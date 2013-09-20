-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: MessageBox ( CGUI )
{
	MessageBox	= function( this, sText, sCaption, iButtons, iIcon )
		sCaption 	= (string)(sCaption);
		iButtons 	= tonumber( iButtons ) or MessageBoxButtons.OK;
		iIcon		= tonumber( iIcon ) or MessageBoxIcon.None;
		
		local Buttons =
		{
			[2]		= { false, false, "OK" };
			[4]		= { false, "OK", "Отмена" };
			[8]		= { "Прервать", "Повтор", "Пропустить" };
			[16]	= { "Да", "Нет", "Отмена" };
			[32]	= { false, "Да", "Нет" };
			[64]	= { false, "Повтор", "Отмена" };
		};
		
		local Icon	=
		{
			[2]		= "None";
			[4]		= "Resources/Images/Question.png";
			[8]		= "Resources/Images/Error.png";
			[16]	= "Resources/Images/Warning.png";
			[32]	= "Resources/Images/Information.png";
		};
				
		this.Window = this:CreateWindow( sCaption )
		{
			X		= "center";
			Y		= "center";
			Width	= 349;
			Height	= 171;
			Sizable = false;
		}
		
		if Icon[ iIcon ] ~= 'None' then
			this.Icon	= this.Window:CreateStaticImage( Icon[ iIcon ] )
			{
				X		= 32;
				Y		= 42;
				Width	= 72;
				Height	= 72;
			}
		end
		
		local Lines 	= sText:split( "\n" );
		local iMaxlen	= 0;
		local iLines	= table.getn( Lines );
		
		for key, value in ipairs( Lines ) do
			if value:len() > iMaxlen then
				iMaxlen = value:len();
			end
		end
		
		local lbl_width		= math.max( iMaxlen * 5, 271 );
		local lbl_height	= math.max( iLines * 21, 84 );
		
		this.Text	= this.Window:CreateLabel( sText )
		{
			X		= 126;
			Y		= 31;
			Width	= lbl_width;
			Height	= lbl_height;
			HorizontalAlign = { "left", true };
			VerticalAlign	= "center";
			Font	= 'default-normal';
		}
		
		local fWidth	= ( lbl_width + 78 );
		local fHeight	= ( lbl_height + 87 );
		
		this.Window:SetSize( lbl_width + 78, lbl_height + 87, false );
		this.Window:SetPosition( ( g_iScreenX - fWidth ) / 2, ( g_iScreenY - fHeight ) / 2, false );
		
		this.Button	= {};
		
		for i, value in ipairs( Buttons[ iButtons ] ) do
			if value then
				this.Button[ value ]	= this.Window:CreateButton( value )
				{
					X		= fWidth - ( 14 + ( ( ( table.getn( Buttons[ iButtons ] ) - i ) + 1 ) * 100 ) );
					Y		= math.max( lbl_height + 43, 128 );
					Width	= 88;
					Height	= 24;
				};
				
				this.Button[ value ].Click = function( sButton, sState )
					if this.Button[ value ].OnClick then
						this.Button[ value ].OnClick( sButton, sState );
					end
					
					delete ( this );
				end
			end
		end
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
	end;
	
	_MessageBox	= function( this )
		this.Window:Delete();
		this.Window = NULL;
		this.Text	= NULL;
		this.Icon	= NULL;
		this.Button = NULL;
		
		this:HideCursor();
	end;
	
	Show = function( self, sText, sCaption, iButtons, iIcon )
		local pMessageBox = MessageBox( sText, sCaption, iButtons, iIcon );
		
		return pMessageBox.Button;
	end;
}

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
	None		= 2;	-- 	Данное окно сообщения не содержит символов.
	Question	= 4;	--	Данное окно сообщения содержит символ, состоящий из вопросительного знака, заключённого в кружок.
	Error		= 8;	--	Данное окно сообщения содержит символ, состоящий из белого значка Х, заключённого в красный кружок. 
	Warning		= 16;	--	Данное окно сообщения содержит символ, состоящий из восклицательного знака в жёлтом треугольнике. 
	Information = 32;	--	Данное окно сообщения содержит символ, состоящий из буквы i в нижнем регистре, помещённой в кружок.
};

function ShowMessageBox( sCallback, sText, sCaption, MessageBoxButtons, MessageBoxIcon, ... )
	local Buttons = MessageBox:Show( sText, sCaption, MessageBoxButtons, MessageBoxIcon );
	
	local Args = { ... };
	
	for sBtnName in pairs( Buttons ) do
		Buttons[ sBtnName ].OnClick = function( sButton, sState )
			return sCallback and SERVER[ sCallback ]( sBtnName, sButton, sState, unpack( Args ) );
		end
	end
end