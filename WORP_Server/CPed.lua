-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

function CPed:_CPed()
	destroyElement( self );
	
	g_pGame:GetPedManager():RemoveFromList( self );
	
	CElement.RemoveFromList( self );
end

function CPed:GetID()
	return self.m_ID;
end

function CPed:DoPulse( tReal )
	local iTick = getTickCount();
	
	if self.m_sAnimLib and self.m_iAnimTime > 50 then
		if iTick - (int)(self.m_iAnimStart) > self.m_iAnimTime then
			self:SetAnimation( self.m_sAnimLib, self.m_sAnimName, self.m_iAnimTime, self.m_bAnimLoop, self.m_bAnimUpdatePos, self.m_bAnimInterruptable, self.m_bAnimFreezeLastFrame );
			
			self.m_iAnimStart = iTick;
		end
	end
end
