-- Author:      	Kernell
-- Version:     	1.0.0

class "CMarker" ( CElement );

function CMarker:CMarker( instance )
	if instance and isElement( instance ) and getElementType( instance ) == 'marker' then
		self.__instance = instance;
	end
end

function CMarker:_CMarker()
	self:Destroy();
end

function CMarker.Create( vecPosition, ... )
	vecPosition = vecPosition or Vector3();
	
	local pMarker = CreateMarker( vecPosition.X, vecPosition.Y, vecPosition.Z, ... );
	
	assert( pMarker, "failed to create marker" );
	
	if getLocalPlayer then
	
	else
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
	
	return pMarker.__instance;
end

function CMarker:GetColor()
	return getMarkerColor( self.__instance );
end

function CMarker:GetIcon()
	return getMarkerIcon( self.__instance );
end

function CMarker:GetSize()
	return getMarkerSize( self.__instance );
end

function CMarker:GetTarget()
	return Vector3( getMarkerTarget( self.__instance ) );
end

function CMarker:GetType()
	return getMarkerType( self.__instance );
end

function CMarker:SetColor( r, g, b, a )
	return setMarkerColor( self.__instance, r, g, b, a );
end

function CMarker:SetIcon( icon )
	return setMarkerIcon( self.__instance, icon );
end

function CMarker:SetSize( size )
	return setMarkerSize( self.__instance, size );
end

function CMarker:SetTarget( pos )
	pos = pos or Vector3();
	
	return setMarkerTarget( self.__instance, pos.X, pos.Y, pos.Z );
end

function CMarker:SetType( type )
	return setMarkerType( self.__instance, type );
end