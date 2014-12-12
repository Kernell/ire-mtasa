-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. PlayerCamera
{
	PlayerCamera	= function( player )
		this.Player = player;
	end;
	
	_PlayerCamera	= function()
	
	end;
	
	Fade	= function( ... )
		return fadeCamera( this.Player, ... );
	end;
	
	GetInterior	= function()
		return getCameraInterior( this.Player );
	end;
	
	GetMatrix	= function()
		local fX, fY, fZ, fLX, fLY, fLZ, fRoll, fFOV = getCameraMatrix( this.Player );
		
		return Vector3( fX, fY, fZ ), Vector3( fLX, fLY, fLZ ), fRoll, fFOV;
	end;
	
	GetTarget	= function()
		return getCameraTarget( this.Player );
	end;
	
	SetInterior	= function( interior )
		return setCameraInterior( this.Player, (int)(interior) );
	end;
	
	SetFreeLookEnabled	= function( enabled )
		this.Player.SetFrozen( enabled );
		this.Player.SetCollisionsEnabled( not enabled );
		this.Player.SetAlpha( enabled and 0 or 255 );

		return this.Player.RPC.Camera.SetFreeLookEnabled( enabled );
	end;
	
	SetMatrix	= function( position, target, ... )
		position	= position or Vector3();
		target		= target or Vector3();
		
		this.Player.RPC.Camera.SetLocked( false );
		
		return setCameraMatrix( this.Player, position.X, position.Y, position.Z, target.X, target.Y, target.Z, ... );
	end;

	SetTarget	= function( target )
		this.Player.RPC.Camera.SetLocked( false );
		
		return setCameraTarget( this.Player, target or this.Player );
	end;

	MoveTo	= function( position, ... )
		this.Player.RPC.Camera.MoveTo( position.X, position.Y, position.Z, ... );
	end;

	RotateTo	= function( position, ... )
		this.Player.RPC.Camera.RotateTo( position.X, position.Y, position.Z, ... );
	end;
}
