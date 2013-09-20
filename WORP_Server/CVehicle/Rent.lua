-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

function CVehicle:SetRentTime( iSeconds )
	if type( iSeconds ) == 'number' then
		assert( g_pDB:Query( "UPDATE " .. DBPREFIX .. "vehicles SET rent_time = %d WHERE id = %d", iSeconds, self:GetID() ) );
		
		self.m_iRentTime = iSeconds;
		
		return true;
	else
		error( TEXT_E2342:format( 'iSeconds', 'number', type( iSeconds ) ), 2 );
	end
	
	return false
end

function CVehicle:SetRentPrice( iAmount )
	if type( iAmount ) == 'number' then
		assert( g_pDB:Query( "UPDATE " .. DBPREFIX .. "vehicles SET rent_price = %d WHERE id = %d", iAmount, self:GetID() ) );
		
		self.m_iRentPrice = iAmount;
		
		return true;
	else
		error( TEXT_E2342:format( 'iAmount', 'number', type( iAmount ) ), 2 );
	end
	
	return false
end

function CVehicle:SetRentable( bRentable )
	self.m_bRentable = tobool( bRentable );
	
	assert( g_pDB:Query( "UPDATE " .. DBPREFIX .. "vehicles SET rentable = %q WHERE id = %d", self.m_bRentable and 'Yes' or 'No', self:GetID() ) );
	
	return true;
end

function CVehicle:GetRentTime()
	return self.m_iRentTime;
end

function CVehicle:GetRentPrice()
	return self.m_iRentPrice;
end

function CVehicle:IsRentable()
	return self.m_bRentable;
end

---

function CVehicle:UpdateRent()
	if self.m_bRentable then
		local iCharID = self:GetOwner();
		
		if self.m_iRentTime > 0 then
			self.m_iRentTime = self.m_iRentTime - 1;
		end
		
		if iCharID > 0 then
			local pPlayer = g_pGame:GetPlayerManager():GetByCharID( iCharID );
			
			if pPlayer then
				if self.m_iRentTime == 0 then
					pPlayer:Hint( "Аренда автомобиля", "Время аренды вышло", "warning" );
					
					if pPlayer:GetVehicle() == self then
						pPlayer:RemoveFromVehicle();
					end
				elseif self.m_iRentTime % 60 == 0 and self.m_iRentTime <= 300 then
					pPlayer:Hint( "Аренда автомобиля", "Времени осталось: " + math.decl( self.m_iRentTime / 60, 'минута', 'минуты', 'минут' ), 'warning' );
				end
			end
			
			if self.m_iRentTime == 0 then
				self:SetOwner( NULL );
				self:RespawnSafe();
			end
		end
	end
end