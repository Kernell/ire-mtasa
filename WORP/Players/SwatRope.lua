-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

addEvent( 'CreateSWATRope', true );

local function rope_wait( player )
	local x, y, z	= getElementPosition( CLIENT );
	local fDistance	= getDistanceBetweenPoints3D( x, y, z, x, y, getGroundPosition( x, y, z ) );
	local bGround	= isPedOnGround( CLIENT ) or fDistance < 2;
	
	if bGround or getPedContactElement( CLIENT ) or isElementInWater( CLIENT ) or getElementHealth( CLIENT ) <= 0 then
		SERVER.DetachFromSWATRope( bGround );
		
		return;
	end
	
	CTimer( rope_wait, 100, 1 );
end

local function CreateSWATRope( x, y, z, time )
	if source == CLIENT then
		CTimer( rope_wait, 500, 1 );
	end
	
	createSWATRope( x, y, z, time );
end

addEventHandler( 'CreateSWATRope', root, CreateSWATRope );