// Innovation Roleplay Engine
// 
// Author		Kernell
// Copyright	© 2011 - 2013
// License		Proprietary Software
// Version		1.0

#include "Common.h"

CLog **g_pAdminLog;
CLog **g_pMoneyLog;
CLog **g_pBanLog;
CLog **g_pCKLog;
CLog **g_pADLog;

CMySQL	**g_pDB;
CGame	**g_pGame;

CBlowfish	g_pBlowfish( "576F726C644F66526F6C65506C6179426C6F77666973684B6579" );

const string DBPREFIX	= MTA::Get( "mysql.prefix" );
const string DBENGINE	= MTA::Get( "mysql.engine" );

#include "CClientRPC.cpp"

CClientRPC	g_pRPC( "0xFF" );

#include "CGame.cpp"

// CDateTime::SetDefaultTimezone( "Europe/Moscow" );

namespace IRE_Server
{
    class Resource
    {
        void Main()
        {
			string sHost	= MTA::Get( "mysql.host" );
			string sUser	= MTA::Get( "mysql.user" );
			string sPwd		= MTA::Get( "mysql.password" );
			string sDB		= MTA::Get( "mysql.dbname" );

			**g_pDB	= CMySQL( sUser, sPwd, sDB, sHost );

			if( !g_pDB->Ping() )
			{
				this->Stop();
				
				**g_pDB = NULL;
				
				return;
			}
			
			**g_pAdminLog	= CLog( "admin" );
			**g_pMoneyLog	= CLog( "money" );
			**g_pBanLog		= CLog( "ban" );
			**g_pCKLog		= CLog( "character_kill" );
			**g_pADLog		= CLog( "advert" );
			
			ICommand::Register( "as", CCommands::Exec, false );
			
			**g_pGame		= CGame();
		}
		
		void OnStop()
		{
			**g_pGame = NULL;
		}
	};
}
