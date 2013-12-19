-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0
local fScreenX, fScreenY	= guiGetScreenSize();
local iUnit					= 879.66625976563 / 1000;

local gl_hVehicle			= NULL;
local gl_fDistance			= NULL;
local gl_iLastTick			= 0;
local gl_iUpdateIntervall	= 2000;
local gl_pFont				= DXFont( 'segoeui', 14, true );
local gl_iColor1			= 0xff000000;
local gl_iColor2			= -1;

local function DrawMeter()
	if gl_fDistance then
		if getPedOccupiedVehicle( localPlayer ) == gl_hVehicle then
			local fX, fY	= getElementVelocity( gl_hVehicle );
			
			gl_fDistance	= gl_fDistance + ( ( fX ^ 2 + fY ^ 2 ) ^ .5 * iUnit );
			
			local sText 	= ( "Пройденая дистанция: %.1f метров" ):format( gl_fDistance );
			
			if getVehicleOccupant( gl_hVehicle ) == localPlayer then
				sText 			= sText .. " - Backspace что бы выключить";
				
				local iTick 	= getTickCount();
				
				if iTick - gl_iLastTick > gl_iUpdateIntervall then
					SERVER.TJobTaxi_Update( gl_fDistance );
					
					gl_iLastTick 		= iTick;
				end
			end
			
			dxDrawText( sText, 0, fScreenY - 40, fScreenX, fScreenY, gl_iColor1, 1.0, gl_pFont, "center", "bottom" );
			dxDrawText( sText, 0, fScreenY - 50, fScreenX, fScreenY, gl_iColor2, 1.0, gl_pFont, "center", "bottom" );
			
			return;
		end
	end
	
	gl_fDistance	= NULL;
	removeEventHandler( "onClientRender", root, DrawMeter );
end

function TJobTaxi_SetMeter( fDistance, hVehicle )
	if not gl_fDistance then
		gl_hVehicle			= hVehicle;
		gl_fDistance 		= fDistance;
		
		addEventHandler		( "onClientRender", root, DrawMeter );
	end
	
	gl_fDistance = fDistance;
end