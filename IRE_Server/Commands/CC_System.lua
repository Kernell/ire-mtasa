-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. CC_System : IConsoleCommand
{
	CC_System	= function( ... )
		this.IConsoleCommand( ... );
	end;
	
	Execute		= function( player, option, ... )
		if option == "restart" then
			local seconds = tonumber( ( { ... } )[ 1 ] );
			
			if seconds then
				seconds = Clamp( 0, seconds, 600 );
				
				Server.CountDown		= seconds;
				Server.CountDownType	= seconds == 0 and SERVER_COUNTDOWN_NONE or SERVER_COUNTDOWN_RESTART;
				
				local decl = math.decl( seconds, "секунду", "секунды", "секунд" );
				
				outputChatBox( "Внимание! Перезапуск сервера " + ( seconds == 0 and "отменён" or "через " + seconds + " " + decl ), root, 255, 64, 0 );
				
				AdminManager.SendMessage( player.GetUserName() + " запустил таймер на перезапуск сервера (" + decl + ")" );
				
				return true;
			end
			
			return "Syntax: /" + this.Name + " " + option + " <seconds>";
		end
		
		if option == "shutdown" then
			local seconds = tonumber( ( { ... } )[ 1 ] );
			
			if seconds then
				seconds = Clamp( 0, seconds, 600 );
				
				Server.CountDown		= seconds;
				Server.CountDownType	= seconds == 0 and SERVER_COUNTDOWN_NONE or SERVER_COUNTDOWN_SHUTDOWN;
				
				local decl = math.decl( seconds, "секунду", "секунды", "секунд" );
				
				outputChatBox( "Внимание! Выключение сервера " + ( seconds == 0 and "отменён" or "через " + seconds + " " + decl ), root, 255, 64, 0 );
				
				AdminManager.SendMessage( player.GetUserName() + " запустил таймер на выключение сервера (" + decl + ")" );
				
				return true;
			end
			
			return "Syntax: /" + this.Name + " " + option + " <seconds>";
		end
		
		return this.Info();
	end;
	
	Info		= function()
		return
		{
			{ "Syntax: /" + this.Name + " <option>", 255, 255, 255 };
			{ "List of options:", 200, 200, 200 };
			{ "restart                    Таймер на рестарт сервера (0 для отмены)", 200, 200, 200 };
			{ "shutdown                   Таймер на выключение сервера (0 для отмены)", 200, 200, 200 };
		};
	end;
};