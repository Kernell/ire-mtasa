-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CGame
{
	m_bRegistration			= true;
	m_bAllowMultiaccount	= false;
	m_iCharactersLimit		= 1;
	
	m_Managers				= NULL;
	
	GetBlips			= function( self ) return self.m_pBlips;			end;
	GetTimeManager		= function( self ) return self.m_pTime;				end;
	GetWeatherManager	= function( self ) return self.m_pWeather;			end;
	GetWorld			= function( self ) return self.m_pWorld;			end;
};

function CGame:CGame()
	g_pGame						= self;
	
	self.m_Managers				= {};
	
	self.m_pBlips				= CGameBlips();
	self.m_pTime				= CGameTime();
	self.m_pWeather				= CGameWeather();
	self.m_pWorld				= CGameWorld();
	
	CEventManager();
	CMapManager();
	CGroupManager();
	CBankManager();
	CFactionManager();
	CPedManager();
	CPlayerManager();
	CVehicleManager();
	CGateManager();
	CRaceManager();
	CItemManager();
	CInteriorManager();
	CTeleportManager();
	CShopManager();
	CEventMarkerManager();
	CTutorialManager();
	
	local pResult	= g_pDB:Query( "SELECT `key`, `value` FROM `game_config`" );
	
	if pResult then
		for _, row in pairs( pResult:GetArray() ) do
			switch( row.key )
			{
				realtime 			= function()
					self.m_pTime.m_bReal		= (bool)(row.value);
				end;
				day 				= function()
					self.m_pTime.m_iDay			= (int)(row.value);
				end;
				month				= function()
					self.m_pTime.m_iMonth		= (int)(row.value);
				end;
				year				= function()
					self.m_pTime.m_iYear		= (int)(row.value);
				end;
				characters_limit	= function()
					self.m_iCharactersLimit		= (int)(row.value);
				end;
				allow_multiaccount	= function()
					self.m_bAllowMultiaccount	= (bool)(row.value);
				end;
			}
		end
		
		delete ( pResult );
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	for i, pManager in ipairs( self.m_Managers ) do
		if pManager.Init then
			local iTick = getTickCount();
			
			if pManager:Init() then
				printf( "Starting %-34s [  OK  ]  %20s ms", classname( pManager ) + ":", (int)(getTickCount() - iTick) );
			else
				printf( "Starting %-34s [FAILED]", classname( pManager ) + ":" );
			end
		end
	end
	
	for i, p in ipairs( getElementsByType( "player" ) ) do
		g_pGame:PlayerJoin( p );
	end
end

function CGame:_CGame()
	g_pDB:StartTransaction( true );
	
	if not self.m_pTime.m_bReal then
		g_pDB:Query( "REPLACE INTO `game_config` ( `key`, `value` ) VALUE ( 'day', '" + self.m_pTime.m_iDay + "' ), ( 'month', '" + self.m_pTime.m_iMonth + "' ), ( 'year', '" + self.m_pTime.m_iYear + "' )" );
	end
	
	delete ( self.m_pBlips );
	delete ( self.m_pTime );
	delete ( self.m_pWeather );
	delete ( self.m_pWorld );
	
	for i = table.getn( self.m_Managers ), 1, -1 do
		local pManager = self.m_Managers[ i ];
		
		if pManager then
			delete ( pManager );
		end
	end
	
	self.m_Managers = NULL;
	
	g_pDB:Commit( true );
end

function CGame:DoPulse()
	local iTick = getTickCount();	
	local tReal = getRealTime(); -- TODO: CDateTime
	
	local iTick2 = getTickCount();	self.m_pTime:DoPulse				( tReal );		root:SetData( "Debug:CGameTime::DoPulse", 			getTickCount() - iTick2 );
	local iTick2 = getTickCount();	self.m_pWeather:DoPulse				( tReal );		root:SetData( "Debug:CGameWeather::DoPulse", 		getTickCount() - iTick2 );

	for i, pManager in ipairs( self.m_Managers ) do
		if pManager.DoPulse then
			local iTick2 = getTickCount();
			
			pManager:DoPulse( tReal );
			
			iTick2 = getTickCount() - iTick2;
			
			root:SetData( "Debug:" + classname( pManager ) + "::DoPulse", iTick2 );
		end
	end
	
	root:SetData( "Debug:CGame::DoPulse", getTickCount() - iTick );
end

function CGame:PlayerJoin( pPlayerEntity )
	local pPlayer = self:GetPlayerManager():Create( pPlayerEntity );
end

function CGame:PlayerQuit( pPlayerEntity, sType, sReason, pResponsePlayer )
	pPlayerEntity:Unlink( sType, sReason, pResponsePlayer );
end

------------------------------------------------------------------------------------------------------------------------
addEventHandler( "onPlayerJoin",		root, function( ... ) g_pGame:PlayerJoin( source, ... ); end );
addEventHandler( "onPlayerQuit", 		root, function( ... ) g_pGame:PlayerQuit( source, ... ); end );
addEventHandler( "onPlayerChangeNick",	root, function() cancelEvent() end );