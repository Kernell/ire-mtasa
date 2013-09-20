-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local scrX, scrY 	= guiGetScreenSize();

local Register 		= CGUI();
local Rules			= CGUI();

function Register:__init()
	if self.Window then
		self:Close();
	end
	
	self.Window	= self:CreateStaticImage( "Resources/Images/Aero.png" )
	{
		X		= "center";
		Y		= "center";
		Width	= 470;
		Height	= 500;
	}
	
	self.Window:CreateLabel( "Registration" )
	{
		X		= 31;
		Y		= 38;
		Width	= 406;
		Height	= 57;
		Font	= ConsolasBold32;
		Color	= { 0, 0, 0 };
	}
	
	self.Window:CreateLabel( "Registration" )
	{
		X		= 30;
		Y		= 37;
		Width	= 406;
		Height	= 57;
		Font	= ConsolasBold32;
	}
	
	self.ErrorBox		= self.Window:CreateLabel( "" )
	{
		X				= 31;
		Y				= 105;
		Width			= 405;
		Height			= 23;
		Font			= Consolas12;
		Color			= { 255, 0, 0 };
		HorizontalAlign	= { "center", false };
	}
	
	self.Window:CreateLabel( "E-Mail:" )
	{
		X		= 30;
		Y		= 138;
		Width	= 204;
		Height	= 22;
		Font	= Consolas10;
	}
	
	self.Window:CreateLabel( "Пароль:" )
	{
		X		= 30;
		Y		= 208;
		Width	= 204;
		Height	= 22;
		Font	= Consolas10;
	}
	
	self.Window:CreateLabel( "Отображаемое имя (Nickname):" )
	{
		X		= 30;
		Y		= 278;
		Width	= 204;
		Height	= 22;
		Font	= Consolas10;
	}
	
	self.Window:CreateLabel( "Ник друга который Вас пригласил:" )
	{
		X			= 30;
		Y			= 348;
		Width		= 244;
		Height		= 22;
		Font		= Consolas10;
		MaxLength	= 64;
	}
	
	self.LoginBox	= self.Window:CreateEdit( "" )
	{
		X			= 30;
		Y			= 160;
		Width		= 407;
		Height		= 28;
		MaxLength	= 64;
	}
	
	self.LoginBox:SetAlpha( .8 );
	
	self.PasswordBox	= self.Window:CreateEdit( "" )
	{
		X			= 30;
		Y			= 230;
		Width		= 407;
		Height		= 28;
		MaxLength	= 64;
		Masked		= true;
	}
	
	self.PasswordBox:SetAlpha( .8 );
	
	self.Nick	= self.Window:CreateEdit( "" )
	{
		X			= 30;
		Y			= 300;
		Width		= 407;
		Height		= 28;
		MaxLength	= 64;
	}
	
	self.Nick:SetAlpha( .8 );
	
	self.ReferBox		= self.Window:CreateEdit( "" )
	{
		X			= 30;
		Y			= 370;
		Width		= 407;
		Height		= 28;
		MaxLength	= 64;
	}
	
	self.ReferBox:SetAlpha( .8 );
	
	self.Checkbox	= self.Window:CreateCheckBox( "Присоединиться к программе улучшения качества ПО" )
	{
		X			= 30;
		Y			= 402;
		Width		= 407; 
		Height		= 27;
		Selected	= false;
	}
	
	self.Checkbox:SetVisible( false );	
	self.Checkbox:SetFont( "default-bold-small" );
	
	self.Register	= self.Window:CreateStaticImage( "Resources/Images/Button.png" )
	{
		X			= 352;
		Y			= 430;
		Width		= 83;
		Height		= 28;
	}
	
	self.Register:CreateLabel( "Регистрация" )
	{
		X				= 1;
		Y				= 5;
		Width			= 83;
		Height			= 28;
		HorizontalAlign	= { "center", true };
		Color			= { 0, 0, 0 };
	}
	
	self.Cancel	= self.Window:CreateStaticImage( "Resources/Images/Button.png" )
	{
		X		= 262;
		Y		= 430;
		Width	= 83;
		Height	= 28;
	}
	
	self.Cancel:CreateLabel( "Отмена" )
	{
		X				= 1;
		Y				= 5;
		Width			= 83;
		Height			= 28;
		HorizontalAlign	= { "center", true };
		Color			= { 0, 0, 0 };
	}
	
	self.Window:SetVisible( false );
	
	--// Callbacks
	
	function self.Register.Click( button )
		if not self.Window:GetEnabled() then
			return;
		end
		
		self.LoginBox:SetProperty( 'NormalTextColour', 'FF000000' );
		self.PasswordBox:SetProperty( 'NormalTextColour', 'FF000000' );
		self.Nick:SetProperty( 'NormalTextColour', 'FF000000' );
		self.ReferBox:SetProperty( 'NormalTextColour', 'FF000000' );
		
		self:SetLocked( true );
		
		Ajax:ShowLoader( 2 );
		
		local Login 		= self.LoginBox:GetText();
		local Password 		= self.PasswordBox:GetText();
		local Nick 			= self.Nick:GetText();
		local Refer			= self.ReferBox:GetText();

		self.TimerReg = CTimer(
			function()
				self:error( "Ошибка регистрации, попробуйте позже" );
			end,
			10000, 1
		);
		
		CTimer(
			function()
				SERVER.Register( Login, Password, Nick, Refer, self.Checkbox:GetSelected() );
			end,
			math.random( 100, 1000 ), 1
		);
	end
	
	function self.Cancel.Click( button )
		if not self.Window:GetEnabled() then
			return;
		end
		
		self:Close();
		
		ShowLoginScreen( true );
	end
	
	function self.Register.MouseEnter()
		self.Register:LoadImage( "Resources/Images/ButtonHover.png" );
	end
	
	function self.Register.MouseLeave()
		self.Register:LoadImage( "Resources/Images/Button.png" );
	end
	
	function self.Cancel.MouseEnter()
		self.Cancel:LoadImage( "Resources/Images/ButtonHover.png" );
	end
	
	function self.Cancel.MouseLeave()
		self.Cancel:LoadImage( "Resources/Images/Button.png" );
	end
	
	return self;
end

function Register:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();
	
	showCursor( true );
	
	Ajax:HideLoader();
end

function Register:Close()
	self.Window:Delete();
	self.Window = NULL;
	
	showCursor( false );
	
	if self.TimerReg then
		self.TimerReg:Kill();
		self.TimerReg = NULL;
	end
	
	Ajax:HideLoader();
end

function Register:SetLocked( bool )
	self.Window:SetEnabled( not bool );
end

function Register:error( sMessage )
	if self.TimerReg then
		self.TimerReg:Kill();
		self.TimerReg = NULL;
	end
	
	if self.Window then
		self.ErrorBox:SetText( sMessage );
		
		self:SetLocked( false );
	end
	
	Ajax:HideLoader();
end

function Rules:__init( rules )
	if self.Window then
		self:Close();
	end
	
	self.Window	= self:CreateStaticImage( "Resources/images/Aero.png" )
	{
		X		= ( scrX - 800 ) / 2;
		Y		= ( scrY - 600 ) / 2;
		Width	= 800;
		Height	= 600;
	}
	
	self.Memo	= self.Window:CreateMemo( rules )
	{
		X			= 47;
		Y			= 60;
		Width		= 700;
		Height		= 440;
		ReadOnly	= true;
	}
	
	self.Memo:SetAlpha( .8 );
	
	self.Disagree	= self.Window:CreateStaticImage( "Resources/images/Button.png" )
	{
		X		= 270;
		Y		= 520;
		Width	= 83;
		Height	= 28;
	}
	
	self.Disagree:CreateLabel( "Отклонить" )
	{
		X				= 1;
		Y				= 5;
		Width			= 83;
		Height			= 28;
		HorizontalAlign	= { "center", true };
		Color			= { 0, 0, 0 };
	}
	
	self.Agree	= self.Window:CreateStaticImage( "Resources/images/Button.png" )
	{
		X		= 430;
		Y		= 520;
		Width	= 83;
		Height	= 28;
	}
	
	self.Agree:CreateLabel( "Принять" )
	{
		X				= 1;
		Y				= 5;
		Width			= 83;
		Height			= 28;
		HorizontalAlign	= { "center", true };
		Color			= { 0, 0, 0 };
	}
	
	function self.Disagree.Click( button )
		self:Close();
		
		ShowLoginScreen( true );
	end
	
	function self.Agree.Click( button )
		self:Close();
		
		Register:__init():Open();
	end
	
	function self.Disagree.MouseEnter()
		self.Disagree:LoadImage( "Resources/Images/ButtonHover.png" );
	end
	
	function self.Disagree.MouseLeave()
		self.Disagree:LoadImage( "Resources/Images/Button.png" );
	end
	
	function self.Agree.MouseEnter()
		self.Agree:LoadImage( "Resources/Images/ButtonHover.png" );
	end
	
	function self.Agree.MouseLeave()
		self.Agree:LoadImage( "Resources/Images/Button.png" );
	end
	
end

function Rules:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();
	
	showCursor( true );
	
	Ajax:HideLoader();
end

function Rules:Close()
	self.Window:Delete();
	self.Window = NULL;
	
	showCursor( false );	
	Ajax:HideLoader();
end

function Registration( rules )
	Rules:__init( rules );
	Rules:Open();
end

function RegistrationError( eErrorData )
	if eErrorData then
		Register:error( eErrorData[ 1 ] );
		
		if eErrorData[ 2 ] then
			CGUI.SetProperty( Register[ eErrorData[ 2 ] ], 'NormalTextColour', 'FFFF0000' );
		end
		
		return;
	end

	Register:Close();
	ShowLoginScreen( true, true );
end