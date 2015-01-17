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
		this.Camera	= new. ClientCamera();
		
		_G.UI = this.UI.UI;
		_G.Camera = this.Camera;
		
		SERVER.PlayerManager( "Ready", guiGetScreenSize() );
	end;
	
	OnStop		= function()
		delete ( this.UI );
		delete ( this.Camera );
		delete ( this.RPC );
		
		_G.UI = NULL;
		_G.Camera = NULL;
	end;
};

new. Resource();