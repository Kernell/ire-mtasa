-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CGroup
{
	CGroup			= function( this, pGroupManager, iID, sName, sCaption, aColor )
		this.m_pGroupManager	= pGroupManager;
		
		this.m_iID		= iID;
		this.m_sName	= sName;
		this.m_sCaption	= sCaption;
		this.m_aColor	= aColor;
		this.m_Rights	= {};
		
		pGroupManager:AddToList( this );
	end;

	_CGroup			= function( this )
		this.m_pGroupManager:RemoveFromList( this );
	end;

	GetID			= function( this )
		return this.m_iID;
	end;

	GetName			= function( this )
		return this.m_sName;
	end;

	GetCaption		= function( this )
		return this.m_sCaption;
	end;

	GetColor		= function( this )
		return this.m_aColor;
	end;

	AddRight		= function( this, sRight )
		this.m_Rights[ sRight ] = true;
	end;

	GetRight		= function( this, sRight )
		return this.m_Rights[ sRight ] == true;
	end;

	RemoveRight		= function( this, sRight )
		this.m_Rights[ sRight ] = NULL;
	end;
};