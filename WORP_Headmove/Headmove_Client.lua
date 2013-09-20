-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local DoPulse;

local fScreenX, fScreenY = guiGetScreenSize();

function DoPulse()
	local fX, fY, fZ = getWorldFromScreenPosition ( fScreenX / 2, fScreenY / 2, 20.0 );
	
	setElementData( localPlayer, "Headmove:LookAt", { fX, fY, fZ } );
	
	for i, pPlayer in ipairs( getElementsByType( "player", root, true ) ) do
		if isPedInVehicle( pPlayer ) or getPedControlState( pPlayer, "aim_weapon" ) then
			setPedLookAt( pPlayer, 1, 2, 3, 0 );
		else
			local LookAt = getElementData( pPlayer, "Headmove:LookAt" );
			
			if LookAt and LookAt[ 1 ] and LookAt[ 2 ] and LookAt[ 3 ] then
				setPedAimTarget( pPlayer, LookAt[ 1 ], LookAt[ 2 ], LookAt[ 3 ] );
				setPedLookAt( pPlayer, LookAt[ 1 ], LookAt[ 2 ], LookAt[ 3 ],  999999999 );
			end
		end
	end
end

setTimer( DoPulse, 300, 0 );