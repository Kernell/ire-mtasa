-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local eErrorData = 
{
	UNK_ERROR			= "Попробуйте позже";
	DB_ERROR			= "Ошибка при работе с базой данных";
	REG_DISABLED		= "Регистрация временно отключена";
	MULTIACCOUNT		= "Вы уже регистрировались на этом сервере";
	EMAIL_IN_USE		= "Данный e-mail уже используется";
	EMAIL_IS_BLANK		= "Введите Ваш e-mail";
	EMAIL_IS_SHORT		= "E-mail может быть не менее 3-х символов";
	EMAIL_IS_LONG		= "E-mail может быть не более 64-х символов";
	EMAIL_IS_INVALID	= "Неправильный формат e-mail";
	PASSWORD_IS_BLANK	= "Введите пароль";
	PASSWORD_IS_SHORT	= "Пароль может быть не менее 4-х символов";
	PASSWORD_IS_LONG	= "Пароль может быть не более 64-х символов";
	NICKNAME_IN_USE		= "Этот никнейм уже используется";
	NICKNAME_IS_BLANK	= "Введите Ваш никнейм";
	NICKNAME_IS_SHORT	= "Никнейм может быть не менее 3-х символов";
	NICKNAME_IS_LONG	= "Никнейм может быть не более 64-х символов";
	NICKNAME_IS_INVALID	= "Никнейм содержит запрещённые символы";
	NICKNAME_IS_NUMBER	= "Никнейм не может состоять только из чисел";
	REFER_NOT_FOUND		= "Пользователь с таким именем не найден";
	REFER_IS_INVALID	= "Имя пользователя содержит запрещённые символы";
	IPB_ERROR			= "Ошибка при создании учётной записи Invision Power Board.\nПожалуйста, сообщите об ошибке системному администратору";
};

class: AsyncQuery
{
	static
	{
		OK					= 200;
		BAD_REQUEST			= 400;
		UNAUTHORIZED		= 401;
		FORBIDDEN			= 403;
		NOT_FOUND			= 404;
		REQUEST_TIMEOUT		= 408;
		TOO_MANY_REQUESTS	= 429;
	};
};

class: CClientRPC
{
	CBankManager			= function( ... )	return g_pGame:GetBankManager():ClientHandle( ... );	end;
	CFactionManager			= function( ... )	return g_pGame:GetFactionManager():ClientHandle( ... );	end;
	CPlayerManager			= function( ... )	return g_pGame:GetPlayerManager():ClientHandle( ... );	end;
};

function CClientRPC:CClientRPC()
	self.m_sServerClient	= "CClientRPC:ServerClient";
	self.m_sClientServer	= "CClientRPC:ClientServer";

	addEvent( self.m_sClientServer, true );

	addEventHandler( self.m_sClientServer, root, 
		function( Data, ... )
			if type( Data ) ~= "table" then return; end
			
			if not CClientRPC[ Data.Function ] then
				if Data.ID then
					client:Client().CClientRPC__Handler( AsyncQuery.NOT_FOUND, Data.ID );
				end
				
				error( 'RPC - ' + (string)(client:GetName()) + ' (' + (string)(client:GetID()) + ') called undefined function "' + (string)(Data.Function) + '"', 2 );
			end
			
			local vResult = CClientRPC[ Data.Function ]( client, ... );
			
			if Data.ID and isElement( client ) then
				if AsyncQuery[ vResult ] then
					client:Client( true ).CClientRPC__Handler( AsyncQuery[ vResult ], Data.ID );
				else
					client:Client( true ).CClientRPC__Handler( AsyncQuery.OK, Data.ID, vResult );
				end
			end
		end
	);

	function CPlayer.Client( this, iBandwidth, bPersist )
		local aSpace	= {};
		
		local pInstance = 
		{	
			__index = function( t, sIndex )
				table.insert( aSpace, sIndex );
				
				local pElement = this.__instance and getElementType( this.__instance ) == "player" and this.__instance or root;
				
				local pObject = 
				{
					__call	= function( tt, ... )
						if iBandwidth then
							triggerLatentClientEvent( pElement, self.m_sServerClient, tonumber( iBandwidth ) or 56000, (bool)(bPersist), pElement, aSpace, ... );
						else
							triggerClientEvent( pElement, self.m_sServerClient, pElement, aSpace, ... );
						end
					end;
					
					__index	= t.__index;
				};
				
				return setmetatable( pObject, pObject );
			end;
		};
		
		return setmetatable( pInstance, pInstance );
	end
end

function CClientRPC:SaveSettings( pSettings )
	if self:IsLoggedIn() then
		local sSettings = toJSON( pSettings );
		
		if not sSettings then
			sSettings = "NULL";
		else
			sSettings = "'" + sSettings + "'";
		end
		
		if not g_pDB:Query( "UPDATE uac_users SET settings = " + sSettings + " WHERE id = " + self:GetID() ) then
			Debug( g_pDB:Error(), 1 );
		end
	end
end

function CClientRPC:Ready()
	self:ShowLoginScreen();
	
	self:ToggleControls( true, true, false );
	self:DisableControls( "next_weapon", "previous_weapon", "action", "walk", "fire", "horn", "radio_next", "radio_previous", "vehicle_left", "vehicle_right" );
	
	self:BindKey( "horn", "both", CPlayer.VehicleHorn );
	self:BindKey( "j", "up", CPlayer.VehicleToggleEngine );
	self:BindKey( "k", "up", CPlayer.VehicleToggleLocked );
	self:BindKey( "l", "up", CPlayer.VehicleToggleLights );
	
	self:BindKey( "vehicle_fire", 			"both", CPlayer.VehicleToggleNitro );
	self:BindKey( "vehicle_secondary_fire", "both", CPlayer.VehicleToggleNitro );
	
	self:BindKey( 'sprint', 'both', CPlayer.SprintHandler );
end

function CClientRPC:Exec( sCmd )
	local Command = sCmd:split( " " );
	
	CCommand:Exec( self, Command[ 1 ], unpack( Command, 2 ) );
end

function CClientRPC:TryLogin( sLogin, sPassword, bRemember )
	local sQuery = "SELECT u.id, u.activation_code, u.ban, u.ban_reason, uu.name AS ban_user_name, DATE_FORMAT( u.ban_date, '%d/%m/%Y %h:%i:%s' ) AS ban_date FROM uac_users u LEFT JOIN uac_users uu ON uu.id = u.ban_user_id WHERE u.login = '" + g_pDB:EscapeString( sLogin ) + "' AND u.deleted = 'No'";
	
	if sLogin ~= "root" and IPSMember.DB.m_pHandler then
		local pIPBResult = IPSMember.DB:Query( "SELECT `member_id` FROM `" + IPSMember.PREFIX + "members` WHERE `email` = %q AND `members_pass_hash` = MD5( CONCAT( MD5( `members_pass_salt` ), MD5( %q ) ) ) LIMIT 1", sLogin, sPassword );
		
		if not pIPBResult then
			Debug( IPSMember.DB:Error(), 1 );
			
			return TEXT_DB_ERROR;
		end
		
		local pRow = pIPBResult:FetchRow();
		
		delete ( pIPBResult );
		
		if not pRow or not pRow.member_id then
			self.m_iLoginAttempt = ( self.m_iLoginAttempt or 0 ) + 1;
			
			if self.m_iLoginAttempt > 5 then
				self:Ban( "Попытка взлома (подбор пароля)", 1440 );
				
				return;
			end
			
			return "Неверный логин или пароль";
		end
		
		self.m_iLoginAttempt = NULL;
	else
		sQuery = sQuery + " AND u.password = '" + g_pBlowfish:Encrypt( sPassword ) + "'";
	end
	
	local pResult = g_pDB:Query( sQuery );
	
	if not pResult then
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR;
	end
	
	local pRow = pResult:FetchRow();
	
	delete ( pResult );
	
	if not pRow or not pRow.id then
		self.m_iLoginAttempt = ( self.m_iLoginAttempt or 0 ) + 1;
		
		if self.m_iLoginAttempt > 5 then
			self:Ban( "Попытка взлома (подбор пароля)", 1440 );
			
			return;
		end
		
		return "Неверный логин или пароль";
	end
	
	self.m_iLoginAttempt = NULL;
	
	if pRow.activation_code then
		return "Ваша учётная запись не активирована";
	end
	
	if pRow.ban == "Yes" then
		local sReason	= Args[ 1 ] and " (" + pRow.ban_reason + ")" or "";
		local sAdmin	= Args[ 2 ] and "администратором " + pRow.ban_user_name or "";
		
		return "Ваша учётная запись заблокирована " + sAdmin + sReason;
	end
	
	for _, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
		if pPlr:GetUserID() == pRow.id then
			return "Другой игрок в настоящее время находится под этой учётной записью";
		end
	end
	
	self.m_sPasswordEnc = g_pBlowfish:Encrypt( sPassword );
	self.m_bAutoLogin	= bRemember;
	
	setTimer( self.Login, 1000, 1, self, pRow.id );

	return true;
end

function CClientRPC:RegDialog()
	if not g_pGame.m_bRegistration then
		return TEXT_REG_UNAVAILABLE;
	end
	
	return true;
end

function CClientRPC:Register( sEmail, sPassword, sNickname, sReferUser )
	sEmail		= (string)(sEmail);
	sPassword	= (string)(sPassword);
	sNickname	= (string)(sNickname);
	sReferUser	= (string)(sReferUser);
	
	if sEmail:len() == 0				then	return eErrorData.EMAIL_IS_BLANK;	end
	if sEmail:len() < 3					then	return eErrorData.EMAIL_IS_SHORT;	end
	if sEmail:len() > 64				then	return eErrorData.EMAIL_IS_LONG;	end
	if not CUser:IsMailValid( sEmail )	then	return eErrorData.EMAIL_IS_INVALID;	end
	
	if sPassword:len() == 0		then	return eErrorData.PASSWORD_IS_BLANK;	end
	if sPassword:len() < 4		then	return eErrorData.PASSWORD_IS_SHORT;	end
	if sPassword:len() > 64		then	return eErrorData.PASSWORD_IS_LONG;		end
	if sNickname:len() == 0		then	return eErrorData.NICKNAME_IS_BLANK;	end
	if sNickname:len() < 3		then	return eErrorData.NICKNAME_IS_SHORT;	end
	if sNickname:len() > 64		then	return eErrorData.NICKNAME_IS_LONG;		end
	if tonumber( sNickname ) 	then	return eErrorData.NICKNAME_IS_NUMBER;	end
	
	if not sNickname:find( "[^A-Za-z0-9]" ) then
		local iReferID = 0;
		
		if sReferUser and sReferUser:len() > 0 then
			if sReferUser:len() > 64 then
				sReferUser = sReferUser:sub( 1, 64 );
			end
			
			if not sReferUser:find( "[^A-Za-z0-9]" ) then
				local pResult = g_pDB:Query( "SELECT id FROM uac_users WHERE LOWER( name ) = LOWER( %q )", sReferUser );
				
				if not pResult then
					Debug( g_pDB:Error(), 1 );
					
					return eErrorData.DB_ERROR;
				end
				
				local iNumRows	= pResult:NumRows();
				local pRow		= pResult:FetchRow();
				
				delete ( pResult );
				
				if iNumRows ~= 1 then
					return eErrorData.REFER_NOT_FOUND;
				end
				
				iReferID = pRow and (int)(pRow.id) or 0;
			else
				return eErrorData.REFER_IS_INVALID;
			end
		end
		
		local sSerial = self:GetSerial();
		
		local pResult = g_pDB:Query( "SELECT SUM( login = %q ) AS mail, SUM( name = %q ) AS name, SUM( serial = %q OR serial_reg = %q ) AS serial FROM uac_users", sEmail, sNickname, sSerial, sSerial );
		
		if not pResult then
			Debug( g_pDB:Error(), 1 );
			
			return eErrorData.DB_ERROR;
		end
		
		local pRow = pResult:FetchRow();
		
		delete ( pResult );
		
		if pRow.mail > 0 	then	return eErrorData.EMAIL_IN_USE;		end
		if pRow.name > 0 	then	return eErrorData.NICKNAME_IN_USE;	end
		
		if not g_pGame.m_bAllowMultiaccount then
			if pRow.serial > 0 then	return eErrorData.MULTIACCOUNT;	end
		end
		
		-- local sActivationCode = md5( md5( math.random( 0, 999999999 ) ) + md5( getRealTime().timestamp ) );
		
		if IPSMember.DB.m_pHandler then
			if not IPSMember:Create( 
				{
					members = 
					{
						password				= (string)(sPassword);
						name					= (string)(sNickname);
						email					= (string)(sEmail); 
						ip_address				= (string)(self:GetIP()); 
						members_display_name	= (string)(sNickname);
					};
				},
				true
			) then
				return eErrorData.IPB_ERROR;
			end
		else
			Debug( "IPSMember::Create - Connection with IPS database is not established", 2 );
		end
		
		local iID = g_pDB:Insert( "uac_users",
			{
				refer_id		= iReferID;
				login			= sEmail:lower();
				password		= g_pBlowfish:Encrypt( sPassword );
				name			= sNickname;
				serial_reg		= sSerial;
				ip_reg			= self:GetIP();
			--	activation_code	= sActivationCode;
			}
		);
		
		if iID then
			g_pServer:Print( "Registered new account %q (%q) (ID: %d, Serial: %s, IP: %s)", sNickname, sEmail, iID, sSerial, self:GetIP() );
			
			return true;
		end
		
		Debug( g_pDB:Error(), 1 );
		
		return eErrorData.DB_ERROR;
	end
	
	return eErrorData.NICKNAME_IS_INVALID;
end

function CClientRPC:Character__Create( sName, sSurname, iSkin, iYear, iMonth, iDay, iCityID, bTest )
	local pResult = g_pDB:Query( "SELECT COUNT(id) AS c FROM " + DBPREFIX + "characters WHERE user_id = %d AND ( status = 'Активен' OR status = 'Заблокирован' )", self:GetUserID() );
	
	if not pResult then
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR;
	end
	
	local pRow = pResult:FetchRow();
	
	delete ( pResult );
	
	if not bTest then
		if pRow and pRow.c >= g_pGame.m_iCharactersLimit then
			return "Вы не можете создавать больше персонажей";
		end
	end
	
	sName		= (string)(sName);
	sSurname	= (string)(sSurname);
	iSkin		= (int)(iSkin);
	iDay		= (int)(iDay);
	iMonth		= (int)(iMonth);
	iYear		= (int)(iYear);
	sDate		= (string)(sDate);
	iCityID		= (int)(iCityID);
	
	if sName:len() == 0 then
		return "Введите имя персонажа";
	end
	
	if sSurname:len() == 0 then
		return "Введите фамилию персонажа";
	end
	
	if sName:len() < 3 then
		return "Имя слишком короткое";
	end
	
	if sSurname:len() < 3 then
		return "Фамилия слишком короткая";
	end
	
	if ( sName + sSurname ):len() > 21 then
		return "Общая длина имени и фамилии не может быть более 21 символа";
	end
	
	if not not sName:find( "[^A-Za-z]" ) then
		return "Имя содержит запрещённые символы\n\nИспользуйте только символы латинского алфавита";
	end
	
	if not not sSurname:find( "[^A-Za-z]" ) then
		return "Фамилия содержит запрещённые символы\n\nИспользуйте только символы латинского алфавита";
	end
	
	if not iSkin then
		return "Вы не выбрали скин персонажа";
	end
	
	if not CPed.GetSkin( iSkin ).IsValid() then
		return "Данный скин отключён";
	end
	
	if iCityID == 0 then
		return "Необходимо выбрать Город и Страну из предлагаемого списка";
	end
	
	if iDay == 0 or iMonth == 0 or iYear == 0 then
		return "Введите дату рождения персонажа";
	end
	
	sName		= sName[ 1 ]:upper() + sName:sub( 2, sName:len() ):lower(); -- fix case
	sSurname	= sSurname[ 1 ]:upper() + sSurname:sub( 2, sSurname:len() ):lower(); -- fix case
	
	local pResult = g_pDB:Query( "SELECT COUNT(id) AS c FROM " + DBPREFIX + "characters WHERE name = %q AND surname = %q", sName, sSurname );
	
	if not pResult then
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR;
	end
	
	local pRow = pResult:FetchRow();
	
	delete ( pResult );
	
	if not bTest then	
		if pRow and pRow.c > 0 then
			return "Персонаж с таким именем уже существует";
		end
	end
	
	local pPlaceResult = g_pDB:Query( "SELECT c.name, cc.city, cc.region FROM cities cc JOIN countries c USING( country_id ) WHERE cc.id = " + iCityID );
	
	if not pPlaceResult then
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR;
	end
	
	local pRowPlace = pPlaceResult:FetchRow();
	
	delete ( pPlaceResult );
	
	if not pRowPlace then
		return "Поле 'Место рождения' заполнено некорректно";
	end
	
	local sLanguage	= "en";
	
	local Languages	= { current = sLanguage };
	
	Languages[ sLanguage ] = 1000;
	
	local Licenses	= { "vehicle" };
	
	local iCharID	= g_pDB:Insert( DBPREFIX + "characters",
		{
			user_id				= self:GetUserID();
			name				= sName;
			surname				= sSurname;
			skin				= iSkin;
			date_of_birdth		= ( "%04d-%02d-%02d" ):format( 1970 + iYear, iMonth, iDay );
			place_of_birdth		= ( "%s, %s, %s" ):format( pRowPlace.name, pRowPlace.region, pRowPlace.city );
			nation				= sLanguage;
			languages			= Languages;
			licenses			= Licenses;
			position			= (string)(CHAR_CREATE_SPAWN_POSITION);
			rotation			= CHAR_CREATE_SPAWN_ANGLE;
			created				= CDateTime():Format( "Y-m-d H:i:s" );
		}
	);
	
	if not iCharID then
		return TEXT_DB_ERROR;
	end
	
	if not bTest then
		self:LoginCharacter( sName, sSurname );
	end
	
	printf( '%s (%d) Created new character "%s_%s" (%d)', self:GetUserName(), self:GetUserID(), sName, sSurname, iCharID );
	
	if not bTest then
		g_pGame:GetEventManager():Call( EVENT_TYPE_NEW_CHARACTER, self );
	end
	
	return true;
end

function CClientRPC:LoadCharacters()
	if self:IsLoggedIn() then
		self:GetCamera():MoveTo( DEFAULT_CAMERA_POSITION, 500, "OutQuad" );
		self:GetCamera():RotateTo( DEFAULT_CAMERA_TARGET, 500 );
		
		self:LoadCharacters( self:GetUserID() );
	end
end

function CClientRPC:SelectCharacter( sName, sSurname )
	sName 		= (string)(sName);
	sSurname 	= (string)(sSurname);
	
	if sName == "NEW" then	
		self:GetCamera():MoveTo( NEW_CHAR_CAMERA_POSITION, 500, "OutQuad" );
		self:GetCamera():RotateTo( NEW_CHAR_CAMERA_TARGET, 1 );
		
		self:Client().CUICharacterCreate( sSurname == "true" );
	else
		if not self:LoginCharacter( sName, sSurname ) then
			-- self:LoadCharacters( self:GetUserID() );
			self:MessageBox( NULL, "Ошибка авторизации, обратитесь к системному администратору", "Login character failed", MessageBoxButtons.OK, MessageBoxIcon.Error );
		end
	end
end

function CClientRPC:LogoutCharacter()
	triggerEvent( "onCharacterLogout", self );
	self.m_pCharacter:Logout( "Logout" );
	
	self:InitLoginCamera();
	self:LoadCharacters( self:GetUserID() );
end

function CClientRPC:SetAnimation( ... )
	return not self:IsInVehicle() and self:SetAnimation( CPlayerAnimation.PRIORITY_ALL, ... );
end

function CClientRPC:SetSpawn( iInteriorID )
	local pChar = self:GetChar();
	
	if pChar then
		if type( iInteriorID ) == 'number' then
			local IntTypes	=
			{
				interior	= true;
				house		= true;
				business	= false;
			};
			
			local pFaction	= pChar:GetFaction();
		
			for _, pInt in pairs( g_pGame:GetInteriorManager():GetAll() ) do
				if IntTypes[ pInt:GetType() ] then
					if pInt:GetOwner() == pChar:GetID() or ( pFaction ~= NULL and pFaction == pInt:GetFaction() ) then
						return pChar:SetSpawn( iInteriorID );
					end
				end
			end
		end
	end
end

function CClientRPC:SearchCountry( sQuery )
	sQuery = (string)(sQuery);
	
	if sQuery:utfLen() > 0 then
		for i = 1, sQuery:utfLen() do
			local char = sQuery:utfSub( 1, 1 ):utfCode();
			
			if 	( char >= 1072 and char <= 1103 or char >= 1040 and char <= 1071 )
				or
				( char >= 65 and char <= 90 or char >= 97 and char <= 122 )
			then
				-- true;
			else
				if _DEBUG then
					Debug( "invalid char " + char, 3 );
				end
				
				return false;
			end
		end
		
		local pResult = g_pDB:Query( "SELECT country_id AS id, name FROM countries WHERE name LIKE '%" + sQuery + "%' ORDER BY country_id LIMIT 15" );
		
		if pResult then
			local Result = 
			{
				{
					id		= NULL;
					name	= "Страна не найдена";
				};
			};
			
			if pResult:NumRows() > 0 then
				Result = pResult:GetArray();
			end
			
			delete ( pResult );
			
			return Result;
		else
			Debug( g_pDB:Error(), 1 );
		end
	end
	
	return NULL;
end

function CClientRPC:SearchCity( sQuery, iCountryID )
	sQuery		= (string)(sQuery);
	iCountryID	= (int)(iCountryID);
	
	if sQuery:utfLen() > 0 and iCountryID > 0 then
		for i = 1, sQuery:utfLen() do
			local char = sQuery:utfSub( 1, 1 ):utfCode();
			
			if 	( char >= 1072 and char <= 1103 or char >= 1040 and char <= 1071 )
				or
				( char >= 65 and char <= 90 or char >= 97 and char <= 122 )
			then
				-- true;
			else
				if _DEBUG then
					Debug( "invalid char " + char, 3 );
				end
				
				return false;
			end
		end
		
		local q = "SELECT id, city AS name, state, region FROM cities WHERE country_id = " + iCountryID + " AND city LIKE '%" + sQuery + "%' LIMIT 15";
		
		-- Debug( q, 0 );
		
		local pResult = g_pDB:Query( q );
		
		if pResult then
			local Result =
			{
				{
					id		= NULL;
					name	= "Город не найден\n";
					state	= "";
					region	= "";
				};
			};
			
			if pResult:NumRows() > 0 then
				Result = pResult:GetArray();
			end
			
			delete ( pResult );
			
			return Result;
		else
			Debug( g_pDB:Error(), 1 );
		end
	end
end

function CClientRPC:BuyItem( iShopID, sItem )
	if self:IsInGame() then
		local pShop = g_pGame:GetShopManager():Get( iShopID );
		
		if pShop then
			pShop:BuyItem( self, sItem );
		else
			Debug( "Player " + self:GetName() + " requested invalid shop " + (string)(iShopID), 1 );
		end
	end
end

function CClientRPC:BuySkin( iShopID, sItem )
	if self:IsInGame() then
		local pShop = g_pGame:GetShopManager():Get( iShopID );
		
		if pShop then
			pShop:BuySkin( self, sItem );
		else
			Debug( "Player " + self:GetName() + " requested invalid shop " + (string)(iShopID), 1 );
		end
	end
end

function CClientRPC:RestoreSkin()
	if self:IsInGame() then
		self:Client().setElementModel( self, self:GetChar().m_iSkin );
		self:SetModel( self:GetChar().m_iSkin );
	end
end

function CClientRPC:CreateFaction( sTitle, sAbbr, sAddress, iType )
	local vResult, iR, iG, iB = CFactionCommands:New( self, NULL, NULL, "--name", sTitle, "--tag", sAbbr, "--address", sAddress, "--type", sType );
	
	if type( vResult ) == "string" then
		local sCaption	= "Information";
		local Icon		= MessageBoxIcon.Information;
		
		if iRed == 255 and iGreen == 0 and iBlue == 0 then
			sCaption	= "Error";
			Icon		= MessageBoxIcon.Error;
		end
		
		self:MessageBox( NULL, vResult, sCaption, MessageBoxButtons.OK, Icon );
	end
end

function CClientRPC:Faction_AddDept( sDeptName, iFactionID )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	local pFaction = g_pGame:GetFactionManager():Get( iFactionID );
		
	if not pFaction then
		return "Invalid faction id";
	end
	
	if sDeptName:utfLen() < 4 then
		return "Слишком короткое название отдела";
	end
	
	if pregFind then
		if pregFind( sDeptName, "^[A-Za-z0-9А-Яа-я ,.]" ) then
			return "Название отдела содержит запрещённые символы";
		end
	else	
		for i = 1, sDeptName:utfLen() do
			local sChar = sDeptName:utfSub( i, i );
			
			if not tonumber( sChar ) then
				local iChar = sChar:utfCode();
				
				if not ( ( iChar >= 65 and iChar <= 90 ) or ( iChar >= 97 and iChar <= 122 ) or ( iChar >= 1040 and iChar <= 1103 ) or iChar == 32 or iChar == 44 or iChar == 46 ) then
					return "Название отдела содержит запрещённые символы";
				end
			end
		end
	end
	
	local iDeptCount = table.getn( pFaction.m_Depts );
	
	if iDeptCount >= 8 then
		return "Достигнут лимит количества отделов";
	end
	
	local iDeptID = iDeptCount + 1;
	
	local bInsert = g_pDB:Insert( DBPREFIX + "faction_depts",
		{
			id			= iDeptID;
			faction_id	= iFactionID;
			name		= sDeptName;
		}
	);
	
	if not bInsert then
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR;
	end
	
	pFaction.m_Depts[ iDeptID ] =
	{
		ID		= iDeptID;
		Name	= sDeptName;
		Ranks	= {};
	};
	
	return pFaction.m_Depts;
end

function CClientRPC:Faction_EditDept( sDeptName, iDeptID, iFactionID )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	local pFaction = g_pGame:GetFactionManager():Get( iFactionID );
		
	if not pFaction then
		return "Invalid faction id";
	end
	
	if not pFaction.m_Depts[ iDeptID ] then
		return "Этого отдела уже не существует";
	end
	
	if sDeptName:utfLen() < 5 then
		return "Слишком короткое название отдела";
	end
	
	if pregFind then
		if pregFind( sDeptName, "^[A-Za-z0-9А-Яа-я ,.]" ) then
			return "Название отдела содержит запрещённые символы";
		end
	else	
		for i = 1, sDeptName:utfLen() do
			local sChar = sDeptName:utfSub( i, i );
			
			if not tonumber( sChar ) then
				local iChar = sChar:utfCode();
				
				if not ( ( iChar >= 65 and iChar <= 90 ) or ( iChar >= 97 and iChar <= 122 ) or ( iChar >= 1040 and iChar <= 1103 ) or iChar == 32 or iChar == 44 or iChar == 46 ) then
					return "Название отдела содержит запрещённые символы";
				end
			end
		end
	end
	
	if not g_pDB:Query( "UPDATE " + DBPREFIX + "faction_depts SET name = %q WHERE id = %d AND faction_id = %d", sDeptName, iDeptID, iFactionID ) then
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR;
	end
	
	pFaction.m_Depts[ iDeptID ].Name = sDeptName;
	
	return pFaction.m_Depts;
end

function CClientRPC:SetInteriorData( iID, sDataName, ... )
	local pInterior = g_pGame:GetInteriorManager():Get( iID );
	
	if pInterior then
		local vResult, iRed, iGreen, iBlue;
		
		local Data				=
		{
			[ "ID" ]			= "set";
			[ "Название" ]		= "setname";
			[ "Тип" ]			= "settype";
			[ "Цена" ]			= "setprice";
			[ "Владелец" ]		= "setowner";
			[ "Организация" ]	= "setfaction";
			[ "Закрыт" ]		= "setlocked";
		};
		
		local Commands			=
		{
			set					= CInteriorCommands.Set;
			setname				= CInteriorCommands.SetName;
			settype				= CInteriorCommands.SetType;
			setprice			= CInteriorCommands.SetPrice;
			setowner			= CInteriorCommands.SetOwner;
			setfaction			= CInteriorCommands.SetFaction;
			setlocked			= CInteriorCommands.SetLocked;
		};
		
		local Function			= Commands[ Data[ sDataName ] ];
		
		if Function then
			if self:HaveAccess( "command.interior:" + Data[ sDataName ] ) or ( sDataName == "Закрыт" and pInterior:GetOwner() == self:GetChar():GetID() ) then
				vResult, iRed, iGreen, iBlue = Function( CInteriorCommands, self, NULL, NULL, iID, ... );
			end
		end
		
		pInterior:OpenMenu( self, true );
		
		if vResult then
			if type( vResult ) == "string" then
				local Caption	= "Information";
				local Icon		= MessageBoxIcon.Information;
				
				if iRed == 255 and iGreen == 0 and iBlue == 0 then
					Caption		= "Error";
					Icon		= MessageBoxIcon.Error;
				end
				
				self:MessageBox( NULL, vResult, Caption, MessageBoxButtons.OK, Icon );
			end
		end
	else
		self:Client().InteriorMenu( false );
	end
end

function CClientRPC:Property__RemoveUpgrade( iPropertyID, sUpgradeID )
	local pChar = self:GetChar();
	
	if not pChar then return AsyncQuery.UNAUTHORIZED; end
	
	local pProperty = g_pGame:GetInteriorManager():Get( iPropertyID );
	
	if not pProperty then return AsyncQuery.BAD_REQUEST; end
	
	local pUpgrade = ePropertyUpgrade[ sUpgradeID ];
	
	if not pUpgrade then return AsyncQuery.BAD_REQUEST; end
	
	if pProperty.m_iCharacterID ~= pChar:GetID() then return "Только владелец может удалять апгрейды"; end
	
	if not pProperty.m_pUpgrades.m_Upgrades[ sUpgradeID ] then return "Этот апгрейд не установлен"; end
	
	if not pProperty:AddUpgrade( sUpgradeID ) then
		return "Внутренняя ошибка сервера. Обратитесь к системному администратору";
	end
	
	local Upgrades	= {};
	
	for sUpgrade in pairs( pProperty.m_pUpgrades.m_Upgrades ) do
		Upgrades[ sUpgrade ] = true;
	end
	
	return Upgrades;
end

function CClientRPC:ReturnOffer( bAccepted, sOfferID )	
	if self:IsInGame() then
		if self:IsInVehicle() then
			self:GetChat():Send( "Функция не доступна в автомобиле", 255, 0, 0 );
			
			return;
		end
		
		if self.m_Offers and self.m_Offers[ sOfferID ] then
			local pOffer	= self.m_Offers[ sOfferID ].pOffer;
			local sOption	= self.m_Offers[ sOfferID ].sOption;
			
			if pOffer and pOffer:IsInGame() then
				if bAccepted then
					local vecSelfPosition	= self:GetPosition();
					local vecOfferPosition	= pOffer:GetPosition();
					
					if pOffer:IsAdmin() or self:GetDimension() ~= pOffer:GetDimension() or vecSelfPosition:Distance( vecOfferPosition ) > 2.0 then
						self:Hint	( "Ошибка", TEXT_PLAYER_NOT_NEARBY, "error" );
						pOffer:Hint	( "Ошибка", TEXT_PLAYER_NOT_NEARBY, "error" );
						
						return;
					end
					
					if ( vecSelfPosition.Z - vecOfferPosition.Z ):abs() > 0.5 then
						self:Hint	( "Ошибка", "Вы должны быть на одной высоте с другим игроком", "error" );
						pOffer:Hint	( "Ошибка", "Вы должны быть на одной высоте с другим игроком", "error" );
						
						return;
					end
					
					if sOption == "kiss" then
						if not pOffer:CheckPriority( CPlayerAnimation.PRIORITY_OFFERS ) or not self:CheckPriority( CPlayerAnimation.PRIORITY_OFFERS ) then
							self:Hint	( "Ошибка", "Эта функция недоступна в данный момент", "error" );
							pOffer:Hint	( "Ошибка", "Эта функция недоступна в данный момент", "error" );
							
							return;
						end
						
						local sMyAnimation		= self:GetSkin().GetGender() == "female" and "Grlfrd_Kiss_02" or "Playa_Kiss_02";
						local sOfferAnimation	= pOffer:GetSkin().GetGender() == "female" and "Grlfrd_Kiss_02" or "Playa_Kiss_02";
						
						if pOffer:GetSkin().GetGender() == self:GetSkin().GetGender() then
							sMyAnimation	= "Grlfrd_Kiss_02";
							sOfferAnimation	= "Playa_Kiss_02";
						end
						
						pOffer:SetRotationAt( self:GetPosition() );
						self:SetRotationAt( pOffer:GetPosition() );
						
						pOffer:SetPosition( self:GetPosition():Offset( 0.9, self:GetRotation() ) );
						
						pOffer:SetData	( "Headmove:Pause", 6000 );
						self:SetData	( "Headmove:Pause", 6000 );
						
						pOffer:SetAnimation( CPlayerAnimation.PRIORITY_OFFERS, "KISSING", sOfferAnimation, 6000, false, false, false, false );
						self:SetAnimation( CPlayerAnimation.PRIORITY_OFFERS, "KISSING", sMyAnimation, 6000, false, false, false, false );
					elseif sOption == "propose" then
						if self:GetChar():IsMarried() then
							self:GetChat():Send( "Вы уже " + self:Gender( 'женаты на ', 'замужем за ' ) + self:GetChar():GetMarried(), 255, 0, 0 );
							
							return;
						end
						
						if pOffer:GetChar():IsMarried() then
							pOffer:GetChat():Send( "Вы уже " + pOffer:Gender( 'женаты на ', 'замужем за ' ) + pOffer:GetChar():GetMarried(), 255, 0, 0 );
							
							return;
						end
						
						if self:GetPosition():Distance( Vector3( 2243.895, -1356.061, 24.478 ) ) < 5.0 then
							local pMale		= self:GetSkin().GetGender() == 'male' and self:GetChar() or pOffer:GetChar();
							local pFemale	= self:GetSkin().GetGender() == 'female' and self:GetChar() or pOffer:GetChar();
							
							if pMale:GetMoney() >= 10000 then
								pMale:TakeMoney( 10000 );
								
								pMale:SetMarried( pFemale );
								pFemale:SetMarried( pMale );
								
								pMale.m_pPlayer:Hint( "Поздравляем!", "Теперь Вы женаты на " + pFemale:GetName(), "ok" );
								pFemale.m_pPlayer:Hint( "Поздравляем!", "Теперь Вы замужем за " + pMale:GetName(), "ok" );
							else
								pMale.m_pClient:GetChat():Send( "Затраты приёма брака - $10000", 222, 222, 222 );
							end
						else
							self:GetChat():Send( "Вы должны быть у церкви в Los Angeles", 255, 32, 32 );
							pOffer:GetChat():Send( "Вы должны быть у церкви в Los Angeles", 255, 32, 32 );
						end
					elseif sOption == "divorce" then
						if self:GetChar():GetMarried() == pOffer:GetChar():GetName() and pOffer:GetChar():GetMarried() == self:GetChar():GetName() then
							self:GetChar():SetMarried();
							pOffer:GetChar():SetMarried();
							
							pOffer:GetChat():Send( "Теперь Вы больше не " + pOffer:Gender( "женаты", "замужем" ), 255, 64, 64 );
							self:GetChat():Send( "Теперь Вы больше не " + self:Gender( "женаты", "замужем" ), 255, 64, 64 );
						else
							self:GetChat():Send( "Вы не " + self:Gender( "женаты на ", "замужем за " ) + pOffer:GetName(), 255, 0, 0 );
							pOffer:GetChat():Send( "Вы не " + pOffer:Gender( "женаты на ", "замужем за " ) + self:GetName(), 255, 0, 0 );
						end
					elseif sOption == "hello" then
						if not pOffer:CheckPriority( CPlayerAnimation.PRIORITY_OFFERS ) or not self:CheckPriority( CPlayerAnimation.PRIORITY_OFFERS ) then
							self:Hint( "Ошибка", "Эта функция не доступна в данный момент", "error" );
							pOffer:Hint( "Ошибка", "Эта функция не доступна в данный момент", "error" );
							
							return;
						end
						
						pOffer:SetRotationAt( self:GetPosition() );
						self:SetRotationAt( pOffer:GetPosition() );
						
						pOffer:SetPosition( self:GetPosition():Offset( .9, self:GetRotation() ) );
						
						self:SetAnimation( CPlayerAnimation.PRIORITY_OFFERS, "GANGS", "hndshkfa_swt", 4000, false, false, false, false );
						pOffer:SetAnimation( CPlayerAnimation.PRIORITY_OFFERS, "GANGS", "hndshkfa_swt", 4000, false, false, false, false );
					end
				else
					local sOfferTitle = NULL;
					
					if sOption == "kiss" then
						sOfferTitle		= "поцеловаться";
					elseif sOption == "propose" then
						sOfferTitle		= "пожениться";
					elseif sOption == "divorce" then
						sOfferTitle		= "развестись";
					elseif sOption == "hello" then
						sOfferTitle		= "поздороваться";
					else
						return false;
					end
					
					pOffer:Hint( "Ошибка", self:GetName() + " " + self:Gender( "отказался", "отказалась", "отказывается" ) + " от " + sOfferTitle + " с Вами", "error" );
					self:Hint( "Ошибка", "Вы отказались от " + sOfferTitle + " с " + pOffer:GetName(), "error" );
				end
			else
				self:Hint( "Ошибка", TEXT_PLAYER_NOT_FOUND, "error" );
			end
			
			self.m_Offers[ sOfferID ] = NULL;
		end
	end
end

function CClientRPC:Faction__Register( iFactionID )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED; 
	end
	
	local pFaction = pChar:GetFaction();
	
	if not pFaction or classof( pFaction ) ~= CFactionGov then
		return TEXT_ACCESS_DENIED;
	end
	
	local pFaction = g_pGame:GetFactionManager():Get( iFactionID );
	
	if not pFaction then
		return TEXT_FACTIONS_INVALID_ID;
	end
	
	local pProperty = g_pGame:GetInteriorManager():Get( pFaction.m_iPropertyID );
	
	if not pProperty then
		return "Не верный адрес регистрации (не существует)";
	end
	
	if pProperty.m_sType ~= INTERIOR_TYPE_COMMERCIAL then
		return "Только коммерческую недвижимость можно оформить на предприятие";
	end
	
	local pResult = g_pDB:Query( "SELECT character_id FROM " + DBPREFIX + "interiors WHERE id = " + pProperty:GetID() + " LIMIT 1" );
	
	if not pResult then
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR;
	end
	
	local pRow = pResult:FetchRow();
	
	delete ( pResult );
	
	if not pRow or not pRow.character_id or pProperty.m_iCharacterID ~= pRow.character_id then
		return "Эта недвижимость не принадлежит владельцу организации";
	end
	
	if pProperty.m_iFactionID ~= 0 then
		return "Недвижимость предлагаемая для регистрации уже оформлена на другую организацию";
	end
	
	pProperty:SetFaction( pFaction );
	
	g_pGame:GetFactionManager():Register( pFaction );
	
	return true;
end

function CClientRPC:CompleteTutorial( iType )
	self:CompleteTutorial( iType );
end

function CClientRPC:FactionTaxi__Update( fDistance )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	local pFaction = pChar:GetFaction();
	
	if not pFaction or classname( pFaction ) ~= "CFactionTaxi" then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	local pVehicle = self:GetVehicleSeat() == 0 and self:GetVehicle();
	
	if pVehicle and pVehicle:GetFaction() == pFaction then
		for i, p in pairs( pVehicle:GetOccupants() ) do
			if p:IsInGame() then
				p:Client().TJobTaxi_SetMeter( fDistance, pVehicle );
			end
		end
	end
end

function CClientRPC:FactionTaxi__ToggleTaxiLight()
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	local pFaction = pChar:GetFaction();
	
	if not pFaction or classname( pFaction ) ~= "CFactionTaxi" then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	local pVehicle = self:GetVehicleSeat() == 0 and self:GetVehicle();
	
	if pVehicle and pVehicle:GetFaction() == pFaction and pChar:GetFaction() == pFaction then
		pVehicle:SetTaxiLightOn( not pVehicle:IsTaxiLightOn() );
		
		local vDistance = not pVehicle:IsTaxiLightOn() and 0;
		
		for i, pPlr in pairs( pVehicle:GetOccupants() ) do
			if pPlr:IsInGame() then
				pPlr:Client().TJobTaxi_SetMeter( vDistance, pVehicle );
			end
		end
	end
end

function CClientRPC:Radio__SelectChannel( iChannel )
	local pVehicle = self:GetVehicleSeat() <= 1 and self:GetVehicle();
	
	if pVehicle then
		if VEHICLE_RADIO[ iChannel ] and pVehicle:GetType() == "Automobile" then
			pVehicle.m_pData.m_iRadioID 	= iChannel;
			
			pVehicle.m_pRadio.m_sPath 		= VEHICLE_RADIO[ iChannel ][ 2 ];
			
			CClientRPC.Radio__SetVolume( self, 0.5 );
			
			pVehicle.m_pRadio:Play();
		else
			pVehicle.m_pData.m_iRadioID		= 0;
			
			pVehicle.m_pRadio:Stop();
		end
		
		return true;
	end
	
	return false;
end

function CClientRPC:Radio__SetVolume( fVolume )
	fVolume = Clamp( 0.0, (float)(fVolume), 1.0 );
	
	local pVehicle 	= self:GetVehicle();
	
	if pVehicle then
		pVehicle.m_pData.m_fRadioVolume		= fVolume;
		
		pVehicle.m_pRadio.m_fVolume 		= fVolume;
		pVehicle.m_pRadio.m_fMaxDistance 	= fVolume * 100.0;
		
		return true;
	end
	
	return false;
end
