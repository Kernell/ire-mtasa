-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CClientCharacter
{
	m_iID			= 0;
	m_sName			= "";
	m_sSurname		= "";
	
	m_UI				= NULL;
	m_pInventory		= NULL;
	m_IClientCharacter	= NULL;
	
	CClientCharacter	= function( this, iID, sName, sSurname )
		this.m_UI				= {};
		this.m_iID				= iID;
		this.m_sName			= sName;
		this.m_sSurname			= sSurname;
		
		this.m_pInventory		= CClientInventory();
		this.m_IClientCharacter	= IClientCharacter( this );
	end;
	
	_CClientCharacter	= function( this )
		for sCUI in pairs( this.m_UI ) do
			delete ( this.m_UI[ sCUI ] );
			this.m_UI[ sCUI ] = NULL;
		end
		
		delete ( this.m_pInventory );
		delete ( this.m_IClientCharacter );
		
		this.m_UI 				= NULL;
		this.m_pInventory 		= NULL;
		this.m_IClientCharacter = NULL;
	end;
	
	ToggleInventory		= function( this )
		if this.m_pInventory:IsVisible() then
			this.m_pInventory:Hide();
		else
			this.m_pInventory:Show();
		end
	end;
	
	ShowUI				= function( this, vCUI, ... )
		local sCUI	= NULL;
		
		if type( vCUI ) == "string" then
			sCUI	= vCUI;
		else
			sCUI	= classname( vCUI );
		end
		
		if this.m_UI[ sCUI ] then
			delete ( this.m_UI[ sCUI ] );
			this.m_UI[ sCUI ] = NULL;
		end
		
		this.m_UI[ sCUI ] = _G[ sCUI ]( ... );
	end;
	
	HideUI				= function( this, vCUI )
		local sCUI	= NULL;
		
		if type( vCUI ) == "string" then
			sCUI	= vCUI;
		else
			sCUI	= classname( vCUI );
		end
		
		if this.m_UI[ sCUI ] then
			delete ( this.m_UI[ sCUI ] );
			this.m_UI[ sCUI ] = NULL;
		end
	end;
	
	ShowInventory		= function( this )
		this.m_pInventory:Show();
	end;
	
	HideInventory		= function( this )
		this.m_pInventory:Hide();
	end;
	
	SetInventoryItems	= function( this, Items )
		this.m_pInventory:SetItems( Items );
	end;
};