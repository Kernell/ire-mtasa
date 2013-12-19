-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CVehicleHUDSpeed ( C3DHUD )
{
	m_pVehicle	= NULL;
	
	m_RemapOffsets	=
	{
		[ RUSTLER ]		= { 0.7, -4.5, 0.7 };
		[ DODO ]		= { 0.5, -6.0, 0.6 };
		[ HYDRA ]		= { 0.7, -7.0, 0.6 };
		[ HUNTER ]		= { 0.6, -9.0, 1.2 };
		[ MAVERICK ]	= { 0.7, -7.0, 1.0 };
		[ POLMAV ]		= { 0.7, -7.0, 1.0 };
		[ VCNMAV ]		= { 0.5, -6.0, 1.0 };
	};
	
	CVehicleHUDSpeed	= function( this )
		this:C3DHUD();
	end;
	
	DrawText	= function( this, sText, fX, fY, fWidth, fHeight, iColor )
		dxDrawText( sText, fX, 0, fWidth, 0, iColor, 1.0, this.m_pFont, "right" );
        dxDrawText( "км/ч", fX + fWidth + 10, 0, fWidth + 15, 0, iColor, 1.0, this.m_pFont );
	end;
	
	Update		= function( this )
		if this.m_pVehicle then
			this:SetText( this.m_pVehicle:GetSpeed():floor() );
			
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
		
		return fMaxX + 0.5, fMinY + 0.5, fMinZ + 0.5;
	end;
};