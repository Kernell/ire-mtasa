-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CGate"

function CGate:CGate( pGateManager, iID, iModel, pFaction, pJob, iInterior, iDimension, vecPosition, vecRotation, vecTargetPosition, vecTargetRotation, iTime, fRadius, sEasing, fEasingPeriod, fEasingAmplitude, fEasingOvershoot )
	self.m_pGateManager			= pGateManager;
	
	self.m_iID					= iID;
	self.m_bOpened				= false;
	self.m_pFaction				= pFaction;
	self.m_pJob					= pJob;
	self.m_iInterior			= iInterior;
	self.m_iDimension			= iDimension;
	self.m_vecPosition			= vecPosition;
	self.m_vecRotation			= vecRotation;
	self.m_vecTargetPosition	= vecTargetPosition;
	self.m_vecTargetRotation	= vecTargetRotation;
	self.m_iTime				= iTime;
	self.m_fRadius				= fRadius;
	self.m_sEasing				= sEasing;
	self.m_fEasingPeriod		= fEasingPeriod;
	self.m_fEasingAmplitude		= fEasingAmplitude;
	self.m_fEasingOvershoot		= fEasingOvershoot;
	self.m_iMovingStart			= 0;
	
	self.m_pColShape			= CColShape( "Sphere", self.m_vecPosition.X, self.m_vecPosition.Y, self.m_vecPosition.Z, self.m_fRadius );
	
	self.m_pColShape:SetInterior	( self.m_iInterior );
	self.m_pColShape:SetDimension	( self.m_iDimension );
	
	self.m_pObject				= CObject.Create( iModel, self.m_vecPosition, self.m_vecRotation );
	
	self.m_pObject:SetInterior	( self.m_iInterior );
	self.m_pObject:SetDimension	( self.m_iDimension );
	
	pGateManager:AddToList( self );
end

function CGate:_CGate()
	self.m_pGateManager:RemoveFromList( self );
	
	delete ( self.m_pColShape );
	self.m_pColShape = NULL;
	
	delete ( self.m_pObject );
	self.m_pObject	= NULL;
end

function CGate:GetID()
	return self.m_iID;
end

function CGate:IsOpen()
	return self.m_bOpened;
end

function CGate:GetFaction()
	return self.m_pFaction;
end

function CGate:GetJob()
	return self.m_pJob;
end

function CGate:GetObject()
	return self.m_pObject;
end

function CGate:DoPulse( tReal )
	local bOpened = false;
	
	for i, pPlayer in ipairs( self.m_pColShape:GetWithinColShape( "player" ) ) do	
		if pPlayer and pPlayer:GetInterior() == self.m_iInterior and pPlayer:GetDimension() == self.m_iDimension then
			local pChar = pPlayer:GetChar();
			
			if pChar and ( self.m_pFaction == NULL or self.m_pFaction == pChar:GetFaction() ) then
				bOpened = true;
				
				break;
			end
		end
	end
	
	if self.m_iMovingStart ~= 0 and tReal.timestamp - self.m_iMovingStart >= self.m_iTime / 1000 then
		self.m_pObject:SetRotation( self.m_bOpened and self.m_vecTargetRotation or self.m_vecRotation );
		
		self.m_iMovingStart = 0;
	end
	
	if self.m_bOpened ~= bOpened then
		local vecRotation 		= self.m_pObject:GetRotation();
		local vecNewPosition	= self.m_bOpened and self.m_vecPosition or self.m_vecTargetPosition;
		local vecNewRotation	= self.m_bOpened and self.m_vecRotation - vecRotation or self.m_vecTargetRotation - vecRotation;
		
		self.m_bOpened			= bOpened;
		self.m_iMovingStart		= tReal.timestamp;
		
		self.m_pObject:Move( self.m_iTime, vecNewPosition, vecNewRotation, self.m_sEasing, self.m_fEasingPeriod, self.m_fEasingAmplitude, self.m_fEasingOvershoot );
	end
end
