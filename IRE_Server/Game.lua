-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. Game
{
	RegistrationEnabled		= true;
	AllowMultiaccount		= false;
	CharactersLimit			= 1;
	
	Game		= function()
		this.DebugTicks	= {};
		this.Managers	= {};
		
		function this.__OnPlayerJoin( ... )
			this.PlayerJoin( source, ... );
		end
		
		function this.__OnPlayerQuit( ... )
			this.PlayerJoin( source, ... );
		end
		
		function this.__OnChangeNick()
			return cancelEvent();
		end
		
		addEventHandler( "onPlayerJoin",			root, this.__OnPlayerJoin );
		addEventHandler( "onPlayerQuit", 			root, this.__OnPlayerQuit );
		addEventHandler( "onPlayerChangeNick",		root, this.__OnChangeNick );
	end;
	
	_Game		= function()
		removeEventHandler( "onPlayerJoin",			root, this.__OnPlayerJoin );
		removeEventHandler( "onPlayerQuit", 		root, this.__OnPlayerQuit );
		removeEventHandler( "onPlayerChangeNick",	root, this.__OnChangeNick );
		
		Server.DB.StartTransaction( true );
		
		if not this.Environment.RealSync then
			local day	= this.Environment.Day;
			local month	= this.Environment.Month;
			local year	= this.Environment.Year;
			
			Server.DB.Query( "REPLACE INTO `game_config` ( `key`, `value` ) VALUE ( 'day', '" + day + "' ), ( 'month', '" + month + "' ), ( 'year', '" + year + "' )" );
		end
		
		for i = table.getn( this.Managers ), 1, -1 do
			local manager = this.Managers[ i ];
			
			if manager then
				delete ( manager );
			end
		end
		
		Server.DB.Commit( true );
		
		this.Managers 		= NULL;
		
		this.__OnPlayerJoin = NULL;
		this.__OnPlayerQuit = NULL;
		this.__OnChangeNick = NULL;
	end;
	
	Init		= function()
		this.Environment				= new. Environment();
	--	this.BlipManager				= new. BlipManager();
	--	this.WeatherManager				= new. WeatherManager();
	--	this.WorldManager				= new. WorldManager();
		
		local result	= Server.DB.Query( "SELECT `key`, `value` FROM `game_config`" );
	
		if result then
			for i, row in pairs( result.GetArray() ) do
				switch( row.key )
				{
					realtime 			= function()
						this.Environment.RealSync		= (bool)(row.value);
					end;
					
					day 				= function()
						this.Environment.Day			= (int)(row.value);
					end;
					
					month				= function()
						this.Environment.Month			= (int)(row.value);
					end;
					
					year				= function()
						this.Environment.Year			= (int)(row.value);
					end;
					
					characters_limit	= function()
						this.CharactersLimit			= (int)(row.value);
					end;
					
					allow_multiaccount	= function()
						this.AllowMultiaccount			= (bool)(row.value);
					end;
				}
			end
			
			delete ( result );
		else
			Debug( Server.DB.Error(), 1 );
		end
		
	--	this.EventManager				= new. EventManager();
	--	this.MapManager					= new. MapManager();
		this.GroupManager				= new. GroupManager();
	--	this.BankManager				= new. BankManager();
	--	this.FactionManager				= new. FactionManager();
	--	this.NPCManager					= new. NPCManager();
	--	this.VehicleManager				= new. VehicleManager();
	--	this.GateManager				= new. GateManager();
	--	this.RaceManager				= new. RaceManager();
	--	this.ItemManager				= new. ItemManager();
	--	this.InteriorManager			= new. InteriorManager();
	--	this.TeleportManager			= new. TeleportManager();
	--	this.ShopManager				= new. ShopManager();
	--	this.EventMarkerManager			= new. EventMarkerManager();
	--	this.TutorialManager			= new. TutorialManager();
		this.PlayerManager				= new. PlayerManager();
		
		for i, manager in ipairs( this.Managers ) do
			if manager.Init then
				local tick = getTickCount();
				
				if manager.Init() then
					Console.Log( "Starting %-34s [  OK  ]  %20s ms", classname( manager ) + ":", (int)(getTickCount() - tick) );
				else
					Console.Log( "Starting %-34s [FAILED]", classname( manager ) + ":" );
				end
			end
		end
	end;
	
	DoPulse		= function()
		local tick	= getTickCount();
		
		local realTime	= new. DateTime();
		
		for i, manager in ipairs( this.Managers ) do
			if manager.DoPulse then
				local tick2 = getTickCount();
				
				manager.DoPulse( realTime );
				
				this.DebugTicks[ classname( manager ) ] = getTickCount() - tick2;
			end
		end
		
		this.DebugTicks[ "DoPulse" ] = getTickCount() - tick;
		
		root.SetData( "DebugDoPulseTicks", this.DebugTicks );
	end;
	
	PlayerJoin	= function( playerEntity )
		this.PlayerManager.Create( playerEntity );
	end;
	
	PlayerQuit	= function( playerEntity, type, reason, responsePlayer )
		this.PlayerManager.Unlink( type, reason, responsePlayer );
	end;
};
