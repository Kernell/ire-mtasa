-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CVehicleHUD
{	
	CVehicleHUD		= function( this )
		this.m_pSpeedo			= CVehicleHUDSpeed();
		this.m_pFuel			= CVehicleHUDFuel();
		this.m_pRaceLaps		= CVehicleHUDRaceLaps();
		this.m_pRaceTime		= CVehicleHUDRaceTime();
		this.m_pRacePosition	= CVehicleHUDRacePosition();
		
		function this.__OnClientVehicleEnter( pPlayer, iSeat )
			this:OnClientVehicleEnter( source, pPlayer, iSeat );
		end
		
		function this.__OnClientVehicleExit( pPlayer, iSeat )
			this:OnClientVehicleExit( source, pPlayer, iSeat );
		end
		
		function this.__OnClientElementDestroy()
			this:OnClientVehicleDestroy( source );
		end
		
		addEventHandler( "onClientVehicleEnter", 	root, this.__OnClientVehicleEnter );
		addEventHandler( "onClientVehicleExit",  	root, this.__OnClientVehicleExit );
		addEventHandler( "onClientElementDestroy",  root, this.__OnClientElementDestroy );
	end;
	
	_CVehicleHUD	= function( this )
		removeEventHandler( "onClientVehicleEnter", 	root, this.__OnClientVehicleEnter );
		removeEventHandler( "onClientVehicleExit",  	root, this.__OnClientVehicleExit );
		removeEventHandler( "onClientElementDestroy",  	root, this.__OnClientElementDestroy );
		
		delete ( this.m_pSpeedo );
		delete ( this.m_pFuel );
		delete ( this.m_pRaceLaps );
		delete ( this.m_pRaceTime );
		delete ( this.m_pRacePosition );
		
		this.m_pSpeedo			= NULL;
		this.m_pFuel			= NULL;
		this.m_pRaceLaps		= NULL;
		this.m_pRaceTime		= NULL;
		this.m_pRacePosition	= NULL;
		
		this.__OnClientVehicleEnter		= NULL;
		this.__OnClientVehicleExit		= NULL;
		this.__OnClientElementDestroy	= NULL;
	end;
	
	SetVehicle		= function( this, pVehicle )
		this.m_pSpeedo.m_pVehicle		= pVehicle;
		this.m_pFuel.m_pVehicle 		= pVehicle;
		this.m_pRaceLaps.m_pVehicle 	= pVehicle;
		this.m_pRaceTime.m_pVehicle 	= pVehicle;
		this.m_pRacePosition.m_pVehicle = pVehicle;
	end;
	
	OnClientVehicleEnter	= function( this, pVehicle, pPlayer, iSeat )
		if pPlayer == CLIENT then
			this:SetVehicle( pVehicle );
		end
	end;
	
	OnClientVehicleExit		= function( this, pVehicle, pPlayer, iSeat )
		if pPlayer == CLIENT then
			this:SetVehicle( NULL );
		end
	end;
	
	OnClientVehicleDestroy	= function( this, pVehicle )
		if CLIENT:GetVehicle() == source then
			this:SetVehicle( NULL );
		end
	end;
};