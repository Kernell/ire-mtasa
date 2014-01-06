-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

function CChar:InitMarried( sMarriedName )
	self.m_sMarriedName	= sMarriedName or false;
end

function CChar:IsMarried()
	return tobool( self.m_sMarriedName );
end

function CChar:GetMarried()
	return self.m_sMarriedName or '';
end

function CChar:SetMarried( pChar )
	if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET married = " + ( pChar and "'" + pChar:GetName() + "'" or 'NULL' ) + " WHERE id = " + self:GetID() ) then
		self.m_sMarriedName = pChar and pChar:GetName() or false;
		
		return true;
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	return false;
end