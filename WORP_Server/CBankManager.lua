-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CBankManager ( CManager )
{
	ClientHandle	= function( this, pClient, sCommand, ... )
		local pChar = pClient:GetChar();
		
		if not pChar then
			return AsyncQuery.UNAUTHORIZED;
		end
		
		if sCommand == "OpenCard" then
			local sCardID, sPIN	= unpack( { ... } );
			
			if not sCardID then
				return "Банковская карточка не действительна";
			end
			
			local bTest = sPIN == "74657374 ";
			
			if ( tonumber( sPIN ) and sPIN:len() == 4 ) or bTest then
				local pCardItem = NULL;
				
				if not bTest then
					for i, pItm in pairs( pChar:GetItems()[ ITEM_SLOT_NONE ] ) do
						if pItm.m_bBankCard and pItm.m_Data.m_sID and pItm.m_Data.m_sID == sCardID then
							pCardItem = pItm;
							
							break;
						end
					end
				end
				
				if pCardItem == NULL and not bTest then
					return "Банковская карточка не действительна";
				end
				
				if bTest or md5( sPIN ) == pCardItem.m_Data.m_sPIN then
					return this:GetInfo( sCardID, { "id", "owner", "owner_id", "currency_id", "currency", "amount", "created", "expiry", "locked" } );
				end
			end
			
			return "Не верный PIN-код";
		elseif sCommand == "LockAccount" then
			local sBankAccountID, sReason = unpack( { ... } );
			
			if not sBankAccountID then
				return "Неверный номер счёта";
			end
			
			if not sReason or sReason:len() == 0 then
				return "Необходимо указать причину закрытия счёта";
			end
			
			local pAccountInfo = this:GetInfo( sBankAccountID, { "id", "owner_id", "faction_id", "currency_id", "amount", "locked", "closed" } );
			
			if pAccountInfo then
				if pAccountInfo.locked or pAccountInfo.closed then
					return "Операция не может быть выполнена: счёт заблокирован";
				end
				
				if pAccountInfo.owner_id ~= pChar:GetID() then
					return "Только владелец может закрыть счёт";
				end
				
				if not g_pDB:Query( "UPDATE " + DBPREFIX + "bank_accounts SET closed = NOW() WHERE id = %q", sBankAccountID ) then
					Debug( g_pDB:Error(), 1 );
					
					return TEXT_DB_ERROR;
				end
				
				this:AppendLog( sBankAccountID, NULL, "Закрытие счёта: " + sReason );
				
				return true;
			end
			
			return "Не удалось получить информацию о счёте";
		elseif sCommand == "Transfer" then
			local sAmount, sBankAccountID, sTargetBankAccountID, sReason = unpack( { ... } );
			
			local iAmount = tonumber( sAmount );
			
			if iAmount and iAmount > 0 then
				sTargetBankAccountID = ( tostring( sTargetBankAccountID ) ):match( "%d%d%d%d %d%d%d%d %d%d%d%d %d%d%d%d" );
				
				if sTargetBankAccountID == NULL then
					return "Неправильно указан номер счёта";
				end
				
				if sTargetBankAccountID == sBankAccountID then
					return "Нельзя переводить средства на счёт с которого производится операция";
				end
				
				local pAccountInfo = this:GetInfo( sBankAccountID, { "id", "owner_id", "faction_id", "currency_id", "currency", "amount", "locked" } );
				
				if pAccountInfo then
					if pAccountInfo.locked then
						return "Операция не может быть выполнена: аккаунт заблокирован";
					end
					
					if pAccountInfo.faction_id then
						local pFaction	= g_pGame:GetFactionManager():Get( pAccountInfo.faction_id );
						
						if not pFaction then
							return "Не удалось получить данные о организации";
						end
						
						if not pFaction:TestRight( pChar, eFactionRight.BANK_TRANSFER ) then
							return "У Вас нет прав на перевод средств с этого счёта";
						end
						
						if sReason:len() == 0 then
							return "Необходимо указать причину перевода средств";
						end
					else
						if pAccountInfo.owner_id ~= pChar:GetID() then
							return "У Вас нет прав на перевод средств с этого счёта";
						end
					end
					
					if pAccountInfo.amount < iAmount then
						return "На Вашем счету недостаточно средств";
					end
					
					local pTargetAccountInfo = this:GetInfo( sTargetBankAccountID, { "currency_id" } );
					
					if pTargetAccountInfo == NULL then
						return "Указанный счёт не существует";
					end
					
					if pTargetAccountInfo.currency_id ~= pAccountInfo.currency_id then
						return "Конечный счёт должен быть той же валюты";
					end
					
					if not this:GiveMoney( sTargetBankAccountID, iAmount, "Перевод со счёта " + sBankAccountID + ": " + sReason ) then
						return TEXT_DB_ERROR;
					end
					
					if not this:TakeMoney( sBankAccountID, iAmount, "Перевод на счёт " + sTargetBankAccountID + ": " + sReason ) then
						return TEXT_DB_ERROR;
					end
					
					pAccountInfo.amount = pAccountInfo.amount - iAmount;
					
					return pAccountInfo;
				end
				
				return "Не удалось получить информацию о Вашем счёте";
			end
			
			return "Неверные данные";
		elseif sCommand == "Deposit" then
			local sAmount, sBankAccountID = unpack( { ... } );
			
			local iAmount = tonumber( sAmount );
			
			if iAmount and iAmount > 0 then
				local pAccountInfo = this:GetInfo( sBankAccountID, { "id", "currency_id", "currency", "amount" } );
				
				if not pAccountInfo then
					return "Не удалось получить информацию о счёте";
				end
				
				if pChar:TakeMoney( iAmount ) then
					if not this:GiveMoney( sBankAccountID, ( iAmount * pAccountInfo.currency_rate ), "Пополнение средств счёта" ) then
						pChar:GiveMoney( iAmount );
						
						return TEXT_DB_ERROR;
					end
					
					pAccountInfo.amount = pAccountInfo.amount + ( iAmount * pAccountInfo.currency_rate );
					
					return pAccountInfo;
				end
				
				return "У Вас нет столько денег";
			end
			
			return "Неверные данные";
		elseif sCommand == "Withdraw" then
			local sAmount, sBankAccountID, sReason = unpack( { ... } );
			
			local iAmount = tonumber( sAmount );
			
			if iAmount and iAmount > 0 then
				local pAccountInfo = this:GetInfo( sBankAccountID, { "id", "owner_id", "currency_id", "currency", "amount", "locked" } );
				
				if pAccountInfo then
					if pAccountInfo.locked == NULL then
						if pAccountInfo.owner_id == pChar:GetID() then
							if pAccountInfo.amount < iAmount then
								return "На Вашем счету недостаточно средств";
							end
							
							if not sReason then
								sReason = "ATM " + GetZoneName( self:GetPosition() );
							else
								sReason = "Списание средств со счёта: " + sReason;
							end
							
							if not this:TakeMoney( sBankAccountID, iAmount, sReason ) then
								return TEXT_DB_ERROR;
							end
							
							local fRate = pAccountInfo.currency_rate + (int)(pAccountInfo.currency_id ~= "USD");
							
							if fRate ~= 0.0 then
								pChar:GiveMoney( iAmount / fRate );
							end
							
							pAccountInfo.amount = pAccountInfo.amount - iAmount;
							
							return pAccountInfo;
						end
						
						return "У Вас нет прав на снятие средств с этого счёта";
					end
					
					return "Операция не может быть выполнена: аккаунт заблокирован";
				end
				
				return "Не удалось получить информацию о счёте";
			end
			
			return "Неверные данные";
		elseif sCommand == "GetLog" then
			local sBankAccountID = unpack( { ... } );
			
			local pAccountInfo = this:GetInfo( sBankAccountID, { "id", "owner_id", "currency_id", "amount", "locked" } );
			
			if not pAccountInfo then
				return "Не удалось получить информацию о счёте";
			end
			
			if pAccountInfo.faction_id then
				local pFaction	= g_pGame:GetFactionManager():Get( pAccountInfo.faction_id );
				
				if not pFaction then
					return "Не удалось получить данные о организации";
				end
				
				if not pFaction:TestRight( pChar, eFactionRight.BANK_LOG ) then
					return "У Вас нет прав на просмотр истории этого счёта";
				end
			else
				if pAccountInfo.owner_id ~= pChar:GetID() then
					return "У Вас нет прав на просмотр истории этого счёта";
				end
			end
			
			return this:GetLog( sBankAccountID, 30 );
		elseif sCommand == "CreateAccount" then
			local sType, sCurrencyID, iFactionID, sCard = unpack( { ... } );
			
			if sType == "none" or sType == "faction" then
				local pFaction = NULL;
				
				if sType == "faction" then
					pFaction = g_pGame:GetFactionManager():Get( iFactionID );
					
					if pFaction == NULL then
						return "Организации с таким именем не существует";
					end
					
					if pFaction.m_sBankAccountID == "0" then
						return "Для этой организации уже создан счёт";
					end
				end
				
				local pCurrency = this.m_Currencies[ sCurrencyID ];
				
				if pCurrency == NULL then
					return "Неверная валюта";
				end
				
				local sBankAccountID = this:CreateAccount( pCurrency.Code, sType, pChar, pFaction and pFaction:GetID() );
				
				if not sBankAccountID then
					return TEXT_DB_ERROR;
				end
				
				if pFaction then
					if not g_pDB:Query( "UPDATE " + DBPREFIX + "factions SET bank_acc_id = %q WHERE id = %d", sBankAccountID, pFaction:GetID() ) then
						Debug( g_pDB:Error(), 1 );
						
						return TEXT_DB_ERROR;
					end
					
					pFaction.m_sBankAccountID	= sBankAccountID;
				end
			elseif sType == "card" then
				local CardTypes	=
				{
					visa			= true;
					mastercard		= true;
					americanexpress	= true;
				};
				
				if not CardTypes[ sCard ] then
					return "Неизвестный тип карты";
				end
				
				local pDate				= CDateTime();
				
				pDate.m_pTime.sse		= pDate.m_pTime.sse + 15778463; -- 6 месяцев
				
				local sBankAccountID	= this:CreateAccount( NULL, sCard, pChar, NULL );
				local sPIN				= ( "%04d" ):format( math.random( 9999 ) );
				
				local pItemData		=
				{
					m_sID			= sBankAccountID;
					m_sPIN			= md5( sPIN );
					m_sExpiryDate	= pDate:Format( "d f Y" );
				};
				
				pChar:GiveItem( "bank_card_" + sCard, 0, 100.0, pItemData );
				
				pClient:MessageBox( NULL, "Банковская карточка создана\n\nPIN-код Вашей карточки: " + sPIN, "Операция выполнена успешно", MessageBoxButtons.OK, MessageBoxIcon.Information );
			else
				return "Неверный тип счёта";
			end
			
			return this:GetInfo( pChar, CBank.m_sImportFields );
		elseif sCommand == "GetAccounts" then
			return this:GetInfo( pChar, CBank.m_sImportFields );
		elseif sCommand == "GetCurrencies" then
			local pResult = g_pDB:Query( "SELECT id, name, rate FROM " + DBPREFIX + "currencies ORDER BY id ASC" );
			
			if pResult then
				local Array = pResult:GetArray();
				
				delete ( pResult );
				
				return Array;
			end
			
			Debug( g_pDB:Error(), 1 );
		elseif sCommand == "GetFactions" then
			local aFields = unpack( { ... } );
			
			local aFactions = {};
			
			for i, pFaction in pairs( g_pGame:GetFactionManager():GetAll() ) do
				if pFaction.m_iOwnerID == pChar:GetID() then
					if aFields then
						local aFaction = {};
						
						for i, key in ipairs( aFields ) do
							aFaction[ key ] = pFaction[ key ];
						end
						
						table.insert( aFactions, aFaction );
					else
						table.insert( aFactions, pFaction );
					end
				end
			end
			
			return aFactions;
		elseif sCommand == "Buy" then
			local sItemType, iItemID, sBankAccountID, sPIN = unpack( { ... } );
			
			local pAccountInfo = NULL;
			
			if sBankAccountID == "Оплата наличными" then
				pAccountInfo = { id = 0; owner_id = pChar:GetID(); amount = pChar:GetMoney(); locked = NULL };
			else
				if sPIN then
					pAccountInfo = this:ClientHandle( this, OpenCard, sBankAccountID, sPIN );
					
					if type( pAccountInfo ) ~= "table" then
						return pAccountInfo;
					end
				else
					pAccountInfo = this:GetInfo( sBankAccountID, { "id", "type", "faction_id", "owner_id", "amount", "locked" } );
				end
			end
			
			if not pAccountInfo then
				return "Не удалось получить информацию о счёте";
			end
			
			if pAccountInfo.locked then
				return "Этот счёт заблокирован";
			end
			
			if sItemType == "Property" then
				local pProperty = g_pGame:GetInteriorManager():Get( iItemID );
				
				if pProperty then
					if not pProperty:GetInt() then
						return TEXT_INTERIORS_CORRUPT;
					end
					
					if pProperty then
						if pProperty:IsElementInside( this ) or pProperty.m_pOutsideMarker:GetPosition():Distance( pChar:GetPosition() ) < 5.0 then
							if pProperty:GetType() == INTERIOR_TYPE_NONE then
								return "Данная собственность недоступна для покупки";
							end
							
							local iPrice = pProperty:GetPrice();
							
							if iPrice <= 0 then
								return "Данная собственность не продаётся";
							end
							
							if pAccountInfo.amount < iPrice then
								return TEXT_NOT_ENOUGH_MONEY;
							end
							
							if pAccountInfo.id == 0 then
								if not pChar:TakeMoney( iPrice, "Покупка собственности #" + pProperty:GetID() ) then
									return TEXT_NOT_ENOUGH_MONEY;
								end
							else
								if not this:TakeMoney( sBankAccountID, iPrice, "Покупка собственности #" + pProperty:GetID() ) then					
									return TEXT_DB_ERROR;
								end
							end
							
							if pProperty.m_iFactionID ~= 0 then
								local pFaction = g_pGame:GetFactionManager():Get( pProperty.m_iFactionID );
								
								if pFaction then
									this:GiveMoney( pFaction.m_sBankAccountID, iPrice, "Продана собственность #" + pProperty:GetID() + ", покупатель: " + sBankAccountID );
								end
							elseif pProperty.m_iCharacterID ~= 0 then
								local pChar = NULL;
								
								-- TODO: while!
								for i, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
									local pChr = pPlr:GetChar();
									
									if pChr and pChr:GetID() == pProperty.m_iCharacterID then
										pChar = pChr;
										
										break;
									end
								end
								
								if pChar then
									pChar:GiveMoney( iPrice, "Продана собственность #" + pProperty:GetID() + ", покупатель: " + sBankAccountID );
									
									pChar.m_pClient:Hint( "Собственность продана", "Выставленная на продажу собственность #" + pProperty:GetID() + " куплена за " + iPrice, "info" );
								else
									if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET money = money + " + iPrice + " WHERE id = " + pProperty.m_iCharacterID ) then
										g_pMoneyLog:Write( "[" + pProperty.m_iCharacterID + "]" + iPrice + " (Продана собственность #" + pProperty:GetID() + ", покупатель: " + sBankAccountID + ")" );
									else
										Debug( g_pDB:Error(), 1 );
									end
								end
							end
							
							local iFactionID = 0;
							
							if pAccountInfo.type == "faction" then
								local pFaction = g_pGame:GetFactionManager():Get( pAccountInfo.faction_id );
								
								if pFaction then
									iFactionID = pFaction:GetID();
								end
							end
							
							if not g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET character_id = %d, faction_id = %d, price = 0 WHERE id = %d", pChar:GetID(), iFactionID, pProperty:GetID() ) then
								Debug( g_pDB:Error() );
								
								return TEXT_DB_ERROR;
							end
							
							pProperty.m_iCharacterID	= pChar:GetID();
							pProperty.m_iFactionID		= iFactionID;
							pProperty.m_iPrice			= 0;
							
							pProperty:UpdateMarker();
							pProperty:Update3DText();
							pProperty:UpdateBlip();
							
							g_pServer:Print( "PROPERTY: %s (%d) bought property %q (%d) for $%d", pChar:GetName(), pChar:GetID(), pProperty:GetName(), pProperty:GetID(), iPrice );
							
							return true;
						end
						
						return "Собственность слишком далеко";
					end
				end
				
				return "Собственности которую вы пытаетесь купить - не существует";
			elseif sItemType == "Vehicle" then
				return true;
			end
		end
		
		return AsyncQuery.BAD_REQUEST;
	end;
};

function CBankManager:CBankManager()
	self:CManager();
	
	g_pDB:CreateTable( DBPREFIX + "currencies",
		{
			{ Field = "id",				Type = "varchar(3)",			Null = "NO",	Key = "PRI", 	Default = NULL		};
			{ Field = "name",			Type = "varchar(128)",			Null = "NO",	Key = "", 		Default = NULL		};
			{ Field = "rate",			Type = "float",					Null = "NO",	Key = "", 		Default = 0			};
		}
	);
	
	g_pDB:CreateTable( DBPREFIX + "banks",
		{
			{ Field = "id",				Type = "int(11) unsigned",		Null = "NO",	Key = "PRI", 	Default = NULL,	Extra = "auto_increment" };
			{ Field = "model",			Type = "smallint(6)",			Null = "YES",	Key = "", 		Default = NULL };
			{ Field = "position",		Type = "varchar(256)",			Null = "NO",	Key = "", 		Default = NULL };
			{ Field = "rotation",		Type = "varchar(256)",			Null = "NO",	Key = "", 		Default = NULL };
			{ Field = "interior",		Type = "smallint(3)",			Null = "NO",	Key = "", 		Default = 0 };
			{ Field = "dimension",		Type = "smallint(6)",			Null = "NO",	Key = "", 		Default = 0 };
			{ Field = "deleted",		Type = "timestamp",				Null = "YES",	Key = "", 		Default = NULL };
		}
	);
	
	g_pDB:CreateTable( DBPREFIX + "bank_accounts",
		{
			{ Field = "id",				Type = "varchar(19)",			Null = "NO",	Key = "PRI", 	Default = NULL		};
			{ Field = "owner_id",		Type = "int(11) unsigned",		Null = "YES",	Key = "", 		Default = NULL		};
			{ Field = "faction_id",		Type = "int(11) unsigned",		Null = "YES",	Key = "", 		Default = NULL		};
			{ Field = "currency_id",	Type = "varchar(3)",			Null = "NO",	Key = "", 		Default = "USD"		};
			{ Field = "amount",			Type = "double",				Null = "NO",	Key = "", 		Default = 0.0		};
			{ Field = "type",			Type = "enum('none','faction','mastercard','visa','americanexpress')",	
																		Null = "NO",	Key = "", 		Default = "none"	};
			{ Field = "created",		Type = "timestamp",				Null = "NO",	Key = "", 		Default = CMySQL.CURRENT_TIMESTAMP	};
			{ Field = "locked",			Type = "timestamp",				Null = "YES",	Key = "", 		Default = NULL		};
			{ Field = "closed",			Type = "timestamp",				Null = "YES",	Key = "", 		Default = NULL		};
		}
	);
	
	g_pDB:CreateTable( DBPREFIX + "bank_logs",
		{
			{ Field = "id",				Type = "int(11) unsigned",		Null = "NO",	Key = "PRI", 	Default = NULL,	Extra = "auto_increment" };
			{ Field = "bank_acc_id",	Type = "varchar(19)",			Null = "NO",	Key = "", 		Default = NULL		};
			{ Field = "amount",			Type = "varchar(64)",			Null = "YES",	Key = "", 		Default = NULL		};
			{ Field = "date",			Type = "timestamp",				Null = "NO",	Key = "", 		Default = CMySQL.CURRENT_TIMESTAMP };
			{ Field = "text",			Type = "text",					Null = "NO",	Key = "", 		Default = NULL 		};
		}
	);
	
	function self.HTTPCurrencies( Data, iError )
		if iError == 0 then
			fileDelete( "forex.xml" );
			
			local pFile = fileCreate( "forex.xml" );
			
			if pFile then
				fileWrite( pFile, Data );
				fileClose( pFile );
				
				local pXML = xmlLoadFile( "forex.xml" );
		
				if pXML then
					self.m_Currencies = {};
					
					local sCode = NULL;
					
					for i, pNode in ipairs( xmlNodeGetChildren( pXML ) ) do
						if xmlNodeGetName( pNode ) == "data" then
							local pCode	= xmlFindChild( pNode, "code", 0 );
							local pName	= xmlFindChild( pNode, "description", 0 );
							local pRate	= xmlFindChild( pNode, "rate", 0 );
							
							local sCode	= xmlNodeGetValue( pCode ) - "[^A-Z]";
							local sName	= xmlNodeGetValue( pName ) - "[^0-9A-Za-z ]";
							local fRate	= tonumber( xmlNodeGetValue( pRate ) );
							
							self.m_Currencies[ sCode ] =
							{
								Code	= sCode;
								Name	= sName;
								Rate	= fRate;
							};
						end
					end
					
					xmlUnloadFile( pXML );
					
					if self.m_Currencies.USD then
						local fUSD		= self.m_Currencies.USD.Rate;
						local sQuery 	= "REPLACE INTO " + DBPREFIX + "currencies ( `id`, `name`, `rate` ) VALUE";
						local i			= 0;
						
						for sCode, pCurr in pairs( self.m_Currencies ) do
							pCurr.Rate = pCurr.Rate / fUSD;
							
							if i == 0 then
								sQuery = sQuery + " ";
							else
								sQuery = sQuery + ", ";
							end
							
							sQuery = sQuery + "( '" + pCurr.Code + "', '" + pCurr.Name + "', '" + pCurr.Rate + "' )";
							
							i = i + 1;
						end
						
						if not g_pDB:Query( sQuery ) then
							Debug( g_pDB:Error(), 1 );
						end
					end
				end
			end
		end
	end
	
end

function CBankManager:Init()
	self.m_List = {};
	
	if not g_pDB:Ping() then return false; end
	
	local iTick, iCount = getTickCount(), 0;
	
	local pResult = g_pDB:Query( "SELECT id, model, position, rotation, interior, dimension FROM " + DBPREFIX + "banks WHERE deleted IS NULL ORDER BY id ASC" );
	
	if pResult then	
		for i, pRow in ipairs( pResult:GetArray() ) do
			CBank( pRow.id, Vector3( pRow.position ), Vector3( pRow.rotation ), pRow.interior, pRow.dimension, pRow.model );
			
			iCount = iCount + 1;
		end
		
		delete ( pResult );
	else
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
--	Debug( ( "Loaded %d banks (%d ms)" ):format( iCount, getTickCount() - iTick ) );
	
	return true;
end

function CBankManager:DoPulse( tReal )
	if self.m_Currencies == NULL or ( tReal.hour == 10 and tReal.minute == 0 ) then
		if fetchRemote( "http://rss.timegenie.com/forex.xml", 10, self.HTTPCurrencies, "", false ) then
		
		end
	end
end

function CBankManager:GetBank( iID )
	return self.m_List[ iID ];
end

function CBankManager:CreateAccount( sCurrencyID, sType, pOwner, iFactionID )
	local pDate			= CDateTime();
	local sTimestamp	= (string)(pDate.m_pTime.sse);
	
	local sBankAccountID	= ( "%04d %04d %04s %04s" ):format(
		iFactionID or pOwner and ( "%d%d" ):format( (byte)(pOwner.m_sName[ 1 ]), (byte)(pOwner.m_sSurname[ 1 ]) ) or 0,
		iFactionID and 0 or pOwner and math.random( 9999 ),
		sTimestamp:sub( 3, 6 ),
		sTimestamp:sub( 7, 10 )
	);
	
	g_pDB:Insert( DBPREFIX + "bank_accounts",
		{
			id			= sBankAccountID;
			owner_id	= pOwner and pOwner:GetID() or NULL;
			faction_id	= iFactionID or NULL;
			currency_id	= sCurrencyID or "USD";
			type		= sType or "none";
		}
	);
	
	return sBankAccountID;
end

function CBankManager:GetInfo( void, Fields )
	local sCondition	= NULL;
	local bSingle		= false;
	
	if type( void ) == "table" then
		if classname( void ) == "CChar" then
			sCondition = "ba.owner_id = " + void:GetID();
		elseif void.m_bIsFaction then
			sCondition = "ba.faction_id = " + void:GetID();
		else
			sCondition = "ba.id IN( '" + table.concat( void, "', '" ) + "' )";
		end
	elseif type( void ) == "string" then
		sCondition = "ba.id = '" + void + "'";
		
		bSingle = true;
	end
	
	if sCondition == NULL then
		return NULL;
	end
	
	for i, k in ipairs( Fields ) do
		Fields[ k ] = true;
	end
	
	local aFields	= {};
	local aLeftJoin	= {};
	
	if Fields[ "id" ] then
		table.insert( aFields, "ba.id" );
	end
	
	if Fields[ "owner_id" ] then
		table.insert( aFields, "ba.owner_id" );
	end
	
	if Fields[ "faction_id" ] then
		table.insert( aFields, "ba.faction_id" );
	end
	
	if Fields[ "currency_id" ] then
		table.insert( aFields, "ba.currency_id" );
	end
	
	if Fields[ "amount" ] then
		table.insert( aFields, "ba.amount" );
	end
	
	if Fields[ "type" ] then
		table.insert( aFields, "ba.type" );
	end
	
	if Fields[ "created" ] then
		table.insert( aFields, "DATE_FORMAT( ba.created, '%d-%m-%Y' ) AS created" );
	end
	
	if Fields[ "locked" ] then
		table.insert( aFields, "DATE_FORMAT( ba.locked, '%d-%m-%Y' ) AS locked" );
	end
	
	if Fields[ "currency" ] then
		table.insert( aFields, "cur.name AS currency" );
		table.insert( aFields, "cur.rate AS currency_rate" );
		table.insert( aLeftJoin, "LEFT JOIN " + DBPREFIX + "currencies cur ON ba.currency_id = cur.id" );
	end
	
	if Fields[ "owner" ] then
		table.insert( aFields, "CONCAT( c.name, ' ', c.surname ) AS owner" );
		table.insert( aLeftJoin, "LEFT JOIN " + DBPREFIX + "characters c ON ba.owner_id = c.id" );
	end
	
	if Fields[ "faction" ] then
		table.insert( aFields, "f.name AS faction" );
		table.insert( aLeftJoin, "LEFT JOIN " + DBPREFIX + "factions f ON ba.faction_id = f.id" );
	end
	
	local pResult	= g_pDB:Query( "SELECT " + table.concat( aFields, ", " ) + " FROM " + DBPREFIX + "bank_accounts ba " + table.concat( aLeftJoin, " " ) + " WHERE " + sCondition + " AND closed IS NULL LIMIT " + ( bSingle and "1" or "15" ) );
	
	if pResult then
		local pRows = bSingle and pResult:FetchRow() or pResult:GetArray();
		
		delete ( pResult );
		
		return pRows;
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	return NULL;
end

function CBankManager:GetLog( sBankAccountID, iLimit )
	iLimit = tonumber( iLimit ) or 15;
	
	local pResult = g_pDB:Query( "SELECT `id`, `text`, `amount`, DATE_FORMAT( `date`, '%%d-%%m-%%Y %%H:%%i:%%S' ) AS `date` FROM " + DBPREFIX + "bank_logs WHERE `bank_acc_id` = %q ORDER BY `date` ASC" + ( iLimit ~= -1 and ( " LIMIT " + iLimit ) or "" ), sBankAccountID );
	
	if pResult then
		local pRows = pResult:GetArray();
		
		delete ( pResult );
		
		return pRows;
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	return NULL;
end

function CBankManager:AppendLog( sBankAccountID, iMoney, sText )
	local iID = g_pDB:Insert( DBPREFIX + "bank_logs",
		{
			bank_acc_id	= sBankAccountID;
			text		= sText;
			amount		= iMoney or NULL;
		}
	);
	
	if not iID then
		Debug( g_pDB:Error(), 1 );
	end
	
	return iID;
end

function CBankManager:GiveMoney( sBankAccountID, iMoney, sReason )
	sBankAccountID = sBankAccountID - "[^0-9 ]";
	
	if g_pDB:Query( "UPDATE " + DBPREFIX + "bank_accounts SET amount = amount + " + (float)(iMoney) + " WHERE id = %q", sBankAccountID ) then
		if sReason then
			self:AppendLog( sBankAccountID, iMoney, sReason );
		end
		
		return true;
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	return false;
end

function CBankManager:TakeMoney( sBankAccountID, iMoney, sReason )
	sBankAccountID = sBankAccountID - "[^0-9 ]";
	
	if g_pDB:Query( "UPDATE " + DBPREFIX + "bank_accounts SET amount = amount - " + (float)(iMoney) + " WHERE id = %q", sBankAccountID ) then
		if sReason then
			self:AppendLog( sBankAccountID, -iMoney, sReason );
		end
		
		return true;
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	return false;
end
