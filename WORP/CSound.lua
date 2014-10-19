-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

enum "eSoundState"
{
	SOUND_STATE_ERROR		= -1;
    SOUND_STATE_STOPPED		= 0;
    SOUND_STATE_PLAYING		= 1;
    SOUND_STATE_PAUSED		= 2;
};

class: CSound
{
	CSound		= function( this, sPath, vecPosition, bLoop )
		if sPath and vecPosition then
			this.m_pSound = playSound3D( sPath, vecPosition.X, vecPosition.Y, vecPosition.Z, bLoop );
			
			this.m_pSound( this );
			
			return this.m_pSound;
		end
	end;
	
	_CSound		= function( this )
		this.m_pSound:Stop();
		this.m_pSound = NULL;
	end;
	
	GetEffects			= getSoundEffects;
	GetLength			= getSoundLength;
	GetMinDistance		= getSoundMinDistance;
	GetMaxDistance		= getSoundMaxDistance;
	GetPos				= getSoundPosition;
	GetMetaTags			= getSoundMetaTags;
	GetSpeed			= getSoundSpeed;
	GetVolume			= getSoundVolume;
	SetEffectEnabled	= setSoundEffectEnabled;
	IsPaused			= isSoundPaused;
	SetMinDistance		= setSoundMinDistance;
	SetMaxDistance		= setSoundMaxDistance;
	SetPaused			= setSoundPaused;
	SetPos				= setSoundPosition;
	SetSpeed			= setSoundSpeed;
	SetVolume			= setSoundVolume;
	Stop				= stopSound;
	GetBPM				= getSoundBPM;
	GetProperties		= getSoundProperties;
	SetProperties		= setSoundProperties;
	GetFFTData			= getSoundFFTData;
	GetWaveData			= getSoundWaveData;
	GetLevelData		= getSoundLevelData;
	SetPan				= setSoundPan;
	GetPan				= getSoundPan;
	
	AttachTo			= attachElements;
	Detach				= detachElements;
	IsAttached			= isElementAttached;
	SetInterior			= setElementInterior;
	SetDimension		= setElementDimension;
	SetPosition			= setElementPosition;
	GetPosition			= getElementPosition;
};

local Sounds = {};

function CreateSound( Sound )
	if Sounds[ Sound.m_ID ] then
		delete ( Sounds[ Sound.m_ID ] );
		Sounds[ Sound.m_ID ] = NULL;
	end
	
	local fX, fY, fZ = 0.0, 0.0, 0.0;
	
	if Sound.m_vecPosition then
		fX, fY, fZ = Sound.m_vecPosition.X, Sound.m_vecPosition.Y, Sound.m_vecPosition.Z;
	end
	
	local pSound = CSound( Sound.m_sPath, fX, fY, fZ, Sound.m_bLoop );
	
	if pSound then
		pSound:SetDimension( Sound.m_iInterior );
		pSound:SetInterior( Sound.m_iDimension );
		
		pSound:SetVolume( Sound.m_fVolume );
		pSound:SetMinDistance( Sound.m_fMinDistance );
		pSound:SetMaxDistance( Sound.m_fMaxDistance );
		
		if Sound.m_pAttachedTo then
			pSound:AttachTo( Sound.m_pAttachedTo );
		end
		
		Sounds[ Sound.m_ID ] = pSound;
	end
end

function StopSound( ID )
	if Sounds[ ID ] then
		delete ( Sounds[ ID ] );
		Sounds[ ID ] = NULL;
	end
end
