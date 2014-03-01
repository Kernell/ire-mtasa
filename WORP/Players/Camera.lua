-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

CLIENT.GetCamera = getCamera;

class: CCamera
{
	m_bLocked			= false;
	m_iCameraMode		= 2;
};

class: CCameraInterp
{	
	fX					= NULL;
	fY					= NULL;
	fZ					= NULL;
	
	fTargetX			= NULL;
	fTargetY			= NULL;
	fTargetZ			= NULL;
	
	iTime				= NULL;
	iTimeEnd			= NULL;
	
	sEasing				= NULL;
	fEasingPeriod		= NULL;
	fEasingAmplitude	= NULL;
	fEasingOvershoot	= NULL;
	
	bFinished			= false;
	
	CCameraInterp		= function( this, fX, fY, fZ, fTargetX, fTargetY, fTargetZ, iTime, sEasing, fEasingPeriod, fEasingAmplitude, fEasingOvershoot )
		this.fX 	= fX;
		this.fY 	= fY;
		this.fZ		= fZ;
	
		this.fTargetX		= fTargetX;
		this.fTargetY		= fTargetY;
		this.fTargetZ		= fTargetZ;
		
		this.iTime 			= iTime or 1000;
		this.iTimeEnd		= getTickCount() + this.iTime;
		
		this.sEasing			= sEasing or "Linear";
		this.fEasingPeriod		= fEasingPeriod or 0.3;
		this.fEasingAmplitude	= fEasingAmplitude or 1.0;
		this.fEasingOvershoot	= fEasingOvershoot or 1.701;
	end;
	
	IsFinished			= function( this )
		return this.bFinished;
	end;
	
	Interpolate			= function( this )
		local fProgress	= 1.0 - ( this.iTimeEnd - getTickCount() ) / this.iTime;
		
		if fProgress >= 1.0 then
			this.bFinished = true;
		end
		
		return interpolateBetween( this.fX, this.fY, this.fZ, this.fTargetX, this.fTargetY, this.fTargetZ, fProgress, this.sEasing, this.fEasingPeriod, this.fEasingAmplitude, this.fEasingOvershoot );
	end;
};

local ProcessCamera, ProcessMouse;

local MovingData	= NULL;
local RotatingData	= NULL;

function SetCameraLocked( bLocked )
	MovingData		= NULL;
	RotatingData	= NULL;
end

function MoveCamera( fTargetX, fTargetY, fTargetZ, iTime, sEasing, fEasingPeriod, fEasingAmplitude, fEasingOvershoot )
	local fX, fY, fZ	= getCameraMatrix();
	
	MovingData		= CCameraInterp( fX, fY, fZ, fTargetX, fTargetY, fTargetZ, iTime, sEasing, fEasingPeriod, fEasingAmplitude, fEasingOvershoot );
end

function RotateCamera( fTargetX, fTargetY, fTargetZ, iTime, sEasing, fEasingPeriod, fEasingAmplitude, fEasingOvershoot )
	local n, n, n, fX, fY, fZ	= getCameraMatrix();
	
	RotatingData	= CCameraInterp( fX, fY, fZ, fTargetX, fTargetY, fTargetZ, iTime, sEasing, fEasingPeriod, fEasingAmplitude, fEasingOvershoot );
end

function ProcessMouse( fX, fY )
	if isCursorShowing() or isMTAWindowActive() then
		return;
	end
	
	local pCamera = CLIENT:GetCamera();
	
	if pCamera.m_bCockpit then
		if getKeyState( "mouse1" ) then
			fX		= ( fX - 0.5 ) * 2.0;
			fY		= ( fY - 0.5 ) * 2.0;
			
			pCamera.m_vecCockpit.X = Clamp( -1.0, pCamera.m_vecCockpit.X + fX, 1.0 );
			pCamera.m_vecCockpit.Z = Clamp( -1.0, pCamera.m_vecCockpit.Z + fY, 1.0 );
		end
	end
end

function ProcessCamera( iTimeSlice )
	if MovingData or RotatingData then
		local fX, fY, fZ, fLookX, fLookY, fLookZ = getCameraMatrix();
		
		if MovingData then
			fX, fY, fZ	= MovingData:Interpolate();
			
			if MovingData:IsFinished() then
				MovingData = NULL;
			end
		end
		
		if RotatingData then
			fLookX, fLookY, fLookZ	= RotatingData:Interpolate();
			
			if RotatingData:IsFinished() then
				RotatingData = NULL;
			end
		end
		
		setCameraMatrix( fX, fY, fZ, fLookX, fLookY, fLookZ );
	end
end

function CCamera:ChangeMode()
	if CLIENT:IsInVehicle() then
		CCamera.m_iCameraMode = ( CCamera.m_iCameraMode + 1 ) % 7;
		
		if CCamera.m_iCameraMode == 6 then
			CLIENT:GetCamera().m_bCockpit = false;
		elseif CCamera.m_iCameraMode < 6 then
			CLIENT:GetCamera():SetTarget();
			
			setCameraViewMode( CCamera.m_iCameraMode );
		end
	else
		CLIENT:GetCamera():SetTarget();
	end
end

addEventHandler( "onClientCursorMove", root, ProcessMouse );
addEventHandler( "onClientPreRender", root, ProcessCamera );
