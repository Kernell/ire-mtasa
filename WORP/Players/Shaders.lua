-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local InitShaders;

function InitShaders()
	local pColorShaderOrange	= dxCreateShader( "Resources/Shaders/tex_color.fx" );
	
	dxSetShaderValue( pColorShaderOrange, 	"Color", 3, 1, 0 );
	
	if pColorShaderOrange then
		engineApplyShaderToWorldTexture( pColorShaderOrange, "MISC_ON" );
		engineApplyShaderToWorldTexture( pColorShaderOrange, "CHARGER_RT_MISC_ON" );
	end
end

addEventHandler( "onClientResourceStart", resourceRoot, InitShaders );