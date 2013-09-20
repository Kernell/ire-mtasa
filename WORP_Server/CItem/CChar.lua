-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

-- TODO: CCharacterItems

addEvent( "onPlayerWeaponFire", true );

CChar.m_SlotLimits =
{
	[ ITEM_SLOT_NONE ]			= 30;
	
	[ ITEM_SLOT_WEAPON1 ]		= 1;
	[ ITEM_SLOT_WEAPON2 ]		= 1;
	[ ITEM_SLOT_WEAPON3 ]		= 1;
	[ ITEM_SLOT_WEAPON4 ]		= 3;
	
	[ ITEM_SLOT_CLIP_AMMO ]		= 6;
	
	[ ITEM_SLOT_SKINS ]			= 0;
};

function CChar:LoadItems()
	self.m_Items				=
	{
		[ ITEM_SLOT_NONE ]		= {};
		
		[ ITEM_SLOT_WEAPON1 ]	= NULL;
		[ ITEM_SLOT_WEAPON2 ]	= NULL;
		[ ITEM_SLOT_WEAPON3 ]	= NULL;
		[ ITEM_SLOT_WEAPON4 ]	= {};
		
		[ ITEM_SLOT_CLIP_AMMO ]	= {};
		
		[ ITEM_SLOT_SKINS ]		= NULL;
	};
	
	g_pGame:GetItemManager():Load( self );
	
	self.m_iCurrentWeapon	= 0;
	
	self:SetInventoryItems( self.m_Items );
end

function CChar:UnloadItems()
	local pWeaponItem = self:GetWeapon();
	
	if pWeaponItem then
		pWeaponItem:Save();
	end
	
	for i in pairs( self.m_Items ) do
		self.m_Items[ i ].m_pOwner = NULL;
		
		delete ( self.m_Items[ i ] );
		
		self.m_Items[ i ] = NULL;
	end
	
	self.m_Items = NULL;
end

-- bool CChar::ShowItems( CChar* pTarget, bForce = false );

function CChar:ShowItems( pTarget, bForce )
	Warning( 2, 8106, "CChar::ShowItems" );
	-- if self.m_pClient:IsInGame() and pTarget and pTarget.m_pClient:IsInGame() and pTarget.m_Items then
		-- self.m_pClient:Client().CClientInventory( pTarget.m_Items );
		
		-- return true;
	-- end
	
	return false;
end

-- CItem* CChar::GiveItem( std::string sItem, int iValue = NULL, float fCondition = 100.0f, void* Data = NULL );
-- CItem* CChar::GiveItem( void CItemClass, int iValue = NULL, float fCondition = 100.0f, void* Data = NULL );
-- CItem* CChar::GiveItem( CItem* pItem );

function CChar:GiveItem( vItem, iValue, fCondition, Data )
	if typeof( vItem ) == "string" then
		return self:GiveItem( g_pGame:GetItemManager():GetItem( vItem ), iValue, fCondition, Data );
	elseif typeof( vItem ) == "class" then
		if vItem.m_bIsItem then
			local pItem = g_pGame:GetItemManager():Create( vItem, self, NULL, NULL, NULL, NULL, iValue, fCondition, Data );
			
			if pItem then
				self:SetInventoryItems( self.m_Items );
				
				return pItem;
			end
			
			delete ( pItem );
		end
	elseif typeof( vItem ) == "object" then
		if vItem:Give( self ) then
			if g_pDB:Query( "UPDATE " + DBPREFIX + "items SET owner = 'CChar[" + self:GetID() + "]' WHERE id = " + vItem:GetID() ) then
				self:SetInventoryItems( self.m_Items );
				
				return vItem;
			end
		end
	end
	
	return NULL;
end

-- unsigned int CChar::TakeItem( CItem* pItem );
-- unsigned int CChar::TakeItem( void CItemClass, const unsigned int iMaxCount = 1 );
-- unsigned int CChar::TakeItem( char* szItem, const unsigned int iMaxCount = 1 );

function CChar:TakeItem( vItem, iMaxCount )
	if not iMaxCount then iMaxCount = 1; end
	
	if typeof( vItem ) == "string" then
		return self:TakeItem( g_pGame:GetItemManager():GetItem( vItem ), iMaxCount );
	elseif typeof( vItem ) == "class" then
		local iCount		= 0;
		local RemovedItems	= {};
		local Items			= self.m_Items[ vItem.m_iSlot ];
		
		for i = table.getn( Items ), 1, -1 do
			if Items[ i ].m_sClassName == classname( vItem ) and iCount < iMaxCount then
				table.insert( RemovedItems, Items[ i ]:GetID() );
				
				delete ( Items[ i ] );
				
				iCount = iCount + 1;
			end
		end
		
		if g_pDB:Query( "DELETE FROM " + DBPREFIX + "items WHERE id IN( " + table.concat( RemovedItems, ", " ) + " )" ) then
			self:SetInventoryItems( self.m_Items );
			
			return iCount;
		else
			Debug( g_pDB:Error(), 1 );
		end
	elseif typeof( vItem ) == "object" then
		if g_pDB:Query( "DELETE FROM " + DBPREFIX + "items WHERE id = " + vItem:GetID() ) then
			delete ( vItem );
			
			self:SetInventoryItems( self.m_Items );
			
			return 1;
		else
			Debug( g_pDB:Error(), 1 );
		end
	end
	
	return 0;
end

-- CObject* CChar::DropItem( CItem* pItem );

function CChar:DropItem( pItem )
	if pItem.m_pOwner == self then
		local pObject = pItem:Drop();
		
		if pObject then
			self:SetInventoryItems( self.m_Items );
			
			return pItem:Save() and pObject;
		else
			g_pGame:GetItemManager():Remove( pItem );
			
			self:SetInventoryItems( self.m_Items );
		end
	end
	
	return NULL;
end

-- bool CChar::HaveItem( CItem* pItem );
-- bool CChar::HaveItem( void CItemClass );
-- bool CChar::HaveItem( char* szItem );

function CChar:HaveItem( vItem )
	if typeof( vItem ) == 'string' then
		return self:HaveItem( g_pGame:GetItemManager():GetItem( vItem ), iMaxCount );
	elseif typeof( vItem ) == 'class' then
		for i, pItem in pairs( self.m_Items[ vItem.m_iSlot ] ) do
			if pItem.m_sClassName == classname( vItem ) then
				return true;
			end
		end
	elseif typeof( vItem ) == 'object' then
		return vItem.m_pOwner == self;
	end
	
	return false;
end

-- CItem[]* CChar::GetItems();

function CChar:GetItems()
	return self.m_Items;
end

-- CItem* CChar::GetWeapon();

function CChar:GetWeapon( iSlot )
	iSlot = iSlot or self.m_iCurrentWeapon;
	
	if self.m_SlotLimits[ iSlot ] and self.m_SlotLimits[ iSlot ] > 1 then
		return self.m_Items[ iSlot ][ 1 ];
	end
	
	return self.m_Items[ iSlot ];
end

function CChar:ReloadWeapon()
	if self.m_pReloadTime then
		return;
	end
	
	local pWeaponItem = self:GetWeapon();
	
	if pWeaponItem then
		if self.m_pClient:SetAnimationSafe( pWeaponItem.m_AnimReload[ 1 ], pWeaponItem.m_AnimReload[ 2 ], pWeaponItem.m_AnimReload[ 3 ], false, true, false, false ) then
			self.m_pReloadTime = CTimer(
				function()
					self.m_pReloadTime = NULL;
					
					g_pDB:StartTransaction();
					
					local pOldClip	=
					{
						m_sClip		= pWeaponItem.m_Data.m_sClip;
						m_iValue	= pWeaponItem.m_iValue
					};
					
					local pClip = NULL;
					
					for i, pClp in ipairs( self.m_Items[ ITEM_SLOT_CLIP_AMMO ] ) do
						if pWeaponItem.m_sClassName == pClp.m_sWeaponClass and pClp.m_iValue > 0 then
							pClip = pClp;
							
							break;
						end
					end
					
					if pClip then
						pWeaponItem.m_Data.m_sClip		= pClip.m_sClassName;
						pWeaponItem.m_iValue			= pClip.m_iValue;
						pWeaponItem.m_iClipSize			= pClip.m_iClipSize;
						
						self:TakeItem( pClip );
						
						if pOldClip.m_sClip then
							local pItem = self:GiveItem( pOldClip.m_sClip, pOldClip.m_iValue );
						end
						
						pWeaponItem:Save();
					end
					
					-- self.m_pClient:Client().SetWeapon( pWeaponItem );
					self.m_pClient:SetData( "m_pWeapon", pWeaponItem, true, true );
					self.m_pClient:GiveWeapon( pWeaponItem.m_iWeaponType, 1, true );
					self.m_pClient:SetWeaponAmmo( pWeaponItem.m_iWeaponType, -1, -1 );
					
					g_pDB:Commit();
				end,
				pWeaponItem.m_AnimReload[ 3 ], 1
			);
		end
	end
end

function CChar:SelectWeaponSlot( iSlot, bForce )
	local pWeapon		= self:GetWeapon();
	local pNewWeapon	= self:GetWeapon( iSlot );
	
	if pNewWeapon and pNewWeapon.m_iType ~= ITEM_TYPE_WEAPON then
		return true;
	end
	
	if not bForce then
		if self.m_pReloadTime then
			return true;
		end
		
		if self:IsDead() then
			return true;
		end
		
		if self:IsJailed() then
			return false;
		end
		
		if pWeapon ~= pNewWeapon and pNewWeapon and self.m_pClient:GetBones():IsBusy( pNewWeapon.m_iBone2 ) then
			self.m_pClient:Hint( "Ошибка", "\nВаши руки заняты", "error" );
			
			return true;
		end
	end
	
	if self.m_pReloadTime then
		delete ( self.m_pReloadTime );
		self.m_pReloadTime = NULL;
	end
	
	if pNewWeapon and pNewWeapon.m_iModel ~= -1 then
		if pNewWeapon.m_iBone then
			self.m_pClient:GetBones():Release( pNewWeapon.m_iBone );
			pNewWeapon.m_pEntity = NULL;
		end
		
		if pNewWeapon.m_iBone2 then
			self.m_pClient:GetBones():Release( pNewWeapon.m_iBone2 );
			pNewWeapon.m_pEntity = NULL;
		end
	end
	
	if pWeapon then
		pWeapon:Save();
		
		if pWeapon.m_iBone2 and pWeapon.m_iModel ~= -1 then
			self.m_pClient:GetBones():Release( pWeapon.m_iBone2 );
			pWeapon.m_pEntity = NULL;
		end
		
		if pWeapon.m_iBone and pWeapon.m_iModel ~= -1 then
			pWeapon.m_pEntity = self.m_pClient:GetBones():AttachObject( pWeapon.m_iBone, pWeapon.m_iModel, pWeapon.m_vecBonePos, pWeapon.m_vecBoneRot );
		end
	end

	self.m_iCurrentWeapon = pNewWeapon ~= pWeapon and pNewWeapon and pNewWeapon.m_iSlot or 0;
	
	triggerEvent( "onPlayerWeaponSwitch", self.m_pPlayer, 0, -1 );
	
	return false;
end

function CPlayer:OnWeaponSwitch( iPrevWeaponID, iWeaponID )
	local pChar = self:GetChar();
	
	if pChar then
		local pWeaponItem = pChar:GetWeapon();
		
		if pWeaponItem then			
			if pWeaponItem.m_iWeaponType ~= iWeaponID then
				self:GiveWeapon( pWeaponItem.m_iWeaponType, 1, true );
				self:SetWeaponAmmo( pWeaponItem.m_iWeaponType, -1, -1 );
				
				local pClip = pWeaponItem.m_Data.m_sClip and g_pGame:GetItemManager():GetItem( pWeaponItem.m_Data.m_sClip );
				
				if pClip then
					pWeaponItem.m_iClipSize		= pClip.m_iClipSize;
				else
					pWeaponItem.m_iValue		= 0;
					pWeaponItem.m_Data.m_sClip	= NULL;
				end
				
				pWeaponItem:Save();
				
				self:SetData( "m_pWeapon", pWeaponItem, true, true );
				
				if pWeaponItem.m_iBone2 and pWeaponItem.m_iModel ~= -1 then
					self:GetBones():AttachObject( pWeaponItem.m_iBone2, pWeaponItem.m_iModel, pWeaponItem.m_vecBone2Pos, pWeaponItem.m_vecBone2Rot );
				end
			end
			
			return true;
		end
	end
	
	self:SetData( "m_pWeapon", NULL, true, true );
	
	self:TakeAllWeapons();
	
	return false;
end

function CPlayer:OnWeaponFire( iValue, fCondition )
	if self:IsInGame() then
		local pWeaponItem = self:GetChar():GetWeapon();
		
		if pWeaponItem then
			pWeaponItem.m_iValue = iValue;
			
			pWeaponItem.m_fCondition = Clamp( 0, fCondition, 100 );
		end
	end
end

addEventHandler( "onPlayerWeaponSwitch", root, function( ... ) source:OnWeaponSwitch( ... ); end );
addEventHandler( "onPlayerWeaponFire", root, function( ... ) source:OnWeaponFire( ... ); end );
