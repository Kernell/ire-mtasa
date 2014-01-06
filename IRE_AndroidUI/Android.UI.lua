-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "Android.UI"
{
	THEME_HOLO_DARK		= 0x00000002;
	THEME_HOLO_LIGHT	= 0x00000003;
	ICON_EXT			= ".png";
	IMAGES_PATH			= "Resources/icons/";
};

class "Android.UI.Point"
{
	Point = function( this, fX, fY )
		this.X	= (int)(fX);
		this.Y	= (int)(fY);
	end
};

class "Android.UI.Size"
{
	Size = function( this, fWidth, fHeight )
		this.Width	= (int)(fWidth);
		this.Height	= (int)(fHeight);
	end
};

Settings		=
{
	Android		=
	{
		Theme	= Android.UI.THEME_HOLO_DARK;
	};
};s