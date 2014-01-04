-- Author:      	Kernell
-- Version:     	1.0.0

local target	= false;
local data		= false;
local screenWidth, screenHeight = guiGetScreenSize();

local X = screenWidth- 300;
local Y = screenHeight / 2;

local function DrawSpec()
	local text = ( "ID: %d\nName: %s\nUsername: %s\nHealth: %.1f\nArmor: %.1f\nMoney: %d" ):format( getElementData( target, 'player_id' ), 
		getPlayerName( target ), data.username, getElementHealth( target ), getPedArmor( target ), data.money );
	
	dxDrawText( text, X + 1, Y + 1, screenWidth, screenHeight, -16777216, 1.0, ConsolaBold12 );
	dxDrawText( text, X + 1, Y - 1, screenWidth, screenHeight, -16777216, 1.0, ConsolaBold12 );
	dxDrawText( text, X - 1, Y - 1, screenWidth, screenHeight, -16777216, 1.0, ConsolaBold12 );
	dxDrawText( text, X - 1, Y + 1, screenWidth, screenHeight, -16777216, 1.0, ConsolaBold12 );
	dxDrawText( text, X, Y, screenWidth, screenHeight, -1, 1.0, ConsolaBold12 );
end

function SetSpectating( _target, _data )
	data = _data;
	
	if _target then
		if not target then
			addEventHandler( 'onClientRender', root, DrawSpec );
		end
		target = _target;
	else
		if target then
			removeEventHandler( 'onClientRender', root, DrawSpec );
			target = false;
		end
	end
end