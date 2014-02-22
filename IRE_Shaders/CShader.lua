-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

CreateShader	= dxCreateShader;

class: CShader
{
	CShader		= function( this, sFilepath, fPriority, fMaxDistance, bLayered, sElementTypes )
		if type( sFilepath ) == "string" then
			local pShader, sTechnique = CreateShader( sFilepath, (float)(fPriority), (float)(fMaxDistance), (bool)(bLayered), sElementTypes or "all" );
			
			pShader.m_sTechnique	= sTechnique;
			
			return pShader;
		end
	end;
	
	_CShader	= destroyElement;
	
	Destroy					= destroyElement;
	ApplyToWorldTexture		= engineApplyShaderToWorldTexture;
	RemoveFromWorldTexture	= engineRemoveShaderFromWorldTexture;
	SetValue				= dxSetShaderValue;
	SetTessellation			= dxSetShaderTessellation;
	SetTransform			= dxSetShaderTransform;
	
	Draw					= function( this, fX, fY, fWidth, fHeight, fRotation, fRotationCenterOffsetX, fRotationCenterOffsetY, iColor, bPostGUI )
		return dxDrawImage( fX, fY, fWidth, fHeight, this, fRotation or 0, fRotationCenterOffsetX or 0, fRotationCenterOffsetY or 0, iColor or -1, bPostGUI or false );
	end;
};