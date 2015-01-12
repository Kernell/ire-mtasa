-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. PlayerNametag
{
	PlayerNametag	= function( player )
		this.Player = player;
	end;
	
	_PlayerNametag	= function()
		
	end;
	
	SetColor	= function( color )
		this.Player.SetData( "Player::Nametag::Color", color );
		
		return setPlayerNametagColor( this.Player, color.R, color.G, color.B );
	end;
	
	GetColor	= function()
		return getPlayerNametagColor( this.Player );
	end;
	
	GetText		= function()
		return this.Player.GetData( "Player::Nametag::Text" );
	end;
	
	SetText		= function( text )
		return this.Player.SetData( "Player::Nametag::Text", text );
	end;
	
	IsShowing	= function()
		return isPlayerNametagShowing( this.Player );
	end;
	
	Show		= function()
		return this.Player.SetData( "Player::Nametag::Showing", true );
	end;

	Hide	= function()
		return this.Player.SetData( "Player::Nametag::Showing", false );
	end;
	
	Update	= function()
		local text	= this.Player.VisibleName;
		local color	= new. Color( 120, 120, 120 );
		
		if this.Player.IsInGame() then
			color	= new. Color( 255, 255, 255 );
		end
		
		if not this.Player.IsAdmin then
			text	= text + " (" + this.Player.ID + ")";
		end
		
		this.SetText( text );
		this.SetColor( color );
	end;
}
