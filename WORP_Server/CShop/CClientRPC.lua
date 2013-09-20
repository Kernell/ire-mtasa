-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

function CClientRPC:BuyItem( iShopID, sItem )
	if self:IsInGame() then
		local pShop = g_pGame:GetShopManager():Get( iShopID );
		
		if pShop then
			pShop:BuyItem( self, sItem );
		else
			Debug( "Player " + self:GetName() + " requested invalid shop " + (string)(iShopID), 1 );
		end
	end
end

function CClientRPC:BuySkin( iShopID, sItem )
	if self:IsInGame() then
		local pShop = g_pGame:GetShopManager():Get( iShopID );
		
		if pShop then
			pShop:BuySkin( self, sItem );
		else
			Debug( "Player " + self:GetName() + " requested invalid shop " + (string)(iShopID), 1 );
		end
	end
end

function CClientRPC:RestoreSkin()
	if self:IsInGame() then
		self:Client().setElementModel( self, self:GetChar().m_iSkin );
		self:SetModel( self:GetChar().m_iSkin );
	end
end