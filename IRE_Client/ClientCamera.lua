-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. ClientCamera : Element
{
	Locked					= false;
	CameraMode				= 2;
	
	Cockpit					= false;
	CockpitVector			= NULL;
	CockpitTime				= 0.6;
	CockpitReleaseTime		= 0.3;
	
	Position				= NULL;
	Rotation				= NULL;
	PositionBehind			= NULL;
	RotationBehind			= NULL;
	
	MovingData				= NULL;
	RotatingData			= NULL;
	
	ClientCamera	= function()
		this = getCamera()( this );
		
		this.CockpitVector		= new. Vector3();
		this.Position			= new. Vector3();
		this.Rotation			= new. Vector3();
		this.PositionBehind		= new. Vector3( 0.4, 0.0, 0.7 );
		this.RotationBehind		= new. Vector3( 0.0, 0.0, 180.0 );
		
		addEventHandler( "onClientPreRender", 		root, this.UpdateCamera );
		addEventHandler( "onClientCursorMove", 		root, this.UpdateCuror );
		addEventHandler( "onClientVehicleEnter", 	root, this.OnVehicleEnter );
		addEventHandler( "onClientVehicleExit", 	root, this.OnVehicleExit );
	end;
	
	_ClientCamera	= function()
		removeEventHandler( "onClientPreRender", 		root, this.UpdateCamera );
		removeEventHandler( "onClientCursorMove", 		root, this.UpdateCuror );
		removeEventHandler( "onClientVehicleEnter", 	root, this.OnVehicleEnter );
		removeEventHandler( "onClientVehicleExit", 		root, this.OnVehicleExit );
		
		this.Detach();
	end;
	
	MoveTo		= function( position, time, easing, easingPeriod, easingAmplitude, easingOvershoot )
		local x, y, z	= getCameraMatrix();
		
		this.MovingData		= new. ClientCameraInterp( new. Vector3( x, y, z ), position, time, easing, easingPeriod, easingAmplitude, easingOvershoot );
	end;
	
	RotateTo	= function( rotation, time, easing, easingPeriod, easingAmplitude, easingOvershoot )
		local n, n, n, x, y, z	= getCameraMatrix();
		
		this.RotatingData	= new. ClientCameraInterp( new. Vector3( x, y, z ), rotation, time, easing, easingPeriod, easingAmplitude, easingOvershoot );
	end;
	
	SetTarget	= function( target )
		this.Detach();
		
		setCameraTarget( target or CLIENT );
	end;
	
	ChangeMode	= function()
		if CLIENT.IsInVehicle() then
			if this.CameraMode == 6 then
				CLIENT.SetAlpha( 255 );
			end
			
			this.CameraMode = ( this.CameraMode + 1 ) % 7;
			
			if this.CameraMode == 6 then
				this.Cockpit = false;
			elseif this.CameraMode < 6 then
				this.SetTarget();
				
				setCameraViewMode( this.CameraMode );
			end
		else
			this.SetTarget();
		end
	end;
	
	OnVehicleEnter	= function( player, seat )
		if player == CLIENT then
			if this.CameraMode == 6 then
				this.Cockpit	= false;
				
				CLIENT.SetAlpha( 0 );
			end
		end
	end;
	
	OnVehicleExit	= function( player, seat )
		if player == CLIENT then
			if this.CameraMode == 6 then
				this.Cockpit	= false;
				
				CLIENT.SetAlpha( 255 );
				
				this.SetTarget();
			end
		end
	end;
	
	UpdateCamera	= function( timeSlice )
		local deltaTime = timeSlice / 1000;
		
		if this.MovingData or this.RotatingData then
			local x, y, z, lookX, lookY, lookZ = getCameraMatrix();
			
			if this.MovingData then
				x, y, z	= this.MovingData.Interpolate();
				
				if this.MovingData.Finished then
					this.MovingData = NULL;
				end
			end
			
			if this.RotatingData then
				lookX, lookY, lookZ	= this.RotatingData.Interpolate();
				
				if this.RotatingData.Finished then
					this.RotatingData = NULL;
				end
			end
			
			setCameraMatrix( x, y, z, lookX, lookY, lookZ );
		elseif this.CameraMode == 6 then
			if this.Cockpit then
				if CLIENT.IsInVehicle() then
					local bKeyLookLeft		= getControlState( "vehicle_look_left" );
					local bKeyLookRight		= getControlState( "vehicle_look_right" );
						
					if not getKeyState( "mouse1" ) then
						local fCockpitX = 0.0;
						
						if bKeyLookLeft then
							fCockpitX = fCockpitX - 1.0;
						end
						
						if bKeyLookRight then
							fCockpitX = fCockpitX + 1.0;
						end
						
						if fCockpitX < this.CockpitVector.X then
							local fCockpitXSpeed	= 1.0 / ( this.CockpitVector.X > 0.0 and this.CockpitReleaseTime or this.CockpitTime );
							
							this.CockpitVector.X		= this.CockpitVector.X - ( fCockpitXSpeed * deltaTime );
							
							if this.CockpitVector.X < fCockpitX then
								this.CockpitVector.X = fCockpitX;
							end
						elseif fCockpitX > this.CockpitVector.X then
							local fCockpitXSpeed	= 1.0 / ( this.CockpitVector.X < 0.0 and this.CockpitReleaseTime or this.CockpitTime );
							
							this.CockpitVector.X		= this.CockpitVector.X + ( fCockpitXSpeed * deltaTime );
							
							if this.CockpitVector.X > fCockpitX then
								this.CockpitVector.X = fCockpitX;
							end
						end
					end
					
					this.Rotation.X	= -this.CockpitVector.Z * 30.0;
					this.Rotation.Z	= -this.CockpitVector.X * 80.0;
					
					if bKeyLookLeft and bKeyLookRight then
						this.SetAttachedOffsets( this.PositionBehind, this.RotationBehind );
					else
						this.SetAttachedOffsets( this.Position, this.Rotation );
					end
				else
					this.Cockpit = false;
					
					this.SetTarget();
					
					CLIENT.SetAlpha( 255 );
				end
			elseif CLIENT.IsInVehicle() then
				this.Cockpit = true;
				
				CLIENT:SetAlpha( 0 );
				
				setAnalogControlState( "vehicle_right", 0.0 );
				setAnalogControlState( "vehicle_left", 0.0 );
				
				this.Position	= CLIENT.GetBonePosition( 6 ) - CLIENT.GetPosition();
				
				this.Position.Y	= -0.2;
				this.Position.X	= 0.0;
				
				this.AttachTo( CLIENT, this.Position );
			end
		end
	end;
	
	UpdateCuror	= function( x, y )
		if isCursorShowing() or isMTAWindowActive() then
			return;
		end
		
		if this.Cockpit then
			if getKeyState( "mouse1" ) then
				x		= ( x - 0.5 ) * 2.0;
				y		= ( y - 0.5 ) * 2.0;
				
				this.CockpitVector.X = Clamp( -1.0, this.CockpitVector.X + x, 1.0 );
				this.CockpitVector.Z = Clamp( -1.0, this.CockpitVector.Z + y, 1.0 );
			end
		end
	end;
};

class. ClientCameraInterp
{	
	Finished = false;
	
	ClientCameraInterp		= function( from, to, time, easing, easingPeriod, easingAmplitude, easingOvershoot )
		this.X 	= from.X;
		this.Y 	= from.Y;
		this.Z	= from.Z;
		
		this.TargetX		= to.X;
		this.TargetY		= to.Y;
		this.TargetZ		= to.Z;
		
		this.Time 			= time or 1000;
		this.TimeEnd		= getTickCount() + this.Time;
		
		this.Easing				= easing or "Linear";
		this.EasingPeriod		= easingPeriod or 0.3;
		this.EasingAmplitude	= easingAmplitude or 1.0;
		this.EasingOvershoot	= easingOvershoot or 1.701;
	end;
	
	Interpolate			= function()
		local progress	= 1.0 - ( this.TimeEnd - getTickCount() ) / this.Time;
		
		this.Finished = progress >= 1.0;
		
		return interpolateBetween( this.X, this.Y, this.Z, this.TargetX, this.TargetY, this.TargetZ, progress, this.Easing, this.EasingPeriod, this.EasingAmplitude, this.EasingOvershoot );
	end;
};