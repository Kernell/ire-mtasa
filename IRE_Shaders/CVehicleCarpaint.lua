-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CVehicleCarpaint ( LuaBehaviour )
{
	m_Textures =
	{
		"bos_main",
		"?emap*", "vehiclegrunge256",
		"predator92body128", "monsterb92body256a", "monstera92body256a", "andromeda92wing","fcr90092body128",
		"hotknifebody128b", "hotknifebody128a", "rcbaron92texpage64", "rcgoblin92texpage128", "rcraider92texpage128", 
		"rctiger92body128","rhino92texpage256", "petrotr92interior128","artict1logos","rumpo92adverts256","dash92interior128",
		"coach92interior128","combinetexpage128","hotdog92body256",
		"raindance92body128", "cargobob92body256", "andromeda92body", "at400_92_256", "nevada92body256",
		"polmavbody128a" , "sparrow92body128" , "hunterbody8bit256a" , "seasparrow92floats64" , 
		"dodo92body8bit256" , "cropdustbody256", "beagle256", "hydrabody256", "rustler92body256", 
		"shamalbody256", "skimmer92body128", "stunt256", "maverick92body128", "leviathnbody8bit256";
	};
	
	m_Variables =
	{
		sNorFac						= 2.5;
		sAdd 						= 0.5;
		sMul		 				= 1.5;
		sCutoff			 			= 0.16;
		sPower			 			= 2;
		sRefFl		 				= 1;
		sRefFlan			 		= 0.25;
		
		sProjectedXsize				= 0.5;
		sProjectedXvecMul			= 1;
		sProjectedXoffset			= -0.021;
		sProjectedYsize				= 0.5;
		sProjectedYvecMul			= 1;
		sProjectedYoffset			= -0.22;
		
		bumpSize 					= 0.02;
		brightnessFactor			= 0.081;
	};
	
	m_fRenderDistance	= 0.0;
	
	Start	= function( this )
		this:Setup();
		
		function this.__OnDataChange( sDataName, vOldValue )
			this:OnDataChange( sDataName, vOldValue );
		end
		
		addEventHandler( "onClientElementDataChange", this.m_pVehicle, this.__OnDataChange );
	end;
	
	Stop	= function( this )
		delete ( this.m_pShader );
		
		removeEventHandler( "onClientElementDataChange", this.m_pVehicle, this.__OnDataChange );
	end;
	
	OnDataChange	= function( this, sDataName, sOldValue )
		if sDataName == "RemapBody" then
			this:Setup();
		end
	end;
	
	Setup		= function( this )
		local sName 	= this.m_pVehicle:GetData( "RemapBody" );
		
		if sName then
			local sTexture		= "Vehicle-" + this.m_pVehicle:GetModel() + "-" + sName;
			
			if resourceRoot.m_pShaderManager.m_Textures[ sTexture ] then
				this.m_pColorTexture	= resourceRoot.m_pShaderManager.m_Textures[ sTexture ];
			else			
				local sTexturePath	= ":WORP/Resources/Textures/" + sTexture + ".png";
				
				if fileExists( sTexturePath ) then
					this.m_pColorTexture		= dxCreateTexture( sTexturePath );
					
					resourceRoot.m_pShaderManager.m_Textures[ sTexture ]	= this.m_pColorTexture;
				end
			end
		else
			this.m_pVehicle.m_pCarpaint:_LuaBehaviour();
			
			this.m_pVehicle.m_pCarpaint = NULL;
			
			return;
		end
		
		this.m_pShader		= CShader( "Shaders/D3D9/carpaint.fx", 0, this.m_fRenderDistance, false, "vehicle" );
		
		ASSERT( this.m_pShader );
		
		for var, value in pairs( this.m_Variables ) do
			this.m_pShader:SetValue( var, value );
		end
		
		if this.m_pColorTexture then
			this.m_pShader:SetValue( "sColorTexture", 		this.m_pColorTexture );
			this.m_pShader:SetValue( "bColorTextureLoaded", true );
		end
		
		this.m_pShader:SetValue( "sRandomTexture", 		resourceRoot.m_pShaderManager.Textures[ "smallnoise3d" );
		this.m_pShader:SetValue( "sReflectionTexture", 	resourceRoot.m_pShaderManager.m_pScreen );
		
		for _, sTexture in ipairs( this.m_Textures ) do
			this.m_pShader:ApplyToWorldTexture( sTexture, this.m_pVehicle );
		end
	end
};