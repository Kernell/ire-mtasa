// Innovation Roleplay Engine
// 
// Author		Kernell
// Copyright	© 2011 - 2013
// License		Proprietary Software
// Version		1.0

#include "CServer.cs"
#include "CClientRPC.cs"

const bool 		_DEBUG			= MTA::Get( "_DEBUG" ) == "true";
const string	DBHOST			= MTA::Get( "mysql.host" );
const string 	DBUSER			= MTA::Get( "mysql.user" );
const string 	DBPASS			= MTA::Get( "mysql.password" );
const string 	DBNAME			= MTA::Get( "mysql.dbname" );
const string 	DBPREFIX		= MTA::Get( "mysql.prefix" );
const string 	DBENGINE		= MTA::Get( "mysql.engine" );
const string	BLOWFISH_KEY	= "576F726C644F66526F6C65506C6179426C6F77666973684B6579";

CLog
	@g_pAdminLog,
	@g_pMoneyLog,
	@g_pBanLog,
	@g_pCKLog,
	@g_pADLog;

CMySQL		@g_pDB;
CServer		@g_pServer;
CGame		@g_pGame;

CClientRPC	@g_pRPC			= CClientRPC( "0xFF" );
Blowfish	@g_pBlowfish	= Blowfish( BLOWFISH_KEY );

CDateTime::SetDefaultTimezone( "Europe/Moscow" );

namespace IRE_Server
{
    class Resource
    {
        void Main()
        {
			g_pDB	= CMySQL( DBUSER, DBPASS, DBNAME, DBHOST );
			
			if( !g_pDB.Ping() )
			{
				this.Stop();
				
				g_pDB = null;
				
				return;
			}
			
			g_pAdminLog		= CLog( "admin" );
			g_pMoneyLog		= CLog( "money" );
			g_pBanLog		= CLog( "ban" );
			g_pCKLog		= CLog( "character_kill" );
			g_pADLog		= CLog( "advert" );
			
			ICommand::Register( "as", CCommands::Exec, false );
			
			g_pServer		= CServer();
		}
		
		void OnStop()
		{
			g_pServer = null;
		}
	}
}
