-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local iPause = 0;

local DoPulse, OnDataChange;

local fScreenX, fScreenY = guiGetScreenSize();

function DoPulse()
	local iTick			= getTickCount();
	local fX, fY, fZ	= getWorldFromScreenPosition( fScreenX / 2, fScreenY / 2, 20.0 );
	
	setElementData( localPlayer, "Headmove:LookAt", { fX, fY, fZ, 999999999 } );
	
	if iPause > 0 then
		if iTick - iPause > 0 then
			setElementData( localPlayer, "Headmove:Pause", false );
		end
	end
	
	for i, pPlayer in ipairs( getElementsByType( "player", root, true ) ) do
		if isPedInVehicle( pPlayer ) or getPedControlState( pPlayer, "aim_weapon" ) then
			setPedLookAt( pPlayer, 1, 2, 3, 0 );
		else
			local LookAt = getElementData( pPlayer, "Headmove:LookAt" );
			
			if LookAt and LookAt[ 1 ] and LookAt[ 2 ] and LookAt[ 3 ] then
				setPedAimTarget( pPlayer, LookAt[ 1 ], LookAt[ 2 ], LookAt[ 3 ] );
				setPedLookAt( pPlayer, LookAt[ 1 ], LookAt[ 2 ], LookAt[ 3 ], LookAt[ 4 ] );
			end
		end
	end
end

function OnDataChange( sData )
	if sData == "Headmove:Pause" and source == localPlayer then
		local iValue = getElementData( source, sData );
		
		iPause = iValue and ( getTickCount() + iValue ) or 0;
	end
end

setTimer( DoPulse, 300, 0 );

addEventHandler( "onClientElementDataChange", root, OnDataChange );