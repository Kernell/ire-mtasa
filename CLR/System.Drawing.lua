-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

System.Drawing			= {};
System.Drawing.Forms	= {};

-- Сводка:
--     Представляет упорядоченную пару целых чисел — координат Х и Y, определяющую точку на двумерной плоскости.
class "System.Drawing.Point"
{
	Point = function( this, X, Y )
		this.X	= (int)(X);
		this.Y	= (int)(Y);
	end
};

-- Сводка:
--     Сохраняет упорядоченную пару целых чисел, указывающих System.Drawing.Size.Height и System.Drawing.Size.Width.
class "System.Drawing.Size"
{
	Size = function( this, Width, Height )
		this.Width	= (int)(Width);
		this.Height	= (int)(Height);
	end
};

-- Сводка:
--     Задает единицу измерения для заданных данных.
System.Drawing.GraphicsUnit =
{
	-- Сводка:
	--     Задает в качестве единицы измерения единицу мировой системы координат.
	World = 0,
	--
	-- Сводка:
	--     Задает единицу измерения устройства отображения. Обычно это пиксели для видеодисплеев
	--     и 1/100 дюйма для принтеров.
	Display = 1,
	--
	-- Сводка:
	--     Задает в качестве единицы измерения пиксель устройства.
	Pixel = 2,
	--
	-- Сводка:
	--     Задает в качестве единицы измерения пункт (1/72 дюйма).
	Point = 3,
	--
	-- Сводка:
	--     Задает в качестве единицы измерения дюйм.
	Inch = 4,
	--
	-- Сводка:
	--     Задает в качестве единицы измерения единицу документа (1/300 дюйма).
	Document = 5,
	--
	-- Сводка:
	--     Задает в качестве единицы измерения миллиметр.
	Millimeter = 6,
};
