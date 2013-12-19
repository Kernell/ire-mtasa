-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CBank
{
	static
	{
		m_sImportFields	= { "id", "faction", "amount", "type", "currency_id", "locked" };
	};
	
	CBank	= function( this, iID, vecPosition, vecRotation, iInterior, iDimension, iModel )
		this.m_iID = iID or (int)((string)(this) - "table: ");
		
		if iModel then
			this.m_pObject = CObject.Create( iModel, vecPosition - Vector3( 0.0, 0.0, .325 ), vecRotation + Vector3( 0.0, 0.0, 180.0 ) );
			
			this.m_pObject:SetInterior( iInterior );
			this.m_pObject:SetDimension( iDimension );
			this.m_pObject:SetFrozen( true );
			
			vecPosition	= vecPosition:Offset( 1.2, vecRotation.Z );
		end
		
		vecPosition.Z	= vecPosition.Z - 0.81;
		
		this.m_pMarker	= CMarker.Create( vecPosition, "cylinder", 1.0, 0, 255, 0, 128 );
		
		this.m_pMarker:SetInterior	( iInterior );
		this.m_pMarker:SetDimension	( iDimension );
		
		if this.m_pObject then
			this.m_pObject:SetParent( this.m_pMarker );
		end
		
		this.m_pMarker.m_pBank	= this;
		this.m_pMarker.OnHit	= CBank.OnHit;
		
		g_pGame:GetBankManager():AddToList( this );
	end;
	
	_CBank	= function( this )
		delete ( this.m_pMarker );
		this.m_pMarker = NULL;
		
		if this.m_pObject then
			delete ( this.m_pObject );
			this.m_pObject = NULL
		end
		
		g_pGame:GetBankManager():RemoveFromList( this );
	end;
	
	GetID	= function( this )
		return this.m_iID;
	end;
	
	OnHit	= function( pMarker, pClient, bMatching )
		if bMatching and classname( pClient ) == "CPlayer" and not pClient:IsInVehicle() then
			local pChar = pClient:GetChar();
			
			if pChar then
				if pMarker.m_pBank.m_pObject then
					pMarker.m_pBank:OnATMHit( pChar );
				else
					pMarker.m_pBank:OnBankHit( pChar );
				end
			end
		end
	end;
	
	OnATMHit	= function( this, pChar )
		local Cards 	= {};
		local iCards	= 0;
		
		for i, pItm in pairs( pChar:GetItems()[ ITEM_SLOT_NONE ] ) do
			if pItm.m_bBankCard == true and pItm.m_Data.m_sID then
				table.insert( Cards, pItm.m_Data.m_sID );
				
				iCards = iCards + 1;
			end
		end
		
		if iCards == 0 then
			return pChar.m_pClient:Hint( "Ошибка", "У Вас нет банковских карт", "error" );
		end
		
		pChar:ShowUI( "CUIBankATM", Cards );
	end;
	
	OnBankHit	= function( this, pChar )
		local Accounts = g_pGame:GetBankManager():GetInfo( pChar, CBank.m_sImportFields );
		
		pChar:ShowUI( "CUIBank", Accounts );
	end;
};
