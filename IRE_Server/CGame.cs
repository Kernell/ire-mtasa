// Innovation Roleplay Engine

// Author		Kernell
// Copyright	© 2011 - 2013
// License		Proprietary Software
// Version		1.0

class CGame : IGame
{
	bool	m_bRegistration				= true;
	bool	m_bAllowMultiaccount		= false;
	bool	m_bTrafficLightsLocked		= false;
	int		m_iCharactersLimit			= 1;
	
	CGameBlips				m_pBlips;
	CGameTime				m_pTime;
	CGameWeather			m_pWeather;
	CGameWorld				m_pWorld;
	
	CGameBlips@ 			GetBlips				( void )				{ return this.m_pBlips; }
	CGameTime@ 				GetTimeManager			( void )				{ return this.m_pTime; }
	CGameWeather@ 			GetWeatherManager		( void )				{ return this.m_pWeather; }
	CGameWorld@ 			GetWorld				( void )				{ return this.m_pWorld; }
	
	CMapManager@ 			GetMapManager			( void )				{ return this.m_pMapManager; }
	CGroupManager@ 			GetGroupManager			( void )				{ return this.m_pGroupManager; }
	CBankManager@ 			GetBankManager			( void )				{ return this.m_pBankManager; }
	CFactionManager@		GetFactionManager		( void )				{ return this.m_pFactionManager; }
	CFactionInviteManager@	GetFactionInviteManager	( void )				{ return this.m_pFactionInviteManager; }
	CPedManager@			GetPedManager			( void )				{ return this.m_pPedManager; }
	CPlayerManager@			GetPlayerManager		( void )				{ return this.m_pPlayerManager; }
	CVehicleManager@		GetVehicleManager		( void )				{ return this.m_pVehicleManager; }
	CGateManager@			GetGateManager			( void )				{ return this.m_pGateManager; }
	CRaceManager@			GetRaceManager			( void )				{ return this.m_pRaceManager; }
	CItemManager@			GetItemManager			( void )				{ return this.m_pItemManager; }
	CInteriorManager@		GetInteriorManager		( void )				{ return this.m_pInteriorManager; }
	CTeleportManager@		GetTeleportManager		( void )				{ return this.m_pTeleportManager; }
	CShopManager@			GetShopManager			( void )				{ return this.m_pShopManager; }
	CEventMarkerManager@	GetEventMarkerManager	( void )				{ return this.m_pEventMarkerManager; }

	void CGame( void )
	{
		g_pGame		= this;
		
		this.m_pBlips					= CGameBlips();
		this.m_pTime					= CGameTime();
		this.m_pWeather					= CGameWeather();
		this.m_pWorld					= CGameWorld();
		
		this.m_pMapManager				= CMapManager();
		this.m_pGroupManager			= CGroupManager();
		this.m_pBankManager				= CBankManager();
		this.m_pFactionManager			= CFactionManager();
		this.m_pFactionInviteManager	= CFactionInviteManager();
		this.m_pPedManager				= CPedManager();
		this.m_pPlayerManager			= CPlayerManager();
		this.m_pVehicleManager			= CVehicleManager();
		this.m_pGateManager				= CGateManager();
		this.m_pRaceManager				= CRaceManager();
		this.m_pItemManager				= CItemManager();
		this.m_pInteriorManager			= CInteriorManager();
		this.m_pTeleportManager			= CTeleportManager();
		this.m_pShopManager				= CShopManager();
		this.m_pEventMarkerManager		= CEventMarkerManager();
		
		MTA::SetGameType	( "Role-Playing Game" );
		MTA::SetMapName		( "Los Santos" );
		MTA::SetRuleValue	( "Author", "Kernell" );
		MTA::SetRuleValue	( "Version", VERSION );
		MTA::SetRuleValue	( "License", "Proprietary Software" );
		
		CMySQLResult pResult = g_pDB.Query( "SELECT `key`, `value` FROM `game_config`" );
		
		if( pResult )
		{
			CMySQLRow pRow;
			
			while( pRow = pResult.GetArray() )
			{
				switch( pRow.key )
				{
					case "realtime":
					{
						this.m_pTime.m_bReal		= (bool)pRow.value;
						
						break;
					}
					case "day":
					{
						this.m_pTime.m_iDay			= (int)pRow.value;
						
						break;
					}
					case "month":
					{
						this.m_pTime.m_iMonth		= (int)pRow.value;
						
						break;
					}
					case "year":
					{
						this.m_pTime.m_iYear		= (int)pRow.value;
						
						break;
					}
					case "characters_limit":
					{
						this.m_iCharactersLimit		= (int)pRow.value;
						
						break;
					}
					case "allow_multiaccount":
					{
						this.m_bAllowMultiaccount	= (bool)pRow.value;
						
						break;
					}
				}
			}
			
			pResult = null;
		}
		else
			Debug( g_pDB:Error(), 1 );
		
		CPlayer pPlr;
		
		while( pPlr = GetElementsByType( "player" ) )
			this.PlayerJoin( p );
	}

	void ~CGame( void )
	{
		g_pDB.StartTransaction( true );
		
		if( !this.m_pTime.m_bReal )
			g_pDB.Query( "REPLACE INTO `game_config` ( `key`, `value` ) VALUE ( 'day', '" + this.m_pTime.m_iDay + "' ), ( 'month', '" + this.m_pTime.m_iMonth + "' ), ( 'year', '" + this.m_pTime.m_iYear + "' )" );
		
		this.m_pBlips					= null;
		this.m_pTime					= null;
		this.m_pWeather					= null;
		this.m_pWorld					= null;	
		
		this.m_pMapManager				= null;
		this.m_pGroupManager			= null;
		this.m_pBankManager				= null;
		this.m_pFactionManager			= null;
		this.m_pFactionInviteManager	= null;
		this.m_pPedManager				= null;
		this.m_pPlayerManager			= null;
		this.m_pVehicleManager			= null;
		this.m_pGateManager				= null;
		this.m_pRaceManager				= null;
		this.m_pItemManager				= null;
		this.m_pInteriorManager			= null;
		this.m_pTeleportManager			= null;
		this.m_pShopManager				= null;
		this.m_pEventMarkerManager		= null;
		
		g_pDB.Commit( true );
	}

	void DoPulse( void )
	{
		MTA::RealTime pTime		= MTA::GetRealTime(); // TODO: CDateTime
		
		this.m_pTime.DoPulse	( pTime );
		this.m_pWeather.DoPulse	( pTime );
		
		this.m_pMapManager.DoPulse				( pTime );
		this.m_pGroupManager.DoPulse			( pTime );
		this.m_pBankManager.DoPulse				( pTime );
		this.m_pFactionManager.DoPulse			( pTime );
		this.m_pFactionInviteManager.DoPulse	( pTime );
		this.m_pPedManager.DoPulse				( pTime );
		this.m_pPlayerManager.DoPulse			( pTime );
		this.m_pVehicleManager.DoPulse			( pTime );
		this.m_pGateManager.DoPulse				( pTime );
		this.m_pRaceManager.DoPulse				( pTime );
		this.m_pItemManager.DoPulse				( pTime );
		this.m_pInteriorManager.DoPulse			( pTime );
		this.m_pTeleportManager.DoPulse			( pTime );
		this.m_pShopManager.DoPulse				( pTime );
		this.m_pEventMarkerManager.DoPulse		( pTime );
		
		if( this.m_bTrafficLightsLocked == false )
		{
			this.ProcessTrafficLights();
		}
		else
			this.SetTrafficLightState( this.GetTrafficLightState() == 9 ? 6 : 9 ); // TODO: IGame
	}
	
	void ProcessTrafficLights( ulong ulCurrentTime )
	{
		ulong ulDiff	= static_cast < ulong > ( ( ulCurrentTime - this.m_ulLastTrafficUpdate ) * this.m_fGameSpeed );
		byte ucNewState	= 0xFF;

		if( ulDiff >= 1000 )
		{
			if( ( this.m_ucTrafficLightState == 0 || this.m_ucTrafficLightState == 3 ) && ulDiff >= 8000 ) // green
			{
				ucNewState = this.m_ucTrafficLightState + 1;
			}
			else if( ( this.m_ucTrafficLightState == 1 || this.m_ucTrafficLightState == 4 ) && ulDiff >= 3000 ) // orange
			{
				ucNewState = ( this.m_ucTrafficLightState == 4 ) ? 0 : 2;
			}
			else if( this.m_ucTrafficLightState == 2 && ulDiff >= 2000 ) // red
			{
				ucNewState = 3;
			}
			
			if( ucNewState != 0xFF )
			{
				this.SetTrafficLightState( ucNewState );
				this.m_ulLastTrafficUpdate = GetTickCount32();
			}
		}
	}

}
