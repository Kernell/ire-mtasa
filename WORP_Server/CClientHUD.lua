-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CClientHUD
{
	CClientHUD		= function( this, pClient )
		this.m_pClient	= pClient;
	end;
	
	_CClientHUD		= function( this, pClient )
	
	end;
	
	Show			= function( this )
	
	end;
	
	Hide			= function( this )
	
	end;
	
	SetMoney		= function( this, fMoney )
		
	end;
	
	ShowComponents	= function( this, ... )
		for _, sComponentName in ipairs( { ... } ) do
			showPlayerHudComponent( this.m_pClient, sComponentName, true );
		end
	end;
	
	HideComponents	= function( this, ... )
		for _, sComponentName in ipairs( { ... } ) do
			showPlayerHudComponent( this.m_pClient, sComponentName, false );
		end
	end;
	
	ShowCursor		= function( this, bToggleControls )
		return showCursor( this.m_pClient, true, bToggleControls == NULL or bToggleControls == true );
	end;
	
	HideCursor		= function( this, bToggleControls )
		return showCursor( this.m_pClient, false, bToggleControls == NULL or bToggleControls == true );
	end;
	
	IsCursorShowing		= function( this )
		return isCursorShowing( this.m_pClient );
	end;
};