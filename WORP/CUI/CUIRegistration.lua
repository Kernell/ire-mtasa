-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CUIRegistration ( CGUI, CUIAsyncQuery )
{
	CUIRegistration		= function( this )
		local Consolas10			= CEGUIFont( "Consolas", 10 );
		local ConsolasBold10		= CEGUIFont( "Consolas", 10, true );
		local Consolas12			= CEGUIFont( "Consolas", 12 );
		local ConsolasBold32		= CEGUIFont( "Consolas", 32, true );
		
		this.Window	= this:CreateWindow( "" )
		{
			X		= "center";
			Y		= "center";
			Width	= 470;
			Height	= 480;
		};
		
		this.Window:CreateLabel( "Registration" )
		{
			X		= 31;
			Y		= 38;
			Width	= 406;
			Height	= 57;
			Font	= ConsolasBold32;
			Color	= { 0, 0, 0 };
		};
		
		this.Window:CreateLabel( "Registration" )
		{
			X		= 30;
			Y		= 37;
			Width	= 406;
			Height	= 57;
			Font	= ConsolasBold32;
		};
		
		this.Window:CreateLabel( "E-Mail:" )
		{
			X		= 30;
			Y		= 138;
			Width	= 204;
			Height	= 22;
			Font	= Consolas10;
		};
		
		this.Window:CreateLabel( "Пароль:" )
		{
			X		= 30;
			Y		= 208;
			Width	= 204;
			Height	= 22;
			Font	= Consolas10;
		};
		
		this.PasswordStrength	= this.Window:CreateLabel( "" )
		{
			X		= 230;
			Y		= 208;
			Width	= 204;
			Height	= 22;
			Font	= ConsolasBold10;
			HorizontalAlign	= { "right", false };
		};
		
		this.Window:CreateLabel( "Отображаемое имя (Nickname):" )
		{
			X		= 30;
			Y		= 278;
			Width	= 204;
			Height	= 22;
			Font	= Consolas10;
		};
		
		this.Window:CreateLabel( "Ник друга который Вас пригласил:" )
		{
			X			= 30;
			Y			= 348;
			Width		= 244;
			Height		= 22;
			Font		= Consolas10;
			MaxLength	= 64;
		};
		
		this.LoginBox	= this.Window:CreateEdit( "" )
		{
			X			= 30;
			Y			= 160;
			Width		= 407;
			Height		= 28;
			MaxLength	= 64;
		};
		
		this.PasswordBox	= this.Window:CreateEdit( "" )
		{
			X			= 30;
			Y			= 230;
			Width		= 407;
			Height		= 28;
			MaxLength	= 64;
			Masked		= true;
			
			Change		= function()
				local sPassword	= this.PasswordBox:GetText();
				
				if sPassword then
					if sPassword:len() == 0 then
						this.PasswordStrength:SetText( "" );
						
						return;
					end
					
					local iStrength = PasswordStrength:Meter( sPassword );
					
					if iStrength < 2 then
						this.PasswordStrength:SetText( "Очень плохой" );
						this.PasswordStrength:SetColor( 200, 0, 0 );
					elseif iStrength < 4 then
						this.PasswordStrength:SetText( "Плохой" );
						this.PasswordStrength:SetColor( 255, 0, 0 );
					elseif iStrength < 5 then
						this.PasswordStrength:SetText( "Средний" );
						this.PasswordStrength:SetColor( 255, 128, 0 );
					elseif iStrength < 7 then
						this.PasswordStrength:SetText( "Нормальный" );
						this.PasswordStrength:SetColor( 255, 255, 0 );
					elseif iStrength < 9 then
						this.PasswordStrength:SetText( "Хороший" );
						this.PasswordStrength:SetColor( 64, 200, 0 );
					elseif iStrength < 13 then
						this.PasswordStrength:SetText( "Очень хороший" );
						this.PasswordStrength:SetColor( 0, 255, 0 );
					end
				end
			end;
		};
		
		this.Nick		= this.Window:CreateEdit( "" )
		{
			X			= 30;
			Y			= 300;
			Width		= 407;
			Height		= 28;
			MaxLength	= 64;
		};
		
		this.ReferBox	= this.Window:CreateEdit( "" )
		{
			X			= 30;
			Y			= 370;
			Width		= 407;
			Height		= 28;
			MaxLength	= 64;
		};
		
		this.Register	= this.Window:CreateButton( "Регистрация" )
		{
			X			= 352;
			Y			= 430;
			Width		= 83;
			Height		= 28;
			
			Click		= function()
				local sLogin 		= this.LoginBox:GetText();
				local sPassword 	= this.PasswordBox:GetText();
				local sNick 		= this.Nick:GetText();
				local sRefer		= this.ReferBox:GetText();
				
				local function Complete()
					delete ( this );
					
					ShowLoginScreen( true );
				end
				
				this:AsyncQuery( Complete, "Register", sLogin, sPassword, sNick, sRefer );
			end;
		};
		
		this.Cancel	= this.Window:CreateButton( "Отмена" )
		{
			X		= 262;
			Y		= 430;
			Width	= 83;
			Height	= 28;
			
			Click	= function()
				delete ( this );
				
				ShowLoginScreen( true );
			end;
		};
		
		this.Window:SetVisible( true );
		this:ShowCursor();
	end;
	
	_CUIRegistration	= function( this )
		this:_CUIAsyncQuery();
		
		this.Window:Delete();
		this:HideCursor();
	end;
	
	Error	= function( this, sMessage )
		this:ShowDialog( MessageBox( sMessage, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error ) );
	end;
};
