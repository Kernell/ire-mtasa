-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local IgnoredElementData	= 
{
	[ "console_active" ]			= true;
	[ "chatbox_active" ]			= true;
	[ "i:left" ]					= true;
	[ "i:right" ]					= true;
	[ "Headmove:LookAt" ]			= true;
	[ "Headmove:Pause" ]			= true;
	[ "Weapon::SoundEmptyPlay" ]	= true;
	[ "CChar::m_fPower" ]			= true;
};

function onElementDataChange( sName, OldValue )
	if client and not IgnoredElementData[ sName ] then
		Debug( client:GetName() + ' changed element data "' + sName + '": value "' + (string)(client:GetData( sName )) + '" old value "' + (string)(OldValue) + '"', 0 );
		
		if client:HaveAccess( "general.modify_protected_data" ) then
			return;
		end
		
		setElementData( client, sName, OldValue );
		
		-- client:Ban( "Hacking attempt (Trying to change protected element data)", 3600 );
	end
end

function onDebugMessage( ... )
	triggerClientEvent( root, 'onServerDebugMessage', root, ... );
end

addEventHandler( 'onElementDataChange', root, onElementDataChange );
addEventHandler( 'onDebugMessage', root, onDebugMessage );