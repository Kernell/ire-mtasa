-- Author:      	Kernell
-- Version:     	1.0.0

local Blips =
{
	{ vecPosition = Vector3( 1481.17, -1759.83, 16 ), iIcon = 19 	}; -- Goverment
	{ vecPosition = Vector3( 1553.54, -1675.63, 16 ), iIcon = 30 	}; -- Police
	{ vecPosition = Vector3( 2025.50, -1423.30, 16 ), iIcon = 22 	}; -- Hospital
	{ vecPosition = Vector3( 1542.91, -1273.05, 17 ), iIcon = 52 	}; -- Bank
	{ vecPosition = Vector3( 1734.13, -2291.80, 16 ), iIcon = 5 	}; -- Airport
	{ vecPosition = Vector3( 725.80,  -1438.70, 14 ), iIcon = 36	}; -- Licensers
};

class "CGameBlips";

function CGameBlips:CGameBlips()
	self.m_Blips = {};
	
	for i, Data in ipairs( Blips ) do
		self.m_Blips[ i ] = CBlip( Data.vecPosition, Data.iIcon, 2, 255, 255, 255, 255, 1, 250.0 );
	end
end