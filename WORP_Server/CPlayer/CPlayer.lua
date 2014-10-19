-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

DEFAULT_SPAWN_POSITION		= Vector3( 1586, -1827, 0 );
DEFAULT_CAMERA_POSITION		= Vector3( 1586.31, -1827.22, 84.12 );
DEFAULT_CAMERA_TARGET		= Vector3( 1585.96, 0.0, 84.12 );

NEW_CHAR_CAMERA_POSITION	= Vector3( 1714.2, -1670.7, 42.9 );
NEW_CHAR_CAMERA_TARGET		= Vector3( 1628.2, -1719.5, 28.4 );

class: CPlayer ( CPed, CPlayerTutorial, CPlayerAnimation )
{
	m_iAdminID			= 0;
	
	GetNametagText		= getPlayerNametagText;
	GetNametagColor		= getPlayerNametagColor;
	SetNametagShowing	= setPlayerNametagShowing;
	
	SetShader			= function( this, sShader, bEnabled )
		this:Client().SetShader( sShader, bEnabled );
	end;
	
	SetShaderValue		= function( this, sShader, ... )
		this:Client().SetShaderValue( sShader, ... );
	end;
};

function CPlayer:CPlayer( pPlayerManager, this )
	this( self );
	
	this:CPlayerTutorial	( this );
	this:CPlayerAnimation	( this );
	
	this.m_pPlayerManager	= pPlayerManager;
	
	this.m_pCamera 			= CPlayerCamera		( this );
	this.m_pHUD 			= CClientHUD		( this );
	this.m_pChat 			= CPlayerChat		( this );
	this.m_pNametag 		= CPlayerNametag	( this );
	this.m_pBones			= CPlayerBones		( this );
	
	this.m_pCharacter 		= NULL;
	this.m_Binds			= {};
	this.m_aControls 		= {};
	this.m_aControlStates	= {};
	this.m_ReportData		=
	{
		m_tStamp			= 0;
		m_sText				= NULL;
		m_bLocked			= true;
	};
	
	pPlayerManager:AddToList( this );
	
	this:SetData( "player_id", this:GetID(), true, true );
	this:SetData( "CPlayer::m_Controls", this.m_aControls );
	this:SetData( "CPlayer::m_ControlStates", this.m_aControlStates );
	
	if _DEBUG then
		Debug( "Creating player \'" + this:GetName() + "\' (" + this:GetID() + ")" );
	end
end

function CPlayer:_CPlayer()
	triggerEvent( "onColShapeLeave", resourceRoot, self, false );
	
	self:_CPlayerTutorial();
	
	if self:IsInGame() then
		delete ( self.m_pCharacter );
		
		self.m_pCharacter = NULL;
	end
	
	if _DEBUG then
		Debug( "Removed player \"" + self:GetName() + " (" + self:GetID() + ")" );
	end
	
	delete ( self.m_pCamera );
	delete ( self.m_pHUD );
	delete ( self.m_pChat );
	delete ( self.m_pNametag );
	delete ( self.m_pBones );
	
	self.m_pCamera	= NULL;
	self.m_pHUD		= NULL;
	self.m_pChat	= NULL;
	self.m_pNametag	= NULL;
	self.m_pBones	= NULL;
	
	self:RemoveData( "player_id" );
	self:Destroy();
end

function CPlayer:GetName()
	return getPlayerName( self );
end

function CPlayer:GetPing()
	return getPlayerPing( self );
end

function CPlayer:GetTeam()
	return getPlayerTeam( self );
end

function CPlayer:Unlink( sType, sReason, pResponsePlayer )
	if self.m_pCharacter then
		self.m_pCharacter:Logout( sType, sReason, pResponsePlayer );
	end
	
	self.m_bAdmin = false;
	
	self:Save();
	self:InitLoginCamera();
	self.m_pPlayerManager:RemoveFromList( self );
end

function CPlayer:GetID()
	return self.m_iID;
end

function CPlayer:IsLoggedIn()
	return (bool)(self.m_iUserID);
end

function CPlayer:GetUserID()
	return self.m_iUserID;
end

function CPlayer:GetUserName()
	return self.m_sUserName;
end

function CPlayer:GetCamera()
	return self.m_pCamera;
end

function CPlayer:GetHUD()
	return self.m_pHUD;
end

function CPlayer:GetNametag()
	return self.m_pNametag;
end

function CPlayer:GetBones()
	return self.m_pBones;
end

function CPlayer:GetChat()
	return self.m_pChat;
end

function CPlayer:GetOldVehicle()
	return self.m_pOldVehicle;
end

function CPlayer:GetGP()
	return self.m_iGP;
end

function CPlayer:SetGP( iAmount )
	iAmount = math.max( 0, iAmount );
	
	if not g_pDB:Query( "UPDATE uac_users SET goldpoints = %d WHERE id = %d", self:GetID(), iAmount ) then
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
	self.m_iGP = iAmount;
	
	return true;
end

function CPlayer:GiveGP( iAmount )
	return self:SetGP( self:GetGP() + iAmount );
end

function CPlayer:TakeGP( iAmount )
	return self:SetGP( self:GetGP() - iAmount );
end

function CPlayer:DoPulse( tReal )
	if self:IsInGame() then
		self.m_iInGameCount	= self.m_iInGameCount + 1;
		self.m_tPayDay		= ( self.m_tPayDay or 0 ) + 1;
		
		if self:IsMuted() then
			self.m_iMuteSeconds = self.m_iMuteSeconds - 1;
			
			if self.m_iMuteSeconds <= 0 then
				self:SetMuted( false );
				
				self:GetChat():Send( "Время молчанки истекло", 255, 128, 0 );
			end
		end
		
		if self.m_iAntiflood and self.m_iAntiflood > 0 then
			self.m_iAntiflood = self.m_iAntiflood - 1;
		end
		
		local iHealth	= math.ceil( not self:IsDead() and self:GetHealth() or 0.0 );
		
		if iHealth > 0 then
			if not self:IsInVehicle() then
				if iHealth < 20 then
					if self:IsInWater() then
						self:Kill( NULL, NULL, NULL, true );
					else
						if not self.m_bLowHPAnim then
							self:SetAnimation( CPlayerAnimation.PRIORITY_LOWHP, "PED", "KO_skid_front", -1, false, false, false, true );
							
							self.m_bLowHPAnim = true;
							
							self:Hint( "Info", "Ваше текущее состояние не позволяет Вам передвигаться дальше", "info" );
						else
							-- self:SetAnimation( CPlayerAnimation.PRIORITY_LOWHP, "PED", "KO_skid_front", -1, false, false, false, true );
							
							-- self:SetAnimationProgress( "KO_skid_front", 1.0 );
						end
					end
				elseif self.m_bLowHPAnim then
					self:SetAnimation( CPlayerAnimation.PRIORITY_LOWHP, "PED", "getup", 1500, false, false, false, false );
					
					self.m_bLowHPAnim = false;
				end
			else
				self.m_bLowHPAnim = false;
			end
		else
			self.m_bLowHPAnim = false;
		end
		
		if iHealth > 0 and iHealth < 100 then
			if self.m_iHealthRegenPause == NULL or self.m_iHealthRegenPause == 0 then
				self:SetHealth( iHealth + 1 );
				
				self.m_iHealthRegenPause = math.ceil( iHealth * 0.3 );
			end
			
			self.m_iHealthRegenPause = self.m_iHealthRegenPause - 1;
		end
		
		local fPower = self:GetData( "CChar::m_fPower" );
		
		if fPower then
			self.m_pCharacter.m_fPower = fPower;
			
			if not self.m_bLowHPAnim and not self:IsCuffed() then
				if fPower <= 0 then
					self:SetAnimation( CPlayerAnimation.PRIORITY_TIRED, "FAT", "IDLE_tired", 10000, true, false, false, false );
				end
			end
		end
		
		if self:GetArmor() > 0 and not self:GetSkin().HaveArmor() then
			self:SetArmor( 0 );
		end
		
		local tHour, tMinute = getTime();
		
		if tMinute == 0 and self.m_tPayDay > 300 then
			setTime( tHour, tMinute );
			self:PayDay();
			self.m_tPayDay = 0;
		end
		
		self:UpdateCuff();
		self:UpdateJail();
		self:UpdateSpectate();
		
		self:GetChar():DoPulse( tReal );
	end
end

function CPlayer:Save()
	if self:IsLoggedIn() then
		return g_pDB:Query( "UPDATE uac_users SET last_logout = NOW() WHERE id = " + self:GetUserID() ) or not Debug( g_pDB:Error(), 1 );
	end
	
	return false;
end

function CPlayer:GetChar()
	return self.m_pCharacter;
end

function CPlayer:IsInGame()
	return self.m_pCharacter ~= NULL;
end

function CPlayer:HasKey( pTarget )
	if pTarget then
		local pChar = self:GetChar();
		
		if pChar then
			if classof( pTarget ) == CVehicle then
				if self.m_bIgnoreCarKey then
					return true;
				end
				
				local iOwnerID = pTarget:GetOwner();
				
				if iOwnerID == 0 then
					return pTarget:IsRentable() == false;
				elseif iOwnerID > 0 then
					return iOwnerID == pChar:GetID();
				elseif iOwnerID < 0 then
					local pFaction = pChar:GetFaction();
					
					return pFaction and pFaction:GetID() == -iOwnerID;
				end
			elseif classof( pTarget ) == CTeleport then
				local pFaction = self:GetFaction();
				
				return pFaction and ( pFaction:GetID() == pTarget.faction_id or pTarget.faction_id == 0 );
			elseif classof( pTarget ) == CInterior then
				if pTarget.character_id > 0 then
					return pTarget.character_id == pChar:GetID();
				elseif pTarget.character_id < 0 then
					local pFaction = self:GetFaction();
					
					return pFaction and pFaction:GetID() == -pTarget.character_id;
				end
				
				return pTarget.character_id == 0;
			end
		end
	end
	
	return false;
end

function CPlayer:MessageBox( sCallback, ... )
	self:Client().ShowMessageBox( sCallback, ... );
end

function CPlayer:Ban( Reason, Seconds, Player )
	return CBan( banPlayer( self, false, false, true, classof( Player ) == CPlayer and Player:GetUserName() or "Server", Reason, (int)(Seconds) ) );
end

function CPlayer:Kick( Reason )
	return kickPlayer( self, Reason );
end

function CPlayer:Spawn( pos, rotation, skin, int, dim, team )
	pos = pos or Vector3();
	
	return spawnPlayer( self, pos.X, pos.Y, pos.Z, rotation or 0, skin or 0, int or 0, dim or 0, team );
end

function CPlayer:SetAnnounceValue( key, value )
	return setPlayerAnnounceValue( self, key, value );
end

function CPlayer:GetAnnounceValue( key )
	return getPlayerAnnounceValue( self, key );
end

function CPlayer:SetBlurLevel( level )
	return setPlayerBlurLevel( self, (int)(level) );
end

function CPlayer:GetBlurLevel()
	return getPlayerBlurLevel( self );
end

function CPlayer:GetIP()
	return getPlayerIP( self );
end

function CPlayer:GetSerial()
	return getPlayerSerial( self );
end

function CPlayer:SetName( name )
	return setPlayerName( self, name );
end

function CPlayer:SetTeam( pTeam )
	return setPlayerTeam( self, pTeam );
end

function CPlayer:GetMTAVersion()
	return getPlayerVersion( self );
end

function CPlayer:GetIdleTime()
	return getPlayerIdleTime( self );
end

function CPlayer:ResendModInfo()
	return resendPlayerModInfo( self );
end

function CPlayer:Redirect( sIP, iPort, sPassword )
	return redirectPlayer( self, sIP or "", (int)(iPort), sPassword );
end

function CPlayer:ToggleControls( enabled, gtaControls, mtaControls )
	return toggleAllControls( self, tobool( enabled ), gtaControls == nil and true or tobool( gtaControls ), mtaControls == nil and true or tobool( mtaControls ) );
end

function CPlayer:DisableControls( ... )
	for _, control in ipairs( { ... } ) do
		self.m_aControls[ control ] = false;
		
		toggleControl( self, control, false );
	end
	
	self:SetData( "CPlayer::m_Controls", self.m_aControls );
end

function CPlayer:EnableControls( ... )
	for _, control in ipairs( { ... } ) do
		self.m_aControls[ control ] = true;
		
		toggleControl( self, control, true );
	end
	
	self:SetData( "CPlayer::m_Controls", self.m_aControls );
end

function CPlayer:SetControlState( control, state )
	self.m_aControlStates[ control ] = state;
	
	self:SetData( "CPlayer::m_ControlStates", self.m_aControlStates );
	
	return setControlState( self, control, state );
end

function CPlayer:GetControlState( control )
	return getControlState( self, control );
end

function CPlayer:BindKey( key, state, func, ... )
	if type( func ) == 'function' then
		local Function = self.m_Binds[ func ];
		
		if Function == NULL then
			function Function( player, key, state, ... )
				return func( self, key, state, ... );
			end
		end
		
		self.m_Binds[ func ] = Function;
		
		return bindKey( self, key, state, Function, ... );
	else
		return bindKey( self, key, state, func, ... );
	end
end

function CPlayer:UnbindKey( key, state, func )
	if type( func ) == 'function' and self.m_Binds then
		func = self.m_Binds[ func ] or func;
	end
	
	if unbindKey( self, key, state, func ) then
		self.m_Binds[ func ] = nil;
		
		return true;
	end
	
	return false;
end

function CPlayer:IsKeyBound( key, state, func )
	if type( func ) == 'function' then
		func = self.m_Binds[ func ] or func;
	end
	
	return isKeyBound( self, key, state, func );
end

function CPlayer:PlaySoundFrontEnd( sound )
	return playSoundFrontEnd( self, sound );
end

-- Command Handlers

function CPlayer:ExecuteCommand( command, ... )
	return executeCommandHandler( command, self, table.concat( { ... }, ' ' ) );
end

function CPlayer:SetMuted( iTime )
	iTime = (int)(iTime);
	
	self.m_iMuteSeconds = iTime > 0 and iTime * 60 or NULL;
	
	if self:IsLoggedIn() then
		return g_pDB:Query( "UPDATE uac_users SET muted_time = " + ( self.m_iMuteSeconds or 'NULL' ) + " WHERE id = " + self:GetUserID() ) or not Debug( g_pDB:Error() );
	end
	
	return true;
end

function CPlayer:GetMuted()
	return self.m_iMuteSeconds;
end

function CPlayer:IsMuted()
	return (bool)(self.m_iMuteSeconds);
end

function CPlayer:GetAdminID()
	return self.m_iAdminID;
end

function CPlayer:GetAdminName()
	return "Агент поддержки #" + self:GetAdminID();
end

function CPlayer:GetVisibleName()
	if self:IsAdmin() then
		return self:GetAdminName();
	elseif self:IsInGame() then
		return self:GetChar():GetName();
	end
	
	return self:GetName();
end

function CPlayer:Hint( ... )
	return self:Client().Hint( ... );
end

function CPlayer:Gender( male, female, unknown )
	local skin = self:GetSkin();
	
	return skin.GetGender() == 'male' and male or skin.GetGender() == 'female' and female or unknown or male;
end

function CPlayer:SetDimension( dimension )
	for _, pElement in ipairs( self:GetChilds() ) do
		pElement:SetDimension( dimension );
	end
	
	return CElement.SetDimension( self, dimension );
end

function CPlayer:AttachToBone( pObject, iBone, vecPosition, vecRotation )
	Warning( 2, 8106, "CPlayer::AttachToBone" );
	
	vecPosition = vecPosition or Vector3();
	vecRotation = vecRotation or Vector3();
	
	return exports.bone_attach:attachElementToBone( pObject, self, iBone, vecPosition.X, vecPosition.Y, vecPosition.Z, vecRotation.X, vecRotation.Y, vecRotation.Z );
end

function CPlayer:DetachFromBone( pObject )
	Warning( 2, 8106, "CPlayer::DetachFromBone" );
	
	return exports.bone_attach:detachElementFromBone( pObject );
end

function CPlayer:IsAttachedToBone( pObject )
	Warning( 2, 8106, "CPlayer::IsAttachedToBone" );
	
	return exports.bone_attach:isElementAttachedToBone( pObject );
end

function CPlayer:PlaySound3D( ... )
	return triggerClientEvent( "CPlayer:PlaySound3D", self, ... );
end

function CPlayer:TakeScreenShot( fWidth, fHeight, sTag, iQuality, iMaxBandwith )
	return takePlayerScreenShot( self, fWidth, fHeight, sTag or "", iQuality or 100, iMaxBandwith or 5000  );
end

function CPlayer:SprintHandler( key, state )
	self:SetControlState( 'walk', state == 'up' );
end

function CPlayer:VehicleHorn( sKey, sState )
	local pVehicle = self:GetVehicle();
	
	if pVehicle and self:GetVehicleSeat() == 0 then
		pVehicle:Horn( sState == "down" );
	end
end

function CPlayer:VehicleToggleEngine() CVehicleCommands:ToggleEngine( self ); end
function CPlayer:VehicleToggleLocked() CVehicleCommands:ToogleLocked( self ); end
function CPlayer:VehicleToggleLights() CVehicleCommands:ToggleLights( self ); end

function CPlayer:VehicleToggleNitro( sKey, sState )
	if sState == "up" then
		local pVehicle = self:GetVehicle();
		
		if pVehicle and pVehicle:GetDriver() == self then
			if pVehicle:GetUpgrades():IsInstalled( 1010 ) then
				pVehicle:GetUpgrades():Add( 1010 );
			end
		end
	end
end

function CPlayer:InitLoginCamera()
	if self:IsInVehicle() then
		self:RemoveFromVehicle();
	end
	
	self:RemoveData( 'player_level' );
	
	self:GetHUD():HideComponents( 'all' );
	self:GetChat():Hide();

	self:Spawn( DEFAULT_SPAWN_POSITION, 0, 0, 0, 0, t_not_logged_in );
	
	self:SetName( 'not_logged_in_' + self:GetID() );
	
	self:GetNametag():Hide();
	self:GetNametag():Update();
	
	self:SetAlpha( 0 );
	self:SetCollisionsEnabled( false );
	
	self.m_pCamera:SetInterior();
	self.m_pCamera:SetMatrix( DEFAULT_CAMERA_POSITION, DEFAULT_CAMERA_TARGET );
	self.m_pCamera:Fade( true );
end

function CPlayer:ShowLoginScreen()
	self:InitLoginCamera();
	
	local pResult = g_pDB:Query( "SELECT `login`, `password` FROM `uac_users` WHERE `autologin` = %q LIMIT 1", self:GetSerial() );
	
	if pResult then
		local pRow = pResult:FetchRow();
		
		delete ( pResult );
		
		if pRow then
			self:Client().ShowLoginScreen( true, false, pRow.login );
			
			return;
		end
	end
	
	self:Client().ShowLoginScreen( true );
end

function CPlayer:Login( iID )
	local pResult = g_pDB:Query( "SELECT admin_id, `groups`, name, password, ip, DATE_FORMAT( last_logout, '%d %M %Y г. %H:%i' ) as last_login_f, DATEDIFF( CURDATE(), last_logout ) AS last_login_d, settings, adminduty, muted_time, login_history, goldpoints FROM uac_users WHERE id = " + iID + " LIMIT 1" );
	
	if pResult then
		local pRow = pResult:FetchRow();
		
		delete ( pResult );
		
		if pRow then
			local sSerial = self:GetSerial();
			
			self.m_LoginHistory = pRow.login_history and pRow.login_history:split( '\n' ) or {};
			
			table.insert( self.m_LoginHistory, getRealTime().timestamp + "|" + self:GetIP() + "|" + sSerial );
			
			while( table.getn( self.m_LoginHistory ) > 32 ) do
				table.remove( self.m_LoginHistory, 1 );
			end
			
			local sUpdateQuery = "UPDATE `uac_users` SET \
				`login_history` = '" + table.concat( self.m_LoginHistory, '\n' ) + "',\
				`serial` = '" + sSerial + "', `ip` = '" + self:GetIP() + "',\
				`last_login` = NOW(),\
				`activation_code` = NULL,\
				`password` = '" + ( self.m_sPasswordEnc or pRow.password ) + "',\
				`autologin` = " + ( self.m_bAutoLogin and ( "'" + sSerial + "'" ) or "NULL" ) + "\
			WHERE `id` = " + iID;
			
			if not g_pDB:Query( sUpdateQuery ) then
				Debug( g_pDB:Error(), 1 );
			end
			
			self.m_iUserID		= iID;
			self.m_sUserName	= pRow.name;
			
			self.m_iAdminID		= pRow.admin_id;
			self.m_bAdmin		= pRow.adminduty == "Yes";
			
			self:InitGroups( (string)(pRow.groups) );
			
			self.muted_time				= pRow.muted_time;
			self.m_Settings				= pRow.settings and fromJSON( pRow.settings ) or {};
			self.m_ReportData.m_bLocked	= pRow.report_locked == "Yes";
			
			local sLastLogin = false;

			if pRow.last_login_f ~= "00 00 0000 г. 00:00" then
				if pRow.last_login_d == 0 then
					sLastLogin = "Сегодня в " + pRow.last_login_f:split( ' ' )[ 5 ];
				elseif pRow.last_login_d == 1 then
					sLastLogin = "Вчера в " + pRow.last_login_f:split( ' ' )[ 5 ];
				else
					sLastLogin	= pRow.last_login_f;
				end
			end
			
			if sLastLogin then
				self:GetChat():Send( ( "Приветствуем Вас %s, последний раз Вы были тут %s (%s)" ):format( self:GetUserName(), sLastLogin, pRow.ip ), 0, 255, 0 );
			end
			
			self.m_iGP = pRow.goldpoints;
			
			self:Client().Settings.Load( self.m_Settings );
			
			-- Load characters
			
			self:LoadCharacters( self:GetUserID() );
			
			g_pServer:Print( "%s (ID: %d) logged in (Serial: %s)", self:GetUserName(), self:GetUserID(), sSerial );
			
			return true;
		end
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	return false;
end

function CPlayer:InitGroups( sGroups, bAlert )
	if self:IsLoggedIn() then
		bAlert	= bAlert == NULL and true or (bool)(bAlert);
		
		if sGroups == false then
			local pResult = g_pDB:Query( "SELECT `groups` FROM `uac_users` WHERE `id` = " + self:GetUserID() + " LIMIT 1" );
			
			if pResult then
				sGroups = (string)(pResult:FetchRow().groups);
				
				delete ( pResult );
			else
				Debug( g_pDB:Error(), 2 );
				
				return false;
			end
		end
		
		local Groups	= {};
		self.m_Groups	= {};
		
		if sGroups then
			for i, sID in ipairs( sGroups:split( "," ) ) do
				local pGroup	= g_pGame:GetGroupManager():Get( tonumber( sID ) );
				
				if pGroup then
					table.insert( self.m_Groups, pGroup );
					table.insert( Groups, pGroup:GetName() );
					
					if bAlert and pGroup:GetName() == "Разработчики" then
						self:Client().setDevelopmentMode( true );
						
						self:GetChat():Send( " Development mode is enabled", 255, 200, 0 );
					end
				end
			end
		end
		
		if self.m_iAdminID == 0 then
			g_pDB:Query( "UPDATE `uac_users`, ( SELECT MAX( `admin_id` ) + 1 AS `maxid` FROM `uac_users` ) AS users SET `admin_id` = users.maxid WHERE `id` = " + self:GetUserID() );
			
			local pResult = g_pDB:Query( "SELECT `admin_id` FROM `uac_users` WHERE `id` = " + self:GetUserID() + " LIMIT 1" );
			
			if pResult then
				self.m_iAdminID = pResult:FetchRow().admin_id;
				
				delete ( pResult );
			else
				Debug( g_pDB:Error(), 2 );
			end
		end
		
		if self.m_iAdminID == 0 then
			self.m_iAdminID = math.random( 1000, 9999 );
		end
		
		self[ self:HaveAccess( 'command.adminchat' ) and 'BindKey' or 'UnbindKey' ]( self, "F4", "up", "chatbox", "adminchat" );
		
		if bAlert and table.getn( Groups ) > 0 then
			self:GetChat():Send( "Вы состоите в группах: " + table.concat( Groups, ', ' ), 0, 255, 128 );
			self:GetChat():Send( "Ваш личный номер: " + self:GetAdminID(), 255, 255, 128 );
			self:GetChat():Send( " " );
		end
		
		
		self:SetAdminDuty( self.m_bAdmin );
		
		return true;
	end
	
	return false;
end

function CPlayer:GetGroups()
	return self.m_Groups;
end

function CPlayer:HaveAccess( sAccess )
	if self:IsLoggedIn() then
		if self:GetUserID() == 0 then
			return true;
		end
		
		for i, pGroup in pairs( self:GetGroups() ) do
			if pGroup:GetID() == 0 or pGroup:GetRight( sAccess ) then
				return true;
			end
		end
	end
	
	return false;
end

function CPlayer:IsAdmin()
	return self.m_bAdmin;
end

function CPlayer:SetAdminDuty( bEnabled )
	bEnabled = bEnabled and self:HaveAccess( 'command.adminduty' );
	
	self.m_bAdmin = bEnabled;
	
	self:SetData( 'adminduty', 		self.m_bAdmin );
	self:SetData( "Nametag:Color",  self.m_bAdmin and self:GetGroups()[ 1 ]:GetColor() );
	
	self:GetNametag():Update();
	
	if self.m_bAdmin then
		self:SetModel( 0 );
		
		self:AddClothes( "suit2grn", "suit2", 0 );
		self:AddClothes( "suit1trblk", "suit1tr", 2 );
		self:AddClothes( "shoedressblk", "shoe", 3 );
		self:AddClothes( "glasses05dark", "glasses03", 15 );
	elseif self:IsInGame() then
		self:SetModel( self:GetChar().m_iSkin );
	end
end

function CPlayer:LoadCharacters( iUserID )
	local pResult = g_pDB:Query( "SELECT name, surname, DATE_FORMAT( last_login, '%d/%m/%Y %H:%i:%s' ) AS last_login, DATE_FORMAT( created, '%d/%m/%Y %H:%i:%s' ) AS created, status FROM " + DBPREFIX + "characters WHERE user_id = " + iUserID + " AND status != 'Скрыт' ORDER BY last_login DESC" );
	
	if pResult then
		local Characters = pResult:GetArray();
		
		delete ( pResult );
		
		local iCharacters	= 0;
		
		for i, char in ipairs( Characters ) do
			if char.status ~= "Скрыт" then
				iCharacters = iCharacters + 1;
			end
		end
		
		if iCharacters == 0 then
			CClientRPC.SelectCharacter( self, "NEW", iCharacters == 0 );
		elseif iCharacters == 1 and g_pGame.m_iCharactersLimit == 1 then
			CClientRPC.SelectCharacter( self, Characters[ iCharacters ][ "name" ], Characters[ iCharacters ][ "surname" ] );
		else				
			self:Client().CUICharacterSelect( Characters, g_pGame.m_iCharactersLimit == 0 or iCharacters < g_pGame.m_iCharactersLimit );
			
			self.m_Characters = Characters;
		end
	else
		Debug( g_pDB:Error(), 1 );
	end
end

function CPlayer:ShowHelp()
	local ContentSort	=
	{
		"Правила";
		"Профессии";
		"Управление";
		"Команды";
		"F.A.Q.";
	};
	
	local Content 			=
	{
		[ "Правила" ]		= TEXT_HELP_RULES;
		[ "Профессии" ]		= TEXT_HELP_JOBS;
		[ "Управление" ]	= TEXT_HELP_BINDS;
		[ "Команды" ]		= TEXT_HELP_COMMANDS_MAIN + '\n' + TEXT_HELP_COMMANDS_ADD;
		[ "F.A.Q." ]		= "Данный раздел ещё в разработке\n\nВы можете задать свой вопрос на нашем форуме, по адресу http://mtaroleplay.ru/index.php?showforum=96";
	};
	
	local sGroupIndex		= NULL;
	local sFactionIndex		= NULL;
	
	local pChar		= self:GetChar();
	local pFaction;
	
	if pChar then
		pFaction = pChar:GetFaction();
		
		if pFaction and pFaction:GetID() > 0 then
			sFactionIndex = pFaction:GetName();
			
			Content[ sFactionIndex ] = "Описание фракции:\n\n";
			Content[ sFactionIndex ] = Content[ sFactionIndex ] + "    " + ( pFaction.m_sDescription or "Описание отсутствует" ); -- TODO: CFaction::GetDescription()
			Content[ sFactionIndex ] = Content[ sFactionIndex ] + "\n\nСписок команд фракции:\n\n";
			
			table.insert( ContentSort, sFactionIndex );
		end
	end
	
	local Groups = self:GetGroups();
	
	if Groups and Groups[ 1 ] then
		sGroupIndex = Groups[ 1 ]:GetCaption();
		
		Content[ sGroupIndex ]	= "";
		
		table.insert( ContentSort, sGroupIndex );
	end
	
	if sGroupIndex or sFactionIndex then
		for i, pCmd in ipairs( CCommand:GetAll() ) do
			if sGroupIndex then
				if pCmd.m_bRestricted and self:HaveAccess( 'command.' + pCmd.m_sName ) then
					Content[ sGroupIndex ] = Content[ sGroupIndex ] + pCmd.m_sName + '\n\n';
				end
			end
			
			if sFactionIndex then
				if pCmd.m_pFaction == pFaction then
					Content[ sFactionIndex ] = Content[ sFactionIndex ] + "    " + pCmd.m_sName + '\n\n';
				end
			end
		end
	end
	
	self:Client().CHelpDialog( Content, ContentSort );
end

function CPlayer:SaveSettings()
	if not g_pDB:Query( "UPDATE uac_users SET settings = '" + toJSON( self.m_Settings ) + "' WHERE id = " + self:GetUserID() ) then
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
	return true;
end

function CPlayer:SetSpectating( pPlayer )
	if self:IsInGame() then
		if pPlayer then
			if pPlayer:IsInGame() then
				if not self.m_pSpectatingPlayer then
					self.spec_pos = self:GetPosition();
					self.spec_int = self:GetInterior();
					self.spec_dim = self:GetDimension();
					self.spec_rot = self:GetRotation();
				end
				
				if not self:IsKeyBound( "d", "up", "player", "spectate next" ) then self:BindKey( "d", "up", "player", "spectate next" ) end
				if not self:IsKeyBound( "a", "up", "player", "spectate prev" ) then self:BindKey( "a", "up", "player", "spectate prev" ) end
				
				self:SetData( 'Nametag->MaxDistance', 200.0 );
				self.m_pSpectatingPlayer = pPlayer;
				
				if pPlayer:HaveAccess( 'general.immunity' ) then
					pPlayer:GetChat():Send( self:GetUserName() + ' (' + self:GetID() + ') наблюдает за Вами', 0, 200, 0 );
				end
			end
		else
			self:RemoveData( 'Nametag->MaxDistance' );
			self.m_pSpectatingPlayer = NULL;
			self:Client().SetSpectating();
		end
		
		self:UpdateSpectate();
	end
	
	return false;
end

function CPlayer:IsSpectating()
	return self.m_pSpectatingPlayer ~= NULL;
end

function CPlayer:GetSpectating()
	return self.m_pSpectatingPlayer;
end

function CPlayer:UpdateSpectate()
	if self.m_pSpectatingPlayer and self.m_pSpectatingPlayer:IsInGame() then
		if self.m_pSpectatingPlayer:IsSpectating() then
			self.m_pSpectatingPlayer = self.m_pSpectatingPlayer:GetSpectating();
		end
		
		self:Client().SetSpectating( self.m_pSpectatingPlayer, 
			{ 
				money		= self.m_pSpectatingPlayer:GetChar():GetMoney();
				username	= self.m_pSpectatingPlayer:GetUserName();
			} 
		);
		
		if self:IsInVehicle() then
			self:RemoveFromVehicle();
		end
		
		if self:GetAlpha() > 0 then
			self:SetAlpha( 0 );
		end
		
		if not self:IsFrozen() then
			self:SetFrozen( true );
		end
		
		if self:IsCollisionsEnabled() then
			self:SetCollisionsEnabled( false );
		end
		
		if self:GetAttachedTo() ~= self.m_pSpectatingPlayer then
			self:SetPosition( self.m_pSpectatingPlayer:GetPosition() + Vector3( 0, 0, -5 ) );
			self:AttachTo( self.m_pSpectatingPlayer, Vector3( 0, 0, -5 ) );
		end
		
		if self:GetInterior() ~= self.m_pSpectatingPlayer:GetInterior() then
			self:SetInterior( self.m_pSpectatingPlayer:GetInterior() );
		end
		
		if self:GetDimension() ~= self.m_pSpectatingPlayer:GetDimension() then
			self:SetDimension( self.m_pSpectatingPlayer:GetDimension() );
		end
		
		if self:GetCamera():GetTarget() ~= self.m_pSpectatingPlayer then
			self:GetCamera():SetTarget( self.m_pSpectatingPlayer );
		end
	else
		self.m_pSpectatingPlayer = NULL;
		
		if self.spec_pos then
			self:Detach();
			
			self:RemoveFromVehicle();
			self:GetCamera():SetTarget();
			self:SetPosition( self.spec_pos );
			self:SetInterior( self.spec_int );
			self:SetDimension( self.spec_dim );
			self:SetRotation( self.spec_rot );
			self:SetAlpha( 255 );
			self:SetCollisionsEnabled( true );
			self:SetFrozen( false );
			
			self.spec_pos = NULL;
			self.spec_int = NULL;
			self.spec_dim = NULL;
			self.spec_rot = NULL;
			
			self:Client().SetSpectating();
			
			self:UnbindKey( "d", "up", "player", "spectate next" );
			self:UnbindKey( "a", "up", "player", "spectate prev" );
		end
	end
end

-- Callbacks

function CPlayer:OnHit( hAttacker, iWeapon, iBodypart, fLoss )
	-- if iBodypart == 9 or self:IsInVehicle() then
	if iBodypart == 9 then
		if self:GetArmor() <= 0 then
			self:Kill( hAttacker, iWeapon, 9 );
		end
	end
	
	-- Debug( "CPlayer(" + self:GetName() + ")->OnHit( " + ( hAttacker and hAttacker:GetName() or 'NULL' ) + " )" );
	
	-- Debug( "CPlayer->OnHit( " + self:GetName() + ", " + (string)( iWeapon ) + ", " + (string)( iBodypart ) + ", " + (string)( fLoss ) + " )" );
end


local ChatCommands =
{
	-- hardcoded
	say			= true;
	teamsay		= true;
	me			= true;
	--
	GlobalOOC	= true;
	o			= true;
	LocalOOC	= true;
	b			= true;
	c			= true;
	shout		= true;
	s			= true;
	whisper		= true;
	w			= true;
	try			= true;
	['do']		= true;
	dice		= true;
	coin		= true;
	-- phone
	p			= true;
	sms			= true;
	-- adm
	adminchat	= false;
	a			= false;
	pm			= false;
};

function CPlayer:OnCommand( cmd )
	if not ChatCommands[ cmd ] then 	return true; 		end
	
	if self:IsMuted() then
		self:GetChat():Send( "Вы лишены права пользоваться чатом. Осталось: " + self:GetMuted() + " секунд", 255, 128, 0 );
		
		return false;
	end
	
	self.m_iAntiflood = ( self.m_iAntiflood or 0 ) + 1;
	
	if self.m_iAntiflood > 10 then
		self:SetMuted( 10 );
		
		self:GetChat():Send( "Вы лишены права пользоваться чатом на 10 минут!", 255, 0, 0 );
		
		return false;
	elseif self.m_iAntiflood > 5 then
		self:GetChat():Send( "Прекратите флудить, иначе Вы будете лишены права пользоваться чатом!", 255, 0, 0 );
		
		return false;
	end
	
	return true;
end

addEventHandler( "onPlayerCommand", root, function( ... ) CPlayer.OnCommand( source, ... ); end );
addEventHandler( "onPlayerDamage", root, function( ... ) CPlayer.OnHit( source, ... ); end );
