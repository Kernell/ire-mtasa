-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

function CClientRPC:UseItem( pItem )
	local pChar = self:GetChar();
	
	if pChar then
		local pItem = g_pGame:GetItemManager():Get( pItem.m_ID );
		
		if pItem then			
			pItem:Use();
			
			pChar:SetInventoryItems( pChar:GetItems() );
		end
	end
end

function CClientRPC:DropItem( pItem, bShow )
	local pChar = self:GetChar();
	
	if pChar then
		local pItem = g_pGame:GetItemManager():Get( pItem.m_ID );
		
		if pItem then
			if pItem.m_iModel == -1 then
				self:MessageBox( "DropItemCallback", "Если Вы выбросите этот предмет, то больше не сможете его подобрать.\nВы действительно хотите выбросить этот предмет?", "Выбросить предмет", MessageBoxButtons.YesNo, MessageBoxIcon.Question, pItem:GetID() );
				
				pChar:HideInventory();
				
				return;
			end
			
			pChar:DropItem( pItem );
		end
		
	--	pChar:SetInventoryItems( pChar:GetItems() );
	end
end

function CClientRPC:DropItemCallback( sBtnName, sButton, sState, iItemID )
	if sBtnName ~= "Да" then return; end
	
	local pChar = self:GetChar();
	
	if not pChar then return; end

	pChar:ShowInventory();
	
	local pItem = g_pGame:GetItemManager():Get( iItemID );
	
	if not pItem then
		self:Hint( "Ошибка", "Предмет который Вы пытаетесь выбросить - не сущестувет", "error" );
		
		return;
	end
	
	if pItem.m_pOwner ~= pChar then
		self:Hint( "Ошибка доступа", "Предмет который Вы пытаетесь выбросить - не пренадлежит Вам", "error" );
		
		return;
	end
	
	pChar:DropItem( pItem );
end

function CClientRPC:ReleaseClip( pWeapon )
	local pChar = self:GetChar();
	
	if pChar then
		local pWeapon = g_pGame:GetItemManager():Get( pWeapon.m_ID );
		
		if pWeapon then
			if pWeapon.m_Data.m_sClip and pWeapon.m_Data.m_iAmmo then
				local Data	= 
				{
					m_iAmmo = pWeapon.m_Data.m_iAmmo;
				};
				
				local pItem = pChar:GiveItem( pWeapon.m_Data.m_sClip, { m_iAmmo = pWeapon.m_Data.m_iAmmo } );
				
				pWeapon.m_Data.m_sClip = NULL;
				pWeapon.m_Data.m_iAmmo = NULL;
				pWeapon:Save();
			end
			
			pChar:SetInventoryItems( pChar:GetItems() );
		end
	end
end

function CClientRPC:TransferItem( pItem, pTarget )
	local pChar = self:GetChar();
	
	if pChar and pTarget then
		local pItem = g_pGame:GetItemManager():Get( pItem.m_ID );
		
		if not pItem then
			self:Hint( "Ошибка", "Предмет который Вы пытаетесь передать - не сущестувет", "error" );
			
			return;
		end
		
		if pTarget:GetPosition():Distance( self:GetPosition() ) > 3 then
			self:Hint( "Невозможно передать предмет", "Цель слишком далеко", "error" );
			
			return;
		end
		
		if classof( pTarget ) == CPlayer then
			if not pTarget:IsAdmin() then
				pTarget:MessageBox( "TransferItemCallback", "Передача предмета", self:GetVisibleName() + " предлагает Вам взять предмет " + pItem.m_sName + "\n", MessageBoxButtons.YesNo, MessageBoxIcon.Question, self, pItem:GetID() );
			end
		elseif classof( pTarget ) == CVehicle then
			do
				self:Hint( "Невозможно передать предмет", TEXT_FEATURE_IN_DEVELOPMENT, "error" );
				
				return;
			end
			
			if not pTarget:HaveTrunk() then
				self:Hint( "Невозможно передать предмет", "Этот транспорт не поддерживает данную функцию", "error" );
				
				return;
			end
			
			if not pTarget:GiveItem( pItem ) then
				local sType = pTarget:GetType();
				
				if sType == "Automobile" then
					sType = "автомобиле";
				elseif sType == "Plane" then
					sType = "самолёте";
				elseif sType == "Helicopter" then
					sType = "вертолёте";
				else
					sType = "транспорте";
				end
				
				self:Hint( "Невозможно передать предмет", "В этом " + sType + " недостаточно места", "error" );
			end
		end
		
		pChar:SetInventoryItems( pChar:GetItems() );
	end
end

function CClientRPC:TransferItemCallback( sBtnName, sButton, sState, pFromPlayer, iItemID )
	if sBtnName ~= "Да" then return; end
	
	local pChar = self:GetChar();
	
	if not pChar then return; end
	
	if not pFromPlayer:IsInGame() then
		self:Hint		( "Ошибка доступа", "Игрок который передавал Вам предмет не найден", "error" );
		
		return;
	end
	
	if pFromPlayer:IsAdmin() or self:GetPosition():Distance( pFromPlayer:GetPosition() ) > 3 then
		self:Hint		( TEXT_ITEMS_TRANSFER_FAILED, TEXT_PLAYER_NOT_NEARBY, "error" );
		pFromPlayer:Hint( TEXT_ITEMS_TRANSFER_FAILED, pFromPlayer:IsAdmin() and TEXT_NOT_ALLOWED_IN_ADMINDUTY or "Вы слишком далеко от цели", "error" );
		
		return;
	end
	
	local pItem = g_pGame:GetItemManager():Get( iItemID );
	
	if not pItem then
		self:Hint		( "Ошибка доступа", TEXT_ITEMS_DOES_NOT_EXIST, "error" );
		pFromPlayer:Hint( "Ошибка доступа", TEXT_ITEMS_DOES_NOT_EXIST, "error" );
		
		return;
	end
	
	if pItem.m_pOwner ~= pFromPlayer:GetChar() then
		self:Hint		( "Ошибка доступа", "Предмет который Вы пытаетесь передать - не пренадлежит " + pFromPlayer:GetVisibleName(), "error" );
		pFromPlayer:Hint( "Ошибка доступа", "Предмет который Вы пытаетесь передать - не пренадлежит Вам", "error" );
		
		return;
	end
	
	if not pChar:GiveItem( pItem ) then
		self:Hint		( "Невозможно передать предмет", TEXT_ITEMS_NOT_ENOUGH_SPACE, "error" );
		pFromPlayer:Hint( "Невозможно передать предмет", TEXT_ITEMS_NOT_ENOUGH_SPACE, "error" );
	end
end

function CClientRPC:PickUp( ID )
	local pChar = self:GetChar();
	
	if pChar then
		local pItem = g_pGame:GetItemManager():Get( (int)(ID) );
		
		if pItem then
			if pItem.m_pOwner == NULL then			
				if not pChar:GiveItem( pItem ) then
					self:Hint( "Недостаточно места", "Все слоты заняты!", "error" );
				end
			end
		end
	end
end

function CClientRPC:ReloadWeapon( Clips, ClipAmmo )
	local pChar = self:GetChar();
	
	if pChar then
		if Clips then
			pChar:ReloadWeapon( Clips, ClipAmmo );
		end
	end
end