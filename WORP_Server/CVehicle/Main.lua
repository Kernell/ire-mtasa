-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

function CVehicle:DoPulse( tReal )
	local fHealth 	= self:GetHealth();
	local pPlayer 	= self:GetDriver();
	
	if self:GetEngineState() then
		if fHealth < 300.0 then
			self.m_bEngine = false;
			
			if pPlayer and classof( pPlayer ) == CPlayer then
				pPlayer:Hint( "Двигатель заглох", "Ваш автомобиль сильно повреждён", "warning" );
			end
		elseif fHealth < 400.0 and math.random( 5 ) == 5 then
			self.m_bEngine = false;
			
			if pPlayer and classof( pPlayer ) == CPlayer then
				pPlayer:Hint( "Двигатель заглох", "Ваш автомобиль сильно повреждён", "warning" );
			end
		end
	end
	
	if pPlayer then
		if ( self.m_bDamageProof or fHealth < 250.0 ) and not self:IsDamageProof() then
			self:SetDamageProof( true );
		elseif self:IsDamageProof() and fHealth >= 300.0 and not self.m_bDamageProof then
			self:SetDamageProof( false );
		end
		
		self.m_iRespawnIdleTime = 0;
	else
		self.m_iRespawnIdleTime = ( self.m_iRespawnIdleTime or 0 ) + 1;
		
		if self:GetID() > 0 and self:GetJob() and self.m_iRespawnIdleTime >= 1440 then
			self.m_iRespawnIdleTime = 0;
			
			self:RespawnSafe();
		end
		
		if not self:IsDamageProof() then
			self:SetDamageProof( true );
		end
	end
	
	if not self.m_bFrozen then
		if not self:IsFrozen() then
			if not self:GetTowingVehicle() and self:IsOnGround() and not pPlayer and self:GetSpeed() <= 1.0 then
				self:SetFrozen( true );
			end
		else
			if self:GetTowingVehicle() or not self:IsOnGround() or pPlayer then
				self:SetFrozen( false );
			end
		end
	end
	
	if fHealth < 250.0 then
		self:SetHealth( 250.0 );
	end
	
	if self:GetEngineState() ~= self.m_bEngine then
		self:SetEngineState( self.m_bEngine );
	end
	
	if pPlayer and classof( pPlayer ) == CPlayer then
		self:UpdateFuel( pPlayer );
	end
	
	self:UpdateRent();
	
	if self.m_pTuning then 
		self.m_pTuning:DoPulse();
	end
end

function CVehicle:OnDamage( fLoss )
	if self:GetHealth() < 250 or fLoss > self:GetHealth() then
		self:SetDamageProof( true );
		self:SetHealth( 250 );
		
		return 0;
	end
	
	return 1;
end

function CVehicle:OnStartEnter( pPlayer, iSeat )
	local pBoneObject = pPlayer:GetBones():GetObject( 12 );
		
	if pBoneObject and pBoneObject.m_rItem and pBoneObject.m_rItem.m_iSlot == 5 then
		return 0;
	end
	
	if pPlayer.m_pTeleportMarker or not pPlayer:IsCollisionsEnabled() then
		return 0;
	end
	
	if self:GetID() == INVALID_ELEMENT_ID or ( self:IsRentable() and self:GetOwner() == 0 ) then
		if iSeat == 0 and ( self.shop_id or self:IsRentable() ) then
		--	{ "Название:", "Цена:", "Вес:", "Макс. скорость:", "Мощность:", "Привод:", "Тип двигателя:", "Коробка передач:", "ABS:", "Соотношение томрозов:" }
			
			local h 			= self:GetHandling();
			local drive_type	= { rwd = "Задний (RWD)", fwd = "Передний (FWD)", awd = "Полный (AWD)" };
			local engine_type 	= { petrol = 'Бензин', diesel = 'Дизель', electric = 'Электро'; };
			local info			= 
			{ 
				self:GetName(), 
				'$' + ( self:IsRentable() and self:GetRentPrice() or self:GetPrice() ) + ( self:IsRentable() and " - 1 час" or "" ),
				h.mass + ' kg',
				h.maxVelocity + " kmh",
				math.ceil( ( h.engineAcceleration  / h.dragCoeff ) * 25 ) + " hp",
				drive_type[ h.driveType ],
				engine_type[ h.engineType ],
				h.numberOfGears + " ступеней",
				h.ABS and "Есть" or "Нет",
				math.ceil( h.brakeBias * 100 ) + "%",
				bRentable = self:IsRentable();
			};
			
			pPlayer:Client().VehicleBuyDialog( self:IsRentable() and self:GetID() or self.shop_id, info );
		end
		
		return 0;
	end
	
	return 1;
end

function CVehicle:OnEnter( pPlayer, iSeat, pJacker )
	if self:GetID() == INVALID_ELEMENT_ID then
		pPlayer:RemoveFromVehicle();
		
		return 0;
	end
	
	if classname( pPlayer ) ~= 'CPlayer' then
		return 1;
	end
	
	pPlayer.m_pVehicle = self;
	
	self:SetFrozen( false );
	self:SetEngineState( self.m_bEngine );
	
	if self.m_pSiren.m_iType > 0 and iSeat <= 1 then
		pPlayer:Hint( "Управление", TEXT_HELP_POLICE_CAR_BINDS, "info" );
	end
	
	if iSeat == 0 then
		self.m_sLastDriver	= pPlayer:GetName();
		self.m_iLastTime	= getRealTime().timestamp;
		
		self:SetData( 'last_driver', self.m_sLastDriver );
		self:SetData( 'last_time', self.m_iLastTime );
		
		if self:GetJob() then
			pPlayer:InitJob();
		else
			if self:HaveFuel() and pPlayer:HasKey( self ) then
				pPlayer:Hint( "Управление", TEXT_HELP_CAR_BINDS, "info" );
			end
		end
		
		if pPlayer.m_pFuel and pPlayer:IsWithinColShape( m_pFuel ) then
			pPlayer:InitFuel( self );
		end
		
		if not pPlayer:GetChar():GetLicense( 'vehicle' ) and self:GetModel() ~= 462 then
			pPlayer:Hint( "Warning", "У Вас нет водительских прав!\n\nВас может арестовать полиция!", "warning" );
		end
	elseif iSeat > 0 and self:GetModel() == 497 then
		pPlayer:Hint( "Info", "\nSpace - Спуститься по верёвке", "info" );
		pPlayer:BindKey( "space", "up", "vehicle", "swatrope" );
	end
	
	return 1;
end

function CVehicle:OnStartExit( pPlayer, iSeat, pJacker, iDoor )
	if pJacker then	
		return 1;
	end
	
	if self.m_pTuning then
		return 0;
	end
	
	if pPlayer:IsCuffed() and not pPlayer.m_bForceExitVehicle then
		pPlayer:Hint( 'Ошибка', 'Вы в наручниках', 'error' );
		
		return 0;
	end
	
	if self:IsLocked() then
		if CVehicleCommands:ToogleLocked( pPlayer ) == 0 then		
			pPlayer:Hint( 'Ошибка', 'Двери заблокированы', 'error' );
			
			return 0;
		end
	end
	
	if iSeat == 0 then
		self.m_pSiren:SetState( 0, self.m_pSiren.m_iWhelenState );
	end
	
	self:Horn( false );
	
	pPlayer.m_pVehicle 		= NULL;
	
	return 1;
end

function CVehicle:OnExit( pPlayer, iSeat, pJacker )
	pPlayer.m_pVehicle 		= NULL;
	pPlayer.m_pOldVehicle	= self;
	
	if iSeat == 0 then
		self.m_sLastDriver	= pPlayer:GetName();
		self.m_iLastTime	= getRealTime().timestamp;
		
		self:SetData( 'last_driver', self.m_sLastDriver );
		self:SetData( 'last_time', self.m_iLastTime );
		
		self:Save();
		
		pPlayer:EndCurrentJob();
	else
		if pPlayer.swat_rope then
			pPlayer:AttachToSWATRope( pPlayer.swat_rope );
			
			pPlayer.swat_rope = NULL;
		end
	end
	
	pPlayer:UnbindKey( "space", "up", "vehicle", "swatrope" );
	pPlayer:SetControlState( 'enter_exit', false );
	
	return 1;
end

function CVehicle:OnRespawn()
	local pPlayer = self:GetDriver();
	
	if pPlayer then
		pPlayer:EndCurrentJob();
	end
	
	self:SetInterior( self.default_interior );
	self:SetDimension( self.default_dimension );
	
	return 1;
end

function CVehicle:OnExplode()
	local pPlayer = self:GetDriver();
	
	if pPlayer then
		pPlayer:EndCurrentJob();
	end
	
	self.m_pSiren:SetState();
	self:Horn( false );
	
	if self:GetOwner() == -105 then
		if self.m_TJobCarrierCar and self.m_TJobCarrierCar.m_aVehicles then
			for i, veh in ipairs( self.m_TJobCarrierCar.m_aVehicles ) do
				veh:Destroy();
			end
			
			self.m_TJobCarrierCar = NULL;
		end
	end
	
	setTimer(
		function()
			self:Fix();
			self:SetDamageProof( true );
			self:SetHealth( 250 );
		end, 500, 1
	);
	
	return 0;
end