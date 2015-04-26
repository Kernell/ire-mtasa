-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. TextField : Control
{
	TextColor				= SystemColors.ButtonFace;
	ForeColor 				= SystemColors.ActiveBorderVS2012;
	MouseOverForeColor		= SystemColors.Highlight;
	MouseDownForeColor		= SystemColors.ActiveBorderVS2012;

	Font					= new. Font( "Segoe UI", 12, FontStyle.Regular, GraphicsUnit.Pixel );
	Align					= "left";
	Clip					= true;
	FontScale				= 1.0;
	VerticalAlign			= "center";
	WordBreak				= false;
	HaveFocus				= false;
	Text					= "";

	CursorPosition			= 1;

	NextKeyTick				= 0;

	static
	{
		NextKeyTickDelay	= 500;
	};

	TextField	= function()
		this.Control();

		this.NextKeyTickDelay	= TextField.NextKeyTickDelay;

		this.ForeColor2		= Color.FromArgb( this.ForeColor.A * 0.5, this.ForeColor.R, this.ForeColor.G, this.ForeColor.B );

		this.Click.Add	( function( ... ) this.OnClick( ... ); end );
		this.Focus.Add	( function( ... ) this.OnFocus( ... ); end );
		this.Blur.Add	( function( ... ) this.OnBlur( ... ); end );

		this.FontHeight	= this.Font.Size;
		this.InputGUI	= guiCreateEdit( 0, 0, 0, 0, "", false );

		function this.__OnGUIAccepted()
			local inputText = this.InputText.Join( "" );
			
			this.CursorPosition = 1;
			
			guiSetText( this.InputGUI, "" );
		end
		
		local __OnGUIChangedSkip = false;
		
		function this.__OnGUIChanged()
			if __OnGUIChangedSkip then
				__OnGUIChangedSkip = false;
				
				return;
			end
			
			local text			= guiGetText( this.InputGUI );
			local len			= text:len();

			local inputText		= new {};

			for i = 1, this.Text:len() do
				inputText.Insert( this.Text[ i ] );
			end

			for i = len, 1, -1 do
				inputText.Insert( this.CursorPosition + 1, text[ i ] );
			end

			this.Text = inputText.Join( "" );

			this.CursorPosition = this.CursorPosition + len;
			
			__OnGUIChangedSkip = true;
			
			guiSetText( this.InputGUI, "" );
		end
		
		function this.__OnGUIBlur()
			if this.HaveFocus then
				guiBringToFront( this.InputGUI );
			end
		end
		
		addEventHandler( "onClientGUIAccepted", this.InputGUI, this.__OnGUIAccepted );
		addEventHandler( "onClientGUIChanged", 	this.InputGUI, this.__OnGUIChanged );
		addEventHandler( "onClientGUIBlur", 	this.InputGUI, this.__OnGUIBlur );
	end;

	_TextField	= function()
		if this.InputGUI then
			this.InputGUI.Destroy();
		end

		this.InputGUI = NULL;
	end;

	OnKey				= function( sKey )
		if this.HaveFocus then
			guiBringToFront( this.InputGUI );
			
			if getKeyState( "rctrl" ) or getKeyState( "lctrl" ) then
				if sKey == "c" then
					this.Print( "> " + table.concat( this.m_aCommand, "" ) );
					
					this.m_iLogIterator = 0;
					this.m_iCursorPosition = 1;
					
					this.m_aCommand = {};
				elseif sKey == "arrow_l" then
					local len = table.getn( this.m_aCommand );
					
					for i = len, 1, -1 do
						if ( ( this.m_aCommand[ i - 1 ] == " " and this.m_aCommand[ i ] ~= " " ) or i == 1 ) and i < this.m_iCursorPosition - 1 then
							this.m_iCursorPosition = i;
							
							break;
						end
					end
				elseif sKey == "arrow_r" then
					local len = table.getn( this.m_aCommand );
					
					for i = 1, len, 1 do
						if ( ( this.m_aCommand[ i - 1 ] == " " and this.m_aCommand[ i ] ~= " " ) or i == len ) and i > this.m_iCursorPosition then
							this.m_iCursorPosition = i;
							
							break;
						end
					end
				end
				
				return false;
			end
			
			if sKey == "escape" or sKey == "end" then
				this.Hide();
			elseif sKey == "delete" then
				if this.m_iCursorPosition <= table.getn( this.m_aCommand ) then
					table.remove( this.m_aCommand, this.m_iCursorPosition );
				end
				
				this.m_iCursorPosition = Clamp( 1, this.m_iCursorPosition, table.getn( this.m_aCommand ) + 1 );
			elseif sKey == "backspace" then
				if this.m_iCursorPosition > 1 then
					table.remove( this.m_aCommand, this.m_iCursorPosition - 1 );
					
					this.m_iCursorPosition = Clamp( 1, this.m_iCursorPosition - 1, table.getn( this.m_aCommand ) + 1 );
				end
			elseif sKey == "arrow_l" then
				this.m_iCursorPosition = Clamp( 1, this.m_iCursorPosition - 1, table.getn( this.m_aCommand ) + 1 );
			elseif sKey == "arrow_r" then
				this.m_iCursorPosition = Clamp( 1, this.m_iCursorPosition + 1, table.getn( this.m_aCommand ) + 1 );
			elseif sKey == "arrow_d" then
				this.m_iLogIterator = this.m_iLogIterator - 1;
				
				if this.m_iLogIterator < 0 then
					this.m_iLogIterator = 0;
				end
				
				this.m_aCommand = {};
				
				local text	= this.Log[ this.m_iLogIterator ] or "";
				local len	= text:len();
				
				for i = 1, len do
					table.insert( this.m_aCommand, text[ i ] );
				end
				
				this.m_iCursorPosition = len + 1;
			elseif sKey == "arrow_u" then
				local iLogSize	= table.getn( this.Log );
				
				if table.getn( this.m_aCommand ) ~= 0 or this.m_iLogIterator == 0 then
					this.m_iLogIterator = this.m_iLogIterator + 1;
				end
				
				if this.m_iLogIterator > iLogSize then
					this.m_iLogIterator = iLogSize;
				end
				
				this.m_aCommand = {};
				
				local text	= this.Log[ this.m_iLogIterator ] or "";
				local len	= text:len();
				
				for i = 1, len do
					table.insert( this.m_aCommand, text[ i ] );
				end
				
				this.m_iCursorPosition = len + 1;
			elseif sKey == "pgup" then
				this.m_iLineScrollOffset = Clamp( 0, this.m_iLineScrollOffset + 1, table.getn( this.m_aLines ) );
			elseif sKey == "pgdn" then
				this.m_iLineScrollOffset = Clamp( 0, this.m_iLineScrollOffset - 1, table.getn( this.m_aLines ) );
			elseif sKey == "mouse_wheel_up" then
				this.m_iLineScrollOffset = Clamp( 0, this.m_iLineScrollOffset + 3, table.getn( this.m_aLines ) );
			elseif sKey == "mouse_wheel_down" then
				this.m_iLineScrollOffset = Clamp( 0, this.m_iLineScrollOffset - 3, table.getn( this.m_aLines ) );
			end
			
			return false;
		end
		
		return true;
	end;

	UpdateKeys			= function()
		local tick	= getTickCount();
		
		if this.NextKeyTick - tick <= 0 then
			this.NextKeyTickDelay = this.NextKeyTickDelay - 150;
			
			local minDelay = 50;
			
			if getKeyState( "delete" ) then
				this.OnKey( "delete" );
				
				minDelay = 50;
				
				this.NextKeyTickDelay = 50;
			elseif getKeyState( "backspace" ) then
				this.OnKey( "backspace" );
				
				minDelay = 50;
				
				this.NextKeyTickDelay = 50;
			elseif getKeyState( "arrow_l" ) then
				this.OnKey( "arrow_l" );
				
				minDelay = 50;
				
				this.NextKeyTickDelay = 50;
			elseif getKeyState( "arrow_r" ) then
				this.OnKey( "arrow_r" );
				
				minDelay = 50;
				
				this.NextKeyTickDelay = 50;
			elseif getKeyState( "arrow_u" ) then
				this.OnKey( "arrow_u" );
			elseif getKeyState( "arrow_d" ) then
				this.OnKey( "arrow_d" );
			elseif getKeyState( "pgup" ) then
				this.OnKey( "pgup" );
				
				minDelay = 10;
				
				this.NextKeyTickDelay = 10;
			elseif getKeyState( "pgdn" ) then
				this.OnKey( "pgdn" );
				
				minDelay = 10;
				
				this.NextKeyTickDelay = 10;
			end
			
			this.NextKeyTick = iTick + Clamp( minDelay, this.NextKeyTickDelay, TextField.NextKeyTickDelay );
		end
	end;

	Draw		= function()
		this.UpdateKeys();

		local borderBottom	= 1;
		local BackColor		= this.BackColor;
		local BorderColor	= this.BorderColor;
		local ForeColor		= this.ForeColor;
		local TextColor		= this.TextColor;
		
		if this.MouseDown then
			BackColor 		= this.CheckedBackColor;
		end
		
		if this.MouseOver then
			BackColor 		= this.MouseOverBackColor;
			BorderColor		= this.MouseOverBorderColor;
			ForeColor		= this.MouseOverForeColor;
			
			if this.MouseDown and not this.HaveFocus then
				BackColor 	= this.MouseDownBackColor;
				ForeColor	= this.MouseDownForeColor;
			end
		end

		if this.HaveFocus then
			borderBottom = 2;

			TextColor = SystemColors.HighlightText;
		end

		dxDrawText( this.Text, this.Left, this.Top, this.Left + this.Width, this.Top + this.Height, TextColor.ToArgb(), this.FontScale, this.Font, this.Align, this.VerticalAlign, this.Clip, this.WordBreak, this.PostGUI );
		
		if this.HaveFocus then
			if getTickCount() % 500 < 250 then
				local textWidth = 0;

				if this.CursorPosition > 1 then
					textWidth = dxGetTextWidth( this.Text:sub( 1, this.CursorPosition ), this.FontScale, this.Font );
				end

				local x = this.Left + textWidth;
			
				dxDrawRectangle( x, this.Top + 3, 1, this.FontHeight + 5, ForeColor.ToArgb(), this.PostGUI );
			end
		end

		dxDrawRectangle( this.Left, this.Top + this.Height + 5, this.Width, borderBottom, ForeColor.ToArgb(), true );
	end;

	OnClick		= function( sender, button, x, y )
		if button == "left" then
			x, y = x - this.Left, y - this.Top;

			local len = 0;

			for i = 1, this.Text:len() do
				local char 		= this.Text[ i ];
				local charLen 	= dxGetTextWidth( char, this.FontScale, this.Font );

				len = len + charLen;

				if len >= x then
					this.CursorPosition = i;

					return;
				end
			end

			this.CursorPosition = this.Text:len();
		end
	end;

	OnFocus		= function( sender )
		this.HaveFocus = true;

		this.CursorPosition = this.Text:len();

		guiBringToFront( this.InputGUI );
	end;

	OnBlur		= function( sender )
		this.HaveFocus = false;

		guiMoveToBack( this.InputGUI );
	end;
}