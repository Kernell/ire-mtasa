-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: Resource
{
	OnStart		= function()
		this.m_pNetManager				= CNetManager();
		this.m_pClientManager			= CClientManager();
		this.m_pClientShaderManager		= CClientShaderManager();
		
		this.m_pVehicleHUD	= CVehicleHUD();
	end;
	
	OnStop		= function()
		delete ( this.m_pClientManager );
		delete ( this.m_pClientShaderManager );
		delete ( this.m_pVehicleHUD );
		delete ( this.m_pNetManager );
		
		this.m_pNetManager				= NULL;
		this.m_pClientManager			= NULL;
		this.m_pClientShaderManager		= NULL;
		this.m_pVehicleHUD				= NULL;
	end;
	
	GetNetManager				= function( this ) return this.m_pNetManager; 			end;
	GetClientManager			= function( this ) return this.m_pClientManager; 		end;
	GetClientShaderManager		= function( this ) return this.m_pClientShaderManager; 	end;
};

addEventHandler( "onClientResourceStart", 	resourceRoot, 	Resource.OnStart, 	true, "high" );
addEventHandler( "onClientResourceStop", 	resourceRoot, 	Resource.OnStop, 	true, "high" );