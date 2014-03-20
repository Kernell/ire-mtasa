-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

addEvent( "IClientCharacter", true );

class: IClientCharacter
{
	m_pCharacter	= NULL;
};

function IClientCharacter:IClientCharacter( pCharacter )
	self.m_pCharacter = pCharacter;
	
	function self._Handler( sMethod, ... )
		return self.m_pCharacter[ sMethod ]( self.m_pCharacter, ... );
	end
	
	addEventHandler( "IClientCharacter", CLIENT, self._Handler );
end

function IClientCharacter:_IClientCharacter()
	removeEventHandler( "IClientCharacter", CLIENT, self._Handler );
end



function OnCharacterLogin( iID, sName, sSurname )
	CLIENT.m_pCharacter = CClientCharacter( iID, sName, sSurname );
end

function OnCharacterLogout()
	delete ( CLIENT.m_pCharacter );
	CLIENT.m_pCharacter = NULL;
end