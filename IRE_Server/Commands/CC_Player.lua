-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. CC_Player : IConsoleCommand
{
	CC_Player	= function( ... )
		this.IConsoleCommand( ... );	
	end;
	
	Execute		= function( player, option, ... )
		if option == "giveitem" then
			return this.Option_GiveItem( player, option, ... );
		end
	end;

	Option_GiveItem	= function( player, option, section, owner )
		if section then
			if owner then
				owner = Server.Game.PlayerManager.Get( owner );
				
				if not owner then
					return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
				end
			else
				owner = player;
			end

			if not owner.IsInGame() then
				return TEXT_PLAYER_NOT_IN_GAME, 255, 0, 0;
			end

			if Server.Game.ItemsManager.Config[ section ] then
				local item = owner.Character.Inventory.GiveItem( section );

				if item then
					Console.Log( "%s (ID: %d) gives item [%s] for %s (ID: %d, UserName: %s)", player.UserName, player.UserID, section, owner.Character.GetName(), owner.UserID, owner.UserName );

					return "Выдан предмет '" + item.name + "' игроку '" + owner.Character.GetName() + "'", 0, 255, 0;
				end
				
				return "Недостаточно места";
			end

			return "invalid section name '" + section + "'", 255, 0, 0;
		end

		return "Syntax: /" + this.Name + " " + option + " <section> [owner]";
	end;
	
	Info		= function()
		
	end;
};