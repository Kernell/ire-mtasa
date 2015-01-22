-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

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

class. VehicleUpgrades
{
	Vehicle		= NULL;
	Upgrades	= NULL;
	Components	= NULL;
	
	VehicleUpgrades	= function( vehicle, upgrades )
		this.Vehicle		= vehicle;
		
		this.Upgrades		= {};
		
		local defaultComponents	= DefaultComponents[ vehicle.GetModel() ];
		
		this.Components	=
		{
			Spoiler			= defaultComponents and defaultComponents.Spoiler or NULL;
			SideSkirt		= defaultComponents and defaultComponents.SideSkirt or NULL;
			Bonnet			= defaultComponents and defaultComponents.Bonnet or NULL;
			BumperFront		= defaultComponents and defaultComponents.BumperFront or NULL;
			BumperRear		= defaultComponents and defaultComponents.BumperRear or NULL;
		};
		
		if upgrades then
			for key, value in pairs( upgrades ) do
				this.Add( value );
			end
		end
	end;

	Add	= function( upgrade )
		local componentType = ComponentTypes[ upgrade ];
		
		if componentType then
			if this.Components[ componentType ] then
				this.Remove( this.Components[ componentType ] );
			end
			
			this.Components[ componentType ] = upgrade;
			
			this.Vehicle.Components.SetVisible( this.Components[ componentType ], true );
			
			this.Upgrades[ upgrade ] = true;
			
			if componentType == "WhelenA" or componentType == "WhelenB" or componentType == "WhelenC" then
				this.Vehicle.Siren.Install();
			end
			
			return true;
		end
		
		return false;
	end;
	
	Get	= function( slot )
		return this.Components[ slot ];
	end;
	
	IsInstalled	= function( upgrade )
		return this.Upgrades[ upgrade ];
	end;
	
	GetAll	= function()
		return this.Components;
	end;
	
	Remove	= function( upgrade )
		this.Upgrades[ upgrade ] = NULL;
		
		local componentType = ComponentTypes[ upgrade ];
		
		if componentType then
			if this.Components[ componentType ] then
				this.Vehicle.Components.SetVisible( this.m_Components[ componentType ], false );
			end
			
			this.m_Components[ componentType ] = NULL;
			
			if componentType == "WhelenA" or componentType == "WhelenB" or componentType == "WhelenC" then
				this.Vehicle.Siren.Remove();
			end
			
			return true;
		end
		
		return false;
	end;
	
	ToJSON	= function()
		local upgrades	= {};
		local count		= 0;
		
		for upgrade in pairs( this.Upgrades ) do
			table.insert( upgrades, upgrade );
			
			count = count + 1;
		end
		
		return count > 0 and toJSON( upgrades ) or NULL;
	end;
};
