-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. PlayerHUD
{
	PlayerHUD		= function( player )
		this.Player	= player;
	end;
	
	_PlayerHUD		= function( player )
	
	end;
	
	Show			= function()
	
	end;
	
	Hide			= function()
	
	end;
	
	SetMoney		= function( money )
		
	end;
	
	ShowComponents	= function( ... )
		for _, componentName in ipairs( { ... } ) do
			showPlayerHudComponent( this.Player, componentName, true );
		end
	end;
	
	HideComponents	= function( ... )
		for _, componentName in ipairs( { ... } ) do
			showPlayerHudComponent( this.Player, componentName, false );
		end
	end;
	
	ShowCursor		= function( toggleControls )
		return showCursor( this.Player, true, toggleControls == NULL or toggleControls == true );
	end;
	
	HideCursor		= function( toggleControls )
		return showCursor( this.Player, false, toggleControls == NULL or toggleControls == true );
	end;
	
	IsCursorShowing		= function()
		return isCursorShowing( this.Player );
	end;
};