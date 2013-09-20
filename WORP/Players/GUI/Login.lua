-- Author:      	Kernell
-- Version:     	1.0.0

local sRegSuccess	= "Поздравляем!\nРегистрация успешно завершена!\nТеперь вы можете ввести Ваши e-mail и пароль";
local pDialog		= NULL;

class "LoginScreen" ( CGUI )

function LoginScreen:LoginScreen( sLogin, sPasswd )
	if not Consolas10 then
		Consolas10			= guiCreateFont( "Resources/Fonts/consola.ttf", 10 );
	end
	
	if not Consolas12 then
		Consolas12			= guiCreateFont( "Resources/Fonts/consola.ttf", 12 );
	end
	
	if not ConsolasBold32 then
		ConsolasBold32		= guiCreateFont( "Resources/Fonts/consolab.ttf", 32 );
	end
	
	self.Background	= self:CreateStaticImage( "Resources/Images/Aero.png" )
	{
		X		= "center";
		Y		= "center";
		Width	= 470;
		Height	= 370;
	}
	
	self.Window	= self:CreateWindow( "" )
	{
		X		= "center";
		Y		= "center";
		Width	= 470;
		Height	= 370;
		Sizable	= false;
		Movable	= false;
	}

	setElementParent( self.Background.__instance, self.Window.__instance );
	
	self.Window:SetProperty( "Alpha", "0" );

	local lblTitle = self.Window:CreateLabel( "Login" )
	{
		X		= 31;
		Y		= 38;
		Width	= 406; 
		Height	= 57;
		Font	= ConsolasBold32;
		Color	= { 0, 0, 0 };
	}
	
	lblTitle:SetProperty( "InheritsAlpha", "False" );
	lblTitle:SetAlpha( 1.0 );
	
	local lblTitleA = self.Window:CreateLabel( "Login" )
	{
		X		= 30;
		Y		= 37;
		Width	= 406; 
		Height	= 57;
		Font	= ConsolasBold32;
	}
	
	lblTitleA:SetProperty( "InheritsAlpha", "False" );
	lblTitleA:SetAlpha( 1.0 );
	
	local lblInfo = self.Window:CreateLabel( "Для игры на сервере Вам необходимо пройти авторизацию" )
	{
		X		= 31;
		Y		= 95;
		Width	= 405; 
		Height	= 20;
		Font	= Consolas10;
		HorizontalAlign	= { "left", true };
	}
	
	lblInfo:SetProperty( "InheritsAlpha", "False" );
	lblInfo:SetAlpha( 1.0 );
	
	self.ErrorBox2	= self.Window:CreateLabel( "" )
	{
		X		= 32;
		Y		= 114;
		Width	= 405;
		Height	= 50;
		Font	= Consolas12;
		HorizontalAlign	= { "center", true };
		VerticalAlign	= "center";
		-- -- Color	= { 125, 174, 168 };
		Color	= { 96, 96, 96 };
	}
	
	self.ErrorBox2:SetProperty( "InheritsAlpha", "False" );
	self.ErrorBox2:SetAlpha( 1.0 );
	
	self.ErrorBox	= self.Window:CreateLabel( "" )
	{
		X		= 31;
		Y		= 115;
		Width	= 405;
		Height	= 50;
		Font	= Consolas12;
		HorizontalAlign	= { "center", true };
		VerticalAlign	= "center";
	}
	
	self.ErrorBox:SetProperty( "InheritsAlpha", "False" );
	self.ErrorBox:SetAlpha( 1.0 );
	
	local lblLoginTitle = self.Window:CreateLabel( "E-mail:" )
	{
		X		= 30;
		Y		= 168;
		Width	= 204; 
		Height	= 22;
		Font	= Consolas10;
	}
	
	lblLoginTitle:SetProperty( "InheritsAlpha", "False" );
	lblLoginTitle:SetAlpha( 1.0 );
	
	local lblPasswdTitle = self.Window:CreateLabel( "Пароль:" )
	{
		X		= 30;
		Y		= 238;
		Width	= 204; 
		Height	= 22;
		Font	= Consolas10;
	}
	
	lblPasswdTitle:SetProperty( "InheritsAlpha", "False" );
	lblPasswdTitle:SetAlpha( 1.0 );
	
	self.lblCodeTitle = self.Window:CreateLabel( "Код активации:" )
	{
		X		= 30;
		Y		= 308;
		Width	= 204; 
		Height	= 22;
		Font	= Consolas10;
	}
	
	self.lblCodeTitle:SetProperty( "InheritsAlpha", "False" );
	self.lblCodeTitle:SetAlpha( 1.0 );
	self.lblCodeTitle:SetVisible( false );
	
	self.LoginBox	= self.Window:CreateEdit( sLogin or "" )
	{
		X		= 30;
		Y		= 190;
		Width	= 407; 
		Height	= 28;
		MaxLength	= 64;
	}
	
	self.LoginBox:SetProperty( "InheritsAlpha", "False" );
	self.LoginBox:SetAlpha( .8 );
	
	self.PasswordBox= self.Window:CreateEdit( sPasswd or "" )
	{
		X			= 30;
		Y			= 260;
		Width		= 407; 
		Height		= 28;
		MaxLength	= 64;
		Masked		= true;
	}
	
	self.PasswordBox:SetProperty( "InheritsAlpha", "False" );
	self.PasswordBox:SetAlpha( .8 );
	
	self.CodeBox	= self.Window:CreateEdit( sPasswd or "" )
	{
		X			= 30;
		Y			= 330;
		Width		= 407; 
		Height		= 28;
		MaxLength	= 64;
		Masked		= true;
	}
	
	self.CodeBox:SetProperty( "InheritsAlpha", "False" );
	self.CodeBox:SetAlpha( .8 );
	self.CodeBox:SetVisible( false );
	
	self.RegLink	= self.Window:CreateLabel( "Регистрация" )
	{
		X			= 233;
		Y			= 168;
		Width		= 204; 
		Height		= 22;
		Color		= { 0, 64, 255 };
		Font		= Consolas10;
		HorizontalAlign	= { "right", false };
	}
	
	self.RegLink:SetProperty( "InheritsAlpha", "False" );
	self.RegLink:SetAlpha( 1.0 );
	
--	self.ForgotPassword	= self.Window:CreateLabel( 233, 238, 204, 22, "Забыли пароль?", false ):SetColor( 0, 64, 255 ):SetHorizontalAlign( "right", false ):SetFont( Consolas10 );

	self.RememberMe	= self.Window:CreateCheckBox( "Запомнить меня" )
	{
		X			= 35;
		Y			= 308;
		Width		= 206; 
		Height		= 27;
		Selected	= sLogin and true or false;
	}
	
	self.RememberMe:SetProperty( "InheritsAlpha", "False" );
	self.RememberMe:SetAlpha( 1.0 );
	
	self.Login		= self.Window:CreateStaticImage( "Resources/Images/Button.png" )
	{
		X			= 352;
		Y			= 308;
		Width		= 83; 
		Height		= 28;
	}
	
	self.Login:SetProperty( "InheritsAlpha", "False" );
	self.Login:SetAlpha( 1.0 );
	
	self.Label_Login = self.Login:CreateLabel( "Войти" )
	{
		X		= 0;
		Y		= 5;
		Width	= 83;
		Height	= 28;
		HorizontalAlign	= { "center", true };
		Color	= { 186, 186, 186 };
	}
	
	self.Label_Login:SetProperty( "InheritsAlpha", "False" );
	self.Label_Login:SetAlpha( 1.0 );
	
	self.Label_LoginS = self.Login:CreateLabel( "Войти" )
	{
		X		= 1;
		Y		= 5;
		Width	= 83;
		Height	= 28;
		HorizontalAlign	= { "center", true };
		Color	= { 0, 0, 0 };
	}

	self.Label_LoginS:SetProperty( "InheritsAlpha", "False" );
	self.Label_LoginS:SetAlpha( 1.0 );
	
	--// Callbacks

	function self.Login.Click( button )
		if not self.Window:GetEnabled() then
			return;
		end
		
		self:SetLocked( true );
		
		Ajax:ShowLoader( 2 );
		
		local sEmail	= self.LoginBox:GetText();
		local sPasswd	= self.PasswordBox:GetText();
		local sCode		= self.CodeBox:GetText();
		
		if sEmail and sPasswd then
			if sEmail:len() > 0 and sPasswd:len() > 0 then
				self.timerLogin = CTimer(
					function()
						self:error( "Превышено время ожидания ответа от сервера" );
					end,
					10000, 1
				);
				
				CTimer(
					function()
						SERVER.TryLogin( sEmail, sPasswd, self.RememberMe:GetSelected(), sCode );
					end,
					math.random( 50, 1000 ), 1
				);
				
				return;
			end
		end
		
		self:error( "Введите e-mail и пароль" );
	end
	
	self.LoginBox.Accept	= self.Login.Click;
	self.PasswordBox.Accept	= self.LoginBox.Accept;
	self.CodeBox.Accept		= self.LoginBox.Accept;
	
	function self.RegLink.Click( button )
		if not self.Window:GetEnabled() then
			return;
		end
		
		delete( pDialog );
		pDialog = NULL;
		
		SERVER.RegDialog();
	end
	
	function self.Login.MouseEnter()
		self.Login:LoadImage( "Resources/Images/ButtonHover.png" );
	end
	
	function self.Login.MouseLeave()
		self.Login:LoadImage( "Resources/Images/Button.png" );
	end

	function self.RegLink.MouseEnter()
		self.RegLink:SetColor( 200, 0, 128 );
	end
	
	function self.RegLink.MouseLeave()
		self.RegLink:SetColor( 0, 64, 255 );
	end

	self.Window:SetVisible( true );
	self:ShowCursor();
end

function LoginScreen:_LoginScreen()
	Ajax:HideLoader();
	
	self.Window:Delete();
	self:HideCursor();
	
	if self.timerLogin then
		self.timerLogin:Kill();
		self.timerLogin = nil;
	end
end

function LoginScreen:SetLocked( bLoked )
	self.Window:SetEnabled( not bLoked );
end

function LoginScreen:error( sText )
	Ajax:HideLoader();
	
	if self.timerLogin then
		self.timerLogin:Kill();
		self.timerLogin = nil;
	end
	
	if self.Window then
		self.ErrorBox:SetText( sText );
		self.ErrorBox2:SetText( sText );
		self.ErrorBox:SetColor( 255, 0, 0 );
		
		self:SetLocked( false );
	end
end

function ShowLoginScreen( bVisible, bRegistered, sLogin, sPasswd )
	if pDialog then
		delete( pDialog );
		pDialog	= NULL;
	end

	if bVisible then
		pDialog = LoginScreen( sLogin, sPasswd );
		
		if bRegistered then
			pDialog.ErrorBox:SetText( sRegSuccess );
			pDialog.ErrorBox2:SetText( sRegSuccess );
			pDialog.ErrorBox:SetColor( 0, 200, 0 );
		end
	end
end

function LoginResults( iCode, ... )
	if pDialog then
		if iCode == 1 then
			pDialog:error( "Неверный логин или пароль" );
		elseif iCode == 2 then
			local Args = { ... };
			
			local Reason	= Args[ 1 ] and " (" + Args[ 1 ] + ")" or "";
			local Admin		= Args[ 2 ] and "администратором " + Args[ 2 ] or "";
			
			pDialog:error( "Ваш аккаунт заблокирован " + Admin + Reason );
		elseif iCode == 3 then
			pDialog:error( "Ваш аккаунт не активирован" );
			
			pDialog.Background:SetSize	( 470, 440, false );
			pDialog.Window:SetSize		( 470, 440, false );
			
			pDialog.Login:SetPosition		( 352, 378, false );
			pDialog.RememberMe:SetPosition	( 35, 378, false );
			
			pDialog.CodeBox:SetVisible( true );
			pDialog.lblCodeTitle:SetVisible( true );
		elseif iCode == 4 then
			pDialog:error( "Ошибка при работе с базой данных" );
		elseif iCode == 5 then
			pDialog:error( "Другой игрок в настоящее время находится под этим аккаунтом" );
		end
	end
end