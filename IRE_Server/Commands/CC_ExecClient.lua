-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. CC_ExecClient : IConsoleCommand
{
	CC_ExecClient	= function( ... )
		this.IConsoleCommand( ... );	
	end;
	
	Execute		= function( player, ... )
		if player.IsLoggedIn() then
			local bHaveAccess = player.UserID == 0;
			
			if not bHaveAccess then
				for i, pGroup in ipairs( player.Groups ) do
					if pGroup.GetID() == 0 then
						bHaveAccess = true;
						
						break;
					end
				end
			end
			
			if not bHaveAccess then
				return;
			end
			
			local code	= table.concat( { ... }, ' ' );
			
			if code[ 1 ] == '=' then
				code = code:gsub( "=", "return ", 1 );
			end
			
			local result = player.RPC.Execute( code );
			
			return result, 200, 255, 200;
		end
	end;
	
	Info		= function()
		
	end;
};
