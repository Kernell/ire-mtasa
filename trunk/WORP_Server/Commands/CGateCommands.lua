-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CGateCommands"

function CGateCommands:Reload( pPlayer )
	local pGateManager = g_pGame:GetGateManager();
	
	pGateManager:DeleteAll();
	pGateManager:Init();
	
	return true;
end

function CGateCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end