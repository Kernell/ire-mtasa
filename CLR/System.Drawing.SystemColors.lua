-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "System.Drawing.SystemColors"
{
	-- Сводка:
	--     Получает структуру System.Drawing.Color, являющуюся цветом границы активного окна.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом границы активного окна.
	ActiveBorder 		= System.Drawing.Color.FromArgb( 180, 180, 180 );
	ActiveBorderVS2012	= System.Drawing.Color.FromArgb( 0, 122, 254 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом фона строки
	--     заголовка активного окна.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом фона строки заголовка активного
	--     окна.
	ActiveCaption = System.Drawing.Color.FromArgb( 153, 180, 209 );
	--
	-- Сводка:
	--     Получает структуру System.Drawing.Color, являющуюся цветом текста заголовка
	--     активного окна.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом текста в строке заголовка активного
	--     окна.
	ActiveCaptionText		= System.Drawing.Color.FromArgb( 0, 0, 0 );
	ActiveCaptionTextVS2012	= System.Drawing.Color.FromArgb( 255 * 0.66, 0, 0, 0 );
	--
	-- Сводка:
	--     Получает структуру System.Drawing.Color, являющуюся цветом рабочей области
	--     приложения.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом рабочей области приложения.
	AppWorkspace = System.Drawing.Color.FromArgb( 171, 171, 171 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом лицевой стороны
	--     трехмерного элемента.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом лицевой стороны трехмерного
	--     элемента.
	ButtonFace			= System.Drawing.Color.FromArgb( 240, 240, 240 );
	ButtonFaceVS2012	= System.Drawing.Color.FromArgb( 223, 223, 223 );
	
	ButtonBorder		= System.Drawing.Color.FromArgb( 172, 172, 172 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом выделения трехмерного
	--     элемента.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом выделения трехмерного элемента.
	ButtonHighlight			= System.Drawing.Color.FromArgb( 255, 255, 255 );
	ButtonHighlightVS2012	= System.Drawing.Color.FromArgb( 221, 237, 252 );
	
	ButtonBorderHighlight	= System.Drawing.Color.FromArgb( 126, 180, 234 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом тени трехмерного
	--     элемента.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом тени трехмерного элемента.
	ButtonShadow = System.Drawing.Color.FromArgb( 160, 160, 160 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом лицевой стороны
	--     трехмерного элемента.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом лицевой стороны трехмерного
	--     элемента.
	Control = System.Drawing.Color.FromArgb( 240, 240, 240 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом тени трехмерного
	--     элемента.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом тени трехмерного элемента.
	ControlDark = System.Drawing.Color.FromArgb( 160, 160, 160 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся темным цветом тени
	--     трехмерного элемента.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся темным цветом тени трехмерного элемента.
	ControlDarkDark = System.Drawing.Color.FromArgb( 105, 105, 105 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся светлым цветом трехмерного
	--     элемента.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся светлым цветом трехмерного элемента.
	ControlLight = System.Drawing.Color.FromArgb( 227, 227, 227 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом выделения трехмерного
	--     элемента.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом выделения трехмерного элемента.
	ControlLightLight = System.Drawing.Color.FromArgb( 255, 255, 255 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом текста в трехмерном
	--     элементе.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом текста трехмерного элемента.
	ControlText = System.Drawing.Color.FromArgb( 0, 0, 0 );
	--
	-- Сводка:
	--     Получает структуру System.Drawing.Color, являющуюся цветом рабочего стола.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом рабочего стола.
	Desktop = System.Drawing.Color.FromArgb( 0, 0, 0 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся самым светлым цветом
	--     градиента цвета в строке заголовка активного окна.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся самым светлым цветом градиента цвета
	--     в строке заголовка активного окна.
	GradientActiveCaption = System.Drawing.Color.FromArgb( 185, 209, 234 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся самым светлым цветом
	--     градиента цвета в строке заголовка неактивного окна.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся самым светлым цветом градиента цвета
	--     в строке заголовка неактивного окна.
	GradientInactiveCaption = System.Drawing.Color.FromArgb( 215, 227, 242 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом серого текста.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом серого текста.
	GrayText = System.Drawing.Color.FromArgb( 109, 109, 109 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом фона выбранных
	--     элементов.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом фона выбранных элементов.
	Highlight = System.Drawing.Color.FromArgb( 51, 153, 255 );
	--
	-- Сводка:
	--     Получает структуру System.Drawing.Color, являющуюся цветом текста выбранных
	--     элементов.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом текста выбранных элементов.
	HighlightText = System.Drawing.Color.FromArgb( 255, 255, 255 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, которая является цветом, используемым
	--     для обозначения отслеженного элемента.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, который является цветом, используемым для обозначения
	--     отслеженного элемента.
	HotTrack = System.Drawing.Color.FromArgb( 0, 102, 204 );
	--
	-- Сводка:
	--     Получает структуру System.Drawing.Color, являющуюся цветом границы неактивного
	--     окна.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом границы неактивного окна.
	InactiveBorder			= System.Drawing.Color.FromArgb( 244, 247, 252 );
	InactiveBorderVS2012	= System.Drawing.Color.FromArgb( 153, 153, 153 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом фона строки
	--     заголовка неактивного окна.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом фона строки заголовка неактивного
	--     окна.
	InactiveCaption = System.Drawing.Color.FromArgb( 191, 205, 219 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом текста в строке
	--     заголовка неактивного окна.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом текста в строке заголовка неактивного
	--     окна.
	InactiveCaptionText = System.Drawing.Color.FromArgb( 67, 78, 84 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом фона всплывающей
	--     подсказки.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом фона всплывающей подсказки.
	Info = System.Drawing.Color.FromArgb( 255, 255, 255 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом текста всплывающей
	--     подсказки.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом текста всплывающей подсказки.
	InfoText = System.Drawing.Color.FromArgb( 0, 0, 0 );
	--
	-- Сводка:
	--     Получает структуру System.Drawing.Color, являющуюся цветом фона меню.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом фона меню.
	Menu = System.Drawing.Color.FromArgb( 240, 240, 240 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом фона строки
	--     меню.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, представляющий собой цвет фона строки меню.
	MenuBar = System.Drawing.Color.FromArgb( 240, 240, 240 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом, используемым
	--     для выделения пунктов меню, когда меню отображается как плоское меню.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом, используемым для выделения
	--     пунктов меню, когда меню отображается как плоское меню.
	MenuHighlight = System.Drawing.Color.FromArgb( 51, 153, 255 );
	--
	-- Сводка:
	--     Получает структуру System.Drawing.Color, являющуюся цветом текста меню.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом текста меню.
	MenuText = System.Drawing.Color.FromArgb( 0, 0, 0 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом фона полосы
	--     прокрутки.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, представляющий собой цвет полосы прокрутки.
	ScrollBar = System.Drawing.Color.FromArgb( 200, 200, 200 );
	--
	-- Сводка:
	--     Возвращает структуру System.Drawing.Color, являющуюся цветом фона клиентской
	--     области окна.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом фона клиентской области окна.
	Window = System.Drawing.Color.FromArgb( 255, 255, 255 );
	--
	-- Сводка:
	--     Получает структуру System.Drawing.Color, являющуюся цветом рамки окна.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом рамки окна.
	WindowFrame = System.Drawing.Color.FromArgb( 100, 100, 100 );
	--
	-- Сводка:
	--     Получает структуру System.Drawing.Color, являющуюся цветом текста в клиентской
	--     области окна.
	--
	-- Возвращает:
	--     Цвет System.Drawing.Color, являющийся цветом текста в клиентской области
	--     окна.
	WindowText = System.Drawing.Color.FromArgb( 0, 0, 0 );
	
	MenuBarButtonHover			= System.Drawing.Color.FromArgb( 255, 255, 255 );
	MenuBarButtonHoverText		= System.Drawing.Color.FromArgb( 0, 122, 204 );
	MenuBarButtonHighlight		= System.Drawing.Color.FromArgb( 0, 122, 204 );
};
