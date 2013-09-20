-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local job_list	= {};

class "CJob"
{
	m_sID		= "invalid_id";
	m_iCode		= 0;
	m_sName 	= "Unnamed";
	m_vPosition	= 0;
	m_pPickup	= 0;
}

function CJob:CJob( sID, iCode, sName, sName2, vPosition )
	assert( is_type( sID, 'string', 'sID' ) );
	
	local pPickup		= CPickup.Create( vPosition, 3, 1314 );
	local pBlip			= CBlip( vPosition, 56, 2, 255, 255, 255, 255, 0, 300.0 );
	
	pBlip:SetParent		( pPickup );
	
	self.m_sID			= sID;
	self.m_iCode		= iCode;
	self.m_sName		= sName;
	self.m_sName2		= sName2;
	self.m_vPosition	= vPosition;
	self.m_pPickup		= pPickup;

	job_list[ sID ]		= self;
	job_list[ iCode ]	= self;
	
	function self.m_pPickup.OnHit( pPickup, pPlayer )
		if pPlayer:IsInGame() then
			if pPlayer:GetChar():GetJob() == self then
				pPlayer:Hint( "Работа: " + self:GetName(), "Вы уже устроены на эту работу", "error" );
			else
				pPlayer:Client().JobDialog( self:GetID(), self:GetName() );
			end
		end
		
		return false;
	end
end

function CJob.GetByID( sID )
	return job_list[ sID ];
end

function CJob.GetByCode( iCode )
	return job_list[ iCode ];
end

function CJob:GetID()
	return self.m_sID;
end

function CJob:GetCode()
	return self.m_iCode;
end

function CJob:GetName()
	return self.m_sName;
end

function CJob:GetName2()
	return self.m_sName2;
end

function CJob:GetPosition()
	return self.m_vPosition;
end

function CJob:GetPickup()
	return self.m_pPickup;
end

CJob.GetFromID = CJob.GetByID;