-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local types			= 
{
	[ 'Название' ]			= 'Edit';
	[ 'Аббревиатура' ]		= 'Edit';
	[ 'Тип' ]				= 'ComboBox';
};

local levels		= 
{
	[ 'Название' ]			= 300;
	[ 'Аббревиатура' ] 		= 300;
	[ 'Тип' ]				= 300;
};

local ComboBox		=
{
	[ "Тип" ]		=
	{
		"Государственная организация";
		"Limited liability company (LLC)";
		"Corporation";
		"Sole proprietorship";
	};
};

local Faction		= CGUI();

function Faction:Init( iID, sName, iLevel )
	if self.Window then
		self:Close();
	end
	
	self.m_iID		= iID;
	self.m_iLevel	= iLevel;
	
	self.Window		= self:CreateWindow( sName )
	{
		X			= "center";
		Y			= "center";
		Width		= 600;
		Height		= 380;
		Sizable		= false;
	}
	
	self:AddControl( 'Название', NULL, NULL, 200 );
	self:AddControl( 'Аббревиатура', NULL, 25 );
	self:AddControl( 'Тип', NULL, 50, 100, 100 );
	
	self.btnEditRanks		= self.Window:CreateButton( "Список должностей" )
	{
		X		= 475;
		Y		= 35;
		Width	= 125;
		Height	= 25;
	}
	
	self.btnInvite			= self.Window:CreateButton( "Пригласить игрока" )
	{
		X		= 475;
		Y		= 65;
		Width	= 125;
		Height	= 25;
	}
	
	self.btnLeave			= self.Window:CreateButton( "Уволиться" )
	{
		X		= 475;
		Y		= 95;
		Width	= 125;
		Height	= 25;
	}
	
	self.List				= self.Window:CreateGridList{ 0, 125, 600, 200 }
	{
		{ "Имя", 		.12 };
		{ "Фамилия",	.12 };
		{ "Должность", 	.3	};
		{ "Телефон", 	.15 };
		{ "Статус", 	.2	};
	}
	
	self.btnShowInvites		= self.Window:CreateButton( "Приглашения" )
	{
		X			= 5;
		Y			= 340;
		Width		= 100;
		Height		= 25;
	}
	
	self.btnClose	= self.Window:CreateButton( "Закрыть" )
	{
		X			= 520;
		Y			= 340;
		Width		= 75;
		Height		= 25;
	}
	
	self.btnEditRanks:SetEnabled( self.m_iLevel > 100 );
	self.btnInvite:SetEnabled( self.m_iLevel > 0 );
	self.btnLeave:SetEnabled( false );
	
	self.btnClose.Click	= function()
		self:Close();
	end
	
	self.btnEditRanks.Click 	= function()
		SERVER.FactionEditRanks( self.m_iID );
	end
	
	self.btnInvite.Click 		= function()
		SERVER.FactionInvite( self.m_iID );
	end
	
	self.btnLeave.Click 		= function()
		local buttons	= MessageBox:Show( "Вы действительно хотите уволиться из организации?", "Внимание", MessageBoxButtons.YesNo, MessageBoxIcon.Question );
		
		buttons[ "Да" ][ 'Click' ] = function()
			SERVER.FactionLeave()
		end
	end
	
	self.btnShowInvites.Click	= function()
		SERVER.FactionShowInvites();
	end
	
	if self.m_iLevel >= 100 then
		self.List.DoubleClick	= function()
			local iItem = self.List:GetSelectedItem();
			
			if iItem and iItem ~= -1 then
				local sName		= self.List:GetItemText( iItem, self.List[ 'Имя' ] );
				local sSurname	= self.List:GetItemText( iItem, self.List[ 'Фамилия' ] );
				
				if sName and sSurname then
					SERVER.FactionEditPlayer( self.m_iID, sName, sSurname );
				end
			end
		end
	end
end

function Faction:SetData( sName, sValue )
	if not self.Window:GetEnabled() then
		return;
	end
	
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
			SERVER.SetFactionData( self.m_iID, sName, sValue );
		end,
		math.random( 500, 1000 ), 1
	);
end

function Faction:Error( iCode, ... )
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
	
	self.Window:SetEnabled( true );
	
	if iCode == 1 then
		return MessageBox:Show( "Ошибка при работе с базой данных.\n\nОбратитесь к системному администратору", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 2 then
		return MessageBox:Show( "Превышено время ожидания ответа от сервера", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 3 then
		return MessageBox:Show( "Название содержит запрещённые символы!\nИспользуйте только символы латинского алфавита", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 4 then
		return MessageBox:Show( "Максимальная длина названия может быть не более 64 символов", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 5 then
		return MessageBox:Show( "Аббревиатура содержит запрещённые символы!\nИспользуйте только символы латинского алфавита", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	elseif iCode == 6 then
		return MessageBox:Show( "Максимальная длина аббревиатуры может быть не более 8 символов", "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	else
		return MessageBox:Show( "Неизвестная ошибка, код " + tostring( iCode ), "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Error );
	end
end

function Faction:AddControl( sName, fOfssetX, fOffsetY, fSizeX, fSizeY )
	local type	= types[ sName ];
	
	if type then
		if not self[ type ] then
			self[ type ]	= {};
		end
		
		if not self.Label then
			self.Label		= {};
		end
		
		if not self.Button then
			self.Button		= {};
		end
		
		self.Window:CreateLabel( sName + ':' )
		{
			X			= 25 + ( fOfssetX or 0 );
			Y			= 40 + ( fOffsetY or 0 );
			Width		= 75 + ( fSizeX or 0 );
			Height		= 25 + ( fSizeY or 0 );
			Font		= "default-bold-small";
		}
		
		local pLabel	= self.Window:CreateLabel( 'NULL' )
		{
			X			= 131 + ( fOfssetX or 0 );
			Y			= 40 + ( fOffsetY or 0 );
			Width		= 80 + ( fSizeX or 0 );
			Height		= 25;
		}
		
		local pObject	= self.Window[ 'Create' + type ]( self.Window, sName )
		{
			X			= 131 + ( fOfssetX or 0 );
			Y			= 40 + ( fOffsetY or 0 );
			Width		= 100 + ( fSizeX or 0 );
			Height		= 21 + ( fSizeY or 0 );
		}
		
		local pButton 	= self.Window:CreateButton( ".." )
		{
			X			= 100 + ( fOfssetX or 0 );
			Y			= 40 + ( fOffsetY or 0 );
			Width		= 21;
			Height		= 21;
		}
		
		if ComboBox[ sName ] then
			for _, v in ipairs( ComboBox[ sName ] ) do
				pObject:AddItem( v );
			end
		end
		
		pObject:SetVisible( false );
		pButton:SetVisible( levels[ sName ] <= self.m_iLevel );
		
		pButton.Click = function()
			if levels[ sName ] <= self.m_iLevel then
				pObject:SetVisible	( not pObject:GetVisible() );
				pLabel:SetVisible	( not pObject:GetVisible() );
				
				if pObject:GetVisible() then
					if type == 'ComboBox' then
						if ComboBox[ sName ] then
							for i, v in ipairs( ComboBox[ sName ] ) do
								if v == pLabel:GetText() then
									pObject:SetSelected( i - 1 );
									
									break;
								end
							end
						end
					elseif type == 'Edit' then
						pObject:SetText( pLabel:GetText() );
					end
				else
					self:SetData( sName, type == 'ComboBox' and pObject:GetSelected() or pObject:GetText() );
				end
			end
		end
		
		self[ type ][ sName ]	= pObject;
		self.Label[ sName ]		= pLabel;
		self.Button[ sName ]	= pButton;
	end
end

function Faction:FillList( aMembers )
	self.List:Clear();
	
	if not aMembers then return end
	
	for key, value in ipairs( aMembers ) do
		if value.name:gsub( ' ', '_' ) == CLIENT:GetName() and value.right_name ~= 'Owner' then
			self.btnLeave:SetEnabled( true );
		end
		
		self.List:AddItem( value );
	end
end

function Faction:AddItem( aItem )
	if not aItem then return end
	
	local Row = self:AddRow();
	
	if not Row then return end
	
	-- self.List.m_aMembers
	
	self:SetItemText( Row,	self[ 'Имя' ],			aItem.name,				false, false );
	self:SetItemText( Row,	self[ 'Фамилия' ],		aItem.surname,			false, false );
	self:SetItemText( Row,	self[ 'Должность' ],	aItem.rank_name,		false, false );
	self:SetItemText( Row,	self[ 'Телефон' ],		aItem.phone,			false, false );
	self:SetItemText( Row,	self[ 'Статус' ],		aItem.online_status == -1 and 'Online' or aItem.online_status == 0 and 'Сегодня' or ( aItem.online_status + math.decl( aItem.online_status, ' день', ' дня', ' дней' ) + " назад"),	false, false );
	
	if aItem.online_status == -1 then
		self:SetItemColor( Row, self[ "Статус" ],		0, 255, 0, 255 );
	end
	
	if aItem.status ~= 'Активен' then
		self:SetItemColor( Row, self[ "Имя" ],			127, 127, 127, 255 );
		self:SetItemColor( Row, self[ "Фамилия" ],		127, 127, 127, 255 );
		self:SetItemColor( Row, self[ "Должность" ],	127, 127, 127, 255 );
		self:SetItemColor( Row, self[ "Телефон" ],		127, 127, 127, 255 );
		self:SetItemColor( Row, self[ "Статус" ],		200, 0, 0, 255 );
		
		self:SetItemText( Row,	self[ 'Статус' ], 	aItem.status,			false, false );
	end
end

function Faction:Open()
	self.Window:SetVisible( true );
	self.Window:BringToFront();

	self:ShowCursor();
	
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
end

function Faction:Close()
	self.Window:Delete();
	self.Window = nil;
	
	self:HideCursor();
	
	Ajax:HideLoader();
	
	if self.m_pTimer then
		self.m_pTimer:Kill();
		self.m_pTimer = nil;
	end
end

function FactionMain( iID, sName, sTag, sType, aMembers, iLevel, bForce )
	if not iID or ( Faction.Window and not bForce ) then
		Faction:Close();
	else
		Faction:Init( iID, sName or 'N/A', iLevel or 0 );
		Faction.Label[ 'Название' ]:SetText( sName or 'N/A' );
		Faction.Label[ 'Аббревиатура' ]:SetText( sTag or 'N/A' );
		Faction.Label[ 'Тип' ]:SetText( ComboBox[ "Тип" ][ (int)(sType) + 1 ] or 'N/A' );
		Faction:FillList( aMembers );
		Faction:Open();
	end
end

function FactionError( iCode, ... )
	return Faction:Error( iCode, ... );
end