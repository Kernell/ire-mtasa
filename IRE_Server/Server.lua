-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. Server
{
	enum "eServerCountDown"
	{
		SERVER_COUNTDOWN_NONE		= 0;
		SERVER_COUNTDOWN_SHUTDOWN	= 1;
		SERVER_COUNTDOWN_RESTART	= 2;
	};
	
	static
	{
		CountDown		= 0;
		CountDownType	= SERVER_COUNTDOWN_NONE;
		
		Game			= false;
		DB				= false;
		Console			= false;
		Blowfish		= false;
		RPC				= false;
	};
	
	DoPulseTimer	= NULL;
	
	Server		= function()
		local MySQLHost		= get "mysql.host";
		local MySQLUser		= get "mysql.user";
		local MySQLPass		= get "mysql.password";
		local MySQLDB		= get "mysql.dbname";
		
		Server.DB			= new. MySQL( MySQLUser, MySQLPass, MySQLDB, MySQLHost );
		
		Server.DB.Prefix	= get "mysql.prefix";
		Server.DB.Engine	= get "mysql.engine";
		
		if not Server.DB.Ping() then
			return cancelEvent( true );
		end
		
		Server.Console	= new. Console();
		Server.Blowfish	= new. Blowfish( "576F726C644F66526F6C65506C6179426C6F77666973684B6579" );
		Server.Game		= new. Game();
		Server.RPC		= new. ClientRPC( "IRE_Server", "IRE_Client" );
		
		Server.Game.Init();
	end;
	
	_Server		= function()
		if this.DoPulseTimer then
			this.DoPulseTimer.Kill();
		end
		
		delete ( Server.Game );
		delete ( Server.Blowfish );
		delete ( Server.Console );
		delete ( Server.RPC );
		delete ( Server.DB );
		
		Server.Blowfish 	= NULL;
		Server.Console 		= NULL;
		Server.Game			= NULL;
		Server.RPC			= NULL;
		Server.DB			= NULL;
		
		this.DoPulseTimer	= NULL;
	end;
	
	Startup		= function()
		Server.Console.Initialize();
		
		if this.DoPulseTimer then
			this.DoPulseTimer.Kill();
		end
		
		this.DoPulseTimer = new. Timer( 
			function()
				this.DoPulse();
			end, 1000, 0
		);
	end;
	
	DoPulse		= function()
		if Server.Game then
			Server.Game.DoPulse();
		end
		
		if Server.CountDown > 0 then 
			Server.CountDown = Server.CountDown - 1;
			
			if Server.CountDownType ~= SERVER_COUNTDOWN_NONE then
				if Server.CountDown <= 10 or Server.CountDown % 60 == 0 then
					local sType		= Server.CountDownType == SERVER_COUNTDOWN_SHUTDOWN and "Выключение" or "Рестарт";
					
				--	Player.Client().CFlowingText( ( "%s сервера через %d:%02d" ):format( sType, Server.CountDown % 3600 / 60, Server.CountDown % 60  ) );
				end
			
				if Server.CountDown == 0 then
					if Server.CountDownType == SERVER_COUNTDOWN_RESTART then
						this.Restart();
					elseif Server.CountDownType == SERVER_COUNTDOWN_SHUTDOWN then
						Server.Shutdown( "System timer" );
					end
				end
			end
		end
	end;
	
	Restart		= function()
		return resource.Restart() and getResourceFromName( "IRE_Client" ).Restart();
	end;
	
	Stop		= function()
		return resource.Stop() and getResourceFromName( "IRE_Client" ).Stop();
	end;
	
	static
	{
		Shutdown			= shutdown;
		SetConfigSetting	= setServerConfigSetting;
		GetConfigSetting	= getServerConfigSetting;
		SetFPSLimit			= setFPSLimit;
		GetFPSLimit			= getFPSLimit;
		GetVersion			= getVersion;
		GetPort				= getServerPort;
		GetHTTPPort			= getServerHttpPort;
		GetPassword			= getServerPassword;
		SetPassword			= setServerPassword;
		GetName				= getServerName;
		GetMaxPlayers		= getMaxPlayers;
		SetMaxPlayers		= setMaxPlayers;
		IsGlitchEnabled		= isGlitchEnabled;
		SetGlitchEnabled	= setGlitchEnabled;
	};
};