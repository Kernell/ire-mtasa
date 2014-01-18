-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CPlayerChat
{
	CPlayerChat		= function( this, pPlayer )
		this.m_pPlayer = pPlayer;
	end;

	_CPlayerChat		= function()
		this.m_pPlayer = NULL;
	end;
	
	OnChat		= function( this, sMessage, iType )
		if this.m_pPlayer:IsMuted() then
			this:Send( "У Вас молчанка, Вы не можете говорить", 255, 128, 0 );
			
			return;
		end
		
		if this.m_pPlayer:IsDead() then
			return;
		end
		
		if iType == 0 then
			this.m_pPlayer:LocalizedMessage( sMessage );
		elseif iType == 1 then
			this.m_pPlayer:Me( sMessage, NULL, true, true );
		elseif iType == 2 then
			local pChar = this.m_pPlayer:GetChar();
			
			if pChar then
				
				
				-- this.m_pPlayer:Me( this.m_pPlayer:Gender( "сказал", "сказала" ) + " что-то по рации", NULL, false, true );
			end
		end
	end;

	Send		= function( this, sMessage, iRed, iGreen, iBlue, bColorCoded )
		if classname( this ) ~= 'CPlayerChat' then error( TEXT_E2288, 2 ) end
		
		return outputChatBox( sMessage, this.m_pPlayer, tonumber( iRed ) or 255, tonumber( iGreen ) or 164, tonumber( iBlue ) or 0, bColorCoded == NULL and true or (bool)(bColorCoded) );
	end;

	Show		= function( this )
		if classname( this ) ~= 'CPlayerChat' then error( TEXT_E2288, 2 ) end
		
		return showChat( this.m_pPlayer, true );
	end;

	Hide		= function( this )
		if classname( this ) ~= 'CPlayerChat' then error( TEXT_E2288, 2 ) end
		
		return showChat( this.m_pPlayer.__instance, false );
	end;

	Error		= function( this, sText, ... )
		if classname( this ) ~= 'CPlayerChat' then error( TEXT_E2288, 2 ) end
		
		return this:Send( "Error: " + ( ( ... ) and sText:format( ... ) or sText ), 255, 0, 0, true );
	end;

	Warning		= function( this, sText, ... )
		if classname( this ) ~= 'CPlayerChat' then error( TEXT_E2288, 2 ) end
		
		return this:Send( "Warning: " + ( ( ... ) and sText:format( ... ) or sText ), 255, 128, 0, true );
	end;
};

local function OnPlayerChat( sMessage, iType )
	cancelEvent();
	
	if sMessage:gsub( " ", "" ):len() == 0 then
		return false;
	end
	
	if source:GetChat() then
		source:GetChat():OnChat( sMessage, iType );
	end
end

addEventHandler( "onPlayerChat", root, OnPlayerChat );

addEventHandler( "onPlayerPrivateMessage", root, 
	function()
		cancelEvent();
	end
);