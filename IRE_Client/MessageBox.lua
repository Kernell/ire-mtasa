-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

enum "MessageBoxButtons"
{
	OK 					= 2;	-- Окно сообщения содержит кнопку "ОК". 
	OKCancel 			= 4; 	-- Окно сообщения содержит кнопки "ОК" и "Отмена". 
	AbortRetryIgnore 	= 8; 	-- Окно сообщения содержит кнопки "Прервать", "Повтор" и "Пропустить". 
	YesNoCancel 		= 16; 	-- Окно сообщения содержит кнопки "Да", "Нет" и "Отмена". 
	YesNo 				= 32; 	-- Окно сообщения содержит кнопки "Да" и "Нет". 
	RetryCancel 		= 64;	-- Окно сообщения содержит кнопки "Повтор" и "Отмена".
};

enum "MessageBoxIcon"
{
	None				= 2;	-- 	Данное окно сообщения не содержит символов.
	Question			= 4;	--	Данное окно сообщения содержит символ, состоящий из вопросительного знака, заключённого в кружок.
	Error				= 8;	--	Данное окно сообщения содержит символ, состоящий из белого значка Х, заключённого в красный кружок. 
	Warning				= 16;	--	Данное окно сообщения содержит символ, состоящий из восклицательного знака в жёлтом треугольнике. 
	Information 		= 32;	--	Данное окно сообщения содержит символ, состоящий из буквы i в нижнем регистре, помещённой в кружок.
};

class. MessageBox
{
	static
	{
		Buttons =
		{
			[ MessageBoxButtons.OK ]				= { false, false, "OK" };
			[ MessageBoxButtons.OKCancel ]			= { false, "OK", "Отмена" };
			[ MessageBoxButtons.AbortRetryIgnore ]	= { "Прервать", "Повтор", "Пропустить" };
			[ MessageBoxButtons.YesNoCancel ]		= { "Да", "Нет", "Отмена" };
			[ MessageBoxButtons.YesNo ]				= { false, "Да", "Нет" };
			[ MessageBoxButtons.RetryCancel ]		= { false, "Повтор", "Отмена" };
		};
		
		Icon	=
		{
			[ MessageBoxIcon.None ]					= "None";
			[ MessageBoxIcon.Question ]				= "Resources/Images/Question.png";
			[ MessageBoxIcon.Error ]				= "Resources/Images/Error.png";
			[ MessageBoxIcon.Warning ]				= "Resources/Images/Warning.png";
			[ MessageBoxIcon.Information ]			= "Resources/Images/Information.png";
		};
	};
	
	Width		= 349;
	Height		= 171;
	
	MessageBox	= function( text, caption, buttons, icon )
		caption 	= (string)(caption);
		buttons 	= tonumber( buttons ) or MessageBoxButtons.OK;
		icon		= tonumber( icon ) or MessageBoxIcon.None;
		
		local screenX, screenY = guiGetScreenSize();
		
		this.Window		= new. CEGUIWindow( ( screenX - this.Width ) / 2, ( screenY - this.Height ) / 2, this.Width, this.Height, caption, false );
		
		if MessageBox.Icon[ icon ] ~= "None" then
			this.Icon	= new. CEGUIImage( 32, 42, 72, 72, MessageBox.Icon[ icon ], false, this.Window );
		end
		
		local lines			= text:split( "\n" );
		local maxLen		= 0;
		local linesCount	= table.getn( lines );
		
		for key, value in ipairs( lines ) do
			if value:len() > maxLen then
				maxLen = value:len();
			end
		end
		
		local lbl_width		= math.max( maxLen * 5, 271 );
		local lbl_height	= math.max( linesCount * 21, 84 );
		
		this.Text	= new. CEGUILabel( 126, 31, lbl_width, lbl_height, text, false, this.Window );
		
		this.Text.SetHorizontalAlign( "left", true );
		this.Text.SetVerticalAlign( "center" );
		this.Text.SetFont( "default-normal" );
		
		local fWidth	= ( lbl_width + 78 );
		local fHeight	= ( lbl_height + 87 );
		
		this.Window.SetSize( lbl_width + 78, lbl_height + 87, false );
		this.Window.SetPosition( ( screenX - fWidth ) / 2, ( screenY - fHeight ) / 2, false );
		
		this.Button	= {};
		
		local buttonsCount = table.getn( MessageBox.Buttons[ buttons ] );
		
		for i = 1, buttonsCount do
			local text = MessageBox.Buttons[ buttons ][ i ];
			
			if text then
				local x			= fWidth - ( 14 + ( ( ( buttonsCount - i ) + 1 ) * 100 ) );
				local y			= math.max( lbl_height + 43, 128 );
				local width		= 88;
				local height	= 24;
				
				local button	= new. CEGUIButton( x, y, width, height, text, false, this.Window );
				
				local function OnClick( sender, e, btn, state )
					if button.OnClick then
						button.OnClick( btn, state );
					end
					
					delete ( this );
				end
				
				button.OnClientGUIClick.Add( OnClick );
				
				this.Button[ text ] = button;
			end
		end
		
		this.Window.SetVisible( true );
		this.Window.BringToFront();
		this.Window.ShowCursor();
	end;
	
	_MessageBox	= function()
		this.Window.HideCursor();
		
		this.Window.Delete();
		
		this.Window = NULL;
		this.Text	= NULL;
		this.Icon	= NULL;
		this.Button = NULL;
	end;
};
