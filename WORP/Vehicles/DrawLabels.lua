-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local MAX_DISTANCE = 30;

local vehicles		= {};
local timer			= false;

local function draw()
	for pVeh, data in pairs( vehicles ) do
		if isElement( pVeh ) and isElementOnScreen( pVeh ) then
			local vecPosition 	= pVeh:GetPosition();
			local fDistance		= vecPosition:Distance( localPlayer:GetPosition() );
			
			if fDistance < MAX_DISTANCE then
				local sx, sy = getScreenFromWorldPosition( vecPosition.X, vecPosition.Y, vecPosition.Z );
				
				if sx and sy then
					local text = ( "%.3f\nID:%d\nHealth: %.2f\n%s (%d)\nLast time: %s\nLast driver: %s" ):format( fDistance, pVeh:GetData( 'id' ), pVeh:GetHealth(), unpack( data ) );
					
					dxDrawText( text, sx + 1, sy + 1, sx + 1, sy + 1, tocolor( 0, 0, 0, 255 ), 1.0, 'default-bold', 'center', 'bottom' );
					dxDrawText( text, sx - 1, sy - 1, sx - 1, sy - 1, tocolor( 0, 0, 0, 255 ), 1.0, 'default-bold', 'center', 'bottom' );
					dxDrawText( text, sx + 1, sy - 1, sx + 1, sy - 1, tocolor( 0, 0, 0, 255 ), 1.0, 'default-bold', 'center', 'bottom' );
					dxDrawText( text, sx - 1, sy + 1, sx - 1, sy + 1, tocolor( 0, 0, 0, 255 ), 1.0, 'default-bold', 'center', 'bottom' );
					dxDrawText( text, sx, sy, sx, sy, tocolor( 0, 196, 255, 255 ), 1.0, 'default-bold', 'center', 'bottom' );
				end
			end
		end
	end
end

local function update_data()
	vehicles = {};
	
	for _, pVeh in ipairs( getElementsByType( 'vehicle', getElementByID "CVehicle", true ) ) do
		if pVeh:GetData( 'id' ) then
			local t		= getRealTime( pVeh:GetData( 'last_time' ) );
			
			vehicles[ pVeh ] =
			{
				getVehicleName( pVeh );-- pVeh:GetName();
				pVeh:GetModel();
				( "%02d/%02d/%04d %d:%02d:%02d" ):format( t.monthday, t.month + 1, t.year + 1900, t.hour, t.minute, t.second );
				pVeh:GetData( 'last_driver' ) or 'None';
			};
		end
	end
end

function VehiclesToggleLabels( fDistance )
	MAX_DISTANCE = tonumber( fDistance ) or MAX_DISTANCE;
	
	if timer then
		removeEventHandler( 'onClientRender', root, draw );
		timer:Kill();
		timer = nil;
	else
		update_data();
		timer = CTimer( update_data, 1000, 0 );
		addEventHandler( 'onClientRender', root, draw );
	end
end