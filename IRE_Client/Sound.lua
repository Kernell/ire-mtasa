-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Sound
{
	enum "eSoundState"
	{
		SOUND_STATE_ERROR		= -1;
		SOUND_STATE_STOPPED		= 0;
		SOUND_STATE_PLAYING		= 1;
		SOUND_STATE_PAUSED		= 2;
	};

	Sound		= function( path, position, loop )
		if path and position then
			return playSound3D( path, position.X, position.Y, position.Z, loop )( this );
		end
	end;
	
	_Sound		= function()
		this.Stop();
	end;
	
	GetEffects			= function()
		return getSoundEffects( this );
	end;
	
	GetLength			= function()
		return getSoundLength( this );
	end;
	
	GetMinDistance		= function()
		return getSoundMinDistance( this );
	end;
	
	GetMaxDistance		= function()
		return getSoundMaxDistance( this );
	end;
	
	GetPos				= function()
		return getSoundPosition( this );
	end;
	
	GetMetaTags			= function()
		return getSoundMetaTags( this );
	end;
	
	GetSpeed			= function()
		return getSoundSpeed( this );
	end;
	
	GetVolume			= function()
		return getSoundVolume( this );
	end;
	
	SetEffectEnabled	= function( ... )
		return setSoundEffectEnabled( this, ... );
	end;
	
	IsPaused			= function()
		return isSoundPaused( this );
	end;
	
	SetMinDistance		= function( ...)
		return setSoundMinDistance( this, ... );
	end;
	
	SetMaxDistance		= function( ...)
		return setSoundMaxDistance( this, ... );
	end;
	
	SetPaused			= function( ... )
		return setSoundPaused( this, ... );
	end;
	
	SetPos				= function( ... )
		return setSoundPosition( this, ... );
	end;
	
	SetSpeed			= function( ... )
		return setSoundSpeed( this, ... );
	end;
	
	SetVolume			= function( ... )
		return setSoundVolume( this, ... );
	end;
	
	Stop				= function()
		return stopSound( this );
	end;
	
	GetBPM				= function()
		return getSoundBPM( this );
	end;
	
	GetProperties		= function()
		return getSoundProperties( this );
	end;
	
	SetProperties		= function( ... )
		return setSoundProperties( this, ... );
	end;
	
	GetFFTData			= function()
		return getSoundFFTData( this );
	end;
	
	GetWaveData			= function()
		return getSoundWaveData( this );
	end;
	
	GetLevelData		= function()
		return getSoundLevelData( this );
	end;
	
	SetPan				= function( ... )
		return setSoundPan( this, ... );
	end;
	
	GetPan				= function()
		return getSoundPan( this );
	end;
	
	AttachTo			= function( ... )
		return attachElements( this, ... );
	end;
	
	Detach				= function( ... )
		return detachElements( this, ... );
	end;
	
	IsAttached			= function()
		return isElementAttached( this );
	end;
	
	SetInterior			= function( interior )
		return setElementInterior( this, interior );
	end;
	
	SetDimension		= function( dimension )
		return setElementDimension( this, dimension );
	end;
	
	SetPosition			= function( position )
		return setElementPosition( this, position.X, position.Y, position.Z );
	end;
	
	GetPosition			= function()
		return new. Vector3( getElementPosition( this ) );
	end;
};
