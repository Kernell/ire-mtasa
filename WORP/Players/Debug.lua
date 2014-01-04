-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local OnDebug;

local aLevels	= { [0] = "", "ERROR:", "WARNING:", "INFO:" };

function OnDebug( sMessage, iLevel, sFileName, iLine )
	if isDebugViewActive() then
		sFileName	= sFileName and ( sFileName + ":" ) or "";
		iLine		= iLine or "";
		
		outputConsole( aLevels[ iLevel ] + sFileName + iLine + ": " + sMessage, CLIENT );
	end
end

addEventHandler( "onClientDebugMessage", root, OnDebug );
addEventHandler( "onServerDebugMessage", root, OnDebug );