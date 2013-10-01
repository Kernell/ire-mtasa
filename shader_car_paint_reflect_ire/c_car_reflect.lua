local GrunTextures =
{
	"?emap*", "vehiclegrunge256",
	"predator92body128", "monsterb92body256a", "monstera92body256a", "andromeda92wing","fcr90092body128",
	"hotknifebody128b", "hotknifebody128a", "rcbaron92texpage64", "rcgoblin92texpage128", "rcraider92texpage128", 
	"rctiger92body128","rhino92texpage256", "petrotr92interior128","artict1logos","rumpo92adverts256","dash92interior128",
	"coach92interior128","combinetexpage128","hotdog92body256",
	"raindance92body128", "cargobob92body256", "andromeda92body", "at400_92_256", "nevada92body256",
	"polmavbody128a" , "sparrow92body128" , "hunterbody8bit256a" , "seasparrow92floats64" , 
	"dodo92body8bit256" , "cropdustbody256", "beagle256", "hydrabody256", "rustler92body256", 
	"shamalbody256", "skimmer92body128", "stunt256", "maverick92body128", "leviathnbody8bit256" 
};

local GeneralTextures	=
{
	"vehiclegeneric256", "hotdog92glass128", "CHARGER_RT_HEADLIGHT_GLASS", "CHARGER_RT_GLASS", "WINDOW_GLASS", "bos_lights"
};

Variables =
{
	renderDistance				= 100;		-- shader will be applied to textures nearer than this
	
	sNorFac						= 1.5;		-- the higher , the less normalised 0-2
	sAdd 						= 0.5;		-- before bright pass
	sMul		 				= 1.5;		-- multiply after brightpass
	sCutoff			 			= 0.16;		-- 0-1
	sPower			 			= 2;		-- 1-5
	sRefFl		 				= 1;		-- 0 or 1
	sRefFlan			 		= 0.25;		-- -1,1

	sProjectedXsize				= 0.5;
	sProjectedXvecMul			= 1;
	sProjectedXoffset			= -0.021;
	sProjectedYsize				= 0.5;
	sProjectedYvecMul			= 1;
	sProjectedYoffset			= -0.22;
};

VariablesGrun	=
{
	bumpSize 				= 0.02;		-- for car paint
	dirtTex		 			= 1; 		-- 0 or 1
	brightnessFactor		= 0.081;
};

VariablesGene	=
{
	bumpSize 				= 0.0;		-- for car paint
	brightnessFactor		= 0.49;
};

VariablesShat	=
{
	brightnessFactor		= 0.49;
};

local gl_pScreen	= dxCreateScreenSource( guiGetScreenSize() );

function Update()
	if gl_pScreen then
	   dxUpdateScreenSource( gl_pScreen );
	end
end

function Init()
	if getVersion().sortable < "1.3.0" then
		return;
	end
	
	local pGrunShader		= dxCreateShader( "car_refgrun.fx", 1, Variables.renderDistance, false );
	local pGeneralShader	= dxCreateShader( "car_refgene.fx", 1, Variables.renderDistance, true );
	local pShatShader		= dxCreateShader( "car_refgene.fx", 1, Variables.renderDistance, true );
	
	if not pGrunShader or not pGeneralShader or not pShatShader then
		Debug( "Could not create shader", 1 );
		
		return;
	end
	
	for var, value in pairs( Variables ) do
		dxSetShaderValue( pGrunShader, var, value );
		dxSetShaderValue( pGeneralShader, var, value );
		dxSetShaderValue( pShatShader, var, value );
	end
	
	for var, value in pairs( VariablesGrun ) do
		dxSetShaderValue( pGrunShader, var, value );
	end
	
	for var, value in pairs( VariablesGene ) do
		dxSetShaderValue( pGeneralShader, var, value );
	end
	
	for var, value in pairs( VariablesShat ) do
		dxSetShaderValue( pShatShader, var, value );
	end
	
	local pTexture = dxCreateTexture( "images/smallnoise3d.dds" );
	
	dxSetShaderValue( pGrunShader, "sRandomTexture", pTexture );
	dxSetShaderValue( pGrunShader, "sReflectionTexture", gl_pScreen );
	
	dxSetShaderValue( pGeneralShader, "gShatt", 0 );
	dxSetShaderValue( pGeneralShader, "sRandomTexture", pTexture );
	dxSetShaderValue( pGeneralShader, "sReflectionTexture", gl_pScreen );
	
	dxSetShaderValue( pShatShader, "gShatt", 1 );
	dxSetShaderValue( pShatShader, "sRandomTexture", pTexture );
	dxSetShaderValue( pShatShader, "sReflectionTexture", gl_pScreen );
	
	engineApplyShaderToWorldTexture( pShatShader, "vehicleshatter128" );
	
	for _, sTexture in ipairs( GeneralTextures ) do
		engineApplyShaderToWorldTexture( pGeneralShader, sTexture );
	end
	
	for _, sTexture in ipairs( GrunTextures ) do
		engineApplyShaderToWorldTexture( pGrunShader, sTexture );
	end
	
	addEventHandler( "onClientHUDRender", root, Update );
end

addEventHandler( "onClientResourceStart", resourceRoot, Init );