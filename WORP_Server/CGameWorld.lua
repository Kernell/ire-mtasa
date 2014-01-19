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
};

class "CGameWorld";

function CGameWorld:CGameWorld()
	for i, data in ipairs( Models ) do
		self:RemoveBuildings( data.iModel, data.fRadius, data.vecPosition );
		
		if data.iLod then
			self:RemoveBuildings( data.iLod, data.fRadius, data.vecPosition );
		end
	end
	
	setGarageOpen( 0, (bool)(_DEBUG) );
	setOcclusionsEnabled( false );
	setAircraftMaxVelocity( 5 );
end

function CGameWorld:RemoveBuildings( iModel, fRadius, vecPosition )
	return removeWorldModel( iModel, fRadius, vecPosition.X, vecPosition.Y, vecPosition.Z );
end