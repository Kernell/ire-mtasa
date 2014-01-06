-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

-- rpm = wheel rotation rate * gear * differential ratio * 60 / 2p

local Gears =
{
	default	=
	{
		[ -1 ]	= -2.90;
		[ 0 ]	= 0.0;
		[ 1 ]	= 2.66;
		[ 2 ]	= 1.78;
		[ 3 ]	= 1.30;
		[ 4 ]	= 1.0;
		[ 5 ]	= 0.74;
		[ 6 ]	= 0.50;
	};
};

function getAngle2D( fX, fX2 )
	return fX % 360 - fX2 % 360 > 180 and fX % 360 - fX2 % 360 - 360 or fX % 360 - fX2 % 360 < -180 and fX % 360 - fX2 % 360 + 360 or fX % 360 - fX2 % 360;
end

function Distance( fA, fB )
	-- return math.abs( fA - fB ) % 360;
	return math.sin( math.rad( fB - fA ) );
end

function getVehicleWheelAngularVelocity()

end

local gl_fX		= 0;
local gl_iTick	= 0;
local FastestWheelRotation = 0;

class: CVehicleEngine
{
    fTorque			= NULL;
    fPower			= NULL;
	fMass			= 0.0;
    fInertia		= 1.015;
	fBackTorque		= 50.02;
    char_Direction	= 0.0;

    iIdleRPM		= 900;

    iRPM			= 700;
	iMaxRPM			= 10000;
	
	fEfficiency		= 0.8;
	fTopGear		= 3.9;
	iCurrentGear	= 1;
	fGear			=
	{
		[-1 ]	=-4.00; -- задняя
		[ 0 ]	= 0.00; -- нейтраль
		[ 1 ] 	= 3.64; -- первая
		[ 2 ] 	= 1.95; -- вторая
		[ 3 ] 	= 1.36; -- третья
		[ 4 ] 	= 0.94; -- четвёртая
		[ 5 ] 	= 0.78;	-- пятая
	};
	
	fWheelInertia	= 0.1;
	fEngineInertia	= 0.5;
	
	GetTorque = function( this, RPM )
		if	   RPM <= 500 then		return Lerp( 0, 25, 	RPM / 500 );
		elseif RPM <= 1000 then		return Lerp( 25, 35, 	( RPM - 500 ) / 500 );
		elseif RPM <= 1500 then		return Lerp( 35, 55, 	( RPM - 1000 ) / 500 );
		elseif RPM <= 2000 then		return Lerp( 55, 85, 	( RPM - 1500 ) / 500 );
		elseif RPM <= 2500 then		return Lerp( 85, 95, 	( RPM - 2000 ) / 500 );
		elseif RPM <= 3000 then		return Lerp( 95, 105, 	( RPM - 2500 ) / 500 );
		elseif RPM <= 3500 then		return Lerp( 105, 110, 	( RPM - 3000 ) / 500 );
		elseif RPM <= 4000 then		return Lerp( 110, 115, 	( RPM - 3500 ) / 500 );
		elseif RPM <= 4500 then		return Lerp( 115, 115, 	( RPM - 4000 ) / 500 );
		elseif RPM <= 5000 then		return Lerp( 115, 110, 	( RPM - 4500 ) / 500 );
		elseif RPM <= 5500 then		return Lerp( 110, 105, 	( RPM - 5000 ) / 500 );
		elseif RPM <= 6000 then		return Lerp( 105, 100, 	( RPM - 5500 ) / 500 );
		elseif RPM <= 6500 then		return Lerp( 100, 95, 	( RPM - 6000 ) / 500 );
		elseif RPM <= 7000 then		return Lerp( 95, 90, 	( RPM - 6500 ) / 500 );
		elseif RPM <= 7500 then		return Lerp( 90, 80, 	( RPM - 7000 ) / 500 );
		elseif RPM <= 8000 then		return Lerp( 80, 70, 	( RPM - 7500 ) / 500 );
		elseif RPM <= 8500 then		return Lerp( 70, 55, 	( RPM - 8000 ) / 500 );
		elseif RPM <= 9000 then		return Lerp( 55, 40, 	( RPM - 8500 ) / 500 );
		elseif RPM <= 9500 then		return Lerp( 40, 10, 	( RPM - 9000 ) / 500 );
		elseif RPM <= 10000 then	return Lerp( 10, 0, 	( RPM - 9500 ) / 500 );
		end
		
		return 0;
	end;
	
    Process = function( this )
        if this.iRPM < this.iIdleRPM and this.fThrottle < 0.3 then
			this.fThrottle = this.fThrottle + 0.5;
		end
		
        local fTorq			= this.fTorque[ (int)(this.iRPM) ] * this.fThrottle;
		local iAdditionRPM 	= fTorq / this.fInertia - math.pow( 1.0 - this.fThrottle, 2 ) * this.fBackTorque;
		
        this.iRPM			= this.iRPM + ( iAdditionRPM * ( 1.0 - this.fClutch ) );
		
		dxDrawText( "this.iRPM = " .. tostring( this.iRPM ), 500, 500 );
		
		local fToWheelTorq	= fTorq * this.fEfficiency / ( this.fTopGear * this.fGear[ this.iCurrentGear ] );
		
		dxDrawText( "fToWheelTorq = " .. tostring( fToWheelTorq ), 500, 520 );
		
		-- вращение колёс "в моторном расчёте"
		local fWheelRPM		= FastestWheelRotation * this.fTopGear * this.fGear[ this.iCurrentGear ];
		
		local fBaseTorque	= ( fWheelRPM - this.iRPM ) * ( 1.0 - this.fClutch ) / ( this.fWheelInertia + this.fEngineInertia );
		
		local fToEngine		= this.fWheelInertia * fBaseTorque;
		local fToWheels		= this.fEngineInertia * fBaseTorque;
		
		dxDrawText( "fToEngine = " .. tostring( fToEngine ), 500, 540 );
		dxDrawText( "fToWheels = " .. tostring( fToWheels ), 500, 560 );
		
		-- setAnalogControlState( "accelerate", fToWheelTorq );
		
		setSoundSpeed( this.m_pSound, this.iRPM / 5000 );
    end;
	
	CVehicleEngine	= function( this, pVehicle )
		this.m_pVehicle = pVehicle;
		
		this.fTorque	= {};
		
		for i = 0, 12000 do
			this.fTorque[ i ] = this:GetTorque( i );
		end
		
		this.m_pSound	= playSound3D( "Sounds/350Z_onmid.wav", 0.0, 0.0, 0.0, true );
		
		attachElements( this.m_pSound, this.m_pVehicle );
		
		this.fThrottle	= 0.0;
		this.fClutch	= 0.0;
		
		function this.__Process()
			local iTick	= getTickCount();
			local fX	= getVehicleComponentRotation( pVehicle, "wheel_rb_dummy" );
			
			FastestWheelRotation = Distance( gl_fX, fX ) / ( iTick - gl_iTick );
			
			dxDrawText( ( "FastestWheelRotation = %.3f" ):format( FastestWheelRotation ), 500, 200 );
			
			local RPM = FastestWheelRotation * this.iCurrentGear * 1.0 * 60 / ( 2 * math.pi );
			
			dxDrawText( ( "RPM = %05d" ):format( RPM ), 500, 220 );
			
			gl_fX 		= fX;
			gl_iTick	= iTick;
			
			this.fThrottle = getAnalogControlState( "accelerate" );
			
			this:Process();
		end
		
		addEventHandler( "onClientPreRender", root, this.__Process );
	end;
	
	_CVehicleEngine	= function( this )
		removeEventHandler( "onClientPreRender", root, this.__Process );
	end;
};

CVehicleEngine( CLIENT:GetVehicle() );