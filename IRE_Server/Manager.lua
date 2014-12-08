-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. Manager
{
	m_List			= NULL;
	
	Manager			= function()
		table.insert( gGame.Managers, this );
		
		this.m_List = {};
	end;
	
	DeleteAll		= function()
		if this.m_List then		
			for i, Object in pairs( this.m_List ) do
				delete ( Object );
			end
		end
	end;
	
	AddToList		= function( Object )
		this.m_List[ Object.GetID() ] = Object;
	end;
	
	RemoveFromList	= function( Object )
		this.m_List[ Object.GetID() ] = NULL;
	end;
	
	Get				= function( iID )
		return this.m_List[ iID ];
	end;
	
	GetAll			= function()
		return this.m_List;
	end;
};