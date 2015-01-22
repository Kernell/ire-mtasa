-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Vehicle : Element
{
	Vehicle		= function( model, position, rotation, plate, variant1, variant2 )
		if not Server.Game.VehicleManager.IsValidModel( model ) then
			error( "invalid vehicle model", 2 );
		end
		
		position 	= position or new. Vector3();
		rotation 	= rotation or new. Vector3();
		plate		= plate or Server.Game.VehicleManager.GetRandomRegPlate();
		
		this = createVehicle( model, position.X, position.Y, position.Z, rotation.X, rotation.Y, rotation.Z, plate, variant1, variant2 )( this );
		
		this.Model			= model;
		this.Variant1		= variant1;
		this.Variant2		= variant2;
		this.RegPlate		= plate;
		
		this.Components		= new. VehicleComponents( this );
		this.Upgrades		= new. VehicleUpgrades( this );
		this.Siren			= new. VehicleSiren( this );
		
		this.ToggleRespawn( false );
		this.SetParent( VehicleManager.Root );
		
		return this;
	end;
	
	_Vehicle	= function()
		delete ( this.Components );
		delete ( this.Upgrades );
		delete ( this.Siren );
		
		this.Components	= NULL;
		this.Upgrades 	= NULL;
		this.Siren 		= NULL;
		
		Server.Game.VehicleManager.RemoveFromList( this );
		
		this.Destroy();
	end;
	
	GetID		= function()
		return this.ID;
	end;
	
	DoPulse		= function( realTime )
		
	end;
	
	RespawnSafe	= function( save )
		this.Spawn( this.DefaultPosition, this.DefaultRotation );
		this.SetInterior( this.DefaultInterior );
		this.SetDimension( this.DefaultDimension );
		this.Fix();
		this.SetFuel( 100.0 );
		this.SetEngineState( false );
		this.SetLights( false );
		this.SetLocked( this.Locked );
		this.SetColor();
		this.Siren.SetState();
		
		if this.ElementData then
			for key, value in pairs( this.ElementData ) do
				this.SetData( key, value );
			end
		end
		
		if save == NULL or save then
			this.Save();
		end
	end;
	
	Save		= function()
		if this.GetID() <= 0 then
			return false;
		end
		
		local position	= this.CharID == 0 and this.DefaultPosition or this.GetPosition();
		local rotation	= this.CharID == 0 and this.DefaultRotation or this.GetRotation();
		
		local panel_states	= {};
		
		for panel = 0, 6 do
			panel_states[ panel ]	= this.GetPanelState( panel );
		end
		
		local door_state	= {};
		
		for door = 0, 5 do
			door_state[ door ]		= this.GetDoorState( door );
		end
		
		local saveFields	=
		{
			position		= position.ToString();
			rotation		= rotation.ToString();
			interior		= this.GetInterior();
			dimension		= this.GetDimension();
			health			= this.GetHealth();
			last_time		= this.LastTime;
			last_driver		= this.LastDriver or NULL;
			locked			= this.Locked and "Yes" or "No";
			engine			= this.Engine and "on" or "off";
			lights			= this.Lights and "on" or "off";
			wheels_states	= toJSON( { this.GetWheelStates() } );
			panel_states	= toJSON( panel_states );
			door_state		= toJSON( door_state );
			fuel			= this.Fuel;
			upgrades		= this.Upgrades.ToJSON() or NULL;
		};
		
		local fields = {};
		
		for key, value in pairs( saveFields ) do
			local sType = type( value );
			
			if sType == "number" then
				table.insert( fields, "`" + key + "` = " + value );
			elseif sType == "string" then
				table.insert( fields, "`" + key + "` = '" + value + "'" );
			elseif value == NULL then
				table.insert( fields, "`" + key + "` = NULL" );
			end
		end
		
		if not Server.DB.Query( "UPDATE " + Server.DB.Prefix + "vehicles SET " + table.concat( fields, ", " ) + " WHERE id = " + this.ID ) then
			Debug( Server.DB.Error(), 1 );
			
			return false;
		end
		
		return true;
	end;
	
	SetCharID	= function( charID )
		this.CharID = charID;
		
		this.SetData( "Vehicle::CharID", this.CharID, true, true );
		
		return true;
	end;
	
	SetOwner	= function( character )
		local charID = character and character.GetID() or 0;
		
		if Server.DB.Query( "UPDATE " + Server.DB.Prefix + "vehicles SET character_id = " + charID + " WHERE id = " + this.ID ) then
			return this.SetCharID( charID );
		else
			Debug( Server.DB.Error(), 1 );
		end
		
		return false;
	end;
	
	SetEngineState	= function( engine )
		this.Engine = (bool)(engine);
		
		return setVehicleEngineState( this, this.Engine );
	end;
	
	SetLocked	= function( locked )
		this.Locked = this.IsLockable() and (bool)(locked);
			
		return setVehicleLocked( this, this.Locked );
	end;
	
	SetLights	= function( lights )
		this.Lights = (bool)(lights);
		
		return setVehicleOverrideLights( this, this.Lights and 2 or 1 );
	end;
	
	GetLights	= function()
		return getVehicleOverrideLights( this ) == 2;
	end;
	
	GenerateRegPlate	= function()
		this.RegPlate = VehicleManager.GetRandomRegPlate();
		
		return this.RegPlate;
	end;
	
	SetRegPlate	= function( plate )
		plate	= ( plate or "NULL" ):sub( 1, 8 );
		
		if this.ID < 0 or Server.DB.Query( "UPDATE " + Server.DB.Prefix + "vehicles SET plate = %q WHERE id = " + this.ID, plate ) then
			this.RegPlate = plate;
			
			setVehiclePlateText( this, plate );
			
			return true;
		
		end
		
		return false;
	end;
	
	RandomizeColor	= function()
		return this.SetColor( VehicleManager.GetRandomColor( this.Model ) );
	end;
	
	SetColor	= function( ... )
		local Args = { ... };
		
		if table.getn( Args ) == 0 then
			this.SetData( "Vehicle::Color", this.Color, true, true );
			
			return setVehicleColor( this, unpack( this.Color ) );
		end
		
		this.Color = Args;
		
		this.SetData( "Vehicle::Color", this.Color, true, true );
		
		return setVehicleColor( this, ... );
	end;
	
	Fix	= function()
		for i = 0, 5 do
			this.SetDoorOpenRatio( i, 0 );
		end
		
		return fixVehicle( this );
	end;
	
	GetColor	= function()
		return getVehicleColor( this, true );
	end;

	GetName		= function()
		return VehicleManager.GetVehicleName( this );
	end;

	GetDriver	= function()
		return getVehicleOccupant( this, 0 );
	end;

	GetTurnVelocity	= function()
		return new. Vector3( getVehicleTurnVelocity( this ) );
	end;

	GetSpeed	= function()
		return this.GetVelocity().Length() * 180.0;
	end;

	IsLockable	= function()
		return VehicleManager.IsModelLockable( this.GetModel() );
	end;
	
	SetRespawnPosition	= function( position, rotation )
		position		= position or new. Vector3();
		rotation		= rotation or new. Vector3();
		
		return setVehicleRespawnPosition( this, position.X, position.Y, position.Z, rotation.X, rotation.Y, rotation.Z );
	end;

	SetTurnVelocity	= function( vector )
		vector = vector or new. Vector3();
		
		return setVehicleTurnVelocity( this, vector.X, vector.Y, vector.Z );
	end;

	Spawn	= function( position, rotation )
		position = position or new. Vector3();
		rotation = rotation or new. Vector3();
		
		return spawnVehicle( this, position.X, position.Y, position.Z, rotation.X, rotation.Y, rotation.Z );
	end;

	Horn	= function( horn )
		if this.Siren.Type ~= 0 then
			if this.HornSound then
				delete ( this.HornSound );
				this.HornSound	= NULL;
			end
			
			if horn then
				this.HornSound = new. Sound( "Resources/Sounds/HornAmbient/police_horn.wav" );
				
				this.HornSound.Loop				= true;
				this.HornSound.Volume			= 0.3;
				this.HornSound.Position			= NULL;
				this.HornSound.AttachedTo		= this;
			--	this.HornSound.MinDistance		= 100.0;
				this.HornSound.MaxDistance		= 200.0;
				
				this.HornSound.Play();
			end
			
			return true;
		else
			local driver = this.GetDriver();
			
			if driver then
				driver.SetControlState( "horn", horn );
				
				return true;
			end
		end
		
		return false;
	end;
	
	AttachTrailer			= function( vehicle )
		return attachTrailerToVehicle( this, vehicle );
	end;
	
	DetachTrailer			= function( vehicle )
		return detachTrailerFromVehicle( this, vehicle or NULL );
	end;
	
	Blow					= function( explode )
		return blowVehicle( this, explode );
	end;
	
	GetController			= function()
		return getVehicleController( this );
	end;
	
	GetDoorState			= function( door )
		return getVehicleDoorState( this, door );
	end;
	
	GetLandingGearDown		= function()
		return getVehicleLandingGearDown( this );
	end;
	
	GetLightState			= function( light )
		return getVehicleLightState( this, light );
	end;
	
	GetMaxPassengers		= function()
		return getVehicleMaxPassengers( this );
	end;
	
	GetOccupant				= function( seat )
		return getVehicleOccupant( this, seat );
	end;
	
	GetOccupants			= function()
		return getVehicleOccupants( this );
	end;
	
	GetOverrideLights		= function()
		return getVehicleOverrideLights( this );
	end;
	
	GetPaintjob				= function()
		return getVehiclePaintjob( this );
	end;
	
	GetPanelState			= function( panel )
		return getVehiclePanelState( this, panel );
	end;
	
	GetTowedByVehicle		= function()
		return getVehicleTowedByVehicle( this );
	end;
	
	GetTowingVehicle		= function()
		return getVehicleTowingVehicle( this );
	end;
	
	GetTurretPosition		= function()
		return new. Vector2( getVehicleTurretPosition( this ) );
	end;
	
	GetType					= function()
		return getVehicleType( this );
	end;
	
	GetWheelStates			= function()
		return getVehicleWheelStates( this );
	end;
	
	GetDoorOpenRatio		= function( door )
		return getVehicleDoorOpenRatio( this, door );
	end;
	
	GetHandling				= function()
		return getVehicleHandling( this );
	end;
	
	IsDamageProof			= function()
		return isVehicleDamageProof( this );
	end;
	
	IsFuelTankExplodable	= function()
		return isVehicleFuelTankExplodable( this );
	end;
	
	IsLocked				= function()
		return isVehicleLocked( this );
	end;
	
	IsOnGround				= function()
		return isVehicleOnGround( this );
	end;
	
	ResetExplosionTime		= function()
		return resetVehicleExplosionTime( this );
	end;
	
	ResetIdleTime			= function()
		return resetVehicleIdleTime( this );
	end;
	
	Respawn					= function()
		return respawnVehicle( this );
	end;
	
	SetDamageProof			= function()
		return setVehicleDamageProof( this );
	end;
	
	SetDirtLevel			= function( level )
		return setVehicleDirtLevel( this );
	end;
	
	SetDoorState			= function( door, state )
		return setVehicleDoorState( this, door, state );
	end;
	
	SetDoorsUndamageable	= function( state )
		return setVehicleDoorsUndamageable( this, state );
	end;
	
	SetFuelTankExplodable	= function( explodable )
		return setVehicleFuelTankExplodable( this, explodable );
	end;
	
	SetIdleRespawnDelay		= function( delay )
		return setVehicleIdleRespawnDelay( this, delay );
	end;
	
	SetLandingGearDown		= function( gearState )
		return setVehicleLandingGearDown( this, gearState );
	end;
	
	SetLightState			= function( light, state )
		return setVehicleLightState( this, light, state );
	end;
	
	SetPaintjob				= function( paintjob )
		return setVehiclePaintjob( this, paintjob );
	end;
	
	SetPanelState			= function( panelID, state )
		return setVehiclePanelState( this, panelID, state );
	end;
	
	SetRespawnDelay			= function( delay )
		return setVehicleRespawnDelay( this, delay );
	end;
	
	SetTurretPosition		= function( position )
		return setVehicleTurretPosition( this, position.X, position.Y );
	end;
	
	SetDoorOpenRatio		= function( door, ratio, time )
		return setVehicleDoorOpenRatio( this, door, ratio, time );
	end;
	
	SetHandling				= function( property, value )
		return setVehicleHandling( this, property, value );
	end;
	
	SetWheelStates			= function( ... )
		return setVehicleWheelStates( this, ... );
	end;
	
	ToggleRespawn			= function( respawn )
		return toggleVehicleRespawn( this, respawn );
	end;
	
	GetDirection			= function()
		return getTrainDirection( this );
	end;
	
	GetTrainSpeed			= function()
		return getTrainSpeed( this );
	end;
	
	GetHeadLightColor		= function()
		return new. Color( getVehicleHeadLightColor( this ) );
	end;
	
	IsTrainDerailable		= function()
		return isTrainDerailable( this );
	end;
	
	IsTrainDerailed			= function()
		return isTrainDerailed( this );
	end;
	
	IsBlown					= function()
		return isVehicleBlown( this );
	end;
	
	IsTaxiLightOn			= function()
		return isVehicleTaxiLightOn( this );
	end;
	
	SetTrainDerailable		= function( state )
		return setTrainDerailable( this, state );
	end;
	
	SetTrainDerailed		= function( state )
		return setTrainDerailed( this, state );
	end;
	
	SetTrainDirection		= function( direction )
		return setTrainDirection( this, direction );
	end;
	
	SetTrainSpeed			= function( speed )
		return setTrainSpeed( this, speed );
	end;
	
	SetHeadLightColor		= function( color )
		return setVehicleHeadLightColor( this, color.R, color.G, color.B );
	end;
	
	SetTaxiLightOn			= function( state )
		return setVehicleTaxiLightOn( this, state );
	end;
	
	GetVariant				= function()
		return getVehicleVariant( this );
	end;
	
	SetVariant				= function( a, b )
		return setVehicleVariant( this, a, b );
	end;
	
	GetEngineState			= function()
		return getVehicleEngineState( this );
	end;
	
	OnModelChange	= function( prevModel, model )
		this.SetHandling( false );
	end;
};