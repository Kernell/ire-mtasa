-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CRaceManager ( CManager );

function CRaceManager:CRaceManager()
	self:CManager();
	
	self.m_List = {};
end

function CRaceManager:_CRaceManager()
	
end

function CRaceManager:Create( sName, fSize, iRed, iGreen, iBlue )
	if not self:Get( sName ) and not self:Load( sName ) then	
		local pRace		= CRace( self, sName );
		
		if fSize then
			pRace.m_fSize	= (float)(fSize);
		end
		
		if iRed then
			pRace.m_iRed	= (int)(iRed) % 256;
		end
		
		if iGreen then
			pRace.m_iGreen	= (int)(iGreen) % 256;
		end
		
		if iBlue then
			pRace.m_iBlue	= (int)(iBlue) % 256;
		end
		
		return pRace;
	end
	
	return false;
end

function CRaceManager:Load( sName )
	
	return NULL;
end

function CRaceManager:Save( pRace )
	if not self:Load( pRace:GetID() ) then
		
	end
	
	return false;
end

function CRaceManager:DoPulse( tReal )
	for i, pRace in pairs( self.m_List ) do
		pRace:DoPulse( tReal );
	end
end