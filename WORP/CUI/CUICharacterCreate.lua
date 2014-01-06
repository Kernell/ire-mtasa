-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local gl_Skins =
{
	{ [ 0 ] = 1, 2, 7, 28, 30, 47, 48, 50, 60, 61, 62, 68, 170, 180, 250, 255, 268, 291, 305, 306, 307, 308, 309, 312 };
	{ [ 0 ] = 12, 13, 41, 56, 90 };
};

local gl_Names =
{
	{
		"Michael", "Caitlin", "Jacob", "Joshua", "Matthew", "Matthew", "Nicholas", "David", "Daniel", "Andrew",
		"Brandon", "Joseph", "Austin", "Justin", "Taylor", "James", "Zachary", "Madison"
	};
	{
		"Abbie", "Adele", "Alexis", "Amanda", "Anastasia", "Ashley", "Brianna", "Brittney", "Elisabetta",
		"Emily", "Grace", "Hannah", "Jenifer", "Jennifer", "Jessica", "Katie", "Katrine", "Kristina", "Lauren",
		"Megan", "Mia", "Molly", "Olivia", "Ria", "Samantha", "Sarah", "Sofia", "Stephanie",
	};
};

local gl_Surnames =
{
	"Adams", "Alexander", "Allen", "Anderson", "Bailey", "Baker", "Barnes", "Bell", "Bennett", "Brooks", "Brown",
	"Bryant", "Butler", "Campbell", "Carter", "Clark", "Coleman", "Collins", "Cook", "Cooper", "Cox", "Davis",
	"Diaz", "Edwards", "Evans", "Flores", "Foster", "Garcia", "Gonzales", "Gonzalez", "Gray", "Green", "Griffin",
	"Hall", "Harris", "Hayes", "Henderson", "Hernandez", "Hill", "Howard", "Hughes", "Jackson", "James", "Jenkins",
	"Johnson", "Jones", "Kelly", "King", "Lee", "Lewis", "Long", "Lopez", "Martin", "Martinez", "Miller", "Mitchell",
	"Moore", "Morgan", "Morris", "Murphy", "Nelson", "Parker", "Patterson", "Perez", "Perry", "Peterson", "Phillips",
	"Powell", "Price", "Ramirez", "Reed", "Richardson", "Rivera", "Roberts", "Robinson", "Rodriguez", "Rogers", "Ross",
	"Russell", "Sanchez", "Sanders", "Scott", "Simmons", "Smith", "Stewart", "Taylor", "Thomas", "Thompson", "Torres",
	"Turner", "Walker", "Ward", "Washington", "Watson", "White", "Williams", "Wilson", "Wood", "Wright", "Young",
};

class: CUICharacterCreate ( CGUI, CUIAsyncQuery )
{
	Width		= 400;
	Height		= 520;
	
	LabelFont	= CEGUIFont( "Segoe UI", 10, true );
	
	CUICharacterCreate	= function( this, bDisableExit )
		this.Window	= this:CreateWindow( "Создание персонажа" )
		{
			X		= 50;
			Y		= "center";
			Width	= this.Width;
			Height	= this.Height;
			Sizable	= false;
		};
		
		this.LabelSex = this.Window:CreateLabel( "Выберите пол" )
		{
			X		= 15;
			Y		= 25;
			Width	= this.Window.Width - 30;
			Height	= 18;
			Font	= this.LabelFont;
		};
		
		this.GroupSex = this.Window:CreateGridList{ 10, this.LabelSex.Y + this.LabelSex.Height + 5, this.Window.Width - 20, 50 }()
		
		this.GroupSex.ButtonMale	= this.GroupSex:CreateButton( "Мужской" )
		{
			X		= 90;
			Y		= 10;
			
			Click	= function()
				this.GroupSex.ButtonMale:SetEnabled( false );
				this.GroupSex.ButtonFemale:SetEnabled( true );
				
				this.GroupName:SetEnabled( true );
				this.GroupSkin:SetEnabled( true );
				this.GroupBPL:SetEnabled( true );
				-- this.GroupDPL:SetEnabled( true );
				
				this.GroupSex.Value = 1;
				
				this.GroupSkin.Value = 0;
				
				this.GroupSkin.InputID:SetValue( this.GroupSex.Value, this.GroupSkin.Value );
			end;
		};
		
		this.GroupSex.ButtonFemale	= this.GroupSex:CreateButton( "Женский" )
		{
			X		= this.GroupSex.ButtonMale.X + this.GroupSex.ButtonMale.Width + 30;
			Y		= this.GroupSex.ButtonMale.Y;
			
			Click	= function()
				this.GroupSex.ButtonMale:SetEnabled( true );
				this.GroupSex.ButtonFemale:SetEnabled( false );
				
				this.GroupName:SetEnabled( true );
				this.GroupSkin:SetEnabled( true );
				this.GroupBPL:SetEnabled( true );
				-- this.GroupDPL:SetEnabled( true );
				
				this.GroupSex.Value = 2;
				
				this.GroupSkin.Value = 0;
				
				this.GroupSkin.InputID:SetValue( this.GroupSex.Value, this.GroupSkin.Value );
			end;
		};
		
		this.LabelName = this.Window:CreateLabel( "Придумайте имя" )
		{
			X		= 15;
			Y		= this.GroupSex.Y + this.GroupSex.Height + 10;
			Width	= this.Window.Width - 30;
			Height	= 18;
			Font	= this.LabelFont;
		};
		
		this.GroupName = this.Window:CreateGridList{ 10, this.LabelName.Y + this.LabelName.Height + 5, this.Window.Width - 20, 85 }()
		
		this.GroupName:SetEnabled( false );
		
		this.GroupName.InputName	= this.GroupName:CreateEdit( "" )
		{
			X			= 15;
			Y			= 10;
			Width		= ( this.GroupName.Width / 2 ) - 20;
			Height		= 25;
			MaxLength	= 10;
			PlaceHolder	= "Введите имя";
			
			GetValue	= function()
				local sText	= this.GroupName.InputName:GetText();
				
				if sText and sText ~= this.GroupName.InputName.PlaceHolder then
					return sText;
				end
				
				return "";
			end;
		};
		
		this.GroupName.InputSurname	= this.GroupName:CreateEdit( "" )
		{
			X			= this.GroupName.InputName.X + this.GroupName.InputName.Width + 10;
			Y			= this.GroupName.InputName.Y;
			Width		= this.GroupName.InputName.Width;
			Height		= this.GroupName.InputName.Height;
			MaxLength	= 10;
			PlaceHolder	= "Введите фамилию";
			
			GetValue	= function()
				local sText	= this.GroupName.InputSurname:GetText();
				
				if sText and sText ~= this.GroupName.InputSurname.PlaceHolder then
					return sText;
				end
				
				return "";
			end;
		};
		
		this.GroupName.ButtonRandom	= this.GroupName:CreateButton( "Случайное имя" )
		{
			X		= ( this.GroupName.Width - 110 ) / 2;
			Y		= this.GroupName.InputName.Y + this.GroupName.InputName.Height + 10;
			Width	= 110;
			
			Click	= function()
				local iSex	= this.GroupSex.Value;
				
				if iSex then
					local sName		= gl_Names[ iSex ][ math.random( table.getn( gl_Names[ iSex ] ) ) ];
					local sSurname	= gl_Surnames[ math.random( table.getn( gl_Surnames ) ) ];
					
					this.GroupName.InputName:SetText( sName );
					this.GroupName.InputSurname:SetText( sSurname );
					
					this.GroupName.InputName:SetProperty( "NormalTextColour", "FF000000" );
					this.GroupName.InputSurname:SetProperty( "NormalTextColour", "FF000000" );
				end
			end;
		};
		
		this.LabelSkin = this.Window:CreateLabel( "Выберите скин" )
		{
			X		= 15;
			Y		= this.GroupName.Y + this.GroupName.Height + 10;
			Width	= this.Window.Width - 30;
			Height	= 18;
			Font	= this.LabelFont;
		};
		
		this.GroupSkin = this.Window:CreateGridList{ 10, this.LabelSkin.Y + this.LabelSkin.Height + 5, this.Window.Width - 20, 50 }()
		
		this.GroupSkin:SetEnabled( false );
		
		this.GroupSkin.ButtonPrev	= this.GroupSkin:CreateButton( "<<" )
		{
			X		= 60;
			Y		= 10;
			
			Click	= function()
				local iSex	= this.GroupSex.Value;
				
				if iSex then
					this.GroupSkin.Value = ( ( this.GroupSkin.Value or 0 ) - 1 ) % sizeof( gl_Skins[ iSex ] );
					
					this.GroupSkin.InputID:SetValue( iSex, this.GroupSkin.Value );
				end
			end;
		};
		
		this.GroupSkin.InputID	= this.GroupSkin:CreateEdit( "" )
		{
			X		= this.GroupSkin.ButtonPrev.X + this.GroupSkin.ButtonPrev.Width + 10;
			Y		= this.GroupSkin.ButtonPrev.Y;
			Width	= this.GroupSkin.ButtonPrev.Width;
			Height	= this.GroupSkin.ButtonPrev.Height - 1;
			ReadOnly= true;
			
			SetValue	= function( self, iSex, iValue )
				local iSkin = gl_Skins[ iSex ][ iValue ];
				
				self:SetText( iSkin );
				this.m_pPed:SetSkin( iSkin );
				
				local pSkin		= CPed.GetSkin( iSkin );
				
				local iStyle	= (int)(pSkin.GetWalkingStyle());
				
				this.m_pPed:SetWalkingStyle( iStyle );
			end;
		};
		
		this.GroupSkin.ButtonNext	= this.GroupSkin:CreateButton( ">>" )
		{
			X		= this.GroupSkin.InputID.X + this.GroupSkin.InputID.Width + 10;
			Y		= this.GroupSkin.InputID.Y;
			
			Click	= function()
				local iSex	= this.GroupSex.Value;
				
				if iSex then
					this.GroupSkin.Value = ( ( this.GroupSkin.Value or 0 ) + 1 ) % sizeof( gl_Skins[ iSex ] );
					
					this.GroupSkin.InputID:SetValue( iSex, this.GroupSkin.Value );
				end
			end;
		};
		
		this.LabelBPL = this.Window:CreateLabel( "Введите место рождения" )
		{
			X		= 15;
			Y		= this.GroupSkin.Y + this.GroupSkin.Height + 10;
			Width	= this.Window.Width - 30;
			Height	= 18;
			Font	= this.LabelFont;
		};
		
		this.GroupBPL = this.Window:CreateGridList{ 10, this.LabelBPL.Y + this.LabelBPL.Height + 5, this.Window.Width - 20, 50 }()
		
		this.GroupBPL:SetEnabled( false );
		
		this.GroupBPL.InputCountry	= this.GroupBPL:CreateEdit( "" )
		{
			X				= 15;
			Y				= 10;
			Width			= ( this.GroupBPL.Width / 2 ) - 20;
			Height			= 25;
			PlaceHolder		= "Введите страну для поиска";
			AutoComplete	=
			{
				Callback	= "SearchCountry";
				
				OnSelect	 = function( pItem )
					if pItem then
						this.GroupBPL.InputCountry.Value = tonumber( pItem.id );
						
						if this.GroupBPL.InputCountry.Value then
							this.GroupBPL.InputCountry:SetText( pItem.name );
						end
					else
						this.GroupBPL.InputCountry.Value = NULL;
						
						this.GroupBPL.InputCountry:SetText( "" );
					end
					
					this.GroupBPL.InputCity.Value = NULL;
				end;
				
				ParseItem	= function( pRow )
					return pRow.name;
				end;
			};
		};
		
		this.GroupBPL.InputCity	= this.GroupBPL:CreateEdit( "" )
		{
			X				= this.GroupBPL.InputCountry.X + this.GroupBPL.InputCountry.Width + 10;
			Y				= this.GroupBPL.InputCountry.Y;
			Width			= this.GroupBPL.InputCountry.Width;
			Height			= this.GroupBPL.InputCountry.Height;
			PlaceHolder		= "Введите город для поиска";
			
			AutoComplete	=
			{
				Callback	= "SearchCity";
				
				GetQuery	= function( sQuery )
					return sQuery, this.GroupBPL.InputCountry.Value;
				end;
				
				OnSelect	= function( pItem )
					if pItem then
						this.GroupBPL.InputCity.Value = tonumber( pItem.id );
						
						if this.GroupBPL.InputCity.Value then
							this.GroupBPL.InputCity:SetText( pItem.name );
						end
					else
						this.GroupBPL.InputCity.Value = NULL;
						
						this.GroupBPL.InputCity:SetText( "" );
					end
				end;
				
				ParseItem	= function( pRow )
					return pRow.name + " (" + pRow.region + ")";
				end;
			};
		};
		
		this.LabelDPL = this.Window:CreateLabel( "Введите дату рождения" )
		{
			X		= 15;
			Y		= this.GroupBPL.Y + this.GroupBPL.Height + 10;
			Width	= this.Window.Width - 30;
			Height	= 18;
			Font	= this.LabelFont;
		};
		
		this.GroupDPL = this.Window:CreateGridList{ 10, this.LabelDPL.Y + this.LabelDPL.Height + 5, this.Window.Width - 20, 50 }()
		
		this.GroupDPL:SetEnabled( false );
		
		this.GroupDPL.InputDay		= this.Window:CreateComboBox( "День" )
		{
			X			= this.GroupDPL.X + 15;
			Y			= this.GroupDPL.Y + 10;
			Width		= ( this.GroupDPL.Width * 0.2 ) - 15;
			Height		= 100;
			
			GetValue	= function()
				local iRow = this.GroupDPL.InputDay:GetSelected();
				
				if not iRow or iRow == -1 then
					return 0;
				end
				
				return iRow + 1;
			end;
		};
		
		this.GroupDPL.InputMonth	= this.Window:CreateComboBox( "Месяц" )
		{
			X			= this.GroupDPL.X + this.GroupDPL.InputDay.X + this.GroupDPL.InputDay.Width;
			Y			= this.GroupDPL.Y + 10;
			Width		= ( this.GroupDPL.Width * 0.4 ) - 15;
			Height		= 100;
			
			GetValue	= function()
				local iRow = this.GroupDPL.InputMonth:GetSelected();
				
				if not iRow or iRow == -1 then
					return 0;
				end
				
				return iRow + 1;
			end;
			
			Accept		= function()
				local iDay		= this.GroupDPL.InputDay.GetValue();
				local iMonth	= this.GroupDPL.InputMonth.GetValue();
				local iYear		= this.GroupDPL.InputYear.GetValue();
				
				this.GroupDPL.InputDay:Clear();
				
				local iMaxDays	= days_in_month( iYear, iMonth );
				
				for i = 1, iMaxDays do	
					this.GroupDPL.InputDay:AddItem( (string)(i) ); 
				end
				
				if iDay > iMaxDays then
					this.GroupDPL.InputDay:SetSelected( iMaxDays - 1 );
				else
					this.GroupDPL.InputDay:SetSelected( iDay - 1 );
				end
			end
		};
		
		this.GroupDPL.InputYear		= this.Window:CreateComboBox( "Год" )
		{
			X			= this.GroupDPL.X + this.GroupDPL.InputMonth.X + this.GroupDPL.InputMonth.Width;
			Y			= this.GroupDPL.Y + 10;
			Width		= ( this.GroupDPL.Width * 0.4 ) - 20;
			Height		= 100;
			
			GetValue	= function()
				local iRow = this.GroupDPL.InputYear:GetSelected();
				
				if not iRow or iRow == -1 then
					return 0;
				end
				
				return iRow + 1;
			end;
			
			Accept		= this.GroupDPL.InputMonth.Accept;
		};
			
		for iDay	= 1, 31 		do	this.GroupDPL.InputDay:AddItem( (string)(iDay) );	end
		for iMonth	= 1, 12 		do	this.GroupDPL.InputMonth:AddItem( mon_full_names_ru[ iMonth ] );	end
		for iYear	= 1971, 1995	do 	this.GroupDPL.InputYear:AddItem( (string)(iYear) );	end
		
		this.ButtonOK		= this.Window:CreateButton( "Создать" )
		{
			X		= ( this.Window.Width - 80 ) * 0.75;
			Y		= this.Window.Height - 40;
			
			Click	= function()
				local function Complete()
					-- this:SetVisible( false );
					-- this:ShowDialog( CUICharacterCreate2() );
					
					delete ( this );
				end
				
				local iYear			= this.GroupDPL.InputYear.GetValue();
				local iMonth		= this.GroupDPL.InputMonth.GetValue();
				local iDay			= this.GroupDPL.InputDay.GetValue();
				
				local sName			= this.GroupName.InputName.GetValue();
				local sSurname		= this.GroupName.InputSurname.GetValue();
				local iSkin			= this.GroupSkin.InputID:GetText();
				local iCityID		= this.GroupBPL.InputCity.Value;
				
				this:AsyncQuery( Complete, "Character__Create", sName, sSurname, iSkin, iYear, iMonth, iDay, iCityID );
			end;
		};
		
		if not bDisableExit then
			this.ButtonCancel	= this.Window:CreateButton( "Отмена" )
			{
				X		= ( this.Window.Width - 80 ) * 0.25;
				Y		= this.ButtonOK.Y;
				
				Click	= function()
					SERVER.LoadCharacters();
					
					delete ( this );
				end;
			};
		end
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		this:ShowCursor();
		
		this.m_pPed = CPed.Create( 0, Vector3( 1711.233, -1671.350, 42.469 ), 312.0 );
		
		this.m_pPed:SetDimension( CLIENT:GetDimension() );
		this.m_pPed:SetInterior( CLIENT:GetInterior() );
		this.m_pPed:SetFrozen( true );
	end;
	
	_CUICharacterCreate	= function( this )
		this:_CUIAsyncQuery();
		
		Ajax:HideLoader();
		
		this:HideCursor();
		
		this.Window:Delete();
		this.Window = NULL;
		
		delete ( this.m_pPed );
		
		this.m_pPed = NULL;
	end;
};