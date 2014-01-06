-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local text = nil;

local screenWidth, screenHeight = guiGetScreenSize();

local function drawText()
	dxDrawText( text, screenWidth - screenWidth / 4, screenHeight - 51, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 1.0, "pricedown" );
	dxDrawText( text, screenWidth - screenWidth / 4, screenHeight - 53, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 1.0, "pricedown" );
end

function UpdatePrisonTextDraw( secs )
	if text == nil and secs > 0 then
		addEventHandler( 'onClientRender', root, drawText );
	end
	
	text = ( "Осталось сидеть: %i:%02i:%02i" ):format( secs / 3600, ( secs % 3600 ) / 60, secs % 60 );
	
	if secs <= 0 then
		removeEventHandler( 'onClientRender', root, drawText );
		text = nil;
	end
end