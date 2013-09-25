-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CVehicleHUDFuel ( C3DHUD )
{
	m_pVehicle	= NULL;
	
	m_RemapOffsets	=
	{
		[ RUSTLER ]		= { 0.6, -4.5, 1.0 };
		[ DODO ]		= { 0.5, -6.0, 0.95 };
		[ HYDRA ]		= { 0.7, -7.0, 0.95 };
		[ HUNTER ]		= { 0.6, -9.0, 1.55 };
		[ MAVERICK ]	= { 0.5, -7.0, 1.35 };
		[ POLMAV ]		= { 0.5, -7.0, 1.35 };
		[ VCNMAV ]		= { 0.5, -6.0, 1.35 };
	};
	
	DrawText	= function( this, sText, fX, fY, fWidth, fHeight, iColor )
		dxDrawText( sText, fX, 0, fWidth, 0, iColor, 1.0, this.m_pFont, "right" );
        dxDrawText( "% fuel", fX + fWidth + 15, 0, fWidth + 10, 0, iColor, 1.0, this.m_pFont );
	end;
	
	Update		= function( this )
		if this.m_pVehicle then
			this:SetText( (float)(this.m_pVehicle:GetData( "fuel" )):ceil() );
			
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
		
		return fMaxX + 0.5, fMinY + 0.5, fMinZ + 0.8;
	end;
};