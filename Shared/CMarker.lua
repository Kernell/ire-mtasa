-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CMarker ( CElement )
{
	CMarker		= function( this, vecPosition, sTheType, fSize, pColor, pVisibleTo )
		vecPosition = vecPosition or Vector3();
		sTheType	= sTheType or "checkpoint";
		fSize		= fSize or 4.0;
		pColor		= pColor or CColor( 255, 0, 0, 255 );
		pVisibleTo	= pVisibleTo or root;
		
		local pMarker = createMarker( vecPosition.X, vecPosition.Y, vecPosition.Z, sTheType, fSize, pColor.R, pColor.G, pColor.B, pColor.A, pVisibleTo );
		
		pMarker( this );
		
		if CLIENT == NULL then -- TODO: Deprecated
			addEventHandler( 'onMarkerHit', pMarker,
				function( pElement, bMatching )
					if pMarker.OnHit then pMarker:OnHit( pElement, bMatching ) end;
				end
			);
			
			addEventHandler( 'onMarkerLeave', pMarker,
				function( pElement, bMatching )
					if pMarker.OnLeave then pMarker:OnLeave( pElement, bMatching ) end;
				end
			);
		end
		
		return pMarker;
	end;
	
	_CMarker	= destroyElement;
	
	GetColor	= function( this )
		return CColor( getMarkerColor( this ) );
	end;

	GetIcon		= getMarkerIcon;
	GetSize		= getMarkerSize;

	GetTarget	= function( this )
		return Vector3( getMarkerTarget( this ) );
	end;

	GetType		= getMarkerType;

	SetColor	= function( this, pColor )
		return setMarkerColor( this, pColor.R, pColor.G, pColor.B, pColor.A );
	end;

	SetIcon		= setMarkerIcon;

	SetSize		= setMarkerSize;

	SetTarget	= function( this, vecPosition )
		vecPosition = vecPosition or Vector3();
		
		return setMarkerTarget( this, vecPosition.X, vecPosition.Y, vecPosition.Z );
	end;

	SetType		= setMarkerType;
};