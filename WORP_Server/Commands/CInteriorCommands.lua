-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CInteriorCommands";

function CInteriorCommands:Create( pPlayer, sCmd, sOption, sInteriorID, sType, iPrice, ... )
	local iPrice		= tonumber( iPrice );
	
	local sName	= table.concat( { ... }, " " );
	
	if sInteriorID and sType and sName:len() > 0 and iPrice then
		local pInteriorManager = g_pGame:GetInteriorManager();
		
		if pInteriorManager:IsValid( sInteriorID ) then
			if eInteriorType[ sType ] then
				local vecPosition	= pPlayer:GetPosition();
				local fRotation		= pPlayer:GetRotation();
				
				local pInterior = pInteriorManager:Create( sInteriorID, iCharacterID, sName, sType, iPrice, bLocked, iFactionID, vecPosition, fRotation );
				
				if pInterior then
					return sCmd and TEXT_INTERIORS_CREATION_SUCCESS:format( pInterior:GetName(), pInterior:GetID() ), 0, 255, 0;
				end
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return TEXT_INTERIORS_INVALID_TYPE, 255, 0, 0;
		end
		
		return TEXT_INTERIORS_INVALID_INTERIOR, 255, 0, 0;
	end
	
	return false;
end

function CInteriorCommands:Remove( pPlayer, sCmd, sOption, sID )
	local iID = tonumber( sID );
	
	if iID then
		local pInterior = g_pGame:GetInteriorManager():Get( iID );
		
		if pInterior then
			if g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET deleted = 'Yes' WHERE id = " + pInterior:GetID() ) then
				local sName = pInterior:GetName();
				
				delete ( pInterior );
				
				g_pServer:Print( pPlayer:GetUserName() + " removed interior ID: " + iID );
				
				return sCmd and TEXT_INTERIORS_REMOVE_SUCCESS:format( sName, iID ) or true, 64, 240, 0;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return TEXT_INTERIORS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CInteriorCommands:SetType( pPlayer, sCmd, sOption, sID, sNewType )
	local iID 	= tonumber( sID );
	
	if iID and sNewType then
		local pInterior = g_pGame:GetInteriorManager():Get( iID );
		
		if pInterior then
			if eInteriorType[ sNewType ] then
				if pInterior:SetType( sNewType ) then
					pInterior:UpdateMarker();
					pInterior:Update3DText();
					pInterior:UpdateBlip();
					
					return sCmd and TEXT_INTERIORS_TYPE_CHANGED:format( pInterior:GetName(), pInterior:GetID(), sNewType ) or true, 0, 255, 0;
				end
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end

			return TEXT_INTERIORS_INVALID_TYPE, 255, 0, 0;
		end
		
		return TEXT_INTERIORS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CInteriorCommands:SetName( pPlayer, sCmd, sOption, sID, ... )
	local iID 		= tonumber( sID );
	local sName 	= table.concat( { ... }, ' ' );
	
	if iID and sName:len() > 0 then
		local pInterior = g_pGame:GetInteriorManager():Get( iID );
		
		if pInterior then
			local sOldName = pInterior:GetName();
			
			if pInterior:SetName( sName ) then
				pInterior:UpdateMarker();
				pInterior:Update3DText();
				pInterior:UpdateBlip();
				
				return sCmd and TEXT_INTERIORS_NAME_CHANGED:format( sOldName, pInterior:GetID(), pInterior:GetName() ) or true, 0, 255, 0;
			end
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return TEXT_INTERIORS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CInteriorCommands:SetPrice( pPlayer, sCmd, sOption, sID, sPrice )
	local iID		= tonumber( sID );
	local iPrice	= tonumber( sPrice );
	
	if iID and iPrice then
		local pInterior = g_pGame:GetInteriorManager():Get( iID );
		
		if pInterior then
			if pInterior:SetPrice( iPrice ) then
				pInterior:UpdateMarker();
				pInterior:Update3DText();
				pInterior:UpdateBlip();
				
				return sCmd and TEXT_INTERIORS_PRICE_CHANGED:format( pInterior:GetName(), pInterior:GetID(), iPrice ) or true, 0, 255, 0;
			end
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return TEXT_INTERIORS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CInteriorCommands:SetFaction( pPlayer, sCmd, sOption, sID, sFactionID )
	local iID			= tonumber( sID );
	local iFactionID	= tonumber( sFactionID );
	
	if iID and iFactionID then
		local pInterior = g_pGame:GetInteriorManager():Get( iID );
		
		if pInterior then
			local pFaction = g_pGame:GetFactionManager():Get( iFactionID );
			
			if pFaction then
				if pInterior:SetFaction( pFaction:GetID() ) then
					return sCmd and TEXT_INTERIORS_FACTION_CHANGED:format( pInterior:GetName(), pInterior:GetID(), pFaction:GetName() ) or true, 0, 255, 0;
				end
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return TEXT_FACTIONS_INVALID_ID, 255, 0, 0;
		end
		
		return TEXT_INTERIORS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CInteriorCommands:SetLocked( pPlayer, sCmd, sOption, sID, sLocked )
	local iID		= tonumber( sID );
	local bLocked	= (bool)(sLocked);
	
	if iID then
		local pInterior = g_pGame:GetInteriorManager():Get( iID );
		
		if pInterior then
			if pInterior:SetLocked( bLocked ) then
				return sCmd and TEXT_INTERIORS_LOCKED_CHANGED:format( pInterior:GetName(), pInterior:GetID(), ( bLocked and 'закрыт' or 'открыт' ) ) or true, 0, 255, 0;
			end
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return TEXT_INTERIORS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CInteriorCommands:SetOwner( pPlayer, sCmd, sOption, sID, sPlayerName, sPlayerSurname )
	local iID		= tonumber( sID );
	
	if iID then
		local pInterior = g_pGame:GetInteriorManager():Get( iID );
		
		if pInterior then
			if not sPlayerName then
				if pInterior:SetOwner( NULL ) then
					pInterior:UpdateMarker();
					pInterior:Update3DText();
					pInterior:UpdateBlip();
					
					return sCmd and TEXT_INTERIORS_OWNER_CHANGED:format( pInterior:GetName(), pInterior:GetID(), "N\A" ) or true, 0, 255, 0;
				end
				
				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			local pPlayer = g_pGame:GetPlayerManager():Get( sPlayerName + ' ' + sPlayerSurname );
			
			if pPlayer then
				if pPlayer:IsInGame() then
					if pInterior:SetOwner( pPlayer:GetChar() ) then
						pInterior:UpdateMarker();
						pInterior:Update3DText();
						pInterior:UpdateBlip();
						
						return sCmd and TEXT_INTERIORS_OWNER_CHANGED:format( pInterior:GetName(), pInterior:GetID(), pPlayer:GetName() ) or true, 0, 255, 0;
					end
					
					return TEXT_DB_ERROR, 255, 0, 0;
				end
				
				return TEXT_PLAYER_NOT_IN_GAME, 255, 0, 0;
			elseif sPlayerName:len() > 1 and sPlayerSurname:len() > 1 then
				if not not sPlayerName:find( "[^A-Za-z ]" ) then
					return "Неправильное имя персонажа", 255, 0, 0;
				end
				
				if not not sPlayerSurname:find( "[^A-Za-z ]" ) then
					return "Неправильная фамилия персонажа", 255, 0, 0;
				end
				
				local pResult = g_pDB:Query( "SELECT id FROM " + DBPREFIX + "characters WHERE name = %q AND surname = %q", sPlayerName, sPlayerSurname );
				
				if pResult then
					local row = pResult:FetchRow();
					
					delete ( pResult );
					
					if row and row.id then
						if g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET character_id = %q WHERE id = %d", row.id, pInterior:GetID() ) then
							pInterior.m_iCharacterID = row.id;
							
							pInterior:UpdateMarker();
							pInterior:Update3DText();
							pInterior:UpdateBlip();
							
							return sCmd and TEXT_INTERIORS_OWNER_CHANGED:format( pInterior:GetName(), pInterior:GetID(), sPlayerName + ' ' + sPlayerSurname ) or true, 0, 255, 0;
						end
						
						Debug( g_pDB:Error(), 1 );
						
						return TEXT_DB_ERROR, 255, 0, 0;
					end
					
					return ( "Персонаж с именем '" + (string)(sPlayerName) + " " + (string)(sPlayerSurname) + "' не найден в базе данных" ), 255, 0, 0;
				end
				
				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return true;
		end
		
		return TEXT_INTERIORS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CInteriorCommands:SetDropoff( pPlayer, sCmd, sOption, sID )
	local iID		= tonumber( sID );
	
	if iID then
		local pInterior = g_pGame:GetInteriorManager():Get( iID );
		
		if pInterior then
			local pos = self:GetPosition();
			
			if g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET dropoff_x = %f, dropoff_y = %f, dropoff_z = %f WHERE id = " + pInterior:GetID(), pos.X, pos.Y, pos.Z ) then
				return TEXT_INTERIORS_DROPOFF_CHANGED:format( pInterior:GetName(), pInterior:GetID(), pos.X, pos.Y, pos.Z ), 0, 255, 0;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return TEXT_INTERIORS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CInteriorCommands:Set( pPlayer, sCmd, sOption, sID, sInteriorID )
	local iID = tonumber( sID );
	
	if iID then
		local pInterior = g_pGame:GetInteriorManager():Get( iID );
		
		if pInterior then
			local InteriorData = g_pGame:GetInteriorManager():GetInterior( sInteriorID );
			
			if InteriorData then
				if g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET interior_id = '" + sInteriorID + "' WHERE id = " + pInterior:GetID() ) then
					pInterior.m_sInteriorID = sInteriorID;
					
					pInterior:UpdateMarker();
					
					pPlayer:SetDimension( pInterior:GetID() );
					pPlayer:SetInterior( InteriorData.Interior );
					pPlayer:SetPosition( InteriorData.Position:Offset( 1.0, InteriorData.Rotation ) );
					pPlayer:SetRotation( InteriorData.Rotation );
					
					return TEXT_INTERIORS_INT_CHANGED:format( pInterior:GetName(), pInterior:GetID(), sInteriorID ), 0, 255, 0;
				end

				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return TEXT_INTERIORS_INVALID_INTERIOR, 255, 0, 0;
		end
		
		return TEXT_INTERIORS_YOU_ARE_NOT_IN_INTERIOR, 255, 0, 0;
	end
	
	return false;
end

function CInteriorCommands:GeneratePrices( pPlayer )
	local iCount, iTick = 0, getTickCount();
	
	for iID, pInterior in pairs( g_pGame:GetInteriorManager():GetAll() ) do
		if pInterior:GetType() == 'house' then
			if INTERIORS_LIST[ pInterior.m_sInteriorID ] then
				pInterior:SetPrice( INTERIORS_LIST[ pInterior.m_sInteriorID ][ 'price' ] );
				pInterior:UpdateMarker();
				pInterior:Update3DText();
				pInterior:UpdateBlip();
				
				iCount = iCount + 1;
			end
		end
	end
	
	pPlayer:GetChat():Send( "All prices generated for " + iCount + " houses (" + ( getTickCount() - iTick ) + " ms.)", 0, 255, 0 );
	
	return true;
end

function CInteriorCommands:View( pPlayer, sCmd, sOption, sID )
	if sID then
		local InteriorData = g_pGame:GetInteriorManager():GetInterior( sID );
		
		if InteriorData then
			pPlayer:SetDimension( 0 );
			pPlayer:SetInterior( InteriorData.Interior );
			pPlayer:SetPosition( InteriorData.Position );
			pPlayer:SetRotation( InteriorData.Rotation );
			
			return true;
		end
		
		return TEXT_INTERIORS_INVALID_INTERIOR, 255, 0, 0;
	end
	
	return false;
end

function CInteriorCommands:Enter( pPlayer, sCmd, sOption, sID )
	if sID then
		local pInterior = g_pGame:GetInteriorManager():Get( (int)(sID) );
		
		if pInterior then
			pInterior.m_pOutsideMarker:Use( pPlayer, true );
			
			return true;
		end
		
		return TEXT_INTERIORS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CInteriorCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end