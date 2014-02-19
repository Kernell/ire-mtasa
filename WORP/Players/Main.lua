-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

-- TODO: Refactoring

local sounds = {};

function PlaySound3D( file, volume, max_distance, min_distance )
	if not isElementStreamedIn( source ) then
		return;
	end
	
	if sounds[ file ] then
		if isElement( sounds[ file ] ) then
			destroyElement( sounds[ file ] );
		end
		sounds[ file ] = nil;
	end
	
	local sound = playSound3D( file, getElementPosition( source ) );
	
	if sound then
		setElementDimension( sound, getElementDimension( source ) );
		setElementInterior( sound, getElementInterior( source ) );
		
		if volume then
			setSoundVolume( sound, volume );
		end
		
		if max_distance then
			setSoundMaxDistance( sound, max_distance );
		end
		
		if min_distance then
			setSoundMinDistance( sound, min_distance );
		end
		
		sounds[ file ] = sound;
	end
end

addEvent( 'CPlayer:PlaySound3D', true );

addEventHandler( 'CPlayer:PlaySound3D', root, PlaySound3D );

local function ProcessStaffAlpha( iTimeSlice )
	for i, pPlr in ipairs( getElementsByType( 'player', root, true ) ) do
		if pPlr:IsCollisionsEnabled() then
			if not pPlr.m_iAdminAlpha then pPlr.m_iAdminAlpha = 255 end
		
			if pPlr:GetData( "adminduty" ) then
				if pPlr.m_iAdminAlpha <= 128 then
					-- // Fade in
					pPlr.m_bAdminAlphaFadeIn = true;
				end
				
				if pPlr.m_iAdminAlpha >= 254 then
					-- // Fade out
					pPlr.m_bAdminAlphaFadeIn = false;
				end
				
				pPlr.m_iAdminAlpha = pPlr.m_bAdminAlphaFadeIn and pPlr.m_iAdminAlpha + ( iTimeSlice * .1 ) or pPlr.m_iAdminAlpha - ( iTimeSlice * .1 );
				
				pPlr.m_iAdminAlpha = math.min( 254, math.max( 128, pPlr.m_iAdminAlpha ) );
			
				pPlr:SetAlpha( pPlr.m_iAdminAlpha );
			elseif pPlr.m_iAdminAlpha < 255 then
				pPlr.m_iAdminAlpha = pPlr.m_iAdminAlpha + ( iTimeSlice * .1 );
				
				pPlr.m_iAdminAlpha = math.min( 255, pPlr.m_iAdminAlpha );
				
				pPlr:SetAlpha( pPlr.m_iAdminAlpha );
			end
		end
	end
	
	if CCamera.m_iCameraMode == 6 then
		CLIENT:SetAlpha( 0 );
	elseif CLIENT:GetAlpha() ~= 255 then
		CLIENT:SetAlpha( 255 );
	end
end

function SetAirbrakeEnabled( bEnabled )
	CLIENT.m_pNoClip	= NULL;
	
	if (bool)(bEnabled) then
		local pVehicle	= CLIENT:GetVehicle();
		
		CLIENT.m_pNoClip	=
		{
			vecPosition		= ( pVehicle or CLIENT ):GetPosition();
			vecRotation		= CElement.GetRotation( pVehicle or CLIENT );
		};
		
		CLIENT.m_pNoClip.vecRotation.X	= 0;
		CLIENT.m_pNoClip.vecRotation.Y	= 0;
		
		addEventHandler( "onClientPreRender", root, ProcessNoClip );
	end
	
	return true;
end

function ProcessNoClip( iTimeSlice )
	local this = CLIENT.m_pNoClip;
	
	if not this then
		removeEventHandler( "onClientPreRender", root, ProcessNoClip );
		
		return;
	end
	
	local pVehicle			= CLIENT:GetVehicle();
	
	if pVehicle and pVehicle:GetDriver() ~= CLIENT then
		SetAirbrakeEnabled( false );
		
		return;
	end
	
	if not CLIENT:GetData( "adminduty" ) then
		SetAirbrakeEnabled( false );
		
		return;
	end
	
	if not isMTAWindowActive() then
		if getKeyState( "f" ) then
			SetAirbrakeEnabled( false );
			
			return;
		end
		
		iTimeSlice	= iTimeSlice * 0.1;
		
		if getKeyState( "rshift" ) or getKeyState( "lshift" ) then
			iTimeSlice = iTimeSlice * 4.0;
		end
		
		if getKeyState( "ralt" ) or getKeyState( "lalt" ) then
			iTimeSlice = iTimeSlice * 0.25;
		end
		
		local fLeft				= getAnalogControlState( pVehicle and "vehicle_left" or "left" );
		local fRight			= getAnalogControlState( pVehicle and "vehicle_right" or "right" );
		local fForwards			= getAnalogControlState( pVehicle and "accelerate" or "forwards" );
		local fBackwards		= getAnalogControlState( pVehicle and "brake_reverse" or "backwards" );
		local fUp				= getKeyState( "space" ) and 1.0 or 0.0;
		local fDown				= getKeyState( "rctrl" ) and 1.0 or 0.0;
		
		if not pVehicle then
			local fX, fY, fZ	= getWorldFromScreenPosition( g_iScreenX / 2, g_iScreenY / 2, 20.0 );
			
			this.vecRotation.Z	= ( 360.0 - math.deg( math.atan2( fX - this.vecPosition.X, fY - this.vecPosition.Y ) ) ) % 360.0;
		end
		
		this.vecPosition	= this.vecPosition:Offset( ( fForwards - fBackwards ) * iTimeSlice, this.vecRotation.Z );
		this.vecPosition	= this.vecPosition:Offset( ( fLeft - fRight ) * iTimeSlice, this.vecRotation.Z + 90.0 );
		
		this.vecPosition.Z	= this.vecPosition.Z + ( ( fUp - fDown ) * iTimeSlice );
	end
	
	( pVehicle or CLIENT ):SetVelocity();
	( pVehicle or CLIENT ):SetPosition( this.vecPosition, true );
	CElement.SetRotation( pVehicle or CLIENT, this.vecRotation, NULL, true );
end

function UpdateCuffed( player )
	cuffed_to = player;
end

function UpdatePlayer( iTimeSlice )
	if cuffed_to and not localPlayer:IsInVehicle() then
		local vecPosition			= localPlayer:GetPosition();
		local vecTargetPosition		= cuffed_to:GetPosition(); --:Offset( -1.4, cuffed_to:GetRotation() - 180 );
		
		local fCurrentRotation 		= localPlayer:GetRotation();		
		local vecNewRotation 		= vecPosition:GetRotation( vecTargetPosition );
		
		localPlayer:SetRotation( fCurrentRotation + math.sin( math.rad( vecNewRotation.Z - fCurrentRotation ) ) * ( iTimeSlice * .5 ) );
	end
	
	if CLIENT:GetSimplestTask() == "TASK_SIMPLE_JUMP" then
		CLIENT.m_bJump = true;
	end
end

addEventHandler( 'onClientPreRender', root, ProcessStaffAlpha );
addEventHandler( 'onClientPreRender', root, UpdatePlayer );

function GetGroundPosition( sCallback )
	SERVER[ sCallback ]( getGroundPosition( getElementPosition( localPlayer ) ) );
end

local fPowerRate = 0.25;

local function UpdatePower()
	local bAdmin	= CLIENT:GetData( "adminduty" );
	local fPower	= not bAdmin and CLIENT:GetData( "CChar::m_fPower" ) or 100.0;
	
	if type( fPower ) == "number" then
		if not bAdmin then
			local sTask = CLIENT:GetSimplestTask();
			
			if sTask == "TASK_SIMPLE_PLAYER_ON_FOOT" or sTask == "TASK_SIMPLE_SWIM" then
				local sState = CLIENT:GetMoveState();
				
				if sState == "walk" then
					fPower = fPower - 0.10;
				elseif sState == "jog" or sState == "powerwalk" then
					fPower = fPower - 0.25 - fPowerRate;
				elseif sState == "sprint" then
					fPower = fPower - 1.00 - fPowerRate;
				elseif sState == "crouch" then
				--	fPower = fPower - 0.25 - fPowerRate;
				elseif sState == "climb" then
					fPower = fPower - 0.25 - fPowerRate;
				else
					local iLen	= CLIENT:GetVelocity():Length();
					
					fPower = fPower - ( iLen * ( iLen * 100.0 ) );
				end
			end
			
			if CLIENT.m_bJump then
				fPower = fPower - 10.0 - fPowerRate;
				
				CLIENT.m_bJump = false;
			end
			
			fPower = fPower + fPowerRate;
		end
		
		CLIENT:SetData( "CChar::m_fPower", Clamp( 0.0, fPower, 100.0 ) );
	end
end

setTimer( UpdatePower, 500, 0 );

function RenderTask()
	if not _TASK_DEBUG then
		return;
	end
	
    local fX, fY = 100, 300;
	
    for k = 0, 4 do
        local a, b, c, d = CLIENT:GetTask( "primary", k );
        
		dxDrawText( "Primary task #" + k + " is " + tostring( a ) + " -> " + tostring( b ) + " -> " + tostring( c ) + " -> " + tostring( d ) + " -> ", fX, fY );
        
		fY = fY + 15;
    end
	
    fY = fY + 15;
    
	for k = 0, 5 do
        local a, b, c, d = CLIENT:GetTask( "secondary", k );
        
		dxDrawText( "Secondary task #" + k + " is " + tostring( a ) + " -> " + tostring( b ) + " -> " + tostring( c ) + " -> " + tostring( d ) + " -> ", fX, fY );    
        
		fY = fY + 15;
    end

    fY = fY + 15;
	
	dxDrawText( "Simplest task is " + CLIENT:GetSimplestTask(), fX, fY );    
	
    fY = fY + 30;
	
	dxDrawText( "Move state is " + tostring( CLIENT:GetMoveState() ), fX, fY );    
end

addEventHandler( "onClientRender", root, RenderTask )