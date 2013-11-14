-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CBankManager ( CManager );

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
			{ Field = "expiry",			Type = "timestamp",				Null = "YES",	Key = "", 		Default = NULL		};
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

function CBankManager:CreateAccount( sCurrencyID, sType, pOwner, sExpiryDate, iFactionID )
	local pDate			= CDateTime();
	local sTimestamp	= (string)(pDate.m_pTime.sse);
	
	local sBankAccountID	= ( "%04s %04s %04s %04s" ):format(
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
			expiry		= sExpiryDate;
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
	
	if Fields[ "expiry" ] then
		table.insert( aFields, "DATE_FORMAT( ba.expiry, '%d-%m-%Y' ) AS expiry" );
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
