-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local Weathers =
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

class: CGameWeather
{
	m_iNextUpdate 		= 0;
	m_bCloudsEnabled	= true;
	m_iRandMin			= 300;
	m_iRandMax			= 1800;
};

function CGameWeather:CGameWeather()
	
end

function CGameWeather:DoPulse( tReal )
	if tReal.timestamp >= self.m_iNextUpdate then
		self.m_iWeather		= Weathers[ math.random( #Weathers ) ];
		self.m_iNextUpdate	= tReal.timestamp + math.random( self.m_iRandMin, self.m_iRandMax );
		
		setWeatherBlended( self.m_iWeather );
	end
end

function CGameWeather:Set( iWeather, bBlended, iNextUpdate )
	self.m_iWeather		= iWeather;
	self.m_iNextUpdate	= iNextUpdate or ( getRealTime().timestamp + math.random( self.m_iRandMin, self.m_iRandMax ) );
	
	if bBlended then
		setWeatherBlended( self.m_iWeather );
	else
		setWeather( self.m_iWeather );
	end
end