-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CVehicleHUDRaceLaps ( C3DHUD )
{
	m_bEnabled	= false;
	
	m_pVehicle	= NULL;
	
	m_RemapOffsets	=
	{
		[ HYDRA ]		= { -1.7, -7.0, 1.3 };
		[ HUNTER ]		= { -1.6, -9.0, 1.9 };
		[ MAVERICK ]	= { -1.5, -7.0, 1.7 };
		[ POLMAV ]		= { -1.5, -7.0, 1.7 };
		[ VCNMAV ]		= { -1.5, -6.0, 1.7 };
	};
	
	Update		= function( this )
		if this.m_pVehicle then
			this:SetText( "круг " + this.m_iLap + "/" + this.m_iLaps );
			
			local fX, fY, fZ	= this:GetVehicleOffsets();
			
			this.m_fStartX, this.m_fStartY, this.m_fStartZ 		= getPositionInOffset( this.m_pVehicle, fX, fY, fZ );
			this.m_fEndX, this.m_fEndY, this.m_fEndZ			= getPositionInOffset( this.m_pVehicle, fX, fY, fZ - 1.0 );
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
		
		return fMinX - 0.5, fMinY + 0.5, fMinZ + 1.2;
	end;
};