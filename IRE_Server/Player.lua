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
							triggerClientEvent( this, Server.RPC.Server2ClientName, this, namespace, ... );
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
	AutoLogin			= false;
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
		
		this.RemoveData( "player_id" );
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
	
	ShowLoginScreen = function()
		this.InitLoginCamera();
		
		local result = Server.DB.Query( "SELECT `login`, `password` FROM `uac_users` WHERE `autologin` = '%d' LIMIT 1", this.GetSerial() );
		
		if result then
			local row = result.FetchRow();
			
			result.Free();
			
			if row then
				this.Client.ShowLoginScreen( true, false, row[ "login" ] );
				
				return;
			end
		end
		
		this.Client.ShowLoginScreen( true );
	end;

	InitLoginCamera = function()
		if this.IsInVehicle() then
			this.RemoveFromVehicle();
		end

		this.RemoveData( "player_level" );

		this.HUD.HideComponents( "all" );
		this.Chat.Hide();

		this.Spawn( PlayerManager.DEFAULT_SPAWN_POSITION, 0, 0, 0, 0, Server.Game.PlayerManager.TeamNotLoggedIn );
		this.SetName( "not_logged_in_" + this.GetID() );

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
			local row = result.FetchRow();
	
			result.Free();

			if row ~= NULL then
				local serial	= this.GetSerial();
				local ip		= this.GetIP();

				this.LoginHistory = row[ "login_history" ] and row[ "login_history" ]:split( '\n' ) or {};
				
				table.insert( this.LoginHistory, getRealTime().timestamp + "|" + ip + "|" + serial );
				
				while( table.getn( this.LoginHistory ) > 32 ) do
					table.remove( this.LoginHistory, 1 );
				end
				
				local sUpdateQuery = "UPDATE `uac_users` SET \
					`login_history` = '" + table.concat( this.LoginHistory, '\n' ) + "',\
					`serial` = '" + serial + "', `ip` = '" + ip + "',\
					`last_login` = NOW(),\
					`activation_code` = NULL,\
					`autologin` = " + ( this.AutoLogin and ( "'" + serial + "'" ) or "NULL" ) + "\
				WHERE `id` = " + UserID;

				if Server.DB.Query( updateQuery ) then
					Debug( Server.DB.Error(), 1 );
				end
				
				this.UserID					= UserID;
				this.UserName				= row[ "name" ];
				
				this.AdminID				= row[ "admin_id" ];
				this.IsAdmin				= row[ "adminduty" ] == "Yes";
				
				this.InitGroups( row[ "groups" ] );
				
				this.MuteSeconds			= row[ "muted_time" ];
				this.ReportData.Locked		= row[ "report_locked" ] == "Yes";

				local lastLogin = "";

				if row[ "last_login_f" ] ~= "00 00 0000 г. 00:00" then
					if row[ "last_login_d" ] == 0 then
						lastLogin = "Сегодня в " + row[ "last_login_f" ]:split( ' ' )[ 4 ];
					elseif row[ "last_login_d" ] == 1 then
						lastLogin = "Вчера в " + row[ "last_login_f" ]:split( ' ' )[ 4 ];
					else
						lastLogin = row[ "last_login_f" ];
					end
				end
				
				if lastLogin ~= "" then
					this.Chat.Send( string.format( "Приветствуем Вас %s, последний раз Вы были тут %s (%s)", this.UserName, lastLogin, row[ "ip" ] ), 0, 255, 0 );
				end
		
				this.GP = row[ "goldpoints" ];

				this.Client.Settings.Load( not row[ "settings" ] and row[ "settings" ] or "" );
		
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
					groups = result.FetchRow()[ "groups" ];
					
					result.Free();
				else
					Debug( Server.DB.Error(), 1 );
					
					return false;
				end
			end

			local Groups = {};

			this.Groups = {};

			if groups ~= NULL then
				for i, groupID in groups:split( ',' ) do
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
						this.AdminID = result.FetchRow()[ "admin_id"];

						result.Free();
					else
						Debug( Server.DB.Error(), 1 );
					end
				end

				if this.AdminID == 0 then
					this.AdminID = math.random( 9000, 9999 );
				end

				this.UnbindKey( "F4", "up", "chatbox", "adminchat" );
				
				if this.HaveAccess( "command.adminchat" ) then
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

		local power = this.GetData( "Char::Power" );

		this.Character.Power = power;
		
		if not this.LowHPAnim and not this.IsCuffed() then
			if power <= 0 then
				this.SetAnimation( PlayerAnimation.PRIORITY_TIRED, "FAT", "IDLE_tired", 10000, true, false, false, false );
			end
		end

		if this.GetArmor() > 0 and not this.GetSkin().HaveArmor() then
			this.SetArmor( 0 );
		end
		
		this.UpdateCuff();
		this.UpdateJail();
		this.UpdateSpectate();
	
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
		return banPlayer( this, false, false, true, typeof( player ) == "Player" and player.GetUserName() or "Server", Reason, (int)(Seconds) )
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
		return toggleAllControls( enabled, gta, mta );
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
		if type( func ) == "function" then
			local Function = this.Binds[ func ];
			
			if Function == NULL then
				function Function( player, key, state, ... )
					return func( this, key, state, ... );
				end
			end
			
			this.Binds[ func ] = Function;
			
			return bindKey( this, key, state, Function, ... );
		else
			return bindKey( this, key, state, func, ... );
		end
		
		return false;
	end;

	UnbindKey	= function( key, state, func )
		if type( func ) == "function" and this.Binds then
			func = this.Binds[ func ] or func;
		end
		
		if unbindKey( this, key, state, func ) then
			this.Binds[ func ] = nil;
			
			return true;
		end
		
		return false;
	end;

	IsKeyBound	= function( key, state, func )
		if type( func ) == "function" then
			func = this.Binds[ func ] or func;
		end
		
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

		this.SetData( "Player::IsAdmin", 		this.IsAdmin );
		
		this.Nametag.SetColor( this.IsAdmin and this.Groups[ 0 ].GetColor() );

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

	LoadCharacters	= function( userID )
		local result = Server.DB.Query( "SELECT name, surname, DATE_FORMAT( last_login, '%d/%m/%Y %H:%i:%s' ) AS last_login, DATE_FORMAT( created, '%d/%m/%Y %H:%i:%s' ) AS created, status FROM " + Server.DB.Prefix + "characters WHERE user_id = " + userID + " AND status != 'Скрыт' ORDER BY last_login DESC" );

		if result ~= NULL then
			local characters = result.GetArray();
			
			result.Free();
			
			local characterCount	= 0;
			
			for i, character in ipairs( characters ) do
				if character[ "status" ] ~= "Скрыт" then
					characterCount = characterCount + 1;
				end
			end
			
			if characterCount == 0 then
				this.RPC.SelectCharacter( "NEW", characterCount == 0 );
			elseif characterCount == 1 and Game.CharactersLimit == 1 then
				this.RPC.SelectCharacter( characters[ 0 ][ "name" ], characters[ 0 ][ "surname" ] );
			else
				this.RPC.CUICharacterSelect( characters, Game.CharactersLimit == 0 or characterCount < Game.CharactersLimit );

				this.Characters = characters;
			end
		else
			Debug( Server.DB.Error(), 1 );
		end
	end;
	
	SaveSettings	= function()
		if not Server.DB.Query( "UPDATE uac_users SET settings = '" + toJSON( this.Settings ) + "' WHERE id = " + this.UserID ) then
			Debug( Server.DB.Error(), 1 );
			
			return false;
		end
		
		return true;
	end;
}
