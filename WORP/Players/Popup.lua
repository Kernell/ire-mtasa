-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local screenX, screenY = guiGetScreenSize();

local SIZE_X	= 275;
local SIZE_Y	= 120;
local START_X	= screenX - ( SIZE_X + 25 );
local START_Y	= screenY - ( SIZE_Y - 75 );

local mouse_click;
local Popups = {};

local function OnRender()
	local tick = getTickCount();
	local x, y = getCursorPosition();
			
	x, y = ( x or 0 ) * screenX, ( y or 0 ) * screenY;
	
	for i, p in ipairs( Popups ) do
		if p.alpha <= 0 then
			table.remove( Popups, i );
		else
			p.Y	= p.Y + ( ( START_Y - ( SIZE_Y * i ) + 20 ) - p.Y ) * .1;
			
			dxDrawImage( p.X, p.Y, p.sizeX + 25, p.sizeY, "Resources/Images/Aero.png", 0, 0, 0, tocolor( 255, 255, 255, p.alpha ), true );
			
			if x >= ( p.X + p.sizeX ) - 10 and y >= p.Y + 10 and x <= ( p.X + p.sizeX ) + 3 and y <= p.Y + 23 then
				dxDrawImage( ( p.X + p.sizeX ) - 10, p.Y + 10, 13, 13, "Resources/Images/close_icon.png", 0, 0, 0, tocolor( 128, 255, 255, p.alpha ), true );
			else
				dxDrawImage( ( p.X + p.sizeX ) - 10, p.Y + 10, 13, 13, "Resources/Images/close_icon.png", 0, 0, 0, tocolor( 255, 255, 255, p.alpha ), true );
			end
			
			dxDrawImage( p.X + 32, p.Y + ( p.sizeY - 48 ) / 2, 64, 64, p.icon, 0, 0, 0, tocolor( 255, 255, 255, p.alpha ), true );
				
			dxDrawText( p.title, p.X + 31, p.Y + 9, p.X + p.sizeX, p.Y + p.sizeY, tocolor( 32, 32, 32, p.alpha ), 1, DXFont( 'segoeui', 12, true ), "left", "top", true, false, true );
			dxDrawText( p.title, p.X + 31, p.Y + 11, p.X + p.sizeX, p.Y + p.sizeY, tocolor( 32, 32, 32, p.alpha ), 1, DXFont( 'segoeui', 12, true ), "left", "top", true, false, true );
			dxDrawText( p.title, p.X + 33, p.Y + 9, p.X + p.sizeX, p.Y + p.sizeY, tocolor( 32, 32, 32, p.alpha ), 1, DXFont( 'segoeui', 12, true ), "left", "top", true, false, true );
			dxDrawText( p.title, p.X + 33, p.Y + 11, p.X + p.sizeX, p.Y + p.sizeY, tocolor( 32, 32, 32, p.alpha ), 1, DXFont( 'segoeui', 12, true ), "left", "top", true, false, true );
			dxDrawText( p.title, p.X + 32, p.Y + 10, p.X + p.sizeX, p.Y + p.sizeY, tocolor( 255, 255, 255, p.alpha ), 1, DXFont( 'segoeui', 12, true ), "left", "top", true, false, true );
			
			dxDrawText( p.text, p.X + 99, ( p.Y + ( p.sizeY - 48 ) / 2 ) - 1, p.X + p.sizeX, p.Y + p.sizeY, tocolor( 32, 32, 32, p.alpha ), 1, "default", "left", "top", true, true, true );
			dxDrawText( p.text, p.X + 99, ( p.Y + ( p.sizeY - 48 ) / 2 ) + 1, p.X + p.sizeX, p.Y + p.sizeY, tocolor( 32, 32, 32, p.alpha ), 1, "default", "left", "top", true, true, true );
			dxDrawText( p.text, p.X + 101, ( p.Y + ( p.sizeY - 48 ) / 2 ) - 1, p.X + p.sizeX, p.Y + p.sizeY, tocolor( 32, 32, 32, p.alpha ), 1, "default", "left", "top", true, true, true );
			dxDrawText( p.text, p.X + 101, ( p.Y + ( p.sizeY - 48 ) / 2 ) + 1, p.X + p.sizeX, p.Y + p.sizeY, tocolor( 32, 32, 32, p.alpha ), 1, "default", "left", "top", true, true, true );
			dxDrawText( p.text, p.X + 100, p.Y + ( p.sizeY - 48 ) / 2, p.X + p.sizeX, p.Y + p.sizeY, tocolor( 255, 255, 255, p.alpha ), 1, "default", "left", "top", true, true, true );
			
			if p.start then
				p.alpha = ( p.start + 1000 - tick ) * .255;
			end
			
			if mouse_click then
				if x >= ( p.X + p.sizeX ) - 10 and y >= p.Y + 10 and x <= ( p.X + p.sizeX ) + 3 and y <= p.Y + 23 then
					p.start	= tick;
				end
			end
		end
	end
	
	mouse_click = false;
end

local function OnClick( button, state, mouse_x, mouse_y )
	if button == 'left' and state == 'up' then
		mouse_click = true;
	end
end

local icons =
{
	info	= "Resources/Images/Popup/Info.png";
	money	= "Resources/Images/Popup/Money.png";
	mail	= "Resources/Images/Popup/Mail.png";
};


function Popup( icon, title, text )
	assert( icons[ icon ], "invalid icon '" .. tostring( icon ) .. "'" );
	
	playSound( "Resources/Sounds/popup.wav", false );
	
	table.insert( Popups,
		{
			X		= START_X;
			Y		= START_Y;
			sizeX	= SIZE_X;
			sizeY	= SIZE_Y;
			alpha	= 255;
			icon	= icons[ icon ];
			title	= tostring( title );
			text	= tostring( text );
			-- start	= getTickCount();
		}
	);
	
	return true;
end

addCommandHandler( "popup_test", function( cmd, ... ) Popup( ... ) end );

addEventHandler( 'onClientRender', root, OnRender );
addEventHandler( 'onClientClick', root, OnClick );