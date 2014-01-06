-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local OnStreamIn, OnStreamOut;

function OnStreamIn()
	-- UpdateGhost( source );
	if getElementID( source ) ~= 'CMap' or getElementModel( source ) == 3409 then
		setObjectBreakable( source, false );
	end
end

function OnStreamOut()
	-- UpdateGhost( source, false );
end

addEventHandler( "onClientElementStreamIn", root, OnStreamIn );
addEventHandler( "onClientElementStreamOut", root, OnStreamOut );