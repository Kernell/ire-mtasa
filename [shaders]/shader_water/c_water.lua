--
-- c_water.lua
--

g_pShader	= NULL;

function Init()
	if getVersion ().sortable < "1.1.0" then
		return;
	end
	
	SetEnabled( getElementData( localPlayer, "Settings.Graphics.Shaders.Water" ) );
end

function Update()
	local r, g, b, a = getWaterColor();
	
	dxSetShaderValue( g_pShader, "sWaterColor", r / 255, g / 255, b / 255, a / 255 );
end

function SetEnabled( bEnabled )
	if bEnabled then
		Start();
	else
		Stop();
	end
end

function Start()
	if g_pShader then
		return;
	end
	
	g_pShader = dxCreateShader( "water.fx" );
	
	if g_pShader then
		local textureVol	= dxCreateTexture( "images/smallnoise3d.dds" );
		local textureCube	= dxCreateTexture( "images/cube_env256.dds" );
		
		dxSetShaderValue( g_pShader, "sRandomTexture", 		textureVol );
		dxSetShaderValue( g_pShader, "sReflectionTexture", 	textureCube );
		
		engineApplyShaderToWorldTexture( g_pShader, "waterclear256" );
		
		setTimer( Update, 100, 0 );
	end
end

function Stop()
	if g_pShader then
		destroyElement( g_pShader );
	end
	
	g_pShader = NULL;
end

addEventHandler( "onClientResourceStart", resourceRoot, Init );
