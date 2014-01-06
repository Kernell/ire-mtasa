-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CClientShaderManager
{
	CClientShaderManager	= function( this )
		this.m_Shaders	=
		{
			GrayScale	= CClientShaderGrayScale();
			MotionBlur	= CClientShaderMotionBlur();
			CarPaint	= CClientShaderCarPaint();
		};		
	end;
	
	_CClientShaderManager	= function( this )
		delete ( this.m_Shaders.GrayScale );
		delete ( this.m_Shaders.MotionBlur );
		delete ( this.m_Shaders.CarPaint );
		
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
