-- WORP Engine v1.0.0
--
-- Author		Kernell
-- Copyright	© 2011 - 2012
-- License		Proprietary Software
-- Version		1.0

class: CFood ( CItem );

function CFood:CFood( rItem )
	self:CItem( rItem );
	
	
end

function CFood:_CFood()
	self:_CItem();
end

function CFood:Use()
	if self.m_iBone2 then
		local pPlayerBones = self.m_pOwner.m_pClient:GetBones();
		
		if pPlayerBones:IsBusy( self.m_iBone2 ) or self.m_pOwner:GetWeapon() then
			self.m_pOwner.m_pClient:Hint( "Ошибка", "Ваши руки заняты", "error" );
			
			return false;
		end
		
		if self.m_pOwner.m_pClient:SetAnimation( CPlayerAnimation.PRIORITY_FOOD, self.m_sAnimLib, self.m_sAnimName, 0, false, false, false, true ) then
			self.m_pOwner:SetHealth		( self.m_pOwner:GetHealth() + self.m_fHealth );
			self.m_pOwner:SetAlcohol	( self.m_pOwner:GetAlcohol() + self.m_fAlcohol );
--			self.m_pOwner:SetSatiety	( self.m_pOwner:GetSatiety() + self.m_fSatiety );
			self.m_pOwner:SetPower		( self.m_pOwner:GetPower() + self.m_fPower );
			
			self.m_pOwner.m_pClient:Me( self.m_pOwner.m_pClient:Gender( "съел ", "съела " ) + self.m_sName2 );
			
			local pBoneObject = self.m_iModel ~= -1 and pPlayerBones:AttachObject( self.m_iBone2, self.m_iModel, self.m_vecBone2Pos, self.m_vecBone2Rot );
			
			local pPlayer = self.m_pOwner.m_pClient;
			
			setTimer(
				function()
					if pPlayer:IsInGame() then
						pPlayer:SetAnimation( CPlayerAnimation.PRIORITY_FOOD, "PED", "facanger", 0, false, false, false, false );
					end
					
					if pBoneObject then
						delete ( pBoneObject );
						pBoneObject = NULL;
					end
				end, self.m_iAnimTime, 1
			);
			
			g_pGame:GetItemManager():Remove( self );
			
			return true;
		end
		
		self.m_pOwner.m_pClient:Hint( "Ошибка", "Операция недоступна в данный момент", "error" );
		
		return false;
	end
	
	return true;
end