-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local iFakePlayerCount = 0;

class: CFakePlayer ( CPlayer )
{
	CFakePlayer		= function( this, pPlayerManager, pPlayerEntity, sNickname )
		iFakePlayerCount = iFakePlayerCount + 1;
		
		this.m_iFakeID	= iFakePlayerCount;
		
		this:SetName( "FakePlayer" + this.m_iFakeID );
		
		this:CPlayer( pPlayerManager, pPlayerEntity );
		
		CClientRPC.Ready( this );
		
		setTimer(
			function()
				if this:Login( 2 ) then
					if this.m_Characters then
						local pCharacter = this.m_Characters[ math.random( table.getn( this.m_Characters ) ) ];
						
						CClientRPC.SelectCharacter( this, pCharacter[ 'name' ], pCharacter[ 'surname' ] );
					end
				end
			end,
			1000, 1
		);
	end;
	
	_CFakePlayer	= function( this )
		
	end;
	
	Save			= function( this )
		return true;
	end;
	
	GetName			= function( this )
		return this.m_sNickname;
	end;
	
	SetName			= function( this, sNickname )
		this.m_sNickname	= sNickname;
		
		return true;
	end;
	
	GetIP			= function( this )
		return "127.0.0.1";
	end;
	
	GetSerial		= function( this )
		return "FAKEPLAYER" + this.m_iFakeID;
	end;
	
	Spawn			= function( this, vecSpawn, fRotation, iSkin, iInterior, iDimension )
		this:SetSkin( iSkin );
		this:SetPosition( vecSpawn );
		this:SetRotation( fRotation );
		this:SetInterior( iInterior );
		this:SetDimension( iDimension );
		
		return true;
	end;
	
	ToggleControls	= function( this, bEnabled, bGtaControls, bMtaControls )
		return true;
	end;
	
	DisableControls	= function( this, ... )
		for _, sControl in ipairs( { ... } ) do
			this.m_aControls[ sControl ] = false;
		end
		
		this:SetData( "CPlayer::m_Controls", this.m_aControls );
	end;
	
	EnableControls	= function( this, ... )
		for _, sControl in ipairs( { ... } ) do
			this.m_aControls[ sControl ] = false;
		end
		
		this:SetData( "CPlayer::m_Controls", this.m_aControls );
	end;
	
	SetControlState	= function( this, sControl, bState )
		this.m_aControlStates[ sControl ] = (bool)(bState);
		
		this:SetData( "CPlayer::m_ControlStates", this.m_aControlStates );
		
		return true;
	end;
	
	GetControlState	= function( this, sControl )
		return this.m_aControlStates[ sControl ];
	end;
	
	BindKey			= function( this, sKey, sKeyState, vFunction, ... )
		this.m_Binds[ sKey ] = vFunction;
		
		return true;
	end;
	
	UnbindKey		= function( this, sKey, sKeyState, vFunction )
		if this:IsKeyBound( sKey, sKeyState, vFunction ) then
			this.m_Binds[ sKey ] = NULL;
			
			return true;
		end
		
		return false;
	end;
	
	IsKeyBound		= function( this, sKey, sKeyState, vFunction )
		return this.m_Binds[ sKey ] == vFunction;
	end;
	
	PlaySoundFrontEnd	= function( this, iSound )
		return true;
	end;
	
	Client			= function( this )
		return setmetatable( 
			{
				
			},
			{
				__index	= function( self, key )
					return rawget( self, key ) or function( ... )
						return true;
					end;
				end;
			}
		);
	end;
};
