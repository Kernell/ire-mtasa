-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. CharacterCreate : UIDialog
{
	static
	{
		NEW_CHAR_POSITION			= new. Vector3( 1711.233, -1671.350, 42.469 );
		NEW_CHAR_ANGLE				= 300.0;
		NEW_CHAR_CAMERA_POSITION	= new. Vector3( 1714.2, -1670.7, 42.9 );
		NEW_CHAR_CAMERA_TARGET		= new. Vector3( 1628.2, -1719.5, 28.4 );
		
		Skins =
		{
			{ [ 0 ] = 1, 2, 7, 28, 30, 47, 48, 50, 60, 61, 62, 68, 170, 180, 250, 255, 268, 291, 305, 306, 307, 308, 309, 312 };
			{ [ 0 ] = 12, 13, 41, 56, 90 };
		};

		Names =
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

		Surnames =
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
	};
	
	CharacterCreate		= function( ... )
		this.Ped = new. Ped( 0, CharacterCreate.NEW_CHAR_POSITION, CharacterCreate.NEW_CHAR_ANGLE );
		
		this.Ped.SetDimension( CLIENT.GetDimension() );
		this.Ped.SetInterior( CLIENT.GetInterior() );
		this.Ped.SetFrozen( true );
		
		Camera.MoveTo( CharacterCreate.NEW_CHAR_CAMERA_POSITION, 500, "OutQuad" );
		Camera.RotateTo( CharacterCreate.NEW_CHAR_CAMERA_TARGET, 500, "OutQuad" );
		
		this.UIDialog( ... );
	end;
	
	_CharacterCreate	= function()
		this._UIDialog();
		
		delete ( this.Ped );
		
		this.Ped = NULL;
	end;
	
	OnShow				= function()
		this.UpdateDaysInMonth();
	end;
	
	UpdateDaysInMonth	= function()
		local year 	= this.year.GetValue() or 1980;
		local month = this.month.GetValue() or 1;
		local day 	= this.day.GetValue();
		
		if month then
			local days = days_in_month( (int)(year), (int)(month) );
			
			this.day.Clear();
			
			this.day.Items = {};
			
			for i = 1, days do
				this.day.AddItem( (string)(i) );
				
				this.day.Items[ (string)(i) ] = i;
			end
			
			if day then
				this.day.SetValue( (string)(Clamp( 1, day, days )) );
			end
		end
	end;
	
	OnClickMale		= function()
		this.buttonMale.SetEnabled( false );
		this.buttonFemale.SetEnabled( true );
		
		this.groupName.SetEnabled( true );
		this.groupSkin.SetEnabled( true );
		
		this.sex.value = 1;
		
		this.skin.value = 0;
		
		this.UpdateSkin();
	end;
	
	OnClickFemale	= function()
		this.buttonMale.SetEnabled( true );
		this.buttonFemale.SetEnabled( false );
		
		this.groupName.SetEnabled( true );
		this.groupSkin.SetEnabled( true );
		
		this.sex.value = 2;
		
		this.skin.value = 0;
		
		this.UpdateSkin();
	end;
	
	OnClickSkinPrev	= function()
		local sex	= this.sex.value;
		
		if sex then
			this.skin.value = ( ( this.skin.value or 0 ) - 1 ) % sizeof( CharacterCreate.Skins[ sex ] );
			
			this.UpdateSkin();
		end
	end;
	
	OnClickSkinNext	= function()
		local sex	= this.sex.value;
		
		if sex then
			this.skin.value = ( ( this.skin.value or 0 ) + 1 ) % sizeof( CharacterCreate.Skins[ sex ] );
			
			this.UpdateSkin();
		end
	end;
	
	OnClickRandomName	= function()
		local sex	= this.sex.value;
		
		if sex then
			local name		= CharacterCreate.Names[ sex ][ math.random( table.getn( CharacterCreate.Names[ sex ] ) ) ];
			
			this.name.SetText( name );
			
			this.name.SetProperty( "NormalTextColour", "FF000000" );
		end
	end;
	
	OnClickRandomSurname	= function()
		local sex	= this.sex.value;
		
		if sex then
			local surname	= CharacterCreate.Surnames[ math.random( table.getn( CharacterCreate.Surnames ) ) ];
			
			this.surname.SetText( surname );
			
			this.surname.SetProperty( "NormalTextColour", "FF000000" );
		end
	end;
	
	UpdateSkin		= function()
		local skinID = CharacterCreate.Skins[ this.sex.value ][ this.skin.value ];
		
		if skinID then
			this.skin.SetText( skinID );
			
			this.Ped.SetModel( skinID );
			
			local skin	= new. CharacterSkin( skinID );
			
			this.Ped.SetWalkingStyle( (int)(skin.GetWalkingStyle()) );
		end
	end;
	
	SearchCity		= function( stringQuery )
		local countryID	= tonumber( this.country.value );
		
		if countryID then
			local result = SERVER.PlayerManager( "SearchCity", stringQuery, countryID );
			
			return result;
		end
		
		return NULL;
	end;
};