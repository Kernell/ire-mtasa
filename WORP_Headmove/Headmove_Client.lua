-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local Players	= {};

local DoPulse, OnDataChange;

local fScreenX, fScreenY = guiGetScreenSize();

function DoPulse()
	local iTick			= getTickCount();
	local fX, fY, fZ	= getWorldFromScreenPosition( fScreenX / 2, fScreenY / 2, 20.0 );
	
	setElementData( localPlayer, "Headmove:LookAt", { fX, fY, fZ } );
	
	for i, pPlayer in ipairs( getElementsByType( "player", root, true ) ) do
		local iPause = Players[ pPlayer ] and Players[ pPlayer ].Pause or 0;
		
		if iTick - iPause <= 0 or isPedInVehicle( pPlayer ) or getPedControlState( pPlayer, "aim_weapon" ) then
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

function OnDataChange( sData )
	if sData == "Headmove:Pause" then
		if not Players[ source ] then
			Players[ source ] = {};
		end
		
		Players[ source ].Pause = getTickCount() + getElementData( source, sData );
	end
end

setTimer( DoPulse, 300, 0 );

addEventHandler( "onClientElementDataChange", root, OnDataChange );