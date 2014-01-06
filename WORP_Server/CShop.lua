-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local OldItems	=
{
	wpn_ak47						= "wpn_ak107m";
	wpn_usp45_silinced				= 0;
	wpn_shotgun_ammo				= "ammo_12x76";
	wpn_spas12_ammo					= "ammo_12x76";
	wpn_mp5_ammo					= "clip_mp5";
	wpn_ak47_ammo					= "clip_ak107m";
	wpn_m4a1_ammo					= "clip_m4a1";
	wpn_aug_ammo					= "clip_aug";
	wpn_scout_ammo					= "clip_scout";
	wpn_rpg_ammo					= "ammo_og_7b";
	wpn_usp45_ammo					= "clip_usp45";
	wpn_usp45_silinced_ammo			= "clip_usp45";
	wpn_desert_eagle_ammo			= "clip_desert_eagle";
	
	wpn_parachute					= "parachute";
	wpn_cane						= 0;
	wpn_pool_cue					= 0;
	wpn_golf_club					= 0;
};

class "CShop";

function CShop:CShop( iID, iInteriorID, iPickupID, sType, vecPosition, iInterior, iDimension, sItems, iMoneys, fPriceMultiple )
	self.m_iID 				= iID;
	self.m_sType			= sType;
	self.m_Items			= {};
	self.m_iInteriorID		= iInteriorID;
	self.m_iMoneys			= iMoneys;
	self.m_fPriceMultiple	= fPriceMultiple;
	
	if sItems then
		local bSave = false;
		
		for i, sItem in ipairs( sItems:split( ( ',' ):byte() ) ) do repeat
			local rItem = g_pGame:GetItemManager():GetItem( sItem );
			
			if not rItem then
				if tonumber( sItem ) then
					rItem = g_pGame:GetItemManager():GetItem( "skin_" + sItem );
					
					if rItem then
						bSave = true;
					end
				elseif OldItems[ sItem ] then
					if OldItems[ sItem ] == 0 then
						bSave = true;
						
						break;
					end
					
					rItem = g_pGame:GetItemManager():GetItem( OldItems[ sItem ] );
					
					if rItem then
						bSave = true;
					end
				end
			end
			
			if not rItem then
				Debug( "Invalid item '" + (string)(sItem) + "'", 2 );
				
				break; -- continue;
			end
			
			table.insert( self.m_Items, rItem );
		until true end
		
		if bSave then
			local Items = {};
			
			for key, value in ipairs( self.m_Items ) do
				table.insert( Items, classname( value ) );
			end
			
			if not g_pDB:Query( "UPDATE " + DBPREFIX + "shops SET items = '" + table.concat( Items, "," ) + "' WHERE id = " + self:GetID() ) then
				Debug( g_pDB:Error(), 1 );
			end
		end
	end
	
	if iPickupID then
		self.m_pMarker	= CPickup.Create( vecPosition, 3, iPickupID );
	else
		vecPosition.Z	= vecPosition.Z - 0.9;
		
		self.m_pMarker	= CMarker.Create( vecPosition, "cylinder", 1.0, 255, 255, 0, 196 );
	end
	
	self.m_pMarker.m_pShop		= self;
	self.m_pMarker:SetInterior	( iInterior );
	self.m_pMarker:SetDimension	( iDimension );
	
	g_pGame:GetShopManager():AddToList	( self );
	
	self.m_pMarker.OnHit 		= CShop.OnMarkerHit;
end

function CShop:_CShop()
	g_pGame:GetShopManager():RemoveFromList( self );
	
	delete ( self.m_pMarker );
	self.m_pMarker = NULL;
end

function CShop.OnMarkerHit( this, pPlayer, bMatching )
	if ( bMatching or this:type() == 'pickup' ) and pPlayer:type() == 'player' and pPlayer:IsInGame() then
		this.m_pShop:InitDialog( pPlayer, this.m_pShop.m_iID );
	end
	
	return false;
end

function CShop:InitDialog( pPlayer )
	if self.m_sType == 'weapons' and not pPlayer:GetChar():GetLicense( 'weapon' ) then
		pPlayer:Hint( "Ошибка", "\nУ Вас нет лицензии на оружие!", "error" );
		
		return false;
	end
	
	local Items = {};
			
	for _, rItem in ipairs( self.m_Items ) do repeat
		if rItem.m_iSlot == 3 and rItem.m_sGender ~= pPlayer:GetSkin().GetGender() then break; end -- continue;
		
		table.insert( Items, 
			{
				m_ID		= classname( rItem );
				m_sName 	= rItem.m_sName;
				m_iCost 	= rItem.m_iCost * self.m_fPriceMultiple;
				m_pItem		= rItem;
			}
		);
	until true end
	
	local pInterior = g_pGame:GetInteriorManager():Get( self.m_iInteriorID );
	
	if table.getn( Items ) == 0 then
		return false, pPlayer:Hint( pInterior and pInterior:GetName() or "Ошибка", "\nЭтот магазин закрыт или не подходит для Вашего персонажа", "error" );
	end
	
	if self.m_sType == 'skins' then
		pPlayer:Hint( "Подсказка", "\nИспользуйте клавишу 'M' для включения/выключения курсора мыши", "info" );
	end
	
	local sFunction = 'OpenShopsDialog';
	
	if self.m_sType == 'skins' then
		sFunction = 'SkinSelection';
	end
	
	pPlayer:Client()[ sFunction ]( self:GetID(), pInterior and pInterior:GetName() or "", Items );
	
	return true;
end

function CShop:GetID()
	return self.m_iID;
end

function CShop:AddItem( rItem )
	for _, value in ipairs( self.m_Items ) do
		if value == rItem then
			return false;
		end
	end
	
	table.insert( self.m_Items, rItem );
	
	return true;
end

function CShop:RemoveItem( rItem )
	local bRemoved = false;
	
	for i = table.getn( self.m_Items ), 1, -1 do
		if self.m_Items[ i ] == rItem then
			table.remove( self.m_Items, i );
			
			bRemoved = true;
		end
	end
	
	return bRemoved;
end

function CShop:GiveMoney( iMoneys )
	local pInterior = g_pGame:GetInteriorManager():Get( self.m_iInteriorID );
			
	if pInterior then
		pInterior:GiveMoney( iMoneys - math.floor( iMoneys * .15 ) );
	else
		Debug( "Shop " + (string)(self:GetID()) + " do not have interior", 2 );
	end

	return g_pInteriorFisc:GiveMoney( math.floor( iMoneys * .15 ) );
end

function CShop:GetMoney()
	return self.m_iMoneys;
end

function CShop:IsPlayerNearby( pPlayer, fDistance )
	return self.m_pMarker:GetPosition():Distance( pPlayer:GetPosition() ) <= fDistance and self.m_pMarker:GetDimension() == pPlayer:GetDimension() and self.m_pMarker:GetInterior() == pPlayer:GetInterior();
end

function CShop:BuySkin( pPlayer, sItem )
	local rItemClass = g_pGame:GetItemManager():GetItem( sItem );
	
	if self:BuyItem( pPlayer, sItem ) then
		pPlayer:GetChar():SetSkin( rItemClass.m_iModel );

		return true;
	end
	
	return false;
end

function CShop:BuyItem( pPlayer, sItem )
	if not self:IsPlayerNearby( pPlayer, 3.0 ) then
		return false;
	end
	
	local rItem		= g_pGame:GetItemManager():GetItem( sItem );
	local iPrice	= rItem.m_iCost * self.m_fPriceMultiple;

	if iPrice <= pPlayer:GetChar():GetMoney() then
		if not pPlayer:GetChar():GiveItem( sItem ) then
			pPlayer:Hint( "Недостаточно места", "Все слоты заняты!", "error" );
			
			return false;
		end
		
		pPlayer:GetChar():TakeMoney( iPrice );
		pPlayer:PlaySoundFrontEnd( 10 );
		
		self:GiveMoney( iPrice );
		self:InitDialog( pPlayer );
		
		return true;
	else
		pPlayer:Hint( "Ошибка", "У Вас недостаточно денег", "error" );
	end
	
	return false;
end