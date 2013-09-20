-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

addEvent( "sendPlayerChat", true );

function SendPlayerChat( sMessage, iType )
	if sMessage:sub( 1, 1 ) == "/" then
		triggerEvent( "onPlayerCommand", client, sMessage );
	else
		triggerEvent( "onPlayerChat", client, sMessage, iType );
	end
end

addEventHandler( "sendPlayerChat", root, SendPlayerChat );