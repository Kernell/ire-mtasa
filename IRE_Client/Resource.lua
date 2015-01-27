-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
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
		
		_G.UI 			= this.UI.UI;
		
		this.Camera		= new. ClientCamera();
		
		_G.Camera 		= this.Camera;
		
		this.Client		= new. Client();
		
		this.VehicleManager		= new. VehicleManager();
		this.SoundManager 		= new. SoundManager();
		
	end;
	
	OnStop		= function()
		delete ( this.UI );
		delete ( this.Camera );
		delete ( this.Client );
		delete ( this.SoundManager );
		delete ( this.VehicleManager );
		delete ( this.RPC );
		
		_G.UI 				= NULL;
		_G.Camera 			= NULL;
	end;
};

new. Resource();