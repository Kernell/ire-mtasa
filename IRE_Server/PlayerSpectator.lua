-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. PlayerSpectator
{
	PlayerSpectator	= function( player )
		this.Player = player;
	end;
	
	_PlayerSpectator = function()
		this.Player = NULL;
	end;
	
	SetTarget	= function( player )
		if player and player.IsInGame() and this.Player.IsInGame() then
			if not this.Target then
				this.Position	= this.Player.GetPosition();
				this.Interior	= this.Player.GetInterior();
				this.Dimension	= this.Player.GetDimension();
				this.Rotation	= this.Player.GetRotation();
			end
			
			if not this.Player.IsKeyBound( "d", "up", "player", "spectate next" ) then
				this.Player.BindKey( "d", "up", "player", "spectate next" );
			end
			
			if not this.Player.IsKeyBound( "a", "up", "player", "spectate prev" ) then
				this.Player.BindKey( "a", "up", "player", "spectate prev" );
			end
			
			this.Player.Nametag.SetMaxDistance( 200.0 );
			
			this.Target = player;
			
			if player.HaveAccess( 'general.immunity' ) then
				player.Chat.Send( this.Player.UserName + " (" + this.Player.ID + ") наблюдает за Вами", 0, 200, 0 );
			end
			
			this.Update();
			
			return;
		end
		
		this.Target = NULL;
		
		this.Player.Nametag.SetMaxDistance( NULL );
		this.Player.RPC.Spectator.SetTarget( NULL );
		this.Player.UnbindKey( "d", "up", "player", "spectate next" );
		this.Player.UnbindKey( "a", "up", "player", "spectate prev" );
		this.Player.Detach();
		this.Player.RemoveFromVehicle();
		this.Player.Camera.SetTarget();
		
		if this.Position then
			this.Player.SetPosition( this.Position );
		end
		
		if this.Interior then
			this.Player.SetInterior( this.Interior );
		end
		
		if this.Dimension then
			this.Player.SetDimension( this.Dimension );
		end
		
		if this.Rotation then
			this.Player.SetRotation( this.Rotation );
		end
		
		this.Player.SetAlpha( 255 );
		this.Player.SetCollisionsEnabled( true );
		this.Player.SetFrozen( false );
		
		this.Position = NULL;
		this.Interior = NULL;
		this.Dimension = NULL;
		this.Rotation = NULL;
	end;
	
	GetTarget	= function()
		return this.Target;
	end;
	
	Update	= function()
		local target = this.Target;
		
		if target and target.IsInGame() then
			if target.Spectator.GetTarget() then
				this.Target = target.Spectator.GetTarget();
				
				return this.Update();
			end
			
			this.Player.RPC.Spectator.Update( target, 
				{ 
					money		= target.Character.Money;
					username	= target.UserName;
				} 
			);
			
			if this.Player.IsInVehicle() then
				this.Player.RemoveFromVehicle();
			end
			
			if this.Player.GetAlpha() > 0 then
				this.Player.SetAlpha( 0 );
			end
			
			if not this.Player.IsFrozen() then
				this.Player.SetFrozen( true );
			end
			
			if this.Player.IsCollisionsEnabled() then
				this.Player.SetCollisionsEnabled( false );
			end
			
			if this.Player.GetAttachedTo() ~= target then
				this.Player.SetPosition( target.GetPosition() + Vector3( 0, 0, -5 ) );
				this.Player.AttachTo( target, Vector3( 0, 0, -5 ) );
			end
			
			if this.Player.GetInterior() ~= target.GetInterior() then
				this.Player.SetInterior( target.GetInterior() );
			end
			
			if this.Player.GetDimension() ~= target.GetDimension() then
				this.Player.SetDimension( target.GetDimension() );
			end
			
			if this.Player.Camera.GetTarget() ~= target then
				this.Player.Camera.SetTarget( target );
			end
		else
			this.SetTarget( NULL );
		end
	end;
}
