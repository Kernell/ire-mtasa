-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CMap";

function CMap:CMap( sName, iID, iDimension, bProtected )
	sName = sName:lower();
	
	if not g_pGame:GetMapManager():Get( sName ) then
		self.m_pElement	= CElement.Create( "CMap", "CMap:" + (string)(iID) );
		
		self.m_pElement:SetParent( g_pGame:GetMapManager() );
		
		self.m_iID				= iID;
		self.m_sName			= sName;
		self.m_iDimension		= (int)(iDimension);
		self.m_bProtected		= (bool)(bProtected);
		self.m_RemovedObjects	= {};
		
		g_pGame:GetMapManager():AddToList( self );
	end
end

function CMap:_CMap()
	g_pGame:GetMapManager():RemoveFromList( self );
	
	self.m_pElement:Destroy();
	
	delete ( self.m_pElement );
	self.m_pElement = NULL;
	
	self:RestoreWorldObjects();
end

function CMap:Remove()
	if not self.m_bProtected then
		g_pDB:Query( "DELETE FROM " + DBPREFIX + "map_objects WHERE map_id = " + self:GetID() );
		g_pDB:Query( "DELETE FROM " + DBPREFIX + "maps WHERE id = " + self:GetID() );
		
		delete ( self );
		
		return true;
	end
	
	return false;
end

function CMap:GetID()
	return self.m_iID;
end

function CMap:IsValid()	
	return self.m_pElement or false;
end

function CMap:AddObject( pObject, iInterior, iAlpha, iScale, bDoublesided, bFrozen, bCollisions )
	if pObject then
		pObject:SetInterior( iInterior );
		pObject:SetDimension( self.m_iDimension );
		pObject:SetAlpha( iAlpha );
		pObject:SetScale( iScale );
		pObject:SetDoubleSided( bDoublesided );
		pObject:SetFrozen( bFrozen );
		pObject:SetCollisionsEnabled( bCollisions );
		pObject:SetParent( self.m_pElement );
		
		return true;
	end
	
	return false;
end

function CMap:SetDimension( iDimension )
	if not self.m_bProtected then				
		if g_pDB:Query( "UPDATE " + DBPREFIX + "maps SET dimension = %d WHERE id = %d", iDimension, self:GetID() ) then
			self.m_iDimension = iDimension;
			
			for i, obj in pairs( self.m_pElement:GetChilds() ) do
				obj:SetDimension( self.m_iDimension );
			end
			
			return true;
		end
		
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
	return false;
end

function CMap:RemoveWorldObject( iModel, iLodModel, vecPosition, iInterior, fRadius )
	table.insert( self.m_RemovedObjects,
		{
			m_iModel		= iModel;
			m_iLodModel		= iLodModel;
			m_vecPosition	= vecPosition;
			m_iInterior		= iInterior;
			m_fRadius		= fRadius;
		}
	);
	
	removeWorldModel( iModel, 		fRadius, vecPosition.X, vecPosition.Y, vecPosition.Z, iInterior );
	removeWorldModel( iLodModel, 	fRadius, vecPosition.X, vecPosition.Y, vecPosition.Z, iInterior );
	
	return true;
end

function CMap:RestoreWorldObjects()
	for i, pData in ipairs( self.m_RemovedObjects ) do
		restoreWorldModel( pData.m_iModel, 		pData.m_fRadius, pData.m_vecPosition.X, pData.m_vecPosition.Y, pData.m_vecPosition.Z, pData.m_iInterior );
		restoreWorldModel( pData.m_iLodModel, 	pData.m_fRadius, pData.m_vecPosition.X, pData.m_vecPosition.Y, pData.m_vecPosition.Z, pData.m_iInterior );
	end
	
	self.m_RemovedObjects = {};
	
	return true;
end
