-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. EventHandler
{
    EventHandler = function( sender )
		this.Handlers 	= new {};
		this.Sender		= sender;
	end;
	
	Add = function( Handler )
		this.Handlers.Insert( Handler );
	end;
	
	Call = function( ... )
		for i = 1, this.Handlers.Length() do
			this.Handlers[ i ]( this.Sender, ... );
		end
	end;
};