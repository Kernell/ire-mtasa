-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local EditPlayer	= CGUI();

function EditPlayer:Init( iID, sName, sSurname )
	if self.Window then
		self:Close();
	end
	
	self.Window		= self:CreateWindow( "Редактирование " + sName + " " + sSurname )
	{
		X			= 'center';
		Y			= 'center';
		Width		= 230;
		Height		= 230;
	}
	
	self.Window:CreateLabel( "Ранг:" )
	{
		X			= 15;
		Y			= 30;
		Width		= 90;
		Height		= 130;
	}
	
	self.cbxRank			= self.Window:CreateComboBox( "" )
	{
		X			= 100;
		Y			= 30;
		Width		= 160;
		Height		= 150;
	}
	
	self.Window:CreateLabel( "Уровень прав:" )
	{
		X			= 15;
		Y			= 60;
		Width		= 90;
		Height		= 130;
	}
	
	self.radRights	= {};
	
	for key, value in ipairs( { "Member", "Leader", "Owner" } ) do
		self.radRights[ key ]	= self.Window:CreateRadioButton( value )
		{
			X			= 110;
			Y			= 80 + ( ( key - 1 ) * 25 );
			Width		= 90;
			Height		= 25;
		}
		
		self.radRights[ key ].Click	= function()
			self:SetRight( iID, sName, sSurname, value );
		end
	end
	
	self.btnClose			= self.Window:CreateButton( "Закрыть" )
	{
		X			= 145;
		Y			= 195;
		Width		= 75;
		Height		= 25;
	}
	
	self.btnUninvite		= self.Window:CreateButton( "Исключить" )
	{
		X			= 5;
		Y			= 195;
		Width		= 75;
		Height		= 25;
	}
	
	--
	
	self.cbxRank.Accept	= function()
		self:SetRank( iID, sName, sSurname, self.cbxRank:GetSelected() + 1 );
	end	
	
	self.btnClose.Click	= function()
		self:Close();
	end
	
	self.btnUninvite.Click	= function()
		local buttons	= MessageBox:Show( "Вы действительно хотите исключить игрока " + sName + " " + sSurname + " из фракции?", "Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Question );
		
		buttons[ 'Да' ][ 'Click' ] = function()
			self:Uninvite( iID, sName, sSurname );
		end
	end
end

function EditPlayer:Uninvite( iID, sName, sSurname )
	self.Window:SetEnabled( false );
	
	Ajax:ShowLoader( 2 );
	
	self.m_pTimer = CTimer(
		function()
			self:Error( 0 );
			
			self.Window:SetEnabled( true );
		end,
		10000, 1
	);
	
	CTimer(
		function()
			SERVER.FUninvite( iID, sName, sSurname );
		end,
		math.random( 500, 1000 ), 1
	);
end

function EditPlayer:SetRight( iID, sName, sSurname, sRight )
	self.Window:SetEnabled( false );
	
	Ajax:ShowLoader( 2 );
	
	self.m_pTimer = CTimer(
		function()
			self:Error( 0 );
			
			self.Window:SetEnabled( true );
		end,
		10000, 1
	);
	
	CTimer(
		function()
			SERVER.FSetPlayerRight( iID, sName, sSurname, sRight );
		end,
		math.random( 500, 1000 ), 1
	);
end

function EditPlayer:SetRank( iID, sName, sSurname, iRank )
	self.Window:SetEnabled( false );
	
	Ajax:ShowLoader( 2 );
	
	self.m_pTimer = CTimer(
		function()
			self:Error( 0 );
			
			self.Window:SetEnabled( true );
		end,
		10000, 1
	);
	
	CTimer(
		function()
			SERVER.FSetPlayerRank( iID, sName, sSurname, iRank );
		end,
		math.random( 500, 1000 ), 1
	);
end

function EditPlayer:Error( iCode, ... )
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
	
	if self.Window then
		self.Window:SetEnabled( true );
	end
	
	if iCode == 0 then
		return MessageBox:Show( "Превышено время ожидания ответа от сервера", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 1 then
		return MessageBox:Show( "Ошибка при работе с базой данных.\n\nОбратитесь к системному администратору", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 2 then
		return MessageBox:Show( "Игрок не состоит в этой фракции", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 3 then
		return MessageBox:Show( "Вы не можете редактировать владельца фракции", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 4 then
		return MessageBox:Show( "Ошибка при поиске персонажа", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
	else
		return MessageBox:Show( "Неизвестная ошибка, код " + tostring( iCode ), "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	end
end

function EditPlayer:Fill( aRanks )
	for key, value in ipairs( aRanks ) do
		self:AddItem( value );
	end
end

function EditPlayer:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();

	self:ShowCursor();
	
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
end

function EditPlayer:Close()
	self.Window:Delete();
	self.Window = nil;
	
	self:HideCursor();
	
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
end

function FactionEditPlayer( iID, sName, sSurname, iRank, sRight, aRanks, iLevel, pPlayer )
	if iID then
		EditPlayer.m_iLevel = iLevel;
		
		EditPlayer:Init( iID, sName, sSurname );
		EditPlayer.cbxRank:Fill( aRanks );
		EditPlayer.cbxRank:SetSelected( iRank - 1 );
		
		for i = 1, #EditPlayer.radRights do
			EditPlayer.radRights[ i ]:SetSelected( sRight == EditPlayer.radRights[ i ]:GetText() );
			EditPlayer.radRights[ i ]:SetEnabled( pPlayer == CLIENT or ( iLevel > 100 and sRight ~= 'Owner' ) or iLevel == 300 );
		end
		
		-- EditPlayer.radRights[ 1 ]:SetEnabled( ( iLevel > 000 and sRight ~= 'Owner' ) or iLevel == 300 );
		-- EditPlayer.radRights[ 2 ]:SetEnabled( ( iLevel > 100 and sRight ~= 'Owner' ) or iLevel == 300 );
		-- EditPlayer.radRights[ 3 ]:SetEnabled( ( iLevel > 100 and sRight ~= 'Owner' ) or iLevel == 300 );
		
		EditPlayer.cbxRank:SetEnabled		( pPlayer == CLIENT or ( iLevel > 000 and sRight ~= 'Owner' ) or iLevel == 300 );
		EditPlayer.btnUninvite:SetEnabled	( pPlayer == CLIENT or ( iLevel > 000 and sRight ~= 'Owner' ) or iLevel == 300 );
		
		EditPlayer:Open();
	elseif EditPlayer.Window then
		EditPlayer:Close();
	end
end

function FactionEditPlayerError( iCode, ... )
	return EditPlayer:Error( iCode, ... );
end