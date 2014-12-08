-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. CC_Exec : IConsoleCommand
{
	CC_Exec	= function( ... )
		this.IConsoleCommand( ... );	
	end;
	
	Execute		= function( Player, ... )
		if Player.IsLoggedIn() then
			local bHaveAccess = Player.GetUserID() == 0;
			
			if not bHaveAccess then
				for i, pGroup in ipairs( Player.GetGroups() ) do
					if pGroup.GetID() == 0 then
						bHaveAccess = true;
						
						break;
					end
				end
			end
			
			if not bHaveAccess then
				return true;
			end
			
			-- local pChat		= Player.GetChat();
			local String	= table.concat( { ... }, ' ' );
			
			-- pChat.Send( "> " + String, 255, 200, 200 );
			
			if String[ 1 ] == '=' then
				String = String:gsub( "=", "return ", 1 );
			end
			
			local Function, Error = loadstring( "return " + String );
			
			if Error then
				Function, Error = loadstring( String );
			end
			
			if Error then
				return "Error: " + Error, 255, 200, 200;
			end
			
			local Results = { pcall( Function ) };
			
			if not Results[ 1 ] then
				return "Error: " + Results[ 2 ], 255, 200, 200;
			end
			
			local Result = {};
			
			for i = 2, table.getn( Results ) do
				local resultType = isElement( Results[ i ] ) and ( "element:" + getElementType( Results[ i ] ) ) or typeof( Results[ i ] );
				
				table.insert( Result, (string)(Results[ i ]) + " [" + resultType + "]" );
			end
			
			return table.concat( Result, ', ' ), 255, 200, 200;
		end
	end;
	
	Info		= function()
		
	end;
};
