-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local WHELEN_MODES =
{
	{
		m_iDelay	= 30;
		m_States	=
		{
			{ 1; 1; 1; 0;   0; 0; 0; 0; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
			{ 1; 1; 1; 0;   0; 0; 0; 0; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
			{ 0; 0; 0; 0;   0; 1; 1; 1; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
			{ 0; 0; 0; 0;   0; 1; 1; 1; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
		};
	};
	{
		m_iDelay	= 45;
		m_States	=
		{
			{ 1; 1; 1; 0;   0; 0; 1; 0; };
			{ 0; 1; 0; 0;   0; 0; 1; 0; };
			{ 1; 1; 1; 0;   0; 0; 1; 0; };
			{ 0; 1; 0; 0;   0; 0; 1; 0; };
			{ 0; 1; 0; 0;   0; 0; 1; 0; };
			{ 0; 1; 0; 0;   0; 1; 1; 1; };
			{ 0; 1; 0; 0;   0; 0; 1; 0; };
			{ 0; 1; 0; 0;   0; 1; 1; 1; };
			{ 0; 1; 0; 0;   0; 0; 1; 0; };
			{ 0; 1; 0; 0;   0; 0; 1; 0; };
			{ 0; 1; 0; 0;   0; 0; 1; 0; };
			{ 0; 1; 0; 0;   0; 0; 1; 0; };
		};
	};
	{
		m_iDelay	= 30;
		m_States	=
		{
			{ 1; 0; 1; 0;   0; 0; 1; 0; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
			{ 1; 0; 1; 0;   0; 0; 1; 0; };
			{ 0; 1; 0; 0;   0; 1; 0; 1; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
			{ 0; 1; 0; 0;   0; 1; 0; 1; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
			{ 0; 0; 0; 0;   0; 0; 0; 0; };
		};
	};
	{
		m_iDelay	= 60;
		m_States	=
		{
			{ 1; 0; 1; 0;   1; 0; 1; 0; };
			{ 0; 0; 0; 0;   1; 0; 1; 0; };
			{ 1; 0; 1; 0;   1; 0; 1; 0; };
			{ 0; 0; 0; 0;   1; 0; 1; 0; };
			{ 0; 1; 0; 1;   0; 1; 0; 1; };
			{ 0; 1; 0; 1;   0; 0; 0; 0; };
			{ 0; 1; 0; 1;   0; 1; 0; 1; };
			{ 0; 1; 0; 1;   0; 0; 0; 0; };
		};
	};
};

class: CVehicleWhelen
{
	m_sWhelen		= "WHELEN_A";
	m_pVehicle		= NULL;
	m_pWhelenData	= NULL;
	m_iSirenIndex	= 0;
	m_iTimeElapsed	= 0;
	
	CVehicleWhelen	= function( this, pManager, pVehicle, sWhelen )
		this.m_sWhelen			= sWhelen;
		this.m_pManager			= pManager;
		this.m_pVehicle			= pVehicle;
		
		this.m_pManager:AddToList( this );
	end;
	
	_CVehicleWhelen	= function( this )
		for i = 1, 8 do
			this.m_pVehicle:SetComponentVisible( this.m_sWhelen + "_" + i, false );
			
			this.m_pVehicle:SetLightState( 0, 0 );
			this.m_pVehicle:SetLightState( 1, 0 );
		end
		
		this.m_pManager:RemoveFromList( this );
	
		this.m_pVehicle		= NULL;
		this.m_pWhelenData	= NULL;
		this.m_iSirenIndex	= NULL;
	end;
	
	Process			= function( this )
		if this.m_pVehicle:GetHealth() == 0 then
			delete ( this );
			
			return;
		end
		
		if not this.m_pVehicle:GetComponentVisible( this.m_sWhelen ) then
			delete ( this );
			
			return;
		end
		
		this.m_iSirenIndex = this.m_iSirenIndex + 1;
		
		local pLights	= this.m_pWhelenData.m_States[ this.m_iSirenIndex ];
		
		if pLights == NULL then
			this.m_iSirenIndex = 1;
			
			pLights	= this.m_pWhelenData.m_States[ this.m_iSirenIndex ];
		end
		
		for i = 1, 8 do
			local iState = pLights[ i ];
			
			if iState then
				this.m_pVehicle:SetComponentVisible( this.m_sWhelen + "_" + i, iState == 1 );
				
				if i == 1 then
					this.m_pVehicle:SetLightState( 0, 1 - iState );
				elseif i == 8 then
					this.m_pVehicle:SetLightState( 1, 1 - iState );
				end
			end
		end
	end;
	
	Update			= function( this, iWhelen )
		this.m_pWhelenData = WHELEN_MODES[ iWhelen ] or WHELEN_MODES[ 1 ];
	end;
};
