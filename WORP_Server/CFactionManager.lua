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

