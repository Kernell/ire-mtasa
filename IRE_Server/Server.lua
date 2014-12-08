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
	
	CountDown		= 0;
	CountDownType	= SERVER_COUNTDOWN_NONE;
	
	Game			= NULL;
	DB				= NULL;
	DoPulseTimer	= NULL;
	
	Server		= function()
		local MySQLHost		= get "mysql.host";
		local MySQLUser		= get "mysql.user";
		local MySQLPass		= get "mysql.password";
		local MySQLDB		= get "mysql.dbname";
		
		DBPREFIX			= get "mysql.prefix";
		DBENGINE			= get "mysql.engine";
		
		this.DB			= new. MySQL( MySQLUser, MySQLPass, MySQLDB, MySQLHost );
		
		if not this.DB.Ping() then
			return cancelEvent( true );
		end

		_G.gDB		= this.DB;
		
		this.Console	= new. Console();
		this.Blowfish	= new. Blowfish( "576F726C644F66526F6C65506C6179426C6F77666973684B6579" );
		this.Game		= new. Game();
	end;
	
	_Server		= function()
		if this.DoPulseTimer then
			this.DoPulseTimer.Kill();
		end
		
		delete ( this.Game );
		delete ( this.DB );
		delete ( this.Blowfish );
		delete ( this.Console );
		
		this.Blowfish 		= NULL;
		this.Console 		= NULL;
		this.Game			= NULL;
		this.DB				= NULL;
		this.DoPulseTimer	= NULL;
	end;
	
	Startup		= function()
		this.Console.Initialize();
		
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
		if this.Game then
			this.Game.DoPulse();
		end
		
		if this.CountDown > 0 then 
			this.CountDown = this.CountDown - 1;
			
			if this.CountDownType ~= SERVER_COUNTDOWN_NONE then
				if this.CountDown <= 10 or this.CountDown % 60 == 0 then
					local sType		= this.CountDownType == SERVER_COUNTDOWN_SHUTDOWN and "Выключение" or "Рестарт";
					
				--	Player.Client().CFlowingText( ( "%s сервера через %d:%02d" ):format( sType, this.CountDown % 3600 / 60, this.CountDown % 60  ) );
				end
			
				if this.CountDown == 0 then
					if this.CountDownType == SERVER_COUNTDOWN_RESTART then
						this.Restart();
					elseif this.CountDownType == SERVER_COUNTDOWN_SHUTDOWN then
						Server.Shutdown( "System timer" );
					end
				end
			end
		end
	end;
	
	Restart		= function()
		return resource.Restart() and getResourceFromName( "WORP" ).Restart();
	end;
	
	Stop		= function()
		return resource.Stop() and getResourceFromName( "WORP" ).Stop();
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