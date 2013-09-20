-- Innovation Roleplay Engine
--
-- Author		Kernell, Alberto "ryden" Alonso
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CVehicleIndicators
{
	m_fSize						= 0.3;
	m_iFadeMs					= 160;
	m_iAutoswitchOffThreshold	= 80 / 90;
	m_SwitchTimes				= { 300, 400 };
	m_Color						= { 255, 100, 10, 255 };
	
	m_pManager			= NULL;
	m_pVehicle			= NULL;
	m_bLeft				= false;
	m_bRight			= false;
	m_pLeft				= NULL;
	m_pRight			= NULL;
	m_iNextChange		= 0;
	m_iTimeElapsed		= 0;
	m_bState			= false;
	m_vecDirection		= NULL;
};

function CVehicleIndicators:CVehicleIndicators( pManager, pVehicle )
	pVehicle.m_pIndicators	= self;
	
	self.m_pManager			= pManager;
	self.m_pVehicle			= pVehicle;
	
	self.m_pManager:AddToList( self );
end

function CVehicleIndicators:_CVehicleIndicators()
	if self.m_pLeft then
		delete ( self.m_pLeft );
		
		self.m_pLeft = NULL;
	end
	
	if self.m_pRight then
		delete ( self.m_pRight );
		
		self.m_pRight = NULL;
	end
	
	if self.m_pVehicle:GetDriver() == CLIENT then
		self.m_pVehicle:SetData( "i:left", false );
		self.m_pVehicle:SetData( "i:right", false );
	end
	
	self.m_pManager:RemoveFromList( self );
	
	self.m_pVehicle.m_pIndicators = NULL;
end

function CVehicleIndicators:SetAlpha( iAlpha )
	if self.m_pLeft then
		self.m_pLeft:SetColor( self.m_Color[ 1 ], self.m_Color[ 2 ], self.m_Color[ 3 ], iAlpha );
	end
	
	if self.m_pRight then
		self.m_pRight:SetColor( self.m_Color[ 1 ], self.m_Color[ 2 ], self.m_Color[ 3 ], iAlpha );
	end
end

function CVehicleIndicators:Process()
	if self.m_pVehicle:GetHealth() == 0 then
		delete ( self );
		
		return;
	end
	
	if self.m_vecDirection then
		local vecVelocity = self.m_pVehicle:GetVelocity();
		
		if vecVelocity:Normalize() == 0 then
			vecVelocity = self.m_pVehicle:GetFakeVelocity();
		end
		
		vecVelocity:CrossProduct( self.m_vecDirection );
		
		if vecVelocity:Length() > self.m_iAutoswitchOffThreshold then
			delete ( self );
			
			return;
		end
	end
	
	if self.m_iNextChange <= self.m_iTimeElapsed then
		self:SetAlpha( self.m_Color[ 4 ] );
		
		self.m_bState		= not self.m_bState;
		self.m_iTimeElapsed	= 0;
		self.m_iNextChange	= self.m_SwitchTimes[ self.m_bState and 1 or 2 ];
		
		if CLIENT:GetVehicle() == self.m_pVehicle then
			playSoundFrontEnd( self.m_bState and 37 or 38 );
		end
	elseif self.m_bState == false then
		if self.m_iTimeElapsed >= self.m_iFadeMs then
			self:SetAlpha( 0 );
		else
			self:SetAlpha( ( 1 - ( self.m_iTimeElapsed / self.m_iFadeMs ) ) * self.m_Color[ 4 ] );
		end
	end
end

function CVehicleIndicators:Update()
	local iIndicators = 0;
	
	if self.m_bLeft then
		if not self.m_pLeft then
			self.m_pLeft	= CVehicleIndicator( self.m_pVehicle, "left" );
		end
		
		iIndicators = iIndicators + 1;
	elseif self.m_pLeft then
		delete ( self.m_pLeft );
		
		self.m_pLeft = NULL;
	end
	
	if self.m_bRight then
		if not self.m_pRight then
			self.m_pRight	= CVehicleIndicator( self.m_pVehicle, "right" );
		end
		
		iIndicators = iIndicators + 1;
	elseif self.m_pRight then
		delete ( self.m_pRight );
		
		self.m_pRight = NULL;
	end
	
	if iIndicators == 1 and self.m_pVehicle:GetDriver() == CLIENT then
		self.m_vecDirection = self.m_pVehicle:GetVelocity();
		
		if self.m_vecDirection:Normalize() == 0 then
			self.m_vecDirection = self.m_pVehicle:GetFakeVelocity();
		end
	else
		self.m_vecDirection = NULL;
	end
end
