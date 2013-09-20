-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CRaceCommands"

function CRaceCommands:Create( pPlayer, sCmd, sOption, sName, sfSize, siRed, siGreen, siBlue )
	if not pPlayer:IsInGame() then return true; end
	
	if sName then
		if pPlayer.m_pRace == NULL then
			pPlayer.m_pRaceCreation = g_pGame:GetRaceManager():Create( sName, sfSize, siRed, siGreen, siBlue );
			
			if pPlayer.m_pRaceCreation then
				return "Трасса с именем '" + sName + "' успешно создана", 0, 255, 0;
			end
			
			return "Трасса с таким именем уже существует", 255, 0, 0;
		end
		
		return "Создание гонки в данный момент невозможно", 255, 0, 0;
	elseif pPlayer.m_pRaceCreation then
		pPlayer.m_pRaceCreation.m_eState = RACE_STATE_CREATING;
		
		return "Режим создания включен. Используйте \"/race ready\" для завершения.", 0, 255, 0;
	end
	
	return false;
end

function CRaceCommands:Clear( pPlayer )
	if not pPlayer:IsInGame() then return true; end
	
	if pPlayer.m_pRaceCreation and pPlayer.m_pRaceCreation.m_eState == RACE_STATE_CREATING then
		pPlayer.m_pRaceCreation.m_CPs = {};
		
		return "Все чекпоинты успешно удалены", 0, 255, 0;
	end
	
	return "Вы не создаёте трассу в данный момент", 255, 0, 0;
end

function CRaceCommands:Save( pPlayer )
	if not pPlayer:IsInGame() then return true; end
	
	if pPlayer.m_pRaceCreation then
		if pPlayer.m_pRaceCreation.m_pRaceManager:Save( pPlayer.m_pRaceCreation ) then
			return "Трасса '" + pPlayer.m_pRaceCreation:Save() + "' успешно сохранена", 0, 255, 0;
		end
		
		return "Ошибка при сохранении трассы", 255, 0, 0;
	end
	
	return "Вы не создаёте трассу в данный момент", 255, 0, 0;
end

function CRaceCommands:Load( pPlayer, sCmd, sOption, sName )
	if not pPlayer:IsInGame() then return true; end
	
	if sName then
		local pRace	= g_pGame:GetRaceManager():Get( sName );
		
		if pRace == NULL then
			pRace	= g_pGame:GetRaceManager():Load( sName );
		end
		
		if pRace then
			pPlayer.m_pRaceCreation = pRace;
			
			return "Трасса '" + pRace:GetID() + "' успешно загружена", 0, 255, 0;
		end
		
		return "Трасса с именем '" + sName + "' не существует", 255, 0, 0;
	end
	
	return false;
end

function CRaceCommands:Add( pPlayer )
	if not pPlayer:IsInGame() then return true; end
	
	if pPlayer.m_pRaceCreation then
		local iCP = pPlayer.m_pRaceCreation:AppendCP( pPlayer:GetPosition() );
		
		if iCP then
			return "Всего добавлено чекпоинтов: " + (string)(iCP), 0, 128, 128;
		end
		
		return "Невозможно добавить чекпоинт", 255, 0, 0;
	end
	
	return "Необходимо включить режим создания трассы. Используйте /race create", 255, 0, 0;
end

function CRaceCommands:Remove( pPlayer )
	if not pPlayer:IsInGame() then return true; end
	
	if pPlayer.m_pRaceCreation then
		if pPlayer.m_pRaceCreation:RemoveCP() then
			return "Осталось чекпоинтов: " + (string)(table.getn( pPlayer.m_pRaceCreation.m_sCP )), 255, 0, 0;
		end
		
		return "Невозможно удалить чекпоинт", 255, 0, 0;
	end
	
	return "Необходимо включить режим создания трассы. Используйте /race create", 255, 0, 0;
end

function CRaceCommands:Ready( pPlayer )
	if not pPlayer:IsInGame() then return true; end
	
	if pPlayer.m_pRaceCreation then
		if table.getn( pPlayer.m_pRaceCreation.m_CPs ) > 1 then
			if pPlayer.m_pRaceCreation:Ready() then
				return "Гонка готова к запуску. Используйте \"/race join " + pPlayer.m_pRaceCreation.m_sName + "\" чтобы присоедениться к гонке", 0, 255, 0;
			end
			
			return "Эта трасса не находится в режиме редактирования", 255, 0, 0;
		end
		
		return "Должно быть минимум 2 чекпоинта", 255, 0, 0;
	end
	
	return "Необходимо включить режим создания трассы. Используйте /race create", 255, 0, 0;
end

function CRaceCommands:Start( pPlayer )
	if not pPlayer:IsInGame() then return true; end
	
	if pPlayer.m_pRaceCreation then
		if table.getn( pPlayer.m_pRaceCreation.m_CPs ) > 1 then
			if pPlayer.m_pRaceCreation:Start() then
				return "Гонка успешно запущена", 0, 255, 0;
			end
			
			return "Невозможно запустить гонку. Трасса не готова или уже запущена", 255, 0, 0;
		end
		
		return "Должно быть минимум 2 чекпоинта", 255, 0, 0;
	end
	
	return "Вы не создаёте трассу или не загрузили её. Используйте /race create для создания или /race load для загрузки", 255, 0, 0;
end

function CRaceCommands:Stop( pPlayer )
	if not pPlayer:IsInGame() then return true; end
	
	if pPlayer.m_pRaceCreation then
		if pPlayer.m_pRaceCreation:Stop() then
			return "Гонка остановлена. Используйте /race start для повторого запуска", 0, 255, 0;
		end
		
		return "Гонка не была запушена", 255, 0, 0;
	end
	
	return "Вы не создаёте трассу или не загрузили её. Используйте /race create для создания или /race load для загрузки", 255, 0, 0;
end

function CRaceCommands:Join( pPlayer, sCmd, sOption, sName )
	if not pPlayer:IsInGame() then return true; end
	
	if pPlayer.m_pRace == NULL then
		local pRace = g_pGame:GetRaceManager():Get( sName );
		
		if pRace then
			if pRace:AddPlayer( pPlayer ) then
				local sPlayerName = pPlayer:GetVisibleName();
				
				for i, pPlr in ipairs( pRace:GetPlayers() ) do
					pPlr:GetChat():Send( sPlayerName + " присоеденился к гонке", 0, 128, 255 );
				end
				
				return true;
			end
			
			return "Гонка уже начата", 255, 0, 0;
		end
		
		return "Гонка с именем '" + sName + "' не найдена", 255, 0, 0;
	end
	
	return "Вы уже находитесь на гонке '" + pPlayer.m_pRace.m_sName + "'. Используйте /race leave для выхода", 255, 0, 0;
end

function CRaceCommands:Leave( pPlayer )
	if not pPlayer:IsInGame() then return true; end
	
	local pRace = pPlayer.m_pRace;
	
	if pRace then
		if pRace:RemovePlayer( pPlayer ) then
			local sPlayerName = pPlayer:GetVisibleName();
				
			for i, pPlr in ipairs( pRace:GetPlayers() ) do
				pPlr:GetChat():Send( sPlayerName + " вышел из гонки", 0, 128, 255 );
			end
		end
	end
	
	return true;
end

function CRaceCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end