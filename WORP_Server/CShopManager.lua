-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CShopManager ( CManager )
{
	CShopManager	= function( this )
		this:CManager();
	end;
};

function CShopManager:Init()
	self.m_List	= {};
	
	if not g_pDB then return Debug( TEXT_E2451:format( "g_pDB" ), 1 ) end
	if not g_pDB:Ping() then return end
	
	local pResult = g_pDB:Query( "SELECT id, interior_id, pickup, type, position, interior, dimension, items, money, price_multiple FROM " + DBPREFIX + "shops WHERE deleted = 'No' ORDER BY id ASC" );
	
	if pResult then
		for _, pRow in ipairs( pResult:GetArray() ) do
			CShop( pRow.id, pRow.interior_id, pRow.pickup, pRow.type, Vector3( pRow.position ), pRow.interior, pRow.dimension, pRow.items, pRow.money, pRow.price_multiple );
		end
	
		delete ( pResult );
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	return true;
end

function CShopManager:Create( vecPosition, iInterior, iDimension, iInteriorID, sType, iPickup, fPriceMultiple )
	local iShopID = g_pDB:Insert( DBPREFIX + "shops",
		{
			interior_id		= iInteriorID;
			pickup			= iPickup or NULL;
			type			= sType or "none";
			position		= (string)(vecPosition);
			interior		= iInterior;
			dimension		= iDimension;
			price_multiple	= fPriceMultiple or 1.0;
		}
	);
	
	if iShopID then
		return CShop( iShopID, iInteriorID, iPickup, sType or "none", vecPosition, iInterior, iDimension, NULL, 0, fPriceMultiple );
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return NULL;
end

function CShopManager:Remove( pShop )
	if g_pDB:Query( "UPDATE " + DBPREFIX + "shops SET deleted = 'Yes' WHERE id = " + pShop:GetID() ) then
		delete ( pShop );
		pShop = NULL;
		
		return true;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return false;
end

function CShopManager:AddShopItem( pShop, rItem )
	if pShop:AddItem( rItem ) then
		if not g_pDB:Query( "UPDATE " + DBPREFIX + "shops SET items = '" + table.concat( pShop.m_Items, ',' ) + "' WHERE id = " + pShop:GetID() ) then
			Debug( g_pDB:Error(), 1 );
			
			pShop:RemoveItem( rItem );
			
			return 1;
		end
		
		return -1;
	end
	
	return 0;
end

function CShopManager:RemoveShopItem( pShop, rItem )
	if pShop:RemoveItem( rItem ) then
		local sItems = table.getn( pShop.m_Items ) > 0 and ( "'" + table.concat( pShop.m_Items, ',' ) + "'" ) or 'NULL';
		
		if not g_pDB:Query( "UPDATE " + DBPREFIX + "shops SET items = " + sItems + " WHERE id = " + pShop:GetID() ) then
			Debug( g_pDB:Error(), 1 );
			
			pShop:AddItem( rItem );
			
			return 1;
		end
		
		return -1;
	end
	
	return 0;
end
