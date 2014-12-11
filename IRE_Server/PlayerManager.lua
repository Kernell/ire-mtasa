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
				{ Field = "rotation",			Type = "float",								Null = "NO", 	Key = "",			Default = 0,	};
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
		
		-- this.TeamLoggedIn		= new. Team( "Players", new. Color( 255, 255, 255 ) );
		-- this.TeamNotLoggedIn	= new. Team( "Not logged in", new. Color( 120, 120, 120 ) );

		root.OnPlayerJoin.Add( this.PlayerJoin );
		root.OnPlayerQuit.Add( this.PlayerQuit );
		root.OnPlayerChangeNick.Add( this.PlayerChangeNick );
		root.OnPlayerDamage.Add( this.PlayerHit );
		root.OnPlayerCommand.Add( this.PlayerCommand );
if _DEBUG then
		root.OnPlayerModInfo.Add( this.PlayerModInfo );
end
	end;

	_PlayerManager	= function()
		root.OnPlayerJoin.Remove( this.PlayerJoin );
		root.OnPlayerQuit.Remove( this.PlayerQuit );
		root.OnPlayerChangeNick.Remove( this.PlayerChangeNick );
		root.OnPlayerDamage.Remove( this.PlayerHit );
		root.OnPlayerCommand.Remove( this.PlayerCommand );
if _DEBUG then
		root.OnPlayerModInfo.Remove( this.PlayerModInfo );
end
		this.DeleteAll();
	end;

	Init	= function()
		for _, player in pairs( getElementsByType( "player" ) ) do
			this.PlayerJoin( player );
		end
		
		return true;
	end;

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
		this.m_List[ player:GetID() ]	= NULL;
		
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

			this.RemoveFromList( player );

			count = count + 1;
		end
		
		if _DEBUG then
			Debug( string.format( "All players (%d) saved (%d ms)", count, getTickCount() - tick ) );
		end
	end;
	
	ClientHandle	= function( player, command, ... )
		return true;
	end;
}
