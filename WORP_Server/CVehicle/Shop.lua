-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local vehicle_prices =
{
	[400] = 247500;		[401] = 85500;		[402] = 270000;		[403] = 423000;		[404] = 31500;	
	[405] = 124500;		[406] = 765000;		[407] = 450000;		[408] = 345000;		[409] = 376500;	
	[410] = 57000;		[411] = 624000;		[412] = 59250;		[413] = 120000;		[414] = 195000;	
	[415] = 322500;		[416] = 225000;		[417] = 4500000;	[418] = 27000;		[419] = 52500;	
	[420] = 30000;		[421] = 85500;		[422] = 121500;		[423] = 15000;		[424] = 148500;	
	[425] = 22500000;	[426] = 345000;		[427] = 600000;		[428] = 499500;		[429] = 337500;	
	[430] = 2250000;	[431] = 450000;		[432] = 30000000;	[433] = 1500000;	[434] = 918000;	
	[435] = 450000;		[436] = 75000;		[437] = 525000;		[438] = 25500;		[439] = 99000;	
	[440] = 165000;		[441] = 7500;		[442] = 45000;		[443] = 481500;		[444] = 750000;	
	[445] = 67500;		[446] = 1200000;	[447] = 9000000;	[448] = 10500;		[449] = 0;	
	[450] = 0;			[451] = 576000;		[452] = 750000;		[453] = 675000;		[454] = 1050000;	
	[455] = 750000;		[456] = 450000;		[457] = 22500;		[458] = 60000;		[459] = 135000;	
	[460] = 4500000;	[461] = 360000;		[462] = 13500;		[463] = 255000;		[464] = 0;	
	[465] = 0;			[466] = 33000;		[467] = 16500;		[468] = 225000;		[469] = 6000000;	
	[470] = 285000;		[471] = 75000;		[472] = 675000;		[473] = 67500;		[474] = 97500;	
	[475] = 72000;		[476] = 30000000;	[477] = 292500;		[478] = 31500;		[479] = 42000;	
	[480] = 121500;		[481] = 7500;		[482] = 135000;		[483] = 30000;		[484] = 570000;	
	[485] = 0;			[486] = 0;			[487] = 2250000;	[488] = 0;			[489] = 225000;	
	[490] = 0;			[491] = 64500;		[492] = 58500;		[493] = 2250000;	[494] = 675000;	
	[495] = 480000;		[496] = 27000;		[497] = 0;			[498] = 0;			[499] = 120000;	
	[500] = 79500;		[501] = 0;			[502] = 675000;		[503] = 675000;		[504] = 480000;	
	[505] = 226500;		[506] = 361500;		[507] = 27000;		[508] = 120000;		[509] = 5250;	
	[510] = 8250;		[511] = 3000000;	[512] = 3000000;	[513] = 3000000;	[514] = 600000;	
	[515] = 750000;		[516] = 82500;		[517] = 102000;		[518] = 69000;		[519] = 7500000;	
	[520] = 0;			[521] = 420000;		[522] = 465000;		[523] = 0;			[524] = 675000;	
	[525] = 165000;		[526] = 87000;		[527] = 96000;		[528] = 0;			[529] = 39750;	
	[530] = 0;			[531] = 0;			[532] = 0;			[533] = 120000;		[534] = 150750;	
	[535] = 352500;		[536] = 97500;		[537] = 0;			[538] = 0;			[539] = 375000;	
	[540] = 66000;		[541] = 570000;		[542] = 55500;		[543] = 33000;		[544] = 0;	
	[545] = 76500;		[546] = 60150;		[547] = 67500;		[548] = 0;			[549] = 39000;	
	[550] = 56250;		[551] = 90000;		[552] = 0;			[553] = 0;			[554] = 180000;	
	[555] = 133500;		[556] = 0;			[557] = 0;			[558] = 162000;		[559] = 195000;	
	[560] = 210000;		[561] = 157500;		[562] = 187500;		[563] = 0;			[564] = 0;	
	[565] = 147750;		[566] = 105000;		[567] = 106500;		[568] = 210750;		[569] = 0;	
	[570] = 0;			[571] = 0;			[572] = 0;			[573] = 676500;		[574] = 0;	
	[575] = 22500;		[576] = 66150;		[577] = 0;			[578] = 750000;		[579] = 345000;	
	[580] = 48165;		[581] = 360000;		[582] = 0;			[583] = 0;			[584] = 0;	
	[585] = 46500;		[586] = 82500;		[587] = 165000;		[588] = 0;			[589] = 81300;	
	[590] = 0;			[591] = 0;			[592] = 0;			[593] = 0;			[594] = 0;	
	[595] = 360000;		[596] = 0;			[597] = 0;			[598] = 0;			[599] = 0;	
	[600] = 62100;		[601] = 0;			[602] = 135000;		[603] = 270750;		[604] = 5250;	
	[605] = 4800;		[606] = 0;			[607] = 0;			[608] = 0;			[609] = 93000;	
	[610] = 0;			[611] = 0;	
};


local shops			= {};
local shop_vehicles = {};

function CVehicle:GetPrice()
	return vehicle_prices[ self:GetModel() ] or 0;
end

function CVehicle.GetRandomShop()
	local result = assert( g_pDB:Query( "SELECT id FROM " + DBPREFIX + "vehicles_shop WHERE deleted = 'No' ORDER BY RAND() LIMIT 1" ) );
	
	local id = result:FetchRow().id;
	
	delete ( result );
	
	return assert( shops[ id ], "undefined vehicle shop (ID: " + (string)( id ) + ")" );
end

function CClientRPC:VehicleBuy( iID, bRentable )
	local pChar = self:GetChar();
	
	if pChar then
		local pVehicle = bRentable and g_pGame:GetVehicleManager():Get( iID ) or shop_vehicles[ iID ];
		
		if pVehicle then
			if pVehicle:GetPosition():Distance( self:GetPosition() ) > 5 or pVehicle:GetInterior() ~= self:GetInterior() or self:GetDimension() ~= pVehicle:GetDimension() then
				return;
			end
			
			if ( bRentable and pVehicle:GetRentPrice() or pVehicle:GetPrice() ) > pChar:GetMoney() then
				self:Hint( "Ошибка", "У Вас недостаточно денег", "error" );
				
				return;
			end
			
			if pVehicle:IsRentable() then
				self:Hint( "Автомобиль арендован", "Автомобиль арендован на 1 час.\n\nТеперь вы можете пользоваться этим автомобилем", "ok" );
				pChar:TakeMoney( pVehicle:GetRentPrice() );
				
				pVehicle:SetOwner( pChar );
				pVehicle:SetRentTime( 3600 );
				
				return;
			end
			
			pChar:TakeMoney( pVehicle:GetPrice() );
			
			local iModel 				= pVehicle:GetModel();
			local vecPosition			= pVehicle:GetPosition();
			local vecRotation			= pVehicle:GetRotation();
			local iInterior				= pVehicle:GetInterior();
			local iDimension			= pVehicle:GetDimension();
			local Color 				= { pVehicle:GetColor() };
			local iVariant1, iVariant2	= pVehicle:GetVariant();
			
			pVehicle:Destroy();
			
			pVehicle				= NULL;
			shop_vehicles[ iID ] 	= NULL;
			
			pVehicle = g_pGame:GetVehicleManager():Create( iModel, vecPosition, vecRotation, iInterior, iDimension, iVariant1, iVariant2, unpack( Color ) );
			
			pVehicle:SetOwner( pChar );
			
			self:Hint( "Автомобиль куплен", "Поздравляем Вас с покупкой автомобиля " + pVehicle:GetName() + "!", "ok" );
			
			g_pServer:Print( "%s (%d) bought vehicle '%s' (%d) for $%d", self:GetName(), pChar:GetID(), pVehicle:GetName(), pVehicle:GetID(), pVehicle:GetPrice() );
		else
			Debug( "invalid shop vehicle id " + (string)( iID ), 2 );
		end
	end
end

function CClientRPC:VehiclePreSell( iVehicleID )
	if self:IsInGame() then
		local pVehicle = g_pGame:GetVehicleManager():Get( iVehicleID );
		
		if pVehicle then
			if pVehicle:GetDriver() == self then
				self:MessageBox( 'VehicleSell', pVehicle:IsRentable() and ( "Вы действительно хотите отказаться от аренды автомобиля " + pVehicle:GetName() + " (" + pVehicle:GetRegPlate() + ")?" ) or ( "Вы действительно хотите продать автомобиль " + pVehicle:GetName() + " (" + pVehicle:GetRegPlate() + ") за $" + ( pVehicle:GetPrice() * .5 ) + "?" ), " ", MessageBoxButtons.YesNo, MessageBoxIcon.Question, iVehicleID );
			else
				self:Hint( "Ошибка", "Вы должны быть за рулём своего автомобиля", "error" );
			end
		else
			self:Hint( "Ошибка", "Автомобиля ID " + (string)( iVehicleID ) + " не существует, обратитесь к системному администратору", "error" );
		end
	end
end

function CClientRPC:VehicleSell( result, button, state, vehicle_id )
	if self:IsInGame() then
		if result == 'Да' then
			local pVehicle = g_pGame:GetVehicleManager():Get( vehicle_id );
			
			if pVehicle then
				if pVehicle:GetOwner() == self:GetChar():GetID() then
					if pVehicle:IsRentable() then
						self:Hint( "Аренда отменена", "Вы больше не арендуете автомобиль " + pVehicle:GetName() + " (" + pVehicle:GetRegPlate() + ")", "ok" );
						self:RemoveFromVehicle();
						
						pVehicle:SetRentTime( 0 );
						pVehicle:SetOwner( NULL );
						pVehicle:RespawnSafe();
					elseif g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET deleted = 'Yes' WHERE id = " + pVehicle:GetID() ) then
						self:Hint( "Собственность продана", "Автомобиль " + pVehicle:GetName() + " (" + pVehicle:GetRegPlate() + ") успешно продан за $" + ( pVehicle:GetPrice() * .5 ), "ok" );
						
						self:GetChar():GiveMoney( pVehicle:GetPrice() * .5 );					
						
						delete ( pVehicle );
					else
						self:GetChat():Send( TEXT_DB_ERROR, 255, 0, 0 );
						
						Debug( g_pDB:Error(), 1 );
					end
				else
					self:Hint( "Ошибка", "Этот автомобиль не пренадлежит Вам", "error" );
				end
			else
				self:Hint( "Ошибка", "Автомобиля ID " + (string)( vehicle_id ) + " не существует, обратитесь к системному администратору", "error" );
			end
		end
	end
end

function CClientRPC:VehicleSellTo( result, button, state, iVehicleID, iPrice, pPlayer )
	assert( type( iPrice ) == 'number', "typeof iPrice == int" );
	
	if self:IsInGame() and isElement( pPlayer) and pPlayer:IsInGame() then
		if result == 'Да' then
			local pVehicle = g_pGame:GetVehicleManager():Get( iVehicleID );
			
			if pVehicle then
				if pVehicle:GetOwner() == pPlayer:GetChar():GetID() and not pVehicle:IsRentable() then
					if self:GetChar():TakeMoney( iPrice ) then
						pPlayer:GetChar():GiveMoney( iPrice );
						
						pVehicle:SetOwner( self:GetChar() );
						
						pPlayer:GetChat():Send( "Автомобиль " + pVehicle:GetName() + " (ID: " + iVehicleID + ") " + " продан за $" + iPrice, 0, 255, 128 );
						self:GetChat():Send( "Вы купили автомобиль " + pVehicle:GetName() + " (ID: " + iVehicleID + ") " + " за $" + iPrice, 0, 255, 128 );
					else
						self:Hint( "Ошибка", "Недостаточно денег.\nВам нужно ещё $" + ( iPrice - self:GetChar():GetMoney() ), "error" );
					end
				else
					pPlayer:Hint( "Ошибка", "Этот автомобиль не пренадлежит Вам", "error" );
				end
			else
				pPlayer:Hint( "Ошибка", "Автомобиля ID " + (string)( iVehicleID ) + " не существует, обратитесь к системному администратору", "error" );
			end
		end
	end
end

function CVehicle.InitShops( bForce )
	if not g_pDB:Ping() then return end
	
	if bForce then
		for _, shop in pairs( shops ) do
			shop:Destroy();
			shops[ shop.id ] = nil;
		end
		
		shop_vehicles = {};
	end
	
	local result = g_pDB:Query( "SELECT * FROM " + DBPREFIX + "vehicles_shop WHERE deleted = 'No' ORDER BY id ASC" );
	
	if not result then
		Debug( g_pDB:Error(), 1 );
		
		return;
	end
	
	for _, row in ipairs( result:GetArray() ) do
		local shop = shops[ row.id ];
		
		if not shop then
			local position = Vector3( row.x, row.y, row.z );
			
			shop = CBlip( position, 55, 2, 255, 255, 255, 255, 0, 250.0 );
			
			shop.id 		= row.id;
			shop.position	= position;
			shop.models		= row.models:split( ',' );
			shop.rent		= row.rent == 'Yes';
			
			shops[ shop.id ] = shop;
		end
		
		local result_spots = g_pDB:Query( "SELECT * FROM " + DBPREFIX + "vehicles_shop_spots WHERE deleted = 'No' AND shop_id = " + row.id + " ORDER BY id ASC" );
		
		if not result_spots then
			Debug( g_pDB:Error(), 1 );
			
			return;
		end
		
		for _, row_spots in ipairs( result_spots:GetArray() ) do
			local pos = Vector3( row_spots.x, row_spots.y, row_spots.z + .2 );
			local rot = Vector3( row_spots.rx, row_spots.ry, row_spots.rz );
			
			if shop_vehicles[ row_spots.id ] then
				if shop_vehicles[ row_spots.id ]:GetPosition():Distance( pos ) > 2 then
					shop_vehicles[ row_spots.id ]:Respawn();
				end
			else
				for _, v in pairs( shop_vehicles ) do
					if v:GetPosition():Distance( pos ) <= 1 then
						pos = nil;
						
						break;
					end
				end
				
				if pos then
					for _, v in pairs( g_pGame:GetVehicleManager():GetAll() ) do
						if v:GetPosition():Distance( pos ) <= 1 then
							pos = nil;
							
							break;
						end
					end
					
					if pos then
						if not bForce then
							for _, v in pairs( g_pGame:GetPlayerManager():GetAll() ) do
								if v:GetPosition():Distance( pos ) < 250 then
									pos = nil;
									
									break;
								end
							end
						end
						
						if pos then
							local pVehicle = CVehicle( g_pGame:GetVehicleManager() ):Create( shop.models[ math.random( #shop.models ) ], pos, rot );
							
							if pVehicle then
								pVehicle:SetParent( shop );
								pVehicle:SetInterior( row_spots.interior );
								pVehicle:SetDimension( row_spots.dimension );
								pVehicle:SetDamageProof( true );
								pVehicle:SetFrozen( true );
								pVehicle:SetLocked( true );
								pVehicle:ToggleRespawn( true );
								pVehicle:SetIdleRespawnDelay( 5000 );
								
								pVehicle.shop_id		= row_spots.id;
								pVehicle.m_bRentable	= shop.rent;
								
								shop_vehicles[ row_spots.id ] = pVehicle;
							else
								Debug( "invalid vehicle: " + (string)( row_spots.model ), 2 );
							end
						end
					end
				end
			end
		end
		
		delete ( result_spots );
	end

	delete ( result );
end