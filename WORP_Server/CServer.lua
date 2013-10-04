-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

enum "eServerCountDown"
{
	SERVER_COUNTDOWN_NONE		= 0;
	SERVER_COUNTDOWN_SHUTDOWN	= 1;
	SERVER_COUNTDOWN_RESTART	= 2;
};

class: CServer
{
	m_iCountDown		= 0;
	m_iCountDownType	= SERVER_COUNTDOWN_NONE;

	CServer		= function( this )
		this.m_pGame = NULL;
	end;
	
	_CServer	= function( this )
		if this.m_pDoPulseTimer then
			this.m_pDoPulseTimer:Kill();
			this.m_pDoPulseTimer = NULL;
		end
		
		delete ( this.m_pGame );
		
		delete ( IPSMember.DB );
		delete ( g_pDB );
	end;
	
	Startup		= function( this )
		if not this.m_pGame then
			this.m_pGame = CGame();
			
			this.m_pDoPulseTimer = CTimer( 
				function()
					this:DoPulse();
				end, 1000, 0
			);
		end
	end;
	
	DoPulse		= function( this )
		if this.m_pGame then
			this.m_pGame:DoPulse();
		end
		
		if this.m_iCountDown > 0 then 
			this.m_iCountDown = this.m_iCountDown - 1;
			
			if this.m_iCountDownType ~= SERVER_COUNTDOWN_NONE then
				if this.m_iCountDown <= 10 or this.m_iCountDown % 60 == 0 then
					local sType		= this.m_iCountDownType == SERVER_COUNTDOWN_SHUTDOWN and "Выключение" or "Рестарт";
					
					CPlayer:Client().CFlowingText( ( "%s сервера через %d:%02d" ):format( sType, this.m_iCountDown % 3600 / 60, this.m_iCountDown % 60  ) );
				end
			
				if this.m_iCountDown == 0 then
					if this.m_iCountDownType == SERVER_COUNTDOWN_RESTART then
						this:Restart();
					elseif this.m_iCountDownType == SERVER_COUNTDOWN_SHUTDOWN then
						this:Shutdown( "System timer" );
					end
				end
			end
		end
	end;
	
	Print		= function( this, ... )
		local bResult, sMessage = pcall( string.format, ... );

		if not bResult then error( sMessage, 2 ) end
		
		return outputServerLog( sMessage );
	end;
	
	Restart		= function( this )
		return restartResource( resource ) and restartResource( getResourceFromName( "WORP" ) );
	end;
	
	Stop		= function( this )
		return stopResource( resource ) and stopResource( getResourceFromName( "WORP" ) );
	end;
	
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