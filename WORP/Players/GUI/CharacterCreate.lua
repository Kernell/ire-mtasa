-- Author:      	Kernell
-- Version:     	1.0.0

local month 			= {	"Январь", 	"Февраль", 	"Март", 	"Апрель", 	"Май", 	"Июнь", 	"Июль", 	"Август", 	"Сентябрь", 	"Октябрь", 	"Ноябрь", 	"Декабрь" };
local days				= { 31,		 	28, 		31,  		30, 		31, 	30, 		31, 		31, 		30, 			31, 		30, 		31 };
local scrX, scrY		= guiGetScreenSize();

local WarningMessage	= [[Внимание!
Не в коем случае не указывайте свои реальные данные!
Все данные должны быть вымышленными и соответствовать придуманной биографии Вашего персонажа
]]

local start_rot, mouse_down, start_x = 0, 0, false;

local pDialog		= NULL;

class "CGUICreateChar" ( CGUI );

function CGUICreateChar:CGUICreateChar( Skins, sRandomName, sRandomSurname )
	if pDialog then
		delete ( pDialog );
	end
	
	pDialog		= self;
	
	self.skin	= Skins[ math.random( table.getn( Skins ) ) ];
	
	self.Window	= self:CreateWindow( "Создание персонажа" )
	{
		X		= "center";
		Y		= "center";
		Width	= 440;
		Height	= 490;
	}
	
	self.Window:CreateLabel( "Укажите информацию о Вашем новом персонаже" )
	{
		X		= 25;
		Y		= 40;
		Width	= 350;
		Height	= 28;
		Font	= "default-bold-small";
	}
	
	self.Window:CreateLabel( "Имя:" )
	{
		X		= 25;
		Y		= 80;
		Width	= 100;
		Height	= 28;
		Font	= "default-bold-small";
	}
	
	self.editName	= self.Window:CreateEdit( "" )
	{
		X			= 180;
		Y			= 80;
		Width		= 220;
		Height		= 24;
		MaxLength	= 11;
	}
	
	self.Window:CreateLabel( "Например: " + sRandomName )
	{
		X		= 185;
		Y		= 105;
		Width	= 200;
		Height	= 28;
		Font	= "default-bold-small";
		Color	= { 128, 255, 255 };
	}
	
	self.Window:CreateLabel( "Фамилия:" )
	{
		X		= 25;
		Y		= 130;
		Width	= 100;
		Height	= 28;
		Font	= "default-bold-small";
	}
	
	self.editSurname = self.Window:CreateEdit( "" )
	{
		X			= 180;
		Y			= 130;
		Width		= 220;
		Height		= 24;
		MaxLength	= 11;
	}
	
	self.Window:CreateLabel( "Например: " + sRandomSurname )
	{
		X		= 185;
		Y		= 155;
		Width	= 200;
		Height	= 28;
		Font	= "default-bold-small";
		Color	= { 128, 255, 255 };
	}
	
	self.Window:CreateLabel( "Дата рождения:" )
	{
		X		= 25;
		Y		= 180;
		Width	= 100;
		Height	= 28;
		Font	= "default-bold-small";
	}
	
	self.boxDateOfBirth_D	= self.Window:CreateComboBox( "" )
	{
		X		= 180;
		Y		= 180;
		Width	= 50;
		Height	= 200;
	}
	
	self.boxDateOfBirth_M	= self.Window:CreateComboBox( "" )
	{
		X		= 235;
		Y		= 180;
		Width	= 90;
		Height	= 200;
	}
	
	self.boxDateOfBirth_Y	= self.Window:CreateComboBox( "" )
	{
		X		= 330;
		Y		= 180;
		Width	= 70;
		Height	= 200;
	}
	
	self.oldM 				= 1;
	
	for m = 1, 12 do 		self.boxDateOfBirth_M:AddItem( month[ m ] ) end		
	for d = 1, 31 do		self.boxDateOfBirth_D:AddItem( (string)(d) ) end
	for y = 1971, 2000  do 	self.boxDateOfBirth_Y:AddItem( (string)(y) ) end
	
	self.Window:CreateLabel( "Место рождения:" )
	{
		X		= 25;
		Y		= 218;
		Width	= 110;
		Height	= 28;
		Font	= "default-bold-small";
	}
	
	self.EditCountry 	= self.Window:CreateEdit( "" )
	{
		X			= 180;
		Y			= 215;
		Width		= 220;
		Height		= 24;
		MaxLength	= 48;
	}
	
	self.EditCountry.Dropdown	= self.Window:CreateGridList{ 180, 239, 220, 196 }
	{
		{ " ", 1.0 }
	};
	
	self.EditCountry.Dropdown:SetScrollBars( false, true );
	self.EditCountry.Dropdown:SetSortingEnabled( false );
	self.EditCountry.Dropdown:SetVisible( false );
	
	self.Window:CreateLabel( "Страна" )
	{
		X		= 185;
		Y		= 240;
		Width	= 250;
		Height	= 28;
		Font	= "default-bold-small";
		Color	= { 128, 255, 255 };
	}
	
	self.EditCity 	= self.Window:CreateEdit( "" )
	{
		X			= 180;
		Y			= 265;
		Width		= 220;
		Height		= 24;
		MaxLength	= 48;
	}
	
	self.Window:CreateLabel( "Город" )
	{
		X			= 185;
		Y			= 293;
		Width		= 250;
		Height		= 28;
		Font		= "default-bold-small";
		Color		= { 128, 255, 255 };
	}
	
	self.EditCity.Dropdown	= self.Window:CreateGridList{ 180, 292, 220, 196 }
	{
		{ " ", 1.0 }
	};
	
	self.EditCity.Dropdown:SetScrollBars( false, true );
	self.EditCity.Dropdown:SetSortingEnabled( false );
	self.EditCity.Dropdown:SetVisible( false );
	
	self.Window:CreateLabel( "Скин:" )
	{
		X			= 25;
		Y			= 320;
		Width		= 100;
		Height		= 28;
		Font		= "default-bold-small";
	}
	
	self.editSkin	= self.Window:CreateEdit( self.skin )
	{
		X			= 180;
		Y			= 320;
		Width		= 70;
		Height		= 24;
		ReadOnly	= true;
	}
	
	self.buttonSkin	= self.Window:CreateButton( "Обзор" )
	{
		X			= 330;
		Y			= 320;
		Width		= 70;
		Height		= 24;
	}
	
	self.Window:CreateLabel( "Национальность:" )
	{
		X			= 25;
		Y			= 360;
		Width		= 100;
		Height		= 28;
		Font		= "default-bold-small";
	}
	
	self.comboBoxNation	= self.Window:CreateComboBox( "" )
	{
		X			= 180;
		Y			= 360;
		Width		= 220;
		Height		= 140;
	}
	
	for key, value in pairs( getLanguages() ) do
		self.comboBoxNation:AddItem( value.male );
	end
	
	self.labelInfo2		= self.Window:CreateLabel( WarningMessage )
	{
		X				= 25;
		Y				= 385;
		Width			= 360;
		Height			= 64;
		Font			= "default-bold-small";
		Color			= { 255, 0, 0 };
		HorizontalAlign	= { "left", true };
	}
	
	self.buttonCreate 	= self.Window:CreateButton( "Создать" )
	{
		X			= 240;
		Y			= 445;
		Width		= 83; 
		Height		= 28;
	}
	
	self.buttonCancel 	= self.Window:CreateButton( "Отмена" )
	{
		X			= 330;
		Y			= 445;
		Width		= 83; 
		Height		= 28;
	}
	
	self.buttonBack		= self:CreateStaticImage( "Resources/Images/arrow_l_gray.png" )
	{
		X			= ( scrX - 128 ) / 4;
		Y			= scrY / 2;
		Width		= 128;
		Height		= 128;
	}
	
	self.buttonSelect	= self:CreateStaticImage( "Resources/Images/select_gray.png" )
	{
		X			= ( scrX - 128 ) / 2;
		Y			= scrY - ( ( scrY - 128 ) / 4 );
		Width		= 128;
		Height		= 128;
	}
	
	self.buttonNext		= self:CreateStaticImage( "Resources/Images/arrow_r_gray.png" )
	{
		X			= scrX - ( ( scrX - 128 ) / 3 );
		Y			= scrY / 2;
		Width		= 128;
		Height		= 128;
	}
	
	self.buttonBack:SetVisible	( false );
	self.buttonSelect:SetVisible( false );
	self.buttonNext:SetVisible	( false );
	
	function self.EditCountry.Dropdown.Click( button, state )
		if button == "left" and state == "up" then
			local item 			= self.EditCountry.Dropdown:GetSelectedItem();
			
			if not item or item == -1 then
				return;
			end
			
			local pResultItem = self.EditCountry.Dropdown.Result[ item + 1 ];
			
			if pResultItem then
				self.EditCountry.m_iCountryID = tonumber( pResultItem.id );
				
				self.EditCountry.Skip = true;
				self.EditCountry:SetText( pResultItem.name );
			else
				self.EditCountry.m_iCountryID = NULL;
				
				self.EditCountry:SetText( "" );
			end
			
			self.EditCity.Dropdown.m_iCityID		= NULL;
			
			self.EditCity:SetText( "" );
			
			self.EditCountry.Dropdown:SetVisible( false );
		end
	end
	
	function self.EditCity.Dropdown.Click( button, state )
		if button == "left" and state == "up" then
			local item 			= self.EditCity.Dropdown:GetSelectedItem();
			
			if not item or item == -1 then
				return;
			end
			
			local pResultItem = self.EditCity.Dropdown.Result[ item + 1 ];
			
			if pResultItem then
				self.EditCity.m_iCityID = tonumber( pResultItem.id );
				
				self.EditCity.Skip = true;
				self.EditCity:SetText( pResultItem.name );
			else
				self.EditCity.m_iCityID = NULL;
				
				self.EditCity:SetText( "" );
			end
			
			self.EditCity.Dropdown:SetVisible( false );
		end
	end
	
	function self.EditCountry.Change()
		if self.EditCountry.Skip then
			self.EditCountry.Skip = NULL;
			
			return;
		end
		
		self.EditCountry.Dropdown:SetVisible( false );
		
		if self.EditCountry.m_pTimer then
			delete ( self.EditCountry.m_pTimer );
			self.EditCountry.m_pTimer = NULL;
		end
		
		self.EditCountry.m_pTimer = CTimer(
			function()
				local sText = (string)(self.EditCountry:GetText());
				
				if sText:utfLen() > 1 then		
					SERVER.SearchCountry( sText, "CGUICreateChar_SearchCountry" );
				end
				
				self.EditCountry.m_pTimer = NULL;
			end,
			300, 1
		);
	end
	
	function self.EditCity.Change()
		if self.EditCity.Skip then
			self.EditCity.Skip = NULL;
			
			return;
		end
		
		self.EditCity.Dropdown:SetVisible( false );
		
		if self.EditCity.m_pTimer then
			delete ( self.EditCity.m_pTimer );
			self.EditCity.m_pTimer = NULL;
		end
		
		if self.EditCountry.m_iCountryID then
			self.EditCity.m_pTimer = CTimer(
				function()
					local sText = (string)(self.EditCity:GetText());
					
					if sText:utfLen() > 1 then		
						SERVER.SearchCity( sText, self.EditCountry.m_iCountryID, "CGUICreateChar_SearchCity" );	
					end
					
					self.EditCity.m_pTimer = NULL;
				end,
				300, 1
			);
		end
	end
	
	function self.buttonBack.Click()
		self.skin = self.skin > 1 and self.skin - 1 or table.getn( Skins );
		
		self.ped.target_x, self.ped.target_y, self.ped.target_z = self.target_rx, self.target_ry, self.target_rz;
	end

	function self.buttonNext.Click()
		self.skin = self.skin < table.getn( Skins ) and self.skin + 1 or 1;
		
		self.ped.target_x, self.ped.target_y, self.ped.target_z = self.target_lx, self.target_ly, self.target_lz;
	end

	function self.buttonSelect.Click()
		self.editSkin:SetText( (string)(Skins[ self.skin ]) );
		
		local l = self.comboBoxNation:GetSelected();
		
		self.comboBoxNation:Clear();
		
		for key, value in pairs( getLanguages() ) do
			self.comboBoxNation:AddItem( value[ self.ped:GetSkin():GetGender() ] );
		end
		
		self.comboBoxNation:SetSelected( l );
		
		self.buttonBack:SetVisible( false );
		self.buttonSelect:SetVisible( false );
		self.buttonNext:SetVisible( false );
		
		self.ped:Destroy();
		self.obj:Destroy();
		
		removeEventHandler( 'onClientRender', root, self.UpdPedRotation );
		removeEventHandler( 'onClientClick', root, self.OnClick );
		
		self.Window:SetVisible( true );
	end
	
	function self.buttonCancel.Click()
		delete ( self );

		SERVER.LoadCharacters();
	end
	
	function self.buttonCreate.Click()
		local date		= ( "%s-%02d-%02d" ):format( self.boxDateOfBirth_Y:GetItemText( self.boxDateOfBirth_Y:GetSelected() ), self.boxDateOfBirth_M:GetSelected() + 1, self.boxDateOfBirth_D:GetSelected() + 1 );
		local lang		= self.comboBoxNation:GetItemText( self.comboBoxNation:GetSelected() );
		
		for key, v in pairs( getLanguages() ) do
			if v.male == lang or v.female == lang then
				lang = key;
				
				break;
			end
		end
		
		local iCountryID	= self.EditCountry.m_iCountryID;
		local iCityID		= self.EditCity.m_iCityID;
		
		SERVER.CreateCharacter( self.editName:GetText(), self.editSurname:GetText(), (int)(self.editSkin:GetText()), date, lang, iCountryID, iCityID );
	end
	
	function self.buttonSkin.Click()
		self.Window:SetVisible( false );
		
		self.buttonBack:SetVisible	( true );
		self.buttonSelect:SetVisible( true );
		self.buttonNext:SetVisible	( true );
		
		self.target_x, self.target_y, self.target_z 		= getWorldFromScreenPosition( scrX / 2, scrY / 2, 3 );
		self.target_lx, self.target_ly, self.target_lz		= getWorldFromScreenPosition( 0 - scrX * .5, scrY / 2, 3 );
		self.target_rx, self.target_ry, self.target_rz		= getWorldFromScreenPosition( scrX * 1.5, scrY / 2, 3 );
		
		local skin				= tonumber( self.editSkin:GetText() ) or Skins[ 1 ];
		
		for i = 1, table.getn( Skins ) do
			if Skins[ i ] == skin then
				self.skin		= i;
				
				break;
			end
		end
		
		local anims = { "shift", "shldr", "stretch", "strleg", "time" };
		
		self.ped	= CPed.Create( skin, Vector3( self.target_lx, self.target_ly, self.target_lz ) );
		
		self.ped:SetDimension( getElementDimension( localPlayer ) );
		self.ped:SetInterior( getElementInterior( localPlayer ) );
		self.ped:SetAnimation( "PED", GetAnimation( self.ped:GetSkin().GetAnimGroup(), 0 ), -1, true, true, false, false );
		self.ped:SetFrozen( true );
		-- self.ped:SetCollisionsEnabled( false );
		
		self.obj	= CObject.Create( 3115, Vector3( self.target_x, self.target_y, self.target_z - 1.15 ) );
		self.obj:SetAlpha( 0 );
		
		self.ped.target_x, self.ped.target_y, self.ped.target_z = self.target_x, self.target_y, self.target_z;
		
		self.UpdPedRotation = function()
			local rot = mouse_down and start_rot + ( ( getCursorPosition() - start_x ) * 360 ) or getPedRotation( self.ped.__instance ) - 1;
			local x, y, z = getElementPosition( self.ped.__instance );
			
			x = x + ( self.ped.target_x - x ) * .09;
			y = y + ( self.ped.target_y - y ) * .09;
			z = z + ( self.ped.target_z - z ) * .09;
			
			setElementRotation( self.ped.__instance, 0, 0, rot );
			setElementPosition( self.ped.__instance, x, y, z, false );
			
			if 	math.floor( x ) == math.floor( self.target_rx ) and math.floor( self.ped.target_x ) == math.floor( self.target_rx ) and
				math.floor( y ) == math.floor( self.target_ry ) and math.floor( self.ped.target_y ) == math.floor( self.target_ry ) and
				math.floor( z ) == math.floor( self.target_rz ) and math.floor( self.ped.target_z ) == math.floor( self.target_rz )
			then
				self.ped:Destroy();
				self.ped	= CPed.Create( Skins[ self.skin ], Vector3( self.target_lx, self.target_ly, self.target_lz ) );

				setElementRotation( self.ped.__instance, 0, 0, rot );
				
				self.ped:SetDimension( CLIENT:GetDimension() );
				self.ped:SetInterior( CLIENT:GetInterior() );
				self.ped:SetAnimation( "PED", GetAnimation( self.ped:GetSkin().GetAnimGroup(), 0 ), -1, true, true, false, false );
				self.ped:SetFrozen( true );
				
				self.ped.target_x, self.ped.target_y, self.ped.target_z = self.target_x, self.target_y, self.target_z;
			elseif 	
				math.floor( x ) == math.floor( self.target_lx ) and math.floor( self.ped.target_x ) == math.floor( self.target_lx ) and
				math.floor( y ) == math.floor( self.target_ly ) and math.floor( self.ped.target_y ) == math.floor( self.target_ly ) and
				math.floor( z ) == math.floor( self.target_lz ) and math.floor( self.ped.target_z ) == math.floor( self.target_lz )
			then
				self.ped:Destroy();
				self.ped	= CPed.Create( Skins[ self.skin ], Vector3( self.target_rx, self.target_ry, self.target_rz ) );

				setElementRotation( self.ped.__instance, 0, 0, rot );
				
				self.ped:SetDimension( CLIENT:GetDimension() );
				self.ped:SetInterior( CLIENT:GetInterior() );
				self.ped:SetAnimation( "PED", GetAnimation( self.ped:GetSkin().GetAnimGroup(), 0 ), -1, true, true, false, false );
				self.ped:SetFrozen( true );
				
				self.ped.target_x, self.ped.target_y, self.ped.target_z = self.target_x, self.target_y, self.target_z;
			end
		end
		
		self.OnClick = function( button, state )
			if self.ped and self.ped.__instance then
				mouse_down = state == 'down';
				
				if mouse_down then
					start_x		= getCursorPosition();
					start_rot 	= getPedRotation( self.ped.__instance );
				end
			else
				mouse_down = false;
			end
		end
		
		addEventHandler( 'onClientRender', root, self.UpdPedRotation );
		addEventHandler( 'onClientClick', root, self.OnClick );
	end
	
	function self.boxDateOfBirth_M.Accept()
		local m = self.boxDateOfBirth_M:GetSelected();
		
		if not m or m == -1 then
			return;
		end
		
		m = m + 1;
		
		if self.oldM == m then
			return;
		end
		
		self.oldM = m;
		
		self.boxDateOfBirth_D:Clear();
		
		for d = 1, days[ m ] do	
			self.boxDateOfBirth_D:AddItem( tostring( d ) ); 
		end
		self.boxDateOfBirth_D:SetSelected( 0 );
	end
	
	function self.buttonBack.MouseEnter()
		self.buttonBack:LoadImage( "Resources/images/arrow_l_blue.png" );
	end
	
	function self.buttonBack.MouseLeave()
		self.buttonBack:LoadImage( "Resources/images/arrow_l_gray.png" );
	end
	
	function self.buttonSelect.MouseEnter()
		self.buttonSelect:LoadImage( "Resources/images/select_green.png" );
	end
	
	function self.buttonSelect.MouseLeave()
		self.buttonSelect:LoadImage( "Resources/images/select_gray.png" );
	end
	
	function self.buttonNext.MouseEnter()
		self.buttonNext:LoadImage( "Resources/images/arrow_r_blue.png" );
	end
	
	function self.buttonNext.MouseLeave()
		self.buttonNext:LoadImage( "Resources/images/arrow_r_gray.png" );
	end
		
	self.boxDateOfBirth_D:SetSelected( 0 );
	self.boxDateOfBirth_M:SetSelected( 0 );
	self.boxDateOfBirth_Y:SetSelected( 0 );	

	self.comboBoxNation:SetSelected( 3 );

	self.Window:SetVisible( true );
	self.Window:BringToFront();

	self:ShowCursor();
end

function CGUICreateChar:_CGUICreateChar()
	self.Window:Delete();
	self.Window = NULL;
	
	self:HideCursor();
	
	pDialog	= NULL;
end

function CharacterCreateResult( iCode )
	if iCode == 0x000000FF then
		if pDialog then
			delete ( pDialog );
		end
	else
		local Messages	=
		{
			[0x290962] = "Персонаж с таким именем уже существует";
			[0xF4D1DC] = "Ошибка при работе с базой данных";
			[0x057072] = "Имя слишком короткое";
			[0x095772] = "Фамилия слишком короткая";
			[0xB855A7] = "Общая длина имени и фамилии не может быть более 21 символа";
			[0xF10FAC] = "Имя содержит запрещённые символы\n\nИспользуйте символы латинского алфавита";
			[0xB78134] = "Фамилия содержит запрещённые символы\n\nИспользуйте символы латинского алфавита";
			[0x2EA069] = "Вы не можете создавать больше персонажей";
			[0x01F7AB] = "Необходимо выбрать Страну из списка";
			[0xE601F3] = "Необходимо выбрать Город из списка";
			[0x6500AD] = "Вы не выбрали скин персонажа";
			[0x36A0B0] = "Данный скин отключён";
			[0x77D56E] = "Вы не выбрали национальность";
			[0x496E76] = "Поле 'Место рождения' заполнено некорректно";
		};
		
		MessageBox:Show( Messages[ iCode ] or "Неизвестная ошибка", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
	end
end

function CGUICreateChar_SearchCountry( Result )
	if not pDialog then return; end
	
	pDialog.EditCountry.m_iCountryID = NULL;
	
	if type( Result ) == 'table' then
		pDialog.EditCountry.Dropdown:Clear();
		
		if table.getn( Result ) > 0 then
			for i, pCountry in ipairs( Result ) do
				local iRow 	= pDialog.EditCountry.Dropdown:AddRow();
				
				if iRow then
					pDialog.EditCountry.Dropdown:SetItemText( iRow, pDialog.EditCountry.Dropdown[ " " ], pCountry.name, false, false );
				end
			end
			
			pDialog.EditCountry.Dropdown.Result = Result;
			
			pDialog.EditCountry.Dropdown:SetVisible( true );
			pDialog.EditCountry.Dropdown:BringToFront();
		end
	end
end

function CGUICreateChar_SearchCity( Result )
	if not pDialog then return; end
	
	pDialog.EditCity.m_iCityID = NULL;
	
	if type( Result ) == 'table' then
		pDialog.EditCity.Dropdown:Clear();
		
		if table.getn( Result ) > 0 then
			for i, pCity in ipairs( Result ) do
				local iRow 	= pDialog.EditCity.Dropdown:AddRow();
				
				if iRow then
					pDialog.EditCity.Dropdown:SetItemText( iRow, pDialog.EditCity.Dropdown[ " " ], pCity.name + ' (' + pCity.state + ')', false, false );
				end
			end
			
			pDialog.EditCity.Dropdown.Result = Result;
			
			pDialog.EditCity.Dropdown:SetVisible( true );
			pDialog.EditCity.Dropdown:BringToFront();
		end
	end
end