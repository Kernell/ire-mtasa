-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0


class. SoundManager
{
	static
	{
		Root = getElementByID( "Sound" );
	};
	
	SoundManager	= function()
		this.List	= {};
		
		addEventHandler( "onClientColShapeHit", 	SoundManager.Root,
			function( element, matchingDimension )
				if matchingDimension and element == CLIENT then
					this.OnStreamIn( source );
				end
			end
		);
		
		addEventHandler( "onClientColShapeLeave", 	SoundManager.Root,
			function( element, matchingDimension )
				if matchingDimension and element == CLIENT then
					this.OnStreamOut( source );
				end
			end
		);
		
		addEventHandler( "onClientElementDestroy", 	SoundManager.Root,
			function()
				-- if getElementType( source ) == "Sound" then
					this.OnDestroy( source );
				-- end
			end
		);
	end;
	
	CreateSound		= function( serverSound )
		local sound = serverSound.GetData( "Sound::" );
		
		if not sound then
			return NULL;
		end
		
		if sound.State == SOUND_STATE_STOPPED then
			return NULL;
		end
		
		local position		= serverSound.GetPosition();
		local interior		= serverSound.GetInterior();
		local dimension		= serverSound.GetDimension();
		
		local sound = new. Sound( Sound.m_sPath, vecPosition, Sound.m_bLoop );
		
		sound.SetInterior( interior );
		sound.SetDimension( dimension );
		sound.SetVolume( sound.Volume );
		sound.SetMinDistance( sound.MinDistance );
		sound.SetMaxDistance( sound.MaxDistance );
		
		if sound.EnabledEffects then
			for i, effect in ipairs( Sound.EnabledEffects ) do
				sound.SetEffectEnabled( effect, true );
			end
		end
		
		if sound.AttachedTo and sound.MemberID then
			sound.AttachedTo[ sound.MemberID ] = serverSound;
		end
		
		serverSound.Sound = sound;
		
		sound.AttachTo( serverSound );
		
		return sound;
	end;
	
	OnDataChange	= function( serverSound, dataName, oldValue )
		if CLIENT.IsWithinColShape( serverSound ) then
			local sound = this.List[ serverSound ];
			
			if not sound then
				this.List[ serverSound ] = this.CreateSound( serverSound );
			elseif dataName == "Sound::" then
				local value = serverSound.GetData( dataName );
				
				
			end
		end
	end;
	
	OnStreamIn		= function( serverSound )
		local sound = this.List[ serverSound ];
		
		if sound then
			delete ( sound );
			
			this.List[ serverSound ] = NULL;
		end
		
		this.List[ serverSound ] = this.CreateSound( serverSound );
	end;
	
	OnStreamOut		= function( serverSound )
		local sound = this.List[ serverSound ];
		
		if sound then
			delete ( sound );
			
			serverSound.Sound = NULL;
			
			this.List[ serverSound ] = NULL;
		end
	end;
	
	OnDestroy		= function( serverSound )
		local sound = this.List[ serverSound ];
		
		if sound then
			delete ( sound );
			
			serverSound.Sound = NULL;
			
			this.List[ serverSound ] = NULL;
		end
	end;
};
