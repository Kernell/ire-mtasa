-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CMapCommands"

function CMapCommands:Add( pPlayer, sCmd, sOption, sName, fOffsetX, fOffsetY, fOffsetZ )
	local sName = sName:lower();
	
	if sName:len() > 0 then
		local pMapManager = g_pGame:GetMapManager();
		
		if pMapManager:Get( sName ) then
			return TEXT_MAPS_MAP_ALREADY_ADDED:format( sName ), 255, 0, 0;
		end
		
		local Objects, iUnsupported, RemoveObjects = pMapManager:ParseXML( sName );
		
		if not Objects then
			return TEXT_MAPS_INVALID_NAME:format( sName ), 255, 0, 0;
		end
		
		if table.getn( Objects ) == 0 then
			return TEXT_MAPS_MAP_HAS_NO_OBJECTS:format( sName ), 255, 128, 0;
		end
		
		local sMapID = g_pDB:Insert( DBPREFIX + "maps", { name = sName } );
		
		if not sMapID then
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		local pMap = CMap( sName, sMapID );
		
		if pMap:IsValid() then
			local iLoaded = 0;
			
			for _, value in ipairs( Objects ) do
				if value.x and value.y and value.z then
					value.alpha			= Clamp( 0, tonumber( value.alpha ) or 255, 255 );
					value.interior		= Clamp( 0, (int)(value.interior), 255 );
					
					value.doublesided	= (bool)(value.doublesided);
					value.frozen		= (bool)(value.frozen);
					value.collisions	= value.collisions == NULL or value.collisions == true;
					
					local fX	= value.x + (float)(fOffsetX);
					local fY	= value.y + (float)(fOffsetY);
					local fZ	= value.z + (float)(fOffsetZ);
				
					local pObject = CObject.Create( value.model, Vector3( fX, fY, fZ ), Vector3( value.rx, value.ry, value.rz ) );
					
					if pObject then
						if g_pDB:Insert( DBPREFIX + "map_objects",
							{
								map_id		= sMapID;
								model		= value.model;
								x			= fX;
								y			= fY;
								z			= fZ;
								rx			= value.rx, 
								ry			= value.ry;
								rz			= value.rz;
								interior	= value.interior;
								alpha		= value.alpha;
								scale		= value.scale;
								doublesided	= ( value.doublesided and "Yes" or "No" );
								collisions	= value.collisions and "Yes" or "No";
								frozen		= value.frozen and "Yes" or "No";
							}
						) then
							pMap:AddObject( pObject, value.interior, value.alpha, value.scale, value.doublesided, value.frozen, value.collisions );
							
							iLoaded = iLoaded + 1
						else
							Debug( g_pDB:Error(), 1 );
						end
					end
				end
			end
			
			for i, pData in ipairs( RemoveObjects ) do
				local iInsertID	= g_pDB:Insert( DBPREFIX + "map_remove_objects",
					{
						map_id			= sMapID;
						model			= pData.m_iModel;
						lod_model		= pData.m_iLodModel;
						position		= (string)(pData.m_vecPosition);
						interior		= pData.m_iInterior;
						radius			= pData.m_fRadius;
					}
				);
				
				if iInsertID then
					pMap:RemoveWorldObject( pData.m_iModel, pData.m_iLodModel, pData.m_vecPosition, pData.m_iInterior, pData.m_fRadius );
				else
					Debug( g_pDB:Error(), 1 );
				end
			end
			
			if iLoaded > 0 then
				return TEXT_MAPS_ADD_SUCESS:format( sName, iLoaded, table.getn( Objects ), iUnsupported ), 0, 255, 155;
			else
				pMap:Remove();
				
				return TEXT_MAPS_UNABLE_LOAD_OBJECTS:format( sName ), 255, 0, 0;
			end
		else
			g_pDB:Query( "DELETE FROM " + DBPREFIX + "maps WHERE map_id = " + sMapID );
			
			return TEXT_MAPS_ADD_FAILED:format( sName ), 255, 0, 0;
		end
		
		return true;
	end	
	
	return false;
end

function CMapCommands:Remove( pPlayer, sCmd, sOption, ... )
	local sName = table.concat( { ... }, " " ):lower();
	
	if sName:len() > 0 then
		local pMap = g_pGame:GetMapManager():Get( sName );
		
		if pMap then
			if not pMap.m_bProtected then
				if pMap:Remove() then
					return TEXT_MAPS_REMOVE_SUCCESS:format( sName ), 0, 255, 155;
				end
				
				return TEXT_MAPS_REMOVE_FAILED:format( sName ), 255, 0, 0;
			end
			
			return TEXT_MAPS_IS_PROTECTED:format( sName ), 255, 0, 0;
		end

		return TEXT_MAPS_INVALID_NAME:format( sName ), 255, 0, 0;
	end
	
	return false;
end

function CMapCommands:SetDimension( pPlayer, sCmd, sOption, ... )
	local Args = { ... };
	
	if table.getn( Args ) >= 2 then
		local iDimension = tonumber( Args[ table.getn( Args ) ] );
		
		table.remove( Args );
		
		local sName = table.concat( Args, ' ' ):lower();
		
		if sName:len() > 0 and iDimension then
			local pMap = g_pGame:GetMapManager():Get( sName );
			
			if pMap then
				if not pMap.m_bProtected then				
					if pMap:SetDimension( iDimension ) then						
						return TEXT_MAPS_DIMENSION_CHANGED:format( sName, iDimension ), 0, 255, 155;
					end
					
					return TEXT_DB_ERROR, 255, 0, 0;
				end
				
				return TEXT_MAPS_IS_PROTECTED:format( sName ), 255, 0, 0;
			end
			
			return TEXT_MAPS_INVALID_NAME:format( sName ), 255, 0, 0;
		end
	end
	
	return false;
end