-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Client : Player
{
	ID			= 0;
	
	Client		= function()
		this = CLIENT( this );
		
		this.ID	= this.GetData( "Player::ID" );
		
		function this.__OnDamage( ... )
			this.OnDamage( ... );
		end
		
		function this.__OnChoke( ... )
			this.OnChoke( ... );
		end
		
		function this.__OnHeliKilled( ... )
			this.OnHeliKilled( ... );
		end
		
		addEventHandler( "onClientPlayerDamage", CLIENT, this.__OnDamage );
		addEventHandler( "onClientPlayerChoke", CLIENT, this.__OnChoke );
		addEventHandler( "onClientPlayerHeliKilled", CLIENT, this.__OnHeliKilled );
		
		showChat( false );
		showPlayerHudComponent( "all", false );
		setAmbientSoundEnabled( "gunfire", false );
		guiSetInputMode( "no_binds_when_editing" );
		
		this.BindKeys();
		
		this.VehicleControl	= new. ClientVehicleControl();
		
		SERVER.PlayerManager( "Ready", guiGetScreenSize() );
		
		return this;
	end;
	
	_Client		= function()
		removeEventHandler( "onClientPlayerDamage", CLIENT, this.__OnDamage );
		removeEventHandler( "onClientPlayerChoke", CLIENT, this.__OnChoke );
		removeEventHandler( "onClientPlayerHeliKilled", CLIENT, this.__OnHeliKilled );
		
		delete ( this.VehicleControl );
	end;
	
	GetID		= function()
		return this.ID;
	end;
	
	GetSkin		= function()
		return new. CharacterSkin( this.GetModel() );
	end;
	
	BindKeys	= function()
		bindKey( "mouse3", "down",	UI.RadialMenu.Show );
		bindKey( "mouse3", "up",	UI.RadialMenu.Hide );
		
		bindKey( "b", "up", "chatbox", "LocalOOC" );
		bindKey( "o", "up", "chatbox", "GlobalOOC" );
		
		bindKey( "f", "up", "enter" );
		bindKey( "r", "up", "reload_weapon" );
		
		bindKey( "i", "up", "inventory" );
		
		bindKey( "0", "up", "drop_weapon" );
		bindKey( "1", "up", "weapon_slot", "1" );
		bindKey( "2", "up", "weapon_slot", "2" );
		bindKey( "3", "up", "weapon_slot", "3" );
		bindKey( "4", "up", "weapon_slot", "4" );
		bindKey( "5", "up", "weapon_slot", "5" );
		
		bindKey( "change_camera", "down", Camera.ChangeMode );
	end;
	
	OnDamage	= function( attacker, weapon, bodypart, loss )
		if ( weapon == 17 and this.GetSkin().HaveGasMask() ) or this.GetData( "Player::IsAdmin" ) or this.GetData( "Player::DamageProof" ) then
			cancelEvent();
		end
	end;
	
	OnChoke		= function( weapon, attacker )
		if this.GetData( "Player::IsAdmin" ) or this.GetSkin().HaveGasMask() then
			cancelEvent();
		end
	end;
	
	OnHeliKilled	= function()
		cancelEvent();
	end;
};