-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CShaderWater ( LuaBehaviour )
{
	CShaderWater	= function( this, pShaderManager )
		this.m_pShader	= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/Water.fx" );
		
		this.m_pShader:SetValue( "sReflectionTexture", pShaderManager.Textures[ "cube_env256" ] );		
		this.m_pShader:SetValue( "sRandomTexture", pShaderManager.Textures[ "smallnoise3d" ] );
		
		this.m_pShader:ApplyToWorldTexture( "waterclear256" );
		
		this:LuaBehaviour();
	end;
	
	_CShaderWater	= function( this )
		this:_LuaBehaviour();
		
		delete ( this.m_pCubeMap );
		
		delete ( this.m_pShader );
	end;
};