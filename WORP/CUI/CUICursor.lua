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
	
	Cursors			=
	{
		Arrow			= "Arrow.png";
		Move			= "Move.png";
		Link			= "Link.png";
		Text			= "Text.png";
		Unavailable		= "Unavailable.png";
	};
	
	CurrentCursor		= "Arrow";
	
	CUICursor		= function( this )
		setCursorAlpha( 0 );
		
		function this.__OnRender()
			if isCursorShowing() and not isMainMenuActive() and not isConsoleActive() then
				this:OnRender();
			end
		end
		
		function this.__OnMouseEnter( fX, fY )
			this:OnMouseEnter( fX, fY );
		end
		
		function this.__OnMouseLeave( fX, fY )
			this:OnMouseLeave( fX, fY );
		end
		
		addEventHandler( "onClientRender", 		root, this.__OnRender, true, "low" );
		addEventHandler( "onClientMouseEnter", 	root, this.__OnMouseEnter );
		addEventHandler( "onClientMouseLeave", 	root, this.__OnMouseLeave );
	end;
	
	_CUICursor		= function( this )
		removeEventHandler( "onClientRender", 		root, this.__OnRender );
		removeEventHandler( "onClientMouseEnter", 	root, this.__OnMouseEnter );
		removeEventHandler( "onClientMouseLeave", 	root, this.__OnMouseLeave );
		
		this.__OnRender		= NULL;
		this.__OnMouseEnter	= NULL;
		this.__OnMouseLeave	= NULL;
		
		setCursorAlpha( 255 );
	end;
	
	OnRender		= function( this )
		if CLIENT.m_pRadialMenu == NULL or not CLIENT.m_pRadialMenu.m_bVisible then
			local fX, fY = getCursorPosition();
			
			fX, fY = ( fX or 0 ) * g_iScreenX, ( fY or 0 ) * g_iScreenY;
			
			local sCursor = this.Cursors[ this.CurrentCursor ] or this.Cursors.Arrow;
			
			dxDrawImage( fX, fY, this.m_fWidth, this.m_fHeight, "Resources/Cursors/" + sCursor, 0, 0, 0, -1, this.m_bPostGUI );
		end
	end;
	
	OnMouseEnter		= function( this )
		this.CurrentCursor	= source and source.Cursor or "Arrow";
	end;
	
	OnMouseLeave		= function( this )
		this.CurrentCursor	= "Arrow";
	end;
};