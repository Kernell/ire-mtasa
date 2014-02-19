-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

AnalogControl = 
{
	fMouseX 	= 0;
	fMouseY 	= 0;
	
	iBrakeTick	= 0;
	
	fSteer					= 0.0;
	fSteerTime				= 0.7;
	fVeloSteerTime			= 0.1;
	fSteerReleaseTime		= 0.5;
	fVeloSteerReleaseTime	= 0.0;
	fSteerCorrectionFactor	= 4.0;
	
	AnalogControl	= function()
		addEventHandler( "onClientCursorMove", root, function() AnalogControl:UpdateMouse(); end );
		addEventHandler( "onClientPreRender", root, function( iDeltaTime ) AnalogControl:UpdateControl( iDeltaTime / 1000 ); end );
	end;
	
	UpdateMouse		= function( this, fX, fY, fAbsoluteX, fAbsoluteY )
		if Settings.Controls.MouseSteering.Enabled == false then return; end
		if isCursorShowing() 			then return; end
		if isMainMenuActive() 			then return; end
		if isConsoleActive() 			then return; end
		if isChatBoxInputActive() 		then return; end
		if getKeyState( "mouse1" )		then return; end
		
		local pVehicle	= CLIENT:GetVehicle();
		
		if pVehicle and pVehicle:GetDriver() == CLIENT then
			fX		= ( fX - .5 ) * 2;
			fY		= ( fY - .5 ) * 2;
			
			this.fMouseX		= this.fMouseX + ( fX * Settings.Controls.MouseSteering.Sensitivity );
			this.fMouseY		= this.fMouseX + ( fX * Settings.Controls.MouseSteering.Sensitivity );
		else
			this.fMouseX		= 0.0;
			this.fMouseY		= 0.0;
		end
		
		this.fMouseX			= Clamp( -1.0, this.fMouseX, 1.0 );
		this.fMouseY			= Clamp( -1.0, this.fMouseY, 1.0 );
	end;
	
	UpdateControl	= function( this, iDeltaTime )
		local bUIShowing	= isCursorShowing() or isMainMenuActive() or isConsoleActive() or isChatBoxInputActive();
		local iTick 		= getTickCount();
		
		if Settings.Controls.Cruise > 0.0 then
			local pVehicle = CLIENT:GetVehicle();
			
			if pVehicle and pVehicle:GetDriver() == CLIENT then
				local fVelAngle		= pVehicle:GetVelocityAngle();
				local fSpeed		= pVehicle:GetSpeed();
				
				if fVelAngle >= 120.0 then
					fSpeed = -fSpeed;
				end
				
				local bAccelerate	= not bUIShowing and getKeyState( this.sKeyAccelerate );
				local bBrakeReverse	= not bUIShowing and getKeyState( this.sKeyBrakeReverse );
				
				local fAccelerate	= 0.0;
				local fBrakeReverse	= 0.0;
				
				local fForce = ( Settings.Controls.Cruise - fSpeed ) / Settings.Controls.Cruise;
				
				if fForce >= 0.0 and bAccelerate then
					fAccelerate = getEasingValue( fForce, "OutQuad" );
				elseif fForce < 0.0 and not bBrakeReverse then
					fBrakeReverse = -fForce * 1.5;
				end
				
				if bBrakeReverse then
					if this.iBrakeTick == 0 then
						this.iBrakeTick = iTick + 2000;
					end
					
					fBrakeReverse = Clamp( 0.25, 1.0 - ( this.iBrakeTick - iTick ) / 2000, 1.0 );
				else
					if this.iBrakeTick ~= 0 then
						this.iBrakeTick = 0;
					end
				end
				
				fAccelerate		= math.abs( fAccelerate ) + ( bAccelerate and 0.05 or 0.0 );
				fBrakeReverse	= math.abs( fBrakeReverse );
				
				setAnalogControlState( "accelerate", fAccelerate );
				setAnalogControlState( "brake_reverse", fBrakeReverse );
				
				if _DEBUG then
					dxDrawText( ( "fAccelerate = %.2f" ):format( fAccelerate ), 50, 300 );
					dxDrawText( ( "fBrakeReverse = %.2f" ):format( fBrakeReverse ), 50, 320 );
					dxDrawText( ( "fVelAngle = %.2f" ):format( fVelAngle ), 50, 340 );
				end
			end
		end
		
		if Settings.Controls.MouseSteering.Enabled then
			if this.fMouseX > 0.0 then
				setAnalogControlState( "vehicle_right", Easing[ Settings.Controls.MouseSteering.EasingOut ]( Easing, this.fMouseX ) );
			elseif this.fMouseX < 0.0 then
				setAnalogControlState( "vehicle_left", Easing[ Settings.Controls.MouseSteering.EasingOut ]( Easing, -this.fMouseX ) );
			else
				setAnalogControlState( "vehicle_right", 0.0 );
				setAnalogControlState( "vehicle_left", 0.0 );
			end
		else
			local bLeft		= false;
			local bRight	= false;
			
			if bUIShowing then
				return;
			end
			
			local pVehicle = CLIENT:GetVehicle();
			
			if pVehicle and pVehicle:GetDriver() == CLIENT then
				if CLIENT:GetHealth() > 0 then
					for sKey in pairs( getBoundKeys( "vehicle_left" ) ) do
						if getKeyState( sKey ) then
							bLeft = true;
							
							break;
						end
					end
					
					for sKey in pairs( getBoundKeys( "vehicle_right" ) ) do
						if getKeyState( sKey ) then
							bRight = true;
							
							break;
						end
					end
					
					local fVelocity		= pVehicle:GetVelocity():Length();
					
					local fSteerInput = 0.0;
					
					if bLeft then
						fSteerInput = fSteerInput - 1.0;
					end
					
					if bRight then
						fSteerInput = fSteerInput + 1.0;
					end
					
					if fSteerInput < this.fSteer then
						local fSteerSpeed	= 0.0;
						
						if this.fSteer > 0.0 then
							fSteerSpeed = 1.0 / ( this.fSteerReleaseTime + this.fVeloSteerReleaseTime * fVelocity );
						else
							fSteerSpeed	= 1.0 / ( this.fSteerTime + this.fVeloSteerTime * fVelocity );
						end
						
						if this.fSteer > 0.0 then
							fSteerSpeed = fSteerSpeed * ( 1.0 + this.fSteer * this.fSteerCorrectionFactor );
						end
						
						this.fSteer = this.fSteer - ( fSteerSpeed * iDeltaTime );
						
						if fSteerInput > this.fSteer then
							this.fSteer = fSteerInput;
						end
					elseif fSteerInput > this.fSteer then
						local fSteerSpeed	= 0.0;
						
						if this.fSteer < 0.0 then
							fSteerSpeed = 1.0 / ( this.fSteerReleaseTime + this.fVeloSteerReleaseTime * fVelocity );
						else
							fSteerSpeed	= 1.0 / ( this.fSteerTime + this.fVeloSteerTime * fVelocity );
						end
						
						if this.fSteer < 0.0 then
							fSteerSpeed = fSteerSpeed * ( 1.0 + -this.fSteer * this.fSteerCorrectionFactor );
						end
						
						this.fSteer = this.fSteer + ( fSteerSpeed * iDeltaTime );
						
						if fSteerInput < this.fSteer then
							this.fSteer = fSteerInput;
						end
					end
				end
				
				if this.fSteer > 0 then
					setAnalogControlState( "vehicle_right", Easing:OutQuad( this.fSteer, 0.0, 1.0, 1.0 ) );
				elseif this.fSteer < 0 then
					setAnalogControlState( "vehicle_left", Easing:OutQuad( -this.fSteer, 0.0, 1.0, 1.0 ) );
				else		
					setAnalogControlState( "vehicle_right", 0.0 );
					setAnalogControlState( "vehicle_left", 0.0 );
				end
				
				if _DEBUG and isDebugViewActive() then
					dxDrawText( "this.fSteer = " + tostring( this.fSteer ), 100, 500 );
				end	
			end
		end
	end;
};

function SetCruise( fSpeed )
	Settings.Controls.Cruise = fSpeed;
	
	if fSpeed > 0.0 then
		for sKey, sState in pairs( getBoundKeys( "accelerate" ) ) do
			AnalogControl.sKeyAccelerate	= sKey;
			
			break;
		end
		
		for sKey, sState in pairs( getBoundKeys( "brake_reverse" ) ) do
			AnalogControl.sKeyBrakeReverse	= sKey;
			
			break;
		end
	end
	
	setAnalogControlState( "accelerate", 0.0 );
	setAnalogControlState( "brake_reverse", 0.0 );
	
	toggleControl( "accelerate", fSpeed <= 0.0 );
	toggleControl( "brake_reverse", fSpeed <= 0.0 );
	
	Hint( "Info", "Круиз контроль " + ( fSpeed <= 0 and "выключен" or ( "установлен на %.1f км/ч" ):format( fSpeed ) ), "ok" );
end

addEventHandler( "onClientResourceStart", resourceRoot, AnalogControl.AnalogControl );
