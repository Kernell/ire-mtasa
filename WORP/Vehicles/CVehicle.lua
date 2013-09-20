-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local gl_Components	= 
{
--	caliper_rf		= { m_bVisible = true; };
--	caliper_lf		= { m_bVisible = true; };
--	caliper_rb		= { m_bVisible = true; };
--	caliper_lb		= { m_bVisible = true; };
	
	WIPER_R			= { m_bVisible = true; m_fMaxAngle = 87.5; };
	WIPER_L			= { m_bVisible = true; m_fMaxAngle = 85.0; };
	
	WIPER_R2		= { m_bVisible = true; m_fMaxAngle = -87.5; };
	WIPER_L2		= { m_bVisible = true; m_fMaxAngle = -85.0; };
	
	stwheel_ok		= { m_bVisible = true; };
	
	speedo_needle_ok= { m_bVisible = true; };
	
	indicator_left	= { m_bVisible = false; };
	indicator_right	= { m_bVisible = false; };
	
	FLASHLIGHT		= { m_bVisible = false; };
	ANTENNA			= { m_bVisible = false; };
	
	WHELEN_A		= { m_bVisible = false; };
	WHELEN_A_EXT	= { m_bVisible = false; };
	WHELEN_A_1		= { m_bVisible = false; };
	WHELEN_A_2		= { m_bVisible = false; };
	WHELEN_A_3		= { m_bVisible = false; };
	WHELEN_A_4		= { m_bVisible = false; };
	WHELEN_A_5		= { m_bVisible = false; };
	WHELEN_A_6		= { m_bVisible = false; };
	WHELEN_A_7		= { m_bVisible = false; };
	WHELEN_A_8		= { m_bVisible = false; };
	
	WHELEN_B		= { m_bVisible = false; };
	WHELEN_B_EXT	= { m_bVisible = false; };
	WHELEN_B_1		= { m_bVisible = false; };
	WHELEN_B_2		= { m_bVisible = false; };
	WHELEN_B_3		= { m_bVisible = false; };
	WHELEN_B_4		= { m_bVisible = false; };
	WHELEN_B_5		= { m_bVisible = false; };
	WHELEN_B_6		= { m_bVisible = false; };
	WHELEN_B_7		= { m_bVisible = false; };
	WHELEN_B_8		= { m_bVisible = false; };
	
	WHELEN_C		= { m_bVisible = false; };
	WHELEN_C_EXT	= { m_bVisible = false; };
	WHELEN_C_1		= { m_bVisible = false; };
	WHELEN_C_2		= { m_bVisible = false; };
	WHELEN_C_3		= { m_bVisible = false; };
	WHELEN_C_4		= { m_bVisible = false; };
	WHELEN_C_5		= { m_bVisible = false; };
	WHELEN_C_6		= { m_bVisible = false; };
	WHELEN_C_7		= { m_bVisible = false; };
	WHELEN_C_8		= { m_bVisible = false; };
	
	SPOILER_0		= { m_bVisible = true; 	m_fAerodynamics = 0.1; };
	SPOILER_1		= { m_bVisible = false; m_fAerodynamics = 0.2; };
	SPOILER_2		= { m_bVisible = false; m_fAerodynamics = 0.2; };
	SPOILER_3		= { m_bVisible = false; m_fAerodynamics = 0.2; };
	SPOILER_4		= { m_bVisible = false; m_fAerodynamics = 0.2; };
	SPOILER_5		= { m_bVisible = false; m_fAerodynamics = 0.2; };
	SPOILER_6		= { m_bVisible = false; m_fAerodynamics = 0.2; };
	SPOILER_7		= { m_bVisible = false; m_fAerodynamics = 0.2; };
	SPOILER_8		= { m_bVisible = false; m_fAerodynamics = 0.2; };
	SPOILER_9		= { m_bVisible = false; m_fAerodynamics = 0.2; };
	SPOILER_10		= { m_bVisible = false; m_fAerodynamics = 0.2; };
	
	SSKIRT_0		= { m_bVisible = true;	m_fAerodynamics = 0.00; };
	SSKIRT_1		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	SSKIRT_2		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	SSKIRT_3		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	SSKIRT_4		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	SSKIRT_5		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	SSKIRT_6		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	SSKIRT_7		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	SSKIRT_8		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	SSKIRT_9		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	SSKIRT_10		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	
	bump_front_dummy= { m_bVisible = true;  m_fAerodynamics = 0.0; };
	FBUMP_1			= { m_bVisible = false; m_fAerodynamics = 0.1; };
	FBUMP_2			= { m_bVisible = false; m_fAerodynamics = 0.1; };
	FBUMP_3			= { m_bVisible = false; m_fAerodynamics = 0.1; };
	FBUMP_4			= { m_bVisible = false; m_fAerodynamics = 0.1; };
	FBUMP_5			= { m_bVisible = false; m_fAerodynamics = 0.1; };
	FBUMP_6			= { m_bVisible = false; m_fAerodynamics = 0.1; };
	FBUMP_7			= { m_bVisible = false; m_fAerodynamics = 0.1; };
	FBUMP_8			= { m_bVisible = false; m_fAerodynamics = 0.1; };
	FBUMP_9			= { m_bVisible = false; m_fAerodynamics = 0.1; };
	FBUMP_10		= { m_bVisible = false; m_fAerodynamics = 0.1; };
	
	bump_rear_dummy	= { m_bVisible = true;  m_fAerodynamics = 0.00; };
	RBUMP_1			= { m_bVisible = false; m_fAerodynamics = 0.01; };
	RBUMP_2			= { m_bVisible = false; m_fAerodynamics = 0.01; };
	RBUMP_3			= { m_bVisible = false; m_fAerodynamics = 0.01; };
	RBUMP_4			= { m_bVisible = false; m_fAerodynamics = 0.01; };
	RBUMP_5			= { m_bVisible = false; m_fAerodynamics = 0.01; };
	RBUMP_6			= { m_bVisible = false; m_fAerodynamics = 0.01; };
	RBUMP_7			= { m_bVisible = false; m_fAerodynamics = 0.01; };
	RBUMP_8			= { m_bVisible = false; m_fAerodynamics = 0.01; };
	RBUMP_9			= { m_bVisible = false; m_fAerodynamics = 0.01; };
	RBUMP_10		= { m_bVisible = false; m_fAerodynamics = 0.01; };
	
	bonnet_dummy	= { m_bVisible = true;  m_fAerodynamics = 0.00; };
	BONNET_1		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	BONNET_2		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	BONNET_3		= { m_bVisible = false; m_fAerodynamics = 0.05; };
	BONNET_4		= { m_bVisible = false; m_fAerodynamics = 0.05; };
};

function gl_Components.SPOILER_0:Update( pVehicle )
	if pVehicle:GetDoorState( 1 ) ~= 4 then
		local fX, fY, fZ	= getVehicleComponentRotation( pVehicle, "boot_dummy" );
		
		if fX and fY and fZ then
			setVehicleComponentRotation( pVehicle, self, fX, fY, fZ );
		end
	else
		pVehicle:SetComponentVisible( self, false );
	end
end

gl_Components.SPOILER_1.Update 	= gl_Components.SPOILER_0.Update;
gl_Components.SPOILER_2.Update 	= gl_Components.SPOILER_0.Update;
gl_Components.SPOILER_3.Update 	= gl_Components.SPOILER_0.Update;
gl_Components.SPOILER_4.Update 	= gl_Components.SPOILER_0.Update;
gl_Components.SPOILER_5.Update 	= gl_Components.SPOILER_0.Update;
gl_Components.SPOILER_6.Update 	= gl_Components.SPOILER_0.Update;
gl_Components.SPOILER_7.Update 	= gl_Components.SPOILER_0.Update;
gl_Components.SPOILER_8.Update 	= gl_Components.SPOILER_0.Update;
gl_Components.SPOILER_9.Update 	= gl_Components.SPOILER_0.Update;
gl_Components.SPOILER_10.Update	= gl_Components.SPOILER_0.Update;

function gl_Components.FBUMP_1:Update( pVehicle )
	if pVehicle:GetPanelState( 5 ) == 0 then
		local fX, fY, fZ	= getVehicleComponentRotation( pVehicle, "bump_front_dummy" );
		
		if fX and fY and fZ then
			setVehicleComponentRotation( pVehicle, self, fX, fY, fZ );
		end
	else
		pVehicle:SetComponentVisible( self, false );
	end
end

gl_Components.FBUMP_2.Update 	= gl_Components.FBUMP_1.Update;
gl_Components.FBUMP_3.Update 	= gl_Components.FBUMP_1.Update;
gl_Components.FBUMP_4.Update 	= gl_Components.FBUMP_1.Update;
gl_Components.FBUMP_5.Update 	= gl_Components.FBUMP_1.Update;
gl_Components.FBUMP_6.Update 	= gl_Components.FBUMP_1.Update;
gl_Components.FBUMP_7.Update 	= gl_Components.FBUMP_1.Update;
gl_Components.FBUMP_8.Update 	= gl_Components.FBUMP_1.Update;
gl_Components.FBUMP_9.Update 	= gl_Components.FBUMP_1.Update;
gl_Components.FBUMP_10.Update 	= gl_Components.FBUMP_1.Update;

function gl_Components.RBUMP_1:Update( pVehicle )
	if pVehicle:GetPanelState( 6 ) == 0 then
		local fX, fY, fZ	= getVehicleComponentRotation( pVehicle, "bump_rear_dummy" );
		
		if fX and fY and fZ then
			setVehicleComponentRotation( pVehicle, self, fX, fY, fZ );
		end
	else
		pVehicle:SetComponentVisible( self, false );
	end
end

gl_Components.RBUMP_2.Update 	= gl_Components.RBUMP_1.Update;
gl_Components.RBUMP_3.Update 	= gl_Components.RBUMP_1.Update;
gl_Components.RBUMP_4.Update 	= gl_Components.RBUMP_1.Update;
gl_Components.RBUMP_5.Update 	= gl_Components.RBUMP_1.Update;
gl_Components.RBUMP_6.Update 	= gl_Components.RBUMP_1.Update;
gl_Components.RBUMP_7.Update 	= gl_Components.RBUMP_1.Update;
gl_Components.RBUMP_8.Update 	= gl_Components.RBUMP_1.Update;
gl_Components.RBUMP_9.Update 	= gl_Components.RBUMP_1.Update;
gl_Components.RBUMP_10.Update 	= gl_Components.RBUMP_1.Update;

function gl_Components.BONNET_1:Update( pVehicle )
	if pVehicle:GetDoorState( 0 ) ~= 4 then
		local fX, fY, fZ	= getVehicleComponentRotation( pVehicle, "bonnet_dummy" );
		
		if fX and fY and fZ then
			setVehicleComponentRotation( pVehicle, self, fX, fY, fZ );
		end
	else
		pVehicle:SetComponentVisible( self, false );
	end
end

gl_Components.BONNET_2.Update 	= gl_Components.BONNET_1.Update;
gl_Components.BONNET_3.Update 	= gl_Components.BONNET_1.Update;
gl_Components.BONNET_4.Update 	= gl_Components.BONNET_1.Update;

function gl_Components.WIPER_R:Update( pVehicle, iTick )
	if pVehicle.m_iWiperState ~= VEHICLE_WIPER_DISABLED or pVehicle.m_fWiperProgress > 0.0 then
		pVehicle.m_fWiperProgress = 1.0 - ( pVehicle.m_iWiperTickEnd - iTick ) / pVehicle.m_iWiperTime;
		
		local fValue	= getEasingValue( Clamp( 0.0, pVehicle.m_fWiperProgress, 1.0 ), "SineCurve" );
		
		setVehicleComponentRotation( pVehicle, self, 0.0, 0.0, gl_Components[ self ].m_fMaxAngle * fValue );
		
		if pVehicle.m_fWiperProgress >= 1.0 then
			if  pVehicle.m_iWiperState == VEHICLE_WIPER_SLOW then
				pVehicle.m_iWiperTickEnd = iTick + pVehicle.m_iWiperTime + 1000;
			else
				pVehicle.m_iWiperTickEnd = iTick + pVehicle.m_iWiperTime;
			end
		end
	end
end

gl_Components.WIPER_L.Update	= gl_Components.WIPER_R.Update;
gl_Components.WIPER_L2.Update	= gl_Components.WIPER_R.Update;
gl_Components.WIPER_R2.Update	= gl_Components.WIPER_R.Update;

function gl_Components.speedo_needle_ok:Update( pVehicle )
	setVehicleComponentRotation( pVehicle, self, 0.0, -( pVehicle:GetSpeed() * 0.621371192 ), 0.0 );
end

function gl_Components.stwheel_ok:Update( pVehicle )
	local fAngle	= 0.0;
	
	local pDriver = pVehicle:GetDriver();
	
	if pDriver then
		if pDriver == CLIENT and Settings.AnalogControl.Enabled and AnalogControl then
			fAngle = -AnalogControl.fMouseX;
		else
			local fLeft		= getPedAnalogControlState( pDriver, "vehicle_left" ) or 0.0;
			local fRight	= getPedAnalogControlState( pDriver, "vehicle_right" ) or 0.0;
			
			if fLeft > 0.0 then
				fAngle = Easing[ Settings.AnalogControl.EasingIn ]( Easing, fLeft );
			end
			
			if fRight > 0.0 then
				fAngle = -Easing[ Settings.AnalogControl.EasingIn ]( Easing, fRight );
			end
			
			if fLeft > 0.0 and fRight > 0.0 then
				fAngle = 0.0;
			end
		end
	end
	
	setVehicleComponentRotation( pVehicle, self, 0.0, Settings.AnalogControl.Angle * fAngle, 0.0 );
end

--[[ function gl_Components.caliper_rf:Update( pVehicle )
	pVehicle:SetComponentPosition( self, pVehicle:GetComponentPosition( "wheel_rf_dummy" ) );
	
	local vecRotation = pVehicle:GetComponentRotation( "wheel_rf_dummy" );
	
	vecRotation.X = 0;
	-- vecRotation.Y = 0;
	-- vecRotation.Z = -vecRotation.Z;
	
	pVehicle:SetComponentRotation( self, vecRotation );
end

function gl_Components.caliper_lf:Update( pVehicle )
	pVehicle:SetComponentPosition( self, pVehicle:GetComponentPosition( "wheel_lf_dummy" ) );
	
	local vecRotation = pVehicle:GetComponentRotation( "wheel_lf_dummy" );
	
	vecRotation.X = 0;
	-- vecRotation.Y = 0;
	-- vecRotation.X = -vecRotation.X;
	-- vecRotation.Y = -vecRotation.Y;
	
	pVehicle:SetComponentRotation( self, vecRotation );
end

function gl_Components.caliper_rb:Update( pVehicle )
	pVehicle:SetComponentPosition( self, pVehicle:GetComponentPosition( "wheel_rb_dummy" ) );
	
	local vecRotation = pVehicle:GetComponentRotation( "wheel_rb_dummy" );
	
	vecRotation.X = 0;
	-- vecRotation.Y = 0;
	
	pVehicle:SetComponentRotation( self, vecRotation );
end

function gl_Components.caliper_lb:Update( pVehicle )
	pVehicle:SetComponentPosition( self, pVehicle:GetComponentPosition( "wheel_lb_dummy" ) );
	
	local vecRotation = pVehicle:GetComponentRotation( "wheel_lb_dummy" );
	
	vecRotation.X = 0;
	-- vecRotation.Y = 0;
	
	pVehicle:SetComponentRotation( self, vecRotation );
end ]]

DEFAULT_VEHICLE_HEALTH		= 1000

enum "eVehicleWiperState"
{
	VEHICLE_WIPER_DISABLED	= 0;
	VEHICLE_WIPER_SLOW		= 1;
	VEHICLE_WIPER_FAST		= 2;
};

class: CVehicle ( CElement )
{
	static
	{
		m_pRoot				= getElementByID "CVehicle";
		m_fUnit				= 879.66625976563 / 1000.0;
	};
	
	m_iWiperState			= VEHICLE_WIPER_DISABLED;
	m_fWiperProgress		= 0.0;
	m_iWiperTime			= 5000;
	m_iWiperTickEnd			= 0;
	m_fAerodynamics			= 0.0;
	
	GetComponents			= getVehicleComponents;
	GetComponentVisible		= getVehicleComponentVisible;
	SetComponentVisible		= setVehicleComponentVisible;
	ResetComponentRotation	= resetVehicleComponentRotation;
	ResetComponentPosition	= resetVehicleComponentPosition;
	IsComponentVisible		= getVehicleComponentVisible;
	GetName 				= getVehicleName;
	GetType 				= getVehicleType;
	GetOccupant				= getVehicleOccupant;
	SetColor				= setVehicleColor;
	GetDoorState			= getVehicleDoorState;
	GetPanelState			= getVehiclePanelState;
	
	SetLightState			= setVehicleLightState;
	SetGravity				= setVehicleGravity;
};

function CVehicle:GetDriver()
	return getVehicleOccupant( self.__instance, 0 );
end

function CVehicle:GetFakeVelocity()
	local vecRotation = self:GetRotation();
	
	vecRotation.X	= -math.sin( vecRotation.Z );
	vecRotation.Y	= math.cos( vecRotation.Z );
	vecRotation.Z	= 0;
	
	return vecRotation;
end

function CVehicle:GetSpeed()
	local fX, fY, fZ = getElementVelocity( self );
	
	return ( ( fX ^ 2 + fY ^ 2 + fZ ^ 2 ) ^ 0.5 ) * 180.0;
end

function CVehicle:CVehicle( pVehicle )
	self.__instance		= pVehicle;
	
	local Components = getVehicleComponents( pVehicle );
	
	if Components then
		for sVehicleComponent, pDefaultData in pairs( gl_Components ) do
			setVehicleComponentVisible( pVehicle, sVehicleComponent, (bool)(pDefaultData.m_bVisible) );
		end
	end
end

function CVehicle.SetComponentPosition( sVehicleComponent, vecPosition )
	return setVehicleComponentPosition( self, sVehicleComponent, vecPosition.X, vecPosition.Y, vecPosition.Z );
end

function CVehicle:SetComponentRotation( sVehicleComponent, vecRotation )
	return setVehicleComponentRotation( self, sVehicleComponent, vecRotation.X, vecRotation.Y, vecRotation.Z );
end

function CVehicle:GetComponentPosition( sVehicleComponent )
	return Vector3( getVehicleComponentPosition( self, sVehicleComponent ) );
end

function CVehicle:GetComponentRotation( sVehicleComponent )
	return Vector3( getVehicleComponentRotation( self, sVehicleComponent ) );
end

function CVehicle:UpdateComponents()
	for sComponent in pairs( gl_Components ) do		self:UpdateComponent( sComponent );
	end
end

function CVehicle:UpdateComponent( sComponent )
	local pData = self:GetData( "CVehicleComponents->" + sComponent ) or gl_Components[ sComponent ];
	
	self:SetComponentVisible( sComponent, (bool)(pData.m_bVisible) );
	
	if pData.m_vecPosition then
		self:SetComponentPosition( sComponent, pData.m_vecPosition );
	end
	
	if pData.m_vecRotation then
		self:SetComponentRotation( sComponent, pData.m_vecRotation );
	end
end

function CVehicle:Update()
	local fX, fY		= getElementVelocity( self );
	
	self:SetGravity( 0.0, 0.0, -1.0 - ( ( fX * fX + fY * fY ) * self.m_fAerodynamics ) );
end

function CVehicle:SetWiperState( iWiperState )
	self.m_iWiperState	= (int)(iWiperState);
	self.m_iWiperTime	= 2500;
	
	if self.m_iWiperState == VEHICLE_WIPER_FAST then
		self.m_iWiperTime	= 1500;
	end
	
	self.m_iWiperTickEnd = getTickCount() + ( self.m_iWiperTime * ( 1.0 - self.m_fWiperProgress ) );
	
	return true;
end

addEventHandler( "onClientPreRender", root,
	function()
		local iTick = getTickCount();
		
		for i, pVehicle in pairs( getElementsByType( "vehicle", root, true ) ) do
			if pVehicle:IsOnScreen() and pVehicle:GetHealth() > 100.0 then
				pVehicle.m_fAerodynamics = 0.0;
				
				for sVehicleComponent, pVehicleComponent in pairs( gl_Components ) do
					if pVehicleComponent.Update and pVehicle:IsComponentVisible( sVehicleComponent ) then
						pVehicleComponent.Update( sVehicleComponent, pVehicle, iTick );
						
						if pVehicleComponent.m_fAerodynamics then
							pVehicle.m_fAerodynamics = pVehicle.m_fAerodynamics + pVehicleComponent.m_fAerodynamics;
						end
					end
				end
				
				pVehicle:Update();
			end
		end
	end
);

addEventHandler( "onClientElementStreamIn", CVehicle.m_pRoot,
	function()
		if source:type() == "vehicle" then
			local m_Color = source:GetData( "color" );
			
			if m_Color then
				source:SetColor( unpack( m_Color ) );
			end
			
			source:SetWiperState( source:GetData( "m_iWiperState" ) );
			
			source:UpdateComponents();
		end
	end
);

addEventHandler( "onClientElementDataChange", CVehicle.m_pRoot,
	function( sDataName, vOldValue )
		if sDataName == "m_iWiperState" then
			source:SetWiperState( source:GetData( "m_iWiperState" ) );
		else
			local sComponent = sDataName:match( "CVehicleComponents-->([A-Za-z0-9_]+)" );
			
			if sComponent and source:type() == "vehicle" then
				source:UpdateComponent( sComponent );
			end
		end
	end
);
