-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CShaderGaussianBlur ( LuaBehaviour )
{
	m_iBlurRadius	= 7;
	m_fBlurAmount	= 2.0;
	
	CShaderGaussianBlur	= function( this, pShaderManager )
		this.m_fScreenX			= pShaderManager.m_fScreenX;
		this.m_fScreenY			= pShaderManager.m_fScreenY;
		
		this.m_fBufferX			= this.m_fScreenX / 2;
		this.m_fBufferY			= this.m_fScreenY / 2;
		
		this.m_pShader			= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/GaussianBlur.fx" );
		
		this.m_pScreen			= dxCreateScreenSource( this.m_fBufferX, this.m_fBufferY );
		
		this.m_pRenderTarget1	= dxCreateRenderTarget( this.m_fBufferX, this.m_fBufferY, false );
		this.m_pRenderTarget2	= dxCreateRenderTarget( this.m_fBufferX, this.m_fBufferY, false );
		
		this:ComputeKernel();
		this:ComputeOffsets();
		
		this:LuaBehaviour();
	end;
	
	_CShaderGaussianBlur	= function( this )
		this:_LuaBehaviour();
		
		delete ( this.m_pScreen );
		
		delete ( this.m_pRenderTarget1 );
		delete ( this.m_pRenderTarget2 );
		
		delete ( this.m_pShader );
	end;
	
	ComputeKernel		= function( this )
		local aKernel 			= {};
		local fSigma 			= this.m_iBlurRadius / this.m_fBlurAmount;
		
		local fTwoSigmaSquare 	= 2.0 * fSigma * fSigma;
		local fSigmaRoot 		= math.sqrt( fTwoSigmaSquare * math.pi );
		local fTotal 			= 0.0;
		
		for i = -this.m_iBlurRadius, this.m_iBlurRadius do
			local fDistance = i * i;
			local fValue	= math.exp( -fDistance / fTwoSigmaSquare ) / fSigmaRoot;
			
			table.insert( aKernel, fValue );
			
			fTotal = fTotal + fValue;
		end
		
		for i in pairs( aKernel ) do
			aKernel[ i ] = aKernel[ i ] / fTotal;
		end
		
		this.m_pShader:SetValue( "weights", aKernel );
	end;
	
	ComputeOffsets		= function( this )
		this.m_Offsets	=
		{
			H = {};
			V = {};
		};
		
		local fOffsetX 	= 1.0 / this.m_fBufferX;
		local fOffsetY 	= 1.0 / this.m_fBufferY;
		
		for i = -this.m_iBlurRadius, this.m_iBlurRadius do
			table.insert( this.m_Offsets.H, { i * fOffsetX, 0.0 } );
			table.insert( this.m_Offsets.V, { 0.0, i * fOffsetY } );
		end
	end;
	
	OnRenderObject		= function( this )
		dxUpdateScreenSource( this.m_pScreen );
		
		dxSetRenderTarget( this.m_pRenderTarget1 );
		
		this.m_pShader:SetValue( "ScreenTexture", this.m_pScreen );
		this.m_pShader:SetValue( "offsets", this.m_Offsets.H );
		
		this.m_pShader:Draw( 0, 0, this.m_fBufferX, this.m_fBufferY );
		
		dxSetRenderTarget( this.m_pRenderTarget2 );
		
		this.m_pShader:SetValue( "ScreenTexture", this.m_pRenderTarget1 );
		this.m_pShader:SetValue( "offsets", this.m_Offsets.V );
		
		this.m_pShader:Draw( 0, 0, this.m_fBufferX, this.m_fBufferY );
		
		dxSetRenderTarget();
		
		this.m_pShader:Draw( 0, 0, this.m_fScreenX, this.m_fScreenY );
	end;
};