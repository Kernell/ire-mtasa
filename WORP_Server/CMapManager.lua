-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CMapManager ( CManager )
{
	__instance	= createElement( "CMap", "CMap" );
};

function CMapManager:CMapManager()
	self:CManager();
	self.CManager = NULL;
	
	if not g_pDB:Ping() then return; end
	
	g_pDB:CreateTable( DBPREFIX + "map_objects",
		{
			{ Field = "id",				Type = "int(10) unsigned",	Null = "NO",	Key = "PRI", 	Default = NULL,	Extra = "auto_increment" };
			{ Field = "map_id",			Type = "int(11)",			Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "model",			Type = "int(11)",			Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "x",				Type = "float",				Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "y",				Type = "float",				Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "z",				Type = "float",				Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "rx",				Type = "float",				Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "ry",				Type = "float",				Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "rz",				Type = "float",				Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "interior",		Type = "smallint(3)",		Null = "NO",	Key = "", 		Default = 0 	};
			{ Field = "alpha",			Type = "smallint(3)",		Null = "NO",	Key = "", 		Default = 255 	};
			{ Field = "scale",			Type = "float",				Null = "NO",	Key = "", 		Default = 1.0 	};
			{ Field = "doublesided",	Type = "enum('Yes','No')",	Null = "NO",	Key = "", 		Default = "No" 	};
			{ Field = "frozen",			Type = "enum('Yes','No')",	Null = "NO",	Key = "", 		Default = "No" 	};
			{ Field = "collisions",		Type = "enum('Yes','No')",	Null = "NO",	Key = "", 		Default = "Yes"	};
		}
	);
	
	g_pDB:CreateTable( DBPREFIX + "map_remove_objects",
		{
			{ Field = "id",				Type = "int(10) unsigned",	Null = "NO",	Key = "PRI", 	Default = NULL,	Extra = "auto_increment" };
			{ Field = "map_id",			Type = "int(11)",			Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "model",			Type = "int(11)",			Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "lod_model",		Type = "int(11)",			Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "position",		Type = "varchar(128)",		Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "interior",		Type = "smallint(8)",		Null = "NO",	Key = "", 		Default = NULL 	};
			{ Field = "radius",			Type = "float",				Null = "NO",	Key = "", 		Default = NULL 	};
		}
	);
end

function CMapManager:_CMapManager()
	
end

function CMapManager:Init()
	self.m_List = {};
	
	local iTick			= getTickCount();
	local iMapCount		= 0;
	local iObjectCount	= 0;
	
	local pResult = g_pDB:Query( "SELECT * FROM " + DBPREFIX + "maps ORDER BY id ASC" );
	
	if pResult then
		for _, row in ipairs( pResult:GetArray() ) do
			local pMap = CMap( row.name, row.id, row.dimension, row.protected == "Yes" );
			
			if pMap:IsValid() then
				iMapCount = iMapCount + 1;
				
				local pResult2 = g_pDB:Query( "SELECT * FROM " + DBPREFIX + "map_objects WHERE map_id = " + row.id + " ORDER BY id ASC" );
				
				if pResult2 then
					for _, r in ipairs( pResult2:GetArray() ) do
						local pObject = CObject.Create( r.model, Vector3( r.x, r.y, r.z ), Vector3( r.rx, r.ry, r.rz ) );
						
						if pMap:AddObject( pObject, r.interior, r.alpha, r.scale, r.doublesided == "Yes", r.frozen == "Yes", r.collisions == "Yes" ) then
							iObjectCount = iObjectCount + 1;
						end
					end
					
					delete ( pResult2 );
					
					printf( "Loading map: %-30s [  OK  ]", row.name );
				else
					Debug( g_pDB:Error(), 1 );
					printf( "Loading map: %-30s [FAILED]", row.name );
				end
				
				local pResultRemove	= g_pDB:Query( "SELECT id, model, lod_model, position, interior, radius FROM " + DBPREFIX + "map_remove_objects WHERE map_id = " + row.id + " ORDER BY id ASC" );
				
				if pResultRemove then
					for x, pRow in ipairs( pResultRemove:GetArray() ) do
						pMap:RemoveWorldObject( pRow.model, pRow.lod_model, Vector3( pRow.position ), pRow.interior, pRow.radius );
					end
					
					delete ( pResultRemove );
				else
					Debug( g_pDB:Error(), 1 );
				end
			else
				printf( "Loading map: %-30s [FAILED]", row.name );
			end
		end
		
		delete ( pResult );
	else
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
--	Debug( ( "Loaded %d maps with %d objects (%d ms)." ):format( iMapCount, iObjectCount, getTickCount() - iTick ) );
	
	return true;
end

function CMapManager:AddToList( pMap )
	self.m_List[ pMap.m_sName ] = pMap;
end

function CMapManager:Get( sName )
	return self.m_List[ sName ];
end

function CMapManager:RemoveFromList( pMap )
	self.m_List[ pMap.m_sName ] = NULL;
end

function CMapManager:ParseXML( sName )
	local sName = sName or self;
	
	if sName then
		local pXML = xmlLoadFile( "Resources/Maps/" + sName + ".xml" );
		
		if pXML then
			local Objects, iUnsupported, RemoveObjects = {}, 0, {};
			
			for i, Node in ipairs( xmlNodeGetChildren( pXML ) ) do
				if xmlNodeGetName( Node ) == "object" then
					local collisions = xmlNodeGetAttribute( Node, "collisions" );
					
					table.insert( Objects,
						{
							x			= (float)(xmlNodeGetAttribute( Node, "posX" ));
							y			= (float)(xmlNodeGetAttribute( Node, "posY" ));
							z			= (float)(xmlNodeGetAttribute( Node, "posZ" ));
							rx			= (float)(xmlNodeGetAttribute( Node, "rotX" ));
							ry			= (float)(xmlNodeGetAttribute( Node, "rotY" ));
							rz			= (float)(xmlNodeGetAttribute( Node, "rotZ" ));
							model		= tonumber( xmlNodeGetAttribute( Node, "model" ) );
							interior	= tonumber( xmlNodeGetAttribute( Node, "interior" ) ) or 0;
							alpha		= tonumber( xmlNodeGetAttribute( Node, "alpha" ) ) or 255;
							scale		= tonumber( xmlNodeGetAttribute( Node, "scale" ) ) or 1;
							doublesided	= (bool)(xmlNodeGetAttribute( Node, "doublesided" ));
							frozen		= (bool)(xmlNodeGetAttribute( Node, "frozen" ));
							collisions	= not collisions or collisions == "true";
						}
					);
				elseif xmlNodeGetName( Node ) == "removeWorldObject" then
					local fX			= (float)(xmlNodeGetAttribute( Node, "posX" ));
					local fY			= (float)(xmlNodeGetAttribute( Node, "posY" ));
					local fZ			= (float)(xmlNodeGetAttribute( Node, "posZ" ));
					
					table.insert( RemoveObjects,
						{
							m_vecPosition	= Vector3( fX, fY, fZ );
							m_iModel		= tonumber( xmlNodeGetAttribute( Node, "model" ) );
							m_iLodModel		= tonumber( xmlNodeGetAttribute( Node, "lodModel" ) );
							m_iInterior		= (int)(xmlNodeGetAttribute( Node, "interior" ));
							m_fRadius		= (float)(xmlNodeGetAttribute( Node, "radius" ));
						}
					);
				else
					Debug( "loading map: " + sName + " has unsupported element: " + xmlNodeGetName( Node ), 2 );
					
					iUnsupported = iUnsupported + 1;
				end
			end
			
			xmlUnloadFile( pXML );
			
			return Objects, iUnsupported, RemoveObjects;
		end
	end
	
	return false;
end
