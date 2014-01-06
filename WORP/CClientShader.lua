-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CClientShader
{
	CClientShader		= function( this )
		assert( getVersion().sortable >= "1.3.0", "Invalid MTA version" );
	end;
	
	_CClientShader		= function( this )
		this:Release();
	end;
	
	SetValue	= function( this, sKey, vValue )
		this[ sKey ] = vValue;
	end;
	
	Process		= function( this )
		-- do nothing
	end;
	
	AddRef		= function( this )
		if not this._OnHUDRender then
			function this._OnHUDRender()
				this:Process();
			end
			
			return addEventHandler( "onClientHUDRender", root, this._OnHUDRender );
		end
		
		return false;
	end;
	
	Release		= function( this )
		if this._OnHUDRender then
			removeEventHandler( "onClientHUDRender", root, this._OnHUDRender );
			
			this._OnHUDRender	= NULL;
			
			return true;
		end
		
		return false;
	end;
};


class: CClientShaderGrayScale ( CClientShader )
{
	m_fScale 		= 0.0;
	m_fBrightness 	= 1.0;
	m_iTickEnd		= 0;
	m_iTime			= 5000;
	m_fFrom			= 0.0;
	m_fTo			= 1.0;
	
	CClientShaderGrayScale	= function( this )
		this:CClientShader();
		
		this.m_pShader			= CShader( "Resources/Shaders/grayscale.fx" );
		this.m_pScreenSource	= dxCreateScreenSource( g_iScreenX, g_iScreenY );
		
		this.m_pShader:SetValue( "TargetTexture", this.m_pScreenSource );
	end;
	
	_CClientShaderGrayScale	= function( this )
		this:_CClientShader();
		
		destroyElement( this.m_pScreenSource );
		delete ( this.m_pShader );
		
		this.m_pScreenSource	= NULL;
		this.m_pShader			= NULL;
	end;
	
	FadeIn		= function( this, iTime )
		this.m_iTime		= iTime or CClientShaderGrayScale.m_iTime;
		this.m_fFrom		= this.m_fScale;
		this.m_fTo			= 1.0;
		this.m_iTickEnd		= getTickCount() + this.m_iTime;
	end;
	
	FadeOut		= function( this, iTime, bRelease )
		this.m_bRelease		= (bool)(bRelease);
		this.m_iTime		= iTime or CClientShaderGrayScale.m_iTime;
		this.m_fFrom		= this.m_fScale;
		this.m_fTo			= 0.0;
		this.m_iTickEnd		= getTickCount() + this.m_iTime;
	end;
	
	Process		= function( this )
		dxUpdateScreenSource( this.m_pScreenSource, true );
		
		local fProgress = 1 - ( this.m_iTickEnd - getTickCount() ) / this.m_iTime;
		
		this.m_fScale	= Lerp( this.m_fFrom, this.m_fTo, fProgress );
		
		this.m_pShader:SetValue( "fScale", this.m_fScale );
		this.m_pShader:SetValue( "fBrightness", this.m_fBrightness - ( this.m_fScale * 0.5 ) );
		
		this.m_pShader:Draw( 0, 0, g_iScreenX, g_iScreenY );
		
		if this.m_bRelease and fProgress >= 1.0 then
			this:Release();
			
			this.m_bRelease = false;
		end
	end;
};


class: CClientShaderMotionBlur ( CClientShader )
{
	CClientShaderMotionBlur		= function( this )
		this:CClientShader();
		
		this.m_pShader			= CShader( "Resources/Shaders/motionblur.fx" );
		this.m_pScreenSource	= dxCreateScreenSource( g_iScreenX, g_iScreenY );
		
		this.m_pShader:SetValue( "ScreenTexture", this.m_pScreenSource );
		
		this:AddRef();
	end;
	
	_CClientShaderMotionBlur	= function( this )
		this:_CClientShader();
		
		destroyElement( this.m_pScreenSource );
		delete ( this.m_pShader );
		
		this.m_pScreenSource	= NULL;
		this.m_pShader			= NULL;
	end;
	
	Process		= function( this )
		local fAlcohol = CLIENT:GetData( "alcohol" );
	
		if fAlcohol and fAlcohol > 0.0 then
			dxUpdateScreenSource( this.m_pScreenSource, true );
			
			this.m_pShader:SetValue( "BlurAmount", fAlcohol * 0.000025 );
			
			this.m_pShader:Draw( 0, 0, g_iScreenX, g_iScreenY );
		end
	end;
};

class: CClientShaderCarPaint ( CClientShader )
{
	static
	{
		m_GrunTextures =
		{
			"bos_main",
			"?emap*", "vehiclegrunge256",
			"predator92body128", "monsterb92body256a", "monstera92body256a", "andromeda92wing","fcr90092body128",
			"hotknifebody128b", "hotknifebody128a", "rcbaron92texpage64", "rcgoblin92texpage128", "rcraider92texpage128", 
			"rctiger92body128","rhino92texpage256", "petrotr92interior128","artict1logos","rumpo92adverts256","dash92interior128",
			"coach92interior128","combinetexpage128","hotdog92body256",
			"raindance92body128", "cargobob92body256", "andromeda92body", "at400_92_256", "nevada92body256",
			"polmavbody128a" , "sparrow92body128" , "hunterbody8bit256a" , "seasparrow92floats64" , 
			"dodo92body8bit256" , "cropdustbody256", "beagle256", "hydrabody256", "rustler92body256", 
			"shamalbody256", "skimmer92body128", "stunt256", "maverick92body128", "leviathnbody8bit256" 
		};
		
		m_GeneralTextures	=
		{
			"vehiclegeneric256", "hotdog92glass128", "CHARGER_RT_HEADLIGHT_GLASS", "CHARGER_RT_GLASS", "WINDOW_GLASS", "ENV_LIGHTS", "bos_lights"
		};
		
		m_Variables =
		{
			renderDistance				= 100;		-- shader will be applied to textures nearer than this
			
			sNorFac						= 1.5;		-- the higher , the less normalised 0-2
			sAdd 						= 0.5;		-- before bright pass
			sMul		 				= 1.5;		-- multiply after brightpass
			sCutoff			 			= 0.16;		-- 0-1
			sPower			 			= 2;		-- 1-5
			sRefFl		 				= 1;		-- 0 or 1
			sRefFlan			 		= 0.25;		-- -1,1

			sProjectedXsize				= 0.5;
			sProjectedXvecMul			= 1;
			sProjectedXoffset			= -0.021;
			sProjectedYsize				= 0.5;
			sProjectedYvecMul			= 1;
			sProjectedYoffset			= -0.22;
		};
		
		m_VariablesGrun	=
		{
			bumpSize 				= 0.02;		-- for car paint
			dirtTex		 			= 1; 		-- 0 or 1
			brightnessFactor		= 0.081;
		};
		
		m_VariablesGene	=
		{
			bumpSize 				= 0.0;		-- for car paint
			brightnessFactor		= 0.49;
		};
		
		m_VariablesShat	=
		{
			brightnessFactor		= 0.49;
		};
	};
	
	CClientShaderCarPaint	= function( this )
		this:CClientShader();
		
		this.m_pGrunShader		= CShader( "Resources/Shaders/car_refgrun.fx", 1, CClientShaderCarPaint.m_Variables.renderDistance, false, "vehicle" );
		this.m_pGeneralShader	= CShader( "Resources/Shaders/car_refgene.fx", 1, CClientShaderCarPaint.m_Variables.renderDistance, true, "vehicle" );
		this.m_pShatShader		= CShader( "Resources/Shaders/car_refgene.fx", 1, CClientShaderCarPaint.m_Variables.renderDistance, true, "vehicle" );
		
		assert( this.m_pGrunShader and this.m_pGeneralShader and this.m_pShatShader, "Could not create shader" );
		
		this.m_pScreenSource	= dxCreateScreenSource( g_iScreenX, g_iScreenY );
		
		for var, value in pairs( CClientShaderCarPaint.m_Variables ) do
			this.m_pGrunShader:SetValue( var, value );
			this.m_pGeneralShader:SetValue( var, value );
			this.m_pShatShader:SetValue( var, value );
		end
		
		for var, value in pairs( CClientShaderCarPaint.m_VariablesGrun ) do
			this.m_pGrunShader:SetValue( var, value );
		end
		
		for var, value in pairs( CClientShaderCarPaint.m_VariablesGene ) do
			this.m_pGeneralShader:SetValue( var, value );
		end
		
		for var, value in pairs( CClientShaderCarPaint.m_VariablesShat ) do
			this.m_pShatShader:SetValue( var, value );
		end
		
		this.m_pTexture = dxCreateTexture( "Resources/Textures/smallnoise3d.dds" );
		
		this.m_pGrunShader:SetValue( "sRandomTexture", this.m_pTexture );
		this.m_pGrunShader:SetValue( "sReflectionTexture", this.m_pScreenSource );
		
		this.m_pGeneralShader:SetValue( "gShatt", 0 );
		this.m_pGeneralShader:SetValue( "sRandomTexture", this.m_pTexture );
		this.m_pGeneralShader:SetValue( "sReflectionTexture", this.m_pScreenSource );
		
		this.m_pShatShader:SetValue( "gShatt", 1 );
		this.m_pShatShader:SetValue( "sRandomTexture", this.m_pTexture );
		this.m_pShatShader:SetValue( "sReflectionTexture", this.m_pScreenSource );
		
		this.m_pShatShader:ApplyToWorldTexture( "vehicleshatter128" );
		
		for _, sTexture in ipairs( CClientShaderCarPaint.m_GeneralTextures ) do
			this.m_pGeneralShader:ApplyToWorldTexture( sTexture );
		end
		
		for _, sTexture in ipairs( CClientShaderCarPaint.m_GrunTextures ) do
			this.m_pGrunShader:ApplyToWorldTexture( sTexture );
		end
		
		this:AddRef();
	end;
	
	_CClientShaderCarPaint	= function( this )
		this:_CClientShader();
		
		destroyElement( this.m_pScreenSource );
		
		delete ( this.m_pGrunShader );
		delete ( this.m_pGeneralShader );
		delete ( this.m_pShatShader );
		
		this.m_pScreenSource	= NULL;
		this.m_pGrunShader		= NULL;
		this.m_pGeneralShader	= NULL;
		this.m_pShatShader		= NULL;
	end;
	
	Process		= function( this )
		dxUpdateScreenSource( this.m_pScreenSource );
	end;
};
