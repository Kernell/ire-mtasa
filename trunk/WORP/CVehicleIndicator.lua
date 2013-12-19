-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CVehicleIndicator
{
	CVehicleIndicator	= function( this, pVehicle, sSide )
		local Components = pVehicle:GetComponents();
		
		if Components[ "indicator_" + sSide ] ~= NULL then
			this[ 1 ] = "indicator_" + sSide;
			
			pVehicle:SetComponentVisible( this[ 1 ], false );
			
			function this.SetColor( t, R, G, B, A )
				pVehicle:SetComponentVisible( this[ 1 ], A == 255 );
			end
			
			function this.GetColor( t )
				return 255, 255, 255, pVehicle:GetComponentVisible( this[ 1 ] ) and 255 or 0;
			end
			
			function this.Destroy( t )
				pVehicle:SetComponentVisible( this[ 1 ], false );
			end
		else
			local x, y, z	= getElementPosition( localPlayer );
			
			this[ 1 ] = createMarker( x, y, z + 4, "corona",
				pVehicle.m_pIndicators.m_fSize, pVehicle.m_pIndicators.m_Color[ 1 ], pVehicle.m_pIndicators.m_Color[ 2 ], pVehicle.m_pIndicators.m_Color[ 3 ], 0 
			);
			
			this[ 2 ] = createMarker( x, y, z + 4, "corona",
				pVehicle.m_pIndicators.m_fSize, pVehicle.m_pIndicators.m_Color[ 1 ], pVehicle.m_pIndicators.m_Color[ 2 ], pVehicle.m_pIndicators.m_Color[ 3 ], 0 
			);
			
			setElementStreamable( this[ 1 ], false );
			setElementStreamable( this[ 2 ], false );
			
			local fMinX, fMinY, fMinZ, fMaxX, fMaxY, fMaxZ = getElementBoundingBox( pVehicle );
	
			fMinX = (float)(fMinX) + 0.2;
			fMaxX = (float)(fMaxX) - 0.2;
			fMinY = (float)(fMinY) + 0.2;
			fMaxY = (float)(fMaxY) - 0.2;
			fMinZ = (float)(fMinZ) + 0.6;
			
			if sSide == "left" then
				attachElements( this[ 1 ], pVehicle, fMinX,  fMaxY, fMinZ );
				attachElements( this[ 2 ], pVehicle, fMinX, -fMaxY, fMinZ );
			else
				attachElements( this[ 1 ], pVehicle, -fMinX,  fMaxY, fMinZ );
				attachElements( this[ 2 ], pVehicle, -fMinX, -fMaxY, fMinZ );
			end
			
			function this.SetColor( t, R, G, B, A )
				setMarkerColor( this[ 1 ], R, G, B, A );
				setMarkerColor( this[ 2 ], R, G, B, A );
			end
			
			function this.GetColor( t )
				return getMarkerColor( this[ 1 ] );
			end
			
			function this.Destroy( t )
				destroyElement( t[ 1 ] );
				destroyElement( t[ 2 ] );
			end
		end
	end;
	
	_CVehicleIndicator	= function( this )
		this:Destroy();
	end;
};