-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. Player : Ped
{
	property: RPC
	{
		get	= function()
			local namespace = {};
			
			local instance = 
			{	
				__index = function( t, key )
					table.insert( namespace, key );
					
					local obj = 
					{
						__call	= function( tt, ... )
							local cr = coroutine.running();
							
							if not cr then
								triggerClientEvent( this, Server.RPC.Server2ClientName, this, { ID = NULL, Namespace = namespace; }, ... );
								
								return;
							end
							
							local tick		= getTickCount();
							
							local id = this.ID + table.concat( namespace, '.' ) + (string)(tick);
							
							local handle = Server.RPC.CreateThread( id, cr );
							
							handle.Call( this, namespace, ... );
							
							coroutine.yield();
							
							local result = NULL;
							
							if handle.StatusCode == 200 then
								result = handle.Result;
							else
								handle.Destroy();
								
								error( handle.StatusCode + " - " + handle.StatusText, 2 );
							end
							
							handle.Destroy();
							
							return result;
						end;
						
						__index	= t.__index;
					};
					
					return setmetatable( obj, obj );
				end;
			};
			
			return setmetatable( instance, instance );
		end;
	};
	
	property: AdminName
	{
		get = function()
			return "Агент поддержки #" + this.AdminID;
		end;
	};

	property: VisibleName
	{
		get = function()
			if this.IsAdmin then
				return this.AdminName;
			elseif this.IsInGame() then
				return this.Character.GetName();
			end

			return this.GetName();
		end;
	};
	
	ID					= 0;
	UserID				= 0;
	IsAdmin				= false;
	AdminID				= 0;
	GP					= 0;
	InGameCount 		= 0;
	PayDay				= 0;
	MuteSeconds 		= 0;
	Antiflood			= 0;
	LowHPAnim			= false;
	HealthRegenPause	= 0;

	UserName			= "";
	
	Player = function( player )
		player( this );
		
		local this = player;
		
		this.Tutorial			= new. PlayerTutorial	( player );
		this.Animation			= new. PlayerAnimation	( player );
		this.Spectator 			= new. PlayerSpectator	( player );
		this.Camera 			= new. PlayerCamera		( player );
		this.HUD 				= new. PlayerHUD		( player );
		this.Chat 				= new. PlayerChat		( player );
		this.Nametag 			= new. PlayerNametag	( player );
		this.Bones				= new. PlayerBones		( player );
		
		this.Character 			= NULL;
		this.Binds				= {};
		this.Controls 			= {};
		this.ControlStates		= {};
		this.ReportData			=
		{
			timestamp			= 0;
			text				= NULL;
			locked				= true;
		};
		
		Server.Game.PlayerManager.AddToList( this );
		
		this.SetID( "player:" + this.GetID() );
		
		this.SetData( "Player::ID", this.GetID(), true, true );
		this.SetData( "Player::Controls", this.Controls );
		this.SetData( "Player::ControlStates", this.ControlStates );
		
		if _DEBUG then	
			Debug( "Creating player \'" + this.GetName() + "\' (" + this.GetID() + ")" );
		end
		
		return player;
	end;
	
	_Player	= function()
		this.OnColShapeLeave( false );
		
		delete ( this.Tutorial );
		
		if this.IsInGame() then
			delete ( this.Character );
			
			this.Character = NULL;
		end
		
		if _DEBUG then
			Debug( "Removed player \"" + this.GetName() + " (" + this.GetID() + ")" );
		end
		
		delete ( this.Animation );
		delete ( this.Spectator );
		delete ( this.Camera );
		delete ( this.HUD );
		delete ( this.Chat );
		delete ( this.Nametag );
		delete ( this.Bones );
		
		this.Tutorial	= NULL;
		this.Animation	= NULL;
		this.Spectator	= NULL;
		this.Camera		= NULL;
		this.HUD		= NULL;
		this.Chat		= NULL;
		this.Nametag	= NULL;
		this.Bones		= NULL;
		
		this.RemoveData( "Player::ID" );
		this.Destroy();
	end;
	
	Unlink	= function( type, reason, responsePlayer )
		if this.Character then
			this.Character.Logout( type, reason, responsePlayer );
		end
		
		this.IsAdmin = false;
		
		this.Save();
		this.InitLoginCamera();
		
		Server.Game.PlayerManager.RemoveFromList( this );
	end;
	
	GetID	= function()
		return this.ID;
	end;
	
	GetName	= function()
		return getPlayerName( this );
	end;

	GetPing	= function()
		return getPlayerPing( this );
	end;

	GetTeam	= function()
		return getPlayerTeam( this );
	end;
	
	IsLoggedIn	= function()
		return this.UserID ~= 0;
	end;

	GetGP	= function()
		return this.GP;
	end;

	SetGP	= function( gp )
		if gp >= 0 then
			if not Server.DB.Query( "UPDATE uac_users SET goldpoints = %d WHERE id = %d", gp, this.UserID ) then
				Debug( Server.DB.Error(), 1 );
				
				return false;
			end
			
			this.GP = gp;
			
			return true;
		end

		return false;
	end;
	
	SetMuted	= function( iTime )
		iTime = (int)(iTime);
		
		this.MuteSeconds = iTime > 0 and iTime * 60 or NULL;
		
		if this.IsLoggedIn() then
			return Server.DB.Query( "UPDATE uac_users SET muted_time = " + ( this.MuteSeconds or "NULL" ) + " WHERE id = " + this.UserID ) or not Debug( g_pDB:Error() );
		end
		
		return true;
	end;

	GetMuted	= function()
		return this.MuteSeconds;
	end;

	IsMuted		= function()
		return (bool)(this.MuteSeconds);
	end;
	
	ShowLoginScreen = function()
		this.LoginAttempts = NULL;
		
		this.InitLoginCamera();
		
		local result = Server.DB.Query( "SELECT `id`, `password` FROM `uac_users_autologin` WHERE `serial` = '%s' LIMIT 1", this.GetSerial() );
		
		if result then
			local row = result.GetRow();
			
			result.Free();
			
			if row then
				local userID	= row.id;
				local password	= row.password;
				
				local result = Server.DB.Query( "SELECT `id` FROM `uac_users` WHERE `id` = %d AND `password` = %q LIMIT 1", userID, password );
				
				if result then
					local row = result.GetRow();
					
					result.Free();
					
					if row and row.id then
						this.Login( row.id );
						
						return;
					end
				else
					Debug( Server.DB.Error(), 1 );
				end
			end
		end
		
		this.RPC.UI.LoginScreen.Show( { login = "" } );
	end;

	InitLoginCamera = function()
		if this.IsInVehicle() then
			this.RemoveFromVehicle();
		end
		
		this.ToggleControls( true, true, false );
		this.DisableControls( "next_weapon", "previous_weapon", "action", "walk", "fire", "horn", "radio_next", "radio_previous", "vehicle_left", "vehicle_right" );
		
		this.BindKey( "horn", "both", Player.KeyVehicleHorn );
		this.BindKey( "j", "up", Player.KeyVehicleToggleEngine );
		this.BindKey( "k", "up", Player.KeyVehicleToggleLocked );
		this.BindKey( "l", "up", Player.KeyVehicleToggleLights );
		
		this.BindKey( "sprint", "both", Player.KeySprint );
		
		this.RemoveData( "Player::Level" );
		
		this.HUD.HideComponents( "all" );
		this.Chat.Hide();
		
		this.Spawn( PlayerManager.DEFAULT_SPAWN_POSITION, 0, 0, 0, 0, Server.Game.PlayerManager.TeamNotLoggedIn );
		this.SetName( "Not_logged_in_" + this.GetID() );
		
		this.Nametag.Hide();
		this.Nametag.Update();
		
		this.SetAlpha( 0 );
		this.SetCollisionsEnabled( false );
		
		this.Camera.SetInterior();
		this.Camera.SetMatrix( PlayerManager.DEFAULT_CAMERA_POSITION, PlayerManager.DEFAULT_CAMERA_TARGET );
		this.Camera.Fade( true );
	end;
	
	Login	= function( UserID )
		local result = Server.DB.Query( "SELECT admin_id, `groups`, name, password, ip, DATE_FORMAT( last_logout, '%d %M %Y г. %H:%i' ) as last_login_f, DATEDIFF( CURDATE(), last_logout ) AS last_login_d, settings, adminduty, muted_time, login_history, goldpoints FROM uac_users WHERE id = " + UserID + " LIMIT 1" );
		
		if result ~= NULL then
			local row = result.GetRow();
	
			result.Free();

			if row ~= NULL then
				local serial	= this.GetSerial();
				local ip		= this.GetIP();

				this.LoginHistory = row[ "login_history" ] and row[ "login_history" ]:split( '\n' ) or {};
				
				table.insert( this.LoginHistory, getRealTime().timestamp + "|" + ip + "|" + serial );
				
				while( table.getn( this.LoginHistory ) > 32 ) do
					table.remove( this.LoginHistory, 1 );
				end
				
				local updateQuery = "UPDATE `uac_users` SET \
					`login_history` = '" + table.concat( this.LoginHistory, '\n' ) + "',\
					`serial` = '" + serial + "', `ip` = '" + ip + "',\
					`last_login` = NOW(),\
					`activation_code` = NULL\
				WHERE `id` = " + UserID;

				if not Server.DB.Query( updateQuery ) then
					Debug( Server.DB.Error(), 1 );
				end
				
				this.UserID					= UserID;
				this.UserName				= row[ "name" ];
				
				this.AdminID				= row[ "admin_id" ];
				this.IsAdmin				= row[ "adminduty" ] == "Yes";
				
				this.InitGroups( row[ "groups" ], true );
				
				this.MuteSeconds			= row[ "muted_time" ];
				this.ReportData.Locked		= row[ "report_locked" ] == "Yes";

				local lastLogin = "";

				if row[ "last_login_f" ] ~= "00 00 0000 г. 00:00" then
					if row[ "last_login_d" ] == 0 then
						lastLogin = "Сегодня в " + row[ "last_login_f" ]:split( ' ' )[ 5 ];
					elseif row[ "last_login_d" ] == 1 then
						lastLogin = "Вчера в " + row[ "last_login_f" ]:split( ' ' )[ 5 ];
					else
						lastLogin = row[ "last_login_f" ];
					end
				end
				
				if lastLogin ~= "" then
					this.Chat.Send( string.format( "Приветствуем Вас %s, последний раз Вы были тут %s (%s)", this.UserName, lastLogin, row[ "ip" ] ), 0, 255, 0 );
				end
				
				this.GP = row[ "goldpoints" ];

			--	this.RPC.Settings.Load( not row[ "settings" ] and row[ "settings" ] or "" );
		
				-- Load characters
		
				this.LoadCharacters( this.UserID );
				
				Console.Log( "%s (ID: %d) logged in (Serial: %s)", this.UserName, this.UserID, serial );
		
				return true;
			end
		else
			Debug( Server.DB.Error(), 1 );
		end

		return false;
	end;

	InitGroups	= function( groups, alert )
		if this.IsLoggedIn() then
			if groups == NULL then
				local result = Server.DB.Query( "SELECT `groups` FROM `uac_users` WHERE `id` = " + this.UserID + " LIMIT 1" );

				if result ~= NULL then
					groups = result.GetRow()[ "groups" ];
					
					result.Free();
				else
					Debug( Server.DB.Error(), 1 );
					
					return false;
				end
			end

			local Groups = {};

			this.Groups = {};

			if groups ~= NULL then
				for i, groupID in ipairs( groups:split( ',' ) ) do
					local group = Server.Game.GroupManager.Get( (int)(groupID) );

					if group ~= NULL then
						table.insert( this.Groups, group );
						
						table.insert( Groups, group.GetName() );
						
						if group.GetName() == "Разработчики" then
							this.RPC.setDevelopmentMode( true );

							if alert then
								this.Chat.Send( " Development mode is enabled", 255, 200, 0 );
							end
						end
					end
				end
			end

			if table.getn( this.Groups ) > 0 then
				if this.AdminID == 0 then
					Server.DB.Query( "UPDATE `uac_users`, ( SELECT MAX( `admin_id` ) + 1 AS `maxid` FROM `uac_users` ) AS users SET `admin_id` = users.maxid WHERE `id` = " + this.UserID );
				
					local result = Server.DB.Query( "SELECT `admin_id` FROM `uac_users` WHERE `id` = " + this.UserID + " LIMIT 1" );
					
					if result ~= NULL then
						this.AdminID = result.FetchRow()[ "admin_id" ];

						result.Free();
					else
						Debug( Server.DB.Error(), 1 );
					end
				end

				if this.AdminID == 0 then
					this.AdminID = math.random( 9000, 9999 );
				end
				
				this.UnbindKey( "end", "down", Player.ToggleClientConsole );

				this.UnbindKey( "F4", "up", "chatbox", "adminchat" );
				
				if this.HaveAccess( "command.adminchat" ) then
					this.BindKey( "end", "down", Player.ToggleClientConsole );
					
					this.BindKey( "F4", "up", "chatbox", "adminchat" );
				end
				
				if alert then
					this.Chat.Send( "Вы состоите в группах: " + table.concat( Groups, ", " ), 0, 255, 128 );
					this.Chat.Send( "Ваш личный номер: " + this.AdminID, 255, 255, 128 );
					this.Chat.Send( " " );
				end
			end

			this.SetAdminDuty( this.IsAdmin );

			return true;
		end

		return false;
	end;
	
	DoPulse	= function( realTime )
		if not this.IsInGame() then
			return;
		end
		
		this.InGameCount	= this.InGameCount + 1;
		this.PayDay			= this.PayDay + 1;
		
		if this.IsMuted() then
			this.MuteSeconds = this.MuteSeconds - 1;
			
			if this.MuteSeconds <= 0 then
				this.SetMuted( false );
				
				this.Chat.Send( "Время молчанки истекло", 255, 128, 0 );
			end
		end
		
		if this.Antiflood > 0 then
			this.Antiflood = this.Antiflood - 1;
		end
		
		local health = this.IsDead() and 0.0 or this.GetHealth();
		
		if health > 0.0 then
			if not this.IsInVehicle() then
				if health < 20.0 then
					if this.IsInWater() then
						this.Kill( null, null, null, true );
					else
						if this.LowHPAnim then
							this.SetAnimation( PlayerAnimation.PRIORITY_LOWHP, "PED", "KO_skid_front", -1, false, false, false, true );
							
							this.LowHPAnim = true;
							
							this.Hint( "Info", "Ваше текущее состояние не позволяет Вам передвигаться дальше", "info" );
						else
							-- this.SetAnimation( PlayerAnimation.PRIORITY_LOWHP, "PED", "KO_skid_front", -1, false, false, false, true );
							
							-- this.SetAnimationProgress( "KO_skid_front", 1.0 );
						end
					end
				elseif this.LowHPAnim then
					this.SetAnimation( PlayerAnimation.PRIORITY_LOWHP, "PED", "getup", 1500, false, false, false, false );
					
					this.LowHPAnim = false;
				else
					this.LowHPAnim = false;
				end
			else
				this.LowHPAnim = false;
			end
		end
		
		if health > 0 and health < 100 then
			if this.HealthRegenPause == 0 then
				this.SetHealth( health + 1 );

				this.HealthRegenPause = math.ceil( health * 0.3 );
			end

			this.HealthRegenPause = this.HealthRegenPause - 1;
		end
		
		if this.Character.IsCuffed() and not this.LowHPAnim then
			local cuffedTo = this.Character.CuffedTo and this.Character.CuffedTo.Player;
			
			if cuffedTo and cuffedTo.IsInGame() then
				if cuffedTo.IsDead() then
					this.Character.SetCuffed();
					
					return true;
				end
				
				local distance = this.GetPosition().Distance( cuffedTo.GetPosition() );
				
				local isPlayerMoved  = cuffedTo.GetControlState( "forwards" )
									or cuffedTo.GetControlState( "backwards" )
									or cuffedTo.GetControlState( "left" )
									or cuffedTo.GetControlState( "right" );
				
				if distance > 30 then
					if this.IsInVehicle() then
						this.RemoveFromVehicle();
					end
					
					this.SetPosition( cuffedTo.GetPosition().Offset( 1.4, cuffedTo.GetRotation() ) );
					this.SetRotation( cuffedTo.GetRotation() );
					this.SetInterior( cuffedTo.GetInterior() );
					this.SetDimension( cuffedT.GetDimension() );
				end
				
				if not cuffedTo.IsInVehicle() and this.IsInVehicle() then
					this.ForceExitVehicle	= true;
					this.SetControlState( "enter_exit", true );
				end
				
				if this.GetControlState( "enter_exit" ) then
					this.SetControlState( "enter_exit", false );
					this.ForceExitVehicle	= false;
				end
				
				if cuffedTo.IsInVehicle() and this.GetVehicle() ~= cuffedTo.GetVehicle() then
					local vehicle = cuffedTo.GetVehicle();
					
					if vehicle and not vehicle.IsLocked() then
						distance = vehicle.GetPosition().Distance( this.GetPosition() );
						
						if distance < 4 then
							for seat = vehicle.GetMaxPassengers(), 1, -1 do
								if not vehicle.GetOccupant( seat ) then
									this.WarpInVehicle( vehicle, seat );
									
									break;
								end
							end
						end
					end
				end
				
				if not this.IsInVehicle() then
					if distance > 7 or ( isPlayerMoved and cuffedTo.GetControlState( "sprint" ) ) then
						this.SetAnimation( PlayerAnimation.PRIORITY_CUFFS, "PED", "SPRINT_civi" );
					elseif distance > 4 or ( isPlayerMoved and not cuffedTo.GetControlState( "walk" ) ) then
						this.SetAnimation( PlayerAnimation.PRIORITY_CUFFS, "PED", "RUN_player" );
					elseif distance > 1 or ( isPlayerMoved ) then
						this.SetAnimation( PlayerAnimation.PRIORITY_CUFFS, "PED", "WALK_player" );
					else
						this.SetAnimation( PlayerAnimation.PRIORITY_CUFFS, "PED", "IDLE_stance" );
					end
				end
			elseif not this.IsInVehicle() then
				this.SetAnimation( PlayerAnimation.PRIORITY_CUFFS, "PED", "IDLE_stance" );
			end
		end
		
		this.Spectator.Update();
		
		this.GetChar().DoPulse( realTime );
	end;

	Save	= function()
		if this.IsLoggedIn() then
			if not Server.DB.Query( "UPDATE uac_users SET last_logout = NOW() WHERE id = " + this.UserID ) then
				Debug( Server.DB.Error(), 1 );
				
				return false;
			end
		end
		
		return false;
	end;
	
	GetChar	= function()
		return this.Character;
	end;
	
	IsInGame	= function()
		return this.Character ~= NULL;
	end;
	
	HasKey	= function( target )
		local type = typeof( target );
		
		if type == "Vehicle" then
			return this.HasVehicleKey( target );
		elseif type == "Teleport" then
			return this.HasTeleportKey( target );
		elseif type == "Interior" then
			return this.HasInteriorKey( target );
		end
		
		return false;
	end;
	
	HasVehicleKey	= function( target )
		local character = this.GetChar();

		if character ~= NULL then
			if this.IgnoreCarKey then
				return true;
			end
			
			local ownerID = target.GetOwner();
			
			if ownerID == 0 then
				return target.IsRentable() == false;
			elseif ownerID > 0 then
				return ownerID == character.GetID();
			elseif ownerID < 0 then
				local faction = character.GetFaction();

				if faction ~= NULL then
					return faction.GetID() == -ownerID;
				end
			end
		end
		
		return false;
	end;

	HasTeleportKey	= function( target )
		local character = this.GetChar();
		
		if character ~= NULL then
			if target.FactionID == 0 then
				return true;
			end
			
			local faction = character.GetFaction();
			
			if faction ~= NULL then
				return faction.GetID() == target.FactionID;
			end
		end
		
		return false;
	end;

	HasInteriorKey	= function( target )
		local character = this.GetChar();
		
		if character ~= NULL then
			if target.CharacterID > 0 then
				return target.CharacterID == character.GetID();
			elseif target.CharacterID < 0 then
				local faction = character.GetFaction();
				
				if faction then
					return faction.GetID() == -target.CharacterID;
				end
			end

			return target.CharacterID == 0;
		end

		return false;
	end;
	
	Ban	= function( reason, seconds, player )
		return banPlayer( this, false, false, true, typeof( player ) == "Player" and player.GetUserName() or "Server", reason, (int)(seconds) );
	end;

	Kick	= function( reason )
		return kickPlayer( this, reason );
	end;

	Spawn	= function( position, rotation, skin, interior, dimension, team )
		return spawnPlayer( this, position.X, position.Y, position.Z, rotation or 0, skin or 0, interior or 0, dimension or 0, team );
	end;

	SetBlurLevel	= function( blur )
		return setPlayerBlurLevel( this, blur );
	end;

	GetBlurLevel	= function()
		return getPlayerBlurLevel( this );
	end;

	GetIP	= function()
		return getPlayerIP( this );
	end;
	
	GetSerial	= function()
		return getPlayerSerial( this );
	end;
	
	SetName		= function( name )
		return setPlayerName( this, name );
	end;

	SetTeam		= function( team )
		return setPlayerTeam( this, team );
	end;
	
	GetMTAVersion	= function()
		return getPlayerVersion( this );
	end;

	GetIdleTime	= function()
		return getPlayerIdleTime( this );
	end;
	
	ResendModInfo	= function()
		return resendPlayerModInfo( this );
	end;
	
	Redirect	= function( ip, port, password )
		return redirectPlayer( this, ip or "", (int)(port), password );
	end;

	ToggleControls	= function( enabled, gta, mta )
		return toggleAllControls( this, enabled, gta, mta );
	end;
	
	DisableControls	= function( ... )
		for _, control in ipairs( { ... } ) do
			this.Controls[ control ] = false;
			
			toggleControl( this, control, false );
		end
		
		this.SetData( "Player::Controls", this.Controls );
	end;
	
	EnableControls	= function( ... )
		for _, control in ipairs( { ... } ) do
			this.Controls[ control ] = true;
			
			toggleControl( this, control, true );
		end
		
		this.SetData( "Player::Controls", this.Controls );
	end;

	SetControlState	= function( control, state )
		this.ControlStates[ control ] = state;
		
		this.SetData( "Player::ControlStates", this.ControlStates );
	
		return setControlState( this, control, state );
	end;

	GetControlState	= function( control )
		return getControlState( this, control );
	end;

	BindKey	= function( key, state, func, ... )
		return bindKey( this, key, state, func, ... );
	end;

	UnbindKey	= function( key, state, func )
		return unbindKey( this, key, state, func );
	end;

	IsKeyBound	= function( key, state, func )
		return isKeyBound( this, key, state, func );
	end;

	PlaySoundFrontEnd	= function( sound )
		return playSoundFrontEnd( this, sound );
	end;
	
	SetMuted	= function( time )
		time = (int)(time);
		
		this.MuteSeconds = time > 0 and time * 60 or NULL;
		
		if this.IsLoggedIn() then
			return Server.DB.Query( "UPDATE uac_users SET muted_time = " + ( this.MuteSeconds or "NULL" ) + " WHERE id = " + this.GetUserID() ) or not Debug( Server.DB.Error(), 1 );
		end
		
		return false;
	end;

	Gender	= function( male, female, unknown )
		local skin = this.GetSkin();
		
		local gender = skin.GetGender();
		
		if gender == "male" then
			return male;
		elseif gender == "female" then
			return female;
		end
		
		return unknown or male;
	end;
	
	Hint	= function( ... )
		return this.RPC.Hint( ... );
	end;
	
	SetDimension	= function( dimension )
		for k, element in pairs( this.GetChilds() ) do
			element.SetDimension( dimension );
		end

		return setElementDimension( this, dimension );
	end;
	
	TakeScreenShot	= function( width, height, tag, quality, maxBandwith )
		return takePlayerScreenShot( this, width, height, tag or "", quality or 30, maxBandwith or 5000 );
	end;
	
	PlaySound3D	= function( ... )
		return triggerClientEvent( "Player::PlaySound3D", this, ... );
	end;
	
	HaveAccess	= function( access )
		if this.IsLoggedIn() then
			if this.UserID == 0 then
				return true;
			end
			
			for k, group in pairs( this.Groups ) do
				if group.GetID() == 0 or group.GetRight( access ) then
					return true;
				end
			end
		end
		
		return false;
	end;

	SetAdminDuty	= function( adminDuty )
		if not this.HaveAccess( "command.adminduty" ) then
			adminDuty = false;
		end

		this.IsAdmin = adminDuty;

		this.SetData( "Player::IsAdmin", this.IsAdmin );
		
		this.Nametag.SetColor( this.IsAdmin and this.Groups[ 1 ].GetColor() or new. Color( 255, 255, 255 ) );

		this.Nametag.Update();

		if this.IsAdmin then
			this.SetModel( 0 );
	
			this.AddClothes( "suit2grn", "suit2", 0 );
			this.AddClothes( "suit1trblk", "suit1tr", 2 );
			this.AddClothes( "shoedressblk", "shoe", 3 );
			this.AddClothes( "glasses05dark", "glasses03", 15 );
		elseif this.IsInGame() then
			this.SetModel( this.Character.SkinID );
		else
			this.SetModel( 0 );
		end
	end;

	LoadCharacters	= function( userID, forceList )
		local result = Server.DB.Query( "SELECT id, name, surname, DATE_FORMAT( last_login, '%d.%m.%Y %H:%i:%s' ) AS last_login, DATE_FORMAT( created, '%d.%m.%Y %H:%i:%s' ) AS created, status FROM " + Server.DB.Prefix + "characters WHERE user_id = " + userID + " AND status != 'Скрыт' ORDER BY last_login DESC" );

		if result ~= NULL then
			local characters = result.GetArray();
			
			result.Free();
			
			local characterCount	= 0;
			
			for i, character in ipairs( characters ) do
				if character[ "status" ] ~= "Скрыт" then
					characterCount = characterCount + 1;
				end
				
				if character[ "last_login" ] == "00.00.0000 00:00:00" then
					character[ "last_login" ] = "Никогда";
				end
			end
			
			if characterCount == 0 then
				this.RPC.UI.CharacterCreate.Show( { cancelable = false } );
			elseif characterCount == 1 and Server.Game.CharactersLimit == 1 and not forceList then
				this.LoginCharacter( characters[ 1 ].id );
			else
				this.RPC.UI.CharacterList.Show( { canCreate = Server.Game.CharactersLimit == 0 or characterCount < Server.Game.CharactersLimit }, { characters = characters } );
			end
		else
			Debug( Server.DB.Error(), 1 );
		end
	end;
	
	LoginCharacter	= function( characterID )
		if this.IsInGame() then
			Debug( this.GetName() + " arealy in game", 2 );
			
			return false;
		end
		
		for _, p in pairs( Server.Game.PlayerManager.GetAll() ) do
			if p.IsInGame() and p.GetID() == characterID then
				Debug( "This character arealy in game", 2 );
				
				return false;
			end
		end
		
		local result = Server.DB.Query( "SELECT *, \
			DATE_FORMAT( created, '%%d/%%m/%%Y %%h:%%i:%%s' ) AS created, \
			DATE_FORMAT( last_login, '%%d/%%m/%%Y %%h:%%i:%%s' ) AS last_login, \
			DATE_FORMAT( date_of_birdth, '%%d/%%m/%%Y' ) AS date_of_birdth, \
			UNIX_TIMESTAMP( c.last_logout ) AS last_logout_t FROM " + Server.DB.Prefix + "characters c\
			WHERE c.id = %d AND c.status = 'Активен'", characterID );
			
		if not result then
			Debug( Server.DB.Error(), 1 );
			
			return false;
		end
		
		local row = result.GetRow();
		
		delete ( result );
		
		if row then
			local character		= new. Character( this, row );
			
			this.Character 		= character;
			this.InGameCount	= 0;
			
			this.SetName( character.GetName():gsub( " ", "_" ) );
			this.SetTeam( Server.Game.PlayerManager.TeamLoggedIn );
			this.SetData( "Player::Level", character.Level );
			
			this.Nametag.Update();
			
			this.Camera.Fade( false );
			
			setTimer(
				function()
					this.SetAlpha( 255 );
					this.SetCollisionsEnabled( true );
					
					character.Spawn( new. Vector3( row.position ), row.rotation, row.interior, row.dimension );
					character.SetHealth( row.health );
					character.SetArmor( row.armor );

					Server.Game.ItemsManager.Load( character );

					this.HUD.Show();
					this.HUD.ShowComponents( "crosshair" );
					this.Chat.Show();
					this.Nametag.Show();
				end,
				1000, 1
			);
			
			if not Server.DB.Query( "UPDATE " + Server.DB.Prefix + "characters SET last_login = NOW() WHERE id = '" + characterID + "'" ) then
				Debug( Server.DB.Error(), 1 ); 
			end
			
		--	this.RPC.OnCharacterLogin( character.GetID(), character.Name, character.Surname );
			
			return true;
		end
		
		return false;
	end;
	
	SaveSettings	= function()
		if not Server.DB.Query( "UPDATE uac_users SET settings = '" + toJSON( this.Settings ) + "' WHERE id = " + this.UserID ) then
			Debug( Server.DB.Error(), 1 );
			
			return false;
		end
		
		return true;
	end;
	
	Respawn	= function()
		if this.IsDead() then
			this.Camera.Fade( false );
			
			setTimer( function() this.PrepareSpawn(); end, 1000, 1 );
		end
	end;
	
	PrepareSpawn	= function()
		local char = this.Character;
		
		if char then
			if char.Jailed ~= "No" then
				char.SetJailed( char.Jailed, char.JailedTime );
			else
				local spawned = false;
				
				if this.GetPosition().Distance( PlayerManager.PRISON_RESPAWN ) < 2000.0 then
					char.Spawn( PlayerManager.PRISON_RESPAWN, 0.0, 0, 0 );
					
					spawned = true;
				end
				
				if not spawned then
					char.Spawn( PlayerManager.HOSPITAL_RESPAWN, 130.0, 0, 0 );
				end
			end
			
			if char.Alcohol > 0.0 then
				char.SetAlcohol();
			end
		end
	end;
	
	-- Events
	
	OnSpawn	= function( position, rotation, interior, dimension )
		this.TakeAllWeapons();
		
		if this.IsInGame() then
			this.SetControlState( "walk", true );
			this.SetWalkingStyle( (int)(this.Character.Skin.GetWalkingStyle()) );
			
			this.SetAnimation();
			
			this.Character.SetPower( 100.0 );
			this.Character.SetCuffed();
			
			this.Camera.SetInterior( interior );			
			this.Camera.Fade( true );
			this.Camera.SetTarget();
			
			setTimer(
				function()
					this.Camera.SetTarget();
				end,
				100,
				1
			);
		else
			this.SetWalkingStyle( 0 );
		end
		
		this.SetAdminDuty( this.IsAdmin );
	end;
	
	OnWasted	= function( totalAmmo, killer, killerWeapon, bodypart, stealth )
		local char = this.Character;
		
		if char then
			this.LowHPAnim = false;
			
			if this.Vehicle then
				this.Vehicle.OnExit( this, this.GetVehicleSeat() );
			end
			
			this.Respawn();
			
			-- this.RPC.OnClientWasted( totalAmmo, killer, killerWeapon, bodypart, stealth );
		end
	end;
	
	OnModelChange	= function( prevSkinID, skinID )
		local skin = new. CharacterSkin( skinID );
		
		local style = (int)(skin.GetWalkingStyle());
		
		this.SetWalkingStyle( style );
	end;
	
	OnRadialMenu	= function( option, ... )
		if not this.IsInGame() then
			return;
		end
		
		local args = { ... };
		
		Debug( option );
		
		if option == "Settings" then
			return;
		end
		
		if option == "PlayerHello" then
			return;
		end
		
		if option == "PlayerKiss" then
			return;
		end
		
		if option == "PlayerPropose" then
			return;
		end
		
		if option == "PlayerToggleCuffed" then
			return;
		end
		
		if option == "PlayerHeal" then
			return;
		end
		
		if option == "NPCInteractive" then
			return;
		end
		
		if option == "InteriorMenu" then
			return;
		end
		
		Debug( "Invalid option '" + (string)(option) + "' for Radial Menu", 2 );
	end;
	
	-- Key handlers
	
	static
	{
		ToggleClientConsole	= function( player )
			triggerClientEvent( player, "ToggleClientConsole", player );
		end;
		
		KeySprint			= function( player, key, state )
			player.SetControlState( "walk", state == "up" );
		end;
		
		KeyVehicleHorn		= function( player, key, state )
			local vehicle = player.GetVehicle();
			
			if vehicle and player.GetVehicleSeat() == 0 then
				vehicle.Horn( state == "down" );
			end
		end;
		
		KeyVehicleToggleEngine	= function( player )
		
		end;
		
		KeyVehicleToggleLocked	= function( player )
			
		end;
		
		KeyVehicleToggleLights	= function( player )
			
		end;
	};
};
