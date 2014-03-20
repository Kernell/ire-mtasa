-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "Android.EventHandler"
{
    EventHandler = function( this, Sender )
		this.Handlers 	= {};
		this.Sender		= Sender;
	end;
	
	Add = function( this, Handler )
		table.insert( this.Handlers, Handler );
	end;
	
	Call = function( this, ... )
		for i, Handler in ipairs( this.Handlers ) do
			Handler( this.Sender, ... );
		end
	end;
};
