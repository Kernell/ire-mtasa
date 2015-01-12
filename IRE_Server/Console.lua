-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

addEvent( "onClientCommand", true );

class. Console
{
	Console		= function()
		this.Commands	= {};

		this = getElementsByType( "console" )[ 1 ]( this );
		
		this.__OnCommand	= function( ... )
			if client then
				local result, red, green, blue = this.ExecuteCommand( client, ... );
			
				if result then
					if red and green and blue then
						result = string.format( "#%02x%02x%02x%s", red, green, blue, result );
					end
					
					triggerClientEvent( client, "Console::StdOut", client, result );
				end
				
				triggerClientEvent( client, "Console::Return", client );
			end
		end;
		
		function this.__CommandHandler( PlayerSource, CommandName, ... )
			if PlayerSource == this then
				local Result = this.ExecuteCommand( this, CommandName, ... );
				
				if Result then
					Console.Log( Result );
				end
			end
		end
		
		addEventHandler( "onClientCommand", root, this.__OnCommand );
	end;
	
	_Console	= function()
		removeEventHandler( "onClientCommand", root, this.__OnCommand );
		
		this.__OnCommand		= NULL;
		this.__CommandHandler	= NULL;
	end;
	
	Initialize	= function()		
		this.AddCommand( new. CC_System		( "system" ) );
		this.AddCommand( new. CC_UAC		( "uac" ) );
		this.AddCommand( new. CC_Game		( "game" ) );
		this.AddCommand( new. CC_Race		( "race" ) );
		this.AddCommand( new. CC_Bank		( "bank" ) );
		this.AddCommand( new. CC_Faction	( "faction" ) );
		this.AddCommand( new. CC_NPC		( "npc" ) );
		this.AddCommand( new. CC_Player		( "player" ) );
		this.AddCommand( new. CC_Vehicle	( "vehicle" ) );
		this.AddCommand( new. CC_Marker		( "marker" ) );
		this.AddCommand( new. CC_Property	( "property" ) );
		this.AddCommand( new. CC_Map		( "map" ) );
		
		this.AddCommand( new. CC_Exec		( "exec" ) );
	end;
	
	AddCommand	= function( CC )
		this.Commands[ CC.Name ] = CC;
		
		addCommandHandler( CC.Name, this.__CommandHandler, false, false );
	end;
	
	ExecuteCommand	= function( Player, Name, ... )
		local CC = this.Commands[ Name ];
		
		if CC then
			if Player.IsLoggedIn() and Player.HaveAccess( "command." + Name ) then
				Console.Log( "%s (%s): %s %s", Player.GetName(), Player.UserName, Name, table.concat( { ... }, ' ' ) );
				
				return CC.Execute( Player, ... );
			end
			
			Console.Log( "DENIED: Denied '%s' access to command '%s'", Player.GetName(), Name );
			
			return ( "UAC: Access denied for '%s'" ):format( Name );
		end
		
		return Name + ": command not found";
	end;
	
	GetID		= function()
		return 0;
	end;
	
	GetUserID	= function()
		return 0;
	end;
	
	IsLoggedIn	= function()
		return true;
	end;
	
	IsInGame	= function()
		return false;
	end;
	
	GetChar		= function()
		return NULL;
	end;
	
	GetGroups	= function()
		return { Game.GetGroupManager().Get( 0 ) };
	end;
	
	HaveAccess	= function()
		return true;
	end;
	
	GetName		= function()
		return "Console";
	end;
	
	GetUserName	= function()
		return "Console";
	end;
	
	GetChat		= function()
		return
		{
			Send	= function( self, sText )
				print( sText );
			end;
		};
	end;
	
	static
	{
		Log		= function( format, ... )
			local text = format;
			
			if ( ... ) then
				local args = { ... };
				
				for i = 1, table.getn( args ) do
					if type( args[ i ] ) == "string" then
						args[ i ] = args[ i ]:gsub( "%%", "%%%%" );
					end
				end
				
				local result;
				
				result, text = pcall( string.format, format, unpack( args ) );
				
				if not result then
					error( text, 2 );
				end
			end
			
			return outputServerLog( text );
		end;
	}
};