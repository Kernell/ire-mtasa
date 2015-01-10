-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. Team : Element
{
	Team		= function( name, color )
		local element	= createTeam( name, color.R, color.G, color.B );
		
		element( this );
		
		return element;
	end;
	
	CountPlayers	= function()
		return countPlayersInTeam( this );
	end;
	
	GetPlayers		= function()
		return getPlayersInTeam( this );
	end;
	
	SetColor		= function( color )
		return setTeamColor( this, color.R, color.G, color.B );
	end;
	
	GetColor		= function()
		return new. Color( getTeamColor( this ) );
	end;
	
	SetFriendlyFire	= function( enabled )
		return setTeamFriendlyFire( this, enabled );
	end;
	
	GetFriendlyFire	= function()
		return getTeamFriendlyFire( this );
	end;
	
	SetName			= function( name )
		return setTeamName( this, name );
	end;
	
	GetName			= function()
		return getTeamName( this );
	end;
};