-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CPlayerCommands"

function CPlayerCommands:Jail( pPlayer, sCmd, sOption, sPlayerID, siMinutes, ... )
	local iMinutes	= (int)(siMinutes);
	local sReason	= table.concat( { ... }, ' ' );
	
	if sPlayerID and iMinutes and sReason:len() > 0 then
		local pTarget = g_pGame:GetPlayerManager():Get( sPlayerID );
		
		if pTarget then
			if pTarget:IsInGame() then
				if pTarget:GetID() == pPlayer:GetID() or pPlayer:GetUserID() == 1 or not pTarget:HaveAccess( "general.immunity" ) then
					pTarget:GetChar():SetJailed( "Admin", iMinutes * 60 );
					
					local date = getRealTime();
					
					outputChatBox( ( "%s посажен в бан зону на %s %s, причина: %s (%02d-%02d-%04d)" ):format( pTarget:GetName(), iMinutes, math.decl( iMinutes, 'минуту', 'минуты', 'минут' ), sReason, date.monthday, date.month + 1, date.year + 1900 ), root, 255, 64, 0 );
					
					g_pAdminLog:Write( "%s jailed %s (%s) to ban zone (%s)", pPlayer:GetUserName(), pTarget:GetName(), pTarget:GetUserName(), sReason );
					
					return true;
				end
				
				return TEXT_PLAYER_HAS_IMMUNITY, 255, 0, 0;
			end
			
			return TEXT_PLAYER_NOT_IN_GAME, 255, 0, 0;
		end
		
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	return false;
end

function CPlayerCommands:Slap( pPlayer, sCmd, sOption, sPlayerID, sForce )
	if sPlayerID then
		local pTarget = g_pGame:GetPlayerManager():Get( sPlayerID );
		
		if pTarget then
			if pTarget:IsInGame() then
				if pTarget:GetID() == pPlayer:GetID() or pPlayer:GetUserID() == 1 or not pTarget:HaveAccess( "general.immunity" ) then
					local fForce = tonumber( sForce ) or 2;
					
					if pTarget:IsInVehicle() then
						pTarget:RemoveFromVehicle();
						pTarget:SetPosition( pTarget:GetPosition() + Vector3( 0, 0, 3 ) );
					end
					
					pTarget:SetVelocity( pTarget:GetVelocity() + Vector3( 0, 0, fForce * .1 ) );
					
					SendAdminsMessage( pPlayer:GetUserName() + " подкинул " + pTarget:GetName() );
					
					return true;
				end
				
				return TEXT_PLAYER_HAS_IMMUNITY, 255, 0, 0;
			end
			
			return TEXT_PLAYER_NOT_IN_GAME, 255, 0, 0;
		end
		
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	return false;
end

function CPlayerCommands:Kick( pPlayer, sCmd, sOption, sTargetPlayer, ... )
	local sReason = table.concat( { ... }, ' ' );
	
	if sTargetPlayer and sReason:len() > 0 then
		local pTarget = g_pGame:GetPlayerManager():Get( sTargetPlayer );
		
		if pTarget then
			if pPlayer:GetUserID() == 1 or not pTarget:HaveAccess( "general.immunity" ) then
				local date = getRealTime();
				
				outputChatBox( ( "%s кикнут с сервера, причина: %s (%02d-%02d-%04d)" ):format( pTarget:GetName(), sReason, date.monthday, date.month + 1, date.year + 1900 ), root, 255, 64, 0 );
				
				pTarget:Kick( sReason );
				
				g_pAdminLog:Write( "%s kicked %s (%s)", pPlayer:GetUserName(), pTarget:GetName(), sReason );
				
				return true;
			end
			
			return TEXT_PLAYER_HAS_IMMUNITY, 255, 0, 0;
		end
		
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	return false;
end

function CPlayerCommands:Mute( pPlayer, sCmd, sOption, sTargetPlayer, sTime, ... )
	local iTime		= tonumber( sTime );
	local sReason	= table.concat( { ... }, ' ' );
	
	if sTargetPlayer and iTime and sReason:len() > 0 then
		local pTarget = g_pGame:GetPlayerManager():Get( sTargetPlayer );
		
		if pTarget then
			if pPlayer == pTarget or pPlayer:GetUserID() == 1 or not pTarget:HaveAccess( "general.immunity" ) then
				local date = getRealTime();
				
				-- if iTime > 0 then
					pTarget:GetChat():Send( "Вы лишены права пользоваться чатом на " + iTime + math.decl( iTime, ' минуту', ' минуты', ' минут' ) + "!", 255, 0, 0 );
				-- end
				
				g_pAdminLog:Write( "%s muted %s (%s) (%s)", pPlayer:GetUserName(), pTarget:GetName(), pTarget:GetUserName(), sReason );
				
				pTarget:SetMuted( iTime );
			else
				pPlayer:GetChat():Error( TEXT_PLAYER_HAS_IMMUNITY ); 
			end
		else
			pPlayer:GetChat():Error( TEXT_PLAYER_NOT_FOUND );
		end
		
		return true;
	end
	
	return false;
end

function CPlayerCommands:Ban( pPlayer, sCmd, sOption, sTargetPlayer, sMinutes, ... )
	local sReason	= table.concat( { ... }, ' ' );
	local iMinutes	= tonumber( sMinutes );
	
	if sTargetPlayer and iMinutes and sReason:len() > 0 then
		local pTarget = g_pGame:GetPlayerManager():Get( sTargetPlayer );
		
		if pTarget then
			if pPlayer:GetUserID() == 1 or not pTarget:HaveAccess( "general.immunity" ) then
				local date	= getRealTime();
				local times	= "";
				
				iMinutes = Clamp( 0, iMinutes, 10080 );
				
				if iMinutes == 0 then
					times = 'перманентно';
				elseif iMinutes < 60 then
					times = 'на ' + iMinutes + math.decl( iMinutes, 'минуту', 'минуты', 'минут' );
				elseif iMinutes < 1440 then
					times = 'на ' + math.floor( iMinutes / 60 ) + math.decl( math.floor( iMinutes / 60 ), 'час', 'часа', 'часов' );
				else
					times = 'на ' + math.floor( iMinutes / 1440 ) + math.decl( math.floor( iMinutes / 1440 ), 'день', 'дня', 'дней' );
				end
				
				local msg = ( "%s забанен %s, причина: %s (%02d-%02d-%04d)" ):format( pTarget:GetName(), times, sReason, date.monthday, date.month + 1, date.year + 1900 );
				
				outputChatBox( msg, root, 255, 64, 0 );
				
				printf( msg );
				
				g_pAdminLog:Write( "%s banned %s (%s) (%s)", pPlayer:GetUserName(), pTarget:GetName(), pTarget:GetUserName(), sReason );
				
				pTarget:Ban( sReason, iMinutes * 60, pPlayer );
			else
				pPlayer:GetChat():Error( TEXT_PLAYER_HAS_IMMUNITY ); 
			end
		else
			pPlayer:GetChat():Error( TEXT_PLAYER_NOT_FOUND );
		end
		
		return true;
	end
	
	return false;
end

function CPlayerCommands:Unban( pPlayer, sCmd, sOption, sSerial )
	if sSerial and sSerial:len() > 0 then
		sSerial = sSerial:upper();
		
		for _, pBan in ipairs( CBan.GetAll() ) do
			if pBan:GetSerial() == sSerial then
				pBan:Remove();
				
				SendAdminsMessage( pPlayer:GetUserName() + ' разбанил серийный номер ' + sSerial );
				
				g_pAdminLog:Write( "%s unlocked serial %s", pPlayer:GetUserName(), sSerial );
				
				return true;
			end
		end
		
		pPlayer:GetChat():Send( "Серийный номер " + sSerial + " не найден в списке заблокированных", 255, 0, 0 );
		
		return true;
	end
	
	return false;
end

function CPlayerCommands:SetName( pPlayer, sCmd, sOption, sTargetPlayer, sName, sSurname )
	if sTargetPlayer and sName and sName:len() > 0 and sSurname and sSurname:len() > 0 then
		local pTarget = g_pGame:GetPlayerManager():Get( sTargetPlayer );
		
		if pTarget then
			if pTarget:IsInGame() then
				if pTarget == pPlayer or pPlayer:GetUserID() == 1 or not pTarget:HaveAccess( "general.immunity" ) then
					local sOldName = pTarget:GetChar():GetName();
					
					local _, iError = pTarget:GetChar():SetName( sName, sSurname );
					
					if not iError then
						SendAdminsMessage( TEXT_PLAYER_NAME_CHANGED_A:format( pPlayer:GetUserName(), sOldName, pTarget:GetName() ) );
						pTarget:GetChat():Send( TEXT_PLAYER_NAME_CHANGED2:format( pPlayer:GetAdminName(), sOldName, pTarget:GetName() ), 0, 255, 255 );
						
						return true;
					elseif iError == 0 then
						return TEXT_PLAYER_INVALID_NAME, 255, 0, 0;
					elseif iError == 1 then
						return TEXT_PLAYER_NAME_CHANGE_FAILED, 255, 0, 0;
					elseif iError == 2 then
						return TEXT_PLAYER_NAME_ALREADY_IN_USE, 255, 0, 0;
					elseif iError == 3 then
						return TEXT_DB_ERROR, 255, 0, 0;
					end
				end
				
				return TEXT_PLAYER_HAS_IMMUNITY, 255, 0, 0;
			end
			
			return TEXT_PLAYER_NOT_IN_GAME, 255, 0, 0;
		end
		
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	return false;
end

function CPlayerCommands:SetHealth( pPlayer, sCmd, sOption, sTargetPlayer, sHealth )
	if sTargetPlayer then
		local pTarget = g_pGame:GetPlayerManager():Get( sTargetPlayer );
		
		if pTarget then
			if pTarget:IsInGame() then
				if pTarget == pPlayer or pPlayer:GetUserID() == 1 or not pTarget:HaveAccess( "general.immunity" ) then
					local fHealth = Clamp( 0, tonumber( sHealth ) or 0, 1000 );
					
					pTarget:SetHealth( fHealth );
					
					SendAdminsMessage( pPlayer:GetUserName() + " установил уровень здоровья игроку " + pTarget:GetVisibleName() + " на " + fHealth );
				else
					pPlayer:GetChat():Error( TEXT_PLAYER_HAS_IMMUNITY ); 
				end
			else
				pPlayer:GetChat():Error( TEXT_PLAYER_NOT_IN_GAME );
			end
		else
			pPlayer:GetChat():Error( TEXT_PLAYER_NOT_FOUND );
		end
		
		return true;
	end
	
	return false;
end

function CPlayerCommands:SetArmor( pPlayer, sCmd, sOption, sTargetPlayer, sArmor )
	if sTargetPlayer then
		local pTarget = g_pGame:GetPlayerManager():Get( sTargetPlayer );
		
		if pTarget then
			if pTarget:IsInGame() then
				if pTarget == pPlayer or pPlayer:GetUserID() == 1 or not pTarget:HaveAccess( "general.immunity" ) then
					local fArmor = Clamp( 0, tonumber( sArmor ) or 0, 1000 );
					
					pTarget:SetArmor( fArmor );
					
					SendAdminsMessage( pPlayer:GetUserName() + " установил уровень брони игроку " + pTarget:GetVisibleName() + " на " + fArmor );
				else
					pPlayer:GetChat():Error( TEXT_PLAYER_HAS_IMMUNITY ); 
				end
			else
				pPlayer:GetChat():Error( TEXT_PLAYER_NOT_IN_GAME );
			end
		else
			pPlayer:GetChat():Error( TEXT_PLAYER_NOT_FOUND );
		end
		
		return true;
	end
	
	return false;
end

function CPlayerCommands:SetSkin( pPlayer, sCmd, sOption, sTargetPlayer, sSkin )
	local iSkin = tonumber( sSkin );
	
	if sTargetPlayer and iSkin then
		local pTarget = g_pGame:GetPlayerManager():Get( sTargetPlayer );
		
		if pTarget then
			if pTarget:IsInGame() then
				if pTarget == pPlayer or pPlayer:GetUserID() == 1 or not pTarget:HaveAccess( "general.immunity" ) then
					local pSkin = CPed.GetSkin( iSkin );
					
					if pTarget:GetChar():SetSkin( pSkin ) then
						pTarget:GetChat():Send( TEXT_PLAYER_SKIN_CHANGED:format( pPlayer:GetAdminName(), pSkin:GetID(), pSkin:GetName() ), 0, 255, 255 );
					else
						pPlayer:GetChat():Error( TEXT_PLAYER_INVALID_SKIN );
					end
				else
					pPlayer:GetChat():Error( TEXT_PLAYER_HAS_IMMUNITY ); 
				end
			else
				pPlayer:GetChat():Error( TEXT_PLAYER_NOT_IN_GAME );
			end
		else
			pPlayer:GetChat():Error( TEXT_PLAYER_NOT_FOUND );
		end
		
		return true;
	end
	
	return false;
end

function CPlayerCommands:SetMoney( pPlayer, sCmd, sOption, sTargetPlayer, sMoney )
	local iMoney = tonumber( sMoney );
	
	if sTargetPlayer and iMoney then
		local pTarget = g_pGame:GetPlayerManager():Get( sTargetPlayer );
		
		if pTarget then
			if pTarget:IsInGame() then
				if pTarget == pPlayer or pPlayer:GetUserID() == 1 or not pTarget:HaveAccess( "general.immunity" ) then
					pTarget:GetChar():SetMoney( iMoney );
					
					pPlayer:GetChat():Send( TEXT_PLAYER_SET_MONEY:format( pTarget:GetName(), pTarget:GetID(), iMoney ), 0, 255, 0 );
				else
					pPlayer:GetChat():Error( TEXT_PLAYER_HAS_IMMUNITY ); 
				end
			else
				pPlayer:GetChat():Error( TEXT_PLAYER_NOT_IN_GAME );
			end
		else
			pPlayer:GetChat():Error( TEXT_PLAYER_NOT_FOUND );
		end
		
		return true;
	end
	
	return false;
end

function CPlayerCommands:GiveMoney( pPlayer, sCmd, sOption, sTargetPlayer, sMoney )
	local iMoney = tonumber( sMoney );
	
	if sTargetPlayer and iMoney then
		local pTarget = g_pGame:GetPlayerManager():Get( sTargetPlayer );
		
		if pTarget then
			if pTarget:IsInGame() then
				if pTarget == pPlayer or pPlayer:GetUserID() == 1 or not pTarget:HaveAccess( "general.immunity" ) then
					pTarget:GetChar():GiveMoney( iMoney );
					
					return TEXT_PLAYER_GIVE_MONEY:format( pTarget:GetName(), pTarget:GetID(), iMoney ), 0, 255, 0;
				end
				
				return TEXT_PLAYER_HAS_IMMUNITY, 255, 0, 0;
			end
			
			return TEXT_PLAYER_NOT_IN_GAME, 255, 0, 0;
		end
		
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	return false;
end

function CPlayerCommands:Warp( pClient, sCmd, sOption, sPlayer1, sPlayer2 )
	if not sPlayer1 or not sPlayer2 then
		return false;
	end
	
	local pPlayer1 = g_pGame:GetPlayerManager():Get( sPlayer1 );
	
	if not pPlayer1 then
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	if not pPlayer1:IsInGame() then
		return TEXT_PLAYER_NOT_IN_GAME, 255, 0, 0;
	end
	
	local pPlayer2 = g_pGame:GetPlayerManager():Get( sPlayer2 );
	
	if not pPlayer2 then
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	if not pPlayer2:IsInGame() then
		return TEXT_PLAYER_NOT_IN_GAME, 255, 0, 0;
	end
	
	if pPlayer1 ~= pPlayer2 and pPlayer1 ~= pClient and pClient:GetUserID() ~= 1 and pPlayer1:HaveAccess( "general.immunity" ) then
		return TEXT_PLAYER_HAS_IMMUNITY, 255, 0, 0;
	end
	
	local vecPosition		= pPlayer2:GetPosition();
	
	local vecNewPosition	= vecPosition:Offset( 1.2, pPlayer2:GetRotation() );
	local vecNewRotation	= Vector3( 0.0, 0.0, pPlayer2:GetRotation() + 180.0 );
	local iNewInterior		= pPlayer2:GetInterior();
	local iNewDimension		= pPlayer2:GetDimension();
	
	pPlayer1:SetInterior( iNewInterior );
	pPlayer1:SetDimension( iNewDimension );
	
	local pVehicle = pPlayer1:GetVehicle();
	
	if pVehicle then
		if pPlayer1:GetVehicleSeat() == 0 and not pPlayer2:IsInVehicle() then
			pVehicle:SetPosition( vecNewPosition );
			pVehicle:SetInterior( iNewInterior );
			pVehicle:SetDimension( iNewDimension );
			pVehicle:SetRotation( vecNewRotation );
			
			return true;
		end
		
		pPlayer1:RemoveFromVehicle();
		pPlayer1:GetCamera():SetTarget();
	end
	
	local pVehicle = pPlayer2:GetVehicle();
	
	if pVehicle then
		for iSeat = 0, pVehicle:GetMaxPassengers() do
			if not pVehicle:GetOccupant( iSeat ) then
				pPlayer1:WarpInVehicle( pVehicle, iSeat );
				
				return true;
			end
		end
	end
	
	pPlayer1:SetPosition( vecNewPosition );
	pPlayer1:SetRotation( vecNewRotation.Z );
	
	return true;
end

function CPlayerCommands:Get( pClient, sCmd, sOption, sTargetPlayer )
	if not sTargetPlayer then
		return false;
	end
	
	return CPlayerCommands:Warp( pClient, sCmd, sOption, sTargetPlayer, pClient:GetID() );
end

function CPlayerCommands:Goto( pClient, sCmd, sOption, sTargetPlayer )
	if not sTargetPlayer then
		return false;
	end
	
	return CPlayerCommands:Warp( pClient, sCmd, sOption, pClient:GetID(), sTargetPlayer );
end

function CPlayerCommands:Reconnect( pPlayer, sCmd, sOption, sTargetPlayer )
	if sTargetPlayer then
		local pTarget = g_pGame:GetPlayerManager():Get( sTargetPlayer );
		
		if pTarget then
			if pTarget == pPlayer or pPlayer:GetUserID() == 1 or not pTarget:HaveAccess( "general.immunity" ) then
				pPlayer:GetChat():Send( TEXT_PLAYER_RECONNECTED:format( pTarget:GetName(), pTarget:GetID() ), 64, 255, 0 );
				
				pTarget:Redirect();
			else
				pPlayer:GetChat():Error( TEXT_PLAYER_HAS_IMMUNITY ); 
			end
		else
			pPlayer:GetChat():Error( TEXT_PLAYER_NOT_FOUND );
		end
		
		return true;
	end
	
	return false;
end

function CPlayerCommands:Spectate( pPlayer, sCmd, sOption, sTargetPlayer )
	if sTargetPlayer or pPlayer:IsSpectating() then
		if sTargetPlayer == 'next' or sTargetPlayer == 'prev' then
			local pCurrentTarget = pPlayer:GetSpectating();
			
			if pCurrentTarget then
				local pTarget	= NULL;
				local iID		= pCurrentTarget:GetID();
				local iMaxID	= iID;
				local Players	= g_pGame:GetPlayerManager():GetAll();				
				
				for key in pairs( Players ) do
					if key > iMaxID then
						iMaxID = key;
					end
				end
				
				repeat
					iID = sTargetPlayer == 'next' and ( iID + 1 ) % iMaxID or ( iID - 1 ) % iMaxID;
					
					pTarget = Players[ iID + 1 ];
					
				until pTarget;
				
				if pTarget == pPlayer then
					return true;
				end
				
				pPlayer:SetSpectating( pTarget );
			end
		else
			local pTarget = g_pGame:GetPlayerManager():Get( sTargetPlayer );
			
			if pTarget then
				pPlayer:SetSpectating( pTarget );
			elseif pPlayer:IsSpectating() then
				pPlayer:SetSpectating();
			else
				pPlayer:GetChat():Error( TEXT_PLAYER_NOT_FOUND );
			end
		end
		
		return true;
	end
	
	return false;
end

function CPlayerCommands:SetFaction( pPlayer, sCmd, sOption, sTargetPlayer, sFactionID, sRank, xRights )
	local iFactionID	= tonumber( sFactionID );
	local iRank			= tonumber( sRank ) or 1;
	local xRights		= (int)(xRights);
	
	do
		return "Команда временно отключена", 255, 255, 0;
	end
	
	if sTargetPlayer and iFactionID then
		local pTarget = g_pGame:GetPlayerManager():Get( sTargetPlayer );
		
		if pTarget and pTarget:IsInGame() then
			local pPlayerChar = pTarget:GetChar();
			
			if iFactionID == 0 then
				pPlayerChar:SetFaction();
				
				pPlayer:GetChat():Send( TEXT_PLAYER_FACTION_REMOVED:format( pTarget:GetName(), pTarget:GetID() ), 0, 255, 255 );
				pTarget:GetChat():Send( TEXT_PLAYER_FACTION_REMOVED2:format( pPlayer:GetAdminName() ), 0, 255, 255 );
			else
				local pFaction = g_pGame:GetFactionManager():Get( iFactionID );
				
				if pFaction then
					if xRights then
						if pFaction:GetRanks()[ iRank ] then
							pPlayerChar:SetFaction( pFaction, iDept or 1, iRank, xRights );
							pPlayerChar:SetFactionRights( sRights );
							pPlayerChar:SetFactionRank( iRank );
							
							pPlayer:GetChat():Send( TEXT_PLAYER_FACTION_CHANGED:format( pTarget:GetName(), pTarget:GetID(), pFaction:GetName(), xRights, pFaction:GetRanks()[ iRank ], iRank ), 0, 255, 255 );
							pTarget:GetChat():Send( TEXT_PLAYER_FACTION_CHANGED2:format( pPlayer:GetAdminName(), pFaction:GetName(), xRights, pFaction:GetRanks()[ iRank ], iRank ), 0, 255, 255 );
						else
							pPlayer:GetChat():Error( TEXT_FACTIONS_INVALID_RANK );
						end
					else
						pPlayer:GetChat():Error( TEXT_FACTIONS_INVALID_RIGHTS );
					end
				else
					pPlayer:GetChat():Error( TEXT_FACTIONS_INVALID_ID );
				end
			end
		else
			pPlayer:GetChat():Error( TEXT_PLAYER_NOT_FOUND );
		end
		
		return true;
	end
	
	return false;
end

function CPlayerCommands:GiveItem( pClient, sCmd, sOption, sItem, ... )
	if not sItem then
		return false;
	end
	
	local TItem	= g_pGame:GetItemManager():GetItem( sItem );
	
	if not TItem then
		return "Предмета с именем '" + sItem + "' не существует", 255, 0, 0;
	end
	
	local pChar, iValue, fCondition, Data;
	
	for Param, Value in CCommand:ReadParams( ... ) do
		if Param == "player" then
			local pPlayer = g_pGame:GetPlayerManager():Get( Value );
			
			if not pPlayer then
				return "Не удалось найти игрока с данными '" + Value + "'", 255, 0, 0;
			end
			
			pChar = pPlayer:GetChar();
			
			if not pChar then
				return "Игрок " + pPlayer:GetVisibleName() + " не в игре", 255, 0, 0;
			end
		elseif Param == "value" then
			iValue = tonumber( Value );
			
			if not iValue then
				return "Invalid value for option --value", 255, 0, 0;
			end
		elseif Param == "condition" then
			
			fCondition = tonumber( Value );
			
			if not fCondition or fCondition < 0 or fCondition > 100 then
				return "Invalid value for option --condition", 255, 0, 0;
			end
		elseif Param == "data" then
			
		end
	end
	
	if pChar == NULL then
		pChar = pClient:GetChar();
		
		if not pChar then
			return "Невозможно дать предмет Вашему персонажу - его не существует", 255, 0, 0;
		end
	end
	
	if pChar:GiveItem( TItem, iValue, fCondition, Data ) then
		return "Предмет " + sItem + " успешно выдан", 0, 255, 0;
	end
	
	return "Ошибка при попытке выдать предмет", 255, 0, 0;
end

function CPlayerCommands:GetPosition( pPlayer, sCmd, sOption, sTargetPlayer )
	local pTarget = g_pGame:GetPlayerManager():Get( ( sTargetPlayer and pPlayer:HaveAccess( "command.adminduty" ) ) or pPlayer:GetID() );
	
	if pTarget then
		local vecPosition = pTarget:GetPosition();
		
		pPlayer:GetChat():Send( ( "*%s [%d]: ( %.3f, %.3f, %.3f ) Int: %i, Dim: %d" ):format( pTarget:GetName(), pTarget:GetID(), vecPosition.X, vecPosition.Y, vecPosition.Z, pPlayer:GetInterior(), pPlayer:GetDimension() ), 255, 200, 0 );
	else
		pPlayer:GetChat():Error( TEXT_PLAYER_NOT_FOUND );
	end
	
	return true;
end

function CPlayerCommands:PayDay( pPlayer, sCmd, sOption, sbForce )
	for _, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
		if pPlr:IsInGame() then
			pPlr:PayDay( (bool)(sbForce) );
		end
	end
	
	return true;
end

function CPlayerCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end