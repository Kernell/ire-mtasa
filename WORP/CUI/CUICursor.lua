-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CUICursor
{
	m_bPostGUI		= true;
	m_fWidth		= 32;
	m_fHeight		= 32;
	m_pCursorImage	= NULL;
	
	CUICursor		= function( this )
		setCursorAlpha( 0 );
		
		this.m_pCursorImage	= dxCreateTexture( "Resources/Images/Arrow.png", "argb", true, "wrap" );
		
		function this.__OnRender()
			if isCursorShowing() and not isMainMenuActive() and not isConsoleActive() then
				this:OnRender();
			end
		end
		
		addEventHandler( "onClientRender", root, this.__OnRender );
	end;
	
	_CUICursor		= function( this )
		removeEventHandler( "onClientRender", root, this.__OnRender );
		
		this.__OnRender	= NULL;
		
		setCursorAlpha( 255 );
	end;
	
	OnRender		= function( this )
		if CLIENT.m_pRadialMenu == NULL or not CLIENT.m_pRadialMenu.m_bVisible then
			local fX, fY = getCursorPosition();
			
			fX, fY = ( fX or 0 ) * g_iScreenX, ( fY or 0 ) * g_iScreenY;
			
			dxDrawImage( fX, fY, this.m_fWidth, this.m_fHeight, this.m_pCursorImage, 0, 0, 0, -1, this.m_bPostGUI );
		end
	end;
};