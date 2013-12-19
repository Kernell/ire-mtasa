-- Author:      	Kernell
-- Version:     	1.0.0

local pDialog		= NULL;

class: CUILoginScreen ( CGUI, CUIAsyncQuery )
{
	TEXT_INTRO			= "Для игры на сервере Вам необходимо пройти авторизацию\n";
	TEXT_REG_SUCCESS	= "Поздравляем!\nРегистрация успешно завершена!\nТеперь вы можете ввести Ваши e-mail и пароль";
	
	CUILoginScreen	= function( self, sLogin, sPasswd )
		local Consolas10			= CEGUIFont( "Consolas", 10 );
		local Consolas12			= CEGUIFont( "Consolas", 12 );
		local ConsolasBold32		= CEGUIFont( "Consolas", 32, true );
		
		self.Window	= self:CreateWindow( "" )
		{
			X		= "center";
			Y		= "center";
			Width	= 470;
			Height	= 370;
			Sizable	= false;
			Movable	= false;
		};
		
		self.Window:CreateLabel( "Login" )
		{
			X		= 31;
			Y		= 38;
			Width	= 406; 
			Height	= 57;
			Font	= ConsolasBold32;
			Color	= { 0, 0, 0 };
		};
		
		self.Window:CreateLabel( "Login" )
		{
			X		= 30;
			Y		= 37;
			Width	= 406; 
			Height	= 57;
			Font	= ConsolasBold32;
		};
		
		self.IntroLabel = self.Window:CreateLabel( CUILoginScreen.TEXT_INTRO )
		{
			X		= 31;
			Y		= 95;
			Width	= 405; 
			Height	= 20;
			Font	= Consolas10;
			HorizontalAlign	= { "left", true };
		};
		
		self.Window:CreateLabel( "E-mail:" )
		{
			X		= 30;
			Y		= 168;
			Width	= 204; 
			Height	= 22;
			Font	= Consolas10;
		};
		
		self.Window:CreateLabel( "Пароль:" )
		{
			X		= 30;
			Y		= 238;
			Width	= 204; 
			Height	= 22;
			Font	= Consolas10;
		};
		
		self.LoginBox	= self.Window:CreateEdit( sLogin or "" )
		{
			X		= 30;
			Y		= 190;
			Width	= 407; 
			Height	= 28;
			MaxLength	= 64;
		};
		
		self.PasswordBox= self.Window:CreateEdit( sPasswd or "" )
		{
			X			= 30;
			Y			= 260;
			Width		= 407; 
			Height		= 28;
			MaxLength	= 64;
			Masked		= true;
		};
		
		self.RegLink	= self.Window:CreateLabel( "Регистрация" )
		{
			X				= 233;
			Y				= 168;
			Width			= 204; 
			Height			= 22;
			Color			= { 0, 64, 255 };
			Font			= Consolas10;
			HorizontalAlign	= { "right", false };
			
			OnClick			= function( this )
				local function Complete()
					delete ( self );
					
					CUIRegistration();
				end
				
				self:AsyncQuery( Complete, "RegDialog" );
			end;
			
			OnMouseEnter		= function( this )
				this:SetColor( 200, 0, 128 );
			end;
			
			OnMouseLeave		= function( this )
				this:SetColor( 0, 64, 255 );
			end;
		};
		
	--	self.ForgotPassword	= self.Window:CreateLabel( 233, 238, 204, 22, "Забыли пароль?", false ):SetColor( 0, 64, 255 ):SetHorizontalAlign( "right", false ):SetFont( Consolas10 );

		self.RememberMe	= self.Window:CreateCheckBox( "Запомнить меня" )
		{
			X			= 35;
			Y			= 308;
			Width		= 206; 
			Height		= 27;
			Selected	= sLogin ~= NULL;
		};
		
		self.Login		= self.Window:CreateButton( "Войти" )
		{
			X			= 352;
			Y			= 308;
			Width		= 83;
			Height		= 28;
			
			Click		= function( sButton )
				local sEmail	= self.LoginBox:GetText();
				local sPasswd	= self.PasswordBox:GetText();
				local bRemember = self.RememberMe:GetSelected();
				
				if sEmail and sPasswd and sEmail:len() > 0 and sPasswd:len() > 0 then
					local function Complete()
						delete ( self );
					end
					
					self:AsyncQuery( Complete, "TryLogin", sEmail, sPasswd, bRemember );
				else
					self:Error( "Введите e-mail и пароль" );
				end
			end;
		};
		
		self.LoginBox.Accept	= self.Login.Click;
		self.PasswordBox.Accept	= self.LoginBox.Accept;
		
		self.Window:SetVisible( true );
		self:ShowCursor();
	end;

	_CUILoginScreen	= function( this )
		this:_CUIAsyncQuery();
		
		this.Window:Delete();
		this:HideCursor();
		
		pDialog = NULL;
	end;
	
	Error	= function( this, sMessage )
		this:ShowDialog( MessageBox( sMessage, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error ) );
	end;
};



function ShowLoginScreen( bVisible, bRegistered, sLogin, sPasswd )
	if pDialog then
		delete( pDialog );
	end

	if bVisible then
		pDialog = CUILoginScreen( sLogin, sPasswd );
		
		if bRegistered then
			pDialog.IntroLabel:SetText( CUILoginScreen.TEXT_REG_SUCCESS );
			pDialog.IntroLabel:SetColor( 0, 255, 0 );
		end
	end
end
