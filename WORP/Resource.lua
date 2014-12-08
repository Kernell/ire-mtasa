-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: Resource
{
	OnStart		= function()
		this.GetNetManager				= function( this ) return this.m_pNetManager; 			end;
		this.GetClientManager			= function( this ) return this.m_pClientManager; 		end;
		this.GetClientShaderManager		= function( this ) return this.m_pClientShaderManager; 	end;
		this.GetClientSoundManager		= function( this ) return this.m_pClientSoundManager; 	end;
		
		this.m_pNetManager				= new. CNetManager;
		this.m_pClientManager			= CClientManager();
		this.m_pClientShaderManager		= CClientShaderManager();
		this.m_pClientSoundManager		= CSoundManager();
		
		this.m_pHUD			= CClientHUD();
		this.m_pCursors		= CUICursor();
		this.m_pCamera		= CClientCamera( CLIENT:GetCamera() );
	end;
	
	OnStop		= function()
		delete ( this.m_pCursors );
		delete ( this.m_pHUD );
		delete ( this.m_pClientSoundManager );
		delete ( this.m_pClientManager );
		delete ( this.m_pClientShaderManager );
		delete ( this.m_pNetManager );
		
		this.m_pCursors					= NULL;
		this.m_pHUD						= NULL;
		this.m_pClientSoundManager		= NULL;
		this.m_pNetManager				= NULL;
		this.m_pClientManager			= NULL;
		this.m_pClientShaderManager		= NULL;
	end;
};

addEventHandler( "onClientResourceStart", 	resourceRoot, 	Resource.OnStart, 	true, "high" );
addEventHandler( "onClientResourceStop", 	resourceRoot, 	Resource.OnStop, 	true, "high" );