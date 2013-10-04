-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

function CCommands:ShowDoPulseStat( pPlayer )
	pPlayer:Client().ShowDoPulseStat();
end

function CCommands:Enter( pClient, sCmd )
	if pClient.m_pTeleportMarker then
		( pClient.m_pTeleportMarker.m_pTeleport or pClient.m_pTeleportMarker.m_pInterior ):Use( pClient );
	end
end

function CCommands:Passport( pPlayer, sCmd, sTarget )
	local pChar = pPlayer:GetChar();
	
	if pChar then	
		local pTarget = NULL;
		
		if sTarget then
			pTarget = g_pGame:GetPlayerManager():Get( sTarget );
		else
			pTarget = pPlayer;
		end
		
		if pTarget and pTarget:IsInGame() then
			local sMarried		= pChar:GetMarried();
			
			pTarget:Client().CGUIPassport(
				{
					{ Name = NULL,					Value = pChar.m_sCreated						};
					{ Name = NULL,					Value = NULL									};
					{ Name = 'Имя',					Value = pChar.m_sName 							};
					{ Name = 'Фамилия',				Value = pChar.m_sSurname 						};
					{ Name = 'Пол',					Value = pPlayer:Gender( "Мужской", "Женский" )	};
					{ Name = 'Дата рождения',		Value = pChar.m_sDateOfBirdth 					};
					{ Name = 'Место рождения',		Value = pChar.m_sPlaceOfBirdth 					};
					{ Name = 'Национальность',		Value = pChar:GetNation() 						};
					{ Name = 'Состояние в браке',	Value = sMarried == '' and pPlayer:Gender( 'Не женат', 'Не замужем' ) or pPlayer:Gender( 'Женат на ', 'Замужем за ' ) + sMarried };
					{ Name = NULL,					Value = NULL									};
					{ Name = 'Дата выдачи',			Value = pChar.m_sCreated 						};
				}
			);
			
			return true;
		end

		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	return true;
end

function CCommands:Eject( pPlayer, sCmd, sTarget )
	if sTarget then
		local pVehicle = pPlayer:GetVehicleSeat() == 0 and pPlayer:GetVehicle();
		
		if pVehicle then
			if pVehicle:IsLocked() then
				pPlayer:Hint( 'Ошибка', '\nДвери заблокированы', 'error' );
				
				return true;
			end
			
			if sTarget == '*' then
				for iSeat, pPlr in pairs( pVehicle:GetOccupants() ) do
					if iSeat ~= 0 then
						pPlr:SetControlState( 'enter_exit', true );
					
						pPlr:GetChat():Send( pPlayer:GetVisibleName() + " выкинул вас из автомобиля", 255, 0, 0 );
					end
				end
				
				return true;
			end
			
			local pTarget = g_pGame:GetPlayerManager():Get( sTarget );
			
			if pTarget and pTarget:IsInGame() then
				if pTarget:GetVehicle() == pVehicle and pTarget:GetVehicleSeat() ~= 0 then
					pTarget:SetControlState( 'enter_exit', true );
					
					pTarget:GetChat():Send( pPlayer:GetVisibleName() + " выкинул вас из автомобиля", 255, 0, 0 );
					
					return true;
				end
				
				return pTarget:GetName() + " не является пассажиром вашего автомобиля", 255, 0, 0;
			end
			
			return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
		end
		
		return "Вы не водитель автомобиля", 255, 0, 0;
	end
	
	return "Syntax: /" + sCmd + " <player или * для всех>", 255, 255, 255;
end

function CCommands:ChangeSpawn( pPlayer, sCmd )
	local pChar		= not pPlayer:IsDead() and pPlayer:GetChar();
	
	if pChar then
		local Spawns	= { [ 0 ] = "Госпиталь" };
		
		local IntTypes	=
		{
			interior	= true;
			house		= true;
			business	= false;
		};
		
		local pFaction	= pChar:GetFaction();
		
		for _, pInt in pairs( g_pGame:GetInteriorManager():GetAll() ) do
			if IntTypes[ pInt:GetType() ] then
				if pInt:GetOwner() == pChar:GetID() then
					Spawns[ pInt:GetID() ] = "Дом ID " + pInt:GetID();
				elseif pFaction ~= NULL and pFaction == pInt:GetFaction() then
					Spawns[ pInt:GetID() ] = "Интерьер " + pFaction:GetTag() + " ID " + pInt:GetID();
				end
			end
		end
		
		if pChar.m_iSpawnInterior then		
			local pInterior = g_pGame:GetInteriorManager():Get( pChar.m_iSpawnInterior );
			
			pChar.m_iSpawnInterior = NULL;
			
			if pInterior and ( pInterior:GetOwner() == pChar:GetID() or ( pFaction ~= NULL and pFaction == pInterior:GetFaction() ) ) then
				pChar.m_iSpawnInterior = pInterior:GetID();
			end
		end
		
		if sizeof( Spawns ) > 1 then
			pPlayer:Client().CGUISpawnChanger( Spawns, pChar.m_iSpawnInterior or 0 );
		elseif sCmd then
			pPlayer:Hint( "Изменение спавна", "\nУ Вас нет доступных интерьеров", "warning" );
		end
	end
end

function CCommands:Report( pPlayer, sCmd, ... )
	if pPlayer:IsInGame() then
		if pPlayer.m_ReportData.m_bLocked then
			self:Echo( pPlayer, "эта команда для вас заблокирована" );
			
			return;
		end
		
		local tStamp = getRealTime().timestamp;
		
		if pPlayer.m_ReportData.m_tStamp - tStamp <= 0 then
			local sText = table.concat( { ... }, ' ' );
			
			if sText:len() > 0 then
				pPlayer.m_ReportData.m_tStamp	= tStamp + 300;
				pPlayer.m_ReportData.m_sText	= sText;
				
				SendAdminsMessage( ( "%s (%s) ID: %d - /ar(eport) для ответа" ):format( pPlayer:GetName(), pPlayer:GetUserName(), pPlayer:GetID() ), "[REPORT]: ", 128, 128, 0 );
				SendAdminsMessage( sText, "Сообщение: ", 128, 128, 64 );
			else
				self:Echo( pPlayer, "<message>" );
			end
		else
			self:Echo( pPlayer,  "функция доступна раз в 5 минут" );
		end
	end
end

function CCommands:ViewHelp( pPlayer )
	if pPlayer:IsInGame() then
		pPlayer:ShowHelp();
	end
end

function CCommands:Stats( pPlayer, sCmd, sTargetID )
	if sTargetID == 0 or pPlayer:GetID() == 0 then
		local Cols, Rows = getPerformanceStats( "Server info" );
		
		local Stats	=
		{
		--	[ "Platform" ]					= true;
			[ "Server FPS sync (logic)" ]	= true;
		--	[ "MinClientVersion" ]			= true;
		--	[ "RecommendedClientVersion" ]	= true;
		--	[ "NetworkEncryptionEnabled" ]	= true;
		--	[ "BandwidthReductionMode" ]	= true;
		--	[ "Version" ]					= true;
			[ "Players" ]					= true;
		--	[ "Bytes/sec incoming" ]		= true;
		--	[ "Bytes/sec outgoing" ]		= true;
		--	[ "Packets/sec incoming" ]		= true;
		--	[ "Packets/sec outgoing" ]		= true;
		--	[ "Packet loss outgoing" ]		= true;
		--	[ "Busy sleep time" ]			= true;
		--	[ "Idle sleep time" ]			= true;
			[ "Uptime" ]					= true;
		--	[ "VoiceEnabled" ]				= true;
			[ "Memory" ]					= true;
		--	[ "Approx network usage" ]		= true;
		--	[ "LightSyncEnabled" ]			= true;
		--	[ "ThreadNetEnabled" ]			= true;
		--	[ "Msg queue incoming" ]		= true;
		--	[ "Msg queue outgoing" ]		= true;
		};

		local pChat = pPlayer:GetChat();
		
		for iter, pRow in ipairs( Rows ) do
			for i = 1, 6, 2 do
				local sKey		= pRow[ i ];
				local sValue	= pRow[ i + 1 ];
				
				if Stats[ sKey ] then
					pChat:Send( ( "%s: %s" ):format( sKey, sValue ), 255, 255, 255 );
				end
			end
		end
	elseif pPlayer:IsInGame() then
		local pTarget = g_pGame:GetPlayerManager():Get( pPlayer:HaveAccess( "command.player:stats" ) and sTargetID or pPlayer:GetID() );
		
		if pTarget then
			if pTarget:IsInGame() then
				pPlayer:ShowStats( pTarget );
			else
				return TEXT_PLAYER_NOT_IN_GAME, 255, 0, 0;
			end
		else
			return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
		end
	end
	
	return true;
end

function CCommands:Pay( pPlayer, sCmd, sTarget, sValue )
	local pChar = pPlayer:GetChar();
	
	if not pChar then return true; end
	
	local iValue = tonumber( sValue );
	
	if sTarget and iValue then
		if iValue > 0 and ( iValue <= 5000 or pPlayer:IsAdmin() ) then
			if iValue > pPlayer:GetChar():GetMoney() then
				return "У Вас нет такой суммы", 255, 0, 0;
			end
			
			local pTarget = g_pGame:GetPlayerManager():Get( sTarget );
			
			if not pTarget or not pTarget:IsInGame() then
				return PLAYER_NOT_FOUND, 255, 0, 0;
			end
			
			if pTarget == pPlayer then
				return "Команда не применима к самому себе", 255, 0, 0;
			end
			
			if pTarget:IsAdmin() or pTarget:GetDimension() ~= pPlayer:GetDimension() then
				return TEXT_PLAYER_NOT_NEARBY, 255, 0, 0;
			end
			
			local pVehicle	= pPlayer:GetVehicle();
			
			if ( pVehicle and pVehicle == pTarget:GetVehicle() ) or pPlayer:GetPosition():Distance( pTarget:GetPosition() ) < 3.0 then
				if not pVehicle and not pPlayer:SetAnimation( CPlayerAnimation.PRIORITY_ALL, "VENDING", "VEND_USE", 1000, false, true, true, false ) then
					return "Команда не доступна в данный момент", 255, 0, 0;
				end
				
				pPlayer:Me( pPlayer:Gender( "передал", "передала" ) + " деньги " + pTarget:GetChar():GetName() );
				
				pChar:TakeMoney( iValue );
				pTarget:GetChar():GiveMoney( iValue );
				
				pPlayer:PlaySoundFrontEnd( 14 );
				pTarget:PlaySoundFrontEnd( 6 );
				
				g_pMoneyLog:Write( "[%d] %s (%s) transfered $%d to [%d] %s (%s)", pPlayer:GetID(), pChar:GetName(), pPlayer:GetUserName(), iValue, pTarget:GetID(), pTarget:GetName(), pTarget:GetUserName() );
				
				return true;
			end
			
			return TEXT_PLAYER_NOT_NEARBY, 255, 0, 0;
		end
		
		return "Сумма должна быть не более $5000 и не менее $1", 255, 0, 0;
	end
	
	return "Syntax: /" + sCmd + " <player> <value>", 255, 255, 255;
end

function CCommands:WeaponSlot( pPlayer, sCmd, siSlot )
	if pPlayer:IsInGame() and not pPlayer:GetControlState( 'aim_weapon' ) and not pPlayer:GetControlState( 'fire' ) and pPlayer:GetAmmoInClip() > 0 and not pPlayer:IsTied() and not pPlayer:IsCuffed() then
		local pChar = pPlayer:GetChar();
		
		if pChar then
			local iSlot = tonumber( siSlot );
			
			pPlayer:GetChar():SelectWeaponSlot( iSlot and iSlot + 1 or NULL );
		end
	end
end

function CCommands:ReloadWeapon( pPlayer )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		pChar:ReloadWeapon();
	end
end

function CCommands:DropWeapon( pPlayer )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		local pWeapon = pChar:GetWeapon();
		
		if pWeapon then
			pChar:DropItem( pWeapon );
		end
	end
end

function CCommands:DropDrink( pPlayer )
	if pPlayer:IsInGame() then
		local pBoneObject = pPlayer:GetBones():GetObject( 12 );
		
		if pBoneObject and pBoneObject.m_rItem and pBoneObject.m_rItem.m_iType == ITEM_TYPE_DRINK then
			delete ( pBoneObject.m_rItem );
		end
	end
	
	pPlayer:UnbindKey( "f", 		"down", "drop_drink" );
	pPlayer:UnbindKey( "enter", 	"down", "drop_drink" );
	
	pPlayer:UnbindKey( "e",	"down", "drink" );
end

function CCommands:Drink( pPlayer )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		local pBoneObject = pPlayer:GetBones():GetObject( 12 );
		
		if pBoneObject and pBoneObject.m_rItem and pBoneObject.m_rItem.m_iType == ITEM_TYPE_DRINK and pBoneObject.m_rItem:Drink() then
			return true;
		end
	end
	
	CCommands:DropDrink( pPlayer );
end

-- // Chat commands

function CCommands:GlobalOOC( pPlayer, sCmd, ... )
	if pPlayer:IsLoggedIn() then
		if g_pGame.m_bGlobalOOC or pPlayer:HaveAccess( 'command.adminchat' ) then
			local sMessage = table.concat( { ... }, " " );
			
			if sMessage:len() > 0 then
				outputChatBox( "(( " + pPlayer:GetUserName() +  ": " + sMessage + " ))", root, 0, 196, 255, true );
				
				g_pServer:Print( "GlobalOOC: [%d]:  (( %s: %s ))", pPlayer:GetID(), pPlayer:GetUserName(), sMessage:gsub( '%%', '%%%%' ) );
				
				return true;
			end

			return "Syntax: /" + sCmd + " <global OOC text>";
		end

		return "Глобальный OOC чат недоступен для игроков", 255, 128, 0;
	end
end

function CCommands:LocalOOC( pPlayer, sCmd, ... )
	if pPlayer:IsInGame() then
		local sMessage = table.concat( { ... }, " " );
			
		if sMessage:len() > 0 then
			pPlayer:LocalMessage( "*" + pPlayer:GetVisibleName() + ( pPlayer:IsAdmin() and '' or ( " (" + pPlayer:GetID() + ")" ) ) + ": (( " + sMessage + " ))", 196, 255, 255 );
			
			g_pServer:Print( "LocalOOC: [%d]:  (( %s: %s ))", pPlayer:GetID(), pPlayer:GetVisibleName(), sMessage:gsub( '%%', '%%%%' ) );
			
			return true;
		end

		return "Syntax: /" + sCmd + " <local OOC text>";
	end
end

function CCommands:CloseIC( pPlayer, sCmd, ... )
	if pPlayer:IsInGame() and not pPlayer:IsDead() then
		local sText = table.concat( { ... }, ' ' );
		
		if sText:len() > 0 then
			pPlayer:LocalizedMessage( sText, 2.0, 4 );
			
			return true;
		end

		return "Syntax: /" + sCmd + " <IC message>";
	end
end

function CCommands:WhisperIC( pPlayer, sCmd, ... )
	if pPlayer:IsInGame() and not pPlayer:IsDead() then
		local sText = table.concat( { ... }, ' ' );
		
		if sText:len() > 0 then
			pPlayer:LocalizedMessage( sText, 1.0, 3 );
			
			return true;
		end
		
		return "Syntax: /" + sCmd + " <IC message>";
	end
end

function CCommands:ShoutIC( pPlayer, sCmd, ... )
	if pPlayer:IsInGame() and not pPlayer:IsDead() then
		local sText = table.concat( { ... }, ' ' );
		
		if sText:len() > 0 then
			pPlayer:LocalizedMessage( sText, 40.0, 2 );
			
			return true;
		end

		return "Syntax: /" + sCmd + " <IC message>";
	end
end

function CCommands:TryIC( pPlayer, sCmd, ... )
	if pPlayer:IsInGame() and not pPlayer:IsDead() then
		local iTimeStamp = getRealTime().timestamp;
		
		local iDiff = ( pPlayer.m_iLastTry or 0 ) - iTimeStamp;
		
		if iDiff <= 0 then		
			local sText = table.concat( { ... }, ' ' );
			
			if sText:len() > 0 then
				pPlayer.m_iLastTry = iTimeStamp + 30;
				
				pPlayer:Me( pPlayer:Gender( 'попытался ', 'попыталась ' ) + sText + ( math.random() >= .5 and ' (Удачно)' or ' (Неудачно)' ), '*** ' );
				
				return true;
			end

			return "Syntax: /" + sCmd + " <IC action>";
		end

		return ( "Команда доступна раз в 30 секунд. Осталось: %d сек." ):format( iDiff ), 200, 200, 200;
	end
end

function CCommands:DoIC( pPlayer, sCmd, ... )
	if pPlayer:IsInGame() and not pPlayer:IsDead() then
		local sText = table.concat( { ... }, ' ' );
		
		if sText:len() > 0 then
			pPlayer:LocalMessage( '* ' + sText + ' (( ' + pPlayer:GetVisibleName() + ' ))', 255, 0, 255, 10, 255, 0, 255 );
				
			g_pServer:Print( '* %s (( %s ))', sText, pPlayer:GetVisibleName() );
		
			return true;
		end

		return "Syntax: /" + sCmd + " <IC action>";
	end
end

function CCommands:DiceIC( pPlayer, sCmd )
	if pPlayer:IsInGame() and not pPlayer:IsDead() then
		pPlayer:Me( 'бросил игральные кости (Выпало: ' + math.random( 6 ) + ')', "*** " );
	end
end

function CCommands:CoinIC( pPlayer, sCmd )
	if pPlayer:IsInGame() and not pPlayer:IsDead() then
		if pPlayer:GetChar():GetMoney() >= 1 then
			pPlayer:Me( 'бросил монетку (Выпало: ' + ( math.random( 2 ) == 1 and "Орёл" or "Решка" ) + ')', "*** " );
			
			return true;
		end

		return 'У Вас нет денег', 255, 0, 0;
	end
end


local Services	=
{
	[555]	= function( pPlayer )
		if not pPlayer:IsInGame() then return end
		
		local TJobTaxi = CJob.GetByID( "taxi" );
		
		if TJobTaxi and table.getn( TJobTaxi:GetDrivers() ) > 0 then			
			if pPlayer:IsInVehicle() and pPlayer:GetVehicle():GetJob() == TJobTaxi then
				pPlayer:GetChat():Send( "Вы не можете вызывать такси в данный момент", 255, 128, 0 );
			else
				TJobTaxi:RegisterCall( pPlayer );
				
				pPlayer:GetChat():Send( "Ваш вызов такси принят", 255, 255, 0 );
			end
		else
			pPlayer:GetChat():Send( "К сожалению сейчас нет ни одной свободной машины", 255, 255, 0 );
		end
		
		CCommands:PhoneHangup( pPlayer );
	end;
	
	[911]	= function( pPlayer, sText )
		if not pPlayer:IsInGame() then return false end
		
		
	end;
};


function CCommands:PhoneText( pPlayer, sCmd, ... )
	if pPlayer:IsInGame() then
		if pPlayer:IsCuffed() then
			CCommands:PhoneHangup( pPlayer );
			
			return "Вы не можете говорить по телефону в наручниках", 255, 0, 0;
		end
		
		if pPlayer.m_bLowHPAnim then
			CCommands:PhoneHangup( pPlayer );
			
			return "Вы не в состоянии говорить по телефону", 255, 0, 0;
		end
		
		local sText = table.concat( { ... }, ' ' );
			
		if sText:len() == 0 then
			return "Syntax: /" + sCmd + " <text>", 255, 255, 255;
		end
		
		if Services[ pPlayer.m_iCallNumber ] then
			return Services[ pPlayer.m_iCallNumber ]( pPlayer, sText );
		end
		
		local pOtherPlayer;
		
		for _, p in pairs( g_pGame:GetPlayerManager():GetAll() ) do
			if p ~= pPlayer and p:IsInGame() and pPlayer.m_iCallNumber ~= NULL and pPlayer.m_iCallNumber == p.m_iCallNumber then
				pOtherPlayer = p;
				break;
			end
		end
		
		if pOtherPlayer then
			pOtherPlayer:GetChat():Send( ( pPlayer.m_bCallNumberHidden and "Телефон: Номер скрыт" or "Телефон: " + pPlayer:GetChar():GetPhoneNumber() ) + ": " + sText, 255, 255, 0 );
			pPlayer:LocalMessage( "*" + pPlayer:GetChar():GetName() + " (" + pPlayer:GetID() + ") [Телефон] " + pPlayer:Gender( "сказал", "сказала" ) + ": " + sText, 240, 240, 240, 10.0, 64, 64, 64 );
			
			pOtherPlayer:SetAnimation( CPlayerAnimation.PRIORITY_PHONE, "PED", "phone_talk", 1, true, true, false, true );
			pPlayer:SetAnimation( CPlayerAnimation.PRIORITY_PHONE, "PED", "phone_talk", 1, true, true, false, true );
			
			return true;
		end
		
		CCommands:PhoneHangup( pPlayer );
		
		return "Вы не на линии", 255, 0, 0;
	end
	
	return true;
end

function CCommands:PhoneHangup( pPlayer )
	if pPlayer:IsInGame() and pPlayer.m_iCallNumber then
		local iNumber = pPlayer:GetChar():GetPhoneNumber();
		
		if Services[ pPlayer.m_iCallNumber ] then
			pPlayer.m_iCallNumber			= NULL;
			pPlayer.m_bCallNumberHidden		= NULL;
			
			pPlayer:SetAnimation( CPlayerAnimation.PRIORITY_PHONE, "PED", "phone_out", 3000, false, true, false, false );
			
			return "Вызов завершен", 255, 255, 255;
		end
		
		for _, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
			if pPlr:IsInGame() and pPlayer.m_iCallNumber == pPlr.m_iCallNumber then
				pPlr:GetChat():Send( "Вызов завершен", 255, 255, 255 );
				
				pPlr.m_iCallNumber			= NULL;
				pPlr.m_bCallNumberHidden	= NULL;
				
				pPlr:SetAnimation( CPlayerAnimation.PRIORITY_PHONE, "PED", "phone_out", 3000, false, true, false, false );
			end
		end
	end
	
	return true;
end

function CCommands:PhonePickup( pPlayer )
	if pPlayer:IsInGame() then
		if not pPlayer:IsCuffed() then
			if not pPlayer.m_bLowHPAnim then
				if pPlayer.m_iCallNumber then
					return pPlayer:GetChat():Send( "Вы уже на линии", 255, 0, 0 );
				end
				
				local bCall = false;
				
				for _, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
					if pPlr:IsInGame() and pPlayer:GetChar():GetPhoneNumber() == pPlr.m_iCallNumber then
						pPlayer.m_iCallNumber = pPlr.m_iCallNumber;
						
						pPlr:GetChat():Send( "Отвечает на звонок ..", 255, 255, 255 );
						pPlayer:GetChat():Send( "Используйте /p <text> для разговора по телефону (/h(angup) для окончания)", 255, 255, 255 );
						
						pPlayer:SetAnimation( CPlayerAnimation.PRIORITY_PHONE, "PED", "phone_in", 1, false, true, false, true );
						
						bCall = true;
					end
				end
				
				if not bCall then
					pPlayer:GetChat():Send( "Никто не звонил Вам", 255, 0, 0 );
				end
			else
				pPlayer:GetChat():Send( "Вы не в состоянии говорить по телефону", 255, 0, 0 );
			end
		else
			pPlayer:GetChat():Send( "Вы не можете говорить по телефону в наручниках", 255, 0, 0 );
		end
		
		CCommands:PhoneHangup( pPlayer );
	end
end

function CCommands:PhoneCall( pPlayer, sCmd, iNumber, bHidden )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		if pPlayer:IsCuffed() then
			CCommands:PhoneHangup( pPlayer );
			
			return "Вы не можете говорить по телефону в наручниках", 255, 0, 0;
		end
		
		if pPlayer.m_bLowHPAnim then
			CCommands:PhoneHangup( pPlayer );
			
			return "Вы не в состоянии говорить по телефону", 255, 0, 0;
		end

		if pPlayer.m_iCallNumber then
			return "Вы уже на линии", 255, 0, 0;
		end
		
		local pFaction = pChar:GetFaction();
		
		iNumber = tonumber( iNumber );
		
		if iNumber then
			pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <number>" + ( pFaction and pFaction:HaveFlag( 'fbi' ) and " [Анти АОН = 0]" or "" ), 255, 255, 255 );
		end
		
		bHidden = (bool)(bHidden) and pFaction and pFaction:HaveFlag( 'fbi' ) or false;

		pPlayer.m_iCallNumber			= iNumber;
		pPlayer.m_bCallNumberHidden		= bHidden;
		
		if Services[ pPlayer.m_iCallNumber ] then
			Services[ pPlayer.m_iCallNumber ]( pPlayer );
			
			return;
		end
		
		for iID, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
			if pPlr:IsInGame() and pPlr:GetChar():GetPhoneNumber() == pPlayer.m_iCallNumber then
				if not pPlr.m_iCallNumber then
					pPlr:GetChat():Send( "Входящий вызов: " + ( bHidden and 'Номер скрыт' or pPlayer.m_iCallNumber ) + " (/pickup чтобы ответить; /h(angup) чтобы сбросить)", 255, 255, 0 );
					
					if not pPlr:IsAdmin() then
						pPlr:Me( "звонит телефон" );
					end
					
					pPlayer:Me( "звонит по телефону" );
					
					pPlayer:SetAnimation( CPlayerAnimation.PRIORITY_PHONE, "PED", "phone_in", 1, false, true, false, true );
					
					if bHidden then
						return "Внимание! Ваш номер будет скрыт!", 255, 128, 0;
					end
			
					return true;
				end
				
				return "Номер занят", 255, 64, 0;
			end
		end
		
		pPlayer.m_iCallNumber = NULL;
		
		return "Телефон абонента выключен или находится вне зоны действия сети", 255, 128, 0;
	end
	
	return true;
end

function CCommands:PhoneSMS( pPlayer, sCmd, iNumber, ... )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		if pPlayer:IsCuffed() then
			CCommands:PhoneHangup( pPlayer );
			
			return "Вы не можете писать SMS в наручниках", 255, 0, 0;
		end
		
		if pPlayer.m_bLowHPAnim then
			CCommands:PhoneHangup( pPlayer );
			
			return "Вы не в состоянии пользоваться телефоном", 255, 0, 0;
		end
		
		if pPlayer.m_iCallNumber then
			return "Вы не можете писать SMS и говорить по телефону одновременно", 255, 0, 0;
		end

		iNumber = tonumber( iNumber );
		
		local sMessage = table.concat( { ... }, ' ' );
		
		if iNumber == NULL or sMessage:len() == 0 then
			return "Syntax: /" + sCmd + " <number> <message>", 255, 255, 255;
		end
		
		-- if pChar:GetMoney() > 0 then
			for _, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
				if pPlr:IsInGame() and pPlr:GetChar():GetPhoneNumber() == iNumber then
					pPlayer:Me( "достаёт телефон" );
					pPlayer:GetChat():Send( "Сообщение на номер " + iNumber + " успешно отправлено: " + sMessage, 255, 255, 0 );
					
					pPlr:Popup( "mail", "SMS: №" + pChar:GetPhoneNumber(), sMessage );
					
					g_pServer:Print( "SMS: From %s (%s) [%d] to %s (%s) [%d]: %s", pPlayer:GetName(), pPlayer:GetUserName(), pChar:GetPhoneNumber(), pPlr:GetName(), pPlr:GetUserName(), iNumber, sMessage );
					
					return true;
				end
			end
			
			return "Телефон абонента выключен или находится вне зоны действия сети", 255, 128, 0;
		-- else
			-- return "У Вас недостаточно средств на счету", 255, 0, 0;
		-- end
	end
	
	return true;
end

function CCommands:ToggleInventory( pPlayer, sCmd )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		pChar:ToggleInventory();
	end
	
	return true;
end

function CCommands:Offer( pPlayer, sCmd, sOption, sTarget )
	local pChar = pPlayer:GetChar();
	
	if not pChar then
		return true;
	end
	
	if not sTarget then
		return false;
	end
	
	local pTarget = g_pGame:GetPlayerManager():Get( sTarget );
	
	if not pTarget then
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	if pTarget == pPlayer then
		return "Команда не применима к самому себе", 255, 0, 0 ;
	end
	
	if not pTarget:IsInGame() then
		return TEXT_PLAYER_NOT_IN_GAME, 255, 0, 0;
	end
	
	if pTarget:IsAdmin() or pTarget:GetDimension() ~= pPlayer:GetDimension() or pPlayer:GetPosition():Distance( pTarget:GetPosition() ) > 2 then
		return TEXT_PLAYER_NOT_NEARBY, 255, 0, 0;
	end
	
	local sOfferTitle	= NULL;
	
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
	
	local sTick = (string)(getTickCount());
	
	if not pTarget.m_Offers then
		pTarget.m_Offers = {};
	end
	
	pTarget.m_Offers[ sTick ] = { pOffer = pPlayer, sOption = sOption };
	
	pTarget:Client().Offer( pPlayer:GetVisibleName(), pPlayer:Gender( "предложил", "предложила", "предложил(а)" ), sOfferTitle, sTick );
	
	pPlayer:Hint( "Information", "Вы предложили " + pTarget:GetName() + " " + sOfferTitle, "info" );
	
	return true;
end
