-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local VehicleNames	=
{
	[ ADMIRAL ]		= { "admiral" };
	[ ALPHA ]		= { "Alpha" };
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
	[ BUFFALO ]		= { "Ford Mustang Boss 302 Mk.V '12", "Buffalo" };
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
	[ ELEGANT ]		= { "Lexus IS 300 Series I", "Elegant" };
	[ ELEGY ]		= { "Elegy" };
	[ EMPEROR ]		= { "Ford Falcon XR8", "Emperor" };
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
	[ PREMIER ]		= { "Dodge Charger RT", "Premier" };
	[ PREVION ]		= { "Previon" };
	[ PRIMO ]		= { "Primo" };
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
	[ SULTAN ]		= { "Mitsubishi Lancer Evolution VIII", "Sultan" };
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
	[ VINCENT ]		= { "Subaru Impreza WRX STI", "Vincent" };
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

class: CVehicleManager ( CManager )
{
	m_ColorManager = NULL;
};

function CVehicleManager:CVehicleManager()
	self:CManager();
	
	self.m_ColorManager = CVehicleColorManager();
	
	g_pDB:CreateTable( DBPREFIX + "vehicles",
		{
			{ Field = "id",					Type = "int(11) unsigned",					Null = "NO",	Key = "PRI", 		Default = NULL,	Extra = "auto_increment" };
			{ Field = "character_id",		Type = "int(11)",							Null = "NO",	Key = "",			Default = 0,	};
			{ Field = "model",				Type = "smallint(3)",						Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "color",				Type = "varchar(255)",						Null = "NO",	Key = "",			Default = "[[ 255, 255, 255, 0, 0, 0, 128, 128, 128, 64, 64, 64 ]]",	};
			{ Field = "lights_color",		Type = "varchar(255)",						Null = "NO",	Key = "",			Default = "[[ 255, 255, 255 ]]",	};
			{ Field = "x",					Type = "float",								Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "y",					Type = "float",								Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "z",					Type = "float",								Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "rx",					Type = "float",								Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "ry",					Type = "float",								Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "rz",					Type = "float",								Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "interior",			Type = "smallint(3)",						Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "dimension",			Type = "smallint(6)",						Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "default_x",			Type = "float",								Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "default_y",			Type = "float",								Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "default_z",			Type = "float",								Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "default_rx",			Type = "float",								Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "default_ry",			Type = "float",								Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "default_rz",			Type = "float",								Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "default_interior",	Type = "smallint(3)",						Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "default_dimension",	Type = "smallint(6)",						Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "plate",				Type = "varchar(8)",						Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "variants",			Type = "varchar(128)",						Null = "YES",	Key = "",			Default = NULL,	};
			{ Field = "handling",			Type = "text",								Null = "YES",	Key = "",			Default = NULL,	};
			{ Field = "upgrades",			Type = "text",								Null = "YES",	Key = "",			Default = NULL,	};
			{ Field = "wheels_states",		Type = "text",								Null = "YES",	Key = "",			Default = NULL,	};
			{ Field = "panel_states",		Type = "text",								Null = "YES",	Key = "",			Default = NULL,	};
			{ Field = "door_state",			Type = "text",								Null = "YES",	Key = "",			Default = NULL,	};
			{ Field = "health",				Type = "smallint(4)",						Null = "NO",	Key = "",			Default = 1000,	};
			{ Field = "fuel",				Type = "float",								Null = "NO",	Key = "",			Default = 100,	};
			{ Field = "last_time",			Type = "int(11)",							Null = "NO",	Key = "",			Default = 0,	};
			{ Field = "last_driver",		Type = "varchar(64)",						Null = "YES",	Key = "",			Default = NULL,	};
			{ Field = "rent_price",			Type = "smallint(6)",						Null = "YES",	Key = "",			Default = NULL,	};
			{ Field = "rent_time",			Type = "int(11)",							Null = "NO",	Key = "",			Default = 0,	};
			{ Field = "locked",				Type = "enum('Yes','No')",					Null = "NO",	Key = "",			Default = "No",	};
			{ Field = "engine",				Type = "enum('on','off')",					Null = "NO",	Key = "",			Default = "off",};
			{ Field = "lights",				Type = "enum('on','off')",					Null = "NO",	Key = "",			Default = "off",};
			{ Field = "rentable",			Type = "enum('Yes','No')",					Null = "NO",	Key = "",			Default = "No",	};
			{ Field = "element_data",		Type = "text",								Null = "YES",	Key = "",			Default = NULL,	};
			{ Field = "deleted",			Type = "timestamp",							Null = "YES",	Key = "",			Default = NULL,	};
			{ Field = "radio_id",			Type = "int(11) unsigned",					Null = "NO",	Key = "",			Default = 0,	}; 
			{ Field = "radio_volume",		Type = "float",								Null = "NO",	Key = "",			Default = 0.0,	}; 
		}
	);
end

function CVehicleManager:_CVehicleManager()
	self:SaveAll();
end

function CVehicleManager:Init()
	self.m_List				= {};
	self.m_iMaxVehicleID	= 0;
	
	local iCount, iTick = 0, getTickCount();
	
	local pResult = g_pDB:Query( "SELECT * FROM " + DBPREFIX + "vehicles WHERE deleted IS NULL ORDER BY id ASC" );
	
	if not pResult then
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
	for i, pRow in ipairs( pResult:GetArray() ) do
		local vecPosition	= Vector3( pRow.x, pRow.y, pRow.z );
		local vecRotation	= Vector3( pRow.rx, pRow.ry, pRow.rz );
		
		local iVariant1, iVariant2 = unpack( fromJSON( pRow.variants ) or {} );
		
		local pVehicle		= self:Add( pRow.id, pRow.model, vecPosition, vecRotation, pRow.plate, iVariant1, iVariant2, pRow );
		
		if pVehicle then
			pVehicle:SetInterior( pRow.interior );
			pVehicle:SetDimension( pRow.dimension );
			
			iCount = iCount + 1;
		end
	end
	
	delete ( pResult );
	
--	Debug( ( "Loaded %d vehicles (%d ms)" ):format( iCount, getTickCount() - iTick ) );
	
	local pResult = g_pDB:Query( "SELECT * FROM " + DBPREFIX + "fuelpoints WHERE deleted = 'No' ORDER BY id ASC" );
	
	if pResult then
		for i, row in ipairs( pResult:GetArray() ) do
			AddFuelpoint( row );
		end
		
		delete ( pResult );
	else
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
	return true;
end

function CVehicleManager:DoPulse( tReal )
	for i, pVehicle in pairs( self.m_List ) do
		pVehicle:DoPulse( tReal );
	end
end

function CVehicleManager:Add( iID, iModel, vecPosition, vecRotation, sPlate, iVariant1, iVariant2, pDBField )
	local pVehicle = CVehicle( self, iID, iModel, vecPosition, vecRotation, sPlate, iVariant1, iVariant2, pDBField );
	
	if pVehicle:GetID() == INVALID_ELEMENT_ID then
		delete ( pVehicle );
		return NULL;
	end
	
	if iID > self.m_iMaxVehicleID then
		self.m_iMaxVehicleID = iID;
	end
	
	return pVehicle;
end

function CVehicleManager:Create( iModel, vecPosition, vecRotation, iInterior, iDimension, iVariant1, iVariant2, ... )
	if self:IsValidModel( iModel ) then
		local Color		= { ... };
		
		if table.getn( Color ) < 3 then
			Color = { self:GetRandomColor( iModel ) };
		end
		
		local sPlate		= self:GetRandomRegPlate();
		
		local iID = g_pDB:Insert( DBPREFIX + "vehicles",
			{
				model				= iModel;
				color				= Color;
				x					= vecPosition.X;
				y					= vecPosition.Y;
				z					= vecPosition.Z;
				rx					= vecRotation.X;
				ry					= vecRotation.Y;
				rz					= vecRotation.Z;
				interior			= iInterior;
				dimension			= iDimension;
				default_x			= vecPosition.X;
				default_y			= vecPosition.Y;
				default_z			= vecPosition.Z;
				default_rx			= vecRotation.X;
				default_ry			= vecRotation.Y;
				default_rz			= vecRotation.Z;
				default_interior	= iInterior;
				default_dimension	= iDimension;
				plate				= sPlate;
				variants			= { iVariant1 or 255, iVariant2 or 255 };
			}
		);
		
		if iID then
			local pResult = g_pDB:Query( "SELECT * FROM " + DBPREFIX + "vehicles WHERE id = %d LIMIT 1", iID );
				
			if pResult then
				local pDBField = pResult:FetchRow();
				
				delete ( pResult );
				
				local pVehicle = CVehicle( self, iID, iModel, vecPosition, vecRotation, sPlate, iVariant1, iVariant2, pDBField );
				
				pVehicle:SetInterior( iInterior );
				pVehicle:SetDimension( iDimension );
				
				if iID > self.m_iMaxVehicleID then
					self.m_iMaxVehicleID = iID;
				end
				
				return pVehicle;
			else
				Debug( g_pDB:Error(), 2 );
			end
		else
			Debug( g_pDB:Error(), 2 );
		end
	else
		Debug( "invalid vehicle model '" + (string)(iModel) + "'", 2 );
	end
	
	return NULL;
end

function CVehicleManager:SaveAll( bForce )
	local iTick, iCount = getTickCount(), 0;
	
	for i = 1, self.m_iMaxVehicleID do
		local pVehicle = self:Get( i );
		
		if pVehicle and pVehicle:Save( bForce ) then
			iCount = iCount + 1;
		end
	end
	
	if _DEBUG then Debug( ( 'All vehicles (%d) saved (%d ms)' ):format( iCount, getTickCount() - iTick ) ); end
end

function CVehicleManager:GetRandomColor( iModel )
	return self.m_ColorManager.GetRandomColor( iModel );
end

function CVehicleManager:GetRandomRegPlate()
	return ( "%04d %c%c%c" ):format( math.random( 1, 9999 ), math.random( 65, 90 ), math.random( 65, 90 ), math.random( 65, 90 ) );
end

function CVehicleManager:IsValidModel( iVehicleModel )
	iVehicleModel = tonumber( iVehicleModel ) or 0;
	
	return iVehicleModel >= 400 and iVehicleModel <= 611 and iVehicleModel ~= 570;
end

function CVehicleManager:GetModelByName( sName )
	sName = (string)(sName):lower();
	
	local iModel = getVehicleModelFromName( sName );
	
	if iModel then
		return iModel;
	end
	
	for iModel, Names in pairs( VehicleNames ) do
		for i, sVehicleName in ipairs( Names ) do
			if sVehicleName:lower():find( sName ) then
				return iModel;
			end
		end
	end
	
	return false;
end

function CVehicleManager:GetVehicleName( void )
	if typeof( void ) == "number" then
		return VehicleNames[ void ][ 1 ];
	elseif typeof( void ) == "object" then
		return self:GetVehicleName( void:GetModel() );
	end
	
	return "invalid vehicle";
end