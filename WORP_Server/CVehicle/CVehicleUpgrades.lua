-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

eVehicleUpgrade		=
{
	NITRO		= 1010;
};

local ComponentTypes	=
{
	WHELEN_A			= "WhelenA";
	WHELEN_A_EXT		= "WhelenAExtension";
	
	WHELEN_B			= "WhelenB";
	WHELEN_B_EXT		= "WhelenBExtension";
	
	WHELEN_C			= "WhelenC";
	WHELEN_C_EXT		= "WhelenCExtension";
	
	SPOILER_0			= "Spoiler";
	SPOILER_1			= "Spoiler";
	SPOILER_2			= "Spoiler";
	SPOILER_3			= "Spoiler";
	SPOILER_4			= "Spoiler";
	SPOILER_5			= "Spoiler";
	SPOILER_6			= "Spoiler";
	SPOILER_7			= "Spoiler";
	SPOILER_8			= "Spoiler";
	SPOILER_9			= "Spoiler";
	SPOILER_10			= "Spoiler";
	
	SSKIRT_0			= "SideSkirt";
	SSKIRT_1			= "SideSkirt";
	SSKIRT_2			= "SideSkirt";
	SSKIRT_3			= "SideSkirt";
	SSKIRT_4			= "SideSkirt";
	SSKIRT_5			= "SideSkirt";
	SSKIRT_6			= "SideSkirt";
	SSKIRT_7			= "SideSkirt";
	SSKIRT_8			= "SideSkirt";
	SSKIRT_9			= "SideSkirt";
	SSKIRT_10			= "SideSkirt";
	
	bonnet_dummy		= "Bonnet";
	BONNET_1			= "Bonnet";
	BONNET_2			= "Bonnet";
	BONNET_3			= "Bonnet";
	BONNET_4			= "Bonnet";
	
	bump_front_dummy	= "BumperFront";
	FBUMP_1				= "BumperFront";
	FBUMP_2				= "BumperFront";
	FBUMP_3				= "BumperFront";
	FBUMP_4				= "BumperFront";
	FBUMP_5				= "BumperFront";
	FBUMP_6				= "BumperFront";
	FBUMP_7				= "BumperFront";
	FBUMP_8				= "BumperFront";
	FBUMP_9				= "BumperFront";
	FBUMP_10			= "BumperFront";
	
	bump_rear_dummy		= "BumperRear";
	RBUMP_1				= "BumperRear";
	RBUMP_2				= "BumperRear";
	RBUMP_3				= "BumperRear";
	RBUMP_4				= "BumperRear";
	RBUMP_5				= "BumperRear";
	RBUMP_6				= "BumperRear";
	RBUMP_7				= "BumperRear";
	RBUMP_8				= "BumperRear";
	RBUMP_9				= "BumperRear";
	RBUMP_10			= "BumperRear";
};

local DefaultComponents	=
{
	[ BUFFALO ]	=
	{
		Spoiler			= "SPOILER_0";
		SideSkirt		= "SSKIRT_0";
		Bonnet			= "bonnet_dummy";
		BumperFront		= "bump_front_dummy";
		BumperRear		= "bump_rear_dummy";
	};
	[ ELEGANT ]	=
	{
		SideSkirt		= "SSKIRT_0";
		Bonnet			= "bonnet_dummy";
		BumperFront		= "bump_front_dummy";
		BumperRear		= "bump_rear_dummy";
	};
	[ EMPEROR ]	=
	{
		Spoiler			= "SPOILER_0";
		SideSkirt		= "SSKIRT_0";
		Bonnet			= "bonnet_dummy";
		BumperFront		= "bump_front_dummy";
		BumperRear		= "bump_rear_dummy";
	};
	[ PREMIER ]	=
	{
		Spoiler			= "SPOILER_0";
	};
	[ SULTAN ]	=
	{
		Spoiler			= "SPOILER_0";
		SideSkirt		= "SSKIRT_0";
		Bonnet			= "bonnet_dummy";
		BumperFront		= "bump_front_dummy";
		BumperRear		= "bump_rear_dummy";
	};
	[ VINCENT ]	=
	{
		Spoiler			= "SPOILER_0";
		SideSkirt		= "SSKIRT_0";
		Bonnet			= "bonnet_dummy";
		BumperFront		= "bump_front_dummy";
		BumperRear		= "bump_rear_dummy";
	};
	[ ALPHA ]	=
	{
		Spoiler			= "SPOILER_0";
		SideSkirt		= "SSKIRT_0";
		Bonnet			= "bonnet_dummy";
		BumperFront		= "bump_front_dummy";
		BumperRear		= "bump_rear_dummy";
	};
};

class: CVehicleUpgrades
{
	m_pVehicle		= NULL;
	m_Upgrades		= NULL;
	m_Components	= NULL;
};

function CVehicleUpgrades:CVehicleUpgrades( pVehicle, Upgrades )
	self.m_pVehicle		= pVehicle;
	
	self.m_Upgrades		= {};
	
	local pDefaultComponents	= DefaultComponents[ pVehicle:GetModel() ];
	
	self.m_Components	=
	{
		Spoiler			= pDefaultComponents and pDefaultComponents.Spoiler or NULL;
		SideSkirt		= pDefaultComponents and pDefaultComponents.SideSkirt or NULL;
		Bonnet			= pDefaultComponents and pDefaultComponents.Bonnet or NULL;
		BumperFront		= pDefaultComponents and pDefaultComponents.BumperFront or NULL;
		BumperRear		= pDefaultComponents and pDefaultComponents.BumperRear or NULL;
	};
	
	if Upgrades then
		for key, value in pairs( Upgrades ) do
			if type( value ) == "number" and value <= 3 then
				self.m_pVehicle:SetPaintjob( value );
			else
				self:Add( value );
			end
		end
	end
end

function CVehicleUpgrades:_CVehicleUpgrades()

end

function CVehicleUpgrades:Add( sUpgrade )
	if classname( self ) ~= "CVehicleUpgrades" then error( TEXT_E2288, 2 ) end
	
	local sComponentType = ComponentTypes[ sUpgrade ];
	
	if sComponentType then
		if self.m_Components[ sComponentType ] then
			self:Remove( self.m_Components[ sComponentType ] );
		end
		
		self.m_Components[ sComponentType ] = sUpgrade;
		
		self.m_pVehicle.m_pComponents:SetVisible( self.m_Components[ sComponentType ], true );
		
		self.m_Upgrades[ sUpgrade ] = true;
		
		if sComponentType == "WhelenA" or sComponentType == "WhelenB" or sComponentType == "WhelenC" then
			self.m_pVehicle.m_pSiren:Install();
		end
		
		return true;
	end
	
	self.m_Upgrades[ sUpgrade ] = true;
	
	return addVehicleUpgrade( self.m_pVehicle.__instance, sUpgrade );
end

function CVehicleUpgrades:Get( sSlot )
	return self.m_Components[ sSlot ];
end

function CVehicleUpgrades:IsInstalled( sUpgrade )
	return self.m_Upgrades[ sUpgrade ];
end

function CVehicleUpgrades:GetCompatible( iSlot )
	if classname( self ) ~= 'CVehicleUpgrades' then error( TEXT_E2288, 2 ) end
	
	return getVehicleCompatibleUpgrades( self.m_pVehicle.__instance, iSlot );
end

function CVehicleUpgrades:GetUpgradeOnSlot( iSlot )
	if classname( self ) ~= 'CVehicleUpgrades' then error( TEXT_E2288, 2 ) end
	
	return getVehicleUpgradeOnSlot( self.m_pVehicle.__instance, iSlot );
end

function CVehicleUpgrades:GetAll()
	if classname( self ) ~= 'CVehicleUpgrades' then error( TEXT_E2288, 2 ) end
	
	return getVehicleUpgrades( self.m_pVehicle.__instance );
end

function CVehicleUpgrades:Remove( vUpgrade )
	if classname( self ) ~= 'CVehicleUpgrades' then error( TEXT_E2288, 2 ) end
	
	self.m_Upgrades[ vUpgrade ] = NULL;
	
	local sComponentType = ComponentTypes[ vUpgrade ];
	
	if sComponentType then
		if self.m_Components[ sComponentType ] then
			self.m_pVehicle.m_pComponents:SetVisible( self.m_Components[ sComponentType ], false );
		end
		
		self.m_Components[ sComponentType ] = NULL;
		
		if sComponentType == "WhelenA" or sComponentType == "WhelenB" or sComponentType == "WhelenC" then
			self.m_pVehicle.m_pSiren:Remove();
		end
		
		return true;
	end
	
	return removeVehicleUpgrade( self.m_pVehicle.__instance, vUpgrade );
end

function CVehicleUpgrades:ToJSON()
	if classname( self ) ~= 'CVehicleUpgrades' then error( TEXT_E2288, 2 ) end
	
	local Upgrades	= {};
	local iCount	= 0;
	
	for vUpgrade in pairs( self.m_Upgrades ) do
		table.insert( Upgrades, vUpgrade );
		
		iCount = iCount + 1;
	end
	
	return iCount > 0 and toJSON( Upgrades ) or NULL;
end
