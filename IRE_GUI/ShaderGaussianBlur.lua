-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. ShaderGaussianBlur
{
	m_iBlurRadius	= 7;
	m_fBlurAmount	= 1.0;

	PostGUI			= false;
	
	ShaderGaussianBlur	= function()
		this.m_fScreenX			= Screen.Width;
		this.m_fScreenY			= Screen.Height;
		
		this.m_fBufferX			= this.m_fScreenX / 3.0;
		this.m_fBufferY			= this.m_fScreenY / 3.0;
		
		this.m_pShader			= new. Shader( "GaussianBlur.fx" );
		
		this.m_pScreen			= dxCreateScreenSource( this.m_fBufferX, this.m_fBufferY );
		
		this.m_pRenderTarget1	= dxCreateRenderTarget( this.m_fBufferX, this.m_fBufferY, false );
		this.m_pRenderTarget2	= dxCreateRenderTarget( this.m_fBufferX, this.m_fBufferY, false );
		this.m_pRenderTarget3	= dxCreateRenderTarget( this.m_fScreenX, this.m_fScreenY, false );
		
		this.ComputeKernel();
		this.ComputeOffsets();
		
		function this.__OnRenderObject()
			this.OnRenderObject();
		end
		
		addEventHandler( "onClientHUDRender", root, this.__OnRenderObject );
	end;
	
	_ShaderGaussianBlur	= function()
		removeEventHandler( "onClientHUDRender", root, this.__OnRenderObject );
		
		delete ( this.m_pScreen );
		
		delete ( this.m_pRenderTarget1 );
		delete ( this.m_pRenderTarget2 );
		delete ( this.m_pRenderTarget3 );
		
		delete ( this.m_pShader );
	end;
	
	ComputeKernel		= function()
		local aKernel 			= {};
		local fSigma 			= this.m_iBlurRadius / this.m_fBlurAmount;
		
		local fTwoSigmaSquare 	= fSigma * fSigma;
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
		
		this.m_pShader.SetValue( "weights", unpack( aKernel ) );
	end;
	
	ComputeOffsets		= function()
		this.m_Offsets	=
		{
			H = {};
			V = {};
		};
		
		local fOffsetX 	= 1.0 / this.m_fBufferX;
		local fOffsetY 	= 1.0 / this.m_fBufferY;
		
		for i = -this.m_iBlurRadius, this.m_iBlurRadius do
			table.insert( this.m_Offsets.H, i * fOffsetX );
			table.insert( this.m_Offsets.V, i * fOffsetY );
		end
		
		this.m_pShader.SetValue( "offsetsH", unpack( this.m_Offsets.H ) );
		this.m_pShader.SetValue( "offsetsV", unpack( this.m_Offsets.V ) );
	end;
	
	DrawSection			= function( left, top, width, height, left2, top2, widht2, height2 )
		dxDrawImageSection( left, top, width, height, left2, top2, widht2, height2, this.m_pRenderTarget3, 0, 0, 0, -1, this.PostGUI );
	end;

	OnRenderObject		= function()
		dxUpdateScreenSource( this.m_pScreen );
		
		dxSetRenderTarget( this.m_pRenderTarget1 );
		
		this.m_pShader.SetValue( "ScreenTexture", this.m_pScreen );
		this.m_pShader.SetValue( "offsets", true );
		
		this.m_pShader.Draw( 0, 0, this.m_fBufferX, this.m_fBufferY );
		
		dxSetRenderTarget( this.m_pRenderTarget2 );
		
		this.m_pShader.SetValue( "ScreenTexture", this.m_pRenderTarget1 );
		this.m_pShader.SetValue( "offsets", false );
		
		this.m_pShader.Draw( 0, 0, this.m_fBufferX, this.m_fBufferY );
		
		dxSetRenderTarget( this.m_pRenderTarget3 );
		
		this.m_pShader.Draw( 0, 0, this.m_fScreenX, this.m_fScreenY );
		
		dxSetRenderTarget();
	end;
};