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
		
		NEW_CHAR_POSITION			= new. Vector3( 1642.18, -2238.65, 13.5 );
		NEW_CHAR_ANGLE				= 180.0;
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
				{ Field = "rotation",			Type = "float",								Null = "NO", 	Key = "",			Default = "0",	};
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
		
		addEvent( "onPlayerRadialMenu", true );
		
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
		root.OnPlayerRadialMenu.Add( this.PlayerRadialMenu );
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
		root.OnPlayerRadialMenu.Remove( this.PlayerRadialMenu );
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
				
				result.Free();
				
				if not row or not row.id then
					player.LoginAttempts = ( player.LoginAttempts or 0 ) + 1;
					
					if player.LoginAttempts > 3 then
						player.Ban( "Попытка взлома (подбор пароля)", 1440 );
						
						return;
					end
					
					return "Неверный логин или пароль";
				end
				
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
				
				if data.rememberMe then
					local query	=
					{
						id			= row.id;
						serial		= player.GetSerial();
						password	= Server.Blowfish.Encrypt( data.password );
					};
					
					if not Server.DB.Insert( "uac_users_autologin", query ) then
						Debug( Server.DB.Error(), 1 );
					end
				end
				
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
					if player.LoginCharacter( characterID ) then
						return -1;
					else
						return "Произошла ошибка при авторизации персонажа";
					end
				end
			end
			
			return ClientRPC.BAD_REQUEST;
		end
		
		if command == "Character::Logout" then			
			if not player.IsInGame() then
				return -1
			end
			
			player.Character.Logout( "Logout" );
			
			player.InitLoginCamera();
			player.LoadCharacters( player.UserID, true );
			
			return -1;
		end
		
		if command == "Character::List" then			
			if player.IsInGame() then
				return -1
			end
			
			if player.IsLoggedIn() then			
				-- player.InitLoginCamera();
				
				player.Camera.MoveTo( PlayerManager.DEFAULT_CAMERA_POSITION, 500, "InQuad" );
				player.Camera.RotateTo( PlayerManager.DEFAULT_CAMERA_TARGET, 500, "InQuad" );
				
				player.LoadCharacters( player.UserID, true );
			else
				player.ShowLoginScreen();
			end
			
			return -1;
		end
		
		if command == "Character::CreateUI" then
			if not player.IsLoggedIn() then
				return ClientRPC.UNAUTHORIZED;
			end
			
			if player.IsInGame() then
				return "Вы не можете создавать персонажей во время игры";
			end
			
			local result = Server.DB.Query( "SELECT COUNT(id) AS c FROM " + Server.DB.Prefix + "characters WHERE user_id = %d AND ( status = 'Активен' OR status = 'Заблокирован' )", player.UserID );
			
			if not result then
				Debug( Server.DB.Error(), 1 );
				
				return TEXT_DB_ERROR;
			end
			
			local row = result.GetRow();
			
			delete ( result );
			
			if not row or type( row.c ) ~= "number" then
				return TEXT_DB_ERROR;
			end
			
			if Server.Game.CharactersLimit ~= 0 and row.c >= Server.Game.CharactersLimit then
				return "Вы не можете создавать больше персонажей";
			end
			
			player.RPC.UI.CharacterCreate.Show();
			
			return -1;
		end
		
		if command == "Character::Create" then
			if not player.IsLoggedIn() then
				return ClientRPC.UNAUTHORIZED;
			end
			
			if player.IsInGame() then
				return "Вы не можете создавать персонажей во время игры";
			end
			
			if data then
				local result = Server.DB.Query( "SELECT COUNT(id) AS c FROM " + Server.DB.Prefix + "characters WHERE user_id = %d AND ( status = 'Активен' OR status = 'Заблокирован' )", player.UserID );
				
				if not result then
					Debug( Server.DB.Error(), 1 );
					
					return TEXT_DB_ERROR;
				end
				
				local row = result.GetRow();
				
				delete ( result );
				
				if row and row.c >= Server.Game.CharactersLimit then
					return "Вы не можете создавать больше персонажей";
				end
				
				local name		= (string)(data.name);
				local surname	= (string)(data.surname);
				local skin		= (int)(data.skin);
				local day		= (int)(data.day);
				local month		= (int)(data.month);
				local year		= (int)(data.year);
				local date		= (string)(data.date);
				local cityID	= (int)(data.city);
				
				if name:len() == 0 then
					return "Введите имя персонажа";
				end
				
				if surname:len() == 0 then
					return "Введите фамилию персонажа";
				end
				
				if name:len() < 3 then
					return "Имя слишком короткое";
				end
				
				if surname:len() < 3 then
					return "Фамилия слишком короткая";
				end
				
				if ( name + surname ):len() > 21 then
					return "Общая длина имени и фамилии не может быть более 21 символа";
				end
				
				if not not name:find( "[^A-Za-z]" ) then
					return "Имя содержит запрещённые символы\n\nИспользуйте только символы латинского алфавита";
				end
				
				if not not surname:find( "[^A-Za-z]" ) then
					return "Фамилия содержит запрещённые символы\n\nИспользуйте только символы латинского алфавита";
				end
				
				if skin == 0 then
					return "Вы не выбрали скин персонажа";
				end
				
				if not ( new. CharacterSkin( skin ) ).IsValid() then
					return "Данный скин отключён";
				end
				
				if cityID == 0 then
					return "Необходимо выбрать Город и Страну из предлагаемого списка";
				end
				
				if day == 0 or month == 0 or year == 0 then
					return "Введите дату рождения персонажа";
				end
				
				if day > days_in_month( year, month ) then
					return "В этом месяце не может быть столько дней";
				end
				
				name		= name[ 1 ]:upper() + name:sub( 2, name:len() ):lower();
				surname		= surname[ 1 ]:upper() + surname:sub( 2, surname:len() ):lower();
				
				local result = Server.DB.Query( "SELECT COUNT(id) AS c FROM " + Server.DB.Prefix + "characters WHERE name = %q AND surname = %q", name, surname );
				
				if not result then
					Debug( Server.DB.Error(), 1 );
					
					return TEXT_DB_ERROR;
				end
				
				local row = result.GetRow();
				
				delete ( result );
				
				if row and row.c > 0 then
					return "Персонаж с таким именем уже существует";
				end
				
				local placeResult = Server.DB.Query( "SELECT c.name, cc.city, cc.region FROM cities cc JOIN countries c USING( country_id ) WHERE cc.id = " + cityID );
				
				if not placeResult then
					Debug( Server.DB.Error(), 1 );
					
					return TEXT_DB_ERROR;
				end
				
				local rowPlace = placeResult.GetRow();
				
				delete ( placeResult );
				
				if not rowPlace then
					return "Поле 'Место рождения' заполнено некорректно";
				end
				
				local language	= "en";
				
				local languages	= { current = language };
				
				languages[ language ] = 1000;
				
				local licenses	= { "vehicle" };
				
				local charID	= Server.DB.Insert( Server.DB.Prefix + "characters",
					{
						user_id				= player.UserID;
						name				= name;
						surname				= surname;
						skin				= skin;
						date_of_birdth		= string.format( "%04d-%02d-%02d", year, month, day );
						place_of_birdth		= string.format( "%s, %s, %s", rowPlace.name, rowPlace.region, rowPlace.city );
						nation				= language;
						languages			= languages;
						licenses			= licenses;
						position			= (string)(PlayerManager.NEW_CHAR_POSITION);
						rotation			= PlayerManager.NEW_CHAR_ANGLE;
						created				= new. DateTime().Format( "Y-m-d H:i:s" );
					}
				);
				
				if not charID then
					return TEXT_DB_ERROR;
				end
				
				Console.Log( "%s (%d) Created new character \"%s_%s\" (%d)", player.UserName, player.UserID, name, surname, charID );
				
				player.LoginCharacter( charID );
				
				return -1;
			end
			
			return ClientRPC.BAD_REQUEST;
		end
		
		if command == "SearchCountry" then
			local query = (string)(data);
			
			if query:utfLen() > 0 then
				for i = 1, query:utfLen() do
					local char = query:utfSub( 1, 1 ):utfCode();
					
					if 	( char >= 1072 and char <= 1103 or char >= 1040 and char <= 1071 )
						or
						( char >= 65 and char <= 90 or char >= 97 and char <= 122 )
					then
						-- true;
					else
						if _DEBUG then
							Debug( "invalid char " + char, 3 );
						end
						
						return false;
					end
				end
				
				local result = Server.DB.Query( "SELECT country_id AS id, name as value FROM countries WHERE name LIKE '%" + query + "%' ORDER BY country_id LIMIT 15" );
				
				if result then
					local Result = 
					{
						{
							id		= 0;
							value	= "Страна не найдена";
						};
					};
					
					if result.NumRows() > 0 then
						Result = result.GetArray();
					end
					
					delete ( result );
					
					return Result;
				else
					Debug( Server.DB.Error(), 1 );
				end
			end
			
			return NULL;
		end
		
		if command == "SearchCity" then
			local query		= (string)(data);
			local countryID	= (int)(( { ... } )[ 1 ]);
			
			if query:utfLen() > 0 and countryID > 0 then
				for i = 1, query:utfLen() do
					local char = query:utfSub( 1, 1 ):utfCode();
					
					if 	( char >= 1072 and char <= 1103 or char >= 1040 and char <= 1071 )
						or
						( char >= 65 and char <= 90 or char >= 97 and char <= 122 )
					then
						-- true;
					else
						if _DEBUG then
							Debug( "invalid char " + char, 3 );
						end
						
						return false;
					end
				end
				
				local q = "SELECT id, CONCAT( city, ' (', region, ')' ) AS value FROM cities WHERE country_id = " + countryID + " AND city LIKE '%" + query + "%' LIMIT 15";
				
				local result = Server.DB.Query( q );
				
				if result then
					local Result =
					{
						{
							id		= 0;
							value	= "Город не найден\n";
						};
					};
					
					if result.NumRows() > 0 then
						Result = result.GetArray();
					end
					
					delete ( result );
					
					return Result;
				else
					Debug( Server.DB.Error(), 1 );
				end
			end
			
			return NULL;
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
	
	PlayerRadialMenu	= function( sender, e, command, ... )
		sender.OnRadialMenu( command, ... );
	end;
	
	PlayerModelChange	= function( sender, e, prevSkinID, skinID )
		if getElementType( sender ) == "player" then
			sender.OnModelChange( prevSkinID, skinID );
		end
	end;
	
	---
}
