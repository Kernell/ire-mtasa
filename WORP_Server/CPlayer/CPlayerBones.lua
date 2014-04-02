-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CPlayerBones";

function CPlayerBones:CPlayerBones( pClient )
	self.m_pClient = pClient;
	
	self.m_Objects = {};
end

function CPlayerBones:_CPlayerBones()
	self:ReleaseAll();
end

function CPlayerBones:AttachObject( iBone, iModel, vecPosition, vecRotation )
	if classname( self ) ~= 'CPlayerBones' then error( TEXT_E2288, 2 ) end
	
	local pObject = CObject( iModel, self.m_pClient:GetPosition() );
	
	if pObject then
		self:Release( iBone );
		
		pObject.m_iBone = iBone;
		
		pObject:SetParent( self.m_pClient );
		pObject:SetInterior( self.m_pClient:GetInterior() );
		pObject:SetDimension( self.m_pClient:GetDimension() );
		pObject:SetAlpha( self.m_pClient:GetAlpha() );
		pObject:SetCollisionsEnabled( false );
		
		vecPosition = vecPosition or Vector3();
		vecRotation = vecRotation or Vector3();
		
		self.m_Objects[ iBone ]		= pObject;
		
		exports.bone_attach:attachElementToBone( pObject, self.m_pClient, iBone, vecPosition.X, vecPosition.Y, vecPosition.Z, vecRotation.X, vecRotation.Y, vecRotation.Z );
	end
	
	return pObject;
end

function CPlayerBones:GetObject( iBone )
	if classname( self ) ~= 'CPlayerBones' then error( TEXT_E2288, 2 ) end
	
	return self:IsBusy( iBone ) and self.m_Objects[ iBone ];
end

function CPlayerBones:IsObjectAttached( pObject )
	if classname( self ) ~= 'CPlayerBones' then error( TEXT_E2288, 2 ) end
	
	return exports.bone_attach:isElementAttachedToBone( pObject );
end

function CPlayerBones:IsBusy( iBone )
	if classname( self ) ~= 'CPlayerBones' then error( TEXT_E2288, 2 ) end
	
	if self.m_Objects[ iBone ] and ( not isElement( self.m_Objects[ iBone ] ) ) then
		self.m_Objects[ iBone ] = NULL;
	end
	
	return self.m_Objects[ iBone ] ~= NULL;
end

function CPlayerBones:Release( iBone )
	if classname( self ) ~= 'CPlayerBones' then error( TEXT_E2288, 2 ) end
	
	if self:IsBusy( iBone ) then
		exports.bone_attach:detachElementFromBone( self.m_Objects[ iBone ] );
		
		delete ( self.m_Objects[ iBone ] );
		
		self.m_Objects[ iBone ] = NULL;
		
		return true;
	end
	
	return false;
end

function CPlayerBones:ReleaseAll()
	for iBone in pairs( self.m_Objects ) do
		self:Release( iBone );
	end
end