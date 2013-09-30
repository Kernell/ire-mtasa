
-- c_car_reflect.lua
--
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

local scx, scy			= guiGetScreenSize();
local myScreenSource	= dxCreateScreenSource( scx, scy );

-- Create shader
local grunShader = dxCreateShader( "car_refgrun.fx", 1, Variables.renderDistance, false );
local geneShader = dxCreateShader( "car_refgene.fx", 1 ,Variables.renderDistance, true );
local shatShader = dxCreateShader( "car_refgene.fx", 1, Variables.renderDistance, true );

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		if getVersion().sortable < "1.3.0" then
			return;
		end

		if not grunShader or not geneShader or not shatShader then
			Debug( "Could not create shader", 1 );
			
			return;
		end
		
		for var, value in pairs( Variables ) do
			dxSetShaderValue( grunShader, var, value );
			dxSetShaderValue( geneShader, var, value );
			dxSetShaderValue( shatShader, var, value );
		end
		
		for var, value in pairs( VariablesGrun ) do
			dxSetShaderValue( grunShader, var, value );
		end
		
		for var, value in pairs( VariablesGene ) do
			dxSetShaderValue( geneShader, var, value );
		end
		
		for var, value in pairs( VariablesShat ) do
			dxSetShaderValue( shatShader, var, value );
		end
		
		-- Set textures
		local textureVol = dxCreateTexture( "images/smallnoise3d.dds" );
		
		dxSetShaderValue ( grunShader, "sRandomTexture", textureVol );
		dxSetShaderValue ( grunShader, "sReflectionTexture", myScreenSource );
		
		dxSetShaderValue ( geneShader, "gShatt", 0 );
		dxSetShaderValue ( geneShader, "sRandomTexture", textureVol );
		dxSetShaderValue ( geneShader, "sReflectionTexture", myScreenSource );
		
		dxSetShaderValue ( shatShader, "gShatt", 1 );
		dxSetShaderValue ( shatShader, "sRandomTexture", textureVol );
		dxSetShaderValue ( shatShader, "sReflectionTexture", myScreenSource );
		
		-- Apply to world texture
		engineApplyShaderToWorldTexture( grunShader, "vehiclegrunge256" );
		engineApplyShaderToWorldTexture( grunShader, "?emap*" );
		engineApplyShaderToWorldTexture( geneShader, "vehiclegeneric256" );
		engineApplyShaderToWorldTexture( shatShader, "vehicleshatter128" );

		engineApplyShaderToWorldTexture( geneShader, "hotdog92glass128" );
		
		--for one custom vehicle
		engineApplyShaderToWorldTexture( geneShader, "CHARGER_RT_HEADLIGHT_GLASS" );
		engineApplyShaderToWorldTexture( geneShader, "CHARGER_RT_GLASS" );
		engineApplyShaderToWorldTexture( geneShader, "WINDOW_GLASS" );
		engineApplyShaderToWorldTexture( geneShader, "bos_lights" );
		engineApplyShaderToWorldTexture( geneShader, "okoshko" );
		
		local texturegrun =
		{
			"predator92body128", "monsterb92body256a", "monstera92body256a", "andromeda92wing","fcr90092body128",
			"hotknifebody128b", "hotknifebody128a", "rcbaron92texpage64", "rcgoblin92texpage128", "rcraider92texpage128", 
			"rctiger92body128","rhino92texpage256", "petrotr92interior128","artict1logos","rumpo92adverts256","dash92interior128",
			"coach92interior128","combinetexpage128","hotdog92body256",
			"raindance92body128", "cargobob92body256", "andromeda92body", "at400_92_256", "nevada92body256",
			"polmavbody128a" , "sparrow92body128" , "hunterbody8bit256a" , "seasparrow92floats64" , 
			"dodo92body8bit256" , "cropdustbody256", "beagle256", "hydrabody256", "rustler92body256", 
			"shamalbody256", "skimmer92body128", "stunt256", "maverick92body128", "leviathnbody8bit256" 
		};
		
		for _, addList in ipairs( texturegrun ) do
			engineApplyShaderToWorldTexture( grunShader, addList );
		end
		
		addEventHandler( "onClientHUDRender", root, updateScreen );
	end
);

function updateScreen()
	if myScreenSource then
	   dxUpdateScreenSource( myScreenSource)
	end
end