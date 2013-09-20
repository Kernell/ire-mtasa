// Innovation Roleplay Engine

// Author		Kernell
// Copyright	© 2011 - 2013
// License		Proprietary Software
// Version		1.0

#include "CGame.cs"

class CServer : IServer
{
	uint m_iShutDownCountdown	= 0;
	uint m_iRestartCountDown	= 0;
	
	void CServer()
	{
		this.m_pGame = CGame();
	}
	
	void ~CServer()
	{
		this.m_pGame = null;
		
		IPSMember::DB = null;
		g_pDB = null;
	}
	
	void SetRestartTimer( uint iSeconds )
	{
		this.m_iShutDownCountdown	= 0;
		this.m_iRestartCountDown	= iSeconds;
	}
	
	void SetShutDownTimer( uint iSeconds )
	{
		this.m_iShutDownCountdown	= iSeconds;
		this.m_iRestartCountDown	= 0;
	}
	
	void DoPulse()
	{
		if( this.m_pGame )
			this.m_pGame:DoPulse();
		
		if( this.m_iShutDownCountdown > 0 )
		{
			if( --this.m_iShutDownCountdown == 0 )
				this:Shutdown( "System timer" );
		}
		else if( this.m_iRestartCountDown > 0 )
		{
			if( --this.m_iRestartCountDown == 0 )
				this:Restart();
		}
	}
	
	// TODO: Inherit from IServer module interface
	
	// bool SetConfigSetting( string sName, string sValue, bool bSave )
	
	// string GetConfigSetting( string sName )
	
	// bool SetFPSLimit( uint iFPS )
	
	// uint GetFPSLimit()
	
	// void Print( ... )
	
	// void Restart()
	
	// void Stop()
	
	// void Shutdown( string sReason )
	
	// void GetVersion()
	
	// uint GetPort()
	
	// uint GetHTTPPort()
	
	// string GetPassword()
	
	// bool SetPassword( string sPasswd )
	
	// string GetName()
	
	// uint GetMaxPlayers()
	
	// bool SetMaxPlayers( uint iMax )
	
	// bool IsGlitchEnabled( string sGlitchName )
	
	// bool SetGlitchEnabled( string sGlitchName )
}