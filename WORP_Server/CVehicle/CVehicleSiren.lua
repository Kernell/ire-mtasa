-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local STATIC_WHELENS	=
{
	[ FBIRANCH ]		=
	{
		{ X	= 0.200,	Y = 2.800,		Z = -0.300,		Red = 255, Green = 0,		Blue = 0,	Alpha = 255, MinAlpha = 255 };
		{ X	= -0.200,	Y = 2.800,		Z = -0.300,		Red = 150, Green = 150, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X	= 0.654,	Y = -2.556,		Z = -0.270, 	Red = 150, Green = 150, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X	= -0.655,	Y = -2.547,		Z = -0.200, 	Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X	= 0.677,	Y = -0.347,		Z = 1.000, 		Red = 150, Green = 150, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X	= -0.635,	Y = -0.342,		Z = 1.000, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X	= 0.234,	Y = -0.136,		Z = 1.000, 		Red = 150, Green = 150, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X	= -0.100,	Y = -0.300,		Z = 1.000, 		Red = 255, Green = 0, 		Blue = 0,	Alpha = 255, MinAlpha = 255 };
	};
	[ AMBULAN ]			=
	{
		{ X = -0.400,	Y = 0.900, 		Z = 1.200, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X = 1.0, 		Y = -3.500, 	Z = 1.450, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X = 0.400, 	Y = 0.900, 		Z = 1.200, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X = -1.0, 	Y = -3.500, 	Z = 1.450, 		Red = 255, Green = 0, 		Blue = 0, 	Alpha = 255, MinAlpha = 255 };
		{ X = 0.100, 	Y = 0.900, 		Z = 1.200, 		Red = 255, Green = 255, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
		{ X = -0.100, 	Y = 0.900,		Z = 1.200, 		Red = 255, Green = 255, 	Blue = 255, Alpha = 255, MinAlpha = 255 };
	};
};

class: CVehicleSiren
{
	m_pVehicle			= NULL;
	m_iSirenState		= 0;
	m_iWhelenState		= 0;
	m_iMaxSirenState	= 3;
	m_iMaxWhelenState	= 4;
	m_iSirenStateLast	= 0;
	m_iWhelenStateLast	= 0;
	m_iType				= 0;
	
	CVehicleSiren		= function( this, pVehicle, iSirenState, iWhelenState )
		this.m_pVehicle	= pVehicle;
		
		this:Install();
		
		this:SetState( iSirenState, iWhelenState );
	end;
	
	_CVehicleSiren		= function( this )
		this:SetState();
		
		this.m_pVehicle	= NULL;
	end;
	
	Install				= function( this )
		removeVehicleSirens( this.m_pVehicle );
		
		local Components	= this.m_pVehicle.m_pUpgrades.m_Components;
		
		if Components.WhelenA or Components.WhelenB or Components.WhelenC then
			this.m_iType	= 1;
			
			return true;
		else
			local pSiren = STATIC_WHELENS[ this.m_pVehicle:GetModel() ];
			
			if pSiren then
				this.m_iType	= 2;
				
				addVehicleSirens( this.m_pVehicle, table.getn( pSiren ), 3, true, false, true, true );
				
				for i, pData in ipairs( pSiren ) do
					setVehicleSirens( this.m_pVehicle, i, pData.X, pData.Y, pData.Z, pData.Red, pData.Green, pData.Blue, pData.Alpha, pData.MinAlpha );
				end
				
				return true;
			end
		end
		
		return false;
	end;
	
	Remove				= function( this )
		removeVehicleSirens( this.m_pVehicle );
		
		this.m_iType = 0;
		
		return true;
	end;
	
	SetState			= function( this, iSirenState, iWhelenState )
		if this.m_iType == 0 then
			return false;
		end
		
		this.m_iSirenState	= (int)(iSirenState);
		this.m_iWhelenState	= (int)(iWhelenState);
		
		if this.m_iType == 1 then
			if this.m_pVehicle.m_pUpgrades.m_Components.WhelenA then
				this.m_pVehicle:SetData( "WHELEN_A", iWhelenState );
			end
			
			if this.m_pVehicle.m_pUpgrades.m_Components.WhelenB then
				this.m_pVehicle:SetData( "WHELEN_B", iWhelenState );
			end
			
			if this.m_pVehicle.m_pUpgrades.m_Components.WhelenC then
				this.m_pVehicle:SetData( "WHELEN_C", iWhelenState );
			end
		elseif this.m_iType == 2 then
			setVehicleSirensOn( this.m_pVehicle, this.m_iWhelenState ~= 0 );
		end
		
		
		if this.m_pSound == NULL or this.m_pSound.m_iSirenState ~= this.m_iSirenState then
			if this.m_pSound then
				delete ( this.m_pSound );
				this.m_pSound = NULL;
			end
			
			if this.m_iSirenState ~= 0 then
				this.m_pSound = CSound( "Resources/Sounds/HornAmbient/police_siren_" + this.m_iSirenState + ".wav" );
				
				this.m_pSound.m_bLoop			= true;
				this.m_pSound.m_fVolume			= 0.3;
				this.m_pSound.m_vecPosition		= NULL;
				this.m_pSound.m_pAttachedTo		= this.m_pVehicle;
			--	this.m_pSound.m_fMinDistance	= 100.0;
				this.m_pSound.m_fMaxDistance	= 200.0;
				this.m_pSound.m_iSirenState		= this.m_iSirenState;
				
				this.m_pSound:Play();
			end
		end
		
		return true;
	end;
};