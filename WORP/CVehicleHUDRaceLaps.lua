-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CVehicleHUDRaceLaps ( C3DHUD )
{
	m_bEnabled	= false;
	
	m_pVehicle	= NULL;
	
	m_fScale	= 1.25;
	
	m_RemapOffsets	=
	{
		[ RUSTLER ]		= { -1.6, -4.5, 1.35 };
		[ DODO ]		= { -1.5, -6.0, 1.30 };
		[ HYDRA ]		= { -1.7, -7.0, 1.30 };
		[ HUNTER ]		= { -1.6, -9.0, 1.90 };
		[ MAVERICK ]	= { -1.5, -7.0, 1.70 };
		[ POLMAV ]		= { -1.5, -7.0, 1.70 };
		[ VCNMAV ]		= { -1.5, -6.0, 1.70 };
	};
	
	CVehicleHUDRaceLaps	= function( this )
		this:C3DHUD();
	end;
	
	Update		= function( this )
		if this.m_pVehicle then
			this:SetText( "круг " + this.m_iLap + "/" + this.m_iLaps );
			
			local fX, fY, fZ	= this:GetVehicleOffsets();
			
			this.m_fStartX, this.m_fStartY, this.m_fStartZ 		= getPositionInOffset( this.m_pVehicle, fX, fY, fZ );
			this.m_fEndX, this.m_fEndY, this.m_fEndZ			= getPositionInOffset( this.m_pVehicle, fX, fY, fZ - 0.5 );
			this.m_fTowardX, this.m_fTowardY, this.m_fTowardZ	= getPositionInOffset( this.m_pVehicle, 0.0, fY * 2.0, fY * 2.0 );
		else
			this:SetText( NULL );
		end
	end;
	
	GetVehicleOffsets	= function( this )
		local iModel = this.m_pVehicle:GetModel();
		
		if this.m_RemapOffsets[ iModel ] then
			return unpack( this.m_RemapOffsets[ iModel ] );
		end
		
		local fMinX, fMinY, fMinZ, fMaxX, fMaxY, fMaxZ = getElementBoundingBox( this.m_pVehicle );
		
		return fMinX - 0.5, fMinY + 0.5, fMinZ + 1.3;
	end;
};