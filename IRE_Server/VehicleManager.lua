-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. VehicleManager : Manager
{
	static
	{
		Root	= new. Element( "Vehicle", "Vehicle" );
		
		DefaultData	=
		{
			character_id	= 0;
			fuel			= 100.0;
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
			
			default_interior	= 0;
			default_dimension	= 0;
		};
		
		NotLockable =
		{
			[448] = true, [461] = true, [462] = true, [463] = true, [481] = true, [509] = true, [510] = true, [521] = true, [522] = true, [581] = true, [586] = true;
			[430] = true, [446] = true, [452] = true, [453] = true, [454] = true, [472] = true, [473] = true, [484] = true, [493] = true, [595] = true;
			[424] = true, [457] = true, [471] = true, [539] = true, [568] = true, [571] = true;
		};
		
		Names	=
		{
			[ ADMIRAL ]		= { "admiral" };
			[ ALPHA ]		= { "Nissan Skyline R34 GT-R M-Spec Nür" };
			[ AMBULAN ]		= { "Ambulance" };
			[ ANDROM ]		= { "Andromada" };
			[ ARTICT1 ]		= { "ARTICT1" };
			[ ARTICT2 ]		= { "ARTICT2" };
			[ ARTICT3 ]		= { "ARTICT3" };
			[ AT400 ]		= { "AT-400" };
			[ BAGBOXA ]		= { "BAGBOXA" };
			[ BAGBOXB ]		= { "BAGBOXB" };
			[ BAGGAGE ]		= { "BAGGAGE" };
			[ BANDITO ]		= { "Bandito" };
			[ BANSHEE ]		= { "Banshee" };
			[ BARRACKS ]	= { "Barracks" };
			[ BEAGLE ]		= { "Beagle" };
			[ BENSON ]		= { "Benson" };
			[ BF400 ]		= { "BF-400" };
			[ BFINJECT ]	= { "BF-Injection" };
			[ BIKE ]		= { "Bike" };
			[ BLADE ]		= { "Blade" };
			[ BLISTAC ]		= { "Blista Compact" };
			[ BLOODRA ]		= { "Bloodring Banger" };
			[ BMX ]			= { "BMX" };
			[ BOBCAT ]		= { "Bobcat" };
			[ BOXBURG ]		= { "BOXBURG" };
			[ BOXVILLE ]	= { "Boxville" };
			[ BRAVURA ]		= { "Bravura" };
			[ BROADWAY ]	= { "Broadway" };
			[ BUCCANEE ]	= { "Buccanee" };
			[ BUFFALO ]		= { "Ford Mustang Boss 302" };
			[ BULLET ]		= { "Bullet" };
			[ BURRITO ]		= { "Burrito" };
			[ BUS ]			= { "Bus" };
			[ CABBIE ]		= { "Cabbie" };
			[ CADDY ]		= { "Caddy" };
			[ CADRONA ]		= { "Cadrona" };
			[ CAMPER ]		= { "Camper" };
			[ CARGOBOB ]	= { "Cargobob" };
			[ CEMENT ]		= { "Cement" };
			[ CHEETAH ]		= { "Cheetah" };
			[ CLOVER ]		= { "Clover" };
			[ CLUB ]		= { "Club" };
			[ COACH ]		= { "Coach" };
			[ COASTG ]		= { "Coastg" };
			[ COMBINE ]		= { "Combine" };
			[ COMET ]		= { "Comet" };
			[ COPBIKE ]		= { "HPV1000" };
			[ COPCARLA ]	= { "Police LS" };
			[ COPCARRU ]	= { "Police Ranger" };
			[ COPCARSF ]	= { "Police SF" };
			[ COPCARVG ]	= { "Police LV" };
			[ CROPDUST ]	= { "Cropdust" };
			[ DFT30 ]		= { "DFT-30" };
			[ DINGHY ]		= { "Dinghy" };
			[ DODO ]		= { "Dodo" };
			[ DOZER ]		= { "Dozer" };
			[ DUMPER ]		= { "Dumper" };
			[ DUNERIDE ]	= { "Duneride" };
			[ ELEGANT ]		= { "Lexus IS 300 Series I" };
			[ ELEGY ]		= { "Elegy" };
			[ EMPEROR ]		= { "Ford Falcon XR8" };
			[ ENFORCER ]	= { "Enforcer" };
			[ ESPERANT ]	= { "Esperanto" };
			[ EUROS ]		= { "Euros" };
			[ FAGGIO ]		= { "Faggio" };
			[ FARMTR1 ]		= { "Farm Trailer" };
			[ FBIRANCH ]	= { "FBI Rancher" };
			[ FBITRUCK ]	= { "FBI Truck" };
			[ FCR900 ]		= { "FCR-900" };
			[ FELTZER ]		= { "Feltzer" };
			[ FIRELA ]		= { "Fire Truck Ladder" };
			[ FIRETRUK ]	= { "Fire Truck" };
			[ FLASH ]		= { "Flash" };
			[ FLATBED ]		= { "Flatbed" };
			[ FORKLIFT ]	= { "Forklift" };
			[ FORTUNE ]		= { "Fortune" };
			[ FREEWAY ]		= { "Freeway" };
			[ FREIBOX ]		= { "Freibox" };
			[ FREIFLAT ]	= { "Freiflat" };
			[ FREIGHT ]		= { "Freight" };
			[ GLENDALE ]	= { "Glendale" };
			[ GLENSHIT ]	= { "Glenshit" };
			[ GREENWOO ]	= { "Greenwood" };
			[ HERMES ]		= { "Hermes" };
			[ HOTDOG ]		= { "Hotdog" };
			[ HOTKNIFE ]	= { "Hotknife" };
			[ HOTRINA ]		= { "Hotring Racer A" };
			[ HOTRINB ]		= { "Hotring Racer B" };
			[ HOTRING ]		= { "Hotring Racer" };
			[ HUNTER ]		= { "Hunter" };
			[ HUNTLEY ]		= { "Huntley" };
			[ HUSTLER ]		= { "Hustler" };
			[ HYDRA ]		= { "Hydra" };
			[ INFERNUS ]	= { "Infernus" };
			[ INTRUDER ]	= { "Intruder" };
			[ JESTER ]		= { "Jester" };
			[ JETMAX ]		= { "Jetmax" };
			[ JOURNEY ]		= { "Journey" };
			[ KART ]		= { "Kart" };
			[ LANDSTAL ]	= { "Landstalker" };
			[ LAUNCH ]		= { "Launch" };
			[ LEVIATHN ]	= { "Leviathan" };
			[ LINERUN ]		= { "Linerunner" };
			[ MAJESTIC ]	= { "Majestic" };
			[ MANANA ]		= { "Manana" };
			[ MARQUIS ]		= { "Marquis" };
			[ MAVERICK ]	= { "Maverick" };
			[ MERIT ]		= { "Merit" };
			[ MESA ]		= { "Mesa" };
			[ MONSTER ]		= { "Monster" };
			[ MONSTERA ]	= { "Monster A" };
			[ MONSTERB ]	= { "Monster B" };
			[ MOONBEAM ]	= { "Moonbeam" };
			[ MOWER ]		= { "Mower" };
			[ MRWHOOP ]		= { "Mr. Whoopie" };
			[ MTBIKE ]		= { "Mountain Bike" };
			[ MULE ]		= { "Mule" };
			[ NEBULA ]		= { "Nebula" };
			[ NEVADA ]		= { "Nevada" };
			[ NEWSVAN ]		= { "Newsvan" };
			[ NRG500 ]		= { "NRG-500" };
			[ OCEANIC ]		= { "Oceanic" };
			[ PACKER ]		= { "Packer" };
			[ PATRIOT ]		= { "Patriot" };
			[ PCJ600 ]		= { "PCJ-600" };
			[ PEREN ]		= { "Perennial" };
			[ PETRO ]		= { "Petro" };
			[ PETROTR ]		= { "Petro Trailer" };
			[ PHOENIX ]		= { "Phoenix" };
			[ PICADOR ]		= { "Picador" };
			[ PIZZABOY ]	= { "Pizzaboy" };
			[ POLMAV ]		= { "Police Maverick" };
			[ PONY ]		= { "Pony" };
			[ PREDATOR ]	= { "Predator" };
			[ PREMIER ]		= { "Dodge Charger R/T" };
			[ PREVION ]		= { "Previon" };
			[ PRIMO ]		= { "Audi A4 2.0 TFSI" };
			[ QUAD ]		= { "Quad" };
			[ RAINDANC ]	= { "Raindance" };
			[ RANCHER ]		= { "Rancher" };
			[ RCBANDIT ]	= { "RC Bandit" };
			[ RCBARON ]		= { "RC Baron" };
			[ RCCAM ]		= { "RC Cam" };
			[ RCGOBLIN ]	= { "RC Goblin" };
			[ RCRAIDER ]	= { "RC Raider" };
			[ RCTIGER ]		= { "RC Tiger" };
			[ RDTRAIN ]		= { "Roadtrain" };
			[ REEFER ]		= { "Reefer" };
			[ REGINA ]		= { "Regina" };
			[ REMINGTN ]	= { "Remingtn" };
			[ RHINO ]		= { "Rhino" };
			[ RNCHLURE ]	= { "Rancher Lure" };
			[ ROMERO ]		= { "Romero" };
			[ RUMPO ]		= { "Rumpo" };
			[ RUSTLER ]		= { "Rustler" };
			[ SABRE ]		= { "Sabre" };
			[ SADLER ]		= { "Sadler" };
			[ SADLSHIT ]	= { "Sadler Damaged" };
			[ SANCHEZ ]		= { "Sanchez" };
			[ SANDKING ]	= { "Sandking" };
			[ SAVANNA ]		= { "Savanna" };
			[ SEASPAR ]		= { "Sea Sparrow" };
			[ SECURICA ]	= { "Securicar" };
			[ SENTINEL ]	= { "Sentinel" };
			[ SHAMAL ]		= { "Shamal" };
			[ SKIMMER ]		= { "Skimmer" };
			[ SLAMVAN ]		= { "Slamvan" };
			[ SOLAIR ]		= { "Solair" };
			[ SPARROW ]		= { "Sparrow" };
			[ SPEEDER ]		= { "Speeder" };
			[ SQUALO ]		= { "Squalo" };
			[ STAFFORD ]	= { "Stafford" };
			[ STALLION ]	= { "Stallion" };
			[ STRATUM ]		= { "Stratum" };
			[ STREAK ]		= { "Streak" };
			[ STREAKC ]		= { "Streakc" };
			[ STRETCH ]		= { "Stretch" };
			[ STUNT ]		= { "Stunt" };
			[ SULTAN ]		= { "Mitsubishi Lancer Evolution VIII GSR" };
			[ SUNRISE ]		= { "Sunrise" };
			[ SUPERGT ]		= { "Super GT" };
			[ SWATVAN ]		= { "Swatvan" };
			[ SWEEPER ]		= { "Sweeper" };
			[ TAHOMA ]		= { "Tahoma" };
			[ TAMPA ]		= { "Tampa" };
			[ TAXI ]		= { "Taxi" };
			[ TOPFUN ]		= { "Topfun" };
			[ TORNADO ]		= { "Tornado" };
			[ TOWTRUCK ]	= { "Town Truck" };
			[ TRACTOR ]		= { "Tractor" };
			[ TRAM ]		= { "Tram" };
			[ TRASH ]		= { "Trash" };
			[ TROPIC ]		= { "Tropic" };
			[ TUG ]			= { "Tug" };
			[ TUGSTAIR ]	= { "Tugstair" };
			[ TURISMO ]		= { "Turismo" };
			[ URANUS ]		= { "Uranus" };
			[ UTILITY ]		= { "Utility" };
			[ UTILTR1 ]		= { "Utilty Tralier" };
			[ VCNMAV ]		= { "VCN Maverick" };
			[ VINCENT ]		= { "Subaru Impreza WRX STI" };
			[ VIRGO ]		= { "Virgo" };
			[ VOODOO ]		= { "Voodoo" };
			[ VORTEX ]		= { "Vortex" };
			[ WALTON ]		= { "Walton" };
			[ WASHING ]		= { "Washington" };
			[ WAYFARER ]	= { "Wayfarer" };
			[ WILLARD ]		= { "Willard" };
			[ WINDSOR ]		= { "Windsor" };
			[ YANKEE ]		= { "Yankee" };
			[ YOSEMITE ]	= { "Yosemite" };
			[ ZR350 ]		= { "ZR-350" };
		};
	};
	
	VehicleManager		= function()
		this.Manager();
		
		Server.DB.CreateTable( Server.DB.Prefix + "vehicles",
			{
				{ Field = "id",					Type = "int(11) unsigned",		Null = "NO",	Key = "PRI", 	Default = NULL,	Extra = "auto_increment" };
				{ Field = "character_id",		Type = "int(11) unsigned",		Null = "NO",	Key = "",		Default = 0,	};
				{ Field = "model",				Type = "smallint(3)",			Null = "NO",	Key = "",		Default = NULL,	};
				{ Field = "color",				Type = "varchar(255)",			Null = "NO",	Key = "",		Default = "[[ 255, 255, 255, 0, 0, 0, 128, 128, 128, 64, 64, 64 ]]" };
				{ Field = "lights_color",		Type = "varchar(255)",			Null = "NO",	Key = "",		Default = "[[ 255, 255, 255 ]]" };
				{ Field = "position",			Type = "varchar(255)",			Null = "NO",	Key = "",		Default = NULL,	};
				{ Field = "rotation",			Type = "varchar(255)",			Null = "NO",	Key = "",		Default = NULL,	};
				{ Field = "interior",			Type = "smallint(3)",			Null = "NO",	Key = "",		Default = NULL,	};
				{ Field = "dimension",			Type = "smallint(6)",			Null = "NO",	Key = "",		Default = NULL,	};
				{ Field = "default_position",	Type = "varchar(255)",			Null = "NO",	Key = "",		Default = NULL,	};
				{ Field = "default_rotation",	Type = "varchar(255)",			Null = "NO",	Key = "",		Default = NULL,	};
				{ Field = "default_interior",	Type = "smallint(3)",			Null = "NO",	Key = "",		Default = NULL,	};
				{ Field = "default_dimension",	Type = "smallint(6)",			Null = "NO",	Key = "",		Default = NULL,	};
				{ Field = "plate",				Type = "varchar(8)",			Null = "NO",	Key = "",		Default = NULL,	};
				{ Field = "variants",			Type = "varchar(128)",			Null = "YES",	Key = "",		Default = NULL,	};
				{ Field = "upgrades",			Type = "text",					Null = "YES",	Key = "",		Default = NULL,	};
				{ Field = "wheels_states",		Type = "text",					Null = "YES",	Key = "",		Default = NULL,	};
				{ Field = "panel_states",		Type = "text",					Null = "YES",	Key = "",		Default = NULL,	};
				{ Field = "door_state",			Type = "text",					Null = "YES",	Key = "",		Default = NULL,	};
				{ Field = "health",				Type = "smallint(4)",			Null = "NO",	Key = "",		Default = 1000,	};
				{ Field = "fuel",				Type = "float",					Null = "NO",	Key = "",		Default = 100,	};
				{ Field = "last_time",			Type = "int(11) unsigned",		Null = "NO",	Key = "",		Default = 0,	};
				{ Field = "last_driver",		Type = "varchar(64)",			Null = "YES",	Key = "",		Default = NULL,	};
				{ Field = "locked",				Type = "enum('Yes','No')",		Null = "NO",	Key = "",		Default = "No",	};
				{ Field = "engine",				Type = "enum('on','off')",		Null = "NO",	Key = "",		Default = "off",};
				{ Field = "lights",				Type = "enum('on','off')",		Null = "NO",	Key = "",		Default = "off",};
				{ Field = "element_data",		Type = "text",					Null = "YES",	Key = "",		Default = NULL,	};
				{ Field = "deleted",			Type = "timestamp",				Null = "YES",	Key = "",		Default = NULL,	};
			}
		);
		
		this.ColorManager = new. VehicleColorManager();
		
		VehicleManager.Root.OnElementModelChange.Add( this.VehicleModelChange );
	end;
	
	_VehicleManager		= function()
		VehicleManager.Root.OnElementModelChange.Remove( this.VehicleModelChange );
		
		this.SaveAll();
	end;
	
	SaveAll	= function( force )
		local tick, count = getTickCount(), 0;
		
		for i = 1, this.MaxVehicleID do
			local vehicle = this.Get( i );
			
			if vehicle and vehicle.Save( force ) then
				count = count + 1;
			end
		end
		
		if _DEBUG then
			Debug( string.format( "%d/%d vehicles saved (%d ms)", count, this.MaxVehicleID, getTickCount() - tick ) );
		end
	end;
	
	Init				= function()
		this.m_List			= {};
		this.MaxVehicleID	= 0;
		
		local result = Server.DB.Query( "SELECT * FROM " + Server.DB.Prefix + "vehicles WHERE deleted IS NULL ORDER BY id ASC" );
		
		if not result then
			Debug( Server.DB.Error(), 1 );
			
			return false;
		end
		
		for i, row in ipairs( result.GetArray() ) do
			local position	= new. Vector3( row.position );
			local rotation	= new. Vector3( row.rotation );
			
			local vehicle	= this.Add( row.id, row.model, position, rotation, row );
		end
		
		result.Free();
		
		return true;
	end;
	
	DoPulse	= function( realTime )
		for i, vehicle in pairs( this.m_List ) do
			vehicle.DoPulse( realTime );
		end
	end;
	
	Add	= function( ID, model, position, rotation, data )
		data	= data or VehicleManager.DefaultData;
		
		local variant1, variant2 = unpack( fromJSON( data.variants ) or {} );
		
		local vehicle = new. Vehicle( model, position, rotation, plate, variant1, variant2 );
		
		local upgrades = data.upgrades and fromJSON( data.upgrades );
		
		if upgrades then
			for key, value in pairs( upgrades ) do
				vehicle.Upgrades.Add( value );
			end
		end
		
		local panelStates = data.panel_states and fromJSON( data.panel_states );
		
		if panelStates then
			for key, value in pairs( panelStates ) do
				vehicle.SetPanelState( tonumber( key ), value );
			end
		end
		
		local doorStates = data.door_state and fromJSON( data.door_state );
		
		if doorStates then
			for key, value in pairs( doorStates ) do
				vehicle.SetDoorState( tonumber( key ), value );
			end
		end
		
		this.ElementData = data.element_data and fromJSON( data.element_data );
		
		if this.ElementData then
			for key, value in pairs( this.ElementData ) do
				vehicle.SetData( key, value );
			end
		end
		
		if not vehicle.RegPlate then
			vehicle.GenerateRegPlate();
		end
		
		local color = data.color and fromJSON( data.color );
		
		if color then
			vehicle.SetColor		( unpack( color ) );
		else
			vehicle.RandomizeColor();
		end
		
		vehicle.ID					= ID;
		vehicle.CharID				= data.character_id;
		vehicle.Fuel				= data.fuel;
		vehicle.LastDriver			= data.last_driver or "N/A";
		vehicle.LastTime			= data.last_time or getRealTime().timestamp;
		
		vehicle.DefaultPosition		= new. Vector3( data.default_position );
		vehicle.DefaultRotation		= new. Vector3( data.default_rotation );
		vehicle.DefaultInterior		= data.default_interior;
		vehicle.DefaultDimension	= data.default_dimension;
		
		vehicle.SetInterior			( data.interior );
		vehicle.SetDimension		( data.dimension );
		
		vehicle.SetEngineState		( data.engine == "on" );
		vehicle.SetLights			( data.lights == "on" );
		vehicle.SetLocked			( data.locked == "Yes" );
		vehicle.SetHeadLightColor	( unpack( data.lights_color and fromJSON( data.lights_color ) or { 255, 255, 255 } ) );
		vehicle.SetWheelStates		( unpack( data.wheels_states and fromJSON( data.wheels_states ) or { 0, 0, 0, 0 } ) );
		vehicle.SetHealth			( Clamp( 300.0, data.health or 1000.0, 1000.0 ) );
		
		vehicle.Siren.SetState		( data.siren, data.whelen );
		
		vehicle.SetID( "vehicle:" + vehicle.ID );
		
		vehicle.SetData( "Vehicle::ID",				vehicle.ID,			true, true );
		vehicle.SetData( "Vehicle::CharID",			vehicle.CharID,		true, true );
		vehicle.SetData( "Vehicle::Fuel",			vehicle.Fuel,		true, true );
		vehicle.SetData( "Vehicle::LastDriver",		vehicle.LastDriver,	true, true );
		vehicle.SetData( "Vehicle::LastTime",		vehicle.LastTime,	true, true );
		
		this.AddToList( vehicle );
		
		if vehicle.ID > this.MaxVehicleID then
			this.MaxVehicleID = vehicle.ID;
		end
		
		return vehicle;
	end;
	
	Create	= function( data )
		if this.IsValidModel( data.model ) then
			if data.color == NULL or table.getn( data.color ) < 3 then
				data.color = { VehicleManager.GetRandomColor( data.model ) };
			end
			
			if not data.plate then
				data.plate			= VehicleManager.GetRandomRegPlate();
			end
			
			data.position 			= data.position.ToString();
			data.rotation 			= data.rotation.ToString();
			
			data.default_position	= data.position;
			data.default_rotation	= data.rotation;
			data.default_interior	= data.interior;
			data.default_dimension	= data.dimension;
			
			if not data.variants then
				data.variants		= { 255, 255 };
			end
			
			local ID = Server.DB.Insert( Server.DB.Prefix + "vehicles", data );
			
			if ID then
				local result = Server.DB.Query( "SELECT * FROM " + Server.DB.Prefix + "vehicles WHERE id = " + ID + " LIMIT 1" );
					
				if result then
					local row = result.GetRow();
					
					result.Free();
					
					return this.Add( ID, model, position, rotation, row );
				else
					Debug( Server.DB.Error(), 2 );
				end
			else
				Debug( Server.DB.Error(), 2 );
			end
		else
			Debug( "invalid vehicle model '" + (string)(model) + "'", 2 );
		end
		
		return NULL;
	end;
	
	VehicleModelChange	= function( sender, e, prevModel, model )
		if getElementType( sender ) == "vehicle" then
			sender.OnModelChange( prevModel, model );
		end
	end;
	
	static
	{
		GetRandomColor	= function( model )
			return Server.Game.VehicleManager.ColorManager.GetRandomColor( model );
		end;
		
		GetRandomRegPlate	= function()
			return string.format( "%04d %c%c%c", math.random( 1, 9999 ), math.random( 65, 90 ), math.random( 65, 90 ), math.random( 65, 90 ) );
		end;
		
		IsValidModel	= function( vehicleModel )
			vehicleModel = (int)(vehicleModel);
			
			return vehicleModel >= 400 and vehicleModel <= 611;
		end;
		
		IsModelLockable	= function( model )
			return not VehicleManager.NotLockable[ model ];
		end;
		
		GetModelByName	= function( name )
			name = (string)(name):lower();
			
			local model = getVehicleModelFromName( name );
			
			if model then
				return model;
			end
			
			for model, Names in pairs( VehicleManager.Names ) do
				for i, vehicleName in ipairs( Names ) do
					if vehicleName:lower():find( name ) then
						return model;
					end
				end
			end
			
			return false;
		end;
		
		GetVehicleName	= function( void )
			if typeof( void ) == "number" then
				return VehicleManager.Names[ void ][ 1 ];
			elseif typeof( void ) == "object" then
				return VehicleManager.GetVehicleName( void.GetModel() );
			end
			
			return "invalid vehicle";
		end;
	};
};