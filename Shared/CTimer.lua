-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CTimer"

function CTimer:CTimer( callback, interval, count, ... )
	self.__instance = setTimer( callback, interval, count or 0, ... );
	
	assert( self.__instance, "failed to create timer" );
end

function CTimer:_CTimer()
	self:Kill();
	self = NULL;
end

function CTimer:Kill()
	return killTimer( self.__instance );
end

function CTimer:GetDetails()
	return getTimerDetails( self.__instance );
end