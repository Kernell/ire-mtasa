-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CGate
{
	m_iElementsCount	= 0;
	m_iMovingStart		= 0;
	m_Players			= NULL;
	
	CGate	= function( this, iID, iModel, pFaction, iInterior, iDimension, vecPosition, vecRotation, vecTargetPosition, vecTargetRotation, iTime, fRadius, sEasing, fEasingPeriod, fEasingAmplitude, fEasingOvershoot )
		this.m_Players				= {};
		this.m_iID					= iID;
		this.m_bOpened				= false;
		this.m_pFaction				= pFaction;
		this.m_iInterior			= iInterior;
		this.m_iDimension			= iDimension;
		this.m_vecPosition			= vecPosition;
		this.m_vecRotation			= vecRotation;
		this.m_vecTargetPosition	= vecTargetPosition;
		this.m_vecTargetRotation	= vecTargetRotation;
		this.m_iTime				= iTime;
		this.m_fRadius				= fRadius;
		this.m_sEasing				= sEasing;
		this.m_fEasingPeriod		= fEasingPeriod;
		this.m_fEasingAmplitude		= fEasingAmplitude;
		this.m_fEasingOvershoot		= fEasingOvershoot;
		
		this.m_pColShape			= CColShape( "Sphere", this.m_vecPosition.X, this.m_vecPosition.Y, this.m_vecPosition.Z, this.m_fRadius );
		
		this.m_pColShape:SetInterior	( this.m_iInterior );
		this.m_pColShape:SetDimension	( this.m_iDimension );
		
		this.m_pColShape.m_pGate	= this;
		this.m_pColShape.OnHit		= this.OnHit;
		this.m_pColShape.OnLeave	= this.OnLeave;
		
		this.m_pObject				= CObject.Create( iModel, this.m_vecPosition, this.m_vecRotation );
		
		this.m_pObject:SetInterior	( this.m_iInterior );
		this.m_pObject:SetDimension	( this.m_iDimension );
		
		g_pGame:GetGateManager():AddToList( this );
	end;
	
	_CGate	= function( this )
		g_pGame:GetGateManager():RemoveFromList( this );
		
		this.m_pColShape.OnHit		= NULL;
		this.m_pColShape.OnLeave	= NULL;
		
		delete ( this.m_pColShape );
		this.m_pColShape = NULL;
		
		delete ( this.m_pObject );
		this.m_pObject	= NULL;
		
		this.m_Players				= NULL;
		this.m_vecPosition			= NULL;
		this.m_vecRotation			= NULL;
		this.m_vecTargetPosition	= NULL;
		this.m_vecTargetRotation	= NULL;
	end;
	
	GetID	= function( this )
		return this.m_iID;
	end;
	
	OnHit	= function( pColShape, pElement, bDimension )
		local this = bDimension and pColShape.m_pGate;
		
		if this and classof( pElement ) == CPlayer then
			local pChar	= pElement:GetChar();
			
			if pChar and ( this.m_pFaction == NULL or this.m_pFaction == pChar:GetFaction() ) then
				this.m_Players[ pElement ]	= true;
				this.m_iElementsCount 		= this.m_iElementsCount + 1;
				
				if _DEBUG then
					Debug( "< CGate* >( " + this:GetID() + " )::OnHit( " + pChar:GetName() + " ); // " + this.m_iElementsCount );
				end
			end
		end
	end;
	
	OnLeave	= function( pColShape, pElement, bDimension )
		local this = pColShape.m_pGate;
		
		if this and this.m_Players[ pElement ] and ( bDimension or pElement:GetDimension() == pColShape:GetDimension() ) then
			this.m_Players[ pElement ]	= NULL;
			this.m_iElementsCount 		= this.m_iElementsCount - 1;
			
			if _DEBUG then
				Debug( "< CGate* >( " + this:GetID() + " )::OnLeave( " + pElement:GetName() + " ); // " + this.m_iElementsCount );
			end
		end
	end;
	
	DoPulse	= function( this, tReal )
		local bOpened = this.m_iElementsCount > 0;
		
		if this.m_iMovingStart ~= 0 and tReal.timestamp - this.m_iMovingStart >= this.m_iTime / 1000 then
			this.m_pObject:SetRotation( this.m_bOpened and this.m_vecTargetRotation or this.m_vecRotation );
			
			this.m_iMovingStart = 0;
		end
		
		if this.m_bOpened ~= bOpened then
			local vecRotation 		= this.m_pObject:GetRotation();
			local vecNewPosition	= this.m_bOpened and this.m_vecPosition or this.m_vecTargetPosition;
			local vecNewRotation	= this.m_bOpened and this.m_vecRotation - vecRotation or this.m_vecTargetRotation - vecRotation;
			
			this.m_bOpened			= bOpened;
			this.m_iMovingStart		= tReal.timestamp;
			
			this.m_pObject:Move( this.m_iTime, vecNewPosition, vecNewRotation, this.m_sEasing, this.m_fEasingPeriod, this.m_fEasingAmplitude, this.m_fEasingOvershoot );
		end
	end;
};
