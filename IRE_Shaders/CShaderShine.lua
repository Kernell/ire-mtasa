-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CShaderShine ( LuaBehaviour )
{
	FixedUpdateRate		= 100;
	
	m_WorldTextures		=
	{
		"*",
	};
	
	m_fMaxEffectDistance	= 250.0;
	
	m_iDectectorPos		= 1.0;
	m_iDectectorScore	= 0.0;
	m_pDetectorList		=
	{
		{ X = -1, Y = -1, Status = 0 },
		{ X =  0, Y = -1, Status = 0 },
		{ X =  1, Y = -1, Status = 0 },
		
		{ X = -1, Y =  0, Status = 0 },
		{ X =  0, Y =  0, Status = 0 },
		{ X =  1, Y =  0, Status = 0 },
		
		{ X = -1, Y =  1, Status = 0 },
		{ X =  0, Y =  1, Status = 0 },
		{ X =  1, Y =  1, Status = 0 },
	};
	
	m_ShineDirections =
	{
		-- H   M    Direction x, y, z,                  sharpness,	brightness,	nightness
		{  0,  0,	-0.019183,	0.994869,	-0.099336,	4,			0.0,		1 },			-- Moon fade in start
		{  0, 30,	-0.019183,	0.994869,	-0.099336,	4,			0.25,		1 },			-- Moon fade in end
		{  3, 00,	-0.019183,	0.994869,	-0.099336,	4,			0.5,		1 },			-- Moon bright
		{  6, 30,	-0.019183,	0.994869,	-0.099336,	4,			0.5,		1 },			-- Moon fade out start
		{  6, 39,	-0.019183,	0.994869,	-0.099336,	4,			0.0,		0 },			-- Moon fade out end

		{  6, 40,	-0.914400,	0.377530,	-0.146093,	16,			0.0,		0 },			-- Sun fade in start
		{  6, 50,	-0.914400,	0.377530,	-0.146093,	16,			1.0,		0 },			-- Sun fade in end
		{  7,  0,	-0.891344,	0.377265,	-0.251386,	16,			1.0,		0 },			-- Sun
		{ 10,  0,	-0.678627,	0.405156,	-0.612628,	16,			0.5,		0 },			-- Sun
		{ 13,  0,	-0.303948,	0.490790,	-0.816542,	16,			0.5,		0 },			-- Sun
		{ 16,  0,	 0.169642,	0.707262,	-0.686296,	16,			0.5,		0 },			-- Sun
		{ 18,  0,	 0.380167,	0.893543,	-0.238859,	16,			0.5,		0 },			-- Sun
		{ 18, 30,	 0.398043,	0.911378,	-0.238859,	4,			1.0,		0 },			-- Sun
		{ 18, 53,	 0.360288,	0.932817,	-0.238859,	1,			1.5,		0 },			-- Sun fade out start
		{ 19, 00,	 0.360288,	0.932817,	-0.238859,	1,			0.0,		0 },			-- Sun fade out end

		{ 19, 01,	 0.360288,	0.932817,	-0.612628,	4,			0.0,		0 },			-- General fade in start
		{ 19, 30,	 0.360288,	0.932817,	-0.612628,	4,			0.5,		0 },			-- General fade in end
		{ 21, 00,	 0.360288,	0.932817,	-0.612628,	4,			0.5,		0 },			-- General fade out start
		{ 22, 09,	 0.360288,	0.932817,	-0.612628,	4,			0.0,		0 },			-- General fade out end

		{ 22, 10,	-0.744331,	0.663288,	-0.077591,	32,			0.0,		1 },			-- Star fade in start
		{ 22, 30,	-0.744331,	0.663288,	-0.077591,	32,			0.5,		1 },			-- Star fade in end
		{ 23, 50,	-0.744331,	0.663288,	-0.077591,	32,			0.5,		1 },			-- Star fade out start
		{ 23, 59,	-0.744331,	0.663288,	-0.077591,	32,			0.0,		1 },			-- Star fade out end
	};
	
	m_WeatherInfluence =
	{
		-- id   sun:size   :translucency  :bright      night:bright 
		{  0,       1,			0,			1,			1 },		-- Hot, Sunny, Clear
		{  1,       0.8,		0,			1,			1 },		-- Sunny, Low Clouds
		{  2,       0.8,		0,			1,			1 },		-- Sunny, Clear
		{  3,       0.8,		0,			0.8,		1 },		-- Sunny, Cloudy
		{  4,       1,			0,			0.2,		0 },		-- Dark Clouds
		{  5,       3,			0,			0.5,		1 },		-- Sunny, More Low Clouds
		{  6,       3,			1,			0.5,		1 },		-- Sunny, Even More Low Clouds
		{  7,       1,			0,			0.01,		0 },		-- Cloudy Skies
		{  8,       1,			0,			0,			0 },		-- Thunderstorm
		{  9,       1,			0,			0,			0 },		-- Foggy
		{  10,      1,			0,			1,			1 },		-- Sunny, Cloudy (2)
		{  11,      3,			0,			1,			1 },		-- Hot, Sunny, Clear (2)
		{  12,      3,			1,			0.5,		0 },		-- White, Cloudy
		{  13,      1,			0,			0.8,		1 },		-- Sunny, Clear (2)
		{  14,      1,			0,			0.7,		1 },		-- Sunny, Low Clouds (2)
		{  15,      1,			0,			0.1,		0 },		-- Dark Clouds (2)
		{  16,      1,			0,			0,			0 },		-- Thunderstorm (2)
		{  17,      3,			1,			0.8,		1 }, 		-- Hot, Cloudy
		{  18,      3,			1,			0.8,		1 },		-- Hot, Cloudy (2)
		{  19,      1,			0,			0,			0 },		-- Sandstorm
	};
	
	m_pLightDirection	= NULL;
	
	m_fFadeCurrent		= 0.0;
	
	m_pTime				= NULL;
	
	m_iMinuteStartTickCount	= 0;
	m_iMinuteEndTickCount	= 0;
	
	CShaderShine		= function( this, pShaderManager )
		this.m_fScreenX			= pShaderManager.m_fScreenX;
		this.m_fScreenY			= pShaderManager.m_fScreenY;
		
		this.m_pShader			= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/Shine.fx" );
		
		this:SetValue( "sStrength", 2.0 );
		this:SetValue( "sFadeEnd", this.m_fMaxEffectDistance );
		this:SetValue( "sFadeStart", this.m_fMaxEffectDistance / 2 );
		
		for i, sTex in ipairs( this.m_WorldTextures ) do
			this.m_pShader:ApplyToWorldTexture( sTex );
		end
		
		this.m_pLightDirection	= Vector3();
		
		this.m_pTime	=
		{
			Hour	= 0;
			Minute	= 0;
			Second	= 0;
		};
		
		this:LuaBehaviour();
	end;
	
	_CShaderShine		= function( this )
		this:_LuaBehaviour();
		
		delete ( this.m_pShader );
	end;
	
	SetValue			= function( this, ... )
		return this.m_pShader:SetValue( ... );
	end;
	
	OnRenderImage		= function( this )
		local iHour, iMinute	= getTime();
		
		local iSecond = 0;
		
		if iMinute ~= m_pTime.Minute then
			this.m_iMinuteStartTickCount = getTickCount();
			
			local fGameSpeed = Clamp( 0.01, getGameSpeed(), 10.0 );
			
			this.m_iMinuteEndTickCount = this.m_iMinuteStartTickCount + 1000 / fGameSpeed;
		end
		
		if this.m_iMinuteStartTickCount then
			local minFraction = UnlerpClamped( this.m_iMinuteStartTickCount, getTickCount(), this.m_iMinuteEndTickCount );
			
			iSecond = math.min( 59, math.floor( minFraction * 60 ) );
		end
		
		this.m_pTime.Hour	= iHour;
		this.m_pTime.Minute	= iMinute;
		this.m_pTime.Second	= iSecond;
	end;
	
	OnPreRender			= function( this, fDeltaTime )
		this:DetectNext();
		
		local fFadeTarget	= 0.0;
		
		if this.m_iDectectorPos > 0.0 then
			fFadeTarget		= 1.0;
		else
			fFadeTarget		= 0.0;
		end
		
		local fFadeDiff		= math.clamp( -fDeltaTime, fFadeTarget - this.m_fFadeCurrent, fDeltaTime );
		
		this.m_fFadeCurrent	= this.m_fFadeCurrent + fFadeDiff;
		
		this:SetValue( "sVisibility", this.m_fFadeCurrent );
	end;
	
	FixedUpdate			= function( this )
		this:UpdateDirection();
	end;
	
	UpdateDirection		= function( this )
		local fHoursNow = this.m_pTime.Hour + this.m_pTime.Minute / 60 + this.m_pTime.Second / 3600;
		
		for i, pDir in ipairs( this.m_ShineDirections ) do
			local fHoursTo = pDir[ 1 ] + pDir[ 2 ] / 60;
			
			if fHoursNow <= fHoursTo then
				local pDirPrev		= this.m_ShineDirections[ math.max( i - 1, 1 ) ];
				local fHoursFrom 	= pDirPrev[ 1 ] + pDirPrev[ 2 ] / 60;
				
				local f				= Unlerp( fHoursFrom, fHoursNow, fHoursTo );
				
				local fX 			= Lerp( pDirPrev[ 3 ], f, pDir[ 3 ] );
				local fY 			= Lerp( pDirPrev[ 4 ], f, pDir[ 4 ] );
				local fZ 			= Lerp( pDirPrev[ 5 ], f, pDir[ 5 ] );
				local fSharpness	= Lerp( pDirPrev[ 6 ], f, pDir[ 6 ] );
				local fBrightness	= Lerp( pDirPrev[ 7 ], f, pDir[ 7 ] );
				local fNightness	= Lerp( pDirPrev[ 8 ], f, pDir[ 8 ] );

				fSharpness, fBrightness = this:ApplyWeatherInfluence( fSharpness, fBrightness, fNightness );

				local fThresh = -0.128859;
				
				if fZ < fThresh then
					fZ = ( fZ - fThresh ) / 2.0 + fThresh;
				end
				
				this.m_pLightDirection.X	= fX;
				this.m_pLightDirection.Y	= fY;
				this.m_pLightDirection.Z	= fZ;
				
				this:SetValue( "sLightDir", fX, fY, fZ );
				this:SetValue( "sSpecularPower", fSharpness );
				this:SetValue( "sSpecularBrightness", fBrightness );
				
				break;
			end
		end
	end;
	
	DetectNext			= function( this )
		this.m_iDectectorPos	= ( this.m_iDectectorPos + 1 ) % table.getn( this.m_pDetectorList );
		
		local pDetector			= this.m_pDetectorList[ this.m_iDectectorPos + 1 ];
		
		local vecPosition		= CLIENT:GetPosition();
		
		vecPosition.X = vecPosition.X + pDetector.X;
		vecPosition.Y = vecPosition.Y + pDetector.Y;
		
		local vecEnd		= vecPosition - this.m_pLightDirection * 200;
		
		if pDetector.Status == 1 then
			this.m_iDectectorScore = this.m_iDectectorScore - 1;
		end
		
		pDetector.Status = vecPosition:IsLineOfSightClear( vecEnd, true, false, false ) and 1 or 0;
		
		if pDetector.Status == 1 then
			this.m_iDectectorScore = this.m_iDectectorScore + 1;
		end
		
		if this.m_iDectectorScore < 0 or this.m_iDectectorScore > 9 then
			Debug( "CShaderShine->m_iDectectorScore = " + tostring( this.m_iDectectorScore ) );
		end
		
		if false then
			dxDrawLine3D( vecPosition.X, vecPosition.Y, vecPosition.Z, vecEnd.X, vecEnd.Y, vecEnd.Z, pDetector.status == 1 and tocolor( 255, 0, 255 ) or tocolor( 255, 255, 0 ) );
		end
	end;
	
	ApplyWeatherInfluence	= function( this, fSharpness, fBrightness, fNightness )
		local iWeatherID		= math.min( getWeather(), table.getn( this.m_WeatherInfluence ) - 1 );
		
		local pWeatherInf		= this.m_WeatherInfluence[ iWeatherID + 1 ];
		local fSunSize			= pWeatherInf[ 2 ];
		local fSunTranslucency	= pWeatherInf[ 3 ];
		local fSunBright		= pWeatherInf[ 4 ];
		local fNightBright		= pWeatherInf[ 5 ];
		
		local fUseSize		  	= Lerp( fSunSize, fNightness, 1.0 );
		local useTranslucency 	= Lerp( fSunTranslucency, fNightness, 0.0 );
		local fUseBright	  	= Lerp( fSunBright, fNightness, fNightBright );

		fBrightness		= fBrightness * fUseBright;
		fSharpness		= fSharpness / fUseSize;

		return fSharpness, fBrightness;
	end
};