-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

mon_full_names =
{
	"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
};

mon_full_names_ru =
{
	"Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"
};

mon_short_names = 
{
	"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
};

day_full_names = 
{
	"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
};

day_short_names =
{
	"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
};

local function english_suffix( iNumber )
	if iNumber >= 10 and iNumber <= 19 then
		return "th";
	else
		local i = iNumber % 10;
		
		if i == 1 then return "st"; end
		if i == 2 then return "nd"; end
		if i == 3 then return "rd"; end
	end
	
	return "th";
end

function days_in_month( y, m )
	return m ~= 2 and ( m % 2 + 30 ) or ( is_leap( y ) and 28 or 29 );
end

function is_leap( y )
	return not( y % 400 == 0 or y % 4 == 0 and y % 25 );
end

local gl_pCurrentTimezone = NULL;

function SetDefaultTimezone( sTimezoneID )
	gl_pCurrentTimezone = get_time_zone_info( sTimezoneID );
end

class: CDateTime
{
	ATOM	= "Y-m-d\TH:i:sP";
	COOKIE	= "l, d-M-y H:i:s T";
	ISO8601	= "Y-m-d\TH:i:sO";
	RFC822	= "D, d M y H:i:s O";
	RFC850	= "l, d-M-y H:i:s T";
	RFC1036	= "D, d M y H:i:s O";
	RFC1123	= "D, d M Y H:i:s O";
	RFC2822	= "D, d M Y H:i:s O";
	RFC3339	= "Y-m-d\TH:i:sP";
	RSS		= "D, d M Y H:i:s O";
	W3C		= "Y-m-d\TH:i:sP";
	
	CDateTime = function( self, iSeconds, sTimezoneID, bLocaltime )
		if not gl_pCurrentTimezone then
			error( "It is not safe to rely on the system's timezone settings. You are *required* to use the SetDefaultTimezone() function.", 2 );
		end
		
		self.m_pTimezoneInfo	= get_time_zone_info( sTimezoneID or gl_pCurrentTimezone.timezone_id );
		
		iSeconds		= ( iSeconds or getRealTime().timestamp ) - ( gl_pCurrentTimezone.offset - self.m_pTimezoneInfo.offset );
		
		self.m_pTime	= getRealTime( iSeconds );
		
		self.m_pTime.d			= self.m_pTime.monthday;
		self.m_pTime.m			= self.m_pTime.month + 1;
		self.m_pTime.y			= self.m_pTime.year + 1900;
		
		self.m_pTime.h			= self.m_pTime.hour;
		self.m_pTime.i			= self.m_pTime.minute;
		self.m_pTime.s			= self.m_pTime.second;
		
		self.m_pTime.sse		= self.m_pTime.timestamp;
		
		self.m_pTime.zone_type	= TIMELIB_ZONETYPE_ID;
		
		self.m_bLocaltime		= bLocaltime == NULL and true or (bool)(bLocaltime);
		
		self.m_pTime.z			= self.m_pTimezoneInfo.offset;
	end;
	
	Format = function( self, format )
		local t 		= self.m_pTime;
		local offset	= {};
		local buffer 	= "";
		
		if self.m_bLocaltime then
			if t.zone_type == TIMELIB_ZONETYPE_ABBR then
				offset.is_dst 		= t.isdst and 1 or 0;
				offset.offset 		= ( t.z - ( offset.is_dst * 60 ) ) * -60;
				offset.leap_secs 	= 0;
				offset.abbr 		= self.m_pTimezoneInfo.abbr:upper();
				
			elseif t.zone_type == TIMELIB_ZONETYPE_OFFSET then
				offset.is_dst 		= 0;
				offset.offset 		= t.z * -60;
				offset.leap_secs 	= 0;
				
				offset.abbr			= ( "GMT%c%02d%02d" ):format( 
					self.m_bLocaltime and ( ( offset.offset < 0 ) and '-' or '+') or '+',
					self.m_bLocaltime and math.abs( offset.offset / 3600 ) or 0,
					self.m_bLocaltime and math.abs( ( offset.offset % 3600 ) / 60 ) or 0
				);
			else
				offset		=
				{
					is_dst		= self.m_pTimezoneInfo.is_dst;
					offset		= self.m_pTimezoneInfo.offset;
					leap_secs	= self.m_pTimezoneInfo.leap_secs;
					abbr		= self.m_pTimezoneInfo.abbr;
				};
			end
		end
		
		local i 			= 1;
		local format_len 	= format:len();
		
		while i <= format_len do
			local rfc_colon = 0;
			local iChar 	= format[ i ];
			
			-- day
				if iChar == 'd' then buffer = buffer + ( "%02d" ):format( t.d );
			elseif iChar == 'D' then buffer = buffer + ( "%s" ):format( day_short_names[ t.weekday + 1 ] );
			elseif iChar == 'j' then buffer = buffer + ( "%d" ):format( t.d );
			elseif iChar == 'l' then buffer = buffer + ( "%s" ):format( day_full_names[ t.weekday + 1 ] );
			elseif iChar == 'S' then buffer = buffer + ( "%s" ):format( english_suffix( t.d ) );
			elseif iChar == 'w' then buffer = buffer + ( "%d" ):format( t.weekday );
			elseif iChar == 'N' then buffer = buffer + ( "%d" ):format( t.weekday + 1 );
			elseif iChar == 'z' then buffer = buffer + ( "%d" ):format( t.yearday );
			
			-- week
			elseif iChar == 'W' then buffer = buffer + ( "%02d" ):format( (int)(isoweek) );	-- TODO: /* iso weeknr */
			elseif iChar == 'o' then buffer = buffer + ( "%d" ):format( (int)(isoyear) );	-- TODO: /* iso year */
			
			-- month
			elseif iChar == 'F' then buffer = buffer + ( "%s" ):format( mon_full_names[ t.m ] );
			elseif iChar == 'f' then buffer = buffer + ( "%s" ):format( mon_full_names_ru[ t.m ] );
			elseif iChar == 'm' then buffer = buffer + ( "%02d" ):format( t.m );
			elseif iChar == 'M' then buffer = buffer + ( "%s" ):format( mon_short_names[ t.m ] );
			elseif iChar == 'n' then buffer = buffer + ( "%d" ):format( t.m );
			elseif iChar == 't' then buffer = buffer + ( "%d" ):format( days_in_month( t.y, t.m ) );
			
			-- year
			elseif iChar == 'L' then buffer = buffer + ( "%d" ):format( is_leap( t.y ) );
			elseif iChar == 'y' then buffer = buffer + ( "%02d" ):format( t.y % 100 );
			elseif iChar == 'Y' then buffer = buffer + ( "%04d" ):format( t.y );
			
			-- time
			elseif iChar == 'a' then buffer = buffer + ( "%s" ):format( t.h >= 12 and "pm" or "am");
			elseif iChar == 'A' then buffer = buffer + ( "%s" ):format( t.h >= 12 and "PM" or "AM");
			elseif iChar == 'B' then
				local iRetval = ( ( ( ( t.sse ) - ( ( t.sse ) - ( ( ( t.sse ) % 86400 ) + 3600 ) ) ) * 10 ) / 864 );		
				
				while iRetval < 0 do
					iRetval = iRetval + 1000;
				end
				
				iRetval = iRetval % 1000;
				
				buffer = buffer + ( "%03d" ):format( iRetval % 1000 );			
			elseif iChar == 'g' then buffer = buffer + ( "%d" ):format( t.h % 12 ~= 0 and t.h % 12 or 12 );
			elseif iChar == 'G' then buffer = buffer + ( "%d" ):format( t.h );
			elseif iChar == 'h' then buffer = buffer + ( "%02d" ):format( t.h % 12 ~= 0 and t.h % 12 or 12 );
			elseif iChar == 'H' then buffer = buffer + ( "%02d" ):format( t.h );
			elseif iChar == 'i' then buffer = buffer + ( "%02d" ):format( t.i );
			elseif iChar == 's' then buffer = buffer + ( "%02d" ):format( t.s );
--			elseif iChar == 'u' then buffer = buffer + ( "%06d" ):format( math.floor( t.f * 1000000 ) );
			
			-- timezone
			elseif iChar == 'I' then buffer = buffer + ( "%d" ):format( self.m_bLocaltime and offset.is_dst or 0 );
			elseif iChar == 'P' then
				rfc_colon = 1;
				
				buffer = buffer + ( "%s%02d%s%02d" ):format(
					self.m_bLocaltime 		and ( ( offset.offset < 0 ) and '-' or '+' ) or '+',
					self.m_bLocaltime 		and math.abs( offset.offset / 3600 ) or 0,
					rfc_colon ~= 0			and ":" or "",
					self.m_bLocaltime 		and math.abs( ( offset.offset % 3600 ) / 60 ) or 0
				);
			elseif iChar == 'O' then
				buffer = buffer + ( "%s%02d%s%02d" ):format(
					self.m_bLocaltime 		and ( ( offset.offset < 0 ) and '-' or '+' ) or '+',
					self.m_bLocaltime 		and math.abs( offset.offset / 3600 ) or 0,
					rfc_colon ~= 0			and ":" or "",
					self.m_bLocaltime 		and math.abs( ( offset.offset % 3600 ) / 60 ) or 0
				);
			elseif iChar == 'T' then buffer = buffer + ( "%s" ):format( self.m_bLocaltime and offset.abbr or "GMT" );
			elseif iChar == 'e' then
					if not self.m_bLocaltime then
						buffer = buffer + "UTC";
					else
						if t.zone_type == TIMELIB_ZONETYPE_ID then
							buffer = buffer + ( "%s" ):format( t.tz_info.name );
							
						elseif t.zone_type == TIMELIB_ZONETYPE_ABBR then
							buffer = buffer + ( "%s" ):format( offset.abbr );
							
						elseif t.zone_type == TIMELIB_ZONETYPE_OFFSET then
							buffer = buffer + ( "%c%02d:%02d" ):format( 
								( ( offset.offset < 0 ) and '-' or '+' ), 
								math.abs( offset.offset / 3600 ), 
								math.abs( ( offset.offset % 3600 ) / 60 )
							);
						end
					end
			elseif iChar == 'Z' then buffer = buffer + ( "%d" ):format( self.m_bLocaltime and offset.offset or 0 );
			
			-- full date/time
			elseif iChar == 'c' then
				buffer = buffer + ( "%04d-%02d-%02dT%02d:%02d:%02d%c%02d:%02d" ):format(
					t.y, t.m, t.d,
					t.h, t.i, t.s,
					self.m_bLocaltime and ( offset.offset < 0 and '-' or '+' ) or '+',
					self.m_bLocaltime and math.abs( offset.offset / 3600 ) or 0,
					self.m_bLocaltime and math.abs( ( offset.offset % 3600 ) / 60) or 0
				);			
			elseif iChar == 'r' then
				buffer = buffer + ( "%3s, %02d %3s %04d %02d:%02d:%02d %c%02d%02d" ):format(
					day_short_names[ t.d ],
					t.d, mon_short_names[ t.m ],
					t.y, t.h, t.i, t.s,
					self.m_bLocaltime and ( offset.offset < 0 and '-' or '+' ) or '+',
					self.m_bLocaltime and math.abs( offset.offset / 3600 ) or 0,
					self.m_bLocaltime and math.abs( ( offset.offset % 3600 ) / 60) or 0
				);			
			elseif iChar == 'U' then buffer = buffer + ( "%d" ):format( t.sse );
			elseif iChar == '\\' then
				if i <= format_len then
					i = i + 1;
				end
				
				buffer = buffer + format[ i ];
			else
				buffer = buffer + format[ i ];
			end
			
			i = i + 1;
		end
		
		return buffer;
	end;
	
	-- DateTime add ( DateInterval interval );
	-- DateTime sub ( DateInterval interval );
	-- DateInterval diff ( DateTime datetime2 [, bool absolute = false ] );
	-- string format ( string format );
	-- int GetOffset ( void );
	-- int GetTimestamp ( void );
	-- DateTime modify ( string modify );
	-- DateTime SetDate ( int year , int month , int $day );
	-- DateTime SetISODate ( int year , int week [, int day = 1 ] );
	-- DateTime SetTime ( int hour , int minute [, int second = 0 ] );
	-- DateTime SetTimestamp ( int unixtimestamp )
	-- DateTime SetTimezone ( DateTimeZone timezone );
};