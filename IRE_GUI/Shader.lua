-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Shader
{
	PostGUI		= false;
	Technique	= "";

	Shader		= function( filepath, priority, maxDistance, layered, elementTypes )
		if type( filepath ) == "string" then
			local shader, technique = dxCreateShader( filepath, (float)(priority), (float)(maxDistance), (bool)(layered), elementTypes or "all" );
			
			this = shader( this );

			this.Technique = technique;
			
			return shader;
		end
	end;
	
	_Shader	= function()
		this.Destroy();
	end;
	
	Destroy					= function()
		return destroyElement( this );
	end;

	ApplyToWorldTexture		= function( ... )
		return engineApplyShaderToWorldTexture( this, ... );
	end;

	RemoveFromWorldTexture	= function( ... )
		return engineRemoveShaderFromWorldTexture( this, ... );
	end;

	SetValue				= function( ... )
		return dxSetShaderValue( this, ... );
	end;

	SetTessellation			= function( ... )
		return dxSetShaderTessellation( this, ... )
	end;

	SetTransform			= function( ... )
		return dxSetShaderTransform( this, ... );
	end;
	
	Draw					= function( x, y, width, height, rotation, rotationCenterOffsetX, rotationCenterOffsetY, color )
		return dxDrawImage( x, y, width, height, this, rotation or 0, rotationCenterOffsetX or 0, rotationCenterOffsetY or 0, color or -1, this.PostGUI );
	end;
};