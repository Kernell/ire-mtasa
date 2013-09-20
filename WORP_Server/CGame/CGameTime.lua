-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CGameTime
{
	m_iMinuteDuration	= 15000;
	m_bReal				= false;
	m_iHour				= NULL;
	m_iMinute			= NULL;
	m_iDay				= 1;
	m_iMonth			= 1;
	m_iYear				= 2000;
	
	m_Month				=
	{
		31; -- Январь
		29; -- Февраль
		31; -- Март
		30; -- Аперль
		31; -- Май
		30; -- Июнь
		31; -- Июль
		31; -- Август
		30; -- Сентябрь
		31; -- Октябрь
		30; -- Ноябрь
		31; -- Декабрь
	};
};

function CGameTime:CGameTime()
	setMinuteDuration( self.m_iMinuteDuration );
end

function CGameTime:Set( iHour, iMinute )
	self.m_iHour	= iHour;
	self.m_iMinute	= iMinute;
end

function CGameTime:SetMinuteDuration( iMinuteDuration )
	if not self.m_bReal then
		self.m_iMinuteDuration = iMinuteDuration;
		
		return setMinuteDuration( self.m_iMinuteDuration );
	end
	
	return false;
end

function CGameTime:DoPulse( tReal )
	if tReal.second == 0 then
		local iMinute, iHour;
		
		if self.m_bReal then
			iMinute	= self.m_iMinute	or tReal.minute;
			iHour	= self.m_iHour 		or tReal.hour;
		else
			iMinute	= self.m_iMinute	or ( ( Lerp( 0, 59 * 4, tReal.minute / 59 ) % 60 ) + math.floor( Lerp( 0, 59 * 4, tReal.second / 59 ) / 60 ) );
			iHour	= self.m_iHour 		or ( ( Lerp( 0, 23 * 4, tReal.hour / 23 ) % 24 ) + math.floor( Lerp( 0, 59 * 4, tReal.minute / 59 ) / 60 ) );
		end
		
		local iGameHour, iGameMinute2	= getTime();
		
		if iGameHour ~= iHour or iGameMinute2 ~= iMinute then
			if _DEBUG then Debug( ( "%02d:%02d -> %02d:%02d" ):format( iGameHour, iGameMinute2, iHour, iMinute ) ) end
			
			setTime( iHour, iMinute );
			setMinuteDuration( self.m_bReal and 60000 or self.m_iMinuteDuration );
		end
		
		if self.m_bReal then
			self.m_iDay		= tReal.monthday;
			self.m_iMonth	= tReal.month + 1;
		else
			if iHour == 0 then		
				self.m_iDay = self.m_iDay + 1;
				
				if self.m_iDay > self.m_Month[ self.m_iMonth ] then
					self.m_iDay		= 1;
					self.m_iMonth	= self.m_iMonth + 1;
				
					if self.m_iMonth > table.getn( self.m_Month ) then
						self.m_iYear	= self.m_iYear + 1;
						self.m_iMonth	= 1;
					end
				end
			end
		end
	end
end