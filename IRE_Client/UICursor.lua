-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. UICursor
{
	PostGUI		= true;
	Width		= 32;
	Height		= 32;
	
	Cursors			=
	{
		Arrow			= "Arrow.png";
		Move			= "Move.png";
		Link			= "Link.png";
		Text			= "Text.png";
		Unavailable		= "Unavailable.png";
	};
	
	CurrentCursor		= "Arrow";
	
	UICursor		= function()
		this.CursorVisible = {};
		
		this.ScreenX, this.ScreenY = guiGetScreenSize();
		
		setCursorAlpha( 0 );
		
		function this.__OnRender()
			if isCursorShowing() and not isMainMenuActive() and not isConsoleActive() then
				this.OnRender();
			end
		end
		
		function this.__OnMouseEnter( x, y )
			this.OnMouseEnter( x, y );
		end
		
		function this.__OnMouseLeave( x, y )
			this.OnMouseLeave( x, y );
		end
		
		addEventHandler( "onClientRender", 		root, this.__OnRender, true, "low" );
		addEventHandler( "onClientMouseEnter", 	root, this.__OnMouseEnter );
		addEventHandler( "onClientMouseLeave", 	root, this.__OnMouseLeave );
	end;
	
	_UICursor		= function()
		removeEventHandler( "onClientRender", 		root, this.__OnRender );
		removeEventHandler( "onClientMouseEnter", 	root, this.__OnMouseEnter );
		removeEventHandler( "onClientMouseLeave", 	root, this.__OnMouseLeave );
		
		this.__OnRender		= NULL;
		this.__OnMouseEnter	= NULL;
		this.__OnMouseLeave	= NULL;
		
		setCursorAlpha( 255 );
	end;
	
	OnRender		= function()
		if not UI.RadialMenu.Visible then
			local x, y = getCursorPosition();
			
			x, y = ( x or 0 ) * this.ScreenX, ( y or 0 ) * this.ScreenY;
			
			local cursor = this.Cursors[ this.CurrentCursor ] or this.Cursors.Arrow;
			
			dxDrawImage( x, y, this.Width, this.Height, "Resources/Cursors/" + cursor, 0, 0, 0, -1, this.PostGUI );
		end
	end;
	
	OnMouseEnter		= function()
		this.CurrentCursor	= source and source.Cursor or "Arrow";
	end;
	
	OnMouseLeave		= function()
		this.CurrentCursor	= "Arrow";
	end;
	
	Show	= function( element, toggleControls )
		this.CursorVisible[ element or root ] = true;
		
		this.UpdateCursorVisible( toggleControls );
	end;
	
	Hide	= function( element, toggleControls )
		this.CursorVisible[ element or root ] = NULL;
		
		this.UpdateCursorVisible( toggleControls );
	end;
	
	UpdateControls	= function()
		local Controls		= CLIENT.GetData( "Player::Controls" );
		local ControlStates	= CLIENT.GetData( "Player::ControlStates" );
		
		if Controls and ControlStates then
			for ctrl, bEnabled in pairs( Controls ) do
				toggleControl( ctrl, bEnabled );
			end
			
			for ctrl, bState in pairs( ControlStates ) do
				setControlState( ctrl, bState );
			end
		end
	end;

	UpdateCursorVisible	= function( toggleControls )
		showCursor( false );
		
		for key, value in pairs( this.CursorVisible ) do
			showCursor( true, toggleControls );
			
			return;
		end
	end;
};

_showCursor = showCursor;

function showCursor( ... )
	_showCursor( ... );
	
	UI.Cursor.UpdateControls();
end