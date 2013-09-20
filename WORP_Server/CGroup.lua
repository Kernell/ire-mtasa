-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

enum "CGroupRight"
{
	RIGHT_TYPE_GENERAL	= 0;
	RIGHT_TYPE_COMMAND	= 1;
};

class "CGroup"

function CGroup:CGroup( pGroupManager, iID, sName, sCaption, aColor )
	self.m_pGroupManager	= pGroupManager;
	
	self.m_iID		= iID;
	self.m_sName	= sName;
	self.m_sCaption	= sCaption;
	self.m_aColor	= aColor;
	self.m_Rights	= {};
	
	self.m_Rights[ CGroupRight.RIGHT_TYPE_GENERAL ] = {};
	self.m_Rights[ CGroupRight.RIGHT_TYPE_COMMAND ] = {};
	
	pGroupManager:AddToList( self );
end

function CGroup:_CGroup()
	self.m_pGroupManager:RemoveFromList( self );
end

function CGroup:GetID()
	return self.m_iID;
end

function CGroup:GetName()
	return self.m_sName;
end

function CGroup:GetCaption()
	return self.m_sCaption;
end

function CGroup:GetColor()
	return self.m_aColor;
end

function CGroup:AddRight( sRight, eRightType, bValue )
	self.m_Rights[ eRightType ][ sRight ] = bValue;
end

function CGroup:GetRight( sRight, eRightType )
	return self.m_Rights[ eRightType ][ sRight ];
end

function CGroup:RemoveRight( sRight, eRightType )
	self.m_Rights[ eRightType ][ sRight ] = NULL;
end