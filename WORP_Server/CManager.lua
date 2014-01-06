-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CManager
{
-- private:
	m_List			= NULL;
	
-- public:
	CManager		= function( this )
		local sClassName	= classname( this );
		local sName			= sClassName:sub( 2, sClassName:len() );
		local sGetFuncName	= "Get" + sName;
		
		table.insert( g_pGame.m_Managers, this );
		
		g_pGame[ sGetFuncName ] = function()
			return this;
		end
	end;
	
	DeleteAll		= function( this )
		if this.m_List then		
			for _, pObject in pairs( this.m_List ) do
				delete ( pObject );
			end
		end
	end;
	
	AddToList		= function( this, pObject )
		this.m_List[ pObject:GetID() ] = pObject;
	end;
	
	RemoveFromList	= function( this, pObject )
		this.m_List[ pObject:GetID() ] = NULL;
	end;
	
	Get				= function( this, iID )
		return this.m_List[ iID ];
	end;
	
	GetAll			= function( this )
		return this.m_List;
	end;
};