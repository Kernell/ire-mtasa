-- WORP Engine v1.0.0
--
-- Author		Kernell
-- Copyright	© 2011 - 2012
-- License		Proprietary Software
-- Version		1.0

class: CWeapon ( CItem );

function CWeapon:CWeapon( rItem )
	self:CItem( rItem );
	
	self.m_AmmoClass	= CItemManager:GetItem( self.m_sAmmoClass );
end

function CWeapon:_CWeapon()
	self:_CItem();
end

function CWeapon:GetCompatibleClips( Items )
	local Clips = {};
	
	for _, pClip in ipairs( Items[ ITEM_SLOT_CLIP_AMMO ] ) do
		if self.m_sClassName == pClip.m_sWeaponClass then
			table.insert( Clips, pClip );
		end
	end
	
	return Clips;
end

function CWeapon:Take()
	local pOwner = self.m_pOwner;
	
	if CItem.Take( self ) > 0 then
		if classof( pOwner ) == CChar then
			pOwner.m_pClient:TakeAllWeapons();
		end
	end
end

function CWeapon:Use()
	self.m_pOwner:SelectWeaponSlot( self.m_iSlot );
	
	return true;
end