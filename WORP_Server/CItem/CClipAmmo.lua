-- WORP Engine v1.0.0
--
-- Author		Kernell
-- Copyright	© 2011 - 2012
-- License		Proprietary Software
-- Version		1.0

class: CClipAmmo ( CItem );

function CClipAmmo:CClipAmmo( rItem )
	self:CItem( rItem );
	self.CItem = NULL;
	
	self.m_iValue 	= (int)(rItem.m_iClipSize);
end

function CClipAmmo:_CClipAmmo()
	self:_CItem();
end

function CClipAmmo:Use( pChar )	
	-- // TODO: зарядить оружие в руках
	
	return true;
end