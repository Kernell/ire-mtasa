-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "Android.UI.Color"
{
	A	= 255;
	R	= 255;
	G	= 255;
	B	= 255;
	
	ToArgb	= function( this )
		return tocolor( this.R, this.G, this.B, this.A );
	end;
	
	static
	{
		FromArgb = function( ... )
			local Args = { ... };
			local n	= table.getn( Args );
			
			local pColor = Android.UI.Color();
			
			if n == 1 then
			-- public static Color FromArgb( int rgb );
				pColor.R = bitExtract( Args[ 1 ], 16, 8 );
				pColor.G = bitExtract( Args[ 1 ], 8, 8 );
				pColor.B = bitExtract( Args[ 1 ], 0, 8 );
			elseif n == 2 then
			-- public static Color FromArgb( int alpha, Color baseColor );
				pColor.A	= Args[ 1 ];
				pColor.R	= Args[ 2 ].R;
				pColor.G	= Args[ 2 ].G;
				pColor.B	= Args[ 2 ].B;
			elseif n == 3 then
			-- public static Color FromArgb( int red, int green, int blue );
				pColor.R	= Args[ 1 ];
				pColor.G	= Args[ 2 ];
				pColor.B	= Args[ 3 ];
			elseif n == 4 then
			-- public static Color FromArgb( int alpha, int red, int green, int blue );
				pColor.A	= Args[ 1 ];
				pColor.R	= Args[ 2 ];
				pColor.G	= Args[ 3 ];
				pColor.B	= Args[ 4 ];
			end
			
			return pColor;
		end;
	};
};