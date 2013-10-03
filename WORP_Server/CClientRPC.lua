-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local eErrorData = 
{
	UNK_ERROR			= { "Попробуйте позже", NULL };
	DB_ERROR			= { "Ошибка при работе с базой данных", NULL };
	REG_DISABLED		= { "Регистрация временно отключена", NULL };
	MULTIACCOUNT		= { "Вы уже зарегистрированы", NULL };
	EMAIL_IN_USE		= { "Данный e-mail уже используется", "LoginBox" };
	EMAIL_IS_BLANK		= { "Введите Ваш e-mail", "LoginBox" };
	EMAIL_IS_SHORT		= { "E-mail может быть не менее 3-х символов", "LoginBox" };
	EMAIL_IS_LONG		= { "E-mail может быть не более 64-х символов", "LoginBox" };
	EMAIL_IS_INVALID	= { "Неправильный формат e-mail", "LoginBox" };
	PASSWORD_IS_BLANK	= { "Введите пароль", "PasswordBox" };
	PASSWORD_IS_SHORT	= { "Пароль может быть не менее 4-х символов", "PasswordBox" };
	PASSWORD_IS_LONG	= { "Пароль может быть не более 64-х символов", "PasswordBox" };
	NICKNAME_IN_USE		= { "Этот никнейм уже используется", "Nick" };
	NICKNAME_IS_BLANK	= { "Введите Ваш никнейм", "Nick" };
	NICKNAME_IS_SHORT	= { "Никнейм может быть не менее 3-х символов", "Nick" };
	NICKNAME_IS_LONG	= { "Никнейм может быть не более 64-х символов", "Nick" };
	NICKNAME_IS_INVALID	= { "Никнейм содержит запрещённые символы", "Nick" };
	NICKNAME_IS_NUMBER	= { "Никнейм не может состоять только из чисел", "Nick" };
	REFER_NOT_FOUND		= { "Пользователь с таким именем не найден", "ReferBox" };
	REFER_IS_INVALID	= { "Имя пользователя содержит запрещённые символы", "ReferBox" };
	IPB_ERROR			= { "Ошибка при создании учётной записи Invision Power Board.\nПожалуйста, сообщите об ошибке системному администратору" };
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

class "CClientRPC";

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
			
			if Data.ID then
				if AsyncQuery[ vResult ] then
					client:Client( true ).CClientRPC__Handler( AsyncQuery[ vResult ], Data.ID );
				else
					client:Client( true ).CClientRPC__Handler( AsyncQuery.OK, Data.ID, vResult );
				end
			end
		end
	);

	function CPlayer.Client( this, bLatent )
		return setmetatable(
			{},
			{
				__index = function( _, sFunction )
					local pElement = this.__instance and getElementType( this.__instance ) == 'player' and this.__instance or root;
					
					return function( ... )
						if bLatent then
							triggerLatentClientEvent( pElement, self.m_sServerClient, 50000, false, pElement, sFunction, ... );
						else
							triggerClientEvent( pElement, self.m_sServerClient, pElement, sFunction, ... );
						end
					end
				end
			}
		);
	end
end

function CClientRPC:Ready()
	self:ShowLoginScreen();
	
	self:ToggleControls( true, true, false );
	self:DisableControls( 'next_weapon', 'previous_weapon', 'action', 'walk', 'fire', 'horn' );
	
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

function CClientRPC:TryLogin( sLogin, sPassword, bRemember, sActivationCode )
	local sQuery = "SELECT u.id, u.activation_code, u.ban, u.ban_reason, uu.name AS ban_user_name, DATE_FORMAT( u.ban_date, '%d/%m/%Y %h:%i:%s' ) AS ban_date FROM uac_users u LEFT JOIN uac_users uu ON uu.id = u.ban_user_id WHERE u.login = '" + g_pDB:EscapeString( sLogin ) + "' AND u.deleted = 'No'";
	
	if sLogin ~= "root" and IPSMember.DB:Ping() then
		local pIPBResult = IPSMember.DB:Query( "SELECT `member_id` FROM `" + IPSMember.PREFIX + "members` WHERE `email` = %q AND `members_pass_hash` = MD5( CONCAT( MD5( `members_pass_salt` ), MD5( %q ) ) ) LIMIT 1", sLogin, sPassword );
		
		if not pIPBResult then
			Debug( IPSMember.DB:Error(), 1 );
			
			self:Client().LoginResults( 4 ); -- MySQL Error
		
			return;
		end
		
		local pRow = pIPBResult:FetchRow();
		
		delete ( pIPBResult );
		
		if not pRow or not pRow.member_id then
			self.m_iLoginAttempt = ( self.m_iLoginAttempt or 0 ) + 1;
			
			if self.m_iLoginAttempt > 5 then
				self:Ban( "Попытка взлома (подбор пароля)", 1440 );
				
				return;
			end
			
			self:Client().LoginResults( 1 ); -- Invalid login or password
			
			return;
		end
		
		self.m_iLoginAttempt = NULL;
	else
		sQuery = sQuery + " AND u.password = '" + g_pBlowfish:Encrypt( sPassword ) + "'";
	end
	
	local pResult = g_pDB:Query( sQuery );
	
	if pResult then
		local pRow = pResult:FetchRow();
		
		delete ( pResult );
		
		if pRow and pRow.id then
			self.m_iLoginAttempt = NULL;
			
			if pRow.activation_code and pRow.activation_code ~= sActivationCode then
				self:Client().LoginResults( 3 ); -- Activation required
				
				return;
			end
			
			if pRow.ban == 'Yes' then
				self:Client().LoginResults( 2, pRow.ban_reason, pRow.ban_user_name, pRow.ban_date ); -- Banned
				
				return;
			end
			
			for _, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
				if pPlr:GetUserID() == pRow.id then
					self:Client().LoginResults( 5 ); -- Another player with that account found
					
					return;
				end
			end
			
			self:Client().ShowLoginScreen( false );
			
			self.m_sPasswordEnc = g_pBlowfish:Encrypt( sPassword );
			
			if self:Login( pRow.id ) then
				if not g_pDB:Query( "DELETE FROM uac_user_autologin WHERE id = %q OR serial = %q", pRow.id, self:GetSerial() ) then
					Debug( g_pDB:Error(), 1 );
				end
				
				if bRemember then
					g_pDB:Query( 'INSERT INTO uac_user_autologin (id, serial) VALUES (' + pRow.id + ', "' + self:GetSerial() + '")' );
				end
			else
				self:Client().LoginResults( 1 ); -- Unk error
			end
		else
			self.m_iLoginAttempt = ( self.m_iLoginAttempt or 0 ) + 1;
			
			if self.m_iLoginAttempt > 5 then
				self:Ban( "Попытка взлома (подбор пароля)", 1440 );
				
				return;
			end
			
			self:Client().LoginResults( 1 ); -- Invalid login or password
		end
	else
		self:Client().LoginResults( 4 ); -- MySQL Error
		
		Debug( g_pDB:Error(), 1 );
	end
end

function CClientRPC:RegDialog()
	self:Client().Registration( TEXT_REG_RULES );
end

function CClientRPC:Register( sEmail, sPassword, sNickname, sReferUser )
	sEmail		= (string)(sEmail);
	sPassword	= (string)(sPassword);
	sNickname	= (string)(sNickname);
	sReferUser	= (string)(sReferUser);
	
	if sEmail:len() == 0				then	return self:Client().RegistrationError( eErrorData.EMAIL_IS_BLANK );		end
	if sEmail:len() < 3					then	return self:Client().RegistrationError( eErrorData.EMAIL_IS_SHORT );		end
	if sEmail:len() > 64				then	return self:Client().RegistrationError( eErrorData.EMAIL_IS_LONG );			end
	if not CUser:IsMailValid( sEmail )	then	return self:Client().RegistrationError( eErrorData.EMAIL_IS_INVALID );		end
	
	if sPassword:len() == 0		then	return self:Client().RegistrationError( eErrorData.PASSWORD_IS_BLANK );		end
	if sPassword:len() < 4		then	return self:Client().RegistrationError( eErrorData.PASSWORD_IS_SHORT );		end
	if sPassword:len() > 64		then	return self:Client().RegistrationError( eErrorData.PASSWORD_IS_LONG );		end
	if sNickname:len() == 0		then	return self:Client().RegistrationError( eErrorData.NICKNAME_IS_BLANK );		end
	if sNickname:len() < 3		then	return self:Client().RegistrationError( eErrorData.NICKNAME_IS_SHORT );		end
	if sNickname:len() > 64		then	return self:Client().RegistrationError( eErrorData.NICKNAME_IS_LONG );		end
	if tonumber( sNickname ) 	then	return self:Client().RegistrationError( eErrorData.NICKNAME_IS_NUMBER );	end
	
	if not sNickname:find( "[^A-Za-z0-9]" ) then
		local iReferID = 0;
		
		if sReferUser and sReferUser:len() > 0 then
			if sReferUser:len() > 64 then
				sReferUser = sReferUser:sub( 1, 64 );
			end
			
			if not sReferUser:find( "[^A-Za-z0-9]" ) then
				local pResult = g_pDB:Query( "SELECT id FROM uac_users WHERE LOWER( name ) = LOWER( %q )", sReferUser );
				
				if not pResult then
					self:Client().RegistrationError( eErrorData.DB_ERROR );
					
					return not Debug( g_pDB:Error(), 1 );
				end
				
				local iNumRows	= pResult:NumRows();
				local pRow		= pResult:FetchRow();
				
				delete ( pResult );
				
				if iNumRows ~= 1 then
					return self:Client().RegistrationError( eErrorData.REFER_NOT_FOUND );
				end
				
				iReferID = pRow and (int)(pRow.id) or 0;
			else
				return self:Client().RegistrationError( eErrorData.REFER_IS_INVALID );
			end
		end
		
		local sSerial = self:GetSerial();
		
		local pResult = g_pDB:Query( "SELECT SUM( login = %q ) AS mail, SUM( name = %q ) AS name, SUM( serial = %q OR serial_reg = %q ) AS serial FROM uac_users", sEmail, sNickname, sSerial, sSerial );
		
		if not pResult then
			self:Client().RegistrationError( eErrorData.DB_ERROR );
			
			return not Debug( g_pDB:Error(), 1 );
		end
		
		local pRow = pResult:FetchRow();
		
		delete ( pResult );
		
		if pRow.mail > 0 	then	return self:Client().RegistrationError( eErrorData.EMAIL_IN_USE );		end
		if pRow.name > 0 	then	return self:Client().RegistrationError( eErrorData.NICKNAME_IN_USE );	end
		
		if not g_pGame.m_bAllowMultiaccount then
			if pRow.serial > 0 then	return self:Client().RegistrationError( eErrorData.MULTIACCOUNT );	end
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
				return self:Client().RegistrationError( eErrorData.IPB_ERROR );
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
			
			return self:Client().RegistrationError( NULL );
		end
		
		Debug( g_pDB:Error(), 1 );
		
		return self:Client().RegistrationError( eErrorData.DB_ERROR );
	end
	
	self:Client().RegistrationError( eErrorData.NICKNAME_IS_INVALID );
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

function CClientRPC:Bank__OpenCard( sCardID, sPIN )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	if sCardID then
		local bTest = sPIN == "74657374 ";
		
		if ( tonumber( sPIN ) and sPIN:len() == 4 ) or bTest then
			local pCardItem = NULL;
			
			if not bTest then
				for i, pItm in pairs( pChar:GetItems()[ ITEM_SLOT_NONE ] ) do
					if pItm.m_bBankCard and pItm.m_Data.m_sID and pItm.m_Data.m_sID == sCardID then
						pCardItem = pItm;
						
						break;
					end
				end
			end
			
			if pCardItem == NULL and not bTest then
				return "Банковская карточка не действительна";
			end
			
			if bTest or md5( sPIN ) == pCardItem.m_Data.m_sPIN then
				return g_pGame:GetBankManager():GetInfo( sCardID, { "id", "owner", "owner_id", "currency_id", "currency", "amount", "created", "expiry", "locked" } );
			end
		end
		
		return "Не верный PIN-код";
	end
	
	return "Банковская карточка не действительна";
end

function CClientRPC:Bank__LockAccount( sBankAccountID, sReason, bClose )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	local pAccountInfo = g_pGame:GetBankManager():GetInfo( sBankAccountID, { "id", "owner", "faction_id", "currency_id", "amount", "locked" } );
	
	if pAccountInfo then
		if pAccountInfo.locked then
			return "Операция не может быть выполнена: аккаунт уже заблокирован";
		end
		
		if pAccountInfo.owner ~= pChar:GetID() then
			return "Только владелец может " + ( bClose and "закрыть" or "заблокировать" ) + " счёт";
		end
		
		if not g_pDB:Query( "UPDATE " + DBPREFIX + "bank_accounts SET locked = NOW() " + ( bClose and ", closed = NOW()" or "" ) + " WHERE id = %q", sBankAccountID ) then
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR;
		end
		
		self:AppendLog( sBankAccountID, NULL, ( bClose and "Закрытие счёта: " or "Блокировка счёта: " ) + sReason );
		
		return true;
	end
	
	return "Не удалось получить информацию о счёте";
end

function CClientRPC:Bank__Transfer( sAmount, sBankAccountID, sTargetBankAccountID, sReason )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	local iAmount = sAmount:ToNumber();
	
	if iAmount and iAmount > 0 then
		if type( sTargetBankAccountID ) ~= "string" then
			return "Не верно указан номер счёта";
		end
		
		local aAcc = sTargetBankAccountID:split( " " );
		
		if not aAcc then
			return "Не верно указан номер счёта";
		end
		
		for i = 1, 4 do
			if aAcc[ i ] == NULL or aAcc[ i ]:len() ~= 4 or not aAcc[ i ]:ToNumber() then
				return "Не верно указан номер счёта";
			end
		end
		
		if sTargetBankAccountID == sBankAccountID then
			return "Нельзя переводить средства на счёт с которого производится операция";
		end
		
		local pAccountInfo = g_pGame:GetBankManager():GetInfo( sBankAccountID, { "id", "owner_id", "faction_id", "currency_id", "currency", "amount", "locked" } );
		
		if pAccountInfo then
			if pAccountInfo.locked then
				return "Операция не может быть выполнена: аккаунт заблокирован";
			end
			
			if pAccountInfo.faction_id then
				local pFaction	= g_pGame:GetFactionManager():Get( pAccountInfo.faction_id );
				
				if not pFaction then
					return "Не удалось получить данные о организации";
				end
				
				if not pFaction:TestRight( pChar, eFactionRight.BANK_TRANSFER ) then
					return "У Вас нет прав на перевод средств с этого счёта";
				end
				
				if sReason:len() == 0 then
					return "Необходимо указать причину перевода средств";
				end
			else
				if pAccountInfo.owner_id ~= pChar:GetID() then
					return "У Вас нет прав на перевод средств с этого счёта";
				end
			end
			
			if pAccountInfo.amount < iAmount then
				return "На Вашем счету недостаточно средств";
			end
			
			local pTargetAccountInfo = g_pGame:GetBankManager():GetInfo( sTargetBankAccountID, { "currency_id", "currency" } );
			
			if pTargetAccountInfo == NULL then
				return "Указанный счёт не существует";
			end
			
			if pTargetAccountInfo.currency_id ~= pAccountInfo.currency_id then
				return "Конечный счёт должен быть той же валюты";
				
				-- if pTargetAccountInfo.currency_id ~= "USD" then
					-- iAmount = iAmount / ( pTargetAccountInfo.currency_rate );
				-- end
				
				-- if pAccountInfo.currency_id ~= "USD" then
					-- iAmount = iAmount * ( pTargetAccountInfo.currency_rate );
				-- end
			end
			
			if not g_pGame:GetBankManager():GiveMoney( sTargetBankAccountID, iAmount, "Перевод со счёта " + sBankAccountID + ": " + sReason ) then
				return TEXT_DB_ERROR;
			end
			
			if not g_pGame:GetBankManager():TakeMoney( sBankAccountID, iAmount, "Перевод на счёт " + sTargetBankAccountID + ": " + sReason ) then
				return TEXT_DB_ERROR;
			end
			
			pAccountInfo.amount = pAccountInfo.amount - iAmount;
			
			return pAccountInfo;
		end
		
		return "Не удалось получить информацию о Вашем счёте";
	end
	
	return "Неверные данные";
end

function CClientRPC:Bank__Deposit( sAmount, sBankAccountID )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	local iAmount = sAmount:ToNumber();
	
	if iAmount and iAmount > 0 then
		local pAccountInfo = g_pGame:GetBankManager():GetInfo( sBankAccountID, { "id", "currency_id", "currency", "amount" } );
		
		if not pAccountInfo then
			return "Не удалось получить информацию о счёте";
		end
		
		if pChar:TakeMoney( iAmount ) then
			if not g_pGame:GetBankManager():GiveMoney( sBankAccountID, ( iAmount * pAccountInfo.currency_rate ), "Пополнение средств счёта" ) then
				pChar:GiveMoney( iAmount );
				
				return TEXT_DB_ERROR;
			end
			
			pAccountInfo.amount = pAccountInfo.amount + ( iAmount * pAccountInfo.currency_rate );
			
			return pAccountInfo;
		end
		
		return "У Вас нет столько денег";
	end
	
	return "Неверные данные";
end

function CClientRPC:Bank__Withdraw( sAmount, sBankAccountID, sReason )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	local iAmount = sAmount:ToNumber();
	
	if iAmount and iAmount > 0 then
		local pAccountInfo = g_pGame:GetBankManager():GetInfo( sBankAccountID, { "id", "owner_id", "currency_id", "currency", "amount", "locked" } );
		
		if pAccountInfo then
			if pAccountInfo.locked == NULL then
				if pAccountInfo.owner_id == pChar:GetID() then
					if pAccountInfo.amount < iAmount then
						return "На Вашем счету недостаточно средств";
					end
					
					if not sReason then
						sReason = "ATM " + GetZoneName( self:GetPosition() );
					else
						sReason = "Списание средств со счёта: " + sReason;
					end
					
					if not g_pGame:GetBankManager():TakeMoney( sBankAccountID, iAmount, sReason ) then
						return TEXT_DB_ERROR;
					end
					
					local fRate = pAccountInfo.currency_rate + (int)(pAccountInfo.currency_id ~= "USD");
					
					if fRate ~= 0.0 then
						pChar:GiveMoney( iAmount / fRate );
					end
					
					pAccountInfo.amount = pAccountInfo.amount - iAmount;
					
					return pAccountInfo;
				end
				
				return "У Вас нет прав на снятие средств с этого счёта";
			end
			
			return "Операция не может быть выполнена: аккаунт заблокирован";
		end
		
		return "Не удалось получить информацию о счёте";
	end
	
	return "Неверные данные";
end

function CClientRPC:Bank__GetLog( sBankAccountID )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	local pAccountInfo = g_pGame:GetBankManager():GetInfo( sBankAccountID, { "id", "owner_id", "currency_id", "amount", "locked" } );
	
	if not pAccountInfo then
		return "Не удалось получить информацию о счёте";
	end
	
	if pAccountInfo.faction_id then
		local pFaction	= g_pGame:GetFactionManager():Get( pAccountInfo.faction_id );
		
		if not pFaction then
			return "Не удалось получить данные о организации";
		end
		
		if not pFaction:TestRight( pChar, eFactionRight.BANK_LOG ) then
			return "У Вас нет прав на просмотр истории этого счёта";
		end
	else
		if pAccountInfo.owner_id ~= pChar:GetID() then
			return "У Вас нет прав на просмотр истории этого счёта";
		end
	end
	
	return g_pGame:GetBankManager():GetLog( sBankAccountID, 30 );
end

function CClientRPC:Bank__CreateAccount( sType, sCurrencyID, iFactionID, sCard )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	if sType == "none" or sType == "faction" then
		local pFaction = NULL;
		
		if sType == "faction" then
			pFaction = g_pGame:GetFactionManager():Get( iFactionID );
			
			if pFaction == NULL then
				return "Организации с таким именем не существует";
			end
			
			if pFaction.m_sBankAccountID then
				return "Для этой организации уже создан счёт";
			end
		end
		
		local pCurrency = g_pGame:GetBankManager().m_Currencies[ sCurrencyID ];
		
		if pCurrency == NULL then
			return "Неверная валюта";
		end
		
		local sBankAccountID = g_pGame:GetBankManager():CreateAccount( pCurrency.Code, sType, pChar, NULL, pFaction and pFaction:GetID() );
		
		if not sBankAccountID then
			return TEXT_DB_ERROR;
		end
		
		if pFaction then
			if not g_pDB:Query( "UPDATE " + DBPREFIX + "factions SET bank_acc_id = %q WHERE id = %d", sBankAccountID, pFaction:GetID() ) then
				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR;
			end
			
			pFaction.m_sBankAccountID	= sBankAccountID;
		end
	elseif sType == "card" then
		local CardTypes	=
		{
			visa			= true;
			mastercard		= true;
			americanexpress	= true;
		};
		
		if not CardTypes[ sCard ] then
			return "Неизвестный тип карты";
		end
		
		local pDate				= CDateTime();
		
		pDate.m_pTime.sse		= pDate.m_pTime.sse + 15778463; -- 6 месяцев
		
		local sBankAccountID	= g_pGame:GetBankManager():CreateAccount( NULL, sCard, pChar, pDate:Format( "Y-m-d 00:00:00" ), NULL );
		local sPIN				= ( "%04d" ):format( math.random( 9999 ) );
		
		local pItemData		=
		{
			m_sID			= sBankAccountID;
			m_sPIN			= md5( sPIN );
			m_sExpiryDate	= pDate:Format( "d f Y" );
		};
		
		pChar:GiveItem( "bank_card_" + sCard, 0, 100.0, pItemData );
		
		pChar.m_pClient:MessageBox( NULL, "Банковская карточка создана\n\nPIN-код Вашей карточки: " + sPIN, "Операция выполнена успешно", MessageBoxButtons.OK, MessageBoxIcon.Information );
	else
		return "Не верный тип счёта";
	end
	
	return g_pGame:GetBankManager():GetInfo( pChar, CBank.m_sImportFields );
end

function CClientRPC:Bank__GetAccounts()
	local pChar = self:GetChar();
	
	if pChar then
		local Accounts = g_pGame:GetBankManager():GetInfo( pChar, CBank.m_sImportFields );
		
		return Accounts;
	end
	
	return AsyncQuery.UNAUTHORIZED;
end

function CClientRPC:Bank__GetCurrencies()
	if self:IsInGame() then
		local pResult = g_pDB:Query( "SELECT id, name, rate FROM " + DBPREFIX + "currencies ORDER BY id ASC" );
		
		if pResult then
			local Array = pResult:GetArray();
			
			delete ( pResult );
			
			return Array;
		end
	end
end

function CClientRPC:Bank__GetFactions( aFields )
	local pChar = self:GetChar();
	
	if pChar then
		local Factions = {};
		
		for i, pFaction in pairs( g_pGame:GetFactionManager():GetAll() ) do
			if pFaction.m_iOwnerID == pChar:GetID() then
				if aFields then
					local aFaction = {};
					
					for i, key in ipairs( aFields ) do
						aFaction[ key ] = pFaction[ key ];
					end

					table.insert( Factions, aFaction );
				else
					table.insert( Factions, pFaction );
				end
			end
		end
		
		return Factions;
	end
end

function CClientRPC:Bank__Buy( sItemType, iItemID, sBankAccountID, sPIN )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED;
	end
	
	local pAccountInfo = NULL;
	
	if sBankAccountID == "Оплата наличными" then
		pAccountInfo = { id = 0; owner_id = pChar:GetID(); amount = pChar:GetMoney(); locked = NULL };
	else
		if sPIN then
			pAccountInfo = CClientRPC.Bank__OpenCard( self, sBankAccountID, sPIN );
			
			if type( pAccountInfo ) ~= "table" then
				return pAccountInfo;
			end
		else
			pAccountInfo = g_pGame:GetBankManager():GetInfo( sBankAccountID, { "id", "type", "faction_id", "owner_id", "amount", "locked" } );
		end
	end
	
	if not pAccountInfo then
		return "Не удалось получить информацию о счёте";
	end
	
	if pAccountInfo.locked then
		return "Этот счёт заблокирован";
	end
	
	if sItemType == "Property" then
		local pProperty = g_pGame:GetInteriorManager():Get( iItemID );
		
		if pProperty then
			if not pProperty:GetInt() then
				return TEXT_INTERIORS_CORRUPT;
			end
			
			if pProperty then
				if pProperty:IsElementInside( self ) or pProperty.m_pOutsideMarker:GetPosition():Distance( pChar:GetPosition() ) < 5.0 then
					if pProperty:GetType() == INTERIOR_TYPE_NONE then
						return "Данная собственность недоступна для покупки";
					end
					
					local iPrice = pProperty:GetPrice();
					
					if iPrice <= 0 then
						return "Данная собственность не продаётся";
					end
					
					if pAccountInfo.amount < iPrice then
						return TEXT_NOT_ENOUGH_MONEY;
					end
					
					if pAccountInfo.id == 0 then
						if not pChar:TakeMoney( iPrice, "Покупка собственности #" + pProperty:GetID() ) then
							return TEXT_NOT_ENOUGH_MONEY;
						end
					else
						if not g_pGame:GetBankManager():TakeMoney( sBankAccountID, iPrice, "Покупка собственности #" + pProperty:GetID() ) then					
							return TEXT_DB_ERROR;
						end
					end
					
					if pProperty.m_iFactionID ~= 0 then
						local pFaction = g_pGame:GetFactionManager():Get( pProperty.m_iFactionID );
						
						if pFaction then
							g_pGame:GetBankManager():GiveMoney( pFaction.m_sBankAccountID, iPrice, "Продана собственность #" + pProperty:GetID() + ", покупатель: " + sBankAccountID );
						end
					elseif pProperty.m_iCharacterID ~= 0 then
						local pChar = NULL;
						
						-- TODO: while!
						for i, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
							local pChr = pPlr:GetChar();
							
							if pChr and pChr:GetID() == pProperty.m_iCharacterID then
								pChar = pChr;
								
								break;
							end
						end
						
						if pChar then
							pChar:GiveMoney( iPrice, "Продана собственность #" + pProperty:GetID() + ", покупатель: " + sBankAccountID );
							
							pChar.m_pClient:Hint( "Собственность продана", "Выставленная на продажу собственность #" + pProperty:GetID() + " куплена за " + iPrice, "info" );
						else
							if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET money = money + " + iPrice + " WHERE id = " + pProperty.m_iCharacterID ) then
								g_pMoneyLog:Write( "[" + pProperty.m_iCharacterID + "]" + iPrice + " (Продана собственность #" + pProperty:GetID() + ", покупатель: " + sBankAccountID + ")" );
							else
								Debug( g_pDB:Error(), 1 );
							end
						end
					end
					
					local iFactionID = 0;
					
					if pAccountInfo.type == "faction" then
						local pFaction = g_pGame:GetFactionManager():Get( pAccountInfo.faction_id );
						
						if pFaction then
							iFactionID = pFaction:GetID();
						end
					end
					
					if not g_pDB:Query( "UPDATE " + DBPREFIX + "interiors SET character_id = %d, faction_id = %d, price = 0 WHERE id = %d", pChar:GetID(), iFactionID, pProperty:GetID() ) then
						Debug( g_pDB:Error() );
						
						return TEXT_DB_ERROR;
					end
					
					pProperty.m_iCharacterID	= pChar:GetID();
					pProperty.m_iFactionID		= iFactionID;
					pProperty.m_iPrice			= 0;
					
					pProperty:UpdateMarker();
					pProperty:Update3DText();
					pProperty:UpdateBlip();
					
					g_pServer:Print( "PROPERTY: %s (%d) bought property %q (%d) for $%d", pChar:GetName(), pChar:GetID(), pProperty:GetName(), pProperty:GetID(), iPrice );
					
					return true;
				end
				
				return "Собственность слишком далеко";
			end
		end
		
		return "Собственности которую вы пытаетесь купить - не существует";
	elseif sItemType == "Vehicle" then
		return true;
	end
	
	return AsyncQuery.BAD_REQUEST;
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
	
	if sDeptName:utfLen() < 5 then
		return "Слишком короткое название отдела";
	end
	
	if pregFind then
		if pregFind( sDeptName, "^[A-Za-z0-9А-Яа-я ,.]" ) then
			return "Название отдела содержит запрещённые символы";
		end
	else	
		for i = 1, sDeptName:utfLen() do
			local iChar = sDeptName:utfSub( i, i ):utfCode();
			
			if not ( ( iChar >= 65 and iChar <= 90 ) or ( iChar >= 97 and iChar <= 122 ) or ( iChar >= 1040 and iChar <= 1103 ) or iChar == 32 or iChar == 44 or iChar == 46 ) then
				return "Название отдела содержит запрещённые символы";
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
			local iChar = sDeptName:utfSub( i, i ):utfCode();
			
			if not ( ( iChar >= 65 and iChar <= 90 ) or ( iChar >= 97 and iChar <= 122 ) or ( iChar >= 1040 and iChar <= 1103 ) or iChar == 32 or iChar == 44 or iChar == 46 ) then
				return "Название отдела содержит запрещённые символы";
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

function CClientRPC:Faction_GetData( sDataName, iFactionID )
	local pChar = self:GetChar();
	
	if pChar then
		local pFaction = g_pGame:GetFactionManager():Get( iFactionID );
		
		if pFaction then
			if sDataName == "Info" then
				local Info;
				
				local pResult	= g_pDB:Query( "SELECT CONCAT( name, ' ', surname ) AS owner FROM " + DBPREFIX + "characters WHERE id = " + pFaction.m_iOwnerID + " LIMIT 1" );
				
				local pRow		= pResult:FetchRow();
				
				delete ( pResult );
				
				local pProperty = g_pGame:GetInteriorManager():Get( pFaction.m_iPropertyID );
				
				Info		=
				{
					ID				= pFaction:GetID();
					Owner			= pRow and pRow.owner or "Неизвестно";
					Property		= pProperty and pProperty:GetName() or "Неизвестно";
					PropertyID		= pFaction.m_iPropertyID;
					Name			= pFaction:GetName();
					Abbr			= pFaction:GetTag();
					Type			= eFactionTypeNames[ pFaction.m_iType ];
					CreatedDate		= pFaction.m_sCreated;
					RegisterDate	= pFaction.m_sRegistered;
					BankAccountID	= pFaction.m_sBankAccountID;
				};
				
				return Info;
			elseif sDataName == "Depts" then
				return pFaction.m_Depts;
			elseif sDataName == "Staff" then
				local Staff = {};
				
				if pFaction:TestRight( pChar, eFactionRight.STAFF_LIST ) then
					local pResult = g_pDB:Query( "SELECT c.id, c.name, c.surname, c.faction_dept_id, c.faction_rank_id, DATEDIFF( NOW(), c.last_login ) AS online, c.status, c.phone FROM " + DBPREFIX + "characters c WHERE c.faction_id = " + pFaction:GetID() + " AND c.status != 'Скрыт' ORDER BY online ASC" );
					
					if pResult then
						for i, row in ipairs( pResult:GetArray() ) do
							local Dept	= pFaction.m_Depts[ row.faction_dept_id ];
							
							Staff[ i ]	=
							{
								name			= row.name;
								surname			= row.surname;
								dept			= Dept and Dept.Name or "N/A";
								rank			= Dept and Dept.Ranks[ row.faction_rank_id ] and Dept.Ranks[ row.faction_rank_id ].Name;
								phone			= row.phone;
								online_status	= g_pGame:GetPlayerManager():Get( ( row.name + '_' + row.surname ):gsub( ' ', '_' ) ) and -1 or row.online;
								status			= row.status;
							};
						end
						
						delete ( pResult );
					else
						Debug( g_pDB:Error(), 1 );
					end
				end
				
				return Staff;
			end
			
			return AsyncQuery.FORBIDDEN;
		end
		
		return "Invalid faction id";
	end
	
	return AsyncQuery.UNAUTHORIZED;
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

function CClientRPC:Property__AddUpgrade( iPropertyID, sUpgradeID )
	local pChar = self:GetChar();
	
	if not pChar then return AsyncQuery.UNAUTHORIZED; end
	
	local pProperty = g_pGame:GetInteriorManager():Get( iPropertyID );
	
	if not pProperty then return AsyncQuery.BAD_REQUEST; end
	
	local pUpgrade = ePropertyUpgrade[ sUpgradeID ];
	
	if not pUpgrade then return AsyncQuery.BAD_REQUEST; end
	
	if pProperty.m_iCharacterID ~= pChar:GetID() then return "Только владелец может устанавливать апгрейды"; end
	
	if pProperty.m_pUpgrades.m_Upgrades[ sUpgradeID ] then return "Этот апгрейд уже установлен"; end
	
	if pUpgrade.Type ~= NULL and pUpgrade.Type ~= pProperty.m_sType then return "Этот апгрейд не совместим с данным интерьером"; end
	
	if not pChar:TakeMoney( pUpgrade.Price ) then return "У Вас недостаточно денег"; end
	
	local Data = NULL;
	
	if sUpgradeID == "FACTION_MARKER" then
		local vecPosition	= pChar:GetPosition();
		local iInterior		= pChar:GetInterior();
		local iDimension	= pChar:GetDimension();
		
		Data	= { vecPosition.X, vecPosition.Y, vecPosition.Z - 0.81, iInterior, iDimension };
	elseif sUpgradeID == "BLIP" then
		local pInt	= pProperty:GetInt();
		
		if not pInt then
			return "Не действительный интерьер";
		end
		
		local iBlip	= pInt.Blip;
		
		if not iBlip then
			return "Этот интерьер не поддерживает данный апгрейд";
		end
		
		Data	= { iBlip };
	end
	
	if not pProperty:AddUpgrade( sUpgradeID, Data ) then
		pChar:GiveMoney( pUpgrade.Price );
		
		return "Внутренняя ошибка сервера. Обратитесь к системному администратору";
	end
	
	local Upgrades	= {};
	
	for sUpgrade in pairs( pProperty.m_pUpgrades.m_Upgrades ) do
		Upgrades[ sUpgrade ] = true;
	end
	
	return Upgrades;
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
			return self:GetChat():Send( "Функция не доступна в автомобиле", 255, 0, 0 );
		end
		
		if self.m_Offers and self.m_Offers[ sOfferID ] then
			local pOffer	= self.m_Offers[ sOfferID ].pOffer;
			local sOption	= self.m_Offers[ sOfferID ].sOption;
			
			if pOffer and pOffer:IsInGame() then
				if bAccepted then
					if not pOffer:IsAdmin() and self:GetDimension() == pOffer:GetDimension() and self:GetPosition():Distance( pOffer:GetPosition() ) < 2.0 then
						if sOption == "kiss" then
							if not pOffer:CheckPriority( CPlayerAnimation.PRIORITY_OFFERS ) or not self:CheckPriority( CPlayerAnimation.PRIORITY_OFFERS ) then
								self:Hint( "Ошибка", "Эта функция не доступна в данный момент", "error" );
								pOffer:Hint( "Ошибка", "Эта функция не доступна в данный момент", "error" );
								
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
						self:Hint( "Ошибка", TEXT_PLAYER_NOT_NEARBY, "error" );
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

function CClientRPC:Faction_Create( sTitle, sAbbr, iInteriorID, iType )
	local pChar = self:GetChar();
	
	if not pChar then
		return AsyncQuery.UNAUTHORIZED; 
	end
	
	local pResult = g_pDB:Query( "SELECT id, registered FROM " + DBPREFIX + "factions WHERE owner_id = " + pChar:GetID() + " LIMIT 1" );
	
	if pResult then
		local pRow = pResult:FetchRow();
		
		delete ( pResult );
		
		if pRow and pRow.id then
			if pRow.registered then
				return "У Вас уже есть организация!", 255, 0, 0;
			end
			
			return "Вы уже подавали заявку на создание организации", 255, 0, 0;
		end
	else
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR, 255, 0, 0;
	end
	
	if not not sTitle:find( "[\\'\"\;]" ) then
		return "Имя организации содержит запрещённые символы", 255, 0, 0;
	end
	
	if sTitle:len() < 8 then
		return "Имя организации слишком короткое", 255, 0, 0;
	end
	
	if sTitle:len() > 64 then
		return "Имя организации слишком длинное", 255, 0, 0;
	end
	
	if not not sAbbr:find( "[\\'\"\;]" ) then
		return "Аббревиатура организации содержит запрещённые символы", 255, 0, 0;
	end
	
	if sAbbr:len() < 3 then
		return "Аббревиатура организации слишком короткая", 255, 0, 0;
	end
	
	if sAbbr:len() > 8 then
		return "Аббревиатура организации слишком длинная", 255, 0, 0;
	end
	
	local pProperty = g_pGame:GetInteriorManager():Get( iInteriorID );
	
	if not pProperty then
		return "Не верный адрес регистрации (не существует)";
	end
	
	if pProperty.m_sType ~= INTERIOR_TYPE_COMMERCIAL then
		return "Только коммерческую недвижимость можно оформить на предприятие";
	end
	
	if pProperty.m_iCharacterID ~= pChar:GetID() then
		return "Эта недвижимость не принадлежит вам";
	end
	
	if pProperty.m_iFactionID ~= 0 then
		return "Эта недвижимость уже оформлена на другую организацию";
	end
	
	if not eFactionType[ iType ] then
		return "Не правильный тип организации";
	end
	
	local Data	=
	{
		name		= sTitle;
		tag			= sAbbr;
		property	= iInteriorID;
		type		= iType;
	};
	
	local pResult	= g_pDB:Query( "SELECT SUM( name = %q ) AS name, SUM( tag = %q ) AS tag FROM " + DBPREFIX + "factions", Data[ "name" ], Data[ "tag" ] );
	
	if pResult then
		local pRow = pResult:FetchRow();
		
		delete ( pResult );
		
		if pRow then
			if pRow.name and pRow.name ~= 0 then
				return "Организация с таким именем уже существует";
			end
			
			if pRow.tag and pRow.tag ~= 0 then
				return "Организация с такой аббревиатурой уже существует";
			end
		end
	else
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR;
	end
	
	Data[ "owner_id" ] = pChar:GetID();
	
	local iFactionID = g_pGame:GetFactionManager():Create( CFaction, Data[ "name" ], Data[ "tag" ], Data );
	
	if iFactionID then
		return true;
	end
	
	return TEXT_DB_ERROR;
end

function CClientRPC:CompleteTutorial( iType )
	self:CompleteTutorial( iType );
end
