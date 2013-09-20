-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CSystemCommands"

function CSystemCommands:Restart( pPlayer, sCmd, sOption, sSeconds )
	local iSeconds = tonumber( sSeconds );
	
	if iSeconds then
		iSeconds = Clamp( 0, iSeconds, 600 );
		
		g_pServer:SetRestartTimer( iSeconds );
		
		outputChatBox( "Внимание! Рестарт сервера " + ( iSeconds == 0 and "отменён" or "через " + iSeconds + " секунд" ), root, 255, 64, 0 );
		
		SendAdminsMessage( pPlayer:GetUserName() + ' запустил таймер на рестарт сервера (' + iSeconds + ' сек.)' );
		
		return true;
	end
	
	return false;
end

function CSystemCommands:Shutdown( pPlayer, sCmd, sOption, sSeconds )
	local iSeconds = tonumber( sSeconds );
	
	if iSeconds then
		iSeconds = Clamp( 0, iSeconds, 600 );
		
		g_pServer:SetShutDownTimer( iSeconds );
		
		outputChatBox( "Внимание! Выключение сервера " + ( iSeconds == 0 and "отменено" or "через " + iSeconds + " секунд" ), root, 255, 64, 0 );
		
		SendAdminsMessage( pPlayer:GetUserName() + ' запустил таймер на выключение сервера (' + iSeconds + ' сек.)' );
		
		return true;
	end
	
	return false;
end

function CSystemCommands:SetOOC( pPlayer, sCmd, sOption, sbEnabled )
	if sbEnabled then
		g_pGame.m_bGlobalOOC = tobool( sbEnabled );
		
		SendAdminsMessage( pPlayer:GetUserName() + ': ' + ( g_pGame.m_bGlobalOOC and 'включил' or 'выключил' ) + ' глобальный OOC чат' );
		
		return true;
	end
	
	return false;
end

function CSystemCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end