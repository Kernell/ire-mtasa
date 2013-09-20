-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

-- Сводка:
--     Задает способ отображения окна формы.
System.Drawing.Forms.FormWindowState =
{
	-- Сводка:
	--     Окно с размерами по умолчанию.
	Normal = 0,
	--
	-- Сводка:
	--     Свернутое окно.
	Minimized = 1,
	--
	-- Сводка:
	--;     Развернутое окно.
	Maximized = 2,
};

-- Сводка:
--     Представляет окно или диалоговое окно, которое составляет пользовательский интерфейс.
class "System.Drawing.Forms.Form"
{
-- private:
	m_sHelpIcon			= NULL;
	m_sMinimizeicon		= "Resources/Textures/System.Drawing.Forms/hide.png";
	m_sMaximizeIcon		= "Resources/Textures/System.Drawing.Forms/maximize.png";
	m_sMaximizeIcon2	= "Resources/Textures/System.Drawing.Forms/minimize.png";
	m_sCloseIcon		= "Resources/Textures/System.Drawing.Forms/close.png";
	
-- public:
	Visible			= true;
	Icon			= "Resources/Textures/System.Drawing.Forms/Windows 7.5.png";
	Location		= NULL;
	Size			= NULL;
	Text			= "";
	Border			= 1;
	Left			= 0;
	Top				= 0;
	Width			= 0;
	Height			= 0;
	-- Сводка:
	--     Получает или задает кнопку на форме, которая срабатывает при нажатии клавиши ENTER.
	--
	-- Возвращает:
	--     Объект System.Windows.Forms.IButtonControl, представляющий кнопку, используемую
	--     в качестве кнопки приема данных для формы.
	AcceptButton	= NULL;
	--
	-- Сводка:
	--     Возвращает или задает значение, указывающее, можно ли изменить уровень непрозрачности
	--     формы.
	--
	-- Возвращает:
	--     Значение true, если уровень непрозрачности формы можно изменить; в противном случае — false.
	AllowTransparency	= true;
	--
	-- Сводка:
	--     Возвращает или задает кнопку, которая срабатывает при нажатии клавиши ESC.
	--
	-- Возвращает:
	--     System.Windows.Forms.IButtonControl, который представляет кнопку отмены для формы.
	CancelButton	 = NULL;
	--
	-- Сводка:
	--     Возвращает или задает размер клиентской области формы.
	--
	-- Возвращает:
	--     System.Drawing.Size, который представляет размер клиентской области формы.
	ClientSize		= NULL;
	--
	-- Сводка:
	--     Получает или задает значение, указывающее, отображается или нет кнопка оконного
	--     меню в строке заголовка формы.
	--
	-- Возвращает:
	--     Значение true, если на форме отображается кнопка оконного меню в левом верхнем
	--     углу формы; в противном случае — значение false. Значение по умолчанию — true.
	ControlBox		= true;
	--
	-- Сводка:
	--     Возвращает или задает значение, указывающее, отображается ли кнопка Справка
	--     в окне заголовка формы.
	--
	-- Возвращает:
	--     Значение true для отображения кнопки справки в заголовке формы; в противном
	--     случае — значение false. Значение по умолчанию — false.
	HelpButton		= false;
	--
	-- Сводка:
	--     Возвращает или задает значение, указывающее, отображается ли кнопка развертывания
	--     в строке заголовка формы.
	--
	-- Возвращает:
	--     Значение true, если должна отображаться кнопка развертывания для формы; в
	--     противном случае — значение false. Значение по умолчанию — true.
	MaximizeBox		= true;
	--
	-- Сводка:
	--     Возвращает или задает значение, указывающее, отображается ли кнопка свертывания
	--     в строке заголовка формы.
	--
	-- Возвращает:
	--     Значение true, если должна отображаться кнопка свертывания для формы; в противном
	--     случае — значение false. Значение по умолчанию — true.
	MinimizeBox		= true;
	--
	-- Сводка:
	--     Получает или задает значение, указывающее, находится ли форма в свернутом,
	--     развернутом или обычном состоянии.
	--
	-- Возвращает:
	--     System.Windows.Forms.FormWindowState , который представляет свернута ли форма,
	--     развернута на весь экран или нормальная. Значение по умолчанию: FormWindowState.Normal.
	WindowState		= System.Drawing.Forms.FormWindowState.Normal;
	
	ActiveBorderColor		= System.Drawing.SystemColors.ActiveBorderVS2012;
	BackColor				= System.Drawing.SystemColors.Control;
	ControlColor			= System.Drawing.SystemColors.Control;
	ForeColor				= System.Drawing.SystemColors.ControlText;
	InactiveBorderColor		= System.Drawing.SystemColors.InactiveBorderVS2012;
	
-- public:
	Close	= function( this )
		removeEventHandler( "onClientRender", root, this.__Draw );
		removeEventHandler( "onClientClick", root, this.__Click );
		
		for i, Control in this.Controls.Begin() do
			delete ( Control );
		end
		
		delete ( this.Controls );
		this.Controls = NULL;
	end;
	
	Show	= function( this )
		this.Visible = true;
	end;
	
	Hide	= function( this )
		this.Visible = false;
	end;
	
	Draw	= function( this, iCurX, iCurY, bMouse1, bMouse2 )
		if this.DragDropOffset and this.MouseDownControl == this.TitleBarCaption then
			this.Location.X	= ( iCurX - this.DragDropOffset.X );
			this.Location.Y	= ( iCurY - this.DragDropOffset.Y );
			
			this.WindowState = System.Drawing.Forms.FormWindowState.Normal;
		end
		
		this.Left	= this.Location.X;
		this.Top	= this.Location.Y;
		this.Width	= this.Size.Width;
		this.Height	= this.Size.Height;
		
		if this.WindowState == System.Drawing.Forms.FormWindowState.Maximized then
			-- sIcon = this.m_sMaximizeIcon2;
			
			this.Left	= 0;
			this.Top	= 0;
			this.Width	= g_iScreenX;
			this.Height	= g_iScreenY;
		end
		
		if this.Border > 0 then
			dxDrawRectangle( this.Left - this.Border, this.Top, this.Border, this.Height, this.ActiveBorderColor:ToArgb(), true );
			dxDrawRectangle( this.Left + this.Width, this.Top, this.Border, this.Height, this.ActiveBorderColor:ToArgb(), true );
			
			dxDrawRectangle( this.Left - this.Border, this.Top - this.Border, this.Width + this.Border * 2, this.Border, this.ActiveBorderColor:ToArgb(), true );
			dxDrawRectangle( this.Left - this.Border, this.Top + this.Height, this.Width + this.Border * 2, this.Border, this.ActiveBorderColor:ToArgb(), true );
		end
		
		dxDrawRectangle( this.Left, this.Top, this.Width, this.Height, this.BackColor:ToArgb(), true );
		
		this.MouseOverControl = NULL;
		
		for i, Control in this.Controls.Begin() do
			if Control.Location then
				Control.Left	= Control.Location.X + this.Left + 16;
				Control.Top		= Control.Location.Y + this.Top + 38;
			end
			
			if Control.Size then
				Control.Width	= Control.Size.Width;
				Control.Height	= Control.Size.Height;
			end

			if IsInRectangle( iCurX, iCurY, Control.Left, Control.Top, Control.Width, Control.Height ) then
				this.MouseOverControl = ( this.MouseDownControl == NULL or this.MouseDownControl == Control ) and Control or NULL;
			end
			
			Control.MouseOver = this.MouseOverControl == Control;
			Control.MouseDown = this.MouseDownControl == Control;
			
			Control:Draw();
		end
	end;
	
	SuspendLayout	= function( this )
		this.Controls				= System.Drawing.Forms.Control.ControlCollection( this );
		this.Location				= System.Drawing.Point( 0, 0 );
		this.TitleBarControls		=
		{
			"Close";
			"Maximize";
			"Minimize";
			"Help";
			
			Help		= this.m_sHelpIcon;
			Minimize	= this.m_sMinimizeicon;
			Maximize	= this.m_sMaximizeIcon;
			Close		= this.m_sCloseIcon;
		};
	end;
	
	ResumeLayout	= function( this, bPerformLayout )
		this.Size		= System.Drawing.Size( this.ClientSize.Width + 16, this.ClientSize.Height + 38 );
		
		this.TitleBarIcon		= System.Drawing.Forms.PictureBox();
		
		this.TitleBarIcon.Image					= System.Drawing.Image.FromFile( this.Icon );
		this.TitleBarIcon.Location				= System.Drawing.Point( 4 - 16, -7 - 38 );
		this.TitleBarIcon.Size					= System.Drawing.Size( 32, 32 );
		this.TitleBarIcon.Name					= "TitleBarIcon";
		
		this.TitleBarCaption	= System.Drawing.Forms.Label();
		
		this.TitleBarCaption.AutoSize			= true;
		this.TitleBarCaption.Font				= System.Drawing.Font( "Segoe UI", 24, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Pixel );
		this.TitleBarCaption.Location			= System.Drawing.Point( ( 8 + 32 ) - 16, -38 );
		this.TitleBarCaption.Size				= System.Drawing.Size( this.Size.Width, 32 );
		this.TitleBarCaption.FontScale			= 0.4;
		this.TitleBarCaption.Name				= "TitleBarCaption";
		this.TitleBarCaption.Text				= this.Text;
		this.TitleBarCaption.ForeColor			= System.Drawing.SystemColors.ActiveCaptionTextVS2012;
		
		this.Controls.Add( this.TitleBarIcon );
		this.Controls.Add( this.TitleBarCaption );
		
		if this.ControlBox then
			local i = 0;
			
			for _, ControlName in ipairs( this.TitleBarControls ) do
				if this.TitleBarControls[ ControlName ] then
					i = i + 1;
					
					local Control	= System.Drawing.Forms.Button();
					
					Control.Name		= "ControlBox" + ControlName;
					Control.Text		= "";
					Control.Location	= System.Drawing.Point( ( this.Size.Width - 34 * i ) - 16, -38 );
					Control.Size		= System.Drawing.Size( 34, 26 );
					Control.Image		= System.Drawing.Image.FromFile( this.TitleBarControls[ ControlName ] );
					Control.BackColor	= System.Drawing.Color.Transparent;
					Control.FlatAppearance.BorderSize 			= 0;
					Control.FlatAppearance.CheckedBackColor		= System.Drawing.Color.White;
					Control.FlatAppearance.MouseOverBackColor	= System.Drawing.Color.White;
					Control.FlatAppearance.MouseOverForeColor	= System.Drawing.SystemColors.HotTrack;
					Control.FlatAppearance.MouseDownBackColor	= System.Drawing.SystemColors.HotTrack;
					Control.FlatAppearance.MouseDownForeColor	= System.Drawing.Color.White;
					
					if ControlName == "Close" then
						Control.Click:Add( 
							function()
								this:Close();
							end
						);
					end
					
					this[ Control.Name ] = Control;
					
					this.Controls.Add( Control );
				end
			end
		end
		
		for i, Control in this.Controls.Begin() do
			Control:ResumeLayout( bPerformLayout );
		end
		
		if bPerformLayout then
			this:PerformLayout();
		end
	end;
	
	PerformLayout	= function( this )
		function this.__Draw()
			if this.Visible then
				local iCurX, iCurY = getCursorPosition();
				
				iCurX, iCurY = ( iCurX or 0 ) * g_iScreenX, ( iCurY or 0 ) * g_iScreenY;
				
				this:Draw( iCurX, iCurY );
			end
		end
		
		function this.__Click( sMouseButton, sState, iCurX, iCurY )
			if sState == "down" then
				if this.MouseOverControl then
					this.MouseDownControl = this.MouseOverControl;
					
					if sMouseButton == "left" then
						this.DragDropOffset	= System.Drawing.Point( iCurX - this.Location.X, iCurY - this.Location.Y );
					end
				end
			elseif sState == "up" then
				if this.MouseDownControl and this.MouseOverControl and this.MouseOverControl == this.MouseDownControl then
					this.MouseDownControl.Click:Call();
				end
				
				this.MouseDownControl = NULL;
			end
		end
		
		addEventHandler( "onClientRender", root, this.__Draw );
		addEventHandler( "onClientClick", root, this.__Click );
	end;
};
