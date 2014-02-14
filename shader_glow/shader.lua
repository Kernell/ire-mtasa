local Shader	=
{
	Glow	= dxCreateShader( "Glow.fx", 1, 0, false );
};


addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		if Shader.Glow then
			engineApplyShaderToWorldTexture( Shader.Glow, "WHELEN_LIGHT_ON" );
		end
	end
);