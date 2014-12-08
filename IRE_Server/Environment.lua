-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. Environment : Manager
{
	MinuteDuration		= 15000;
	RealSync			= false;
	
	Hour				= NULL;
	Minute				= NULL;
	
	Day					= 1;
	Month				= 1;
	Year				= 2000;
	
	NextWeatherUpdate 	= 0;
	CloudsEnabled		= true;
	RandMin				= 300;
	RandMax				= 1800;
	
	static
	{
		Months				=
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
		
		Weathers =
		{
			0; -- Different Versions of Blue Skies / Clouds 
			1;
			2;
			3; 
			4;
			5;
			6;
			7;
			8; -- Stormy 
			9; -- Cloudy and Foggy 
			10; -- Clear Blue Sky 
			11; -- Scorching Hot (Los Santos heat waves) 
			12;
			13;
			14;
			15; -- Very Dull, Colourless, Hazy 
			16; -- Dull, Cloudy, Rainy 
			17;
			18; -- Scorching Hot 
		--	19; -- Sandstorm 
			20; -- Foggy, Greenish 
		--	21;
		--	22; -- Very dark, gradiented skyline, purple 
		--	23;
		--	24;
		--	25;
		--	26; -- Pale orange 
		--	27;
		--	28;
		--	29; -- Fresh blue 
		--	30;
		--	31;
		--	32; -- Dark, cloudy, teal 
		--	33; -- Dark, cloudy, brown 
		--	34; -- Blue/purple, regular 
		--	35; -- Dull brown 
		--	36;
		--	37;
		--	38; -- Bright, foggy, orange 
		--	39; -- Very bright 
		--	40;
		--	41;
		--	42; -- Blue/purple cloudy 
		--	43; -- Toxic clouds 
		--	44; -- Black/white sky 
		--	51;
		--	52;
		--	53; -- Amazing draw distance 
		--	150; -- Darkest weather ever 
		--	700; -- Stormy weather with pink sky and crystal water 
		};
	};
	
	Environment	= function()
		this.Manager();
		
		setMinuteDuration( this.MinuteDuration );
	end;
	
	SetTime			= function( hour, minute )
		this.Hour		= hour;
		this.Minute		= minute;
	end;
	
	SetWeather		= function( weatherID, blend, nextUpdate )
		this.WeatherID			= weatherID;
		this.NextWeatherUpdate	= nextUpdate or ( getRealTime().timestamp + math.random( this.RandMin, this.RandMax ) );
		
		if blend then
			setWeatherBlended( this.WeatherID );
		else
			setWeather( this.WeatherID );
		end
	end;
	
	SetMinuteDuration	= function( MinuteDuration )
		this.MinuteDuration = MinuteDuration;
		
		return setMinuteDuration( this.MinuteDuration );
	end;
	
	DoPulse		= function( realTime )
		if realTime.Second == 0 then
			local minute, hour;
			
			if this.RealSync then
				minute	= this.Minute	or realTime.Minute;
				hour	= this.Hour 	or realTime.Hour;
			else
				minute	= this.Minute	or ( ( Lerp( 0, 59 * 4, realTime.Minute / 59 ) % 60 ) + math.floor( Lerp( 0, 59 * 4, realTime.Second / 59 ) / 60 ) );
				hour	= this.Hour 	or ( ( Lerp( 0, 23 * 4, realTime.Hour / 23 ) % 24 ) + math.floor( Lerp( 0, 59 * 4, realTime.Minute / 59 ) / 60 ) );
			end
			
			local gameHour, gameMinute	= getTime();
			
			if gameHour ~= hour or gameMinute ~= minute then
				if _DEBUG then
					Debug( string.format( "%02d:%02d -> %02d:%02d", gameHour, gameMinute, hour, minute ) );
				end
				
				setTime( hour, minute );
				setMinuteDuration( this.RealSync and 60000 or this.MinuteDuration );
			end
			
			if this.RealSync then
				this.Day		= realTime.Day;
				this.Month		= realTime.Month;
			else
				if hour == 0 then		
					this.Day = this.Day + 1;
					
					if this.Day > Environment.Months[ this.Month ] then
						this.Day		= 1;
						this.Month		= this.Month + 1;
					
						if this.Month > table.getn( Environment.Months ) then
							this.Year		= this.Year + 1;
							this.Month		= 1;
						end
					end
				end
			end
		end
		
		if realTime.SSE >= this.NextWeatherUpdate then
			this.WeatherID			= Environment.Weathers[ math.random( table.getn( Environment.Weathers ) ) ];
			this.NextWeatherUpdate	= realTime.SSE + math.random( this.RandMin, this.RandMax );
			
			setWeatherBlended( this.WeatherID );
		end
	end;
};

