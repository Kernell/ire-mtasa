local gl_iScreenX, gl_iScreenY 	= guiGetScreenSize();
-- local gl_pScreen 				= dxCreateScreenSource( gl_iScreenX, gl_iScreenY );


local RenderTarget	=
{
	-- Filter	= dxCreateRenderTarget( gl_iScreenX, gl_iScreenY );
	-- Blur	= dxCreateRenderTarget( gl_iScreenX, gl_iScreenY );
	Glow	= dxCreateRenderTarget( gl_iScreenX, gl_iScreenY );
};

local Shader	=
{
	Glow	= dxCreateShader( "Glow.fx", 0, 0, true );
};

function ProcessShader()
	if gl_pScreen then
		dxUpdateScreenSource( gl_pScreen );
		
		--[[ dxSetRenderTarget( RenderTarget.Glow ); ]]
		
		dxSetShaderValue( Shader.Glow, "pTexture0", gl_pScreen );
		
		dxDrawImage( 0, 0, gl_iScreenX / 2, gl_iScreenY / 2, Shader.Glow );
		
		-- dxSetRenderTarget();
	end
end

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		if Shader.Glow then
			dxSetShaderValue( Shader.Glow, "fMorphSize", 0.0, 0.0, 0.1 );
			
			engineApplyShaderToWorldTexture( Shader.Glow, "WHELEN_LIGHT_ON" );
		end
		
		-- addEventHandler( "onClientHUDRender", root, ProcessShader );
	end
);