-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Vehicle : Element
{
	enum "eVehicleWiperState"
	{
		VEHICLE_WIPER_DISABLED	= 0;
		VEHICLE_WIPER_SLOW		= 1;
		VEHICLE_WIPER_FAST		= 2;
	};
	
	ID					= 0;
	
	Aerodynamics		= 0.0;
	
	WiperTime			= 0;
	WiperProgress		= 0.0;
	WiperState			= VEHICLE_WIPER_DISABLED;
	WiperTime			= 5000;
	WiperTickEnd		= 0;
	
	Vehicle		= function( element )
		this = element( this );
		
		this.ID	= this.GetData( "Vehicle::ID" );
		
		this.SetWiperState( this.GetData( "Vehicle::WiperState" ) );
	
		return this;
	end;
	
	_Vehicle	= function()
		
	end;
	
	GetID	= function()
		return this.ID;
	end;
	
	SetWiperState	= function( wiperState )
		this.WiperState	= (int)(wiperState);
		this.WiperTime	= 2500;
		
		if this.WiperState == VEHICLE_WIPER_FAST then
			this.WiperTime	= 1500;
		end
		
		this.WiperTickEnd = getTickCount() + ( this.WiperTime * ( 1.0 - this.WiperProgress ) );
	end;
	
	SetComponentPosition	= function( vehicleComponent, position, base )
		return setVehicleComponentPosition( this, vehicleComponent, position.X, position.Y, position.Z, base );
	end;
	
	SetComponentRotation	= function( vehicleComponent, rotation, base )
		return setVehicleComponentRotation( this, vehicleComponent, rotation.X, rotation.Y, rotation.Z, base );
	end;
	
	GetComponentPosition	= function( vehicleComponent, base )
		return new. Vector3( getVehicleComponentPosition( this, vehicleComponent, base ) );
	end;
	
	GetComponentRotation	= function( vehicleComponent, base )
		return new. Vector3( getVehicleComponentRotation( this, vehicleComponent, base ) );
	end;
	
	GetDriver	= function()
		return getVehicleOccupant( this, 0 );
	end;
	
	GetSpeed	= function()
		local x, y, z = getElementVelocity( this );
		
		return ( ( x ^ 2 + y ^ 2 + z ^ 2 ) ^ 0.5 ) * 180.0;
	end;
	
	SetGravity	= function( x, y, z )
		return setVehicleGravity( this, x, y, z );
	end;
	
	GetGravity	= function()
		return getVehicleGravity( this );
	end;
	
	GetComponents			= function()
		return getVehicleComponents( this );
	end;
	
	GetComponentVisible		= function( componentName )
		return getVehicleComponentVisible( this, componentName );
	end;
	
	IsComponentVisible		= function( componentName )
		return getVehicleComponentVisible( this, componentName );
	end;
	
	SetComponentVisible		= function( componentName, visible )
		return setVehicleComponentVisible( this, componentName, visible );
	end;
	
	ResetComponentRotation	= function( componentName )
		return resetVehicleComponentRotation( this, componentName );
	end;
	
	ResetComponentPosition	= function( componentName )
		return resetVehicleComponentPosition( this, componentName );
	end;
	
	GetName 				= function()
		return getVehicleName( this );
	end;
	
	GetType 				= function()
		return getVehicleType( this );
	end;
	
	GetOccupant				= function( seat )
		return getVehicleOccupant( this, seat );
	end;
	
	SetColor				= function( ... )
		return setVehicleColor( this, ... );
	end;
	
	GetDoorState			= function( door )
		return getVehicleDoorState( this, door );
	end;
	
	GetPanelState			= function( panel )
		return getVehiclePanelState( this, panel );
	end;
	
	SetLightState			= function( light, state )
		return setVehicleLightState( this, light, state );
	end;
	
	-- events
	
	DoPulse		= function( deltaTime )
		if this.IsOnScreen() and this.GetHealth() > 100.0 then
			this.Aerodynamics = 0.0;
			
			if this.GetModel() == 520 then
				this.Aerodynamics = 0.5;
			end
			
			local x, y, z	= getElementVelocity( this );
			local gravity	= -1.0 - ( ( x * x + y * y + z * z ) * this.Aerodynamics );
			
			this.SetGravity( 0.0, 0.0, gravity );
		end
	end;
	
	OnCollision	= function( hitElement, force )
		if force > 300 and CLIENT.GetVehicle() == this and this.GetType() == "Automobile" and not CLIENT.GetData( "Player::IsAdmin" ) then
			local health = CLIENT.GetHealth();
			
			if health > 0 then
				CLIENT.SetHealth( math.max( health - ( force * 0.063 ), 0 ) );
			end
		end
	end;
	
	OnRespawn	= function()
		
	end;
	
	OnDestroy	= function()
	
	end;
	
	OnStreamIn	= function()
		local color = this.GetData( "Vehicle::Color" );
		
		if color then
			this.SetColor( unpack( color ) );
		end
	end;
	
	OnStreamOut	= function()
		
	end;
	
	OnDataChange	= function( name, oldValue )
		if name == "Vehicle::WiperState" then
			this.SetWiperState( this.GetData( name ) );
		else
			local componentName = name:match( "VehicleComponents-->([A-Za-z0-9_]+)" );
			
			if componentName then
				this.UpdateComponent( componentName );
			end
		end
	end;
};
