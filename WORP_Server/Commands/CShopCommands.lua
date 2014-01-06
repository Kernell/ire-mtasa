-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CShopCommands";

function CShopCommands:Create( pPlayer, sCmd, sOption, sType, siPickup, sfPriceMultiple )
	local vecPosition	= self:GetPosition();
	local iInterior		= self:GetInterior();
	local iDimension	= self:GetDimension();
	
	local pShop = g_pGame:GetShopManager():Create( vecPosition, iInterior, iDimension, iDimension, sType, tonumber( siPickup ), sfPriceMultiple );
	
	if pShop then
		return TEXT_SHOPS_CREATED:format( pShop:GetID() ), 0, 255, 255;
	end
	
	return TEXT_DB_ERROR, 255, 0, 0;
end

function CShopCommands:Delete( pPlayer, sCmd, sOption, sID )
	local iID = tonumber( sID );
	
	if iID then
		local pShop = g_pGame:GetShopManager():Get( iID );
		
		if pShop then
			if g_pGame:GetShopManager():Remove( pShop ) then
				return TEXT_SHOPS_DELETED:format( iID ), 255, 100, 0;
			end
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return TEXT_SHOPS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CShopCommands:AddItem( pPlayer, sCmd, sOption, sID, sItem )
	local iID = tonumber( sID );
	
	if iID and sItem then
		local pShop = g_pGame:GetShopManager():Get( iID );
		
		if pShop then
			local rItem = g_pGame:GetItemManager():GetItem( sItem );
			
			if rItem then
				local iErrorCode = g_pGame:GetShopManager():AddShopItem( pShop, rItem );
				
				if iErrorCode == -1 then
					return TEXT_SHOPS_ITEM_ADDED:format( sItem, pShop:GetID() ), 0, 255, 255;
				end
				
				if iErrorCode == 1 then
					return TEXT_DB_ERROR, 255, 0, 0;
				end
				
				if iErrorCode == 0 then
					return TEXT_SHOPS_ITEM_ALREADY_ADDED, 255, 0, 0;
				end
			end
			
			return TEXT_ITEMS_INVALID_ID, 255, 0, 0;
		end
		
		return TEXT_SHOPS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CShopCommands:RemoveItem( pPlayer, sCmd, sOption, sID, sItem )
	local iID = tonumber( sID );
	
	if iID and sItem then
		local pShop = g_pGame:GetShopManager():Get( iID );
		
		if pShop then
			local rItem = g_pGame:GetItemManager():GetItem( sItem );
			
			if rItem then
				local iErrorCode = g_pGame:GetShopManager():AddShopItem( pShop, rItem );
				
				if iErrorCode == -1 then
					return TEXT_SHOPS_ITEM_REMOVED:format( sItem ), 0, 255, 255;
				end
				
				if iErrorCode == 1 then
					return TEXT_DB_ERROR, 255, 0, 0;
				end
				
				if iErrorCode == 0 then
					return TEXT_SHOPS_NOT_ADDED:format( sItem ), 255, 0, 0;
				end
			end
			
			return TEXT_ITEMS_INVALID_ID, 255, 0, 0;
		end
		
		return TEXT_SHOPS_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end
