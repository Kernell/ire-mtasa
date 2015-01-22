-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

local STATIC_WHELENS	=
{
	[ FBIRANCH ]		=
	{
		{ X	= 0.200,	Y = 2.800,		Z = -0.300,		Red = 255, Green = 0,		Blue = 0,	Alpha = 255, MinAlpha = 255 };
		{ X	= -0.200,	Y = 2.800,		Z = -0.300,		Red = 150, Green = 150, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X	= 0.654,	Y = -2.556,		Z = -0.270, 	Red = 150, Green = 150, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X	= -0.655,	Y = -2.547,		Z = -0.200, 	Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X	= 0.677,	Y = -0.347,		Z = 1.000, 		Red = 150, Green = 150, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X	= -0.635,	Y = -0.342,		Z = 1.000, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X	= 0.234,	Y = -0.136,		Z = 1.000, 		Red = 150, Green = 150, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X	= -0.100,	Y = -0.300,		Z = 1.000, 		Red = 255, Green = 0, 		Blue = 0,	Alpha = 255, MinAlpha = 255 };
	};
	[ AMBULAN ]			=
	{
		{ X = -0.400,	Y = 0.900, 		Z = 1.200, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X = 1.0, 		Y = -3.500, 	Z = 1.450, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X = 0.400, 	Y = 0.900, 		Z = 1.200, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X = -1.0, 	Y = -3.500, 	Z = 1.450, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X = 0.100, 	Y = 0.900, 		Z = 1.200, 		Red = 255, Green = 255, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X = -0.100, 	Y = 0.900,		Z = 1.200, 		Red = 255, Green = 255, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
	};
};

class. VehicleSiren
{
	Vehicle			= NULL;
	SirenState		= 0;
	WhelenState		= 0;
	MaxSirenState	= 3;
	MaxWhelenState	= 4;
	SirenStateLast	= 0;
	WhelenStateLast	= 0;
	Type			= 0;
	
	VehicleSiren		= function( vehicle )
		this.Vehicle	= vehicle;
		
		this.Install();
	end;
	
	_VehicleSiren		= function()
		this.SetState();
		
		this.Vehicle	= NULL;
	end;
	
	Install				= function()
		removeVehicleSirens( this.Vehicle );
		
		local Components	= this.Vehicle.Upgrades.Components;
		
		if Components.WhelenA or Components.WhelenB or Components.WhelenC then
			this.Type	= 1;
			
			return true;
		else
			local sirenData = STATIC_WHELENS[ this.Vehicle.GetModel() ];
			
			if sirenData then
				this.Type	= 2;
				
				addVehicleSirens( this.Vehicle, table.getn( sirenData ), 3, true, false, true, true );
				
				for i, data in ipairs( sirenData ) do
					setVehicleSirens( this.Vehicle, i, data.X, data.Y, data.Z, data.Red, data.Green, data.Blue, data.Alpha, data.MinAlpha );
				end
				
				return true;
			end
		end
		
		return false;
	end;
	
	Remove				= function()
		removeVehicleSirens( this.Vehicle );
		
		this.Type = 0;
		
		return true;
	end;
	
	SetState			= function( sirenState, whelenState )
		if this.Type == 0 then
			return false;
		end
		
		this.SirenState		= (int)(sirenState);
		this.WhelenState	= (int)(whelenState);
		
		if this.Type == 1 then
			if this.Vehicle.Upgrades.Components.WhelenA then
				this.Vehicle.SetData( "WHELEN_A", whelenState );
			end
			
			if this.Vehicle.Upgrades.Components.WhelenB then
				this.Vehicle.SetData( "WHELEN_B", whelenState );
			end
			
			if this.Vehicle.Upgrades.Components.WhelenC then
				this.Vehicle.SetData( "WHELEN_C", whelenState );
			end
		elseif this.Type == 2 then
			setVehicleSirensOn( this.Vehicle, this.WhelenState ~= 0 );
		end
		
		
		if this.Sound == NULL or this.Sound.SirenState ~= this.SirenState then
			if this.Sound then
				delete ( this.Sound );
				this.Sound = NULL;
			end
			
			if this.SirenState ~= 0 then
				this.Sound = new. Sound( "Resources/Sounds/HornAmbient/police_siren_" + this.SirenState + ".wav" );
				
				this.Sound.Loop			= true;
				this.Sound.Volume		= 0.3;
				this.Sound.Position		= NULL;
				this.Sound.AttachedTo	= this.Vehicle;
			--	this.Sound.MinDistance	= 100.0;
				this.Sound.MaxDistance	= 200.0;
				this.Sound.SirenState	= this.SirenState;
				
				this.Sound.Play();
			end
		end
		
		return true;
	end;
};