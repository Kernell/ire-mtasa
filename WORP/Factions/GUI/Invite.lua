-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local Invites		= CGUI();

function Invites:Init()
	if self.Window then
		self:Close();
	end
	
	self.Window	= self:CreateWindow( "Ваши приглашения" )
	{
		X		= "center";
		Y		= "center";
		Width	= 450;
		Height	= 250;
		Sizable	= false;
	}
	
	self.List	= self.Window:CreateGridList{ 0, 20, 450, 200 }
	{
		{ "Фракция", .5 };
		{ "Пригласил", .3 };
		{ "Дата", .15 };
	}
	
	self.btnClose	= self.Window:CreateButton( "Закрыть" )
	{
		X		= 370;
		Y		= 220;
		Width	= 75;
		Height	= 25;
	}
	
	self.btnAccept	= self.Window:CreateButton( "Принять" )
	{
		X		= 5;
		Y		= 220;
		Width	= 75;
		Height	= 25;
	}
	
	self.btnDecline	= self.Window:CreateButton( "Отклонить" )
	{
		X		= 85;
		Y		= 220;
		Width	= 75;
		Height	= 25;
	}
	
	self.btnAccept:SetEnabled( false );
	self.btnDecline:SetEnabled( false );
	
	self.btnClose.Click = function()
		self:Close();
	end
	
	self.btnAccept.Click = function()
		local item 	= self.List:GetSelectedItem();
		
		if item and item ~= -1 then
			local id = self.List.Items[ item ];
			
			if id then
				local buttons = MessageBox:Show( "Вы действительно хотите принять это приглашение?", "Приглашение от: " + self.List:GetItemText( item, self.List[ 'Фракция' ] ), MessageBoxButtons.YesNo, MessageBoxIcon.Question );
				
				buttons[ 'Да' ][ 'Click' ] = function()
					SERVER.FAcceptInvite( id );
				end
				
				return;
			end
		end
		
		self.btnAccept:SetEnabled( false );
		self.btnDecline:SetEnabled( false );
	end
	
	self.btnDecline.Click = function()
		local item 	= self.List:GetSelectedItem();
		
		if item and item ~= -1 then
			local id = self.List.Items[ item ];
			
			if id then
				local buttons = MessageBox:Show( "Вы действительно хотите отклонить это приглашение?", "Приглашение от: " + self.List:GetItemText( item, self.List[ 'Фракция' ] ), MessageBoxButtons.YesNo, MessageBoxIcon.Question );
				
				buttons[ 'Да' ][ 'Click' ] = function()
					SERVER.FDeclineInvite( id );
				end
				
				return;
			end
		end
		
		self.btnAccept:SetEnabled( false );
		self.btnDecline:SetEnabled( false );
	end
	
	self.List.Click		= function()
		local item 	= self.List:GetSelectedItem();
		
		if item and item ~= -1 then
			local id = self.List.Items[ item ];
			
			if id then
				self.btnAccept:SetEnabled( true );
				self.btnDecline:SetEnabled( true );
				
				return;
			end
		end
		
		self.btnAccept:SetEnabled( false );
		self.btnDecline:SetEnabled( false );
	end
end

function Invites:Fill( aInvites )
	self:Clear();
	self.Items = {};
	
	for i, row in ipairs( aInvites ) do
		self:AddItem( row );
	end
end

function Invites:AddItem( row )
	local gridRow		= self:AddRow();
	
	self:SetItemText	( gridRow, self[ 'Фракция' ],	row.faction,		false, false );
	self:SetItemText	( gridRow, self[ 'Пригласил' ],	row.inviter or 'Неизвестно',	false, false );
	self:SetItemText	( gridRow, self[ 'Дата' ], 		row.date,			false, false );
	
	self.Items[ gridRow ]	= row.id;
end

function Invites:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();

	self:ShowCursor();
	
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
end

function Invites:Close()
	self.Window:Delete();
	self.Window = nil;
	
	self:HideCursor();
	
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
end

function FShowInvites( aInvites )
	Invites:Init();
	
	if aInvites then
		Invites.List:Fill( aInvites );
		Invites:Open();
	end
end

local Invite = CGUI();

function Invite:Init( iID )
	if self.Window then
		self:Close();
	end
	
	self.Window	= self:CreateWindow( "" )
	{
		X		= "center";
		Y		= "center";
		Width	= 350;
		Height	= 300;
		Sizable = false;
	}
	
	self.List	= self.Window:CreateGridList{ 0, 20, 350, 215 }
	{
		{ "ID", .1 };
		{ "Имя Фамилия", .8 };
	}
	
	self.Search	= self.Window:CreateEdit( 'Поиск' )
	{
		X		= 0;
		Y		= 240;
		Width	= 350;
		Height	= 25;
	}
	
	self.btnClose	= self.Window:CreateButton( "Закрыть" )
	{
		X		= 270;
		Y		= 270;
		Width	= 75;
		Height	= 25;
	}
	
	self.btnInvite	= self.Window:CreateButton( "Пригласить" )
	{
		X		= 5;
		Y		= 270;
		Width	= 75;
		Height	= 25;
	}
	
	self.btnInvite:SetEnabled( false );
	
	--
	
	self.btnClose.Click = function()
		self:Close();
	end
	
	self.btnInvite.Click = function()
		self.Window:SetEnabled( false );
	
		Ajax:ShowLoader( 2 );
		
		self.m_pTimer = CTimer(
			function()
				FInviteError( 1 );
				
				self.Window:SetEnabled( true );
			end,
			10000, 1
		);
		
		CTimer(
			function()
				local item = self.List:GetSelectedItem();
		
				if item and item ~= -1 then
					local sName = self.List:GetItemText( item, self.List[ "Имя Фамилия" ] );
					
					if sName then
						SERVER.FInvite( iID, sName );
				
						return;
					end
				end
				
				self.btnInvite:SetEnabled( false );
			end,
			math.random( 500, 1000 ), 1
		);
	end

	self.List.DoubleClick = self.btnInvite.Click;
	
	self.List.Click	= function()
		local item = self.List:GetSelectedItem();
		
		if item and item ~= -1 then
			local sName = self.List:GetItemText( item, self.List[ "Имя Фамилия" ] );
			
			if sName then
				self.btnInvite:SetEnabled( true );
				
				return;
			end
		end
		
		self.btnInvite:SetEnabled( false );
	end
	
	self.Search.Click	= function()
		if self.Search:GetText() == 'Поиск' then
			self.Search:SetText( '' );
		end
	end
	
	self.Search.Change	= function()
		local text = self.Search:GetText();
		
		if text then
			self.List:Fill( text );
		end
	end
end

function Invite:Fill( sSearch )
	self:Clear();
	
	for i, player in ipairs( getElementsByType( "player" ) ) do
		local sName		= getPlayerName( player );
		
		if sName and ( not sSearch or sName:find( sSearch:gsub( ' ', '_' ) ) ) then
			self:AddItem( player, sName );
		end
	end
end

function Invite:AddItem( pPlayer, sName )
	if pPlayer then
		local iID = getElementData( pPlayer, 'player_id' );
		
		if iID then		
			local iRow = self:AddRow();
			
			if iRow then
				self:SetItemText( iRow, self[ 'ID' ], iID,				false, false );
				self:SetItemText( iRow, self[ 'Имя Фамилия' ], sName,	false, false );
			end
		end
	end
end

function Invite:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();

	self:ShowCursor();
	
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
end

function Invite:Close()
	self.Window:Delete();
	self.Window = nil;
	
	self:HideCursor();
	
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
end

function FInvite( iID )
	Invite:Init( iID )
	Invite.List:Fill();
	Invite:Open();
end

function FInviteError( iCode, ... )
	Ajax:HideLoader();
	
	if Invite.m_pTimer then
		Invite.m_pTimer:Kill();
		Invite.m_pTimer = nil;
	end
	
	if Invite.Window then
		Invite.Window:SetEnabled( true );
	end
	
	if iCode == 0 then
		return MessageBox:Show( "Приглашение игроку " + ( { ... } )[ 1 ] + " упешно отправлно", "Сообщение", MessageBoxButtons.OK, MessageBoxIcon.Information );
	elseif iCode == 1 then
		return MessageBox:Show( "Превышено время ожидания ответа от сервера", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 2 then
		return MessageBox:Show( "Приглашение этому игроку уже было отправлено", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 3 then
		return MessageBox:Show( "Игрок уже состоит в этой фракции", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 4 then
		return MessageBox:Show( "Ошибка при поиске игрока", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
	else
		return MessageBox:Show( "Неизвестная ошибка, код " + tostring( iCode ), "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	end
end