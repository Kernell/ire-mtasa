-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local FillVehicle;

local pFuelRoot = CElement( "fuelRoot" );

local FuelConfig	=
{
	default		= { fLoss = .0;		};
	
	petrol		= { fLoss = .03;	iPrice = 3; iRefillRatio = 5  };
	diesel		= { fLoss = .018;	iPrice = 2; iRefillRatio = 5  };
	electric	= { fLoss = .05;	iPrice = 1; iRefillRatio = 10 };
};

local _HaveFuel			=
{
	Automobile 			= true,
	Bike 				= true,
	[ "Monster Truck" ] = true,
	Quad 				= true
};

function CVehicle:HaveFuel()	
	return _HaveFuel[ self:GetType() ];
end

function CVehicle:GetFuel()
	return self.m_fFuel;
end

function CVehicle:SetFuel( fFuel )
	self.m_fFuel = Clamp( 0, (float)(fFuel), 100 );
	
	self:SetData( 'fuel', self.m_fFuel, true, true );
	
	return self:GetID() < 0 or g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET fuel = " + self.m_fFuel + " WHERE id = " + self:GetID() ) or not Debug( g_pDB:Error(), 1 );
end

function CVehicle:UpdateFuel( pPlayer )
	if self:HaveFuel() then
		local pFuelCfg = FuelConfig[ self:GetHandling().engineType ] or FuelConfig.petrol;
		
		if self.m_bEngine then
			local fLoss		= ( pFuelCfg.fLoss + ( FuelConfig[ self:GetModel() ] or FuelConfig.default ).fLoss ) * ( pPlayer and pPlayer:GetControlState( 'accelerate' ) and 1.0 or .8 );
			
			self.m_fFuel	= math.max( self.m_fFuel - fLoss, 0 );
			
			self:SetData( 'fuel', self.m_fFuel, true, true );
			
			if self.m_fFuel <= 0 then
				if pPlayer then
					pPlayer:Hint( "Внимание!", "В Вашем автомобиле закончилось топливо", "error" );
				end
				
				self:SetFuel( 0 );
				
				self.m_bEngine = false;
			elseif math.floor( self.m_fFuel ) == 10 then
				if pPlayer then
					pPlayer:Hint( "Внимание!", "В Вашем автомобиле заканчивается топливо", "warning" );
				end
			end
		elseif pPlayer and pPlayer:IsInGame() and pPlayer.m_pFuel then
			if pPlayer.m_bRefill then
				if pPlayer.m_pVehicle:GetID() ~= self:GetID() then
					pPlayer:FinalizeFuel();
					
					Debug( (string)( self ) + "|" + (string)( pPlayer.m_pVehicle ), 0 );
					
					return;
				end
				
				local iPrice = pFuelCfg.iPrice * pFuelCfg.iRefillRatio;
				
				if pPlayer:GetChar():GetMoney() >= iPrice then
					if self.m_fFuel >= 100 then
						pPlayer:Hint( "Информация", "Ваш автомобиль полностью заправлен", "ok" );
						pPlayer:FinalizeFuel();
						
						self:SetFuel( 100 );
						
						return;
					end
					
					pPlayer:GetChar():TakeMoney( iPrice );
					g_pInteriorFisc:GiveMoney( iPrice );
					
					self.m_fFuel = math.min( 100, self.m_fFuel + pFuelCfg.iRefillRatio );
					self:SetData( 'fuel', self.m_fFuel, true, true );
				else
					pPlayer:Hint( "Ошибка", "У Вас недостаточно денег для заправки автомобиля", "error" );
					pPlayer:FinalizeFuel();
					
					self:SetFuel( self.m_fFuel );
				end
			else
				pPlayer:Hint( "Подсказка", "\nДля заправки, заглушите двигатель \nи удерживайте клавишу 'Space'", "info" );
			end
		end
	end
end

function CPlayer:InitFuel( pVehicle )
	if pVehicle:HaveFuel() then
		if not self:IsKeyBound( "space", "both", FillVehicle ) then
			self:Hint( "Подсказка", "\nДля заправки, заглушите двигатель \nи удерживайте клавишу 'Space'", "info" );
			self:BindKey( "space", "both", FillVehicle );
			
			return true;
		end
	end
	
	return false;
end

function CPlayer:FinalizeFuel()
	self:UnbindKey( "space", "both", FillVehicle );
	
	self.m_bRefill 	= NULL;
	self.m_pFuel	= NULL;
end

function FillVehicle( pPlayer, key, state )
	if pPlayer and pPlayer:IsInGame() then
		local pVehicle = pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
		
		if pVehicle then
			pPlayer.m_bRefill = state == 'down' and not pVehicle.m_bEngine and true or NULL;
			
			return;
		end
	end
	
	pPlayer.m_bRefill	= NULL;
	pPlayer.m_pFuel		= NULL;
	pPlayer:UnbindKey( "space", "both", FillVehicle );
end

local function OnFuelHit( pFuel, pPlayer, bMatching )
	if bMatching and getElemenType( pPlayer ) == "player" and pPlayer:IsInGame() then
		local pVehicle = pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
		
		if pVehicle then
			if pPlayer:InitFuel( pVehicle ) then
				pPlayer.m_pFuel		= pFuel;
				pPlayer.m_bRefill 	= NULL;
			end
		end
	end
end

local function OnFuelLeave( pFuel, pPlayer, bMatching )
	if bMatching and getElemenType( pPlayer ) == "player" then
		pPlayer:FinalizeFuel();
	end
end

function AddFuelpoint( data )
	local pFuel = CColShape( 'Tube', data.x, data.y, data.z, 1.5, 3.0 );
	
	pFuel:SetParent( pFuelRoot );
	
	pFuel.OnHit		= OnFuelHit;
	pFuel.OnLeave	= OnFuelLeave;
end