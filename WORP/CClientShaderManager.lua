-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CClientShaderManager
{
	CClientShaderManager	= function( this )
		this.m_Shaders	= {};		
	end;
	
	Start	= function( this )
		-- if Settings.Graphics.Shaders.MotionBlur then
			this.m_Shaders.MotionBlur	= CClientShaderMotionBlur();
		-- end
		
		if Settings.Graphics.Shaders.CarReflect then
			this.m_Shaders.CarPaint	= CClientShaderCarPaint();
		end
		
		this.m_Shaders.GrayScale	= CClientShaderGrayScale();
		
		exports.IRE_Shaders:LoadSettings( Settings.Graphics.Shaders );
	end;
	
	Stop	= function( this )
		if this.m_Shaders.GrayScale		then delete ( this.m_Shaders.GrayScale ); end
		if this.m_Shaders.MotionBlur	then delete ( this.m_Shaders.MotionBlur ); end
		if this.m_Shaders.CarPaint		then delete ( this.m_Shaders.CarPaint ); end
		
		this.m_Shaders.GrayScale	= NULL;
		this.m_Shaders.MotionBlur	= NULL;
		this.m_Shaders.CarPaint		= NULL;
	end;
	
	_CClientShaderManager	= function( this )
		this.m_Shaders		= NULL;
	end;
	
	Get		= function( this, sID )
		return this.m_Shaders[ sID ];
	end;
};

function SetShader( sShaderID, bEnabled )
	local pClientShader = resourceRoot.m_pClientShaderManager:Get( sShaderID );
	
	if pClientShader then
		if bEnabled then
			if pClientShader.FadeIn then
				pClientShader:FadeIn();
			end
			
			pClientShader:AddRef();
		else
			if pClientShader.FadeOut then
				pClientShader:FadeOut( NULL, true );
			else
				pClientShader:Release();
			end
		end
	end
end

function SetShaderValue( sShaderID, sKey, ... )
	local pClientShader = resourceRoot.m_pClientShaderManager:Get( sShaderID );
	
	if pClientShader then
		pClientShader:SetValue( sKey, ... );
	end
end
