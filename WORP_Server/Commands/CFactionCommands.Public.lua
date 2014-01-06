-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

-- Flag: news
local SN_BASE_POSITION		= Vector3( 363.486, 271.150, 1008.673 );
local SN_BASE_INTERIOR		= 2;
local SN_BASE_DIMENSION		= 229;

function CFactionCommands:Show( pClient )
	local pChar = pClient:GetChar();
	
	if pChar then
		( pChar:GetFaction() or CFaction ):Show( pClient );
	end
	
	return true;
end

function CFactionCommands:Menu( pClient, sCmd, sOption, ... )
	local pChar = pClient:GetChar();
	
	if pChar then
		local pFaction = pChar:GetFaction();
		
		if pFaction then
			pFaction:ShowMenu( pClient );
		end
	end
	
	return true;
end

function CFactionCommands:New( pClient, sCmd, sOption, ... )
	local pChar = pClient:GetChar();
	
	if not pChar then
		return true;
	end
	
	if not ( ... ) then
		return false;
	end
	
	local pResult = g_pDB:Query( "SELECT id, registered FROM " + DBPREFIX + "factions WHERE owner_id = " + pClient:GetChar():GetID() + " LIMIT 1" );
	
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
	
	-- local sCommand	= table.concat( { ... }, " " ):gsub( [[(--([%w_]+)=([А-Яа-я%w%p%s]+))]], [[--%2="%3"]] );
	
	local Params	= {};
	local sParam	= NULL;
	
	for i, sString in ipairs( { ... } ) do
		if sString:sub( 1, 2 ) == "--" then
			sParam = sString:sub( 3, sString:len() );
		elseif sParam then
			Params[ sParam ] = ( Params[ sParam ] or "" ) + " " + sString;
		end
	end
	
	local Data		= {};
	
	-- for Param, Value in sCommand:gmatch( [[--([%w_]+)="(.*)"]] ) do
	for Param, Value in pairs( Params ) do
		Value = Value:gsub( "%%", "" ):trim();
		
		if Param == "name" then
			if not not Value:find( "[\\'\"\;]" ) then
				return "Имя организации содержит запрещённые символы", 255, 0, 0;
			end
			
			if Value:len() < 8 then
				return "Имя организации слишком короткое", 255, 0, 0;
			end
			
			if Value:len() > 64 then
				return "Имя организации слишком длинное", 255, 0, 0;
			end
		elseif Param == "tag" then
			if not not Value:find( "[\\'\"\;]" ) then
				return "Аббревиатура организации содержит запрещённые символы", 255, 0, 0;
			end
			
			if Value:len() < 3 then
				return "Аббревиатура организации слишком короткая", 255, 0, 0;
			end
			
			if Value:len() > 8 then
				return "Аббревиатура организации слишком длинная", 255, 0, 0;
			end
		elseif Param == "property" then
			local iInteriorID = Value:ToNumber();
			
			if not iInteriorID then
				return "Не верный адрес регистрации (не верный ID)", 255, 0, 0;
			end
			
			local pInterior = g_pGame:GetInteriorManager():Get( iInteriorID );
			
			if not pInterior then
				return "Не верный адрес регистрации (не существует)", 255, 0, 0;
			end
			
			if pInterior.m_sType ~= INTERIOR_TYPE_COMMERCIAL then
				return "Только коммерческую недвижимость можно оформить на предприятие", 255, 0, 0;
			end
			
			if pInterior.m_iCharacterID ~= pChar:GetID() then
				return "Эта недвижимость не принадлежит вам", 255, 0, 0;
			end
			
			if pInterior.m_iFactionID ~= 0 then
				return "Эта недвижимость уже оформлена на другую организацию";
			end
			
			Value	= pInterior:GetID();
			Param	= "property_id";
		elseif Param == "type" then
			Value = (int)(Value);
			
			if not eFactionType[ Value ] then
				return "Не правильный тип организации", 255, 0, 0;
			end			
		end
		
		Data[ Param ] = Value;
	end
	
	if sizeof( Data ) > 0 then
		local pResult	= g_pDB:Query( "SELECT SUM( name = %q ) AS name, SUM( tag = %q ) AS tag FROM " + DBPREFIX + "factions", Data[ "name" ], Data[ "tag" ] );
		
		if pResult then
			local pRow = pResult:FetchRow();
			
			delete ( pResult );
			
			if pRow then
				if pRow.name and pRow.name ~= 0 then
					return "Организация с таким именем уже существует", 255, 0, 0;
				end
				
				if pRow.tag and pRow.tag ~= 0 then
					return "Организация с такой аббревиатурой уже существует", 255, 0, 0;
				end
			end
		else
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		Data[ "owner_id" ] = pClient:GetChar():GetID();
		
		local iFactionID = g_pGame:GetFactionManager():Create( CFaction, Data[ "name" ], Data[ "tag" ], Data );
		
		if iFactionID then
			pClient:GetChar():HideUI( "CUIFactionCreate" );
			
			return sCmd and "Ваша заявка на регистрацию организации успешно отправлена" or true, 0, 255, 0;
		end
		
		return TEXT_DB_ERROR, 255, 0, 0;
	end
	
	return false;
end

function CFactionCommands:Government( pClient, sCmd, ... )
	local pChar = pClient:GetChar();
	
	if pChar then
		local sMessage = table.concat( { ... }, ' ' );
		
		if sMessage:len() > 0 then
			outputChatBox( "  Сообщение от Администрации штата", root, 255, 100, 0 );
			outputChatBox( "  " + pClient:GetName():gsub( '_', ' ' ) + ': ' + sMessage, root, 255, 100, 0 );
			
			g_pServer:Print( "GOV: %s (%s): %s", pClient:GetName(), pClient:GetUserName(), sMessage:gsub( '%%', '%%%%' ) );
			
			return true;
		end
		
		return "Syntax: /" + sCmd + " <message>", 255, 255, 255;
	end
end

function CFactionCommands:GiveLicense( pClient, sCmd, iPlayer, sLicence )
	local pChar = pClient:GetChar();
	
	if not pChar then
		return true;
	end
	
	if not iPlayer or not sLicence then
		return "Syntax: /" + sCmd + " <player> <license>", 255, 255, 255;
	end
	
	local pPlayer = g_pGame:GetPlayerManager():Get( iPlayer );
	
	if not pPlayer then
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	if not pPlayer:IsAdmin() then
		local pFaction = pChar:GetFaction();
		
		if pFaction then
			local pProperty = g_pGame:GetInteriorManager():Get( pFaction.m_iPropertyID );
			
			if not pProperty or not pProperty:IsElementInside( pClient ) then
				return "Лицензии можно выдавать только в автошколе", 255, 0, 0;
			end
			
			if not pProperty:IsElementInside( pPlayer ) then
				return TEXT_PLAYER_NOT_NEARBY, 255, 0, 0;
			end
		else
			return TEXT_ACCESS_DENIED, 255, 0, 0;
		end
	end
	
	local pLicense = pPlayer:GetChar():GiveLicense( sLicence );
	
	if pLicense then
		pPlayer:GetChat():Send( pClient:GetVisibleName() + " выдал Вам " + pLicense:GetName2(), 0, 128, 255 );
		
		return "Вы выдали игроку " + pPlayer:GetName() + " " + pLicense:GetName2(), 0, 255, 255;
	end
	
	return "Ошибка при выдаче лицензии. Возможно было указанно неверное имя лицензии", 255, 0, 0;
end

function CFactionCommands:News( pPlayer, sCmd, ... )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		local pFaction = pChar:GetFaction();
		
		if ( pFaction and pFaction:HaveFlag( 'news' ) ) or pPlayer.m_bCmdNews then
			local sMessage = table.concat( { ... }, ' ' );
			
			if sMessage:len() > 0 then
				local vecPosition	= pPlayer:GetPosition();
				local pVehicle		= pPlayer:GetVehicle();
				
				if ( pVehicle and pVehicle:GetFaction() == pFaction ) or ( vecPosition:Distance( SN_BASE_POSITION ) < 15 and pPlayer:GetInterior() == SN_BASE_INTERIOR and pPlayer:GetDimension() == SN_BASE_DIMENSION ) then				
					if pPlayer:IsMuted() then
						return "У Вас молчанка, Вы не можете говорить", 255, 128, 0;
					end
					
					local sText = ( "Радио %s: (( %d )): %s" ):format( pFaction:GetTag(), pPlayer:GetID(), sMessage );
					
					for i, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
						if pPlr ~= pPlayer then						
							local pVeh = pPlr:IsInGame() and pPlr:GetVehicle();
							
							if pVeh and pPlr.m_pVehicle == pVeh and pVeh.m_bRadio then
								pPlr:GetChat():Send( sText, 222, 255, 0 );
							end
						end
					end
					
					self:LocalizedMessage( sText, 10.0, 7 );
					
					g_pServer:Print( sText:gsub( '%%', '%%%%' ) );
					
					return true;
				end
				
				return "Вы должны быть в студии или в транспорте San News", 255, 0, 0;
			end

			return "Syntax: /" + sCmd + " <ic text>", 255, 255, 255;
		end
		
		return "У Вас нет прав на использование этой команды", 255, 0, 0;
	end
end

function CFactionCommands:Live( pPlayer, sCmd, siPlayer, sbEnable )
	if siPlayer then
		local pPlayer2 = g_pGame:GetPlayerManager():Get( siPlayer );
		
		if pPlayer2 and pPlayer2:IsInGame() then
			if pPlayer2:GetChar():GetFaction() ~= pFaction then
				pPlayer2.m_bCmdNews = (bool)(sbEnable);
				
				pPlayer2:GetChat():Send( pPlayer:GetVisibleName() + " " + ( pPlayer2.m_bCmdNews and "разрешил" or "запретил" ) + " вам использование команды /news", 0, 255, 255 );
				return "Вы " + ( pPlayer2.m_bCmdNews and "разрешили" or "запретили" ) + " доступ " + pPlayer2:GetName() + " к команде /news", 0, 255, 255;
			end
			
			return pPlayer2:GetName() + " состоит во фракции репортёров", 255, 128, 0;
		end
			
		return "невозможно найти игрока '" + siPlayer + "'", 255, 0, 0;
	end
	
	return "Syntax: /" + sCmd + " <player> [enable = false]", 255, 255, 255
end

function CFactionCommands:Advert( pClient, sCmd, ... )
	local pChar		= pClient:GetChar();
	
	if pChar then
		local sText = table.concat( { ... }, ' ' );
		
		if sText:len() > 1 then
			local iPrice	= (int)(sText:len() * .5);
			
			if iPrice < 3 then
				return "Рекламное объявление слишком короткое", 255, 0, 0;
			end
			
			if pChar:GetMoney() >= iPrice then
				pChar:TakeMoney( iPrice );
				
				for iID, pFcn in pairs( g_pGame:GetFactionManager():GetAll() ) do
					if classof( pFcn ) == CFactionNews then
						pFcn:AddAdvert( pChar, sText, iPrice );
					end
				end
				
				return "Ваше объявление отправлено, ожидайте его проверки (-$" + iPrice + ")", 0, 255, 0;
			else
				return "У Вас недостаточно денег. - Стоимость подачи объявления: 1 символ = $0.5", 255, 0, 0;
			end
		else
			return "Syntax: /" + sCmd + " <text> - Стоимость подачи объявления: 1 символ = $0.5", 255, 0, 0;
		end
	end
end

function CFactionCommands:Heal( pClient, sCmd, sPlayer )
	if not pClient:IsInGame() then
		return false;
	end
	
	if not sPlayer then
		return "Syntax: /" + sCmd + " <player>", 255, 255, 255;
	end
	
	local pPlayer = g_pGame:GetPlayerManager():Get( sPlayer );
	
	if not pPlayer then
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	if pClient.m_pHealTimer then
		return "Вы не можете лечить сразу нескольких игроков", 255, 0, 0;
	end
	
	if pPlayer:GetID() == pClient:GetID() then
		return "Команда не применима к самому себе", 255, 0, 0;
	end
	
	if not pPlayer:IsInGame() then
		return TEXT_PLAYER_NOT_IN_GAME, 255, 0, 0;
	end
	
	local vecPlayerPosition = pPlayer:GetPosition();
	
	if pClient:GetPosition():Distance( vecPlayerPosition ) > 1.0 or pPlayer:IsAdmin() then
		return TEXT_PLAYER_NOT_NEARBY, 255, 0, 0;
	end
	
	if pPlayer:GetHealth() >= 100 then
		return "Этому игроку не требуется лечение", 255, 0, 0;
	end
	
	if not pClient:SetAnimation( CPlayerAnimation.PRIORITY_JOB, pPlayer.m_bLowHPAnim and "MEDIC" or "CRIB", pPlayer.m_bLowHPAnim and "CPR" or "CRIB_Use_Switch", pPlayer.m_bLowHPAnim and 5000 or 500, false, false, false, false ) then
		return "Команда не доступна в данный момент", 255, 0, 0;
	end
	
--	pClient:SetRotationAt( vecPlayerPosition );
	pClient.m_pHealTimer = CTimer(
		function()
			pClient.m_pHealTimer = NULL;
			
			if pPlayer:IsElement() and pPlayer:IsInGame() and pClient:GetPosition():Distance( pPlayer:GetPosition() ) <= 1 and not pPlayer:IsAdmin() then
				pPlayer:SetHealth( 100 );
			end
		end, pPlayer.m_bLowHPAnim and 7000 or 1000, 1
	);
	
	return true;
end

function CFactionCommands:Cuff( pClient, sCmd, sPlayer, bFollow )
	return CFactionCommands:SetCuffed( pClient, sCmd, sPlayer, true, bFollow );
end

function CFactionCommands:UnCuff( pClient, sCmd, sPlayer )
	return CFactionCommands:SetCuffed( pClient, sCmd, sPlayer, false );
end

function CFactionCommands:SetCuffed( pClient, sCmd, sPlayer, bCuffed, bFollow )
	local pChar = pClient:GetChar();
	
	if not pChar then
		return true;
	end
	
	if not sPlayer then
		return "Syntax: /" + sCmd + " <player> [cuffed (1/0 - true/false)] [follow = 1 (если 0 - игрок не будет идти за Вами)] ", 255, 255, 255;
	end
	
	local pPlayer = g_pGame:GetPlayerManager():Get( sPlayer );
	
	if not pPlayer then
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	if pClient:IsCuffed() then
		return "Ошибка: Вы в наручниках", 255, 0, 0;
	end
	
	if pPlayer:GetID() == pClient:GetID() then
		return "Команда не применима к самому себе", 255, 0, 0;
	end
	
	if pPlayer == NULL or not pPlayer:IsInGame() then
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;	
	end
	
	if pPlayer:IsAdmin() or pPlayer:GetPosition():DistanceTo( pClient:GetPosition() ) > 2.0 then
		return TEXT_PLAYER_NOT_NEARBY, 255, 0, 0;
	end
	
	if pPlayer:IsJailed() or pClient:IsJailed() then
		return "Команда не доступна для заключённых", 255, 0, 0;
	end
	
	if bCuffed == NULL then
		bCuffed	= not pPlayer:IsCuffed();
	else
		bCuffed = (bool)(bCuffed);
	end
	
	if bCuffed then
		if pPlayer:IsCuffed() then
			return "Этот игрок уже в наручниках", 128, 128, 128;
		end
		
		bFollow = bFollow == NULL and true or (bool)(bFollow);

		pPlayer:SetCuffed( true, bFollow and pClient or NULL );
		pPlayer:Hint( "Вы арестованы", pClient:GetVisibleName() + ( pClient:GetChar():GetSkin():GetGender() == "female" and " надела" or " надел" ) + " на Вас наручники", "info" );
		pPlayer:PlaySound3D( "Resources/Sounds/narcuffs.wav", .2 );

		pClient:Me( ( pClient:GetChar():GetSkin():GetGender() == "female" and "надела" or "надел" ) + " наручники на " + pPlayer:GetName() );
	else
		if not pPlayer:IsCuffed() then
			return "Этот игрок не в наручниках", 128, 128, 128;
		end
		
		pPlayer:SetCuffed();
		pPlayer:Hint( "Вы освобождены", pClient:GetVisibleName() + ( pClient:GetChar():GetSkin():GetGender() == "female" and " сняла" or " снял" ) + " с Вас наручники", "info" );
		
		pClient:Me( ( pClient:GetChar():GetSkin():GetGender() == "female" and "сняла" or "снял" ) + " наручники с " + pPlayer:GetName() );
	end
	
	return true;
end

function CFactionCommands:Arrest( pClient, sCmd, sPlayer, iMinutes )
	local pChar = pClient:GetChar();
	
	if not pChar then
		return true;
	end
	
	iMinutes = tonumber( iMinutes );
	
	local bIsFBI = pChar:GetFaction() and pChar:GetFaction():HaveFlag( eFactionFlags.fbi );
	
	if not sPlayer or not iMinutes then
		return "Sytax /" + sCmd + " <player> " + ( bIsFBI and "<minutes (от 0 до 120)>" or "<minutes (от 5 до 60)>" ), 255, 255, 255;
	end
	
	if pClient:IsJailed() then
		return "Команда не доступна для заключённых";
	end
	
	local pPlayer = g_pGame:GetPlayerManager():Get( sPlayer );
	
	if pPlayer == NULL or not pPlayer:IsInGame() then
		return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
	end
	
	if pPlayer:GetID() == pClient:GetID() then
		return "Команда не применима к самому себе", 255, 0, 0;
	end
	
	if pPlayer:IsAdmin() or pPlayer:GetPosition():Distance( pClient:GetPosition() ) > 5.0 then
		return TEXT_PLAYER_NOT_NEARBY, 255, 0, 0;
	end
	
	local sType, vecPosition = pClient:GetNearbyJail( "Outside" );
	
	if vecPosition:Distance( pPlayer:GetPosition() ) > 5.0 then
		return "Игрок должен быть рядом с камерой", 255, 0, 0;
	end
	
	if bIsFBI and iMinutes == 0 then
		pPlayer:GetChar():SetJailed();
		pPlayer:SetCuffed();
		
		pPlayer:GetChat():Send( pClient:GetVisibleName() + " освободил Вас из камеры", 255, 128, 0 );
		
		return "Вы освободили из камеры " + pPlayer:GetName(), 0, 255, 255;
	else		
		iMinutes = Clamp( 5, iMinutes, bIsFBI and 120 or 60 );
		
		pPlayer:GetChar():SetJailed( sType, iMinutes * 60 );
		pPlayer:SetCuffed();
		
		pPlayer:GetChat():Send( pClient:GetVisibleName() + " посадил Вас на " + iMinutes + " " + math.decl( iMinutes, "минуту", "минуты", "минут" ), 255, 128, 0 );
		
		return "Вы посадили " + pPlayer:GetName() + " на " + iMinutes + " " + math.decl( iMinutes, "минуту", "минуты", "минут" ), 0, 255, 255;
	end
end

function CFactionCommands:Megaphone( pClient, sCmd, ... )
	if pClient:IsInGame() then
		local pVehicle = pClient:GetVehicle();
		local pFaction = pVehicle and pVehicle:GetFaction();
		
		if pFaction then
			local Tag2Name =
			{
				LAPD	= "Полиция";
				FBI		= "ФБР";
				GOV		= "Правительство";
			};
			
			if Tag2Name[ pFaction:GetTag() ] then
				local sMessage = table.concat( { ... }, ' ' );
				
				if sMessage:len() > 0 then
					pClient:LocalMessage( "[" + Tag2Name[ pFaction:GetTag() ] + "]: " + sMessage, 225, 255, 0, 80.0, 89, 100, 0 );
					
					return true;
				end
				
				return "Syntax: /" + sCmd + " <ic text>", 255, 255, 255;
			end
		end
		
		return "Вы должны быть в автомобиле силовых структур", 255, 0, 0;
	end
end
