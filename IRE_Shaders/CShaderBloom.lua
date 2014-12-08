-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CShaderBloom ( LuaBehaviour )
{
	m_fCutoff		= 0.08;
	m_fPower		= 1.88;
	m_fBloom		= 1.0;
	m_iColor		= tocolor( 204, 153, 130, 140 );
	
	CShaderBloom		= function( this, pShaderManager )
		this.m_fScreenX				= pShaderManager.m_fScreenX;
		this.m_fScreenY				= pShaderManager.m_fScreenY;
		
		this.m_pRTPool				= RTPool();
		
		-- this.m_pScreen				= dxCreateScreenSource( this.m_fScreenX, this.m_fScreenY );
		
		this.m_pScreen				= pShaderManager.m_pScreen;
		
		this.m_pAddBlendShader		= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/BloomAddBlend.fx" );
		this.m_pBrightPassShader	= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/BloomBrightPass.fx" );
		this.m_pBlurHShader			= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/BloomBlurH.fx" );
		this.m_pBlurVShader			= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/BloomBlurV.fx" );
		
		this:LuaBehaviour();
	end;
	
	_CShaderBloom		= function( this )
		this:_LuaBehaviour();
		
		-- delete ( this.m_pScreen );
		
		delete ( this.m_pRTPool );
		
		delete ( this.m_pBlurHShader );
		delete ( this.m_pBlurVShader );
		delete ( this.m_pBrightPassShader );
		delete ( this.m_pAddBlendShader );
	end;
	
	OnRenderObject			= function( this )
		-- dxUpdateScreenSource( this.m_pScreen );
		
		this.m_pRTPool:Init();
		
		local pCurrentTexture = this.m_pScreen;
		
		pCurrentTexture	= this:ApplyBrightPass( pCurrentTexture, this.m_fCutoff, this.m_fPower );
		pCurrentTexture	= this:ApplyDownsample( pCurrentTexture );
		pCurrentTexture	= this:ApplyDownsample( pCurrentTexture );
		pCurrentTexture	= this:ApplyGBlurH( pCurrentTexture, this.m_fBloom );
		pCurrentTexture	= this:ApplyGBlurV( pCurrentTexture, this.m_fBloom );
		
		dxSetRenderTarget();
		
		if pCurrentTexture then
			this.m_pAddBlendShader:SetValue( "TEX0", pCurrentTexture );
			
			this.m_pAddBlendShader:Draw( 0, 0, this.m_fScreenX, this.m_fScreenY, 0, 0, 0, this.m_iColor );
		end
	end;
	
	ApplyDownsample	= function( this, pTexture, iAmount )
		if not pTexture then
			return;
		end
		
		iAmount = iAmount or 2;
		
		local fSizeX, fSizeY = pTexture:GetSize();
		
		fSizeX = fSizeX / iAmount;
		fSizeY = fSizeY / iAmount;
		
		local pRenderTarget = this.m_pRTPool:GetUnused( fSizeX , fSizeY );
		
		if not pRenderTarget then
			return;
		end
		
		dxSetRenderTarget( pRenderTarget );
		
		pTexture:Draw( 0, 0, fSizeX, fSizeY );
		
		return pRenderTarget;
	end;
	
	ApplyGBlurH		= function( this, pTexture, fBloom )
		if not pTexture then
			return;
		end
		
		local fSizeX, fSizeY	= pTexture:GetSize();
		local pRenderTarget		= this.m_pRTPool:GetUnused( fSizeX , fSizeY );
		
		if not pRenderTarget then
			return;
		end
		
		dxSetRenderTarget( pRenderTarget, true );
		
		this.m_pBlurHShader:SetValue( "TEX0", pTexture );
		this.m_pBlurHShader:SetValue( "TEX0SIZE", fSizeX, fSizeY );
		this.m_pBlurHShader:SetValue( "BLOOM", fBloom );
		
		this.m_pBlurHShader:Draw( 0, 0, fSizeX, fSizeY );
		
		return pRenderTarget;
	end;
	
	ApplyGBlurV		= function( this, pTexture, fBloom )
		if not pTexture then
			return;
		end
		
		local fSizeX, fSizeY	= pTexture:GetSize();
		local pRenderTarget		= this.m_pRTPool:GetUnused( fSizeX , fSizeY );
		
		if not pRenderTarget then
			return;
		end
		
		dxSetRenderTarget( pRenderTarget, true );
		
		this.m_pBlurVShader:SetValue( "TEX0", pTexture );
		this.m_pBlurVShader:SetValue( "TEX0SIZE", fSizeX, fSizeY );
		this.m_pBlurVShader:SetValue( "BLOOM", fBloom );
		
		this.m_pBlurVShader:Draw( 0, 0, fSizeX, fSizeY );
		
		return pRenderTarget;
	end;
	
	ApplyBrightPass		= function( this, pTexture, fCutoff, fPower )
		if not pTexture then
			return;
		end
		
		local fSizeX, fSizeY	= pTexture:GetSize();
		local pRenderTarget		= this.m_pRTPool:GetUnused( fSizeX , fSizeY );
		
		if not pRenderTarget then
			return;
		end
		
		dxSetRenderTarget( pRenderTarget, true );
		
		this.m_pBrightPassShader:SetValue( "TEX0", pTexture );
		this.m_pBrightPassShader:SetValue( "CUTOFF", fCutoff );
		this.m_pBrightPassShader:SetValue( "POWER", fPower );
		
		this.m_pBrightPassShader:Draw( 0, 0, fSizeX, fSizeY );
		
		return pRenderTarget;
	end;
};