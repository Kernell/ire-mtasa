-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: Resource
{
	OnStart		= function()
		this.GetNetManager				= function( this ) return this.m_pNetManager; 			end;
		this.GetClientManager			= function( this ) return this.m_pClientManager; 		end;
		this.GetClientShaderManager		= function( this ) return this.m_pClientShaderManager; 	end;
		this.GetClientSoundManager		= function( this ) return this.m_pClientSoundManager; 	end;
		
		this.m_pNetManager				= CNetManager();
		this.m_pClientManager			= CClientManager();
		this.m_pClientShaderManager		= CClientShaderManager();
		this.m_pClientSoundManager		= CSoundManager();
		
		this.m_pVehicleHUD	= CVehicleHUD();
		
		this.m_pRadioUI		= CUIRadio();
		this.m_pSideBarUI	= CUISideBar();
	end;
	
	OnStop		= function()
		delete ( this.m_pClientSoundManager );
		delete ( this.m_pClientManager );
		delete ( this.m_pClientShaderManager );
		delete ( this.m_pRadioUI );
		delete ( this.m_pSideBarUI );
		delete ( this.m_pVehicleHUD );
		delete ( this.m_pNetManager );
		
		this.m_pClientSoundManager		= NULL;
		this.m_pNetManager				= NULL;
		this.m_pClientManager			= NULL;
		this.m_pClientShaderManager		= NULL;
		this.m_pVehicleHUD				= NULL;
		this.m_pRadioUI					= NULL;
		this.m_pSideBarUI				= NULL;
	end;
};

addEventHandler( "onClientResourceStart", 	resourceRoot, 	Resource.OnStart, 	true, "high" );
addEventHandler( "onClientResourceStop", 	resourceRoot, 	Resource.OnStop, 	true, "high" );