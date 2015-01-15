-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. PlayerManager : Manager
{
	static
	{
		DEFAULT_SPAWN_POSITION		= new. Vector3( 1586.0, -1827.0, 0.0 );
		DEFAULT_CAMERA_POSITION		= new. Vector3( 1586.31, -1827.22, 84.12 );
		DEFAULT_CAMERA_TARGET		= new. Vector3( 1585.96, 0.0, 84.12 );
		
		NEW_CHAR_CAMERA_POSITION	= new. Vector3( 1714.2, -1670.7, 42.9 );
		NEW_CHAR_CAMERA_TARGET		= new. Vector3( 1628.2, -1719.5, 28.4 );
		
		HOSPITAL_RESPAWN			= new. Vector3( 2035.477, -1413.835, 16.99 );
		PRISON_RESPAWN				= new. Vector3( 2262.488, -4783.914, 8.62 );
		
		AntiFloodCommands =
		{
			-- hardcoded
			say			= true;
			teamsay		= true;
			me			= true;
			--
			GlobalOOC	= true;
			o			= true;
			LocalOOC	= true;
			b			= true;
			c			= true;
			shout		= true;
			s			= true;
			whisper		= true;
			w			= true;
			try			= true;
			['do']		= true;
			dice		= true;
			coin		= true;
			-- phone
			p			= true;
			sms			= true;
			-- adm
			adminchat	= false;
			a			= false;
			pm			= false;
		};
	};

	TeamLoggedIn	= NULL;
	TeamNotLoggedIn	= NULL;

	PlayerManager	= function()
		this.Manager();
		
		Server.DB.CreateTable( Server.DB.Prefix + "characters",
			{
				{ Field = "id",					Type = "int(11) unsigned",					Null = "NO",	Key = "PRI", 		Default = NULL,	Extra = "auto_increment" };
				{ Field = "user_id",			Type = "int(11)",							Null = "NO",	Key = "",			Default = NULL,	};
				{ Field = "spawn_id",			Type = "smallint(4)",						Null = "YES",	Key = "",			Default = NULL,	};
				{ Field = "faction_id",			Type = "int(5) unsigned",					Null = "NO",	Key = "",			Default = 0,	};
				{ Field = "faction_dept_id",	Type = "smallint(5) unsigned",				Null = "NO",	Key = "",			Default = 0,	};
				{ Field = "faction_rank_id",	Type = "smallint(5) unsigned",				Null = "NO",	Key = "",			Default = 0,	};
				{ Field = "faction_rights",		Type = "varchar(8)",						Null = "NO",	Key = "",			Default = "0",	};
				{ Field = "level",				Type = "smallint(3)",						Null = "NO",	Key = "",			Default = 1,	};
				{ Field = "level_points",		Type = "int(11)",							Null = "NO",	Key = "",			Default = 0,	};
				{ Field = "name",				Type = "varchar(11)",						Null = "NO",	Key = "",			Default = NULL,	};
				{ Field = "surname",			Type = "varchar(11)",						Null = "NO",	Key = "",			Default = NULL,	};
				{ Field = "created",			Type = "timestamp",							Null = "NO",	Key = "",			Default = "0000-00-00 00:00:00",	};
				{ Field = "last_login",			Type = "timestamp",							Null = "NO",	Key = "",			Default = "0000-00-00 00:00:00",	};
				{ Field = "last_logout",		Type = "timestamp",							Null = "NO",	Key = "",			Default = MySQL.CURRENT_TIMESTAMP,	};
				{ Field = "status",	Type = "enum('Активен','Заблокирован','Убит','Скрыт')",	Null = "NO", 	Key = "",			Default = "Активен",	};
				{ Field = "date_of_birdth",		Type = "datetime",							Null = "NO", 	Key = "",			Default = "0000-00-00 00:00:00",	};
				{ Field = "place_of_birdth",	Type = "varchar(255)",						Null = "NO", 	Key = "",			Default = "Неизвестно",	};
				{ Field = "nation",				Type = "varchar(3)",						Null = "NO", 	Key = "",			Default = "en",	};
				{ Field = "languages",			Type = "text",								Null = "NO", 	Key = "",			Default = NULL,	};
				{ Field = "interior",			Type = "smallint(6)",						Null = "NO", 	Key = "",			Default = 0,	};
				{ Field = "dimension",			Type = "smallint(6)",						Null = "NO", 	Key = "",			Default = 0,	};
				{ Field = "position",			Type = "varchar(255)",						Null = "NO", 	Key = "",			Default = "(0,0,0)",	};
				{ Field = "rotation",			Type = "varchar(255)",						Null = "NO", 	Key = "",			Default = "(0,0,0)",	};
				{ Field = "skin",				Type = "smallint(6)",						Null = "NO", 	Key = "",			Default = 0,	};
				{ Field = "money",				Type = "double",							Null = "NO", 	Key = "",			Default = 1000,	};
				{ Field = "pay",				Type = "int(10) unsigned",					Null = "NO", 	Key = "",			Default = 0,	};
				{ Field = "health",				Type = "float",								Null = "NO", 	Key = "",			Default = 100,	};
				{ Field = "armor",				Type = "float",								Null = "NO", 	Key = "",			Default = 0,	};
				{ Field = "alcohol",			Type = "float",								Null = "NO", 	Key = "",			Default = 0,	};
				{ Field = "power",				Type = "float",								Null = "NO", 	Key = "",			Default = 100,	};
				{ Field = "licenses",			Type = "text",								Null = "NO", 	Key = "",			Default = NULL,	};
				{ Field = "jailed",			Type = "enum('No','Police','FBI','Prison')",	Null = "NO", 	Key = "",			Default = "No",	};
				{ Field = "jailed_time",		Type = "int(11)",							Null = "NO", 	Key = "",			Default = 0,	};
				{ Field = "married",			Type = "varchar(255)",						Null = "YES", 	Key = "",			Default = NULL,	};
				{ Field = "phone",				Type = "int(11)",							Null = "YES", 	Key = "UNI",		Default = NULL,	};
				{ Field = "events",				Type = "text",								Null = "YES", 	Key = "",			Default = NULL,	};
			}
		);
		
		this.TeamLoggedIn		= new. Team( "Players", new. Color( 255, 255, 255 ) );
		this.TeamNotLoggedIn	= new. Team( "Not logged in", new. Color( 120, 120, 120 ) );

		root.OnPlayerJoin.Add( this.PlayerJoin );
		root.OnPlayerQuit.Add( this.PlayerQuit );
		root.OnPlayerChangeNick.Add( this.PlayerChangeNick );
		root.OnPlayerDamage.Add( this.PlayerHit );
		root.OnPlayerCommand.Add( this.PlayerCommand );
		root.OnPlayerChat.Add( this.PlayerChat );
		root.OnPlayerPrivateMessage.Add( this.PlayerPrivateMessage );
if _DEBUG then
		root.OnPlayerModInfo.Add( this.PlayerModInfo );
end
		root.OnPlayerSpawn.Add( this.PlayerSpawn );
		root.OnPlayerWasted.Add( this.PlayerWasted );
		root.OnElementModelChange.Add( this.PlayerModelChange );
	end;

	_PlayerManager	= function()
		root.OnPlayerJoin.Remove( this.PlayerJoin );
		root.OnPlayerQuit.Remove( this.PlayerQuit );
		root.OnPlayerChangeNick.Remove( this.PlayerChangeNick );
		root.OnPlayerDamage.Remove( this.PlayerHit );
		root.OnPlayerCommand.Remove( this.PlayerCommand );
		root.OnPlayerChat.Remove( this.PlayerChat );
		root.OnPlayerPrivateMessage.Remove( this.PlayerPrivateMessage );
if _DEBUG then
		root.OnPlayerModInfo.Remove( this.PlayerModInfo );
end
		root.OnPlayerSpawn.Remove( this.PlayerSpawn );
		root.OnPlayerWasted.Remove( this.PlayerWasted );
		root.OnElementModelChange.Remove( this.PlayerModelChange );
		
		this.DeleteAll();
	end;

	Init	= function()
		for _, player in pairs( getElementsByType( "player" ) ) do
			this.PlayerJoin( player );
		end
		
		return true;
	end;

	DoPulse	= function( realTime )
		for ID, player in pairs( this.GetAll() ) do
			player.DoPulse( realTime );
		end
	end;

	Create	= function( playerEntity )
		local player = new. Player( playerEntity );
		
		if player.GetID() == 0 then
			delete ( player );
			
			return NULL;
		end
		
		player.SetTeam( this.TeamNotLoggedIn );
		
		return player;
	end;

	Unlink	= function( player, type, reason, responsePlayerEntity )
		player.Unlink( type, reason, responsePlayer );
	end;

	GetByCharID	= function( charID )
		for ID, player in pairs( this.GetAll() ) do
			if player.IsInGame() and player.Character.GetID() == charID then
				return player;
			end
		end

		return NULL;
	end;

	AddToList	= function( player )
		local ID = 0;

		for key in ipairs( this.m_List ) do
			ID = key;
		end

		player.ID = ID + 1;

		this.m_List[ player.ID ] = player;
	end;

	RemoveFromList	= function( player )
		this.m_List[ player.GetID() ]	= NULL;
		
		delete ( player );
		
		player = NULL;	
	end;

	Get	= function( vArg1, bCaseSensitive )
		if tonumber( vArg1 ) then
			return this.m_List[ tonumber( vArg1 ) ];
		elseif type( vArg1 ) == "string" then
			local sName = vArg1:gsub( " ", "_" );
			
			bCaseSensitive = bCaseSensitive == NULL or false;
			
			if not bCaseSensitive then
				sName = sName:lower();
			end
			
			for i, p in pairs( this.m_List ) do
				if bCaseSensitive and p.GetName():find( sName ) or p.GetName():lower():find( sName ) then
					return p;
				end
			end
		end
		
		return NULL;
	end;

	DeleteAll	= function()
		local tick	= getTickCount();
		local count	= 0;
		
		for i, player in pairs( this.GetAll() ) do
			player.Unlink();

			count = count + 1;
		end
		
		if _DEBUG then
			Debug( string.format( "All players (%d) saved (%d ms)", count, getTickCount() - tick ) );
		end
	end;
	
	ClientHandle	= function( player, command, data, ... )
		if command == "Ready" then
			player.ShowLoginScreen();
			
			player.ToggleControls( true, true, false );
			player.DisableControls( "next_weapon", "previous_weapon", "action", "walk", "fire", "horn", "radio_next", "radio_previous", "vehicle_left", "vehicle_right" );
			
			player.BindKey( "horn", "both", player.KeyVehicleHorn );
			player.BindKey( "j", "up", player.KeyVehicleToggleEngine );
			player.BindKey( "k", "up", player.KeyVehicleToggleLocked );
			player.BindKey( "l", "up", player.KeyVehicleToggleLights );
			
			player.BindKey( "sprint", "both", player.KeySprint );
			
			return true;
		end
		
		if command == "SignIn" then
			if data then
				if data.login == NULL or data.login:len() == 0 then
					return "Введите логин";
				end
				
				if data.password == NULL or data.password:len() == 0 then
					return "Введите пароль";
				end
				
				local query = "SELECT u.id, u.activation_code, u.ban, u.ban_reason, uu.name AS ban_user_name, DATE_FORMAT( u.ban_date, '%d/%m/%Y %h:%i:%s' ) AS ban_date \
					FROM uac_users u \
					LEFT JOIN uac_users uu ON uu.id = u.ban_user_id \
					WHERE \
						u.login = '" + Server.DB.EscapeString( data.login ) + "' \
					AND u.password = '" + Server.Blowfish.Encrypt( data.password ) + "' \
					AND u.deleted = 'No' ";
				
				local result = Server.DB.Query( query );
				
				if not result then
					Debug( Server.DB.Error(), 1 );
					
					return TEXT_DB_ERROR;
				end
				
				local row = result.GetRow();
				
				delete ( result );
				
				if not row or not row.id then
					player.LoginAttempt = ( player.LoginAttempt or 0 ) + 1;
					
					if player.LoginAttempt > 3 then
						player.Ban( "Попытка взлома (подбор пароля)", 1440 );
						
						return;
					end
					
					return "Неверный логин или пароль";
				end
				
				player.LoginAttempt = NULL;
				
				if row.activation_code then
					return "Учётная запись не активирована";
				end
				
				if row.ban == "Yes" then
					local reason	= row.ban_reason and " (" + row.ban_reason + ")" or "";
					local admin		= row.ban_user_name and ( "администратором " + row.ban_user_name ) or "";
					
					return "Ваша учётная запись заблокирована " + admin + reason;
				end
				
				for _, plr in pairs( this.GetAll() ) do
					if plr.UserID == row.id then
						return "Другой игрок в настоящее время находится под этой учётной записью";
					end
				end
				
				player.AutoLogin	= data.rememberMe == true;
				
				setTimer( function() player.Login( row.id ); end, 1000, 1 );
				
				return -1;
			end
			
			return "Ошибка авторизации";
		end
		
		if command == "SignUp" then
			if not data then
				return ClientRPC.BAD_REQUEST;
			end
			
			local email		= (string)(data.login);
			local password	= (string)(data.password);
			local nickname	= (string)(data.nick);
			local referUser	= (string)(data.refer);
			
			if email:len() == 0					then	return TEXT_REG_EMAIL_IS_BLANK;		end
			if email:len() < 3					then	return TEXT_REG_EMAIL_IS_SHORT;		end
			if email:len() > 64					then	return TEXT_REG_EMAIL_IS_LONG;		end
			if not email:match( "^[%w+%.%-_]+@[%w+%.%-_]+%.%a%a+$" ) then return TEXT_REG_EMAIL_IS_INVALID;	end
			
			if password:len() == 0		then	return TEXT_REG_PASSWORD_IS_BLANK;	end
			if password:len() < 4		then	return TEXT_REG_PASSWORD_IS_SHORT;	end
			if password:len() > 64		then	return TEXT_REG_PASSWORD_IS_LONG;	end
			
			if nickname:len() == 0		then	return TEXT_REG_NICKNAME_IS_BLANK;	end
			if nickname:len() < 3		then	return TEXT_REG_NICKNAME_IS_SHORT;	end
			if nickname:len() > 64		then	return TEXT_REG_NICKNAME_IS_LONG;	end
			if tonumber( nickname ) 	then	return TEXT_REG_NICKNAME_IS_NUMBER;	end
			
			if not not nickname:find( "[^A-Za-z0-9]" ) then
				return TEXT_REG_NICKNAME_IS_INVALID;
			end
			
			local referID = 0;
			
			if referUser and referUser:len() > 0 then
				if referUser:len() > 64 then
					referUser = referUser:sub( 1, 64 );
				end
				
				if not referUser:find( "[^A-Za-z0-9]" ) then
					local result = Server.DB.Query( "SELECT id FROM uac_users WHERE LOWER( name ) = LOWER( %q )", referUser );
					
					if not result then
						Debug( Server.DB.Error(), 1 );
						
						return TEXT_DB_ERROR;
					end
					
					local numRows	= result.NumRows();
					local row		= result.GetRow();
					
					delete ( result );
					
					if numRows ~= 1 then
						return TEXT_REG_REFER_NOT_FOUND;
					end
					
					referID = row and (int)(row.id) or 0;
				else
					return TEXT_REG_REFER_IS_INVALID;
				end
			end
			
			local serial = player.GetSerial();
			
			local result = Server.DB.Query( "SELECT \
				SUM( login = %q ) AS mail, \
				SUM( name = %q ) AS name, \
				SUM( serial = %q OR serial_reg = %q ) AS serial \
				FROM uac_users",
				email, nickname, serial, serial
			);
			
			if not result then
				Debug( Server.DB.Error(), 1 );
				
				return TEXT_DB_ERROR;
			end
			
			local row = result.GetRow();
			
			delete ( result );
			
			if row.mail > 0 	then	return TEXT_REG_EMAIL_IN_USE;		end
			if row.name > 0 	then	return TEXT_REG_NICKNAME_IN_USE;	end
			
			if not Server.Game.AllowMultiaccount then
				if row.serial > 0 then	return TEXT_REG_MULTIACCOUNT;	end
			end
			
			-- local activationCode = md5( md5( math.random( 0, 999999999 ) ) + md5( getRealTime().timestamp ) );
			
			local ID = Server.DB.Insert( "uac_users",
				{
					refer_id		= referID;
					login			= email:lower();
					password		= Server.Blowfish.Encrypt( password );
					name			= nickname;
					serial_reg		= serial;
					ip_reg			= player.GetIP();
				--	activation_code	= activationCode;
				}
			);
			
			if ID then
				Console.Log( "Registered new account %q (%q) (ID: %d, Serial: %s, IP: %s)", nickname, email, ID, serial, player.GetIP() );
				
				player.RPC.UI.LoginScreen.Show( { intro_text = TEXT_REG_SUCCESS } );
				
				return -1;
			end
			
			Debug( Server.DB.Error(), 1 );
			
			return TEXT_DB_ERROR;
		end
		
		if command == "DoLogin" then
			if not player.IsLoggedIn() then
				player.ShowLoginScreen();
			end
			
			return -1
		end
		
		if command == "DoRegister" then
			if not player.IsLoggedIn() then
				player.RPC.UI.Registration.Show();
			end
			
			return -1;
		end
		
		if command == "Character::Login" then
			if not player.IsLoggedIn() then
				return ClientRPC.UNAUTHORIZED;
			end
			
			if data then
				local characterID = (int)(data.characters);
				
				if characterID > 0 then
					if player.IsInGame() then
						Debug( player.GetName() + " arealy in game", 2 );
						
						return true;
					end
					
					for _, p in pairs( this.GetAll() ) do
						if p.IsInGame() and p.GetID() == characterID then
							Debug( "This character arealy in game", 2 );
							
							return "Этот персонаж уже в игре";
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
						
						return TEXT_DB_ERROR;
					end
					
					local row = result.GetRow();
			
					delete ( result );
					
					if row then
						local character		= new. Character( player, row );
						
						player.Character 	= character;
						player.InGameCount	= 0;
						
						player.SetName( character.GetName():gsub( " ", "_" ) );
						player.SetTeam( this.TeamLoggedIn );
						player.SetData( "Player::Level", character.Level );
						
						player.Nametag.Update();
						
						player.Camera.Fade( false );
						
						setTimer(
							function()
								player.SetAlpha( 255 );
								player.SetCollisionsEnabled( true );
								
								character.Spawn( new. Vector3( row.position ), row.rotation, row.interior, row.dimension );
								character.SetHealth( row.health );
								character.SetArmor( row.armor );
								
								player.HUD.Show();
								player.HUD.ShowComponents( "crosshair" );
								player.Chat.Show();
								player.Nametag.Show();
								
								player.Camera.SetInterior( interior );
								player.Camera.SetTarget();
								player.Camera.Fade( true );
							end,
							1000, 1
						);
						
						if not Server.DB.Query( "UPDATE " + Server.DB.Prefix + "characters SET last_login = NOW() WHERE id = '" + characterID + "'" ) then
							Debug( Server.DB.Error(), 1 ); 
						end
						
					--	player.RPC.OnCharacterLogin( character.GetID(), character.Name, character.Surname );
						
						return -1;
					end
				end
			end
			
			return ClientRPC.BAD_REQUEST;
		end
		
		return false;
	end;
	
	-- Events
	
	PlayerJoin	= function( sender, e )
		this.Create( sender );
	end;

	PlayerQuit	= function( sender, e, type, reason, responsePlayer )
		this.Unlink( sender, type, reason, responsePlayer );
	end;

	PlayerChangeNick	= function( sender, e, oldName, newName )
		e.Cancel();
	end;

	PlayerModInfo	= function( sender, e, file, List )
		Debug( "ModInfo: " + sender.GetName() + " - " + file );
		
		for i, mod in ipairs( List ) do
			Debug( (string)(mod.id) + ": " + (string)(mod.name) + " (" + (string)(mod.hash) + ")" );
		end
	end;
	
	PlayerHit	= function( sender, e, attacker, weaponID, bodypart, loss )
		if bodypart == 9 then
			if sender.GetArmor() <= 0 then
				sender.Kill( attacker, weaponID, 9 );
			end
		end
	end;
	
	PlayerCommand	= function( sender, e, cmd )
		if not PlayerManager.AntiFloodCommands[ cmd ] then
			return;
		end
		
		if sender.IsMuted() then
			sender.Chat.Send( "Вы лишены права пользоваться чатом. Осталось: " + sender.GetMuted() + " секунд", 255, 128, 0 );
			
			e.Cancel();
			
			return;
		end
		
		sender.Antiflood = ( sender.Antiflood or 0 ) + 1;
		
		if sender.Antiflood > 10 then
			sender.SetMuted( 10 * 60 );
			
			sender.Chat.Send( "Вы лишены права пользоваться чатом на 10 минут!", 255, 0, 0 );
		elseif sender.Antiflood > 5 then
			sender.GetChat.Send( "Прекратите флудить, иначе Вы будете лишены права пользоваться чатом!", 255, 0, 0 );
		end
	end;
	
	PlayerChat	= function( sender, e, ... )
		e.Cancel();
		
		sender.Chat.OnChat( ... );
	end;
	
	PlayerPrivateMessage	= function( sender, e )
		e.Cancel();
	end;
	
	PlayerSpawn		= function( sender, e, posX, posY, posZ, rotation, team, skinID, interior, dimension )
		sender.OnSpawn( new. Vector3( posX, posY, posZ ), rotation, interior, dimension );
	end;
	
	PlayerWasted	= function( sender, e, totalAmmo, killer, killerWeapon, bodypart, stealth )
		sender.OnWasted( totalAmmo, killer, killerWeapon, bodypart, stealth );
	end;
	
	PlayerModelChange	= function( sender, e, prevSkinID, skinID )
		if getElementType( sender ) == "player" then
			sender.OnModelChange( prevSkinID, skinID );
		end
	end;
	
	---
}
