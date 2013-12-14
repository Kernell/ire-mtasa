// Innovation Roleplay Engine

// Author		Kernell
// Copyright	© 2011 - 2013
// License		Proprietary Software
// Version		1.0

#include "Common.h"

class CGame
{
	bool	m_bRegistration				= true;
	bool	m_bAllowMultiaccount		= false;
	bool	m_bTrafficLightsLocked		= false;
	int		m_iCharactersLimit			= 1;
	
	ulong	m_ucTrafficLightState		= 0;
	ulong	m_ulLastTrafficUpdate		= 0;
	
	
	CGameBlips				**m_pBlips;
	CGameTime				**m_pTime;
	CGameWeather			**m_pWeather;
	CGameWorld				**m_pWorld;
	
	CGameBlips 				**GetBlips					( void )			{ return **this->m_pBlips; }
	CGameTime 				**GetTimeManager			( void )			{ return **this->m_pTime; }
	CGameWeather 			**GetWeatherManager			( void )			{ return **this->m_pWeather; }
	CGameWorld	 			**GetWorld					( void )			{ return **this->m_pWorld; }
	
	CMapManager 			**GetMapManager				( void )			{ return **this->m_pMapManager; }
	CGroupManager 			**GetGroupManager			( void )			{ return **this->m_pGroupManager; }
	CBankManager 			**GetBankManager			( void )			{ return **this->m_pBankManager; }
	CFactionManager			**GetFactionManager			( void )			{ return **this->m_pFactionManager; }
	CFactionInviteManager	**GetFactionInviteManager	( void )			{ return **this->m_pFactionInviteManager; }
	CPedManager				**GetPedManager				( void )			{ return **this->m_pPedManager; }
	CPlayerManager			**GetPlayerManager			( void )			{ return **this->m_pPlayerManager; }
	CVehicleManager			**GetVehicleManager			( void )			{ return **this->m_pVehicleManager; }
	CGateManager			**GetGateManager			( void )			{ return **this->m_pGateManager; }
	CRaceManager			**GetRaceManager			( void )			{ return **this->m_pRaceManager; }
	CItemManager			**GetItemManager			( void )			{ return **this->m_pItemManager; }
	CInteriorManager		**GetInteriorManager		( void )			{ return **this->m_pInteriorManager; }
	CTeleportManager		**GetTeleportManager		( void )			{ return **this->m_pTeleportManager; }
	CShopManager			**GetShopManager			( void )			{ return **this->m_pShopManager; }
	CEventMarkerManager		**GetEventMarkerManager		( void )			{ return **this->m_pEventMarkerManager; }

	CGame( void )
	{
		this->m_pBlips					= CGameBlips();
		this->m_pTime					= CGameTime();
		this->m_pWeather				= CGameWeather();
		this->m_pWorld					= CGameWorld();
		
		this->m_pMapManager				= CMapManager();
		this->m_pGroupManager			= CGroupManager();
		this->m_pBankManager			= CBankManager();
		this->m_pFactionManager			= CFactionManager();
		this->m_pFactionInviteManager	= CFactionInviteManager();
		this->m_pPedManager				= CPedManager();
		this->m_pPlayerManager			= CPlayerManager();
		this->m_pVehicleManager			= CVehicleManager();
		this->m_pGateManager			= CGateManager();
		this->m_pRaceManager			= CRaceManager();
		this->m_pItemManager			= CItemManager();
		this->m_pInteriorManager		= CInteriorManager();
		this->m_pTeleportManager		= CTeleportManager();
		this->m_pShopManager			= CShopManager();
		this->m_pEventMarkerManager		= CEventMarkerManager();
		
		MTA::SetGameType	( "Role-Playing Game" );
		MTA::SetMapName		( "Los Angeles" );
		MTA::SetRuleValue	( "Author", "Kernell" );
		MTA::SetRuleValue	( "Version", VERSION );
		MTA::SetRuleValue	( "License", "Proprietary Software" );
		
		CMySQLResult **pResult = g_pDB->Query( "SELECT `key`, `value` FROM `game_config`" );
		
		if( pResult != NULL )
		{
			CMySQLRow **pRow;
			
			while( **pRow = pResult->GetArray() )
			{
				switch( pRow->key )
				{
					case "realtime":
					{
						this->m_pTime->m_bReal		= pRow->value == "1";
						
						break;
					}
					case "day":
					{
						this->m_pTime->m_iDay		= pRow->value;
						
						break;
					}
					case "month":
					{
						this->m_pTime->m_iMonth		= pRow->value;
						
						break;
					}
					case "year":
					{
						this->m_pTime->m_iYear		= pRow->value;
						
						break;
					}
					case "characters_limit":
					{
						this->m_iCharactersLimit	= pRow->value;
						
						break;
					}
					case "allow_multiaccount":
					{
						this->m_bAllowMultiaccount	= pRow->value == "1";
						
						break;
					}
				}
			}
			
			pResult = NULL;
		}
		else
			Debug::Error( g_pDB->Error() );
		
		CPlayer **pPlr;
		
		while( **pPlr = GetElementsByType( "player" ) )
			this->PlayerJoin( pPlr );
	}

	~CGame( void )
	{
		g_pDB->StartTransaction( true );
		
		if( !this->m_pTime->m_bReal )
			g_pDB->Query( "REPLACE INTO `game_config` ( `key`, `value` ) VALUE ( 'day', '" + this->m_pTime->m_iDay + "' ), ( 'month', '" + this->m_pTime->m_iMonth + "' ), ( 'year', '" + this->m_pTime->m_iYear + "' )" );
		
		**this->m_pBlips				= NULL;
		**this->m_pTime					= NULL;
		**this->m_pWeather				= NULL;
		**this->m_pWorld				= NULL;	
		**this->m_pMapManager			= NULL;
		**this->m_pGroupManager			= NULL;
		**this->m_pBankManager			= NULL;
		**this->m_pFactionManager		= NULL;
		**this->m_pFactionInviteManager	= NULL;
		**this->m_pPedManager			= NULL;
		**this->m_pPlayerManager		= NULL;
		**this->m_pVehicleManager		= NULL;
		**this->m_pGateManager			= NULL;
		**this->m_pRaceManager			= NULL;
		**this->m_pItemManager			= NULL;
		**this->m_pInteriorManager		= NULL;
		**this->m_pTeleportManager		= NULL;
		**this->m_pShopManager			= NULL;
		**this->m_pEventMarkerManager	= NULL;
		
		g_pDB->Commit( true );
	}

	void DoPulse( void )
	{
		CDateTime pTime;
		
		this->m_pTime->DoPulse						( pTime );
		this->m_pWeather->DoPulse					( pTime );
		this->m_pMapManager->DoPulse				( pTime );
		this->m_pGroupManager->DoPulse				( pTime );
		this->m_pBankManager->DoPulse				( pTime );
		this->m_pFactionManager->DoPulse			( pTime );
		this->m_pFactionInviteManager->DoPulse		( pTime );
		this->m_pPedManager->DoPulse				( pTime );
		this->m_pPlayerManager->DoPulse				( pTime );
		this->m_pVehicleManager->DoPulse			( pTime );
		this->m_pGateManager->DoPulse				( pTime );
		this->m_pRaceManager->DoPulse				( pTime );
		this->m_pItemManager->DoPulse				( pTime );
		this->m_pInteriorManager->DoPulse			( pTime );
		this->m_pTeleportManager->DoPulse			( pTime );
		this->m_pShopManager->DoPulse				( pTime );
		this->m_pEventMarkerManager->DoPulse		( pTime );
		
		if( this->m_bTrafficLightsLocked == false )
			this->ProcessTrafficLights();
		else
			this->SetTrafficLightState( this->GetTrafficLightState() == 9 ? 6 : 9 );
	}
	
	void ProcessTrafficLights()
	{
		int iTick		= GetTickCount();
		int iDiff		= iTick - this->m_ulLastTrafficUpdate;
		int iNewState	= 0xFF;

		if( iDiff >= 1000 )
		{
			if( ( this->m_ucTrafficLightState == 0 || this->m_ucTrafficLightState == 3 ) && iDiff >= 8000 ) // green
			{
				iNewState = this->m_ucTrafficLightState + 1;
			}
			else if( ( this->m_ucTrafficLightState == 1 || this->m_ucTrafficLightState == 4 ) && iDiff >= 3000 ) // orange
			{
				iNewState = ( this->m_ucTrafficLightState == 4 ) ? 0 : 2;
			}
			else if( this->m_ucTrafficLightState == 2 && iDiff >= 2000 ) // red
			{
				iNewState = 3;
			}
			
			if( iNewState != 0xFF )
			{
				this->SetTrafficLightState( iNewState );
				this->m_ulLastTrafficUpdate = iTick;
			}
		}
	}

};
