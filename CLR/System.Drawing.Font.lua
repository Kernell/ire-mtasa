-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local FontRemap =
{
	[ "Segoe UI" ]				= "segoeui";
	[ "Microsoft Sans Serif" ]	= "micross";
};

local FontCache	= {};

-- Сводка:
--     Определяет конкретный формат текста, включая начертание шрифта, его размер
--     и атрибуты стиля. Этот класс не наследуется.
class "System.Drawing.Font"
{
	--
	-- Сводка:
	--     Инициализирует новый шрифт System.Drawing.Font, используя заданные размер,
	--     начертание, единицу и кодировку.
	--
	-- Параметры:
	--   family:
	--     Семейство шрифтов System.Drawing.FontFamily нового шрифта System.Drawing.Font.
	--
	--   emSize:
	--     Размер максимального пробела нового шрифта в единицах, указанных параметром
	--     unit.
	--
	--   style:
	--     Стиль System.Drawing.FontStyle нового шрифта.
	--
	--   unit:
	--     Единица System.Drawing.GraphicsUnit нового шрифта.
	--
	--   gdiCharSet:
	--     Объект System.Byte, определяющий набор знаков GDI, используемый для нового
	--     шрифта.
	--
	-- Исключения:
	--   System.ArgumentException:
	--     Параметр emSize меньше или равен нулю 0, равняется бесконечности или не является
	--     допустимым числом.
	--
	--   System.ArgumentNullException:
	--     Параметр family имеет значение null.
	Font	= function( this, familyName, emSize, style, unit )
		familyName = FontRemap[ familyName ] or familyName;
		
		local pxSize = 9;
		
		if unit == System.Drawing.GraphicsUnit.World then
			pxSize = (int)(emSize * 37.795275591);
		elseif unit == System.Drawing.GraphicsUnit.Display then
			pxSize = emSize;
		elseif unit == System.Drawing.GraphicsUnit.Pixel then
			pxSize = (int)(emSize);
		elseif unit == System.Drawing.GraphicsUnit.Point then
			pxSize = math.floor( emSize * 1.35 );
		elseif unit == System.Drawing.GraphicsUnit.Inch then
			pxSize = (int)(emSize * 96);
		elseif unit == System.Drawing.GraphicsUnit.Document then
			pxSize = (int)(emSize * 16);
		elseif unit == System.Drawing.GraphicsUnit.Millimeter then -- 72dpi
			pxSize = (int)(emSize * 3.779527559);
		end
		
		pxSize = Clamp( 6, pxSize, 72 );
		
		if not FontCache[ familyName ] then
			FontCache[ familyName ] = {};
		end
		
		if not FontCache[ familyName ][ pxSize ] then
			FontCache[ familyName ][ pxSize ] = {};
		end
		
		if not FontCache[ familyName ][ pxSize ][ style ] then
			local bBold = style == System.Drawing.FontStyle.Bold;
			local sPath = "Resources/Fonts/" + familyName + ".ttf";
			
			if bBold and fileExists( "Resources/Fonts/" + familyName + "b.ttf" ) then
				sPath = "Resources/Fonts/" + familyName + "b.ttf";
			end
			
			FontCache[ familyName ][ pxSize ][ style ] = dxCreateFont( sPath, pxSize, bBold );
		end
		
		return FontCache[ familyName ][ pxSize ][ style ];
	end;
};

-- Сводка:
--     Задает сведения о стиле, применяемые к тексту.
System.Drawing.FontStyle	=
{
	-- Сводка:
	--     Стандартный текст.
	Regular = 0;
	-- 
	-- Сводка:
	--     Текст, выделенный жирным шрифтом.
	Bold = 1;
	--
	-- Сводка:
	--     Текст, выделенный курсивом.
	Italic = 2;
	--
	-- Сводка:
	--     Текст, выделенный подчеркиванием.
	Underline = 4;
	--
	-- Сводка:
	--     Текст с линией посредине.
	Strikeout = 8;
};
