-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software

class "Android.UI.Image" ( Android.UI.Control )
{
	Image	= function( this, pParent )
		this:Control( pParent );
	end;
	
	Load	= function( this, sFilename, sTextureFormat, bMipmaps, sTextureEdge )
		this.m_pElement = dxCreateTexture( sFilename, sTextureFormat or "argb", bMipmaps == NULL and true or bMipmaps, sTextureEdge or "wrap" );
	end;
	
	Clone	= function( this )
		local Image = Android.UI.Image();
			
		Image.m_pElement = cloneElement( this.m_pElement );
		
		return Image;
	end;
	
	Size	= function( this )
		return Android.UI.Size( dxGetMaterialSize( this.m_pElement ) );
	end;
	
	Draw	= function( this )
		dxDrawImage( this.X, this.Y, this.Width, this.Height, this.Image.m_pElement, 0, 0, 0, -1, this.PostGUI );
	end;
};