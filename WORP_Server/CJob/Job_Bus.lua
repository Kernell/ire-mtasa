-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local TJobBus		= CJob( 'bus', 103, 'Водитель автобуса', 'водителем автобуса', Vector3( 1751.75, -2056.90, 13.76 ) );

local aRoutes =
{
	{
		{ stop = false; 1815.88, -2074.29, 13.460000038147 };
		{ stop = true; 	1853.40, -2170.68, 13.380000114441 };
		{ stop = false; 1984.40, -2169.44, 13.380000114441 };
		{ stop = false; 2120.30, -2239.62, 13.390000343323 };
		{ stop = false; 2179.28, -2379.35, 13.380000114441 };
		{ stop = false; 2148.79, -2614.34, 13.380000114441 };
		{ stop = false; 1937.98, -2669.44, 13.130000114441 };
		{ stop = false; 1445.96, -2668.81, 13.840000152588 };
		{ stop = false; 1346.32, -2447.23, 23.469999313354 };
		{ stop = false; 1426.30, -2293.47, 13.380000114441 };
		{ stop = false; 1506.77, -2324.45, 13.380000114441 };
		{ stop = true; 	1602.31, -2256.75, 13.35000038147 };
		{ stop = false; 1730.04, -2267.86, 13.380000114441 };
		{ stop = false; 1798.71, -2319.44, 13.380000114441 };
		{ stop = false; 1799.11, -2253.63, 6.2699999809265 };
		{ stop = false; 1581.00, -2254.89, -2.8499999046326 };
		{ stop = false; 1520.29, -2280.20, -2.9900000095367 };
		{ stop = false; 1442.98, -2248.10, -2.9900000095367 };
		{ stop = false; 1418.53, -2436.50, 6.039999961853 };
		{ stop = false; 1250.56, -2442.87, 8.8299999237061 };
		{ stop = false; 1044.52, -2255.27, 12.920000076294 };
		{ stop = false; 1062.73, -1959.35, 12.930000305176 };
		{ stop = true; 	1088.19, -1856.47, 13.380000114441 };
		{ stop = false; 1253.56, -1854.95, 13.380000114441 };
		{ stop = false; 1312.67, -1773.53, 13.380000114441 };
		{ stop = false; 1320.72, -1575.73, 13.380000114441 };
		{ stop = false; 1485.30, -1594.81, 13.380000114441 };
		{ stop = true; 	1646.80, -1597.51, 13.560000419617 };
		{ stop = false; 1824.55, -1603.98, 13.380000114441 };
		{ stop = true; 	1890.94, -1469.31, 13.380000114441 };
		{ stop = false; 2114.96, -1462.67, 23.829999923706 };
		{ stop = true; 	2159.63, -1388.16, 23.829999923706 };
		{ stop = false; 2257.14, -1386.86, 23.829999923706 };
		{ stop = false; 2385.53, -1390.35, 23.879999160767 };
		{ stop = true; 	2406.29, -1448.86, 23.840000152588 };
		{ stop = false; 2567.78, -1447.12, 34.680000305176 };
		{ stop = false; 2640.03, -1465.26, 30.280000686646 };
		{ stop = true; 	2639.66, -1686.07, 10.729999542236 };
		{ stop = false; 2639.92, -1787.77, 10.720000267029 };
		{ stop = true; 	2737.51, -1895.02, 10.880000114441 };
		{ stop = false; 2822.90, -1903.85, 10.939999580383 };
		{ stop = false; 2830.29, -2050.23, 11.10000038147 };
		{ stop = true; 	2860.74, -1956.95, 10.939999580383 };
		{ stop = true; 	2788.13, -1885.86, 10.890000343323 };
		{ stop = false; 2669.33, -1862.71, 10.920000076294 };
		{ stop = true; 	2646.33, -1696.85, 10.729999542236 };
		{ stop = false; 2628.15, -1441.78, 30.799999237061 };
		{ stop = true; 	2410.79, -1440.40, 23.840000152588 };
		{ stop = false; 2320.85, -1381.62, 23.860000610352 };
		{ stop = true; 	2189.15, -1380.44, 23.829999923706 };
		{ stop = false; 2110.37, -1402.96, 23.829999923706 };
		{ stop = false; 2098.16, -1459.20, 23.829999923706 };
		{ stop = true; 	1917.54, -1457.58, 13.380000114441 };
		{ stop = false; 1842.72, -1507.52, 13.369999885559 };
		{ stop = false; 1800.56, -1609.22, 13.35000038147 };
		{ stop = true; 	1637.44, -1588.75, 13.46 };
		{ stop = false; 1432.89, -1582.48, 13.369999885559 };
		{ stop = false; 1445.73, -1437.66, 13.380000114441 };
		{ stop = false; 1404.80, -1394.99, 13.380000114441 };
		{ stop = false; 1345.59, -1421.40, 13.380000114441 };
		{ stop = false; 1299.04, -1572.74, 13.380000114441 };
		{ stop = false; 1287.92, -1849.57, 13.380000114441 };
		{ stop = true; 	1117.36, -1848.02, 13.380000114441 };
		{ stop = false; 1048.76, -1873.57, 13.229999542236 };
		{ stop = false; 1037.28, -2070.35, 12.949999809265 };
		{ stop = false; 1029.52, -2258.75, 12.92 };
		{ stop = false; 1322.32, -2463.97, 7.6599998474121 };
		{ stop = false; 1533.24, -2289.03, -2.9900000095367 };
		{ stop = false; 1589.95, -2316.58, -2.8499999046326 };
		{ stop = false; 1732.54, -2299.78, -2.8499999046326 };
		{ stop = false; 1757.45, -2255.83, 0.090000003576279 };
		{ stop = false; 1782.98, -2316.61, 13.380000114441 };
		{ stop = false; 1733.77, -2254.21, 13.369999885559 };
		{ stop = true; 	1663.01, -2250.02, 13.359999656677; hint = "Следующая остановка будет конечной" };
		{ stop = false; 1549.09, -2282.49, 13.380000114441 };
		{ stop = false; 1478.20, -2237.82, 13.380000114441 };
		{ stop = false; 1437.02, -2321.10, 13.380000114441 };
		{ stop = false; 1463.67, -2375.83, 13.430000305176 };
		{ stop = false; 1279.09, -2369.96, 20.670000076294 };
		{ stop = false; 1331.22, -2343.05, 13.380000114441 };
		{ stop = false; 1354.82, -2638.44, 13.380000114441 };
		{ stop = false; 1574.77, -2684.61, 5.9699997901917 };
		{ stop = false; 2025.80, -2684.91, 11.329999923706 };
		{ stop = false; 2179.75, -2358.66, 13.380000114441 };
		{ stop = false; 2138.60, -2214.12, 13.380000114441 };
		{ stop = true; 	1916.74, -2162.70, 13.380000114441; hint = "Это конечная остановка" };
		{ stop = false; 1825.23, -2157.48, 13.380000114441 };
		{ stop = false; 1810.24, -2072.38, 13.560000419617 };
	};
};

local OnMarkerHit;

function TJobBus:Init( pPlayer )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		if pChar:GetLicense( 'vehicle' ) then
			local pVehicle = pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
			
			if pVehicle then
				pPlayer.m_pJob	=
				{
					m_aRoutes	= aRoutes[ math.random( table.getn( aRoutes ) ) ];
					m_nCP		= 0;
				};
				
				self:NextCP( pPlayer, pPlayer.m_pJob.m_nCP );
				
				pPlayer:Hint( "Работа: Водитель автобуса", "Двигайтесь по указанному маршруту", "info" );
			end
		else
			pPlayer:Hint( "Работа: " + self:GetName(), "\nУ Вас нет водительских прав чтобы работать " + self:GetName2(), "error" );
		end
	end
end

function TJobBus:Finalize( pPlayer )
	if pPlayer.m_pJob and pPlayer.m_pJob.m_pMarker then
		pPlayer.m_pJob.m_pMarker:Destroy();
		pPlayer.m_pJob.m_pMarker = NULL;
	end
end

function TJobBus:CheckRequirements( pPlayer )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		if pChar:GetLicense( 'vehicle' ) then
			return true;
		else
			pPlayer:Hint( "Работа: " + self:GetName(), "\nУ Вас нет водительских прав чтобы работать " + self:GetName2(), "error" );
		end
	end
	
	return false;
end

function TJobBus:NextCP( pPlayer )
	if pPlayer.m_pJob.m_pMarker then
		delete( pPlayer.m_pJob.m_pMarker );
		pPlayer.m_pJob.m_pMarker	= NULL;
	end
	
	local pChar = pPlayer:GetChar();
	
	if pChar then
		pPlayer.m_pJob.m_nCP	= pPlayer.m_pJob.m_nCP + 1;
		
		if pPlayer.m_pJob.m_nCP > table.getn( pPlayer.m_pJob.m_aRoutes ) then
			pChar:SetJobSkill( math.min( 1000, pChar:GetJobSkill() + 1 ) );
			pChar:GivePay( 100 );
			
			pPlayer:EndCurrentJob();
			
			return;
		end
		
		local r, g, b	= unpack( pPlayer.m_pJob.m_aRoutes[ pPlayer.m_pJob.m_nCP ][ 'stop' ] and { 255, 0, 0 } or { 255, 255, 0 } );
		
		local vecPosition	= Vector3( unpack( pPlayer.m_pJob.m_aRoutes[ pPlayer.m_pJob.m_nCP ] ) );
		local pMarker		= CMarker.Create( vecPosition, "checkpoint", 3.0, r, g, b, 196, pPlayer.__instance );
		local pBlip			= CBlip( pMarker, 0, 2.0, 0, 255, 255, 255, 0, 9999.0, pPlayer.__instance );
		local pColShape		= CColShape( "Tube",  vecPosition.X, vecPosition.Y, vecPosition.Z - 10.0, 9.0, 20.0 );
		
		pBlip:SetParent( pMarker );
		pColShape:SetParent( pMarker );
		
		pMarker.m_pColShape = pColShape;
		pColShape.m_pMarker = pMarker;
		
		pPlayer.m_pJob.m_pMarker = pMarker;
		
		pColShape.OnHit = OnMarkerHit;
	else
		if _DEBUG then Debug( "DEBUG: " + pPlayer:GetName() + " not in game", 0, 0, 128, 255 ) end
		
		pPlayer:EndCurrentJob();
	end
end

function OnMarkerHit( pColShape, pPlayer, bMatching )
	if bMatching and classof( pPlayer ) == CPlayer and pPlayer.m_pJob and pPlayer.m_pJob.m_pMarker == pColShape.m_pMarker then
		local pChar = pPlayer:GetChar();
		
		if not pChar then
			pPlayer:EndCurrentJob();
			
			return;
		end
		
		if pChar:GetJob() ~= TJobBus then
			return;
		end
		
		local pVehicle = pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
		
		if not pVehicle or pVehicle:GetJob() ~= TJobBus then
			pPlayer:EndCurrentJob();
			
			return;
		end
		
		local bIsStop	= pPlayer.m_pJob.m_aRoutes[ pPlayer.m_pJob.m_nCP ][ 'stop' ];
		local sHint		= pPlayer.m_pJob.m_aRoutes[ pPlayer.m_pJob.m_nCP ][ 'hint' ];
		
		if sHint then
			pPlayer:Hint( "Работа: " + TJobBus:GetName(), sHint, "ok" );
		end
		
		if bIsStop then
			pPlayer:Client().JobWaitTimer( pColShape, 30000, 'BusstopComplete' );
			
			return;
		end
		
		pPlayer:PlaySoundFrontEnd( 13 );
		
		TJobBus:NextCP( pPlayer );
	end
end

function CClientRPC:BusstopComplete()
	if self:IsInGame() then
		local pVehicle = self:GetVehicleSeat() == 0 and self:GetVehicle();
		
		if pVehicle and pVehicle:GetJob() == TJobBus and self:GetChar():GetJob() == TJobBus then
			self:GetChar():GivePay( 7 );
			self:PlaySoundFrontEnd( 10 );
			
			TJobBus:NextCP( self );
		else
			if _DEBUG then Debug( "DEBUG: " + self:GetName() + " not in TJobBus vehicle", 0, 0, 128, 255 ) end
		end
	else
		if _DEBUG then Debug( "DEBUG: " + self:GetName() + " not in game", 0, 0, 128, 255 ) end
	end
end