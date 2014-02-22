-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CFactionManager ( CManager )
{
	m_sTable	= "factions";
	m_sQuery	= "SELECT id, bank_acc_id, owner_id, property_id, class, name, tag, type, flags, DATE_FORMAT( created, '%d-%m-%Y' ) AS created, DATE_FORMAT( registered, '%d-%m-%Y' ) AS registered FROM ";
};

function CFactionManager:CFactionManager()
	self:CManager();
	
	g_pDB:CreateTable( DBPREFIX + self.m_sTable,
		{
			{ Field = "id",				Type = "int(5) unsigned",		Null = "NO",	Key = "PRI", 	Default = NULL,	Extra = "auto_increment" };
			{ Field = "owner_id",		Type = "int(11) unsigned",		Null = "NO",	Key = "",		Default = 0		};
			{ Field = "property_id",	Type = "int(11) unsigned",		Null = "NO",	Key = "",		Default = 0		};
			{ Field = "bank_acc_id",	Type = "varchar(19)",			Null = "NO",	Key = "",		Default = 0		};
			{ Field = "class",			Type = "varchar(64)",			Null = "NO",	Key = "",		Default = "CFaction" };
			{ Field = "name",			Type = "varchar(64)",			Null = "NO",	Key = "",		Default = NULL	};
			{ Field = "tag",			Type = "varchar(8)",			Null = "NO",	Key = "",		Default = NULL	};
			{ Field = "type",			Type = "smallint(2)",			Null = "NO",	Key = "",		Default = 0		};
			{ Field = "flags",			Type = "varchar(64)",			Null = "YES",	Key = "",		Default = NULL	};
			{ Field = "created",		Type = "timestamp",				Null = "NO",	Key = "",		Default = CMySQL.CURRENT_TIMESTAMP };
			{ Field = "registered",		Type = "timestamp",				Null = "YES",	Key = "",		Default = NULL	};
			{ Field = "deleted",		Type = "timestamp",				Null = "YES",	Key = "",		Default = NULL	};
		}
	);
	
	g_pDB:CreateTable( DBPREFIX + "faction_depts",
		{
			{ Field = "faction_id",		Type = "int(5) unsigned",		Null = "NO",	Key = "PRI", 	Default = NULL };
			{ Field = "id",				Type = "smallint(5) unsigned",	Null = "NO",	Key = "PRI", 	Default = NULL };
			{ Field = "name",			Type = "varchar(64)",			Null = "NO",	Key = "", 		Default = NULL };
		}
	);
	
	g_pDB:CreateTable( DBPREFIX + "faction_ranks",
		{
			{ Field = "faction_id",		Type = "int(5) unsigned",		Null = "NO",	Key = "PRI", 	Default = NULL };
			{ Field = "dept_id",		Type = "smallint(5) unsigned",	Null = "NO",	Key = "PRI", 	Default = NULL };
			{ Field = "id",				Type = "smallint(5) unsigned",	Null = "NO",	Key = "PRI", 	Default = NULL };
			{ Field = "name",			Type = "varchar(64)",			Null = "NO",	Key = "", 		Default = NULL };
		}
	);
end

function CFactionManager:_CFactionManager()
	self:DeleteAll();
end

function CFactionManager:Init()
	self.m_List	= {};
	
	g_pNoFaction 	= CFaction();
	
	local pResult = g_pDB:Query( self.m_sQuery + DBPREFIX + self.m_sTable + " WHERE deleted IS NULL ORDER BY id ASC" );
	
	if pResult then
		for _, pRow in ipairs( pResult:GetArray() ) do
			self:Load( pRow );
		end
		
		delete ( pResult );
	else
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
	return true;
end

function CFactionManager:Load( pRow )
	local TFaction = _G[ pRow.class ];
	
	if TFaction and TFaction.m_bIsFaction then
		if eFactionType[ pRow.type ] then
			local pFaction = TFaction( pRow.id, pRow.flags );
			
			pFaction.m_iOwnerID			= pRow.owner_id;
			pFaction.m_iPropertyID		= pRow.property_id;
			pFaction.m_sBankAccountID	= pRow.bank_acc_id;
			pFaction.m_sName			= pRow.name;
			pFaction.m_sTag				= pRow.tag;
			pFaction.m_sCreated			= pRow.created;
			pFaction.m_sRegistered		= pRow.registered;
			pFaction.m_iType			= pRow.type;
			
			local pResult = g_pDB:Query( "SELECT id, name FROM " + DBPREFIX + "faction_depts WHERE faction_id = " + pFaction:GetID() + " ORDER BY id ASC LIMIT 10" );
			
			if pResult then
				for i, pRow in ipairs( pResult:GetArray() ) do
					pFaction.m_Depts[ pRow.id ] =
					{
						ID		= pRow.id;
						Name	= pRow.name;
						Ranks	= {};
					};
				end
				
				delete ( pResult );
			else
				Debug( g_pDB:Error(), 1 );
			end
			
			if table.getn( pFaction.m_Depts ) > 0 then
				local pResult = g_pDB:Query( "SELECT id, dept_id, name FROM " + DBPREFIX + "faction_ranks WHERE faction_id = " + pFaction:GetID() + " ORDER BY dept_id, id ASC" );
				
				if pResult then
					for i, pRow in ipairs( pResult:GetArray() ) do
						if pFaction.m_Depts[ pRow.dept_id ] then
							pFaction.m_Depts[ pRow.dept_id ].Ranks[ pRow.id ] =
							{
								ID		= pRow.id;
								DeptID	= pRow.dept_id;
								Name	= pRow.name
							};
						end
					end
					
					delete ( pResult );
				else
					Debug( g_pDB:Error(), 1 );
				end
			end
			
			return pFaction;
		else
			Debug( "Invalid faction type '" + (string)(pRow.type) + "' on faction id " + pRow.id, 2 );
		end
	else
		Debug( "Invalid faction class '" + (string)(pRow.class) + "' on faction id " + pRow.id, 2 );
	end
	
	return NULL;
end

function CFactionManager:Create( TFaction, sName, sTag, CustomFields )
	local Fields	=
	{
		class		= classname( TFaction );
		name		= sName;
		tag			= sTag;
	};
	
	for Key, Value in pairs( CustomFields ) do
		local Result = NULL;
		
		if Key == "owner_id" then
			Result = (int)(Value);
			
			Result = Result > 0 and Result or NULL;
		elseif Key == "property_id" then
			Result = (int)(Value);
			
			Result = Result > 0 and Result or NULL;
		elseif Key == "bank_acc_id" then
			if g_pGame:GetBankManager():GetInfo( Value ) then
				Result = Value;
			end
		elseif Key == "type" then
			if eFactionType[ Value ] then
				Result = Value;
			end
		elseif Key == "flags" then
			if table.getn( Value ) then
				Result = table.concat( Value, "," );
			end
		elseif Key == "created" then
			Result = (int)(Value);
		elseif Key == "registered" then
			Result = (int)(Value);
		end
		
		if Result then
			Fields[ Key ] = Result;
		end
	end
	
	local iFactionID = g_pDB:Insert( DBPREFIX + "factions", Fields );
	
	if iFactionID then
		local pResult = g_pDB:Query( self.m_sQuery + DBPREFIX + self.m_sTable + " WHERE id = " + iFactionID );
		
		if pResult then
			local pRow = pResult:FetchRow();
			
			delete ( pResult );
			
			if g_pDB:Query( "INSERT INTO " + DBPREFIX + "faction_depts (faction_id, id, name) VALUES (%d, 1, 'Default Dept 1')", iFactionID ) then				
				if g_pDB:Query( "INSERT INTO " + DBPREFIX + "faction_ranks (faction_id, dept_id, id, name) VALUES (%d, 1, 1, 'Default Rank 1')", iFactionID ) then
					return self:Load( pRow );
				end
			end
		end
		
		Debug( g_pDB:Error(), 1 );
		
		if not g_pDB:Query( "DELETE FROM " + DBPREFIX + "factions WHERE id = " + iFactionID ) then
			Debug( g_pDB:Error(), 1 );
		end
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	return NULL;
end

function CFactionManager:Register( pFaction )
	if pFaction.m_sRegistered == NULL then
		if g_pDB:Query( "UPDATE " + DBPREFIX + "factions SET registered = NOW() WHERE id = " + pFaction:GetID() ) then
			pFaction.m_sRegistered = CDateTime():Format( "d-m-Y" );
			
			if pFaction.m_iPropertyID ~= 0 then
				if not g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET faction_id = " + pFaction:GetID() + " WHERE id = " + pFaction.m_iPropertyID ) then
					Debug( g_pDB:Error(), 1 );
				end
			end
			
			return true;
		end
		
		Debug( g_pDB:Error(), 1 );
	end
	
	return false;
end

function CFactionManager:ClientHandle( pClient, sCommand, ... )
	local pChar = pClient:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	if sCommand == NULL then
		local pFaction = pChar:GetFaction();
		
		if pFaction then
			return pFaction:ClientHandle( pClient, ... );
		end
	end
	
	if sCommand == "GetPublicFactions" then
		local sQuery = "SELECT \
				f.id, f.owner_id, f.name, f.tag, f.type, \
				DATE_FORMAT( f.registered, '%d-%m-%Y' ) AS registered, \
				CONCAT( c.name, ' ', c.surname ) AS owner \
			FROM " + DBPREFIX + "factions f \
			LEFT JOIN " + DBPREFIX + "characters c ON f.owner_id = c.id \
			WHERE f.registered IS NOT NULL AND f.deleted IS NULL \
			ORDER BY f.registered";
		
		local pResult = g_pDB:Query( sQuery );
		
		if not pResult then
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR;
		end
		
		local aResult = pResult:GetArray();
		
		delete ( pResult );
		
		return aResult;
	elseif sCommand == "CreationUIData" then
		local aInteriors	= {};
		
		for i, pInt in pairs( g_pGame:GetInteriorManager():GetAll() ) do
			if pInt.m_sType == INTERIOR_TYPE_COMMERCIAL and pInt.m_iCharacterID == pChar:GetID() then
				table.insert( aInteriors, { ID = pInt:GetID(); Name = pInt:GetName(); } );
			end
		end
		
		return aInteriors;
	elseif sCommand == "Create" then
		local sTitle, sAbbr, iInteriorID, iType = unpack( { ... } );
		
		if eFactionTypePrice[ iType ] > 0 and pChar:GetMoney() < eFactionTypePrice[ iType ] then
			return "Недостаточно денег для создания организации";
		end
		
		if eFactionTypePriceGP[ iType ] > 0 and pClient:GetGP() < eFactionTypePriceGP[ iType ] then
			return "Недостаточно GP для создания организации";
		end
		
		if not not sTitle:find( "[\\'\"\;]" ) then
			return "Имя организации содержит запрещённые символы";
		end
		
		if sTitle:len() < 8 then
			return "Имя организации слишком короткое";
		end
		
		if sTitle:len() > 64 then
			return "Имя организации слишком длинное";
		end
		
		if not not sAbbr:find( "[\\'\"\;]" ) then
			return "Аббревиатура организации содержит запрещённые символы";
		end
		
		if sAbbr:len() < 3 then
			return "Аббревиатура организации слишком короткая";
		end
		
		if sAbbr:len() > 8 then
			return "Аббревиатура организации слишком длинная";
		end
		
		local pProperty = g_pGame:GetInteriorManager():Get( iInteriorID );
		
		if not pProperty then
			return "Не верный адрес регистрации (не существует)";
		end
		
		if pProperty.m_sType ~= INTERIOR_TYPE_COMMERCIAL then
			return "Только коммерческую недвижимость можно оформить на предприятие";
		end
		
		if pProperty.m_iCharacterID ~= pChar:GetID() then
			return "Эта недвижимость не принадлежит вам";
		end
		
		if pProperty.m_iFactionID ~= 0 then
			return "Эта недвижимость уже оформлена на другую организацию";
		end
		
		if not eFactionType[ iType ] then
			return "Не правильный тип организации";
		end
		
		local Data	=
		{
			name		= sTitle;
			tag			= sAbbr;
			type		= iType;
			property_id	= iInteriorID;
		};
		
		local pResult	= g_pDB:Query( "SELECT SUM( name = %q ) AS name, SUM( tag = %q ) AS tag FROM " + DBPREFIX + "factions", Data[ "name" ], Data[ "tag" ] );
		
		if pResult then
			local pRow = pResult:FetchRow();
			
			delete ( pResult );
			
			if pRow then
				if pRow.name and pRow.name ~= 0 then
					return "Организация с таким именем уже существует";
				end
				
				if pRow.tag and pRow.tag ~= 0 then
					return "Организация с такой аббревиатурой уже существует";
				end
			end
		else
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR;
		end
		
		pChar:TakeMoney( eFactionTypePrice[ iType ] );
		
		pClient:TakeGP( eFactionTypePriceGP[ iType ] );
		
		Data[ "owner_id" ] = pChar:GetID();
		
		local pFaction = self:Create( CFaction, Data[ "name" ], Data[ "tag" ], Data );
		
		if pFaction then
			self:Register( pFaction );
			
			return true;
		end
		
		return TEXT_DB_ERROR;
	elseif sCommand == "GetData" then
		local sDataName, iFactionID = unpack( { ... } );
		
		local pFaction = self:Get( iFactionID );
		
		if not pFaction then
			return "Invalid faction id"; 
		end
		
		if sDataName == "Info" then
			local Info;
			
			local pResult	= g_pDB:Query( "SELECT CONCAT( name, ' ', surname ) AS owner FROM " + DBPREFIX + "characters WHERE id = " + pFaction.m_iOwnerID + " LIMIT 1" );
			
			local pRow		= pResult:FetchRow();
			
			delete ( pResult );
			
			local pProperty = g_pGame:GetInteriorManager():Get( pFaction.m_iPropertyID );
			
			Info		=
			{
				ID				= pFaction:GetID();
				Owner			= pRow and pRow.owner or "Неизвестно";
				Property		= pProperty and pProperty:GetName() or "Неизвестно";
				PropertyID		= pFaction.m_iPropertyID;
				Name			= pFaction:GetName();
				Abbr			= pFaction:GetTag();
				Type			= eFactionTypeNames[ pFaction.m_iType ];
				CreatedDate		= pFaction.m_sCreated;
				RegisterDate	= pFaction.m_sRegistered;
				BankAccountID	= pFaction.m_sBankAccountID;
			};
			
			return Info;
		elseif sDataName == "Depts" then
			return pFaction.m_Depts;
		elseif sDataName == "Staff" then
			local Staff = {};
			
			if pFaction:TestRight( pChar, eFactionRight.STAFF_LIST ) then
				local pResult = g_pDB:Query( "SELECT c.id, c.name, c.surname, c.faction_dept_id, c.faction_rank_id, DATEDIFF( NOW(), c.last_login ) AS online, c.status, c.phone FROM " + DBPREFIX + "characters c WHERE c.faction_id = " + pFaction:GetID() + " AND c.status != 'Скрыт' ORDER BY online ASC" );
				
				if pResult then
					for i, row in ipairs( pResult:GetArray() ) do
						local Dept	= pFaction.m_Depts[ row.faction_dept_id ];
						
						Staff[ i ]	=
						{
							name			= row.name;
							surname			= row.surname;
							dept			= Dept and Dept.Name or "N/A";
							rank			= Dept and Dept.Ranks[ row.faction_rank_id ] and Dept.Ranks[ row.faction_rank_id ].Name;
							phone			= row.phone;
							online_status	= g_pGame:GetPlayerManager():Get( ( row.name + '_' + row.surname ):gsub( ' ', '_' ) ) and -1 or row.online;
							status			= row.status;
						};
					end
					
					delete ( pResult );
				else
					Debug( g_pDB:Error(), 1 );
				end
			end
			
			return Staff;
		end
		
		return AsyncQuery.FORBIDDEN;
	end
	
	return AsyncQuery.BAD_REQUEST;
end