-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

addEvent( "CreateSWATRope", true );

local function SWATRopeWait( player )
	local vecVelocity	= CLIENT:GetVelocity();
	local vecPosition	= CLIENT:GetPosition();
	local fDistance		= vecPosition:Distance( Vector3( getGroundPosition( vecPosition.X, vecPosition.Y, vecPosition.Z ) ) );
	local bGround		= CLIENT:IsOnGround() or fDistance < 2 or vecVelocity.Z < .1;
	
	if bGround or CLIENT:GetContactElement() or CLIENT:IsInWater() or CLIENT:GetHealth() <= 0 then
		SERVER.DetachFromSWATRope( bGround );
		
		return;
	end
	
	CTimer( SWATRopeWait, 100, 1 );
end

local function CreateSWATRope( fX, fY, fZ, iTime )
	if source == CLIENT then
		CTimer( SWATRopeWait, 500, 1 );
	end
	
	createSWATRope( fX, fY, fZ, iTime );
end

addEventHandler( "CreateSWATRope", root, CreateSWATRope );