-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

WindowState =
{
	Normal = 0,
	Minimized = 1,
	Maximized = 2,
};

class. Window
{
-- private:
	m_sHelpIcon			= NULL;
	m_sMinimizeicon		= "Resources/Textures/hide.png";
	m_sMaximizeIcon		= "Resources/Textures/maximize.png";
	m_sMaximizeIcon2	= "Resources/Textures/minimize.png";
	m_sCloseIcon		= "Resources/Textures/close.png";
	
-- public:
	Icon			= "Resources/Textures/Windows 7.5.png";
	Location		= NULL;
	Size			= NULL;
	Text			= "";
	Border			= 1;
	Left			= 0;
	Top				= 0;
	Width			= 0;
	Height			= 0;

	ClientSize		= NULL;

	ControlBox		= true;
	CloseButton		= true;
	HelpButton		= false;
	MaximizeBox		= false;
	MinimizeBox		= false;

	WindowState		= WindowState.Normal;
	
	ActiveBorderColor		= SystemColors.ActiveBorderVS2012;
	ActiveBackColor			= SystemColors.ActiveBackColor;
	ControlColor			= SystemColors.Control;
	ForeColor				= SystemColors.ControlText;
	InactiveBorderColor		= SystemColors.InactiveBorderVS2012;
	InactiveBackColor		= SystemColors.InactiveBackColor;

	Window	= function()
		this.Controls				= new. ControlCollection( this );
		this.Location				= new. Point( 0, 0 );
		this.TitleBarControls		=
		{
			Help		= this.m_sHelpIcon;
			Minimize	= this.m_sMinimizeicon;
			Maximize	= this.m_sMaximizeIcon;
			Close		= this.m_sCloseIcon;
		};

		if this.CloseButton then
			this.TitleBarControls[ 1 ] = "Close";
		end

		if this.MaximizeBox then
			this.TitleBarControls[ 2 ] = "Maximize";
		end
		
		if this.MinimizeBox then
			this.TitleBarControls[ 3 ] = "Minimize";
		end

		if this.HelpButton then
			this.TitleBarControls[ 4 ] = "Minimize";
		end

		this.BlurShader	= new. ShaderGaussianBlur();

		this.BlurShader.PostGUI = true;
	end;
	
	Close	= function()
		WindowManager.Remove( this );

		delete ( this.BlurShader );

		for i, control in this.Controls.Begin() do
			delete ( control );
		end
		
		delete ( this.Controls );
		this.Controls = NULL;
	end;
	
	Show	= function()
		WindowManager.Add( this );
	end;
	
	Hide	= function()
		WindowManager.Remove( this );
	end;

	BringToFront	= function()
		WindowManager.BringToFront( this );
	end;

	IsVisible	= function()
		return WindowManager.IsInList( this );
	end;
	
	Draw	= function( curX, curY, bMouse1, bMouse2 )
		if this.DragDropOffset and this.MouseDownControl == this.TitleBar.Caption then
			this.Location.X		= ( curX - this.DragDropOffset.X );
			this.Location.Y		= ( curY - this.DragDropOffset.Y );
			
			this.WindowState	= WindowState.Normal;
		end
		
		this.Left		= this.Location.X;
		this.Top		= this.Location.Y;
		this.Width		= this.Size.Width;
		this.Height		= this.Size.Height;
		
		if this.WindowState == WindowState.Maximized then
		--	sIcon 		= this.m_sMaximizeIcon2;
			
			this.Left	= 0;
			this.Top	= 0;
			this.Width	= Screen.Width;
			this.Height	= Screen.Height;
		end

		this.BackColor		= this.InactiveBackColor;
		this.BorderColor	= this.InactiveBorderColor;

		if WindowManager.GetCurrent() == this then
			this.BackColor		= this.ActiveBackColor;
			this.BorderColor	= this.ActiveBorderColor;
		end
		
		this.TitleBar.BackColor	= this.BackColor;

		if this.Border > 0 then
			local borderColor = this.BorderColor.ToArgb();

			dxDrawRectangle( this.Left - this.Border, this.Top, this.Border, this.Height, borderColor, true );
			dxDrawRectangle( this.Left + this.Width, this.Top, this.Border, this.Height, borderColor, true );
			
			dxDrawRectangle( this.Left - this.Border, this.Top - this.Border, this.Width + this.Border * 2, this.Border, borderColor, true );
			dxDrawRectangle( this.Left - this.Border, this.Top + this.Height, this.Width + this.Border * 2, this.Border, borderColor, true );
		end
		
		this.BlurShader.DrawSection( this.Left, this.Top, this.Width, this.Height, this.Left, this.Top, this.Width, this.Height, 0, 0, 0, -1 );

		dxDrawRectangle( this.Left, this.Top + 32, this.Width, this.Height - 32, this.BackColor.ToArgb(), true );
		
		this.MouseOverControl = NULL;

		this.DrawControls( this.Controls, curX, curY, 16, 38 );
	end;

	DrawControls	= function( controls, curX, curY, offsetX, offsetY )
		for i, control in controls.Begin() do
			if control.Location then
				control.Left	= control.Location.X + this.Left + ( offsetX or 0 );
				control.Top		= control.Location.Y + this.Top + ( offsetY or 0 );
			end
			
			if control.Size then
				control.Width	= control.Size.Width;
				control.Height	= control.Size.Height;
			end
			
			if curX > control.Left and curX < control.Left + control.Width and curY > control.Top and curY < control.Top + control.Height then
				this.MouseOverControl = ( this.MouseDownControl == NULL or this.MouseDownControl == control ) and control or NULL;
			end
			
			control.MouseOver = this.MouseOverControl == control;
			control.MouseDown = this.MouseDownControl == control;
			
			control.Draw( this, curX, curY );

			if control.Controls and control.Controls.Length() > 0 then
				this.DrawControls( control.Controls, curX, curY );
			end
		end
	end;
	
	ResumeLayout	= function( performLayout )
		this.Size		= new. Size( this.ClientSize.Width + 16, this.ClientSize.Height + 38 );

		this.TitleBar			= new. Label();

		this.TitleBar.Location		= new. Point( -16, -38 );
		this.TitleBar.Size			= new. Size( this.Size.Width, 32 );
		this.TitleBar.BackColor		= this.BackColor;
		
		this.TitleBar.Icon		= new. PictureBox();
		
		this.TitleBar.Icon.Image				= new. Image.FromFile( this.Icon );
		this.TitleBar.Icon.Location				= new. Point( 4, -7 );
		this.TitleBar.Icon.Size					= new. Size( 32, 32 );
		this.TitleBar.Icon.Name					= "TitleBarIcon";
		
		this.TitleBar.Caption	= new. Label();
		
		this.TitleBar.Caption.Font				= new. Font( "Segoe UI", 24, FontStyle.Regular, GraphicsUnit.Pixel );
		this.TitleBar.Caption.Location			= new. Point( ( 8 + 32 ), 0 );
		this.TitleBar.Caption.Size				= new. Size( this.Size.Width - 32, 32 );
		this.TitleBar.Caption.FontScale			= 0.4;
		this.TitleBar.Caption.VerticalAlign		= "center";
		this.TitleBar.Caption.Name				= "TitleBarCaption";
		this.TitleBar.Caption.Text				= this.Text;
		this.TitleBar.Caption.ForeColor			= SystemColors.ActiveCaptionTextVS2012;
				
		this.Controls.Add( this.TitleBar );

		this.TitleBar.Controls.Add( this.TitleBar.Icon );
		this.TitleBar.Controls.Add( this.TitleBar.Caption );
		
		if this.ControlBox then
			local i = 0;
			
			for _, controlName in ipairs( this.TitleBarControls ) do
				if this.TitleBarControls[ controlName ] then
					i = i + 1;
					
					local control	= new. Button();
					
					control.Name		= "ControlBox" + controlName;
					control.Text		= "";
					control.Location	= new. Point( ( this.Size.Width - 32 * i ), 0 );
					control.Size		= new. Size( 32, 26 );
					control.Image		= Image.FromFile( this.TitleBarControls[ controlName ] );
					control.BackColor	= Color.Transparent;

					control.BorderSize 			= 0;
					control.CheckedBackColor	= SystemColors.ActiveBackColor;
					control.MouseOverBackColor	= SystemColors.ActiveBackColor;
					control.MouseOverForeColor	= SystemColors.HotTrack;
					control.MouseDownBackColor	= SystemColors.HotTrack;
					control.MouseDownForeColor	= Color.White;
					
					if controlName == "Close" then
						control.Click.Add( 
							function()
								this.Close();
							end
						);
					end
					
					this[ control.Name ] = control;
					
					this.TitleBar.Controls.Add( control );
				end
			end
		end
		
		if performLayout then
			this.PerformLayout();
		end
	end;
	
	PerformLayout	= function()
		WindowManager.Add( this );
	end;
};
