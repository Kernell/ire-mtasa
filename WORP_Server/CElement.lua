-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

function CElement:Clone( vecPosition, bCloneChildren )
	vecPosition = vecPosition or Vector3();
	
	return cloneElement( self.__instance, vecPosition.X, vecPosition.Y, vecPosition.Z, (bool)(bCloneChildren) );
end

function CElement:ClearVisible()
	return clearElementVisibleTo( self.__instance );
end

function CElement:IsVisibleTo( pElement )
	return isElementVisibleTo( self.__instance, pElement.__instance );
end

function CElement:SetVisible( pElement, bVisible )
	return setElementVisibleTo( self.__instance, pElement.__instance, (bool)(bVisible) );
end

function CElement:GetSyncer()
	return getElementSyncer( self.__instance );
end

function CElement:GetAllData()
	return getAllElementData( self.__instance );
end

function CElement:RemoveData( sDataName )
	return removeElementData( self.__instance, sDataName );
end

function CElement:GetZoneName( bCitiesonly )
	return getElementZoneName( self.__instance, (bool)(bCitiesonly) );
end