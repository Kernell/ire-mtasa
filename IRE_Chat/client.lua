-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local gl_pChatBox = NULL;

function Chatbox( fX, fY, fWidth, fHeight )
	local pEdit = guiCreateEdit( fX, fY, fWidth, fHeight, "", false );
	
	guiEditSetCaretIndex( pEdit, 1 );
	
	guiSetProperty( pEdit, "InheritsAlpha", "False" );
	guiSetProperty( pEdit, "Alpha", 0.5 );
	guiSetProperty( pEdit, "NormalTextColour", "FF000000" );
	
	local this = 
	{
		Log		=
		{
			Iter	= 0;
		};
		
		SetText		= function( sText )
			return guiSetText( pEdit, sText );
		end;
		
		GetText		= function( sText )
			return guiGetText( pEdit );
		end;
		
		IsVisible	= function()
			return guiGetVisible( pEdit );
		end;
		
		Destroy		= function()
			return destroyElement( pEdit );
		end;
	};
	
	function this.SetVisible( bShow )
		if not bShow then
			if this.Log.Iter > 0 then
				this.SetText( "" );
			end
			
			this.Log.Iter = 0;
		end
		
		guiSetVisible( pEdit, bShow );
		
		if bShow then
			guiBringToFront( pEdit );
		else
			guiMoveToBack( pEdit );
		end
	end
	
	function this.Send()
		local sText = this.GetText();
		
		this.SetText( "" );
		
		this.SetVisible( false );
		
		if sText:len() > 0 then
			triggerServerEvent( "sendPlayerChat", localPlayer, sText, 0 );
			
			this.Log.Append( sText );
			
			return true;
		end
		
		return false;
	end
	
	function this.Log.Next()
		if this.Log.Iter == 0 then
			this.Log[ 0 ] = this.GetText();
		end
		
		if this.Log.Iter < table.getn( this.Log ) then
			this.Log.Iter = this.Log.Iter + 1;
			
			this.SetText( this.Log[ this.Log.Iter ] );
		end
	end
	
	function this.Log.Prev()
		if this.Log.Iter > 0 then
			this.Log.Iter = this.Log.Iter - 1;
			
			if this.Log[ this.Log.Iter ] then
				this.SetText( this.Log[ this.Log.Iter ] );
			end
		end
	end
	
	function this.Log.Append( sText )
		table.insert( this.Log, 1, sText );
		
		while table.getn( this.Log ) > 100 do
			table.remove( this.Log );
		end
	end

	this.SetVisible( false );
	
	addEventHandler( "onClientGUIAccepted", pEdit, this.Send );
	
	return this;
end

function Init()
	toggleControl( "chatbox", false );
	
	local Fonts		=
	{
		[ 0 ] = 16;
		[ 1 ] = 16;
		[ 2 ] = 16;
		[ 3 ] = 16;
	};
	
	local Layout	= getChatboxLayout();
	
	local fX		= 15;
	local fY		= 10 + ( ( Layout.chat_lines * Fonts[ Layout.chat_font ] ) * Layout.text_scale * Layout.chat_scale[ 2 ] );
	local fWidth	= 100 * Layout.chat_scale[ 1 ] * Layout.chat_width;
	local fHeight	= 22;
	
	gl_pChatBox = Chatbox( fX, fY, fWidth, fHeight );
end

function FallBack()
	gl_pChatBox.Destroy();
	gl_pChatBox = NULL;
	
	toggleControl( "chatbox", true );
end

function ShowChatbox()
	if gl_pChatBox then
		gl_pChatBox.SetVisible( true );
	end
end

bindKey( "t", "up", ShowChatbox );

local iTick = 0;

function Update()
	if gl_pChatBox and gl_pChatBox.IsVisible() then
		if getKeyState( "esc" ) then
			gl_pChatBox.SetVisible( false );
			
			iTick = getTickCount();
		elseif getKeyState( "arrow_u" ) then
			if getTickCount() - iTick > 150 then
				gl_pChatBox.Log.Next();
				
				iTick = getTickCount();
			end
		elseif getKeyState( "arrow_d" ) then
			if getTickCount() - iTick > 150 then
				gl_pChatBox.Log.Prev();
				
				iTick = getTickCount();
			end
		end
	end
end

addEventHandler( "onClientRender", root, Update );
addEventHandler( "onClientResourceStart", resourceRoot, Init );
addEventHandler( "onClientResourceStop", resourceRoot, FallBack );

addCommandHandler( "togglechatbox",
	function()
		if gl_pChatBox then
			FallBack();
		else
			Init();
		end
	end
);
