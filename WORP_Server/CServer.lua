-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CServer"
{
	m_iShutDownCountdown	= 0;
	m_iRestartCountDown		= 0;
}

function CServer:CServer()
	self.m_pGame = NULL;
end

function CServer:_CServer()
	if self.m_pDoPulseTimer then
		self.m_pDoPulseTimer:Kill();
		self.m_pDoPulseTimer = NULL;
	end
	
	delete ( self.m_pGame );
	
	delete ( IPSMember.DB );
	delete ( g_pDB );
end

function CServer:Startup()
	if not self.m_pGame then
		self.m_pGame = CGame();
		
		self.m_pDoPulseTimer = CTimer( 
			function()
				self:DoPulse();
			end, 1000, 0
		);
	end
end

function CServer:SetRestartTimer( iSeconds )
	self.m_iShutDownCountdown	= 0;
	self.m_iRestartCountDown	= iSeconds;
end

function CServer:SetShutDownTimer( iSeconds )
	self.m_iShutDownCountdown	= iSeconds;
	self.m_iRestartCountDown	= 0;
end

function CServer:DoPulse()
	if self.m_iShutDownCountdown > 0 then 
		self.m_iShutDownCountdown = self.m_iShutDownCountdown - 1;
		
		if self.m_iShutDownCountdown == 0 then
			return self:Shutdown( 'System timer' );
		end
	elseif self.m_iRestartCountDown > 0 then
		self.m_iRestartCountDown = self.m_iRestartCountDown - 1;
		
		if self.m_iRestartCountDown == 0 then
			return self:Restart();
		end
	end
	
	if self.m_pGame then
		self.m_pGame:DoPulse();
	end
end

function CServer:SetConfigSetting( sName, sValue, bSave )
	return setServerConfigSetting( sName, sValue, bSave );
end

function CServer:GetConfigSetting( sName )
	return getServerConfigSetting( sName );
end

function CServer:SetFPSLimit( iFPS )
	return setFPSLimit( iFPS );
end

function CServer:GetFPSLimit()
	return getFPSLimit();
end

function CServer:Print( ... )
	local result, message = pcall( string.format, ... );

	if not result then error( message, 2 ) end
	
	return outputServerLog( message );
end

function CServer:Restart()
	return restartResource( resource ) and restartResource( getResourceFromName( "WORP" ) );
end

function CServer:Stop()
	return stopResource( resource ) and stopResource( getResourceFromName( "WORP" ) );
end

function CServer:Shutdown( sReason )
	return shutdown( sReason );
end

function CServer:GetVersion()
	return getVersion();
end

function CServer:GetPort()
	return getServerPort();
end

function CServer:GetHTTPPort()
	return getServerHttpPort();
end

function CServer:GetPassword()
	return getServerPassword();
end

function CServer:SetPassword( sPasswd )
	return setServerPassword( sPasswd );
end

function CServer:GetName()
	return getServerName();
end

function CServer:GetMaxPlayers()
	return getMaxPlayers();
end

function CServer:SetMaxPlayers( iMax )
	return setMaxPlayers( iMax );
end

function CServer:IsGlitchEnabled( sGlitchName )
	return isGlitchEnabled( sGlitchName );
end

function CServer:SetGlitchEnabled( sGlitchName )
	return setGlitchEnabled( sGlitchName );
end