-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. PlayerNametag
{
	static
	{
		DEFAULT_COLOR	= new. Color( 120, 120, 120 );
		PLAYER_COLOR	= new. Color( 255, 255, 255 );
	};
	
	Distance		= 8.0;
	
	PlayerNametag	= function( player )
		this.Player = player;
	end;
	
	_PlayerNametag	= function()
		
	end;
	
	SetColor	= function( color )
		this.Player.SetData( "Player::Nametag::Color", color );
		
		return setPlayerNametagColor( this.Player, false );
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
	
	SetMaxDistance	= function( distance )
		return this.Player.SetData( "Player::Nametag::Distance", distance or this.Distance );
	end;
	
	Update	= function()
		local text	= this.Player.VisibleName;
		local color	= PlayerNametag.DEFAULT_COLOR;
		
		if this.Player.IsInGame() then
			color	= PlayerNametag.PLAYER_COLOR;
		end
		
		if not this.Player.IsAdmin then
			text	= text + " (" + this.Player.ID + ")";
		else
			color	= this.Player.Groups[ 1 ].GetColor();
		end
		
		this.SetText( text );
		this.SetColor( color );
	end;
}
