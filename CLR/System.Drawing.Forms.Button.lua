-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

-- Сводка:
--     Обеспечивает свойства, которые задают представление элементов управления
--     System.Windows.Forms.Button для которых объект System.Windows.Forms.FlatStyle
--     имеет значение System.Windows.Forms.FlatStyle.Flat.
class "System.Drawing.Forms.FlatButtonAppearance"
{
	-- Сводка:
	--     Получает или задает цвет границы вокруг кнопки.
	--
	-- Возвращает:
	--     Структура System.Drawing.Color, представляющая цвет границы вокруг кнопки.
	BorderColor 			= System.Drawing.SystemColors.ButtonBorder;
	--
	-- Сводка:
	--     Получает или задает значение, определяющее размер в пикселях для границы
	--     вокруг кнопки.
	--
	-- Возвращает:
	--     Объект System.Int32, представляющий размер в пикселях для границы вокруг
	--     кнопки.
	BorderSize				= 1;
	--
	-- Сводка:
	--     Получает или задает цвет клиентской области кнопки, когда она нажата и указатель
	--     мыши находится вне границ элемента управления.
	--
	-- Возвращает:
	--     Структура System.Drawing.Color, представляющая цвет клиентской области кнопки.
	CheckedBackColor		= System.Drawing.SystemColors.ButtonFace;
	-- Сводка:
	--     Получает или задает цвет клиентской области кнопки, когда нажата кнопка мыши
	--     и указатель мыши находится в границах элемента управления.
	--
	-- Возвращает:
	--     Структура System.Drawing.Color, представляющая цвет клиентской области кнопки.
	MouseDownBackColor		= System.Drawing.SystemColors.ButtonFace;
	--
	-- Сводка:
	--     Получает или задает цвет клиентской области кнопки, когда указатель мыши
	--     находится в границах элемента управления.
	--
	-- Возвращает:
	--     Структура System.Drawing.Color, представляющая цвет клиентской области кнопки.
	MouseOverBackColor		= System.Drawing.SystemColors.ButtonHighlightVS2012;
	MouseOverBorderColor	= System.Drawing.SystemColors.ButtonBorderHighlight;
	
	MouseOverForeColor		= System.Drawing.SystemColors.ButtonFace;
	MouseDownForeColor		= System.Drawing.SystemColors.ForeColor;
};

class "System.Drawing.Forms.Button" ( System.Drawing.Forms.Control )
{
	Button			= function( this )
		this.FlatAppearance = System.Drawing.Forms.FlatButtonAppearance();
	end;
	
	Draw = function( this )
		local BackColor		= this.BackColor;
		local BorderColor	= this.FlatAppearance.BorderColor;
		local ForeColor		= this.ForeColor;
		
		if this.MouseDown then
			BackColor 		= this.FlatAppearance.CheckedBackColor;
		end
		
		if this.MouseOver then
			BackColor 		= this.FlatAppearance.MouseOverBackColor;
			BorderColor		= this.FlatAppearance.MouseOverBorderColor;
			ForeColor		= this.FlatAppearance.MouseOverForeColor;
			
			if this.MouseDown then
				BackColor 		= this.FlatAppearance.MouseDownBackColor;
				ForeColor		= this.FlatAppearance.MouseDownForeColor;
			end
		end
		
		local BorderSize = this.FlatAppearance.BorderSize;
		
		if BorderSize > 0 then
			dxDrawRectangle( this.Left - BorderSize, this.Top, BorderSize, this.Height, BorderColor:ToArgb(), true );
			dxDrawRectangle( this.Left + this.Width, this.Top, BorderSize, this.Height, BorderColor:ToArgb(), true );
			
			dxDrawRectangle( this.Left - BorderSize, this.Top - BorderSize, this.Width + BorderSize * 2, BorderSize, BorderColor:ToArgb(), true );
			dxDrawRectangle( this.Left - BorderSize, this.Top + this.Height, this.Width + BorderSize * 2, BorderSize, BorderColor:ToArgb(), true );
		end
		
		dxDrawRectangle( this.Left, this.Top, this.Width, this.Height, BackColor:ToArgb(), true );
		
		if this.Image then
			dxDrawImageSection	( this.Left, this.Top, this.Width, this.Height, 0, 2, this.Width, this.Height, this.Image.material, 0, 0, 0, ForeColor:ToArgb(), true );
		end
		
		dxDrawText( this.Text, this.Left, this.Top, this.Left + this.Width, this.Top + this.Height, this.ForeColor:ToArgb(), 1.0, this.Font or "default", "center", "center", false, false, true );
	end;
};
