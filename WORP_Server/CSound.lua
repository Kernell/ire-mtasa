-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local gl_pSoundParent = createElement( "CSound", "CSound" );

enum "eSoundState"
{
	SOUND_STATE_ERROR		= -1;
    SOUND_STATE_STOPPED		= 0;
    SOUND_STATE_PLAYING		= 1;
    SOUND_STATE_PAUSED		= 2;
};

class: CSound
{
	m_ID				= NULL;
	m_sPath				= sPath;
	m_pAttachedTo		= NULL;
	m_iInterior			= 0;
	m_iDimension		= 0;
	m_fVolume			= 1.0;
	m_fMinDistance		= 5.0;
	m_fMaxDistance		= 30.0;
	m_bLoop				= true;
	m_pElement			= NULL;
	m_EnabledEffects	= NULL;
	m_sMemberID			= NULL;
	
	CSound		= function( this, sPath )
		this.m_sPath	= sPath;
	end;
	
	_CSound		= function( this )
		this:Stop();
		
		this.m_pAttachedTo		= NULL;
		this.m_vecPosition		= NULL;
		this.m_EnabledEffects	= NULL;
	end;
	
	Play		= function( this )
		if this.m_pAttachedTo and type( this.m_pAttachedTo ) ~= "userdata" then
			Error( 2, 2342, "this.m_pAttachedTo", "userdata", type( this.m_pAttachedTo ) );
		end
		
		this:Stop();
		
		local Sound	=
		{
			m_sPath				= this.m_sPath;
			m_fVolume			= this.m_fVolume;
			m_fMinDistance		= this.m_fMinDistance;
			m_fMaxDistance		= this.m_fMaxDistance;
			m_bLoop				= this.m_bLoop;
			m_EnabledEffects	= this.m_EnabledEffects;
			m_pAttachedTo		= this.m_pAttachedTo;
			m_sMemberID			= this.m_sMemberID;
		};
		
		this.m_pElement = createColSphere( 0.0, 0.0, 0.0, this.m_fMaxDistance + 40.0 );
		
		this.m_pElement:SetData( "CSound::", Sound );
		
		this.m_pElement:SetParent( gl_pSoundParent );
		
		this.m_pElement:SetInterior( this.m_iInterior );
		this.m_pElement:SetDimension( this.m_iDimension );
		
		if this.m_vecPosition then
			this.m_pElement:SetPosition( this.m_vecPosition );
		end
		
		if this.m_pAttachedTo then
			this.m_pElement:AttachTo( this.m_pAttachedTo );
		end
		
		return true;
	end;
	
	Pause		= function( this )
	end;
	
	Stop		= function( this )
		if this.m_pElement then
			this.m_pElement:Destroy();
			this.m_pElement = NULL;
			
			return true;
		end
		
		return false;
	end;
};
