-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local Texture			= {};
local Shader			= {};
local Remap	=
{
	[ 426 ]	= "RemapChargerBody";
	[ 560 ]	= "RemapEvoBody";
};

local InstallPaintjob, RemovePaintjob;

function InstallPaintjob( pVehicle )
	local sName 	= pVehicle:GetData( "RemapBody" );
	
	if sName then
		local iModel	= pVehicle:GetModel();
		local sPath		= "Resources/Textures/Vehicle-" + (string)(iModel) + "-" + (string)(sName) + ".png";
		
		if fileExists( sPath ) then
			if not Texture[ iModel ] then
				Texture[ iModel ] = {};
			end
			
			if not Texture[ iModel ][ sName ] then
				Texture[ iModel ][ sName ]	= dxCreateTexture( sPath );
			end
			
			if not Shader[ iModel ] then
				Shader[ iModel ] = {};
			end
			
			if not Shader[ iModel ][ sName ] then
				Shader[ iModel ][ sName ] = dxCreateShader( "Resources/Shaders/ReplaceTexture.fx" );
				
				dxSetShaderValue( Shader[ iModel ][ sName ], "Tex0", Texture[ iModel ][ sName ] );
			end
			
			engineApplyShaderToWorldTexture( Shader[ iModel ][ sName ], Remap[ iModel ] or "RemapVehicleBody", pVehicle, false );
			
			pVehicle.m_sPaintjob = sName;
			
			return true;
		else
			Debug( sPath, 2 );
		end
	end
	
	return false;
end

function RemovePaintjob( pVehicle )
	if pVehicle.m_sPaintjob then
		local iModel	= pVehicle:GetModel();
		
		if Shader[ iModel ] and Shader[ iModel ][ pVehicle.m_sPaintjob ] then
			engineRemoveShaderFromWorldTexture( Shader[ iModel ][ pVehicle.m_sPaintjob ], Remap[ iModel ] or "RemapVehicleBody", pVehicle );
		end
	end
	
	pVehicle.m_sPaintjob = NULL;
end

local function OnVehicleStreamIn()
	if source:type() == "vehicle" and not source.m_sPaintjob then
		InstallPaintjob( source );
	end
end

local function OnVehicleDataChange( sData, vOldValue )
	if sData == "RemapBody" and source:type() == "vehicle" then
		RemovePaintjob( source );
		InstallPaintjob( source );
	end
end

addEventHandler( "onClientElementStreamIn", CVehicle.m_pRoot, OnVehicleStreamIn );
addEventHandler( "onClientElementDataChange", CVehicle.m_pRoot, OnVehicleDataChange );