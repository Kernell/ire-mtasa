-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

function CChar:InitJobs( sJobID, iJobSkill )
	self.m_pJob				= CJob.GetByID( sJobID );
	self.m_iJobSkill		= iJobSkill;
end

function CChar:SetJob( pJob )
	if assert( g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET job = %q WHERE id = %d", pJob:GetID(), self:GetID() ) ) then
		self.m_pJob = pJob;
		
		return true;
	end
	
	return false;
end

function CChar:SetJobSkill( iJobSkill )
	if assert( g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET job_skill = %d WHERE id = %d", iJobSkill, self:GetID() ) ) then
		self.m_iJobSkill = iJobSkill;
		
		return true;
	end
	
	return false;
end

function CChar:GetJob()
	return self.m_pJob;
end

function CChar:GetJobSkill()
	return self.m_iJobSkill;
end