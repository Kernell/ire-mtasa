-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CShaderDepthOfField ( LuaBehaviour )
{
	m_fBlurFactor			= 0.0012;
	m_fBlurDiv				= 5.2;
	m_fDepthFactor			= 0.002;
	
	CShaderDepthOfField		= function( this, pShaderManager )
		this.m_fScreenX				= pShaderManager.m_fScreenX;
		this.m_fScreenY				= pShaderManager.m_fScreenY;
		
		this.m_pScreen				= pShaderManager.m_pScreen;
		
		this.m_pRTPool				= RTPool();
		
		this.m_pBlurHShader			= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/DepthOfFieldBlurH.fx" );
		this.m_pBlurVShader			= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/DepthOfFieldBlurV.fx" );
		
		this:LuaBehaviour();
	end;
	
	_CShaderDepthOfField	= function( this )
		this:_LuaBehaviour();
		
		delete ( this.m_pRTPool );
		
		delete ( this.m_pBlurHShader );
		delete ( this.m_pBlurVShader );
	end;
	
	OnRenderObject			= function( this )
		this.m_pRTPool:Init();
		
		local pCurrentTexture = this.m_pScreen;
		
		pCurrentTexture	= this:ApplyBlurH( pCurrentTexture );
		pCurrentTexture	= this:ApplyBlurV( pCurrentTexture );
		
		dxSetRenderTarget();
		
		if pCurrentTexture then
			pCurrentTexture:Draw( 0, 0, this.m_fScreenX, this.m_fScreenY );
		end
	end;
	
	ApplyBlurH		= function( this, pTexture )
		if not pTexture then
			return;
		end
		
		local fSizeX, fSizeY	= pTexture:GetSize();
		local pRenderTarget		= this.m_pRTPool:GetUnused( fSizeX, fSizeY );
		
		if not pRenderTarget then
			return;
		end
		
		dxSetRenderTarget( pRenderTarget, true );
		
		this.m_pBlurHShader:SetValue( "TEX0", pTexture );
		this.m_pBlurHShader:SetValue( "gblurFactor", this.m_fBlurFactor );
		this.m_pBlurHShader:SetValue( "gDepthFactor", this.m_fDepthFactor );
		this.m_pBlurHShader:SetValue( "blurDiv", this.m_fBlurDiv );
		
		this.m_pBlurHShader:Draw( 0, 0, fSizeX, fSizeY );
		
		return pRenderTarget;
	end;
	
	ApplyBlurV		= function( this, pTexture )
		if not pTexture then
			return;
		end
		
		local fSizeX, fSizeY	= pTexture:GetSize();
		local pRenderTarget		= this.m_pRTPool:GetUnused( fSizeX, fSizeY );
		
		if not pRenderTarget then
			return;
		end
		
		dxSetRenderTarget( pRenderTarget, true );
		
		this.m_pBlurVShader:SetValue( "TEX0", pTexture );
		this.m_pBlurVShader:SetValue( "gblurFactor", this.m_fBlurFactor );
		this.m_pBlurVShader:SetValue( "gDepthFactor", this.m_fDepthFactor );
		this.m_pBlurVShader:SetValue( "blurDiv", this.m_fBlurDiv );
		
		this.m_pBlurVShader:Draw( 0, 0, fSizeX, fSizeY );
		
		return pRenderTarget;
	end;
};