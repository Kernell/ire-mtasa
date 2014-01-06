-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

CHAR_CREATE_SPAWN_POSITION	= Vector3( 1642.18, -2238.65, 13.5 )
CHAR_CREATE_SPAWN_ANGLE		= 180.0

CClientRPC( "0xFF" );

g_pBlowfish	= Blowfish( "576F726C644F66526F6C65506C6179426C6F77666973684B6579" );

g_pServer	= CServer();

SetDefaultTimezone( "Europe/Moscow" );

class: Resource
{
	Main 	= function( pResource )
		_DEBUG 			= (bool)(get "_DEBUG");
		
		setGameType		( "Role-Playing Game" );
		setMapName		( "Los Angeles" );
		setRuleValue	( "Author", "Kernell" );
		setRuleValue	( "Version", VERSION );
		setRuleValue	( "License", "Proprietary Software" );
		setRuleValue	( "ServerVersion", getVersion().tag );
		
		DBHOST			= get "mysql.host";
		DBUSER			= get "mysql.user";
		DBPASS			= get "mysql.password";
		DBNAME			= get "mysql.dbname";
		DBPREFIX		= get "mysql.prefix";
		DBENGINE		= get "mysql.engine";

		g_pDB			= CMySQL( DBUSER, DBPASS, DBNAME, DBHOST );
		
		if not g_pDB:Ping() then
			pResource:Stop();
			
			return cancelEvent( true, sReason );
		end
		
		g_pAdminLog		= CLog( "admin" );
		g_pMoneyLog		= CLog( "money" );
		g_pBanLog		= CLog( "ban" );
		g_pCKLog		= CLog( "character_kill" );
		g_pADLog		= CLog( "advert" );
		
		CCommand:RegisterCommand( "gov", 				CFactionCommands.Government, 	false, CFactionGov );
		CCommand:RegisterCommand( "givelicense", 		CFactionCommands.GiveLicense, 	false, CFactionLicense );
		CCommand:RegisterCommand( "news", 				CFactionCommands.News, 			false );
		CCommand:RegisterCommand( "live", 				CFactionCommands.Live, 			false, CFactionNews );
		CCommand:RegisterCommand( { "ad", "advert" },	CFactionCommands.Advert, 		false );
		CCommand:RegisterCommand( "heal", 				CFactionCommands.Heal, 			false, CFactionMedical );
		CCommand:RegisterCommand( "cuff", 				CFactionCommands.Cuff, 			false, CFactionPolice );
		CCommand:RegisterCommand( "uncuff", 			CFactionCommands.UnCuff, 		false, CFactionPolice );
		CCommand:RegisterCommand( "setcuffed", 			CFactionCommands.SetCuffed, 	false, CFactionPolice );
		CCommand:RegisterCommand( "arrest", 			CFactionCommands.Arrest, 		false, CFactionPolice );
		CCommand:RegisterCommand( { "m", "megaphone" },	CFactionCommands.Megaphone, 	false );
				
		CCommand:RegisterCommand( "p",					CCommands.PhoneText		);
		CCommand:RegisterCommand( { "hangup", "h" },	CCommands.PhoneHangup	);
		CCommand:RegisterCommand( "pickup",				CCommands.PhonePickup	);
		CCommand:RegisterCommand( "call",				CCommands.PhoneCall		);
		CCommand:RegisterCommand( "sms",				CCommands.PhoneSMS		);
		
		CCommand:RegisterCommand( "settings", 			CCommands.Settings );
		CCommand:RegisterCommand( "enter", 				CCommands.Enter );
		CCommand:RegisterCommand( 'showdopulsestat',	CCommands.ShowDoPulseStat	);
		CCommand:RegisterCommand( 'passport',			CCommands.Passport		);
		CCommand:RegisterCommand( 'eject',				CCommands.Eject			);
		CCommand:RegisterCommand( 'changespawn',		CCommands.ChangeSpawn	);
		CCommand:RegisterCommand( 'report',				CCommands.Report		);
		CCommand:RegisterCommand( 'view_help',			CCommands.ViewHelp		);
		CCommand:RegisterCommand( 'stats',				CCommands.Stats			);
		CCommand:RegisterCommand( 'pay',				CCommands.Pay			);
		CCommand:RegisterCommand( 'weapon_slot',		CCommands.WeaponSlot	);
		CCommand:RegisterCommand( 'reload_weapon',		CCommands.ReloadWeapon	);
		CCommand:RegisterCommand( 'drop_weapon',		CCommands.DropWeapon	);
		CCommand:RegisterCommand( 'drop_drink',			CCommands.DropDrink		);
		CCommand:RegisterCommand( 'drink',				CCommands.Drink			);
		CCommand:RegisterCommand( "inventory",			CCommands.ToggleInventory	);
		
		CCommand:RegisterCommand( { 'GlobalOOC', 'o' },	CCommands.GlobalOOC		);
		CCommand:RegisterCommand( { 'LocalOOC', 'b' },	CCommands.LocalOOC		);

		CCommand:RegisterCommand( 'c',					CCommands.CloseIC		);
		CCommand:RegisterCommand( { 'shout', 's' },		CCommands.ShoutIC		);
	--	CCommand:RegisterCommand( { 'whisper', 'w' },	CCommands.WhisperIC		);
		CCommand:RegisterCommand( 'try',				CCommands.TryIC			);
		CCommand:RegisterCommand( 'do',					CCommands.DoIC			);
		CCommand:RegisterCommand( 'dice',				CCommands.DiceIC		);
		CCommand:RegisterCommand( 'coin',				CCommands.CoinIC		);
		
		CCommand:RegisterCommand( 'offer',				CCommands.Offer			);

		CCommand:RegisterCommand( "ignorecarkey",			CCommands.IgnoreCarKey,			true );
		CCommand:RegisterCommand( "ipsadduser",				CCommands.IPSAddUser,			true );
		CCommand:RegisterCommand( "noclip",					CCommands.NoClip, 				false );
		CCommand:RegisterCommand( "exe",					CCommands.Exec, 				false );
		CCommand:RegisterCommand( "exec",					CCommands.ExecClient,			false );
		CCommand:RegisterCommand( "admins",					CCommands.Admins, 				false );
		CCommand:RegisterCommand( "adminduty",				CCommands.AdminDuty,			true ); 
		CCommand:RegisterCommand( "freecam", 				CCommands.Freecam,				true );
		CCommand:RegisterCommand( { "areport", "ar" },		CCommands.AnswerReport,			true );
		CCommand:RegisterCommand( { "adminchat", "a" },		CCommands.AdminChat,			true );
		CCommand:RegisterCommand( { "develchat", "dev" },	CCommands.DevelChat,			false );
		CCommand:RegisterCommand( "pm",						CCommands.PrivateMessage,		true );

		CCommand:RegisterCommand( 'race', NULL, false );
		
		CCommand:AddOption( 'race', 'create',			CRaceCommands.Create,			false, "[name] [cp size] [red] [green] [blue]" );
		CCommand:AddOption( 'race', 'clear',			CRaceCommands.Clear,			false, "—— Удаление всех чекпоинтов" );
		CCommand:AddOption( 'race', 'save',				CRaceCommands.Save,				false, "—— Сохранение гонки" );
		CCommand:AddOption( 'race', 'load',				CRaceCommands.Load,				false, "<name> —— Загрузка уже созданной гонки" );
		CCommand:AddOption( 'race', 'add',				CRaceCommands.Add,				false, "—— Добавление чекпоинта" );
		CCommand:AddOption( 'race', 'remove',			CRaceCommands.Remove,			false, "—— Удаляет последний созданный чекпоинт" );
		CCommand:AddOption( 'race', 'ready',			CRaceCommands.Ready,			false, "—— Переводит гонку в режим ожидания и позволяет игрокам подключаться к ней" );
		CCommand:AddOption( 'race', 'start',			CRaceCommands.Start,			false, "—— Запуск гонки" );
		CCommand:AddOption( 'race', 'stop',				CRaceCommands.Stop,				false, "—— Остановка гонки" );
		CCommand:AddOption( 'race', 'join',				CRaceCommands.Join,				false, "—— Подключение к гонке (только если гонка в режиме ожидания)" );
		CCommand:AddOption( 'race', 'leave',			CRaceCommands.Leave,			false, "—— Выход из гонки" );
		CCommand:AddOption( 'race', '--help',			CRaceCommands.Help );
		
		CCommand:RegisterCommand( 'bank', NULL, true );
		
		CCommand:AddOption( 'bank', 'create',			CBankCommands.Create,			true );
		CCommand:AddOption( 'bank', '--help',			CBankCommands.Help );
		
		CCommand:RegisterCommand( 'gate', NULL, true );
		
		CCommand:AddOption( 'gate', 'reload',			CGateCommands.Reload,			true );
		CCommand:AddOption( 'gate', '--help',			CGateCommands.Help );
		
		CCommand:RegisterCommand( 'faction', NULL, false );
		
		CCommand:AddOption( 'faction', 'new',			CFactionCommands.New,			false, 
			{
				"<options>";
				"Options:";
				"--name         Имя организации - от 8 до 64 символов";
				"--tag         Аббревиатура организации - от 3 до 8 символов";
				"--type         Тип организации - int";
				"--address         Адрес организации - от 10 до 128 символов";
			}
		);
		CCommand:AddOption( 'faction', 'show',			CFactionCommands.Show );
		CCommand:AddOption( 'faction', 'menu',			CFactionCommands.Menu );
		CCommand:AddOption( 'faction', 'edit',			CFactionCommands.Edit,			true, "—— <id>" );
		CCommand:AddOption( 'faction', 'create',		CFactionCommands.Create,		true, "—— <class> <tag> <name>" );
		CCommand:AddOption( 'faction', '--help',		CFactionCommands.Help );
		
		CCommand:RegisterCommand( 'world', NULL, true );
		
		CCommand:AddOption( 'world', 'setweather',		CWorldCommands.SetWeather,		true, 	"<weather> —— Устанавливает погоду" );
		CCommand:AddOption( 'world', 'settime',			CWorldCommands.SetTime,			true, 	"<hour> [minute=0] —— Устанавливает время" );
		CCommand:AddOption( 'world', 'resettime',		CWorldCommands.ResetTime,		true, 	"Востанавливает время" );
		CCommand:AddOption( 'world', '--help',			CWorldCommands.Help );

		CCommand:RegisterCommand( 'system', NULL, true );

		CCommand:AddOption( 'system', 'restart',		CSystemCommands.Restart,		true,	"Таймер на рестарт сервера (0 для отмены)" );
		CCommand:AddOption( 'system', 'shutdown',		CSystemCommands.Shutdown,		true,	"Таймер на выключение сервера (0 для отмены)" );
		CCommand:AddOption( 'system', 'setooc',			CSystemCommands.SetOOC,			true,	"<enabled> —— Включение/выключение глобального OOC чата" );
		CCommand:AddOption( 'system', '--help',			CSystemCommands.Help );

		CCommand:RegisterCommand( 'ped', NULL, true );
		
		CCommand:AddOption( 'ped', 'create',			CPedCommands.Create,			true,	"<model>" );
		CCommand:AddOption( 'ped', 'remove',			CPedCommands.Remove,			true,	"<ped id>" );
		CCommand:AddOption( 'ped', 'setposition',		CPedCommands.SetPosition,		true,	"<ped id> [x y z] [rotation]" );
		CCommand:AddOption( 'ped', 'setanimation',		CPedCommands.SetAnimation,		true,	"<ped id> <lib> <name> [time = 0] [loop = false] [update position = false] [interruptable = false] [freeze last frame = false]" );
		CCommand:AddOption( 'ped', 'setfrozen',			CPedCommands.SetFrozen,			true,	"<ped id> [frozen = false]" );
		CCommand:AddOption( 'ped', 'setdamageproof',	CPedCommands.SetDamageProof,	true,	"<ped id> [damageproof = false]" );
		CCommand:AddOption( 'ped', 'setcollisions',		CPedCommands.SetCollisions,		true,	"<ped id> [collisions = false]" );
		CCommand:AddOption( 'ped', 'toggle_labels',		CPedCommands.ToggleLabels,		true,	"—— Включение/выключение отображения информации над педами" );
		CCommand:AddOption( 'ped', '--help',			CPedCommands.Help );
		
		CCommand:RegisterCommand( 'player', NULL, true );

		CCommand:AddOption( 'player', 'jail',			CPlayerCommands.Jail,			true,	"<player> <minutes> <reason> —— Садит игрока в бан зону" );
		CCommand:AddOption( 'player', 'slap',			CPlayerCommands.Slap,			true,	"<player> [health = 0]" );
		CCommand:AddOption( 'player', 'mute',			CPlayerCommands.Mute,			true,	"<player> <minutes> <причина> —— Молчанка (запрещает игроку пользоваться чатом)" );
		CCommand:AddOption( 'player', 'kick',			CPlayerCommands.Kick,			true,	"<player> <причина> —— Отключает игрока от сервера" );
		CCommand:AddOption( 'player', 'ban',			CPlayerCommands.Ban,			true,	"<player> <minutes; 0 - permanent> <причина> —— Оффлайн бан" );
		CCommand:AddOption( 'player', 'unban',			CPlayerCommands.Unban,			true,	"<serial | username> —— Разблокировка игрока" );
		CCommand:AddOption( 'player', 'setname',		CPlayerCommands.SetName,		true,	"<player> <name> <surname> —— Смена РП ника игроку" );
		CCommand:AddOption( 'player', 'sethealth',		CPlayerCommands.SetHealth,		true,	"<player> <health> —— Устанавливает уровень здоровья" );
		CCommand:AddOption( 'player', 'setarmor',		CPlayerCommands.SetArmor,		true,	"<player> <armor> —— Устанавливает уровень брони" );
		CCommand:AddOption( 'player', 'setskin',		CPlayerCommands.SetSkin,		true,	"<player> <skin>" );
		CCommand:AddOption( 'player', 'setmoney',		CPlayerCommands.SetMoney,		true,	"<player> <money> —— Устанавливает определённое кол-во денег игроку" );
		CCommand:AddOption( 'player', 'givemoney',		CPlayerCommands.GiveMoney,		true,	"<player> <money> —— Даёт определённое кол-во денег игроку" );
		CCommand:AddOption( 'player', 'get',			CPlayerCommands.Get,			true,	"<player> —— Телепортирует игрока к Вам" );
		CCommand:AddOption( 'player', 'goto',			CPlayerCommands.Goto,			true,	"<player> —— Телепортирует Вас к игроку" );
		CCommand:AddOption( 'player', 'reconnect',		CPlayerCommands.Reconnect,		true,	"<player> —— Переподключает игрока к серверу" );
		CCommand:AddOption( 'player', 'setfaction',		CPlayerCommands.SetFaction,		true,	"<player> <faction> [rank = 1] [rights = Member] —— Устанавливает игроку фракцию, ранк и уровень прав" );
		CCommand:AddOption( 'player', 'spectate',		CPlayerCommands.Spectate,		true,	"<player> —— Наблюдение за игроком" );
		CCommand:AddOption( 'player', 'giveitem',		CPlayerCommands.GiveItem,		true,
			{
				"<item> [options]";
				"Options:";
				"--player              target player (id/name)";
				"--value               int";
				"--condition           float (0-100)";
			--	"--data                key:value,...";
			}
		);
		CCommand:AddOption( 'player', 'getposition',	CPlayerCommands.GetPosition,	false,	"[player] —— Вывод текущих координат игрока" );
		CCommand:AddOption( 'player', 'payday',			CPlayerCommands.PayDay,			true );
		CCommand:AddOption( 'player', '--help',			CPlayerCommands.Help );
		
		CCommand:RegisterCommand( 'vehicle', NULL, false );

		CCommand:AddOption( 'vehicle', 'setcruise', 	CVehicleCommands.SetCruise,			false, 	"[speed = 0.0] —— Круиз контроль" );
		CCommand:AddOption( 'vehicle', 'loop_wiper', 	CVehicleCommands.LoopWhiperState,	false, 	"Переключает состояние дворников автомобиля" );
		CCommand:AddOption( 'vehicle', 'loop_whelen', 	CVehicleCommands.LoopWhelenState,	false, 	"Переключает следующее состояние проблесковых маячков" );
		CCommand:AddOption( 'vehicle', 'loop_siren', 	CVehicleCommands.LoopSirenState,	false, 	"Переключает следующее состояние сирены" );
		CCommand:AddOption( 'vehicle', 'setwhelen', 	CVehicleCommands.SetWhelenState,	false, 	"Устанавливает состояние проблесковых маячков" );
		CCommand:AddOption( 'vehicle', 'setsiren', 		CVehicleCommands.SetSirenState,		false, 	"Устанавливает состояние сирены" );
		CCommand:AddOption( 'vehicle', 'toggle_whelen', CVehicleCommands.ToggleWhelen,		false, 	"Переключает состояние проблесковых маячков" );
		CCommand:AddOption( 'vehicle', 'toggle_siren', 	CVehicleCommands.ToggleSiren,		false, 	"Переключает состояние сирены" );
		CCommand:AddOption( 'vehicle', 'toggle_engine', CVehicleCommands.ToggleEngine,	false, 	"Переключает состояние двигателя автомобиля" );
		CCommand:AddOption( 'vehicle', 'toggle_locked', CVehicleCommands.ToogleLocked,	false, 	"Переключает состояние дверей автомобиля" );
		CCommand:AddOption( 'vehicle', 'toggle_lights', CVehicleCommands.ToggleLights,	false, 	"Переключает состояние фар автомобиля" );
		CCommand:AddOption( 'vehicle', 'swatrope', 		CVehicleCommands.SwatRope,		false, 	"Спустится по верёвке" );
		CCommand:AddOption( 'vehicle', 'sell',	 		CVehicleCommands.Sell,			false, 	"<player> <price>" );
		-- Admin
		CCommand:AddOption( 'vehicle', 'create', 		CVehicleCommands.Create,		true,	"<model> —— создание нового автомобиля" );
		CCommand:AddOption( 'vehicle', 'delete', 		CVehicleCommands.Delete,		true,	"<id> —— удаляет автомобиль с сервера" );
		CCommand:AddOption( 'vehicle', 'restore', 		CVehicleCommands.Restore,		true,	"<MySQL id> —— востанавливает удалённый автомобиль" );
		CCommand:AddOption( 'vehicle', 'toggle_labels', CVehicleCommands.ToggleLabels,	true,	"[distance] —— Включение/выключение отображения информации" );
		CCommand:AddOption( 'vehicle', 'get', 			CVehicleCommands.Get,			true,	"<id> —— Телепортирует автомобиль" );
		CCommand:AddOption( 'vehicle', 'goto', 			CVehicleCommands.Goto,			true,	"<id> —— Телепортирует к автомобилю" );
		CCommand:AddOption( 'vehicle', 'spawn', 		CVehicleCommands.Spawn,			true,	"<model> —— Создание временного автомобиля" );
		CCommand:AddOption( 'vehicle', 'respawn', 		CVehicleCommands.Respawn,		true,	"<id> —— Полное пересоздание автомобиля" );
		CCommand:AddOption( 'vehicle', 'respawnall',	CVehicleCommands.RespawnAll,	true,	"Полное пересоздание всех автомобилей" );
		CCommand:AddOption( 'vehicle', 'repair', 		CVehicleCommands.Repair,		true,	"[id] —— Полный ремонт автомобиля" );
		CCommand:AddOption( 'vehicle', 'flip', 			CVehicleCommands.Flip, 			true,	"[id] —— Переворачивает автомобиль на колёса" );
		CCommand:AddOption( 'vehicle', 'setfrozen', 	CVehicleCommands.SetFrozen,		true,	"<id> [frozen = true] —— Принудительная заморозка" );
		CCommand:AddOption( 'vehicle', 'setfuel', 		CVehicleCommands.SetFuel,		true,	"<id> <fuel> —— Установка уровня топлива" );
		CCommand:AddOption( 'vehicle', 'setcolor', 		CVehicleCommands.SetColor,		true,	"<id> <r> <g> <b> [ ... ] —— Изменение цвета автомобиля" );
		CCommand:AddOption( 'vehicle', 'setmodel', 		CVehicleCommands.SetModel,		true,	"<id> <model> —— Изменение модели автомобиля" );
		CCommand:AddOption( 'vehicle', 'setspawn', 		CVehicleCommands.SetSpawn,		true,	"[id] —— Устанавливает начальные координаты для автомобиля" );
		CCommand:AddOption( 'vehicle', 'setplate', 		CVehicleCommands.SetPlate, 		true,	"<id> <plate> —— Устанавливает номер машины" );
		CCommand:AddOption( 'vehicle', 'setvariant',	CVehicleCommands.SetVariant,	true,	"<id> <variant1> <variant2> —— Устанавливает разные вариации автомобиля (extra детали)" );
		CCommand:AddOption( 'vehicle', 'setupgrade',	CVehicleCommands.SetUpgrade,	true,	"<id> <upgrade> —— Устанавливает компоненты тюнинга" );
		CCommand:AddOption( 'vehicle', 'setdata',		CVehicleCommands.SetData,		true,	"<id> <data> <value or NULL>" );
		CCommand:AddOption( 'vehicle', 'setowner', 		CVehicleCommands.SetOwner,		true,	"<id> <player> —— Устанавливает нового владельца машины" );
		CCommand:AddOption( 'vehicle', 'setrentable',	CVehicleCommands.SetRentable,	true,	"<id> [rentable = false] —— true/false (1/0)" );
		CCommand:AddOption( 'vehicle', 'setrentprice', 	CVehicleCommands.SetRentPrice,	true,	"<id> <value> —— Устанавливает стоимость аренды машины" );
		CCommand:AddOption( 'vehicle', 'setfaction', 	CVehicleCommands.SetFaction,	true,	"<id> <faction> —— Закрепляет машину за фракцией" );
		CCommand:AddOption( 'vehicle', 'saveall', 		CVehicleCommands.SaveAll, 		true,	"Принудительное сохранение всех машин" );
		CCommand:AddOption( 'vehicle', 'shop', 			CVehicleCommands.Shop,	 		true,	"<option> —— Options: reload" );
		CCommand:AddOption( 'vehicle', 'fuelpoint', 	CVehicleCommands.FuelPoint,		true,	"<option> —— Options: add" );
		CCommand:AddOption( 'vehicle', '--help',		CVehicleCommands.Help );

		CCommand:RegisterCommand( 'teleport', NULL, true );
		
		CCommand:AddOption( 'teleport', 'create',		CTeleportCommands.Create,		true,	"—— Добавление нового маркера" );
		CCommand:AddOption( 'teleport', 'delete',		CTeleportCommands.Delete,		true,	"<id> —— Удаление маркера" );
		CCommand:AddOption( 'teleport', 'drawlabels',	CTeleportCommands.DrawLabels,	true,	"—— Показывает информацию о маркере над ним" );
		CCommand:AddOption( 'teleport', 'setfaction',	CTeleportCommands.SetFaction,	true,	"<id> <faction> —— Заркпление маркера за фракцией (По умолчанию: 0)" );
		CCommand:AddOption( 'teleport', 'setmark',		CTeleportCommands.SetMark,		true,	"—— Запоминает текущие координаты для создания нового маркера" );
		CCommand:AddOption( 'teleport', '--help',		CTeleportCommands.Help );
		
		CCommand:RegisterCommand( 'interior', NULL, false );
		
		CCommand:AddOption( 'interior', 'create',			CInteriorCommands.Create,			true,	"<interior id> <type> <price> <name> —— Добавление нового интерьера" );
		CCommand:AddOption( 'interior', 'remove',			CInteriorCommands.Remove,			true,	"<id> —— Удаление интерьера" );
		CCommand:AddOption( 'interior', 'settype',			CInteriorCommands.SetType,			true,	"<id> <type> —— Изменение типа интерьера" );
		CCommand:AddOption( 'interior', 'setname',			CInteriorCommands.SetName,			true,	"<id> <name> —— Изменение названия интерьера" );
		CCommand:AddOption( 'interior', 'setprice',			CInteriorCommands.SetPrice,			true,	"<id> <price> —— Изменение цены интерьера" );
		CCommand:AddOption( 'interior', 'setmoney',			CInteriorCommands.SetMoney,			true,	"<id> <moneys> —— Изменение банка интерьера" );
		CCommand:AddOption( 'interior', 'setlocked',		CInteriorCommands.SetLocked,		true,	"<id> [locked=false] —— Открытие/закрытие интерьера" );
		CCommand:AddOption( 'interior', 'setowner',			CInteriorCommands.SetOwner,			true,	"<id> <name> <surname> —— Изменение владельца интерьера" );
		CCommand:AddOption( 'interior', 'setdropoff',		CInteriorCommands.SetDropoff,		true,	"<id> —— " );
		CCommand:AddOption( 'interior', 'setinterior',		CInteriorCommands.Set,				true,	"<id> <interior id> —— Изменение интерьера" );
		CCommand:AddOption( 'interior', 'generateprices',	CInteriorCommands.GeneratePrices,	true,	"—— Генерация цен всех интерьеров (на основе таблицы)" );
		CCommand:AddOption( 'interior', 'view',				CInteriorCommands.View,				true,	"<interior id> —— Просмотр интерьера" );
		CCommand:AddOption( 'interior', 'enter',			CInteriorCommands.Enter,			true,	"<id> —— Вход в интерьер" );
		CCommand:AddOption( 'interior', 'openmenu',			CInteriorCommands.OpenMenu,			false,	"<id> —— " );
		CCommand:AddOption( 'interior', 'buy',				CInteriorCommands.Buy,				false,	"<id> —— Покупка интерьера" );
		CCommand:AddOption( 'interior', 'sell',				CInteriorCommands.Sell,				false,	"<id> —— Продажа в интерьера" );
		CCommand:AddOption( 'interior', '--help',			CInteriorCommands.Help );
		
		CCommand:RegisterCommand( "map", NULL, true );
		
		CCommand:AddOption( 'map', 'add',			CMapCommands.Add,			true,	"<file name (without extension)>" );
		CCommand:AddOption( 'map', 'remove',		CMapCommands.Remove,		true,	"<file name (without extension)>" );
		CCommand:AddOption( 'map', 'setdimension',	CMapCommands.SetDimension,	true,	"<file name (without extension)> <dimension>" );
		CCommand:AddOption( 'map', '--help',		CMapCommands.Help );
		
		CCommand:RegisterCommand( "marker", NULL, true );
		
		CCommand:AddOption( 'marker', 'add',		CMarkerCommands.Create,	true,
			{
				"<options>";
				"Options:";
				"--model               pickup model or checkpoint type (required)";
				"--size                float";
				"--color               rgba color (255,128,0,255)";
				"--onhit               function name of CEventMarker";
				"--onleave             function name of CEventMarker";
			}
		);
		
		CCommand:AddOption( 'marker', 'remove',			CMarkerCommands.Remove, true, "<id>" );
		CCommand:AddOption( 'marker', '--help',			CMarkerCommands.Help );
		
		CCommand:RegisterCommand( "shop", NULL, true );
		
		CCommand:AddOption( 'shop', 'create',		CShopCommands.Create,		true,	"[type = none] [pickup = null] [price multiple = 1.0]" );
		CCommand:AddOption( 'shop', 'delete',		CShopCommands.Delete,		true,	"<shop id>" );
		CCommand:AddOption( 'shop', 'additem',		CShopCommands.AddItem,		true,	"<shop id> <item> —— добавление предмета в продажу" );
		CCommand:AddOption( 'shop', 'removeitem',	CShopCommands.RemoveItem,	true,	"<shop id> <item> —— удаление предмета из продажи" );
		CCommand:AddOption( 'shop', '--help',		CShopCommands.Help );
		
		CCommand:RegisterCommand( "uac", NULL, true );
		
		CCommand:AddOption( 'uac', 'adduser',		CUACCommands.AddUser,			true,
			{
				"<login> [options]";
				"Options:";
				"-p, --password       пароль для нового пользователя";
				"-n. --name            имя пользователя (по умолчанию - логин)";
				"-g, --groups          группы через запятую (ID и/или название)";
			}
		);
		CCommand:AddOption( 'uac', 'usermod',		CUACCommands.UserMod,			true,
			{
				"[flags] <login>";
				"Options:";
				"-l, --login              логин пользователя";
				"-p, --password       пароль пользователя";
				"-n. --name            имя пользователя (по умолчанию - логин)";
				"-g, --groups          группы через запятую (ID и/или название)";
			}
		);
		CCommand:AddOption( 'uac', 'userdel',		CUACCommands.UserDel,			true,
			{
				"<login> [flags]";
				"Options:";
				"-c, --chars         удалить всех персонажей пользователя";
			}
		);
		CCommand:AddOption( 'uac', 'addgroup',		CUACCommands.AddGroup,			true,
			{
				"<name> <caption> [flags]";
				"Options:";
				"-c, --color         цвет группы. По умолчанию: 255,255,255";
			}
		);
		CCommand:AddOption( 'uac', 'groupmod',		CUACCommands.GroupMod,			true,
			{
				"<id|name|caption> [flags]";
				"Options:";
				"-c, --color         RGB цвет группы, например: 255,64,128";
				"-n, --name          Имя группы";
				"-C, --caption       Заголовок группы";
				"--add-rule          Добавить разрешение доступа к правилу";
				"--remove-rule       Запретить доступ к правилу";
			}
		);
		CCommand:AddOption( 'uac', 'reload',		CUACCommands.Reload,			true,	"Перезагрузка групп и их привилегий" );
		CCommand:AddOption( 'uac', '--help',		CUACCommands.Help );
		
		g_pServer:Startup();
	end;
	
	OnStop	= function()
		delete ( g_pServer );
		g_pServer = NULL;
	end;
};

addEventHandler( 'onResourceStop', resourceRoot, Resource.OnStop, true, "high" );