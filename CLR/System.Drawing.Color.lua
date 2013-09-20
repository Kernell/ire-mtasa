-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "System.Drawing.Color"
{
	-- Сводка:
	--     Получает значение альфа-компонента этой структуры System.Drawing.Color.
	--
	-- Возвращает:
	--     Значение альфа-компонента этой структуры System.Drawing.Color.
	A = 255;
	--
	-- Сводка:
	--     Получает значение красного компонента этой структуры System.Drawing.Color.
	--
	-- Возвращает:
	--     Значение красного компонента этой структуры System.Drawing.Color.
	R = 255;
	--
	-- Сводка:
	--     Получает значение зеленого компонента этой структуры System.Drawing.Color.
	--
	-- Возвращает:
	--     Значение зеленого компонента этой структуры System.Drawing.Color.
	G = 255;
	--
	-- Сводка:
	--     Получает значение синего компонента этой структуры System.Drawing.Color.
	--
	-- Возвращает:
	--     Значение синего компонента этой структуры System.Drawing.Color.
	B = 255;
	-- 
	-- Сводка:
	--     Возвращает 32-разрядное значение ARGB этой структуры System.Drawing.Color.
	--
	-- Возвращает:
	--     32-разрядное значение ARGB структуры System.Drawing.Color.
	ToArgb	= function( this )
		return tocolor( this.R, this.G, this.B, this.A );
	end;
	
	static
	{
		FromArgb = function( ... )
			local Args = { ... };
			local n	= table.getn( Args );
			
			local Color = System.Drawing.Color();
			
			if n == 1 then
			-- public static Color FromArgb( int argb );
				-- Color.A, Color.R, Color.G, Color.B = getColorFromString( ( "#%0x" ):format( Args[ 1 ] ) );
				
			--	Color.A = bitExtract( Args[ 1 ], 24, 8 );
				Color.R = bitExtract( Args[ 1 ], 16, 8 );
				Color.G = bitExtract( Args[ 1 ], 8, 8 );
				Color.B = bitExtract( Args[ 1 ], 0, 8 );
			elseif n == 2 then
			-- public static Color FromArgb( int alpha, Color baseColor );
				Color.A	= Args[ 1 ];
				Color.R	= Args[ 2 ].R;
				Color.G	= Args[ 2 ].G;
				Color.B	= Args[ 2 ].B;
			elseif n == 3 then
			-- public static Color FromArgb( int red, int green, int blue );
				Color.R	= Args[ 1 ];
				Color.G	= Args[ 2 ];
				Color.B	= Args[ 3 ];
			elseif n == 4 then
			-- public static Color FromArgb( int alpha, int red, int green, int blue );
				Color.A	= Args[ 1 ];
				Color.R	= Args[ 2 ];
				Color.G	= Args[ 3 ];
				Color.B	= Args[ 4 ];
			end
			
			return Color;
		end;
	};
};

System.Drawing.Color.AliceBlue				= System.Drawing.Color.FromArgb( 0xF0F8FF );
System.Drawing.Color.AntiqueWhite			= System.Drawing.Color.FromArgb( 0xFAEBD7 );
System.Drawing.Color.Aqua					= System.Drawing.Color.FromArgb( 0x00FFFF );
System.Drawing.Color.Aquamarine				= System.Drawing.Color.FromArgb( 0x7FFFD4 );
System.Drawing.Color.Azure					= System.Drawing.Color.FromArgb( 0xF0FFFF );
System.Drawing.Color.Beige					= System.Drawing.Color.FromArgb( 0xF5F5DC );
System.Drawing.Color.Bisque					= System.Drawing.Color.FromArgb( 0xFFE4C4 );
System.Drawing.Color.Black					= System.Drawing.Color.FromArgb( 0x000000 );
System.Drawing.Color.BlanchedAlmond			= System.Drawing.Color.FromArgb( 0xFFEBCD );
System.Drawing.Color.Blue					= System.Drawing.Color.FromArgb( 0x0000FF );
System.Drawing.Color.BlueViolet				= System.Drawing.Color.FromArgb( 0x8A2BE2 );
System.Drawing.Color.Brown					= System.Drawing.Color.FromArgb( 0xA52A2A );
System.Drawing.Color.BurlyWood				= System.Drawing.Color.FromArgb( 0xDEB887 );
System.Drawing.Color.CadetBlue				= System.Drawing.Color.FromArgb( 0x5F9EA0 );
System.Drawing.Color.Chartreuse				= System.Drawing.Color.FromArgb( 0x7FFF00 );
System.Drawing.Color.Chocolate				= System.Drawing.Color.FromArgb( 0xD2691E );
System.Drawing.Color.Coral					= System.Drawing.Color.FromArgb( 0xFF7F50 );
System.Drawing.Color.CornflowerBlue			= System.Drawing.Color.FromArgb( 0x6495ED );
System.Drawing.Color.Cornsilk				= System.Drawing.Color.FromArgb( 0xFFF8DC );
System.Drawing.Color.Crimson				= System.Drawing.Color.FromArgb( 0xDC143C );
System.Drawing.Color.Cyan					= System.Drawing.Color.FromArgb( 0x00FFFF );
System.Drawing.Color.DarkBlue				= System.Drawing.Color.FromArgb( 0x00008B );
System.Drawing.Color.DarkCyan				= System.Drawing.Color.FromArgb( 0x008B8B );
System.Drawing.Color.DarkGoldenrod			= System.Drawing.Color.FromArgb( 0xB8860B );
System.Drawing.Color.DarkGray				= System.Drawing.Color.FromArgb( 0xA9A9A9 );
System.Drawing.Color.DarkGreen				= System.Drawing.Color.FromArgb( 0x006400 );
System.Drawing.Color.DarkKhaki				= System.Drawing.Color.FromArgb( 0xBDB76B );
System.Drawing.Color.DarkMagenta			= System.Drawing.Color.FromArgb( 0x8B008B );
System.Drawing.Color.DarkOliveGreen			= System.Drawing.Color.FromArgb( 0x556B2F );
System.Drawing.Color.DarkOrange				= System.Drawing.Color.FromArgb( 0xFF8C00 );
System.Drawing.Color.DarkOrchid				= System.Drawing.Color.FromArgb( 0x9932CC );
System.Drawing.Color.DarkRed				= System.Drawing.Color.FromArgb( 0x8B0000 );
System.Drawing.Color.DarkSalmon				= System.Drawing.Color.FromArgb( 0xE9967A );
System.Drawing.Color.DarkSeaGreen			= System.Drawing.Color.FromArgb( 0x8FBC8F );
System.Drawing.Color.DarkSlateBlue			= System.Drawing.Color.FromArgb( 0x483D8B );
System.Drawing.Color.DarkSlateGray			= System.Drawing.Color.FromArgb( 0x2F4F4F );
System.Drawing.Color.DarkTurquoise			= System.Drawing.Color.FromArgb( 0x00CED1 );
System.Drawing.Color.DarkViolet				= System.Drawing.Color.FromArgb( 0x9400D3 );
System.Drawing.Color.DeepPink				= System.Drawing.Color.FromArgb( 0xFF1493 );
System.Drawing.Color.DeepSkyBlue			= System.Drawing.Color.FromArgb( 0x00BFFF );
System.Drawing.Color.DimGray				= System.Drawing.Color.FromArgb( 0x696969 );
System.Drawing.Color.DodgerBlue				= System.Drawing.Color.FromArgb( 0x1E90FF );
System.Drawing.Color.Firebrick				= System.Drawing.Color.FromArgb( 0xB22222 );
System.Drawing.Color.FloralWhite			= System.Drawing.Color.FromArgb( 0xFFFAF0 );
System.Drawing.Color.ForestGreen			= System.Drawing.Color.FromArgb( 0x228B22 );
System.Drawing.Color.Fuchsia				= System.Drawing.Color.FromArgb( 0xFF00FF );
System.Drawing.Color.Gainsboro				= System.Drawing.Color.FromArgb( 0xDCDCDC );
System.Drawing.Color.GhostWhite				= System.Drawing.Color.FromArgb( 0xF8F8FF );
System.Drawing.Color.Gold					= System.Drawing.Color.FromArgb( 0xFFD700 );
System.Drawing.Color.Goldenrod				= System.Drawing.Color.FromArgb( 0xDAA520 );
System.Drawing.Color.Gray					= System.Drawing.Color.FromArgb( 0x808080 );
System.Drawing.Color.Green					= System.Drawing.Color.FromArgb( 0x008000 );
System.Drawing.Color.GreenYellow			= System.Drawing.Color.FromArgb( 0xADFF2F );
System.Drawing.Color.Honeydew				= System.Drawing.Color.FromArgb( 0xF0FFF0 );
System.Drawing.Color.HotPink				= System.Drawing.Color.FromArgb( 0xFF69B4 );
System.Drawing.Color.IndianRed				= System.Drawing.Color.FromArgb( 0xCD5C5C );
System.Drawing.Color.Indigo					= System.Drawing.Color.FromArgb( 0x4B0082 );
System.Drawing.Color.Ivory					= System.Drawing.Color.FromArgb( 0xFFFFF0 );
System.Drawing.Color.Khaki					= System.Drawing.Color.FromArgb( 0xF0E68C );
System.Drawing.Color.Lavender				= System.Drawing.Color.FromArgb( 0xE6E6FA );
System.Drawing.Color.LavenderBlush			= System.Drawing.Color.FromArgb( 0xFFF0F5 );
System.Drawing.Color.LawnGreen				= System.Drawing.Color.FromArgb( 0x7CFC00 );
System.Drawing.Color.LemonChiffon			= System.Drawing.Color.FromArgb( 0xFFFACD );
System.Drawing.Color.LightBlue				= System.Drawing.Color.FromArgb( 0xADD8E6 );
System.Drawing.Color.LightCoral				= System.Drawing.Color.FromArgb( 0xF08080 );
System.Drawing.Color.LightCyan				= System.Drawing.Color.FromArgb( 0xE0FFFF );
System.Drawing.Color.LightGoldenrodYellow	= System.Drawing.Color.FromArgb( 0xFAFAD2 );
System.Drawing.Color.LightGray				= System.Drawing.Color.FromArgb( 0xD3D3D3 );
System.Drawing.Color.LightGreen				= System.Drawing.Color.FromArgb( 0x90EE90 );
System.Drawing.Color.LightPink				= System.Drawing.Color.FromArgb( 0xFFB6C1 );
System.Drawing.Color.LightSalmon			= System.Drawing.Color.FromArgb( 0xFFA07A );
System.Drawing.Color.LightSeaGreen			= System.Drawing.Color.FromArgb( 0x20B2AA );
System.Drawing.Color.LightSkyBlue			= System.Drawing.Color.FromArgb( 0x87CEFA );
System.Drawing.Color.LightSlateGray			= System.Drawing.Color.FromArgb( 0x778899 );
System.Drawing.Color.LightSteelBlue			= System.Drawing.Color.FromArgb( 0xB0C4DE );
System.Drawing.Color.LightYellow			= System.Drawing.Color.FromArgb( 0xFFFFE0 );
System.Drawing.Color.Lime					= System.Drawing.Color.FromArgb( 0x00FF00 );
System.Drawing.Color.LimeGreen				= System.Drawing.Color.FromArgb( 0x32CD32 );
System.Drawing.Color.Linen					= System.Drawing.Color.FromArgb( 0xFAF0E6 );
System.Drawing.Color.Magenta				= System.Drawing.Color.FromArgb( 0xFF00FF );
System.Drawing.Color.Maroon					= System.Drawing.Color.FromArgb( 0x800000 );
System.Drawing.Color.MediumAquamarine		= System.Drawing.Color.FromArgb( 0x66CDAA );
System.Drawing.Color.MediumBlue				= System.Drawing.Color.FromArgb( 0x0000CD );
System.Drawing.Color.MediumOrchid			= System.Drawing.Color.FromArgb( 0xBA55D3 );
System.Drawing.Color.MediumPurple			= System.Drawing.Color.FromArgb( 0x9370DB );
System.Drawing.Color.MediumSeaGreen			= System.Drawing.Color.FromArgb( 0x3CB371 );
System.Drawing.Color.MediumSlateBlue		= System.Drawing.Color.FromArgb( 0x7B68EE );
System.Drawing.Color.MediumSpringGreen		= System.Drawing.Color.FromArgb( 0x00FA9A );
System.Drawing.Color.MediumTurquoise		= System.Drawing.Color.FromArgb( 0x48D1CC );
System.Drawing.Color.MediumVioletRed		= System.Drawing.Color.FromArgb( 0xC71585 );
System.Drawing.Color.MidnightBlue			= System.Drawing.Color.FromArgb( 0x191970 );
System.Drawing.Color.MintCream				= System.Drawing.Color.FromArgb( 0xF5FFFA );
System.Drawing.Color.MistyRose				= System.Drawing.Color.FromArgb( 0xFFE4E1 );
System.Drawing.Color.Moccasin				= System.Drawing.Color.FromArgb( 0xFFE4B5 );
System.Drawing.Color.NavajoWhite			= System.Drawing.Color.FromArgb( 0xFFDEAD );
System.Drawing.Color.Navy					= System.Drawing.Color.FromArgb( 0x000080 );
System.Drawing.Color.OldLace				= System.Drawing.Color.FromArgb( 0xFDF5E6 );
System.Drawing.Color.Olive					= System.Drawing.Color.FromArgb( 0x808000 );
System.Drawing.Color.OliveDrab				= System.Drawing.Color.FromArgb( 0x6B8E23 );
System.Drawing.Color.Orange					= System.Drawing.Color.FromArgb( 0xFFA500 );
System.Drawing.Color.OrangeRed				= System.Drawing.Color.FromArgb( 0xFF4500 );
System.Drawing.Color.Orchid					= System.Drawing.Color.FromArgb( 0xDA70D6 );
System.Drawing.Color.PaleGoldenrod			= System.Drawing.Color.FromArgb( 0xEEE8AA );
System.Drawing.Color.PaleGreen				= System.Drawing.Color.FromArgb( 0x98FB98 );
System.Drawing.Color.PaleTurquoise			= System.Drawing.Color.FromArgb( 0xAFEEEE );
System.Drawing.Color.PaleVioletRed			= System.Drawing.Color.FromArgb( 0xDB7093 );
System.Drawing.Color.PapayaWhip				= System.Drawing.Color.FromArgb( 0xFFEFD5 );
System.Drawing.Color.PeachPuff				= System.Drawing.Color.FromArgb( 0xFFDAB9 );
System.Drawing.Color.Peru					= System.Drawing.Color.FromArgb( 0xCD853F );
System.Drawing.Color.Pink					= System.Drawing.Color.FromArgb( 0xFFC0CB );
System.Drawing.Color.Plum					= System.Drawing.Color.FromArgb( 0xDDA0DD );
System.Drawing.Color.PowderBlue				= System.Drawing.Color.FromArgb( 0xB0E0E6 );
System.Drawing.Color.Purple					= System.Drawing.Color.FromArgb( 0x800080 );
System.Drawing.Color.Red					= System.Drawing.Color.FromArgb( 0xFF0000 );
System.Drawing.Color.RosyBrown				= System.Drawing.Color.FromArgb( 0xBC8F8F );
System.Drawing.Color.RoyalBlue				= System.Drawing.Color.FromArgb( 0x4169E1 );
System.Drawing.Color.SaddleBrown			= System.Drawing.Color.FromArgb( 0x8B4513 );
System.Drawing.Color.Salmon					= System.Drawing.Color.FromArgb( 0xFA8072 );
System.Drawing.Color.SandyBrown				= System.Drawing.Color.FromArgb( 0xF4A460 );
System.Drawing.Color.SeaGreen				= System.Drawing.Color.FromArgb( 0x2E8B57 );
System.Drawing.Color.SeaShell				= System.Drawing.Color.FromArgb( 0xFFF5EE );
System.Drawing.Color.Sienna					= System.Drawing.Color.FromArgb( 0xA0522D );
System.Drawing.Color.Silver					= System.Drawing.Color.FromArgb( 0xC0C0C0 );
System.Drawing.Color.SkyBlue				= System.Drawing.Color.FromArgb( 0x87CEEB );
System.Drawing.Color.SlateBlue				= System.Drawing.Color.FromArgb( 0x6A5ACD );
System.Drawing.Color.SlateGray				= System.Drawing.Color.FromArgb( 0x708090 );
System.Drawing.Color.Snow					= System.Drawing.Color.FromArgb( 0xFFFAFA );
System.Drawing.Color.SpringGreen			= System.Drawing.Color.FromArgb( 0x00FF7F );
System.Drawing.Color.SteelBlue				= System.Drawing.Color.FromArgb( 0x4682B4 );
System.Drawing.Color.Tan					= System.Drawing.Color.FromArgb( 0xD2B48C );
System.Drawing.Color.Teal					= System.Drawing.Color.FromArgb( 0x008080 );
System.Drawing.Color.Thistle				= System.Drawing.Color.FromArgb( 0xD8BFD8 );
System.Drawing.Color.Tomato					= System.Drawing.Color.FromArgb( 0xFF6347 );
System.Drawing.Color.Transparent			= System.Drawing.Color.FromArgb( 0, 255, 255, 255 );
System.Drawing.Color.Turquoise				= System.Drawing.Color.FromArgb( 0x40E0D0 );
System.Drawing.Color.Violet					= System.Drawing.Color.FromArgb( 0xEE82EE );
System.Drawing.Color.Wheat					= System.Drawing.Color.FromArgb( 0xF5DEB3 );
System.Drawing.Color.White					= System.Drawing.Color.FromArgb( 0xFFFFFF );
System.Drawing.Color.WhiteSmoke				= System.Drawing.Color.FromArgb( 0xF5F5F5 );
System.Drawing.Color.Yellow					= System.Drawing.Color.FromArgb( 0xFFFF00 );
System.Drawing.Color.YellowGreen			= System.Drawing.Color.FromArgb( 0x9ACD32 );
