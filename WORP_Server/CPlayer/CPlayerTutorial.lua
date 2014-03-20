-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CPlayerTutorial
{
	m_pClient	= NULL;
	
	CPlayerTutorial		= function( this, pPlayerEntity )
		this.m_pClient = pPlayerEntity;
	end;
	
	_CPlayerTutorial	= function( this )
		this.m_pClient	= NULL;
	end;
	
	SendTutorialData	= function( this, aStrings, iType )
		this.m_pClient:Client().SendTutorialData( aStrings, iType );
	end;
	
	CompleteTutorial	= function( this, iType )
		g_pGame:GetTutorialManager():Complete( this, iType );
	end;
};