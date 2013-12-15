-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

AnalogControl = 
{
	fMouseX 	= 0;
	fMouseY 	= 0;
	
	iBrakeTick	= 0;
	
	AnalogControl	= function()
		addEventHandler( "onClientCursorMove", root, AnalogControl.UpdateMouse );
		addEventHandler( "onClientRender", root, AnalogControl.UpdateControl );
	end;
	
	UpdateMouse		= function( fX, fY, fAbsoluteX, fAbsoluteY )
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
			
			AnalogControl.fMouseX		= AnalogControl.fMouseX + ( fX * Settings.Controls.MouseSteering.Sensitivity );
			AnalogControl.fMouseY		= AnalogControl.fMouseX + ( fX * Settings.Controls.MouseSteering.Sensitivity );
		else
			AnalogControl.fMouseX		= 0.0;
			AnalogControl.fMouseY		= 0.0;
		end
		
		AnalogControl.fMouseX			= Clamp( -1.0, AnalogControl.fMouseX, 1.0 );
		AnalogControl.fMouseY			= Clamp( -1.0, AnalogControl.fMouseY, 1.0 );
	end;
	
	UpdateControl	= function()
		local iTick = getTickCount();
		
		if Settings.Controls.Cruise > 0.0 then
			local pVehicle = CLIENT:GetVehicle();
			
			if pVehicle and pVehicle:GetDriver() == CLIENT then
				local bUIShowing	= isCursorShowing() or isMainMenuActive() or isConsoleActive() or isChatBoxInputActive();
				local fSpeed		= pVehicle:GetSpeed();
				
				local bAccelerate	= not bUIShowing and getKeyState( AnalogControl.sKeyAccelerate );
				local bBrakeReverse	= not bUIShowing and getKeyState( AnalogControl.sKeyBrakeReverse );
				
				local fAccelerate	= 0.0;
				local fBrakeReverse	= 0.0;
				
				local fForce = ( Settings.Controls.Cruise - fSpeed ) / Settings.Controls.Cruise;
				
				if fForce >= 0.0 and bAccelerate then
					fAccelerate = getEasingValue( fForce, "OutQuad" );
				elseif fForce < 0.0 and not bBrakeReverse then
					fBrakeReverse = -fForce * 1.5;
				end
				
				if bBrakeReverse then
					if AnalogControl.iBrakeTick == 0 then
						AnalogControl.iBrakeTick = iTick + 2000;
					end
					
					fBrakeReverse = Clamp( 0.25, 1.0 - ( AnalogControl.iBrakeTick - iTick ) / 2000, 1.0 );
				else
					if AnalogControl.iBrakeTick ~= 0 then
						AnalogControl.iBrakeTick = 0;
					end
				end
				
				setAnalogControlState( "accelerate", fAccelerate );
				setAnalogControlState( "brake_reverse", fBrakeReverse );
				
				if _DEBUG then
					dxDrawText( ( "fAccelerate = %.2f" ):format( fAccelerate ), 50, 300 );
					dxDrawText( ( "fBrakeReverse = %.2f" ):format( fBrakeReverse ), 50, 320 );
				end
			end
		end
		
		if Settings.Controls.MouseSteering.Enabled then
			if AnalogControl.fMouseX > 0.0 then
				setAnalogControlState( "vehicle_right", Easing[ Settings.Controls.MouseSteering.EasingOut ]( Easing, AnalogControl.fMouseX ) );
			elseif AnalogControl.fMouseX < 0.0 then
				setAnalogControlState( "vehicle_left", Easing[ Settings.Controls.MouseSteering.EasingOut ]( Easing, -AnalogControl.fMouseX ) );
			else
				setAnalogControlState( "vehicle_right", 0.0 );
				setAnalogControlState( "vehicle_left", 0.0 );
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
