-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CShaderHDR ( LuaBehaviour )
{
	Brightness			= 0.32;
	Contrast			= 2.24;
	
	ExtractThreshold	= 0.72;
	
	DownSampleSteps		= 2;
	GBlurHBloom			= 1.68;
	GBlurVBloom			= 1.52;
	
	BloomIntensity		= 0.94;
	BloomSaturation		= 1.66;
	BaseIntensity		= 0.94;
	BaseSaturation		= -0.38;
	
	LumSpeed			= 51;
	LumChangeAlpha		= 27;
	
	MultAmount			= 0.46;
	Mult				= 0.70;
	Add					= 0.10;
	ModExtraFrom		= 0.11;
	ModExtraTo			= 0.58;
	ModExtraMult		= 4;
	
	MulBlend			= 0.82;
	BloomBlend			= 0.25;
	
	Vignette			= 0.47;
	
	CShaderHDR		= function( this, pShaderManager )
		this.m_fScreenX				= pShaderManager.m_fScreenX;
		this.m_fScreenY				= pShaderManager.m_fScreenY;
		
		this.m_pRTPool				= RTPool();
		
		this.m_pScreen				= pShaderManager.m_pScreen;
		
		this.m_pContrastShader		= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/HDRContrast.fx" )
		this.m_pBloomCombineShader	= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/HDRBloomCombine.fx" )
		this.m_pBloomExtractShader	= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/HDRBloomExtract.fx" )
		this.m_pBlurHShader			= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/HDRBlurH.fx" )
		this.m_pBlurVShader			= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/HDRBlurV.fx" )
		this.m_pModulationShader	= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/HDRModulation.fx" )
		
		this.m_pLumTarget			= dxCreateRenderTarget( 1, 1 );
		
		this.m_iNextLumSampleTime	= 0;
		
		this.m_pTextureVignette		= pShaderManager.Textures[ "vignette1" ];
		
		this:LuaBehaviour();
	end;
	
	_CShaderHDR		= function( this )
		this:_LuaBehaviour();
		
		delete ( this.m_pRTPool )
		
		delete ( this.m_pContrastShader );
		delete ( this.m_pBloomCombineShader );
		delete ( this.m_pBloomExtractShader );
		delete ( this.m_pBlurHShader );
		delete ( this.m_pBlurVShader );
		delete ( this.m_pModulationShader );
		
		delete ( this.m_pLumTarget );
	end;
	
	OnRenderObject	= function( this )
		this.m_pRTPool:Init();
		
		local pCurrent1 = this.m_pScreen;
		local pCurrent2 = this.m_pScreen;
		
		pCurrent1 = this:ApplyModulation( pCurrent1, this.m_pLumTarget, this.MultAmount, this.Mult, this.Add, this.ModExtraFrom, this.ModExtraTo, this.ModExtraMult );
		pCurrent1 = this:ApplyContrast( pCurrent1, this.Brightness, this.Contrast );
		
		pCurrent2 = this:ApplyBloomExtract( pCurrent2, this.m_pLumTarget, this.ExtractThreshold );
		pCurrent2 = this:ApplyDownsampleSteps( pCurrent2, this.DownSampleSteps );
		pCurrent2 = this:ApplyGBlurH( pCurrent2, this.GBlurHBloom );
		pCurrent2 = this:ApplyGBlurV( pCurrent2, this.GBlurVBloom );
		pCurrent2 = this:ApplyBloomCombine( pCurrent2, pCurrent1, this.BloomIntensity, this.BloomSaturation, this.BaseIntensity, this.BaseSaturation );
		
		this:UpdateLumSource( pCurrent1, this.LumSpeed, this.LumChangeAlpha );
		
		dxSetRenderTarget();
		
		pCurrent1:Draw( 0, 0, this.m_fScreenX, this.m_fScreenY, 0, 0, 0, tocolor( 255, 255, 255, this.MulBlend * 255 ) );
		pCurrent2:Draw( 0, 0, this.m_fScreenX, this.m_fScreenY, 0, 0, 0, tocolor( 255, 255, 255, this.BloomBlend * 255 ) );
		
		this.m_pTextureVignette:Draw( 0, 0, this.m_fScreenX, this.m_fScreenY, 0, 0, 0, tocolor( 255, 255, 255, this.Vignette * 255 ) );
	end;
	
	ApplyBloomCombine	= function( this, pTexture, pBaseTexture, fBloomIntensity, fBloomSaturation, fBaseIntensity, fBaseSaturation )
		if not pTexture then
			return NULL;
		end
		
		local fSizeX, fSizeY = pBaseTexture:GetSize();
		
		local pRT	= this.m_pRTPool:GetUnused( fSizeX, fSizeY );
		
		dxSetRenderTarget( pRT, true );
		
		this.m_pBloomCombineShader:SetValue( "sBloomTexture", pTexture );
		this.m_pBloomCombineShader:SetValue( "sBaseTexture", pBaseTexture );
		this.m_pBloomCombineShader:SetValue( "sBloomIntensity", fBloomIntensity );
		this.m_pBloomCombineShader:SetValue( "sBloomSaturation", fBloomSaturation );
		this.m_pBloomCombineShader:SetValue( "sBaseIntensity", fBaseIntensity );
		this.m_pBloomCombineShader:SetValue( "sBaseSaturation", fBaseSaturation );
		
		this.m_pBloomCombineShader:Draw( 0, 0, fSizeX, fSizeY );
		
		return pRT;
	end;
	
	ApplyBloomExtract	= function( this, pTexture, pSceneLuminance, fBloomThreshold )
		if not pTexture then
			return NULL;
		end
		
		local fSizeX, fSizeY = pTexture:GetSize();
		
		local pRT	= this.m_pRTPool:GetUnused( fSizeX, fSizeY );
		
		dxSetRenderTarget( pRT, true ) 
		
		this.m_pBloomExtractShader:SetValue( "sBaseTexture", pTexture );
		this.m_pBloomExtractShader:SetValue( "sBloomThreshold", fBloomThreshold );
		this.m_pBloomExtractShader:SetValue( "sLumTexture", pSceneLuminance );
		
		this.m_pBloomExtractShader:Draw( 0, 0, fSizeX, fSizeY );
		
		return pRT;
	end;

	ApplyContrast		= function( this, pTexture, fBrightness, fContrast )
		if not pTexture then
			return NULL;
		end
		
		local fSizeX, fSizeY = pTexture:GetSize();
		
		local pRT	= this.m_pRTPool:GetUnused( fSizeX, fSizeY );
		
		dxSetRenderTarget( pRT );
		
		this.m_pContrastShader:SetValue( "sBaseTexture", pTexture );
		this.m_pContrastShader:SetValue( "sBrightness", fBrightness );
		this.m_pContrastShader:SetValue( "sContrast", fContrast );
		
		this.m_pContrastShader:Draw( 0, 0, fSizeX, fSizeY );
		
		return pRT;
	end;

	ApplyModulation		= function( this, pTexture, pLumTexture, fMultAmount, fMult, fAdd, fExtraFrom, fExtraTo, fExtraMult )
		if not pTexture then
			return NULL;
		end
		
		local fSizeX, fSizeY = pTexture:GetSize();
		
		local pRT	= this.m_pRTPool:GetUnused( fSizeX, fSizeY );
		
		dxSetRenderTarget( pRT );
		
		this.m_pModulationShader:SetValue( "sBaseTexture", pTexture );
		this.m_pModulationShader:SetValue( "sMultAmount", fMultAmount );
		this.m_pModulationShader:SetValue( "sMult", fMult );
		this.m_pModulationShader:SetValue( "sAdd", fAdd );
		this.m_pModulationShader:SetValue( "sLumTexture", pLumTexture );
		this.m_pModulationShader:SetValue( "sExtraFrom", fExtraFrom );
		this.m_pModulationShader:SetValue( "sExtraTo", fExtraTo );
		this.m_pModulationShader:SetValue( "sExtraMult", fExtraMult );
		
		this.m_pModulationShader:Draw( 0, 0, fSizeX, fSizeY );
		
		return pRT;
	end;

	ApplyResize			= function( this, pTexture, fSizeX, fSizeY )
		if not pTexture then
			return NULL;
		end
		
		local pRT = this.m_pRTPool:GetUnused( fSizeX, fSizeY );
		
		dxSetRenderTarget( pRT );
		
		pTexture:Draw( 0,  0, fSizeX, fSizeY );
		
		return pRT;
	end;

	ApplyDownsampleSteps	= function( this, pTexture, iSteps )
		if not pTexture then
			return NULL;
		end
		
		for i = 1, iSteps do
			pTexture = this:ApplyDownsample( pTexture );
		end
		
		return pTexture;
	end;

	ApplyDownsample		= function( this, pTexture )
		if not pTexture then
			return NULL;
		end
		
		local fSizeX, fSizeY = pTexture:GetSize();
		
		fSizeX = fSizeX / 2;
		fSizeY = fSizeY / 2;
		
		local pRT = this.m_pRTPool:GetUnused( fSizeX, fSizeY );
		
		if not pRT then
			return NULL;
		end
		
		dxSetRenderTarget( pRT );
		
		pTexture:Draw( 0, 0, fSizeX, fSizeY );
		
		return pRT;
	end;

	ApplyGBlurH			= function( this, pTexture, fBloom )
		if not pTexture then
			return NULL;
		end
		
		local fSizeX, fSizeY = pTexture:GetSize();
		
		local pRT = this.m_pRTPool:GetUnused( fSizeX, fSizeY );
		
		if not pRT then
			return NULL;
		end
		
		dxSetRenderTarget( pRT, true );
		
		this.m_pBlurHShader:SetValue( "tex0", pTexture );
		this.m_pBlurHShader:SetValue( "tex0size", fSizeX, fSizeY );
		this.m_pBlurHShader:SetValue( "bloom", fBloom );
		
		this.m_pBlurHShader:Draw( 0, 0,fSizeX, fSizeY );
		
		
		return pRT;
	end;

	ApplyGBlurV			= function( this, pTexture, fBloom )
		if not pTexture then
			return NULL;
		end
		
		local fSizeX, fSizeY = pTexture:GetSize();
		
		local pRT = this.m_pRTPool:GetUnused( fSizeX, fSizeY );
		
		if not pRT then
			return NULL;
		end
		
		dxSetRenderTarget( pRT, true );
		
		this.m_pBlurVShader:SetValue( "tex0", pTexture );
		this.m_pBlurVShader:SetValue( "tex0size", fSizeX, fSizeY );
		this.m_pBlurVShader:SetValue( "bloom", fBloom );
		
		this.m_pBlurVShader:Draw( 0, 0, fSizeX, fSizeY );
		
		return pRT;
	end;
	
	UpdateLumSource		= function( this, pTexture, iChangeRate, iAlpha )
		if not pTexture then
			return NULL;
		end
		
		iChangeRate = iChangeRate or 50;

		local fSizeX, fSizeY = pTexture:GetSize();

		local fSize = 1.0;
		
		while fSize < fSizeX / 2.0 or fSize < fSizeY / 2.0 do
			fSize = fSize * 2.0;
		end

		pTexture = this:ApplyResize( pTexture, fSize, fSize );
		
		while fSize > 1.0 do
			fSize = fSize / 2.0;
			
			pTexture = this:ApplyDownsample( pTexture, 2.0 );
		end

		if getTickCount() > this.m_iNextLumSampleTime then
			this.m_iNextLumSampleTime = getTickCount() + iChangeRate;
			
			dxSetRenderTarget( this.m_pLumTarget );
			
			pTexture:Draw( 0,  0, 1, 1, 0,0,0, tocolor( 255, 255, 255, iAlpha ) );
		end

		pTexture = this:ApplyResize( this.m_pLumTarget, 1.0, 1.0 );

		return this.m_pLumTarget;
	end;
};