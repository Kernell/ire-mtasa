-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CWorldCommands"

function CWorldCommands:SetWeather( pPlayer, sCmd, sOption, sWeatherID )
	local iWeather = tonumber( sWeatherID );
	
	if iWeather then
		g_pGame:GetWeatherManager():Set( iWeather, false );
		
		pPlayer:GetChat():Send( "Погода изменена, ID: " + iWeather, 0, 255, 128 );
		
		return true;
	end
	
	return false;
end

function CWorldCommands:SetTime( pPlayer, sCmd, sOption, sHour, sMinute )
	local iHour = tonumber( sHour );
	
	if iHour then
		local iMinute = tonumber( sMinute ) or 0;
		
		g_pGame:GetTimeManager():Set( iHour, iMinute );
		
		pPlayer:GetChat():Send( ( "Время изменено (%d:%02d)" ):format( iHour, iMinute ), 0, 255, 128 );
		
		return true;
	end
	
	return false;
end

function CWorldCommands:ResetTime( pPlayer )
	g_pGame:GetTimeManager():Set();
	
	pPlayer:GetChat():Send( "Время восстановлено", 0, 255, 128 );
	
	return true;
end

function CWorldCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end