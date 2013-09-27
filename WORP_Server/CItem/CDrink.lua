-- WORP Engine v1.0.0
--
-- Author		Kernell
-- Copyright	© 2011 - 2012
-- License		Proprietary Software
-- Version		1.0

class: CDrink ( CItem );

function CDrink:CDrink( rItem )
	self:CItem( rItem );
	self.CItem = NULL;
	
	
end

function CDrink:_CDrink()
	if self.m_pOwner and self.m_pOwner.m_pClient then
		local pBoneObject = self.m_pOwner.m_pClient:GetBones():GetObject( 12 );
		
		if pBoneObject.m_rItem == self then
			self.m_pOwner.m_pClient:GetBones():Release( 12 );
			
			if self.m_fCondition <= 0.0 then
				if not g_pDB:Query( "DELETE FROM " + DBPREFIX + "items WHERE id = " + self:GetID() ) then
					Debug( g_pDB:Error(), 1 );
				end
			end
		end
	end
	
	self:_CItem();
end

function CDrink:Drink()
	if self.m_fCondition > 0.0 then
		if getTickCount() - ( self.m_pOwner.m_pDrinkAnimationTime or 0 ) < 0 then
			return;
		end
		
		if self.m_pOwner.m_pClient:SetAnimation( CPlayerAnimation.PRIORITY_FOOD, self.m_sAnimLib, self.m_sAnimName, self.m_iAnimTime, false, true, false, false ) then
			self.m_fCondition	= Clamp( 0.0, self.m_fCondition - 10.0, 100.0 );
			
			self.m_pOwner:SetHealth		( self.m_pOwner:GetHealth() + self.m_fHealth );
			self.m_pOwner:SetAlcohol	( self.m_pOwner:GetAlcohol() + self.m_fAlcohol );
--			self.m_pOwner:SetSatiety	( self.m_pOwner:GetSatiety() + self.m_fSatiety );
			self.m_pOwner:SetPower		( self.m_pOwner:GetPower() + self.m_fPower );
			
			self.m_pOwner.m_pDrinkAnimationTime = self.m_iAnimTime + getTickCount();
		end
	end
	
	return self.m_fCondition > 0.0;
end

function CDrink:Use()
	if self.m_iBone2 and self.m_fCondition > 0.0 then
		local pPlayerBones = self.m_pOwner.m_pPlayer:GetBones();
		
		if pPlayerBones:IsBusy( self.m_iBone2 ) or self.m_pOwner:GetWeapon() then
			self.m_pOwner.m_pPlayer:Hint( "Ошибка", "Ваши руки заняты", "error" );
			
			return false;
		end
		
		local pBoneObject = pPlayerBones:AttachObject( self.m_iBone2, self.m_iModel, self.m_vecBone2Pos, self.m_vecBone2Rot );
		
		if pBoneObject then
			self.m_pOwner.m_pPlayer:BindKey( "enter", 	"down", "drop_drink" );
			self.m_pOwner.m_pPlayer:BindKey( "f", 		"down", "drop_drink" );
			self.m_pOwner.m_pPlayer:BindKey( "e",		"down", "drink" );
			self.m_pOwner.m_pPlayer:Hint( "Управление", "\nE - Что бы пить\nF или Enter - положить в инвентарь", "info" );
			
			pBoneObject.m_rItem 	= self;
			
			return true;
		end
	end
	
	return true;
end