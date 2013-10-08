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
	
	AnalogControl	= function()
		
		
		addEventHandler( "onClientCursorMove", root, AnalogControl.UpdateMouse );
		addEventHandler( "onClientRender", root, AnalogControl.UpdateControl );
	end;
	
	UpdateMouse		= function( fX, fY, fAbsoluteX, fAbsoluteY )
		if Settings.AnalogControl.Enabled == false then return; end
		if isCursorShowing() 			then return; end
		if isMainMenuActive() 			then return; end
		if isConsoleActive() 			then return; end
		if isChatBoxInputActive() 		then return; end
		if getKeyState( "mouse1" )		then return; end
		
		local pVehicle	= CLIENT:GetVehicle();
		
		if pVehicle and pVehicle:GetDriver() == CLIENT then
			fX		= ( fX - .5 ) * 2;
			fY		= ( fY - .5 ) * 2;
			
			AnalogControl.fMouseX		= AnalogControl.fMouseX + ( fX * Settings.AnalogControl.Sensitivity );
			AnalogControl.fMouseY		= AnalogControl.fMouseX + ( fX * Settings.AnalogControl.Sensitivity );
		else
			AnalogControl.fMouseX		= 0.0;
			AnalogControl.fMouseY		= 0.0;
		end
		
		AnalogControl.fMouseX			= Clamp( -1.0, AnalogControl.fMouseX, 1.0 );
		AnalogControl.fMouseY			= Clamp( -1.0, AnalogControl.fMouseY, 1.0 );
	end;
	
	UpdateControl	= function()
		if Settings.AnalogControl.Enabled == false then
			return false;
		end
		
		if AnalogControl.fMouseX > 0.0 then
			setAnalogControlState( "vehicle_right", Easing[ Settings.AnalogControl.EasingOut ]( Easing, AnalogControl.fMouseX ) );
		elseif AnalogControl.fMouseX < 0.0 then
			setAnalogControlState( "vehicle_left", Easing[ Settings.AnalogControl.EasingOut ]( Easing, -AnalogControl.fMouseX ) );
		else
			setAnalogControlState( "vehicle_right", 0.0 );
			setAnalogControlState( "vehicle_left", 0.0 );
		end
	end;
};

addEventHandler( "onClientResourceStart", resourceRoot, AnalogControl.AnalogControl );
