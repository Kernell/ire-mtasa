-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local EditRanks		= CGUI();

function EditRanks:Init()
	if self.Window then
		self:Close();
	end
	
	self.Ranks  = {};
	
	self.Window	= self:CreateWindow( "Редактирование рангов" )
	{
		X		= "center";
		Y		= "center";
		Width	= 300;
		Height	= 100;
		Sizable	= false;
	}
	
	self.btnAdd	= self.Window:CreateButton( "Добавить" )
	{
		X		= 5;
		Y		= 25;
		Width	= 290;
		Height	= 25;
	}
	
	self.btnSave = self.Window:CreateButton( "Сохранить" )
	{
		X		= 5;
		Y		= 70;
		Width	= 75;
		Height	= 25;
	}
	
	self.btnClose = self.Window:CreateButton( "Закрыть" )
	{
		X		= 220;
		Y		= 70;
		Width	= 75;
		Height	= 25;
	}
	
	self.btnAdd:SetEnabled( #self.Ranks <= FACTION_MAX_RANKS );
	
	self.btnAdd.Click	= function()
		self:AddItem( "Новый ранг " + ( #self.Ranks + 1 ) );
	end
	
	self.btnSave.Click	= function()
		self.Window:SetEnabled( false );
	
		Ajax:ShowLoader( 2 );
		
		self.m_pTimer = CTimer(
			function()
				self:Error( 2 );
				
				self.Window:SetEnabled( true );
			end,
			10000, 1
		);
		
		CTimer(
			function()
				self:Save();
			end,
			math.random( 500, 1000 ), 1
		);
		
	end
	
	self.btnClose.Click	= function()
		for i = 1, #self.Ranks do
			if #self.Ranks_bakup ~= #self.Ranks or self.Ranks[ i ]:GetText() ~= self.Ranks_bakup[ i ] then
				local buttons = MessageBox:Show( "Ранги были изменены. Сохранить?", "Редактирование рангов", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Question );
				
				buttons[ "Да" ][ "Click" ] = function()
					self:Save( true );
					self:Close();
				end
				
				buttons[ "Нет" ][ "Click" ] = function()
					self:Close();
				end
				
				return;
			end
		end
		
		self:Close();
	end
end

function EditRanks:Save( bExit )
	local aRanks = {};

	for key, value in ipairs( self.Ranks ) do
		table.insert( aRanks, value:GetText() );
	end

	SERVER.FactionSaveRanks( self.m_iID, aRanks, bExit );
end

function EditRanks:AddItem( sName )
	table.insert( self.Ranks,
		self.Window:CreateEdit( sName )
		{
			X		= 5;
			Y		= 25 + ( ( #self.Ranks + 1 ) * 26 );
			Width	= 290;
			Height	= 25;
		}
	);
	
	self.Window:SetSize( 300, 100 + ( #self.Ranks * 26 ), false );
	self.btnSave:SetPosition( 5, 70 + ( #self.Ranks * 26 ), false );
	self.btnClose:SetPosition( 220, 70 + ( #self.Ranks * 26 ), false );
	self.btnAdd:SetEnabled( #self.Ranks < FACTION_MAX_RANKS );
end

function EditRanks:FillList( aRanks )
	self.Ranks_bakup = table.clone( aRanks );
	
	for key, rank in ipairs( aRanks ) do
		self:AddItem( rank );
	end
end

function EditRanks:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();

	self:ShowCursor();
	
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
end

function EditRanks:Close()
	self.Window:Delete();
	self.Window = nil;
	
	self:HideCursor();
	
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
end

function FactionEditRanks( iID, aRanks )
	EditRanks:Init();
	
	if iID then
		EditRanks.m_iID = iID;
		EditRanks:FillList( aRanks );
		EditRanks:Open();
	end
end

function EditRanksError( iCode, ... )
	Ajax:HideLoader();
	
	if EditRanks.m_pTimer then
		EditRanks.m_pTimer:Kill();
		EditRanks.m_pTimer = nil;
	end
	
	if EditRanks.Window then
		EditRanks.Window:SetEnabled( true );
	end
	
	if iCode == 1 then
		return MessageBox:Show( "Ошибка при работе с базой данных.\n\nОбратитесь к системному администратору", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 2 then
		return MessageBox:Show( "Превышено время ожидания ответа от сервера", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 3 then
		return MessageBox:Show( "Недостаточно прав", "Denied", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 4 then
		return MessageBox:Show( "Ранг " + tonumber( ( { ... } )[ 1 ] ) + " содержит некорректные символы", "Denied", MessageBoxButtons.OK, MessageBoxIcon.Error );
	else
		return MessageBox:Show( "Неизвестная ошибка, код " + tostring( iCode ), "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	end
end