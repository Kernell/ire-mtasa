-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. PlayerChat
{
	static
	{
		Smiles	=
		{
			smile		= "(\>\:\]|\:-\)|\:\)|\:o\)|\:\]|\:3|\:c\)|\:\>|\=\]|8\)|\=\)|\:\}|\:\^\))";
			laugh		= "(\>\:D|\:-D|\:D|8-D|x-D|X-D|\=-D|\=D|\=-3|8-\)|xD|XD|8D|\=3)";
			sad 		= "(\>\:\[|\:-\(|\:\(|\:-c|\:c|\:-\<|\:-\[|\:\[|\:\{|\>\.\>|\<\.\<|\>\.\<)";
			wink		= "(\>;\]|;-\)|;\)|\*-\)|\*\)|;-\]|;\]|;D|;\^\))";
			tongue		= "(\>\:P|\:-P|\:P|X-P|x-p|\:-p|\:p|\=p|\:-Þ|\:Þ|\:-b|\:b|\=p|\=P|xp|XP|xP|Xp)";
			surprise	= "(\>\:o|\>\:O|\:-O|\:O|°o°|°O°|\:O|o_O|o\.O|8-0)";
			annoyed		= "(\>\:\\|\>\:/|\:-/|\:-\.|\:\\|\=/|\=\\|\:S|\:\/)";
			cry			= "(\:'\(|;'\()";
		};
		
		SmileActions	=
		{
			smile		= "улыбается";
			laugh		= "смеётся";
			sad			= "грустит";
			wink		= "подмигивает";
			tongue		= "показывает язык";
			surprise	= "удивляется";
			cry			= "плачет";
		};
		
		Prefixes =
		{
			{ male = "сказал";			female = "сказала";			unknown = "сказал(а)";		};
			{ male = "крикнул";			female = "крикнула";		unknown = "крикнул(а)";		};
			{ male = "шепнул";			female = "шепнула";			unknown = "шепнул(а)"; 		};
			{ male = "тихо сказал";		female = "тихо сказала";	unknown = "тихо сказал(а)";	};
			{ male = "рация";			female = "рация";			unknown = "рация"; 			};
			{ male = "телефон";			female = "телефон";			unknown = "телефон"; 		};
			{ male = "микрофон";		female = "микрофон";		unknown = "микрофон"; 		};
		};	
	};
	
	PlayerChat		= function( player )
		this.Player = player;
	end;
	
	_PlayerChat		= function()
		this.Player = NULL;
	end;
	
	OnChat		= function( message, type )
		if message:gsub( " ", "" ):len() == 0 then
			return;
		end
		
		if this.Player.IsMuted() then
			this:Send( "У Вас молчанка, Вы не можете говорить", 255, 128, 0 );
			
			return;
		end
		
		if this.Player.IsDead() then
			return;
		end
		
		if type == 0 then
			this.LocalizedMessage( message );
		elseif type == 1 then
			this.Me( message, NULL, true, true );
		elseif type == 2 then
			-- local pChar = this.Player.GetChar();
			
			-- if pChar then
				-- this.Player.Me( this.Player.Gender( "сказал", "сказала" ) + " что-то по рации", NULL, false, true );
			-- end
		end
	end;
	
	Send		= function( message, red, green, blue, colorCoded )
		red		= tonumber( red ) or 255;
		green	= tonumber( green ) or 164;
		blue	= tonumber( blue ) or 0;
		
		return outputChatBox( message, this.Player, red, green, blue, colorCoded == NULL or colorCoded );
	end;
	
	LocalizedMessage	= function( message, range, type )
		local char = this.Player.Character;
		
		if char then
			if this.Player.IsAdmin then
				this.LocalOOC( message );
			else
				local gender = char.Skin.GetGender() or "unknown";
				local prefix = PlayerChat.Prefixes[ type or 1 ][ gender ];
				
				local text = this.Player.VisibleName + " (" + this.Player.GetID() + ") " + prefix + ": " + message;
				
				this.LocalMessage( text, 240, 240, 240, tonumber( range ) or 20.0, 64, 64, 64 );
				
				Console.Log( text:gsub( "%%", "%%%%" ) );
			end
		end
	end;
	
	LocalMessage	= function( message, r, g, b, range, r2, g2, b2 )
		r = r or 255;
		g = g or 255;
		b = b or 255;
		
		range = range or 20.0;
		
		r2 = r2 or r;
		g2 = g2 or g;
		b2 = b2 or b;
		
		local position	= this.Player.GetPosition();
		local dimension	= this.Player.GetDimension();
		
		for _, player in pairs( Server.Game.PlayerManager.GetAll() ) do
			local distance = player.GetPosition().Distance( position );
			
			if distance < range and dimension == player.GetDimension() then
				local progress	= distance / range;
				
				local red	= Lerp( r, r2, progress );
				local green	= Lerp( g, g2, progress );
				local blue	= Lerp( b, b2, progress );
				
				player.Chat.Send( message, red, green, blue, false );
			end
		end
	end;
	
	Me	= function( message, prefix, sendChat, showBubble )
		prefix 		= type( prefix ) == "string" and prefix or "* ";
		sendChat	= sendChat == NULL or sendChat;
		showBubble	= showBubble == NULL or showBubble;
		
		local text = prefix + this.Player.VisibleName + " " + message;
		
		if sendChat then
			this.LocalMessage( text, 255, 0, 255, 10, 255, 0, 255 );
			
			Console.Log( text );
		else
			this.Send( text, 255, 0, 255 );
		end
		
		if showBubble then
			triggerClientEvent( root, "OnPlayerChatMessage", this.Player, message, 1 );
		end
	end;
	
	GlobalOOC	= function( message )
		outputChatBox( "(( " + this.Player.UserName +  ": " + message + " ))", root, 0, 196, 255, this.Player.IsAdmin );
		
		Console.Log( "GlobalOOC: [%d]: (( %s: %s ))", this.Player.ID, this.Player.UserName, message );
	end;
	
	LocalOOC	= function( message )
		local visibleName	= this.Player.VisibleName;
		local text	= "*" + visibleName + ( this.Player.IsAdmin and "" or ( " (" + this.Player.ID + ")" ) ) + ": (( " + message + " ))";
		
		this.LocalMessage( text, 196, 255, 255 );
		
		Console.Log( "LocalOOC: [%d]:  (( %s: %s ))", this.Player.ID, visibleName, message );
	end;
	
	SendAdminsMessage	= function( message, prefix, r, g, b )
		prefix = type( prefix ) == "string" and prefix or "*Admins: ";
		
		r = r or 255;
		g = g or 64;
		b = b or 0;
		
		for _, player in pairs( Server.Game.PlayerManager.GetAll() ) do
			if player.HaveAccess( "command.adminchat" ) then
				player.GetChat.Send( prefix + message, r, g, b );
			end
		end
		
		Console.Log( prefix + message );
	end;
	
	Show		= function()
		return showChat( this.Player, true );
	end;
	
	Hide		= function()
		return showChat( this.Player, false );
	end;
	
	Error		= function( text, ... )
		return this.Send( "Error: " + ( ( ... ) and text:format( ... ) or text ), 255, 0, 0, true );
	end;
	
	Warning		= function( text, ... )
		return this.Send( "Warning: " + ( ( ... ) and text:format( ... ) or text ), 255, 128, 0, true );
	end;
}
