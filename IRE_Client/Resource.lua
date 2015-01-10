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
		this.UI		= new. UIManager();
		
		_G.UI = this.UI.UI;
		
		SERVER.PlayerManager( "Ready", guiGetScreenSize() );
	end;
	
	OnStop		= function()
		delete ( this.UI );
		delete ( this.RPC );
		
		_G.UI = NULL;
	end;
};

new. Resource();