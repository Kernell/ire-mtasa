-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CTeleportCommands";

function CTeleportCommands:Create( pPlayer, sCmd, sOption )
	if pPlayer.m_pTeleport then
		local vecPosition	= pPlayer:GetPosition();
		local fRotation		= pPlayer:GetRotation();
		local iInterior		= pPlayer:GetInterior();
		local iDimension	= pPlayer:GetDimension();
		
		local pTeleport		= g_pGame:GetTeleportManager():Create( vecPosition, fRotation, iInterior, iDimension, pPlayer.m_pTeleport.vecPosition, pPlayer.m_pTeleport.fRotation, pPlayer.m_pTeleport.iInterior, pPlayer.m_pTeleport.iDimension );
		
		if pTeleport then
			return TEXT_TELEPORTS_CREATE_SUCCESS:format( pTeleport:GetID() ), 0, 255, 0;
		end
		
		return TEXT_DB_ERROR, 255, 0, 0;
	end
	
	return 'Не задана вторая точка, используйте /' + sCmd + ' setmark', 255, 0, 0;
end

function CTeleportCommands:Delete( pPlayer, sCmd, sOption, sID )
	local iID = tonumber( sID );
	
	if iID then
		local pTeleport = g_pGame:GetTeleportManager():Get( iID );
		
		if pTeleport then
			if g_pDB:Query( "UPDATE " + DBPREFIX + "teleports SET deleted = NOW() WHERE id = %q", iID ) then
				delete ( pTeleport );
				
				return TEXT_TELEPORTS_REMOVE_SUCCESS:format( iID ), 0, 255, 0;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return TEXT_TELEPORTS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CTeleportCommands:DrawLabels( pPlayer )
	pPlayer:SetData( "CTeleport::DrawLabels", not pPlayer:GetData( "CTeleport::DrawLabels" ) );
	
	return true;
end

function CTeleportCommands:SetFaction( pPlayer, sCmd, sOption, sID, sFactionID )
	local iID			= tonumber( sID );
	local iFactionID	= tonumber( sFactionID );
	
	if iID and iFactionID then
		local pTeleport = g_pGame:GetTeleportManager():Get( iID );
		
		if pTeleport then
			local pFaction = g_pGame:GetFactionManager():Get( iFactionID );
			
			if pFaction then			
				if g_pDB:Query( "UPDATE " + DBPREFIX + "teleports SET faction_id = %d WHERE id = %q", pFaction:GetID(), iID ) then
					pTeleport.m_pFaction = pFaction;
					
					return TEXT_TELEPORTS_FACTION_CHANGED:format( iID, pFaction:GetName(), pFaction:GetID() ), 0, 255, 0;
				end
				
				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end

			return TEXT_FACTIONS_INVALID_ID, 255, 0, 0;
		end
		
		return TEXT_TELEPORTS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CTeleportCommands:SetMark( pPlayer )
	local vecPosition	= pPlayer:GetPosition();
	
	pPlayer.m_pTeleport =
	{
		vecPosition 	= vecPosition;
		fRotation 		= pPlayer:GetRotation();
		iInterior		= pPlayer:GetInterior();
		iDimension		= pPlayer:GetDimension();
	};
	
	return "Позиция сохранена", 0, 222, 0;
end

function CTeleportCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end