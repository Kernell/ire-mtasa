-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CVehicleManager
{
	CVehicleManager	= function( this )
		this.m_StreamedVehicles	= {};
		
		for i, pVeh in ipairs( getElementsByType( "vehicle", root, true ) ) do
			this:PerformChecks( pVeh );
		end
		
		function this.__PerformChecks()
			if getElementType( source ) == "vehicle" then
				this:PerformChecks( source );
			end
		end
		
		function this.__Remove()
			if getElementType( source ) == "vehicle" then
				this:Remove( source );
			end
		end
		
		addEventHandler( "onClientVehicleRespawn", 			root,	this.__PerformChecks );
		addEventHandler( "onClientElementStreamIn", 		root,	this.__PerformChecks );
		
		addEventHandler( "onClientElementStreamOut", 		root, 	this.__Remove );
		addEventHandler( "onClientElementDestroy", 			root, 	this.__Remove );
	end;
	
	_CVehicleManager	= function( this )
		removeEventHandler( "onClientVehicleRespawn", 		root,	this.__PerformChecks );
		removeEventHandler( "onClientElementStreamIn", 		root,	this.__PerformChecks );
		
		removeEventHandler( "onClientElementStreamOut", 	root, 	this.__Remove );
		removeEventHandler( "onClientElementDestroy", 		root, 	this.__Remove );
		
		for i, pVeh in ipairs( getElementsByType( "vehicle" ) ) do
			this:Remove( pVeh );
		end
	end;
	
	PerformChecks	= function( this, pVehicle )
		if this.m_StreamedVehicles[ pVehicle ] == NULL then
			this.m_StreamedVehicles[ pVehicle ] = CVehicle( pVehicle );
			
			Debug( "Add Ref " + pVehicle:GetID(), 0, 255, 255, 255 );
		end
	end;
	
	Remove		= function( this, pVehicle )
		if this.m_StreamedVehicles[ pVehicle ] then
			Debug( "Remove Ref " + pVehicle:GetID(), 0, 255, 255, 255 );
			
			delete ( this.m_StreamedVehicles[ pVehicle ] );
		end
		
		this.m_StreamedVehicles[ pVehicle ] = NULL;
	end;
};