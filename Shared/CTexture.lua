-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

ASSERT( CLIENT, "This script is client-side only" );

class: CTexture
{
	_CTexture			= destroyElement;
	
	Destroy				= destroyElement;
	
	GetSize				= dxGetMaterialSize;
	
	SetPixels			= function( this, sPixels, iSurfaceIndex, ... )
		return dxSetTexturePixels( iSurfaceIndex or 0, this, sPixels, ... );
	end;
	
	GetPixels			= function( this, iSurfaceIndex, ... )
		return dxSetTexturePixels( iSurfaceIndex or 0, this, ... );
	end;
	
	Draw				= function( this, fX, fY, fWidth, fHeight, fRotation, fRotationCenterOffsetX,  fRotationCenterOffsetY, iColor, bPostGUI )
		return dxDrawImage( fX, fY, fWidth, fHeight, this, fRotation or 0, fRotationCenterOffsetX or 0, fRotationCenterOffsetX or 0, iColor or -1, bPostGUI == true );
	end;
	
	DrawSection			= function( this, fX, fY, fWidth, fHeight, fU, fV, fUSize, fVSize, fRotation, fRotationCenterOffsetX,  fRotationCenterOffsetY, iColor, bPostGUI )
		return dxDrawImageSection( fX, fY, fWidth, fHeight, fU, fV, fUSize, fVSize, this, fRotation or 0, fRotationCenterOffsetX or 0, fRotationCenterOffsetX or 0, iColor or -1, bPostGUI == true );
	end;
	
	DrawLine3D			= function( this, fX, fY, fZ, fEndX, fEndY, fEndZ, fWidth, iColor, fFaceTowardX, fFaceTowardY, fFaceTowardZ )
		return dxDrawMaterialLine3D( fX, fY, fZ, fEndX, fEndY, fEndZ, this, fWidth, iColor, fFaceTowardX, fFaceTowardY, fFaceTowardZ );
	end;
	
	DrawSectionLine3D	= function( this, fX, fY, fZ, fEndX, fEndY, fEndZ, fU, fV, fUSize, fVSize, fWidth, iColor, fFaceTowardX, fFaceTowardY, fFaceTowardZ )
		return dxDrawMaterialSectionLine3D( fX, fY, fZ, fEndX, fEndY, fEndZ, fU, fV, fUSize, fVSize, this, fWidth, iColor, fFaceTowardX, fFaceTowardY, fFaceTowardZ );
	end;
};