-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local gl_pSoundParent = getElementByID( "CSound" );

class: CSoundManager
{
	CSoundManager	= function( this )
		this.m_List	= {};
		
		addEventHandler( "onClientColShapeHit", 	gl_pSoundParent,
			function( pElement, bMatchingDimension )
				if bMatchingDimension and pElement == CLIENT then
					this:OnStreamIn( source );
				end
			end
		);
		
		addEventHandler( "onClientColShapeLeave", 	gl_pSoundParent,
			function( pElement, bMatchingDimension )
				if bMatchingDimension and pElement == CLIENT then
					this:OnStreamOut( source );
				end
			end
		);
		
		addEventHandler( "onClientElementDestroy", 	gl_pSoundParent,
			function()
				-- if getElementType( source ) == "Sound" then
					this:OnDestroy( source );
				-- end
			end
		);
	end;
	
	_CSoundManager	= function( this )
		
	end;
	
	CreateSound		= function( this, pServerSound )
		local Sound = pServerSound:GetData( "CSound::" );
		
		if not Sound then
			return NULL;
		end
		
		if Sound.m_iState == SOUND_STATE_STOPPED then
			return NULL;
		end
		
		local vecPosition		= pServerSound:GetPosition();
		local iInterior			= pServerSound:GetInterior();
		local iDimension		= pServerSound:GetDimension();
		
		local pSound = CSound( Sound.m_sPath, vecPosition, Sound.m_bLoop );
		
		pSound:SetInterior( iInterior );
		pSound:SetDimension( iDimension );
		pSound:SetVolume( Sound.m_fVolume );
		pSound:SetMinDistance( Sound.m_fMinDistance );
		pSound:SetMaxDistance( Sound.m_fMaxDistance );
		
		if Sound.m_EnabledEffects then
			for i, sEffect in ipairs( Sound.m_EnabledEffects ) do
				pSound:SetEffectEnabled( sEffect, true );
			end
		end
		
		if Sound.m_pAttachedTo and Sound.m_sMemberID then
			Sound.m_pAttachedTo[ Sound.m_sMemberID ] = pServerSound;
		end
		
		pServerSound.m_pSound = pSound;
		
		pSound:AttachTo( pServerSound );
		
		return pSound;
	end;
	
	OnDataChange	= function( this, pServerSound, sDataName, vOldValue )
		if CLIENT:IsWithinColShape( pServerSound ) then
			local pSound = this.m_List[ pServerSound ];
			
			if not pSound then
				this.m_List[ pServerSound ] = this:CreateSound( pServerSound );
			elseif sDataName == "CSound::" then
				local vValue = pServerSound:GetData( sDataName );
				
				
			end
		end
	end;
	
	OnStreamIn		= function( this, pServerSound )
		local pSound = this.m_List[ pServerSound ];
		
		if pSound then
			delete ( pSound );
			
			this.m_List[ pServerSound ] = NULL;
		end
		
		this.m_List[ pServerSound ] = this:CreateSound( pServerSound );
	end;
	
	OnStreamOut		= function( this, pServerSound )
		local pSound = this.m_List[ pServerSound ];
		
		if pSound then
			delete ( pSound );
			
			pServerSound.m_pSound = NULL;
			
			this.m_List[ pServerSound ] = NULL;
		end
	end;
	
	OnDestroy		= function( this, pServerSound )
		local pSound = this.m_List[ pServerSound ];
		
		if pSound then
			delete ( pSound );
			
			pServerSound.m_pSound = NULL;
			
			this.m_List[ pServerSound ] = NULL;
		end
	end;
};
