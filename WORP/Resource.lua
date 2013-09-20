-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: Resource
{
	OnStart		= function()
		this.m_pClientShaderManager		= CClientShaderManager();
		
		this.m_pVehicleHUD	= CVehicleHUD();
	end;
	
	OnStop		= function()
		delete ( this.m_pClientShaderManager );
		delete ( this.m_pVehicleHUD );
		
		this.m_pClientShaderManager		= NULL;
		this.m_pVehicleHUD				= NULL;
	end;
};

addEventHandler( "onClientResourceStart", 	resourceRoot, 	Resource.OnStart, 	true, "high" );
addEventHandler( "onClientResourceStop", 	resourceRoot, 	Resource.OnStop, 	true, "high" );