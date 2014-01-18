-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CClientHUD
{
	CClientHUD = function( this )		
		this.m_pVehicleHUD	= CVehicleHUD();
		this.m_pRadioUI		= CUIRadio();
		this.m_pSideBarUI	= CUISideBar();
	end;

	_CClientHUD = function( this )
		delete ( this.m_pRadioUI );
		delete ( this.m_pSideBarUI );
		delete ( this.m_pVehicleHUD );
		
		this.m_pVehicleHUD				= NULL;
		this.m_pRadioUI					= NULL;
		this.m_pSideBarUI				= NULL;
	end;
};