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

class: CVehicle ( CElement, IElementData )
{
	static
	{
		m_pVehicleRoot	= CElement( "CVehicle", "CVehicle" );
	};
	
	m_iID			= 0;
	m_iCharID		= 0;
	m_fFuel			= 0;
	m_sLastDriver	= 0;
	m_iLastTime		= 0;
	m_pSiren		= NULL;
	m_pRadio		= NULL;
--	m_bRadio		= true;
	
	CVehicle		= function( this, iID, iModel, vecPosition, vecRotation, sPlate, iVariant1, iVariant2 )
		if type( iModel ) ~= "number" then
			Error( 3, 2342, "iModel", "number", type( iModel ) );
		end
		
		this = this:Create( iModel, vecPosition, vecRotation, sPlate, iVariant1, iVariant2 );
		
		this.m_iID	= iID;
		
		this:SetID( "vehicle:" + this:GetID() );
		
		this:SetData( "id",				this:GetID(),		true, true );
		this:SetData( "character_id",	this.m_iCharID,		true, true );
		this:SetData( "fuel",			this.m_fFuel,		true, true );
		this:SetData( "last_driver",	this.m_sLastDriver,	true, true );
		this:SetData( "last_time",		this.m_iLastTime,	true, true );
		
		this:ToggleRespawn( false );
		this:SetParent( CVehicle.m_pVehicleRoot );
		
		this:IElementData();
		
		return this;
	end;
	
	_CVehicle	= function( this )
		delete ( this.m_pSiren );
		
		this.m_pSiren = NULL;
		
		delete ( this.m_pRadio );
		
		this.m_pRadio = NULL;
		
		g_pGame:GetVehicleManager():RemoveFromList( this );
		this:Destroy();
	end;
	
	Create		= function( this, iModel, vecPosition, vecRotation, sPlate, iVariant1, iVariant2 )
		if not g_pGame:GetVehicleManager():IsValidModel( iModel ) then
			error( "invalid vehicle model", 2 );
		end
		
		vecPosition 	= vecPosition or Vector3();
		vecRotation 	= vecRotation or Vector3();
		sPlate			= sPlate or g_pGame:GetVehicleManager():GetRandomRegPlate();
	--	iVariant1		= iVariant1 or 255;
	--	iVariant2		= iVariant2 or 255;
		
		if iVariant1 then
			local sVariant1 = type( iVariant1 );
			
			if sVariant1 ~= "number" then error( TEXT_E2342:format( "iVariant1", "number", sVariant1 ), 2 ) end
		end
		
		if iVariant2 then
			local sVariant2 = type( iVariant2 );
			
			if sVariant2 ~= "number" then error( TEXT_E2342:format( "iVariant2", "number", sVariant2 ), 2 ) end
		end
		
		local pElement		= createVehicle( iModel, vecPosition.X, vecPosition.Y, vecPosition.Z, vecRotation.X, vecRotation.Y, vecRotation.Z, sPlate, false, iVariant1, iVariant2 );
		
		pElement( this );
		
		this.m_iModel		= iModel;
		this.m_iVariant1	= iVariant1;
		this.m_iVariant2	= iVariant2;
		this.m_sRegPlate	= sPlate;
		
		return pElement;
	end;
	
	Save		= function( this )
		if this:GetID() <= 0 then
			return false;
		end
		
		local vecPosition	= this:IsRentable() and this:GetOwner() == 0 and this.m_vecDefaultPosition or this:GetPosition();
		local vecRotation	= this:IsRentable() and this:GetOwner() == 0 and this.m_vecDefaultRotation or this:GetRotation();
		local iRentTime		= this:IsRentable() and this:GetRentTime() or 0;
		
		local panel_states	= {};
		
		for iPanel = 0, 6 do
			panel_states[ iPanel ]	= this:GetPanelState( iPanel );
		end
		
		local door_state	= {};
		
		for iDoor = 0, 5 do
			door_state[ iDoor ]		= this:GetDoorState( iDoor );
		end
		
		local aSaveFields	=
		{
			x				= vecPosition.X;
			y				= vecPosition.Y;
			z				= vecPosition.Z;
			rx				= vecRotation.X;
			ry				= vecRotation.Y;
			rz				= vecRotation.Z;
			interior		= this:GetInterior();
			dimension		= this:GetDimension();
			health			= this:GetHealth();
			last_time		= this:GetLastTime();
			last_driver		= this:GetLastDriver() or NULL;
			locked			= this.m_bLocked and "Yes" or "No";
			engine			= this.m_bEngine and "on" or "off";
			lights			= this.m_bLights and "on" or "off";
			wheels_states	= toJSON( { this:GetWheelStates() } );
			panel_states	= toJSON( panel_states );
			door_state		= toJSON( door_state );
			fuel			= this:GetFuel();
			rent_time		= iRentTime;
			upgrades		= this:GetUpgrades():ToJSON() or NULL;
			radio_id		= this.m_pData.m_iRadioID;
			radio_volume	= this.m_pData.m_fRadioVolume;
		};
		
		local aFields = {};
		
		for key, value in pairs( aSaveFields ) do
			local sType = type( value );
			
			if sType == "number" then
				table.insert( aFields, "`" + key + "` = " + value );
			elseif sType == "string" then
				table.insert( aFields, "`" + key + "` = '" + value + "'" );
			elseif value == NULL then
				table.insert( aFields, "`" + key + "` = NULL" );
			end
		end
		
		if not g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET " + table.concat( aFields, ", " ) + " WHERE id = " + this:GetID() ) then
			Debug( g_pDB:Error(), 1 );
		end
		
		return true;
	end;
	
	AttachTrailer			= attachTrailerToVehicle;
	DetachTrailer			= detachTrailerFromVehicle;
	Blow					= blowVehicle;
	GetController			= getVehicleController;
	GetDoorState			= getVehicleDoorState;
	GetLandingGearDown		= getVehicleLandingGearDown;
	GetLightState			= getVehicleLightState;
	GetMaxPassengers		= getVehicleMaxPassengers;
	GetOccupant				= getVehicleOccupant;
	GetOccupants			= getVehicleOccupants;
	GetOverrideLights		= getVehicleOverrideLights;
	GetPaintjob				= getVehiclePaintjob;
	GetPanelState			= getVehiclePanelState;
	GetTowedByVehicle		= getVehicleTowedByVehicle;
	GetTowingVehicle		= getVehicleTowingVehicle;
	GetTurretPosition		= getVehicleTurretPosition;
	GetType					= getVehicleType;
	GetWheelStates			= getVehicleWheelStates;
	GetDoorOpenRatio		= getVehicleDoorOpenRatio;
	GetHandling				= getVehicleHandling;
	IsDamageProof			= isVehicleDamageProof;
	IsFuelTankExplodable	= isVehicleFuelTankExplodable;
	IsLocked				= isVehicleLocked;
	IsOnGround				= isVehicleOnGround;
	ResetExplosionTime		= resetVehicleExplosionTime;
	ResetIdleTime			= resetVehicleIdleTime;
	Respawn					= respawnVehicle;
	SetDamageProof			= setVehicleDamageProof;
	SetDirtLevel			= setVehicleDirtLevel;
	SetDoorState			= setVehicleDoorState;
	SetDoorsUndamageable	= setVehicleDoorsUndamageable;
	SetFuelTankExplodable	= setVehicleFuelTankExplodable;
	SetIdleRespawnDelay		= setVehicleIdleRespawnDelay;
	SetLandingGearDown		= setVehicleLandingGearDown;
	SetLightState			= setVehicleLightState;
	SetPaintjob				= setVehiclePaintjob;
	SetPanelState			= setVehiclePanelState;
	SetRespawnDelay			= setVehicleRespawnDelay;
	SetTurretPosition		= setVehicleTurretPosition;
	SetDoorOpenRatio		= setVehicleDoorOpenRatio;
	SetHandling				= setVehicleHandling;
	SetWheelStates			= setVehicleWheelStates;
	ToggleRespawn			= toggleVehicleRespawn;
	GetDirection			= getTrainDirection;
	GetTrainSpeed			= getTrainSpeed;
	GetHeadLightColor		= getVehicleHeadLightColor;
	IsTrainDerailable		= isTrainDerailable;
	IsTrainDerailed			= isTrainDerailed;
	IsBlown					= isVehicleBlown;
	IsTaxiLightOn			= isVehicleTaxiLightOn;
	SetTrainDerailable		= setTrainDerailable;
	SetTrainDerailed		= setTrainDerailed;
	SetTrainDirection		= setTrainDirection;
	SetTrainSpeed			= setTrainSpeed;
	SetHeadLightColor		= setVehicleHeadLightColor;
	SetTaxiLightOn			= setVehicleTaxiLightOn;
	GetVariant				= getVehicleVariant;
	SetVariant				= setVehicleVariant;
	
	GetEngineState			= getVehicleEngineState;
};

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
	
	self:SetData( "character_id", self.m_iCharID, true, true );
	
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
	
	return setVehicleEngineState( self, self.m_bEngine );
end

function CVehicle:SetLocked( bLocked )
	self.m_bLocked = self:IsLockable() and (bool)(bLocked);
		
	return setVehicleLocked( self, self.m_bLocked );
end

function CVehicle:SetLights( bLights )
	self.m_bLights = (bool)(bLights);
	
	return setVehicleOverrideLights( self, self.m_bLights and 2 or 1 );
end

function CVehicle:GetLights()
	return getVehicleOverrideLights( self ) == 2;
end

function CVehicle:GetLastTime()
	return self.m_iLastTime;
end

function CVehicle:GetLastDriver()
	return self.m_sLastDriver;
end

function CVehicle:GenerateRegPlate()
	self.m_sRegPlate = g_pGame:GetVehicleManager():GetRandomRegPlate();

	return self.m_sRegPlate;
end

function CVehicle:SetRegPlate( sPlate )
	sPlate	= ( sPlate or "NULL" ):sub( 1, 8 );
	
	if self:GetID() < 0 or g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET plate = %q WHERE id = " + self:GetID(), sPlate ) then
		self.m_sRegPlate = sPlate;
		
		setVehiclePlateText( self, sPlate );
		
		return true;
	
	end
	
	return false;
end

function CVehicle:GetRegPlate()
	return self.m_sRegPlate;
end

function CVehicle:RandomizeColor()
	return self:SetColor( g_pGame:GetVehicleManager():GetRandomColor( self.m_iModel ) );
end

function CVehicle:SetColor( ... )
	local Args = { ... };
	
	if #Args == 0 then
		return setVehicleColor( self, unpack( self.m_Color ) );
	end
	
	self.m_Color = Args;
	
	self:SetData ( "color", 		self.m_Color,	true, true );
	
	return setVehicleColor( self, ... );
end

function CVehicle:Fix()
	for i = 0, 5 do
		self:SetDoorOpenRatio( i, 0 );
	end
	
	return fixVehicle( self );
end

function CVehicle:GetColor()
	return getVehicleColor( self, true );
end

function CVehicle:GetName()
	return CVehicleManager:GetVehicleName( self );
end

function CVehicle:GetDriver()
	return getVehicleOccupant( self, 0 );
end

function CVehicle:GetTurnVelocity()
	return Vector3( getVehicleTurnVelocity( self ) );
end

function CVehicle:GetSpeed()
	return self:GetVelocity():Length() * 180.0;
end

function CVehicle:IsLockable()
	return not aNotLockable[ self:GetModel() ];
end

function CVehicle:SetRespawnPosition( vecPosition, vecRotation )
	vecPosition		= vecPosition or Vector3();
	vecRotation		= vecRotation or Vector3();
	
	return setVehicleRespawnPosition( self, vecPosition.X, vecPosition.Y, vecPosition.Z, vecRotation.X, vecRotation.Y, vecRotation.Z );
end

function CVehicle:SetTurnVelocity( pVector )
	pVector = pVector or Vector3();
	
	return setVehicleTurnVelocity( self, pVector.X, pVector.Y, pVector.Z );
end

function CVehicle:Spawn( vecPosition, vecRotation )
	vecPosition = vecPosition or Vector3();
	vecRotation = vecRotation or Vector3();
	
	return spawnVehicle( self, vecPosition.X, vecPosition.Y, vecPosition.Z, vecRotation.X, vecRotation.Y, vecRotation.Z );
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