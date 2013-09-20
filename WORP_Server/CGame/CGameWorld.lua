-- Author:      	Kernell
-- Version:     	1.0.0

local Models	=
{
	{ iModel = 3664, 	fRadius = 300.0, 	vecPosition = Vector3( 1398.7, 	-2548.7, 	20.0	); };
	{ iModel = 3664, 	fRadius = 300.0, 	vecPosition = Vector3( 1960.9, 	-2243.6, 	13.5	); };
	{ iModel = 3573, 	fRadius = 20.0, 	vecPosition = Vector3( 1781.52,	-2057.4, 	15.0	); };
	{ iModel = 620, 	fRadius = 10.0, 	vecPosition = Vector3( 1531.34, -2329.83, 	12.55	); };
	{ iModel = 721, 	fRadius = 10.0, 	vecPosition = Vector3( 1532.20, -2301.65, 	13.54	); };
	{ iModel = 3625, 	fRadius = 10.0, 	vecPosition = Vector3( 1961.63, -2216.32, 	13.5	); iLod = 3769 }; 
	{ iModel = 3665, 	fRadius = 10.0, 	vecPosition = Vector3( 1381.43, -2546.47, 	14.5	); iLod = 3780 };
	{ iModel = 985, 	fRadius = 10.0, 	vecPosition = Vector3( 2497.41, 2777.07, 	11.5312	); };
	{ iModel = 986, 	fRadius = 10.0, 	vecPosition = Vector3( 2497.41, 2769.11, 	11.5312	); };
--	{ iModel = 968, 	fRadius = 10.0, 	vecPosition = Vector3( -1526.4375, 481.3828, 6.9063	); };
--	{ iModel = 966, 	fRadius = 10.0, 	vecPosition = Vector3( -1526.3906, 481.3828, 6.1797	); };
--	{ iModel = 4002, 	fRadius = 100.0, 	vecPosition = Vector3( 1479.87, -1790.4, 56.0234 ); iLod = 4024 };
--	{ iModel = 3980, 	fRadius = 100.0, 	vecPosition = Vector3( 1487.03, -1764.29, 20.0	); 	iLod = 4044 };
--	{ iModel = 4003, 	fRadius = 10.0, 	vecPosition = Vector3( 1481.08, -1747.03, 33.5234 ); };

--	{ iModel = 4019, 	fRadius = 10.0, 	vecPosition = Vector3( 1777.84, -1773.91, 12.5234 ); iLod = 4025 };
--	{ iModel = 4215, 	fRadius = 10.0, 	vecPosition = Vector3( 1777.55, -1775.04, 36.75 ); };
};

local WaterZ	= 5;

local Water		=
{
	{ Vector3( 2530, -2211, -1.2 ), Vector3( 2620, -2211, -1.2 ), Vector3( 2530, -2100, WaterZ-1 ), Vector3( 2620, -2100, WaterZ-1 ) };
	{ Vector3( 2530, -2100, WaterZ-1 ), Vector3( 2620, -2100, WaterZ-1 ), Vector3( 2530, -1900, WaterZ ), Vector3( 2620, -1900, WaterZ ) };
	{ Vector3( 2530, -1900, WaterZ ), Vector3( 2620, -1900, WaterZ ), Vector3( 2530, -1700, WaterZ ), Vector3( 2620, -1700, WaterZ ) };
	{ Vector3( 2530, -1700, WaterZ ), Vector3( 2620, -1700, WaterZ ), Vector3( 2530, -1500, WaterZ ), Vector3( 2620, -1500, WaterZ ) };
	{ Vector3( 2330, -1875, WaterZ ), Vector3( 2530, -1875, WaterZ ), Vector3( 2330, -1825, WaterZ ), Vector3( 2530, -1825, WaterZ ) };
	{ Vector3( 2130, -1875, WaterZ ), Vector3( 2330, -1875, WaterZ ), Vector3( 2130, -1825, WaterZ ), Vector3( 2330, -1825, WaterZ ) };
	{ Vector3( 1930, -1875, WaterZ ), Vector3( 2130, -1875, WaterZ ), Vector3( 1930, -1825, WaterZ ), Vector3( 2130, -1825, WaterZ ) };
	{ Vector3( 1830, -1875, WaterZ ), Vector3( 1930, -1875, WaterZ ), Vector3( 1830, -1800, WaterZ ), Vector3( 1930, -1800, WaterZ ) };
	{ Vector3( 1610, -1830, WaterZ ), Vector3( 1830, -1830, WaterZ ), Vector3( 1610, -1695, WaterZ ), Vector3( 1830, -1695, WaterZ ) };
	{ Vector3( 1500, -1770, WaterZ ), Vector3( 1610, -1770, WaterZ ), Vector3( 1500, -1725, WaterZ ), Vector3( 1610, -1725, WaterZ ) };
};

class "CGameWorld";

function CGameWorld:CGameWorld()
	for i, data in ipairs( Models ) do
		self:RemoveBuildings( data.iModel, data.fRadius, data.vecPosition );
		
		if data.iLod then
			self:RemoveBuildings( data.iLod, data.fRadius, data.vecPosition );
		end
	end
	
	self.m_Water = {};
	
	for i, data in ipairs( Water ) do
		self.m_Water[ i ] = CWater( unpack( data ) );
	end
	
	setGarageOpen( 0, (bool)(_DEBUG) );
	
	setOcclusionsEnabled( false );
end

function CGameWorld:RemoveBuildings( iModel, fRadius, vecPosition )
	return removeWorldModel( iModel, fRadius, vecPosition.X, vecPosition.Y, vecPosition.Z );
end