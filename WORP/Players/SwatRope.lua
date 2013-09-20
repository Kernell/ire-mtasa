-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

addEvent( 'CreateSWATRope', true );

local function rope_wait( player )
	local x, y, z	= getElementPosition( localPlayer );
	local is_ground	= getDistanceBetweenPoints3D( x, y, z, x, y, getGroundPosition( x, y, z ) ) < 3;
	
	if isPedOnGround( localPlayer ) or is_ground or isElementInWater( localPlayer ) or getElementHealth( localPlayer ) <= 0 then
		SERVER.DetachFromSWATRope( isPedOnGround( localPlayer ) or is_ground );
		
		return;
	end
	
	CTimer( rope_wait, 100, 1 );
end

local function CreateSWATRope( x, y, z, time )
	if source == localPlayer then
		CTimer( rope_wait, 500, 1 );
	end
	
	createSWATRope( x, y, z, time );
end

addEventHandler( 'CreateSWATRope', root, CreateSWATRope );