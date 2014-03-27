-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CTimer
{
	CTimer		= function( this, vCallback, iInterval, iCount, ... )
		this.m_hTimer = setTimer( callback, interval, count or 0, ... );
	end;
	
	_CTimer		= function( this )
		this:Kill();
	end;
	
	Kill		= function( this )
		return killTimer( this.m_hTimer );
	end;
	
	GetDetails	= function( this )
		return getTimerDetails( this.m_hTimer );
	end;
};