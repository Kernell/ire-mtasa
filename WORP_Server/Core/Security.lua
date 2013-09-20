-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local IgnoredElementData	= 
{
	console_active			= true;
	chatbox_active			= true;
	['i:left']				= true;
	['i:right']				= true;
	[ 'Headmove:LookAt' ]	= true;
};

function CElement:SetData( sName, vValue, bSync, bProtected )
	if bProtected then
		if not self.m_ProtectedElementData then
			self.m_ProtectedElementData = {};
		end
		
		self.m_ProtectedElementData[ sName ] = true;
	end
	
	return setElementData( self.__instance, sName, vValue, bSync == NULL or (bool)(bSync) );
end

function CElement:RemoveData( sName )
	if self.m_ProtectedElementData then
		self.m_ProtectedElementData[ sName ] = NULL;
	end
	
	return removeElementData( self.__instance, sName );
end

function onElementDataChange( sName, OldValue )
	if client and not IgnoredElementData[ sName ] then
		if client.m_ProtectedElementData and client.m_ProtectedElementData[ sName ] then
			Debug( client:GetUserName() + ' changed element data "' + sName + '": value "' + (string)(client:GetData( sName )) + '" old value "' + (string)(OldValue) + '"', 0 );
			
			if client:HaveAccess( 'general.modify_protected_data' ) then
				return;
			end
			
			setElementData( client, sName, OldValue );
			
			-- client:Ban( "Hacking attempt (Trying to change protected element data)", 3600 );
		end
	end
end

function onDebugMessage( ... )
	triggerClientEvent( root, 'onServerDebugMessage', root, ... );
end

addEventHandler( 'onElementDataChange', root, onElementDataChange );
addEventHandler( 'onDebugMessage', root, onDebugMessage );