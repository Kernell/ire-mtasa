-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CShaderNormalMap
{
	m_Textures = 
	{
		WHEEL_TYRE	= { "WHEEL_TYRE_N", 	"WHEEL_TYRE_B" 	};
		BRAKEDISC	= { "BRAKEDISC_N", 		"BRAKEDISC_B" 	};
	};
	
	CShaderNormalMap		= function( this, pShaderManager )
		this.m_pShader	= {};
		
		for sWorldTex, Textures in pairs( this.m_Textures ) do
			local pShader		= CShader( "Shaders/D3D" + DIRECT3D_VERSION + "/NormalMap.fx", 0, 0, false, "all" );
			
			if pShader then
				local pNormalMap		= pShaderManager.Textures[ Textures[ 1 ] ];
				local pBumpMap			= pShaderManager.Textures[ Textures[ 2 ] ];
				
				pShader:SetValue( "BumpTexture", 	pNormalMap );
				pShader:SetValue( "NormalTexture", 	pBumpMap );
				
				pShader:ApplyToWorldTexture( sWorldTex );
				
				this.m_pShader[ sWorldTex ] = pShader;
			end
		end
	end;
	
	_CShaderNormalMap		= function( this )
		for sTex, pShader in pairs( this.m_pShader ) do
			delete ( pShader );
		end
		
		this.m_pShader = NULL;
	end;
};