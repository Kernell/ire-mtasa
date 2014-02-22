-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: Resource
{
	OnStart		= function()
		this.m_pShaderManager	= CShaderManager();
		this.m_pVehicleManager	= CVehicleManager();
	end;
	
	OnStop		= function()
		delete ( this.m_pVehicleManager );
		delete ( this.m_pShaderManager );
	end;
};

addEventHandler( "onClientResourceStart", 	resourceRoot, 	Resource.OnStart );
addEventHandler( "onClientResourceStop", 	resourceRoot, 	Resource.OnStop );