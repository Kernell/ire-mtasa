-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. Resource
{
	event. OnClientResourceStart;
	event. OnClientResourceStop;
	
	Resource	= function()
		resourceRoot( this );
		
		local this = resourceRoot;
		
		this.OnClientResourceStart.Add( this.OnStart );
		this.OnClientResourceStop.Add( this.OnStop );
	end;
	
	OnStart		= function()
		this.RPC	= new. RPC( "IRE_Server", "IRE_Client" );
	end;
	
	OnStop		= function()
	end;
};

new. Resource();