-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local aNotLockable =
{
	[448] = true, [461] = true, [462] = true, [463] = true, [481] = true, [509] = true, [510] = true, [521] = true, [522] = true, [581] = true, [586] = true, -- bikes
	[430] = true, [446] = true, [452] = true, [453] = true, [454] = true, [472] = true, [473] = true, [484] = true, [493] = true, [595] = true, -- boats
	[424] = true, [457] = true, [471] = true, [539] = true, [568] = true, [571] = true -- recreational vehicles
};

local aPoliceVehicles = 
{
	[427] = true; -- Enforcer
	[490] = true; -- FBI Rancher
	[596] = true; -- Police LS
	[597] = true; -- Police SF
	[598] = true; -- Police LV
	[599] = true; -- Police Ranger
};

DEFAULT_VEHICLE_FUEL	= 100.0

class: CVehicle ( CElement )
{
	__instance		= createElement( 'CVehicle', 'CVehicle' );
	m_pSiren		= NULL;
	m_pRadio		= NULL;
	--m_bRadio		= true;
	
	static
	{
		DefaultData	=
		{
			character_id	= 0;
			fuel			= DEFAULT_VEHICLE_FUEL;
			engine			= "on";
			lights			= "off";
			locked			= "No";
			rentable		= "No";
			rent_price		= 0;
			rent_time		= 0;
			last_driver		= "N/A";
			last_time		= 0;
			handling		= NULL;
			upgrades		= NULL;
			panel_states	= NULL;
			door_state		= NULL;
			element_data	= NULL;
			siren			= 0;
			whelen			= 0;
			radio_id		= 0;
			radio_volume	= 1.0;
		};
	};
};

function CVehicle:CVehicle( pVehicleManager, iID, iModel, vecPosition, vecRotation, sPlate, iVariant1, iVariant2, DBField )
	self:CElement();
	
	DBField = DBField or CVehicle.DefaultData;
	
	self.m_pVehicleManager = pVehicleManager;
	
	if iModel and self:Create( iModel, vecPosition, vecRotation, sPlate, iVariant1, iVariant2 ) then
		self.m_pComponents			= CVehicleComponents( self );
		self.m_pUpgrades			= CVehicleUpgrades( self );
		self.m_pSiren				= CVehicleSiren( self, DBField.siren, DBField.whelen );
		
		self.m_pRadio				= new. CSound;
		self.m_pRadio.vecPosition	= vecPosition;
		self.m_pRadio.m_pAttachedTo = self.__instance;
		self.m_pRadio.m_sMemberID	= "m_pRadio";
			
		if VEHICLE_RADIO[ DBField.radio_id ] then
			self.m_pRadio.m_sPath		= VEHICLE_RADIO[ DBField.radio_id ][ 2 ];
			self.m_pRadio.m_fVolume 		= DBField.radio_volume;
			self.m_pRadio.m_fMaxDistance 	= self.m_pRadio.m_fVolume * 100.0;
			
			self.m_pRadio:Play();
		end
		
		self.m_pData.m_iRadioID 	= DBField.radio_id;
		self.m_pData.m_fRadioVolume	= DBField.radio_volume;
		
		local Upgrades		= fromJSON( DBField.upgrades );
		
		if Upgrades then
			for key, value in pairs( Upgrades ) do
				if type( value ) == "number" and value <= 3 then
					self.m_pVehicle:SetPaintjob( value );
				else
					self.m_pUpgrades:Add( value );
				end
			end
		end
		
		local Handling = fromJSON( DBField.handling );
		
		if Handling then
			for key, value in pairs( Handling ) do
				self:SetHandling( key, value );
			end
		end
		
		local PanelStates = fromJSON( DBField.panel_states );
		
		if PanelStates then
			for key, value in pairs( PanelStates ) do
				self:SetPanelState( tonumber( key ), value );
			end
		end
		
		local DoorStates = fromJSON( DBField.door_state );
		
		if DoorStates then
			for key, value in pairs( DoorStates ) do
				self:SetDoorState( tonumber( key ), value );
			end
		end
		
		self:SetID( "vehicle:" + iID );
		
		self.m_iID			= iID;
		self.m_iCharID		= DBField.character_id or 0;
		self.m_fFuel		= DBField.fuel or DEFAULT_VEHICLE_FUEL;
--		self.m_bEngine		= ( DBField.engine or 'on' ) == 'on';
--		self.m_bLights		= ( DBField.lights or 'off' ) == 'on';
--		self.m_bLocked		= ( DBField.locked or 'No' ) == 'Yes';
		self.m_bRentable	= ( DBField.rentable or 'No' ) == 'Yes';
		self.m_iRentPrice	= DBField.rent_price or 0;
		self.m_iRentTime	= DBField.rent_time or 0;
		
		self.m_sLastDriver	= DBField.last_driver or 'N/A';
		self.m_iLastTime	= DBField.last_time or getRealTime().timestamp;
		
		self:SetData ( 'id',			self.m_iID,			true, true );
		self:SetData ( 'character_id',	self.m_iCharID,		true, true );
		self:SetData ( 'fuel',			self.m_fFuel,		true, true );
		self:SetData ( 'last_driver',	self.m_sLastDriver,	true, true );
		self:SetData ( 'last_time',		self.m_iLastTime,	true, true );
		
		self.m_Data = fromJSON( DBField.element_data );
		
		if self.m_Data then
			for key, value in pairs( self.m_Data ) do
				self:SetData( key, value );
			end
		end
		
		self.m_vecDefaultPosition	= DBField and Vector3( DBField.default_x, DBField.default_y, DBField.default_z ) or vecPosition;
		self.m_vecDefaultRotation	= DBField and Vector3( DBField.default_rx, DBField.default_ry, DBField.default_rz ) or vecRotation;
		self.m_iDefaultInterior		= DBField.default_interior or 0;
		self.m_iDefaultDimension	= DBField.default_dimension or 0;
		
		if not self.m_sRegPlate then
			self:GenerateRegPlate();
		end
		
		local Color = fromJSON( DBField.color );
		
		if Color then
			self:SetColor		( unpack( Color ) );
		else
			self:RandomizeColor();
		end
		
		self:SetEngineState		( ( DBField.engine or 'on' ) == 'on' );
		self:SetLights			( ( DBField.lights or 'off' ) == 'on' );
		self:SetLocked			( ( DBField.locked or 'No' ) == 'Yes' );
		self:SetHeadLightColor	( unpack( fromJSON( DBField.lights_color ) or { 255, 255, 255 } ) );
		self:SetWheelStates		( unpack( fromJSON( DBField.wheels_states ) or { 0, 0, 0, 0 } ) );
		self:SetHealth			( Clamp( 300, DBField.health or 1000, 1000 ) );
		
		self:ToggleRespawn( false );
		self:SetParent( CVehicle );
		
		pVehicleManager:AddToList( self );
	else
		self.m_iID			= INVALID_ELEMENT_ID;
	end
end

function CVehicle:_CVehicle()
	delete ( self.m_pSiren );
	
	self.m_pSiren = NULL;
	
	delete ( self.m_pRadio );
	
	self.m_pRadio = NULL;
	
	self.m_pVehicleManager:RemoveFromList( self );
	self:Destroy();
end

function CVehicle:Create( iModel, vecPosition, vecRotation, sPlate, iVariant1, iVariant2 )
	if self.m_pVehicleManager:IsValidModel( iModel ) then
		vecPosition = vecPosition or Vector3();
		vecRotation = vecRotation or Vector3();
		sPlate		= sPlate or self.m_pVehicleManager:GetRandomRegPlate();
--		iVariant1	= iVariant1 or 255;
--		iVariant2	= iVariant2 or 255;
		
		if iVariant1 then
			local sVariant1 = type( iVariant1 );
			
			if sVariant1 ~= 'number' then error( TEXT_E2342:format( 'iVariant1', 'number', sVariant1 ), 2 ) end
		end
		
		if iVariant2 then
			local sVariant2 = type( iVariant2 );
			
			if sVariant2 ~= 'number' then error( TEXT_E2342:format( 'iVariant2', 'number', sVariant2 ), 2 ) end
		end
		
		self.__instance = createVehicle( iModel, vecPosition.X, vecPosition.Y, vecPosition.Z, vecRotation.X, vecRotation.Y, vecRotation.Z, sPlate, false, iVariant1, iVariant2 );
		
		CElement.AddToList( self );
		
		self.m_iModel		= iModel;
		self.m_iVariant1	= iVariant1;
		self.m_iVariant2	= iVariant2;
		self.m_sRegPlate	= sPlate;
		
		return self.__instance;
	end
	
	return false, "Invalid vehicle model '" + (string)(iModel) + "'";
end

function CVehicle:RespawnSafe( bSave )
	self:Spawn( self.m_vecDefaultPosition, self.m_vecDefaultRotation );
	self:SetInterior( self.m_iDefaultInterior );
	self:SetDimension( self.m_iDefaultDimension );
	self:Fix();
	self:SetFuel( 100.0 );
	self:SetEngineState( false );
	self:SetLights( false );
	self:SetLocked( self:GetFaction() and true or self.m_bLocked );
	self:SetColor();
	self.m_pSiren:SetState();
	
	if self.m_Data then
		for key, value in pairs( self.m_Data ) do
			self:SetData( key, value );
		end
	end
	
	if bSave == NULL or bSave then
		self:Save();
	end
end

function CVehicle:GetID()
	return self.m_iID;
end

function CVehicle:GetOwner()
	return self.m_iCharID;
end

function CVehicle:GetUpgrades()
	return self.m_pUpgrades;
end

function CVehicle:SetCharID( iCharID )
	self.m_iCharID = iCharID;
	
	self:SetData( 'character_id', self.m_iCharID, true, true );
	
	return true;
end

function CVehicle:SetOwner( pChar )
	local iCharID = pChar and pChar:GetID() or 0;
	
	if g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET character_id = " + iCharID + " WHERE id = " + self:GetID() ) then
		return self:SetCharID( iCharID );
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	return false;
end

function CVehicle:SetModel( iModel )
	if CElement.SetModel( self, iModel ) then
		self:SetHandling( false );
		
		return true;
	end
	
	return false;
end

function CVehicle:SetEngineState( bEngine )
	self.m_bEngine = (bool)(bEngine);
	
	return setVehicleEngineState( self.__instance, self.m_bEngine );
end

function CVehicle:GetEngineState()
	return getVehicleEngineState( self.__instance );
end

function CVehicle:SetLocked( bLocked )
	self.m_bLocked = self:IsLockable() and (bool)(bLocked);
		
	return setVehicleLocked( self.__instance, self.m_bLocked );
end

function CVehicle:SetLights( bLights )
	self.m_bLights = (bool)(bLights);
	
	return setVehicleOverrideLights( self.__instance, self.m_bLights and 2 or 1 );
end

function CVehicle:GetLights()
	return getVehicleOverrideLights( self.__instance ) == 2;
end

function CVehicle:GetLastTime()
	return self.m_iLastTime;
end

function CVehicle:GetLastDriver()
	return self.m_sLastDriver;
end

function CVehicle:GenerateRegPlate()
	self.m_sRegPlate = self.m_pVehicleManager:GetRandomRegPlate();

	return self.m_sRegPlate;
end

function CVehicle:SetRegPlate( sPlate )
	sPlate	= ( sPlate or "NULL" ):sub( 1, 8 );
	
	if self:GetID() < 0 or g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET plate = %q WHERE id = " + self:GetID(), sPlate ) then
		self.m_sRegPlate = sPlate;
		
		setVehiclePlateText( self.__instance, sPlate );
		
		return true;
	
	end
	
	return false;
end

function CVehicle:GetRegPlate()
	return self.m_sRegPlate;
end

function CVehicle:RandomizeColor()
	return self:SetColor( self.m_pVehicleManager:GetRandomColor( self.m_iModel ) );
end

function CVehicle:SetColor( ... )
	local Args = { ... };
	
	if #Args == 0 then
		return setVehicleColor( self.__instance, unpack( self.m_Color ) );
	end
	
	self.m_Color = Args;
	
	self:SetData ( "color", 		self.m_Color,	true, true );
	
	return setVehicleColor( self.__instance, ... );
end

------------

function CVehicle:AttachTrailer( vTarget )
	return attachTrailerToVehicle( self.__instance, type( vTarget ) == 'table' and vTarget.__instance or vTarget )
end

function CVehicle:DetachTrailer( vTarget )
	return detachTrailerFromVehicle( self.__instance, type( vTarget ) == 'table' and vTarget.__instance or vTarget );
end

function CVehicle:Blow( bExplode )
	return blowVehicle( self.__instance, bExplode == NULL or (bool)(bExplode) );
end

function CVehicle:Fix()
	for i = 0, 5 do
		self:SetDoorOpenRatio( i, 0 );
	end
	
	return fixVehicle( self.__instance );
end

function CVehicle:GetColor()
	return getVehicleColor( self.__instance, true );
end

function CVehicle:GetController()
	return getVehicleController( self.__instance );
end

function CVehicle:GetDoorState( door )
	return getVehicleDoorState( self.__instance, door );
end

function CVehicle:GetLandingGearDown()
	return getVehicleLandingGearDown( self.__instance );
end

function CVehicle:GetLightState( light )
	return getVehicleLightState( self.__instance, light );
end

function CVehicle:GetMaxPassengers()
	return getVehicleMaxPassengers( self.__instance );
end

function CVehicle:GetName()
	return CVehicleManager:GetVehicleName( self.__instance );
end

function CVehicle:GetOccupant( seat )
	return getVehicleOccupant( self.__instance, seat );
end

function CVehicle:GetDriver()
	return getVehicleOccupant( self.__instance, 0 );
end

function CVehicle:GetOccupants()
	return getVehicleOccupants( self.__instance );
end

function CVehicle:GetOverrideLights()
	return getVehicleOverrideLights( self.__instance );
end

function CVehicle:GetPaintjob()
	return getVehiclePaintjob( self.__instance );
end

function CVehicle:GetPanelState( panel )
	return getVehiclePanelState( self.__instance, panel );
end

function CVehicle:GetTowedByVehicle()
	return getVehicleTowedByVehicle( self.__instance );
end

function CVehicle:GetTowingVehicle()
	return getVehicleTowingVehicle( self.__instance );
end

function CVehicle:GetTurnVelocity()
	return Vector3( getVehicleTurnVelocity( self.__instance ) );
end

function CVehicle:GetSpeed()
	return self:GetVelocity():Length() * 180.0;
end

function CVehicle:GetTurretPosition()
	return getVehicleTurretPosition();
end

function CVehicle:GetType()
	return getVehicleType( self.__instance );
end

function CVehicle:GetWheelStates()
	return getVehicleWheelStates( self.__instance );
end

function CVehicle:GetDoorOpenRatio( door )
	return getVehicleDoorOpenRatio( self.__instance, door );
end

function CVehicle:GetHandling()
	return getVehicleHandling( self.__instance );
end

function CVehicle:IsDamageProof()
	return isVehicleDamageProof( self.__instance );
end

function CVehicle:IsFuelTankExplodable()
	return isVehicleFuelTankExplodable( self.__instance );
end

function CVehicle:IsLocked()
	return isVehicleLocked( self.__instance );
end

function CVehicle:IsOnGround()
	return isVehicleOnGround( self.__instance );
end

function CVehicle:ResetExplosionTime()
	return resetVehicleExplosionTime( self.__instance );
end

function CVehicle:ResetIdleTime()
	return resetVehicleIdleTime( self.__instance );
end

function CVehicle:Respawn()
	return respawnVehicle( self.__instance );
end

function CVehicle:SetDamageProof( bool )
	return setVehicleDamageProof( self.__instance, tobool( bool ) );
end

function CVehicle:SetDirtLevel( level )
	return setVehicleDirtLevel( self.__instance, level );
end

function CVehicle:SetDoorState( door, state )
	return setVehicleDoorState( self.__instance, door, state );
end

function CVehicle:SetDoorsUndamageable( state )
	return setVehicleDoorsUndamageable( self.__instance, state );
end

function CVehicle:SetFuelTankExplodable( state )
	return setVehicleFuelTankExplodable( self.__instance, state );
end

function CVehicle:SetIdleRespawnDelay( delay )
	return setVehicleIdleRespawnDelay( self.__instance, delay );
end

function CVehicle:SetLandingGearDown( state )
	return setVehicleLandingGearDown( self.__instance, state );
end

function CVehicle:SetLightState( light, state )
	return setVehicleLightState( self.__instance, light, state );
end

function CVehicle:IsLockable()
	return not aNotLockable[ self:GetModel() ];
end

function CVehicle:SetPaintjob( paintjob )
	return setVehiclePaintjob( self.__instance, paintjob );
end

function CVehicle:SetPanelState( panel, state )
	return setVehiclePanelState( self.__instance, panel, state );
end

function CVehicle:SetRespawnDelay( delay )
	return setVehicleRespawnDelay( self.__instance, delay );
end

function CVehicle:SetRespawnPosition( pos, rot )
	pos = pos or Vector3();
	rot = rot or Vector3();
	
	return setVehicleRespawnPosition( self.__instance, pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z );
end

function CVehicle:SetTurretPosition( X, Y )
	return setVehicleTurretPosition( self.__instance, X, Y );
end

function CVehicle:SetDoorOpenRatio( door, ratio, time )
	return setVehicleDoorOpenRatio( self.__instance, door, ratio, tonumber( time ) or 0 );
end

function CVehicle:SetHandling( key, value )
	return setVehicleHandling( self.__instance, key, value );
end

function CVehicle:SetTurnVelocity( vel )
	vel = vel or Vector3();
	
	return setVehicleTurnVelocity( self.__instance, vel.X, vel.Y, vel.Z );
end

function CVehicle:SetWheelStates( frontLeft, rearLeft, frontRight, rearRight )
	return setVehicleWheelStates( self.__instance, frontLeft, tonumber( rearLeft ) or -1, tonumber( frontRight ) or -1, tonumber( rearRight ) or -1 );
end

function CVehicle:Spawn( pos, rot )
	pos = pos or Vector3();
	rot = rot or Vector3();
	
	return spawnVehicle( self.__instance, pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z );
end

function CVehicle:ToggleRespawn( bool )
	return toggleVehicleRespawn( self.__instance, bool );
end

function CVehicle:GetDirection()
	return getTrainDirection( self.__instance );
end

function CVehicle:GetTrainSpeed()
	return getTrainSpeed( self.__instance );
end

function CVehicle:GetHeadLightColor()
	return getVehicleHeadLightColor( self.__instance );
end

function CVehicle:IsTrainDerailable()
	return isTrainDerailable( self.__instance );
end

function CVehicle:IsTrainDerailed()
	return isTrainDerailed( self.__instance );
end

function CVehicle:IsBlown()
	return isVehicleBlown( self.__instance );
end

function CVehicle:IsTaxiLightOn()
	return isVehicleTaxiLightOn( self.__instance );
end

function CVehicle:SetTrainDerailable( derailable )
	return setTrainDerailable( self.__instance, derailable );
end

function CVehicle:SetTrainDerailed( derailed )
	return setTrainDerailed( self.__instance, derailed );
end

function CVehicle:SetTrainDirection( direction )
	return setTrainDirection( self.__instance, direction );
end

function CVehicle:SetTrainSpeed( speed )
	return setTrainSpeed( self.__instance, speed );
end

function CVehicle:SetHeadLightColor( r, g, b )
	return setVehicleHeadLightColor( self.__instance, r, g, b );
end

function CVehicle:SetTaxiLightOn( LightState )
	return setVehicleTaxiLightOn( self.__instance, LightState );
end

function CVehicle:GetVariant()
	return getVehicleVariant( self.__instance );
end

function CVehicle:SetVariant( variant1, variant2 )
	return setVehicleVariant( self.__instance, variant1, variant2 );
end

function CVehicle:IsPolice()
	return aPoliceVehicles[ self:GetModel() ];
end

function CVehicle:GetFaction() -- TODO: m_pFaction
	return g_pGame:GetFactionManager():Get( -self:GetOwner() );
end

function CVehicle:SetFaction( pFaction ) -- TODO: m_pFaction
	if pFaction then
		if g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET character_id = " + -pFaction:GetID() + " WHERE id = " + self:GetID() ) then
			self:SetCharID( -pFaction:GetID() );
			
			return true;
		else
			Debug( g_pDB:Error(), 1 );
		end
	end
	
	return false;
end

function CVehicle:Horn( bHorn )
	if self.m_pSiren.m_iType ~= 0 then
		if self.m_pHornSound then
			delete ( self.m_pHornSound );
			self.m_pHornSound	= NULL;
		end
		
		if bHorn then
			self.m_pHornSound = CSound( "Resources/Sounds/HornAmbient/police_horn.wav" );
			
			self.m_pHornSound.m_bLoop			= true;
			self.m_pHornSound.m_fVolume			= 0.3;
			self.m_pHornSound.m_vecPosition		= NULL;
			self.m_pHornSound.m_pAttachedTo		= self;
		--	self.m_pHornSound.m_fMinDistance	= 100.0;
			self.m_pHornSound.m_fMaxDistance	= 200.0;
			
			self.m_pHornSound:Play();
		end
		
		return true;
	else
		local pDriver = self:GetDriver();
		
		if pDriver then
			pDriver:SetControlState( "horn", bHorn );
			
			return true;
		end
	end
	
	return false;
end

function CVehicle:Save()
	if self:GetID() > 0 and self:GetID() ~= INVALID_ELEMENT_ID then
		local pos			= self:IsRentable() and self:GetOwner() == 0 and self.m_vecDefaultPosition or self:GetPosition();
		local rot			= self:IsRentable() and self:GetOwner() == 0 and self.m_vecDefaultRotation or self:GetRotation();
		local int			= self:GetInterior();
		local dim			= self:GetDimension();
		local health		= self:GetHealth();
		local last_time 	= self:GetLastTime();
		local last_driver	= self:GetLastDriver() and ( "'" + self:GetLastDriver() + "'" ) or 'NULL';
		local locked		= self.m_bLocked and 'Yes' or 'No';
		local engine		= self.m_bEngine and 'on' or 'off';
		local lights		= self.m_bLights and 'on' or 'off';
		local iRentTime		= self:IsRentable() and self:GetRentTime() or 0;
		
		local wheels_states	= toJSON( { self:GetWheelStates() } );
		local panel_states	= {};
		
		for panel = 0, 6 do
			panel_states[ panel ] = self:GetPanelState( panel );
		end
		
		panel_states = toJSON( panel_states );
		
		local door_state	= {};
		
		for door = 0, 5 do
			door_state[ door ] = self:GetDoorState( door );
		end
		
		door_state = toJSON( door_state );
		
		local sUpgrades	= self:GetUpgrades():ToJSON();
		
		if sUpgrades then
			sUpgrades = "'" + sUpgrades + "'";
		else
			sUpgrades = "NULL";
		end
		
		local radio_id		= self.m_pData.m_iRadioID;
		local radio_volume	= self.m_pData.m_fRadioVolume;
		
		local query = ( "UPDATE " + DBPREFIX + "vehicles SET x = %f, y = %f, z = %f, rx = %f, ry = %f, rz = %f, interior = %d, dimension = %d, health = %d, last_time = %d, last_driver = %s, locked = %q, engine = %q, lights = %q, wheels_states = %q, panel_states = %q, door_state = %q, fuel = %d, rent_time = %d, upgrades = %s, radio_id = %d, radio_volume = %f WHERE id = " + self:GetID() ):format( pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z, int, dim, health, last_time, last_driver, locked, engine, lights, wheels_states, panel_states, door_state, self:GetFuel(), iRentTime, sUpgrades, radio_id, radio_volume );
		
		if not g_pDB:Query( query ) then
			Debug( g_pDB:Error(), 1 );
		end
		
		return true;
	end
	
	return false;
end