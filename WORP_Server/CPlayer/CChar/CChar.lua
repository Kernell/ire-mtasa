-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local default_weapon_skills 		=
{
	WEAPON_PISTOL_SKILL 			= 500;
	WEAPON_PISTOL_SILENCED_SKILL	= 500;
	WEAPON_DESERT_EAGLE_SKILL 		= 500;
	WEAPON_SHOTGUN_SKILL 			= 500;
	WEAPON_SAWNOFF_SHOTGUN_SKILL	= 500;
	WEAPON_SPAS12_SHOTGUN_SKILL		= 500;
	WEAPON_MICRO_UZI_SKILL			= 500;
	WEAPON_MP5_SKILL				= 500;
	WEAPON_AK47_SKILL 				= 500;
	WEAPON_M4_SKILL 				= 500;
	WEAPON_SNIPERRIFLE_SKILL 		= 500;
};

local gl_Names =
{
	"Michael", "Jessica", "Michael", "Caitlin", "Christopher", "Ashley", "Jacob", "Emily", "Joshua", "Britteni", "Matthew", "Sarah",
	"Matthew", "Amanda", "Nicholas", "Hannah", "David", "Stephanie", "Joshua", "Ashley", "Daniel", "Jennifer", "Christopher", "Brianna",
	"Andrew", "Samantha", "Brandon", "Alexis", "Joseph", "Sara", "Austin", "Samantha", "Justin", "Megan", "Tyler", "Taylor", "James", "Lauren", "Zachary", "Madison"
};

local gl_Surnames =
{
	"Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor", "Anderson", "Thomas", "Jackson", "White", "Harris", 
	"Martin", "Thompson", "Garcia", "Martinez", "Robinson", "Clark", "Rodriguez", "Lewis", "Lee", "Walker", "Hall", "Allen", "Young", "Hernandez", "King", 
	"Wright", "Lopez", "Hill", "Scott", "Green", "Adams", "Baker", "Gonzalez", "Nelson", "Carter", "Mitchell", "Perez", "Roberts", "Turner", "Phillips", 
	"Campbell", "Parker", "Evans", "Edwards", "Collins"
};


class: CChar ( CCharacterFaction, ICharacter );

function CChar:CChar( pClient, pDBField )
	self.m_pPlayer			= pClient;
	self.m_pClient			= pClient;
	
	self.m_iID 				= pDBField.id;
	self.m_iLevel			= pDBField.level;
	self.m_iLevelPoints		= pDBField.level_points;
	self.m_sName			= pDBField.name;
	self.m_sSurname			= pDBField.surname;
	self.m_sDateOfBirdth	= pDBField.date_of_birdth;
	self.m_sPlaceOfBirdth	= pDBField.place_of_birdth;
	self.m_sNation			= pDBField.nation;
	self.m_iSkin			= pDBField.skin;
	self.m_sCreated			= pDBField.created;
	self.m_sLastLogin		= pDBField.last_login;
	self.m_iAlcohol			= pDBField.alcohol;
	self.m_fPower			= pDBField.power;
	self.m_iSpawnInterior	= pDBField.spawn_id;
	
	self:InitJobs			( pDBField.job, pDBField.job_skill );
	self:InitLanguages		( pDBField.languages );
	self:InitMarried		( pDBField.married );
	self:InitPay			( pDBField.pay );
	self:InitPhone			( pDBField.phone );
	self:InitLicenses		( pDBField.licenses );
	
	self.m_fMoney			= (int)(pDBField.money);
	
	self.m_sJailed			= pDBField.jailed;
	self.m_iJailedTime		= pDBField.jailed_time;
	
	for weapon, value in pairs( default_weapon_skills ) do
		self.m_pClient:SetStat( _G[ weapon ], value );
	end
	
	self.m_Events		= {};
	
	if pDBField.events then
		for i, iEventType in ipairs( (string)(pDBField.events):split( "," ) ) do
			self.m_Events[ iEventType ] = true;
		end
	end
	
	self.m_pClient:SetData( "alcohol", self.m_iAlcohol );
	self.m_pClient:SetData( "CChar::m_fPower", self.m_fPower );
end

function CChar:_CChar()
	self:_CCharacterFaction();
	
	self.m_pClient:RemoveData( "alcohol" );
	
	self:Save();
	self:UnloadItems();
	
	self.m_pClient:Client().OnCharacterLogout();
	
	delete ( self._ICharacter );
	
	self.m_pClient.m_pCharacter = NULL;
end

function CChar:Logout( sType, sReason, pResponsePlayer )
	if self.m_pClient.m_pRace then
		self.m_pClient.m_pRace:OnPlayerLeave( self.m_pClient, sType );
	end
	
	if sType == "Quit" or sType == "Logout" then
		if self.m_pClient:IsCuffed() and not self:IsJailed() then
			self.m_sJailed		= "Police";
			self.m_iJailedTime	= 30 * 60;
		end
	end
	
	delete ( self );
end

function CChar:Save()
	local iTick			= getTickCount();
	
	local vecPosition	= self.m_pClient:IsSpectating() and self.m_pClient.spec_pos or self:GetPosition();
	local iInterior		= self.m_pClient:IsSpectating() and self.m_pClient.spec_int or self:GetInterior();
	local iDimension	= self.m_pClient:IsSpectating() and self.m_pClient.spec_dim or self:GetDimension();
	local fRotation		= self.m_pClient:IsSpectating() and self.m_pClient.spec_rot or self:GetRotation().Z;
	
	local fHealth		= self:GetHealth();
	local fArmor		= self:GetArmor();
	
	local query = ( 
	"UPDATE " + DBPREFIX + "characters SET \
	position = %q, interior = '%d', dimension = '%d', rotation = '%f', \
	health = '%f', armor = '%f', alcohol = '%f', power = '%f', jailed = %q, jailed_time = %d, \
	level_points = %d, last_logout = NOW() WHERE id = %d" ):format( 
		(string)(vecPosition), iInterior, iDimension, fRotation,
		fHealth, fArmor, self:GetAlcohol(), self:GetPower(), self:GetJailed(), self:GetJailedTime(),  self:GetLevelPoints(), 
		self:GetID()
	);
	
	if not g_pDB:Query( query ) then
		Debug( g_pDB:Error(), 1 );
	end
	
	if _DEBUG then
		Debug( "Character '" + self.m_sName + ' ' + self.m_sSurname + "' saved (" + ( getTickCount() - iTick ) + " ms)" );
	end
end

function CChar:IsEventComplete( iEventType )
	return self.m_Events[ iEventType ] == true;
end

function CChar:SetEventComplete( iEventType )
	self.m_Events[ iEventType ] = true;
	
	local Events = {};
	
	for iEvent in pairs( self.m_Events ) do
		table.insert( Events, iEvent );
	end
	
	if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET events = '" + table.concat( Events, "," ) + "' WHERE id = " + self:GetID() ) then
		return true;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return false;
end

function CChar:GetMoney()
	return self.m_fMoney;
end

function CChar:SetMoney( fMoney )
	if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET money = '%f' WHERE id = %d", fMoney, self:GetID() ) then		
		self.m_fMoney = fMoney;
		
		self.m_pPlayer:GetHUD():SetMoney( self.m_fMoney );
		
		return true;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return false;
end

function CChar:GiveMoney( fMoney, sReason )
	if sReason then
		g_pMoneyLog:Write( "[" + self:GetID() + "]" + self:GetName() + " +" + fMoney + " (" + sReason + ")" );
	end
	
	return self:SetMoney( self.m_fMoney + fMoney );
end

function CChar:TakeMoney( fMoney, sReason )
	if self.m_fMoney >= fMoney then
		if sReason then
			g_pMoneyLog:Write( "[" + self:GetID() + "]" + self:GetName() + " -" + fMoney + " (" + sReason + ")" );
		end
		
		return self:SetMoney( self.m_fMoney - fMoney );
	end
	
	return false;
end

function CChar:IsDead()
	return isPedDead( self.m_pClient );
end

function CChar:GetArmor()
	return getPedArmor( self.m_pClient );
end

function CChar:SetArmor( iArmor )
	return setPedArmor( self.m_pClient, iArmor );
end

function CChar:GetHealth()
	return getElementHealth( self.m_pClient );
end

function CChar:SetHealth( iHealth )
	return setElementHealth( self.m_pClient, iHealth );
end

function CChar:GetPosition()
	return Vector3( getElementPosition( self.m_pClient ) );
end

function CChar:SetPosition( vecPosition )
	return setElementPosition( self.m_pClient, vecPosition.X, vecPosition.Y, vecPosition.Z );
end

function CChar:GetRotation()
	return Vector3( getElementRotation( self.m_pClient ) );
end

function CChar:SetRotation( vecRotation )
	return setElementRotation( self.m_pClient, vecPosition.X, vecPosition.Y, vecPosition.Z );
end

function CChar:GetInterior()
	return getElementInterior( self.m_pClient );
end

function CChar:SetInterior( iInterior )
	return setElementInterior( self.m_pClient, (int)(iInterior) );
end

function CChar:GetDimension()
	return getElementDimension( self.m_pClient );
end

function CChar:SetDimension( iDimension )
	return setElementDimension( self.m_pClient, (int)(iDimension) );
end

function CChar:GetID()
	return self.m_iID;
end

function CChar:GetName()
	return self.m_sName + ' ' + self.m_sSurname;
end

function CChar:SetName( sName, sSurname )
	if type( sName ) ~= 'string' 	then error( TEXT_E2342:format( 'sName', 	'string', type( sName ) 	), 2 ); end
	if type( sSurname ) ~= 'string' then error( TEXT_E2342:format( 'sSurname', 	'string', type( sSurname ) 	), 2 ); end
	
	if sName:len() > 0 and sSurname:len() > 0 then
		if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET name = %q, surname = %q WHERE id = " + self.m_iID, sName, sSurname ) then
			if self.m_pClient:SetName( ( sName + '_' + sSurname ):gsub( ' ', '_' ) ) then
				self.m_sName	= sName;
				self.m_sSurname	= sSurname;
				
				self.m_pClient.m_pNametag:Update();
				
				return true, false;
			else
				return false, 1;
			end
		else
			return false, g_pDB.m_pHandler:errno() == 1062 and 2 or 3;
		end
	end
	
	return false, 0;
end

function CChar:GetLevel()
	return self.m_iLevel;
end

function CChar:GetLevelPoints()
	return self.m_iLevelPoints;
end

function CChar:SetLevel( iLevel, bResetPoints )
	if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET level = %d, level_points = %d WHERE id = %d", iLevel, bResetPoints and 0 or self.m_iLevelPoints, self.m_iID ) then
		self.m_iLevel = iLevel;
		
		if bResetPoints then
			self.m_iLevelPoints = 0;
		end
		
		self.m_pClient:SetData( 'player_level', self.m_iLevel );
		
		return true;
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	return false;
end

function CChar:GetSkin()
	return self.m_pClient:GetSkin();
end

function CChar:SetSkin( pSkin )
	if pSkin:IsValid() or pSkin:IsSpecial() then
		self.m_iSkin = pSkin:GetID() or self.m_iSkin;
	
		assert( g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET skin = %d WHERE id = %d", pSkin:GetID(), self:GetID() ) );
		
		self.m_pClient:SetSkin( pSkin );
		
		return true;
	end
	
	return false;
end

function CChar:SetSpawn( iInteriorID )
	self.m_iSpawnInterior = tonumber( iInteriorID ) or 0;
	
	if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET spawn_id = " + self.m_iSpawnInterior + " WHERE id = " + self:GetID() ) then
		return true;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return false;
end

function CChar:SetPower( fPower )
	self.m_fPower = Clamp( 0, (int)(fPower), 100 );
	
	if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET power = " + self.m_fPower + " WHERE id = " + self:GetID() ) then
		self.m_pClient:SetData( "CChar::m_fPower", self.m_fPower );
		
		return true;
	end

	Debug( g_pDB:Error(), 1 );
	
	return false;
end

function CChar:GetPower()
	return self.m_fPower;
end

function CChar:SetAlcohol( iAlcohol )
	self.m_iAlcohol = Clamp( 0, (int)(iAlcohol), 100 );
	
	if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET alcohol = " + self.m_iAlcohol + " WHERE id = " + self:GetID() ) then
		self.m_pClient:SetData( "alcohol", self.m_iAlcohol, true, true );
		
		return true;
	end

	Debug( g_pDB:Error(), 1 );
	
	return false;
end

function CChar:GetAlcohol()
	return self.m_iAlcohol;
end

function CChar:DoPulse( tReal )
	if self.m_iAlcohol > 0 then
		self.m_iAlcohol = Clamp( 0, self.m_iAlcohol - math.random() * .4, 100 );
		
		self.m_pClient:SetData( "alcohol", self.m_iAlcohol, true, true );
		
		if self.m_iAlcohol > 30 and getTickCount() - ( self.m_pDrinkAnimationTime or 0 ) > 0 then
			self.m_pClient:SetAnimation( CPlayerAnimation.PRIORITY_FOOD, "PED", "WALK_drunk", 900, true, true, true, true );
		end
	end
end

function CChar:GetRandomName()
	local sRandomName		= gl_Names		[ math.random( table.getn( gl_Names ) ) ];
	local sRandomSurname	= gl_Surnames	[ math.random( table.getn( gl_Surnames ) ) ];
	
	return { Name = sRandomName, Surname = sRandomSurname };
end