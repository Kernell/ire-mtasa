-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

function CInteriorCommands:OpenMenu( pPlayer, sCmd, sOption, sID )
	if not pPlayer:IsAdmin() then
		if not pPlayer:IsInGame() then return true; end
		if pPlayer:IsInVehicle() then return true; end
	end
	
	local iID = tonumber( sID );
	
	if not iID then
		return false;
	end
	
	local pInterior = g_pGame:GetInteriorManager():Get( iID );
	
	if pInterior then
		if pPlayer:IsAdmin() or pInterior:IsElementInside( pPlayer ) then
			pInterior:OpenMenu( pPlayer );
		end
	end
	
	return true;
end
