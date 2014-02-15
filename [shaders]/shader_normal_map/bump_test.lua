local NormalList = 
{
	WHEEL_TYRE	= { "WHEEL_TYRE", 	"WHEEL_TYRE_N", 	"WHEEL_TYRE_B" 	};
	BRAKEDISC	= { "BRAKEDISC", 	"BRAKEDISC_N", 		"BRAKEDISC_B" 	};
};

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		for sWorldTex, Textures in pairs( NormalList ) do
			local pShader = dxCreateShader( "fx/bump3.fx" );
			
			if pShader then
				local pModelTexture		= dxCreateTexture( "tga/" .. Textures[ 1 ] .. ".jpg" );
				local pNormalMap		= dxCreateTexture( "tga/" .. Textures[ 2 ] .. ".jpg" );
				local pBumpMap			= dxCreateTexture( "tga/" .. Textures[ 3 ] .. ".jpg" );
				
				dxSetShaderValue( pShader, "DiffuseTexture", 	pModelTexture );
				dxSetShaderValue( pShader, "BumpTexture", 		pNormalMap );
				dxSetShaderValue( pShader, "NormalTexture", 	pBumpMap );
				
				engineApplyShaderToWorldTexture( pShader, sWorldTex );
			end
		end
	end
);