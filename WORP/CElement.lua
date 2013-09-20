-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

function CElement:GetBoundingBox()
	local x, y, z, rx, ry, rz = getElementBoundingBox( self.__instance );
	
	return Vector3( x, y, z ), Vector3( rx, ry, rz );
end

function CElement:GetDistanceFromCentreOfMassToBaseOfModel()
	return getElementDistanceFromCentreOfMassToBaseOfModel( self.__instance );
end

function CElement:GetRadius()
	return getElementRadius( self.__instance );
end

function CElement:GetMatrix()
	return getElementMatrix( self.__instance );
end

function CElement:IsLocal()
	return isElementLocal( self.__instance );
end

function CElement:IsCollidableWith( element )
	return isElementCollidableWith( self.__instance, type( element ) == 'table' and element.__instance or element );
end

function CElement:SetCollidableWith( element, bool )
	return setElementCollidableWith( self.__instance, type( element ) == 'table' and element.__instance or element, tobool( bool ) );
end

function CElement:IsOnScreen()
	return isElementOnScreen( self.__instance );
end

function CElement:IsStreamable()
	return isElementStreamable( self.__instance );
end

function CElement:IsStreamedIn()
	return isElementStreamedIn( self.__instance );
end

function CElement:SetStreamable( bool )
	return setElementStreamable( self.__instance, tobool( bool ) );
end