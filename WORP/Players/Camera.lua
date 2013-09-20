-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CCamera
{
	m_bLocked			= false;
	m_iCameraMode		= 2
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

local ProcessCamera, ProcessMouse, CamLookBinds;

local gl_fRotOffsetX		= 0.0;
local gl_fRotOffsetY		= 1.0;
local gl_fRotOffsetZ		= 0.0;
local gl_bCameraMode		= {};
local gl_iMouseTick			= 0;

local validTypes		=
{
	Automobile 			= true;
	Bike 				= true;
	[ "Monster Truck" ] = true;
	Quad 				= true;
};


local gl_offX, gl_offY, gl_offZ		= 0, 0, 0;

local fMouseX, fMouseY		= 0, 0;
local fScreenX, fScreenY	= guiGetScreenSize();

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

function ProcessMouse( fX, fY, fAbsoluteX, fAbsoluteY )
	if isCursorShowing() or isMTAWindowActive() then
		return;
	end
	
	if gl_bCameraMode[ 6 ] then
		if getKeyState( "mouse1" ) then
			fX		= ( fX - .5 ) * 2;
			fY		= ( fY - .5 ) * 2;
			
			fMouseX = fMouseX + fX * 0.2;
			fMouseY = fMouseY + fY * 0.2;
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
	elseif CCamera.m_iCameraMode == 6 then
		if gl_bCameraMode[ CCamera.m_iCameraMode ] then
			local pVehicle = CLIENT:GetVehicle();
			
			if pVehicle then
				-- local fX, fY, fZ	= getPedBonePosition( localPlayer, 6 );
				-- local fRX, fRY, fRZ	= getElementRotation( pVehicle );
				
				gl_fRotOffsetX = 0;
				gl_fRotOffsetY = 1;
				gl_fRotOffsetZ = 0;
				
				-- local vehicle_left	= getAnalogControlState( "vehicle_left" );
				-- local vehicle_right	= getAnalogControlState( "vehicle_right" );
				
				local vehicle_look_left		= getControlState( "vehicle_look_left" );
				local vehicle_look_right	= getControlState( "vehicle_look_right" );
				
				if vehicle_left or vehicle_right or vehicle_look_left or vehicle_look_right then
					fMouseX = 0;
					fMouseY = 0;
				end
				
				if vehicle_left then
					gl_fRotOffsetX = -( vehicle_left * .1 );
				end
				
				if vehicle_right then
					gl_fRotOffsetX = vehicle_right * .1;
				end
				
				if vehicle_right and vehicle_left and vehicle_right > 0 and vehicle_left > 0 then
					gl_fRotOffsetX = 0;
				end
				
				if vehicle_look_left then
					gl_fRotOffsetX = -1;
				end
				
				if vehicle_look_right then
					gl_fRotOffsetX = 1;
				end
				
				if vehicle_look_right and vehicle_look_left then
					gl_fRotOffsetX = 0;
					gl_fRotOffsetY = -1;
				end
				
				local offX	= 15 * Clamp( -1, gl_fRotOffsetX + fMouseX, 1 );
				local offY	= 5 * gl_fRotOffsetY;
				local offZ	=-5 * Clamp( -1, gl_fRotOffsetZ + fMouseY, 1 );
				
				gl_offX		= gl_offX + math.sin( math.rad( offX - gl_offX ) ) * ( iTimeSlice * .2 );
				gl_offY		= gl_offY + math.sin( math.rad( offY - gl_offY ) ) * ( iTimeSlice * .2 );
				gl_offZ		= gl_offZ + math.sin( math.rad( offZ - gl_offZ ) ) * ( iTimeSlice * .2 );
				
				local m 	= getElementMatrix( CLIENT );
				
				local fLookAtX = gl_offX * m[ 1 ][ 1 ] + gl_offY * m[ 2 ][ 1 ] + gl_offZ * m[ 3 ][ 1 ] + m[ 4 ][ 1 ];
				local fLookAtY = gl_offX * m[ 1 ][ 2 ] + gl_offY * m[ 2 ][ 2 ] + gl_offZ * m[ 3 ][ 2 ] + m[ 4 ][ 2 ];
				local fLookAtZ = gl_offX * m[ 1 ][ 3 ] + gl_offY * m[ 2 ][ 3 ] + gl_offZ * m[ 3 ][ 3 ] + m[ 4 ][ 3 ];
				
				local fRoll = -math.deg( math.asin( m[ 4 ][ 3 ] - ( 1.0 * m[ 1 ][ 3 ] + 0 * m[ 2 ][ 3 ] + 0 * m[ 3 ][ 3 ] + m[ 4 ][ 3 ] ) ) );
				
				local fX, fY, fZ;
				
				fX, fY, fZ	= getPedBonePosition( localPlayer, 6 );
				
				setCameraMatrix( fX, fY, fZ, fLookAtX, fLookAtY, fLookAtZ, fRoll );
				
			else			
				gl_bCameraMode[ CCamera.m_iCameraMode ] = false;
				
				setCameraTarget( CLIENT );
			end
		elseif CLIENT:IsInVehicle() then
			gl_bCameraMode[ CCamera.m_iCameraMode ] = true;
			
			local pVehicle = CLIENT:GetVehicle();
			
			if pVehicle and getVehicleType( pVehicle ) == "Automobile" and pVehicle:GetDriver() == CLIENT then
				CLIENT:SetAnimation( "PED", "car_sit", -1 );
			end
		end
	elseif CCamera.m_iCameraMode == 7 then
		local pVehicle = CLIENT:GetVehicle();
			
		if pVehicle then
			gl_bCameraMode[ CCamera.m_iCameraMode ] = true;
			
			local fX, fY, fZ = getPositionInOffset( pVehicle, 0, -7.0, 2.0 );
			local fLookAtX, fLookAtY, fLookAtZ = getElementPosition( pVehicle );
			
			setCameraMatrix( fX, fY, fZ, fLookAtX, fLookAtY, fLookAtZ + 1.0 );
		elseif gl_bCameraMode[ CCamera.m_iCameraMode ] then
			setCameraTarget( CLIENT );
			
			gl_bCameraMode[ CCamera.m_iCameraMode ] = false;
		end
	end
end


function CamLookBinds( sKey, sState )
	if gl_bCameraMode[ 6 ] then
		local pVehicle = CLIENT:GetVehicle();
		
		if pVehicle and validTypes[ getVehicleType( pVehicle.__instance ) ] then
			if sState == 'down' then
				if sKey == 'vehicle_look_behind' then
					gl_fRotOffsetY = -1;
				end
				
				return;
			end
		end
	end
	
	gl_fRotOffsetX = 0;
	gl_fRotOffsetY = 1;
end

function CCamera:ChangeMode()
	if CLIENT:IsInVehicle() then
		if CCamera.m_iCameraMode == 6 then
			gl_bCameraMode[ CCamera.m_iCameraMode ] = false;
			
			CLIENT:SetAnimation();
			
			setAnalogControlState( "vehicle_right", 0.0 );
			setAnalogControlState( "vehicle_left", 0.0 );
		end
		
		CCamera.m_iCameraMode = ( CCamera.m_iCameraMode + 1 ) % 7;
		
		if CCamera.m_iCameraMode < 6 then
			setCameraTarget( CLIENT );
			setCameraViewMode( CCamera.m_iCameraMode );
		end
	else
		setCameraTarget( CLIENT );
	end
end

addEventHandler( "onClientCursorMove", root, ProcessMouse );
addEventHandler( "onClientPreRender", root, ProcessCamera );

bindKey( "vehicle_look_behind", "both", CamLookBinds );
