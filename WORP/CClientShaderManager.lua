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
		
		setElementData( CLIENT, "Settings.Graphics.Shaders.DepthOfField", 	Settings.Graphics.Shaders.DepthOfField, false );
		setElementData( CLIENT, "Settings.Graphics.Shaders.HDR", 			Settings.Graphics.Shaders.HDR, 			false );
		setElementData( CLIENT, "Settings.Graphics.Shaders.Bloom", 			Settings.Graphics.Shaders.Bloom, 		false );
		setElementData( CLIENT, "Settings.Graphics.Shaders.RadialBlur", 	Settings.Graphics.Shaders.RadialBlur, 	false );
		setElementData( CLIENT, "Settings.Graphics.Shaders.RoadShine3", 	Settings.Graphics.Shaders.RoadShine3, 	false );
		setElementData( CLIENT, "Settings.Graphics.Shaders.Water", 			Settings.Graphics.Shaders.Water, 		false );
		
		exports.shader_hdr:SetEnabled			( Settings.Graphics.Shaders.HDR );
		exports.shader_dof:SetEnabled			( Settings.Graphics.Shaders.DepthOfField );
		exports.shader_bloom:SetEnabled			( Settings.Graphics.Shaders.Bloom );
		exports.shader_radial_blur:SetEnabled	( Settings.Graphics.Shaders.RadialBlur );
		exports.shader_roadshine3:SetEnabled	( Settings.Graphics.Shaders.RoadShine3 );
		exports.shader_water:SetEnabled			( Settings.Graphics.Shaders.Water );
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
