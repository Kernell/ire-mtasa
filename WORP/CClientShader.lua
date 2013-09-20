-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CClientShader
{
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