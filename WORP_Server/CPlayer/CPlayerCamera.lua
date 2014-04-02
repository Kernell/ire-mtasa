-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CPlayerCamera"

function CPlayerCamera:CPlayerCamera( pPlayer )
	self.m_pPlayer = pPlayer;
end

function CPlayerCamera:_CPlayerCamera()
	
end

function CPlayerCamera:Fade( ... )
	if classname( self ) ~= 'CPlayerCamera' then error( TEXT_E2288, 2 ) end
	
	return fadeCamera( self.m_pPlayer, ... );
end

function CPlayerCamera:GetInterior()
	if classname( self ) ~= 'CPlayerCamera' then error( TEXT_E2288, 2 ) end
	
	return getCameraInterior( self.m_pPlayer );
end

function CPlayerCamera:GetMatrix()
	if classname( self ) ~= 'CPlayerCamera' then error( TEXT_E2288, 2 ) end
	
	local fX, fY, fZ, fLX, fLY, fLZ, fRoll, fFOV = getCameraMatrix( self.m_pPlayer );
	
	assert( fX, 'Assertion failed - fX' );
	assert( fY, 'Assertion failed - fY' );
	assert( fZ, 'Assertion failed - fZ' );
	
	return Vector3( fX, fY, fZ ), Vector3( fLX, fLY, fLZ ), fRoll, fFOV;
end

function CPlayerCamera:GetTarget()
	if classname( self ) ~= 'CPlayerCamera' then error( TEXT_E2288, 2 ) end
	
	return getCameraTarget( self.m_pPlayer );
end

function CPlayerCamera:SetInterior( int )
	if classname( self ) ~= 'CPlayerCamera' then error( TEXT_E2288, 2 ) end
	
	return setCameraInterior( self.m_pPlayer, tonumber( int ) or 0 );
end

---

function CPlayerCamera:SetFreeLookEnabled( bEnabled )
	if classname( self ) ~= 'CPlayerCamera' then error( TEXT_E2288, 2 ) end
	
	self.m_pPlayer:SetFrozen( bEnabled );
	self.m_pPlayer:SetCollisionsEnabled( not bEnabled );
	self.m_pPlayer:SetAlpha( bEnabled and 0 or 255 );

	return bEnabled and exports.freecam:setPlayerFreecamEnabled( self.m_pPlayer ) or exports.freecam:setPlayerFreecamDisabled( self.m_pPlayer, 1 );
end

function CPlayerCamera:SetFreeLookOption( sOption, vValue )
	if classname( self ) ~= 'CPlayerCamera' then error( TEXT_E2288, 2 ) end
	
	return exports.freecam:setPlayerFreecamOption( self.m_pPlayer, sOption, vValue );
end

function CPlayerCamera:IsFreeLookEnabled()
	if classname( self ) ~= 'CPlayerCamera' then error( TEXT_E2288, 2 ) end
	
	return exports.freecam:isPlayerFreecamEnabled( self.m_pPlayer );
end

---

function CPlayerCamera:SetMatrix( vecPosition, vecTarget, ... )
	if classname( self ) ~= 'CPlayerCamera' then error( TEXT_E2288, 2 ) end
	
	vecPosition		= vecPosition or Vector3();
	vecTarget		= vecTarget or Vector3();
	
	self.m_pPlayer:Client().SetCameraLocked( false );
	
	return setCameraMatrix( self.m_pPlayer, vecPosition.X, vecPosition.Y, vecPosition.Z, vecTarget.X, vecTarget.Y, vecTarget.Z, ... );
end

function CPlayerCamera:SetTarget( pTarget )
	if classname( self ) ~= 'CPlayerCamera' then error( TEXT_E2288, 2 ) end
	
	self.m_pPlayer:Client().SetCameraLocked( false );
	
	return setCameraTarget( self.m_pPlayer, pTarget and pTarget or self.m_pPlayer );
end

function CPlayerCamera:MoveTo( vecPosition, ... )
	if classname( self ) ~= 'CPlayerCamera' then error( TEXT_E2288, 2 ) end
	
	self.m_pPlayer:Client().MoveCamera( vecPosition.X, vecPosition.Y, vecPosition.Z, ... );
end

function CPlayerCamera:RotateTo( vecPosition, ... )
	if classname( self ) ~= 'CPlayerCamera' then error( TEXT_E2288, 2 ) end
	
	self.m_pPlayer:Client().RotateCamera( vecPosition.X, vecPosition.Y, vecPosition.Z, ... );
end