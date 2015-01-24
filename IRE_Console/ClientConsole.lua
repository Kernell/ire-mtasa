-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

addEvent( "Console::StdOut", true );
addEvent( "Console::Return", true );

local gl_iScreenX, gl_iScreenY = guiGetScreenSize();

class. ClientConsole
{
	static
	{
		NextKeyTickDelay	= 500;
	};

	m_sVersion			= "0.1.20140110";
	
	m_iWidth			= gl_iScreenX;
	m_iHeight			= gl_iScreenY * 0.5;
	
	m_iSize				= 1;
	m_pFont				= "default-bold";
	m_iFontWidth		= 7;
	m_iLineHeight		= 15;
	m_iLinesBufferSize	= 999;
	m_iLines			= 20;
	m_iLineScrollOffset	= 0;
	m_iLogSize			= 999;
	m_iLogIterator		= 0;
	
	m_iNextKeyTick		= 0;
	m_iNextKeyTickDelay	= 500;
	
	m_iTextColor		= tocolor( 255, 255, 255, 255 );
	m_iTextInputColor	= tocolor( 255, 255, 255, 255 );
	m_iBackgroundColor	= tocolor( 0, 0, 0, 150 );
	
	ClientConsole		= function()
		this.m_aThreads	= {};
		
		this.LoadLog();
		this.Clear();
		
		this.m_iFontWidth	= dxGetTextWidth( "a", this.m_iSize, this.m_pFont );
		
		this.m_pInputGUI	= guiCreateEdit( 0, 0, 0, 0, "", false );
		
		function this.__OnGUIAccepted()
			local sCommand = table.concat( this.m_aCommand, "" );
			
			this.Send( sCommand );
			
			this.m_aCommand	= {};
			
			guiSetText( this.m_pInputGUI, "" );
		end
		
		local __OnGUIChangedSkip = false;
		
		function this.__OnGUIChanged()
			if __OnGUIChangedSkip then
				__OnGUIChangedSkip = false;
				
				return;
			end
			
			local text = guiGetText( this.m_pInputGUI );
			
			for i = 1, text:len() do
				table.insert( this.m_aCommand, text[ i ] );
			end
			
			__OnGUIChangedSkip = true;
			
			guiSetText( this.m_pInputGUI, "" );
		end
		
		function this.__OnGUIBlur()
			guiBringToFront( this.m_pInputGUI );
		end
		
		addEventHandler( "onClientGUIAccepted", this.m_pInputGUI, this.__OnGUIAccepted );
		addEventHandler( "onClientGUIChanged", 	this.m_pInputGUI, this.__OnGUIChanged );
		addEventHandler( "onClientGUIBlur", 	this.m_pInputGUI, this.__OnGUIBlur );
		
		function this.__OnClientKey( sKey, bPressed )
			this.m_iNextKeyTickDelay = ClientConsole.NextKeyTickDelay;
			
			this.m_iNextKeyTick = getTickCount() + this.m_iNextKeyTickDelay;
			
			if bPressed then
				if not this.OnKey( sKey ) then
					cancelEvent();
				end	
			end
		end
		
		function this.__OnClientRender()
			this.Draw();
		end
		
		function this.__OnClientChatMessage( sText, iRed, iGreen, iBlue )
			local sLine = ( "#%02x%02x%02x%s" ):format( (int)(iRed), (int)(iGreen), (int)(iBlue), sText );
			
			if table.getn( this.m_aThreads ) > 0 then
				this.StdOut( sLine );
			else
				this.Print( sLine );
			end
		end
		
		function this.__Print( result )
			if type( result ) == "table" then
				for i, str in ipairs( result ) do
					if type( str ) == "table" then
						local str, r, g, b = str[ 1 ], str[ 2 ], str[ 3 ], str[ 4 ];
						
						if r and g and b then
							str = ( "#%02x%02x%02x%s" ):format( r, g, b, str );
						end
						
						this.StdOut( str );
					elseif type( str ) == "string" then
						this.StdOut( str );
					end
				end
			elseif type( result ) == "string" then
				this.StdOut( result );
			end
		end
		
		function this.__Return()
			this.ExecuteResult();
		end
		
		addEventHandler( "onClientKey", 		root, this.__OnClientKey );
		addEventHandler( "onClientRender", 		root, this.__OnClientRender );
		addEventHandler( "onClientChatMessage", root, this.__OnClientChatMessage );
		addEventHandler( "Console::StdOut", 	root, this.__Print );
		addEventHandler( "Console::Return", 	root, this.__Return );
	end;
	
	_ClientConsole		= function()
		this.Hide();
		
		removeEventHandler( "onClientKey", 			root, this.__OnClientKey );
		removeEventHandler( "onClientRender", 		root, this.__OnClientRender );
		removeEventHandler( "onClientChatMessage",	root, this.__OnClientChatMessage );
		removeEventHandler( "Console::Print",		root, this.__Print );
		
		this.__OnClientKey			= NULL;
		this.__OnClientRender		= NULL;
		this.__OnClientChatMessage	= NULL;
		this.__Print				= NULL;
		
		removeEventHandler( "onClientGUIAccepted", 	this.m_pInputGUI, this.__OnGUIAccepted );
		removeEventHandler( "onClientGUIChanged", 	this.m_pInputGUI, this.__OnGUIChanged );
		removeEventHandler( "onClientGUIBlur", 		this.m_pInputGUI, this.__OnGUIBlur );
		
		destroyElement( this.m_pInputGUI );
		
		this.__OnGUIAccepted	= NULL;
		this.__OnGUIChanged		= NULL;
		this.__OnGUIBlur		= NULL;
		
		this.m_pInputGUI	= NULL;
	end;
	
	AppendLog			= function( sText )
		while table.getn( this.Log ) > this.m_iLogSize do
			table.remove( this.Log );
		end
		
		table.insert( this.Log, 1, sText );
		
		local pFile = fileExists( "history" ) and fileOpen( "history" ) or fileCreate( "history" );
		
		if pFile then
			fileSetPos( pFile, fileGetSize( pFile ) );
			fileWrite( pFile, sText + "\n" );
			fileClose( pFile );
		else
			error( "failed to open history file", 2 );
		end
	end;
	
	LoadLog				= function()
		this.Log		= {};
		
		local pFile		= fileExists( "history" ) and fileOpen( "history" );
		
		if pFile then
			local sContent	= fileRead( pFile, fileGetSize( pFile ) );
			
			fileClose( pFile );
			
			for i, sLine in ipairs( sContent:split( '\n' ) ) do
				table.insert( this.Log, 1, sLine );
			end
		end
	end;
	
	Clear				= function()
		this.m_aLines	=
		{
			"";
			"Innovation Roleplay Engine Shell [Version " + this.m_sVersion + "]";
		};
		
		this.m_aCommand	= {};
		
		this.m_iLogIterator 		= 0;
		this.m_iLineScrollOffset	= 0;
	end;
	
	Show				= function()
		this.m_bVisible = true;
		
		showChat( false );
		
		guiSetInputEnabled( true );
		
		guiBringToFront( this.m_pInputGUI );
	end;
	
	Hide				= function()
		this.m_bVisible = false;
		
		showChat( true );
		
		guiSetInputEnabled( false );
	end;
	
	Send				= function( sText )
		this.Print( "> " + sText );
		
		this.m_iLineScrollOffset = 0;
		
		if sText:len() == 0 then
			this.m_iLogIterator	= 0;
			
			return;
		end
		
		this.m_aStdOut = NULL;
		
		this.m_aThreads = sText:split( "|" );
		
		if this.Log[ this.m_iLogIterator ] ~= sText then
			this.AppendLog( sText );
		end
		
		this.Exec();
	end;
	
	Exec				= function()
		local sCommand = this.m_aThreads[ 1 ];
		
		table.remove( this.m_aThreads, 1 );
		
		local Args = sCommand:split( ' ' );
		
		if _G[ Args[ 1 ] ] then
			_G[ Args[ 1 ] ]( unpack( Args, 2 ) );

			this.ExecuteResult();
			
			this.m_aStdOut = NULL;
		else
			triggerServerEvent( "onClientCommand", CLIENT, unpack( Args ) );
			
			-- this.StdOut( "#FF0000" + Args[ 1 ] + ": command not found" );
		end
		
	end;
	
	ExecuteResult		= function( sResult )
		if table.getn( this.m_aThreads ) == 0 then
			if this.m_aStdOut then
				for i, sLine in ipairs( this.m_aStdOut ) do
					this.Print( sLine );
				end
			end
		else
			this.Exec();
		end
		
		if sResult then
			this.StdOut( sResult );
		end
	end;
	
	StdOut				= function( sLine )
		if this.m_aStdOut == NULL then
			this.m_aStdOut = {};
		end
		
		table.insert( this.m_aStdOut, sLine );
	end;
	
	Print				= function( sText )
		while table.getn( this.m_aLines ) > this.m_iLinesBufferSize do
			table.remove( this.m_aLines );
		end
		
		table.insert( this.m_aLines, 1, sText );
	end;
	
	OnKey				= function( sKey )
		if this.m_bVisible then
			guiBringToFront( this.m_pInputGUI );
			
			if sKey == "escape" or sKey == "end" then
				this.Hide();
			elseif sKey == "c" then
				if getKeyState( "rctrl" ) or getKeyState( "lctrl" ) then
					this.Print( "> " + table.concat( this.m_aCommand, "" ) );
					
					this.m_iLogIterator = 0;
					
					this.m_aCommand = {};
				end
			elseif sKey == "arrow_d" then
				this.m_iLogIterator = this.m_iLogIterator - 1;
				
				if this.m_iLogIterator < 0 then
					this.m_iLogIterator = 0;
				end
				
				local sText = this.Log[ this.m_iLogIterator ] or "";
				
				this.m_aCommand = sText:split( "" );
			elseif sKey == "arrow_u" then
				local iLogSize	= table.getn( this.Log );
				
				if table.getn( this.m_aCommand ) ~= 0 or this.m_iLogIterator == 0 then
					this.m_iLogIterator = this.m_iLogIterator + 1;
				end
				
				if this.m_iLogIterator > iLogSize then
					this.m_iLogIterator = iLogSize;
				end
				
				local sText = this.Log[ this.m_iLogIterator ] or "";
				
				this.m_aCommand = sText:split( "" );
			elseif sKey == "pgup" then
				this.m_iLineScrollOffset = Clamp( 0, this.m_iLineScrollOffset + 1, table.getn( this.m_aLines ) );
			elseif sKey == "pgdn" then
				this.m_iLineScrollOffset = Clamp( 0, this.m_iLineScrollOffset - 1, table.getn( this.m_aLines ) );
			elseif sKey == "mouse_wheel_up" then
				this.m_iLineScrollOffset = Clamp( 0, this.m_iLineScrollOffset + 3, table.getn( this.m_aLines ) );
			elseif sKey == "mouse_wheel_down" then
				this.m_iLineScrollOffset = Clamp( 0, this.m_iLineScrollOffset - 3, table.getn( this.m_aLines ) );
			end
			
			return false;
		end
		
		return true;
	end;
	
	UpdateKeys			= function()
		local iTick	= getTickCount();
		
		if this.m_iNextKeyTick - iTick <= 0 then
			this.m_iNextKeyTickDelay = this.m_iNextKeyTickDelay - 150;
			
			local iMinDelay = 50;
			
			if getKeyState( "arrow_u" ) then
				this.OnKey( "arrow_u" );
			elseif getKeyState( "arrow_d" ) then
				this.OnKey( "arrow_d" );
			elseif getKeyState( "pgup" ) then
				this.OnKey( "pgup" );
				
				iMinDelay = 10;
				
				this.m_iNextKeyTickDelay = 10;
			elseif getKeyState( "pgdn" ) then
				this.OnKey( "pgdn" );
				
				iMinDelay = 10;
				
				this.m_iNextKeyTickDelay = 10;
			end
			
			this.m_iNextKeyTick = iTick + Clamp( iMinDelay, this.m_iNextKeyTickDelay, ClientConsole.NextKeyTickDelay );
		end
	end;
	
	Draw				= function()
		if this.m_bVisible then
			this.UpdateKeys();
			
			dxDrawRectangle( 0, 0, this.m_iWidth, this.m_iHeight, this.m_iBackgroundColor, true );
			
			for i = 1, this.m_iLines do
				local fY = this.m_iHeight - ( ( i + 1 ) * this.m_iLineHeight );
				
				local sLine = this.m_aLines[ i + this.m_iLineScrollOffset ];
				
				if sLine then
					dxDrawText( sLine, 10, fY, this.m_iWidth - 10, fY, this.m_iTextColor, this.m_iSize, this.m_pFont, "left", "center", false, false, true, true, false );
				end
			end
			
			local fX	= 10;
			local fY	= this.m_iHeight - this.m_iLineHeight;
			
			dxDrawText( "$ ", fX, fY, fX, fY, this.m_iTextInputColor, this.m_iSize, this.m_pFont, "left", "center", false, false, true, true, false );
			
			for i = 1, table.getn( this.m_aCommand ) do
				local fX	= 17 + ( i * this.m_iFontWidth );
				
				local sChar = this.m_aCommand[ i ];
				
				dxDrawText( sChar, fX, fY, fX, fY, this.m_iTextInputColor, this.m_iSize, this.m_pFont, "left", "center", false, false, true, true, false );
			end
		end
	end;
};
