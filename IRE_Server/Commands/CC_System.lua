-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CC_System ( IConsoleCommand )
{
	CC_System	= function( ... )
		this.IConsoleCommand( ... );
	end;
	
	Execute		= function( Player, Option, ... )
		print( Player, Option, ... );
	end;
	
	Info		= function()
		
	end;
};