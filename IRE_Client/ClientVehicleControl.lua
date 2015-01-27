-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. ClientVehicleControl
{
	MouseY 					= 0;
	
	BrakeTick				= 0;
	
	Steer					= 0.0;
	SteerTime				= 0.7;
	VeloSteerTime			= 0.1;
	SteerReleaseTime		= 0.6;
	VeloSteerReleaseTime	= 0.0;
	SteerCorrectionFactor	= 4.0;
	
	ClientVehicleControl	= function()
		function this.__UpdateMouse( ... )
			this.UpdateMouse( ... );
		end
		
		function this.__UpdateControl( deltaTime )
			this.UpdateControl( deltaTime / 1000 );
		end
		
		addEventHandler( "onClientCursorMove", root, this.__UpdateMouse );
		addEventHandler( "onClientPreRender", root, this.__UpdateControl );
	end;
	
	_ClientVehicleControl	= function()
		removeEventHandler( "onClientCursorMove", root, this.__UpdateMouse );
		removeEventHandler( "onClientPreRender", root, this.__UpdateControl );
	end;
	
	UpdateMouse		= function( x, y, absoluteX, absoluteY )
		if Settings.Controls.MouseSteering.Enabled == false then return; end
		
		if isCursorShowing() 			then return; end
		if isMainMenuActive() 			then return; end
		if isConsoleActive() 			then return; end
		if isChatBoxInputActive() 		then return; end
		if getKeyState( "mouse1" )		then return; end
		
		local vehicle	= CLIENT.GetVehicle();
		
		if vehicle and vehicle.GetDriver() == CLIENT then
			x		= ( x - 0.5 ) * 2;
			y		= ( y - 0.5 ) * 2;
			
			this.Steer	= this.Steer + ( x * Settings.Controls.MouseSteering.Sensitivity );
			this.MouseY	= this.MouseY + ( y * Settings.Controls.MouseSteering.Sensitivity );
		else
			this.Steer	= 0.0;
			this.MouseY	= 0.0;
		end
		
		this.Steer		= Clamp( -1.0, this.Steer, 1.0 );
		this.MouseY		= Clamp( -1.0, this.MouseY, 1.0 );
	end;
	
	UpdateControl	= function( deltaTime )
		local isUIShowing	= isCursorShowing() or isMainMenuActive() or isConsoleActive() or isChatBoxInputActive();
		local tick 			= getTickCount();
		
		if Settings.Controls.Cruise > 0.0 then
			local vehicle = CLIENT.GetVehicle();
			
			if vehicle and vehicle.GetDriver() == CLIENT then
				local velAngle	= vehicle.GetVelocityAngle();
				local speed		= vehicle.GetSpeed();
				
				if velAngle >= 120.0 then
					speed = -speed;
				end
				
				local isAccelerate		= not isUIShowing and getKeyState( this.KeyAccelerate );
				local isBrakeReverse	= not isUIShowing and getKeyState( this.KeyBrakeReverse );
				
				local accelerate	= 0.0;
				local brakeReverse	= 0.0;
				
				local force = ( Settings.Controls.Cruise - speed ) / Settings.Controls.Cruise;
				
				if force >= 0.0 and isAccelerate then
					accelerate = getEasingValue( fForce, "OutQuad" );
				elseif force < 0.0 and not isBrakeReverse then
					brakeReverse = -force * 1.5;
				end
				
				if isBrakeReverse then
					if this.BrakeTick == 0 then
						this.BrakeTick = tick + 2000;
					end
					
					brakeReverse = Clamp( 0.25, 1.0 - ( this.BrakeTick - tick ) / 2000, 1.0 );
				else
					if this.BrakeTick ~= 0 then
						this.BrakeTick = 0;
					end
				end
				
				accelerate		= math.abs( accelerate ) + ( isAccelerate and 0.05 or 0.0 );
				brakeReverse	= math.abs( brakeReverse );
				
				setAnalogControlState( "accelerate", accelerate );
				setAnalogControlState( "brake_reverse", brakeReverse );
				
				if _DEBUG then
					dxDrawText( ( "accelerate = %.2f" ):format( accelerate ), 50, 300 );
					dxDrawText( ( "brakeReverse = %.2f" ):format( brakeReverse ), 50, 320 );
					dxDrawText( ( "velAngle = %.2f" ):format( velAngle ), 50, 340 );
				end
			end
		end
		
		local bLeft		= false;
		local bRight	= false;
		
		if isUIShowing then
			return;
		end
		
		local vehicle = CLIENT.GetVehicle();
		
		if vehicle and vehicle.GetDriver() == CLIENT and CLIENT.GetHealth() > 0 then
			if not Settings.Controls.MouseSteering.Enabled then
				for key in pairs( getBoundKeys( "vehicle_left" ) ) do
					if getKeyState( key ) then
						bLeft = true;
						
						break;
					end
				end
				
				for key in pairs( getBoundKeys( "vehicle_right" ) ) do
					if getKeyState( key ) then
						bRight = true;
						
						break;
					end
				end
				
				local velocity		= pVehicle.GetVelocity().Length();
				
				local steerInput = 0.0;
				
				if bLeft then
					steerInput = steerInput - 1.0;
				end
				
				if bRight then
					steerInput = steerInput + 1.0;
				end
				
				if steerInput < this.Steer then
					local steerSpeed	= 0.0;
					
					if this.steer > 0.0 then
						steerSpeed = 1.0 / ( this.SteerReleaseTime + this.VeloSteerReleaseTime * velocity );
					else
						steerSpeed	= 1.0 / ( this.SteerTime + this.VeloSteerTime * velocity );
					end
					
					if this.Steer > 0.0 then
						steerSpeed = steerSpeed * ( 1.0 + this.Steer * this.SteerCorrectionFactor );
					end
					
					this.Steer = this.Steer - ( SteerSpeed * deltaTime );
					
					if steerInput > this.Steer then
						this.Steer = steerInput;
					end
				elseif steerInput > this.Steer then
					local steerSpeed	= 0.0;
					
					if this.Steer < 0.0 then
						steerSpeed = 1.0 / ( this.SteerReleaseTime + this.VeloSteerReleaseTime * velocity );
					else
						steerSpeed	= 1.0 / ( this.SteerTime + this.VeloSteerTime * velocity );
					end
					
					if this.Steer < 0.0 then
						steerSpeed = steerSpeed * ( 1.0 + -this.Steer * this.SteerCorrectionFactor );
					end
					
					this.Steer = this.Steer + ( steerSpeed * deltaTime );
					
					if steerInput < this.Steer then
						this.Steer = SteerInput;
					end
				end
			end
		
			if this.Steer > 0.0 then
				setAnalogControlState( "vehicle_right", Easing[ Settings.Controls.MouseSteering.EasingOut ]( this.Steer ) );
			elseif this.Steer < 0.0 then
				setAnalogControlState( "vehicle_left", Easing[ Settings.Controls.MouseSteering.EasingOut ]( -this.Steer ) );
			else
				setAnalogControlState( "vehicle_right", 0.0 );
				setAnalogControlState( "vehicle_left", 0.0 );
			end
			
			if _DEBUG and isDebugViewActive() then
				dxDrawText( "this.Steer = " + tostring( this.Steer ), 100, 500 );
			end	
		end
	end;
	
	SetCruise	= function( speed )
		Settings.Controls.Cruise = speed;
		
		if speed > 0.0 then
			for key, state in pairs( getBoundKeys( "accelerate" ) ) do
				this.KeyAccelerate		= key;
				
				break;
			end
			
			for key, state in pairs( getBoundKeys( "brake_reverse" ) ) do
				this.KeyBrakeReverse	= key;
				
				break;
			end
		end
		
		setAnalogControlState( "accelerate", 0.0 );
		setAnalogControlState( "brake_reverse", 0.0 );
		
		toggleControl( "accelerate", speed <= 0.0 );
		toggleControl( "brake_reverse", speed <= 0.0 );
	end;
};
