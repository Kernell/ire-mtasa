-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. MySQLManager : Manager
{
	static
	{
		Tables	=
		{
			"uac_users", "$characters", "$vehicles"
		};
	};
	
	MySQLManager	= function()
		this.Manager();
	end;
	
	Init	= function()
		local dbTables = {};
		
		for i, tableName in pairs( MySQLManager.Tables ) do
			local xml = xmlLoadFile( "Resources/DB/" + tableName + ".xml" );
			
			if xml then
				local dbTable = {};
				
				local dbNode = xmlNodeGetChildren( xml );
				
				for x, node in ipairs( xmlNodeGetChildren( dbNode ) ) do
					local nodeName		= xmlNodeGetName( node );
					local attributes	= xmlNodeGetAttributes( node );
					
					local dbAttrs =
					{
						Field	= nodeName;
						Type	= attributes.type;
						Null	= attributes.null or "NO";
						Key		= attributes.key or "";
					};
					
					if attributes.default then
						if attributes.default:lower() == "false" then
							dbAttrs.Default = false;
						elseif attributes.default:lower() == "null" then
							dbAttrs.Default = NULL;
						elseif attributes.default:upper() == "CURRENT_TIMESTAMP" then
							dbAttrs.Default = MySQL.CURRENT_TIMESTAMP;
						else
							dbAttrs.Default = attributes.default;
						end
					end
					
					if attributes.extra then
						dbAttrs.Extra = attributes.extra;
					end
					
					table.insert( dbTable, dbAttrs );
				end
				
				xmlUnloadFile( xml );
				
				dbTables[ tableName:gsub( "$", Server.DB.Prefix ) ] = dbTable; 
			end
		end
		
		for tableName, dbTable in pairs( dbTables ) do
			Server.DB.CreateTable( tableName, dbTable );
		end
		
		return true;
	end;
};
