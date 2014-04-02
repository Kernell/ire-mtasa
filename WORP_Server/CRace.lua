-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local OnMarkerHit;

enum "eRaceState"
{
	"RACE_STATE_CREATING";
	"RACE_STATE_READY";
	"RACE_STATE_STARTING";
	"RACE_STATE_STARTED";
	"RACE_STATE_STOPPED";
};

class: CRace
{
	m_eState		= RACE_STATE_CREATING;
	m_sName			= NULL;
	m_fSize			= 15.0;
	m_iRed			= 255;
	m_iGreen		= 0;
	m_iBlue			= 0;
	m_bReversed		= false;
	m_iLaps			= 1;
	m_Players		= NULL;
	m_CPs			= NULL;
	m_pRaceManager	= NULL;
};

function CRace:CRace( pRaceManager, sName, fSize, iRed, iGreen, iBlue )
	self.m_pRaceManager	= pRaceManager;
	
	self.m_CPs			= {};
	self.m_Players		= {};
	
	self.m_sName		= sName;
	
	pRaceManager:AddToList( self );
end

function CRace:GetID()
	return self.m_sName;
end

function CRace:_CRace()
	for i, pPlr in ipairs( self.m_Players ) do
		delete ( pPlr.m_pRaceMarker );
		
		self:ClearClient( pPlr );
	end
	
	self.m_pRaceManager:RemoveFromList( self );
end

function CRace:GetState()
	return self.m_eState;
end

function CRace:AppendCP( vecPosition )
	if self.m_eState == RACE_STATE_CREATING then
		table.insert( self.m_CPs, vecPosition );
		
		return table.getn( self.m_CPs );
	end
	
	return false;
end

function CRace:RemoveCP()
	if self.m_eState == RACE_STATE_CREATING then
		table.remove( self.m_CPs );
		
		return true;
	end
	
	return false;
end

function CRace:Ready()
	if self.m_eState == RACE_STATE_CREATING then
		self.m_eState = RACE_STATE_READY;
		
		return true;
	end
	
	return false;
end

function CRace:Start()
	if self.m_eState == RACE_STATE_READY then
		self.m_iCPs		= table.getn( self.m_CPs );
		self.m_iCount	= 11;
		self.m_eState	= RACE_STATE_STARTING;
		
		self:UpdatePositions();
		
		return true;
	end
	
	return false;
end

function CRace:Stop()
	if self.m_eState == RACE_STATE_STARTING or self.m_eState == RACE_STATE_STARTED then
		self.m_eState = RACE_STATE_READY;
		
		for _, pPlr in ipairs( self.m_Players ) do
			self:ClearClient( pPlr );
			
			pPlr.m_pRace	= self;
		end
		
		return true;
	end
	
	return false;
end

function CRace:GetPlayers()
	return self.m_Players;
end

function CRace:ClearClient( pClient )
	if pClient.m_pRace == self then
		if pClient.m_pRaceMarker then
			delete ( pClient.m_pRaceMarker );
			pClient.m_pRaceMarker = NULL;
		end
		
		pClient.m_pRace			= NULL;
		pClient.m_iRaceCP		= NULL;
		pClient.m_iRaceLap		= NULL;
		pClient.m_iRaceFinished	= NULL;
		
		pClient:RemoveData( "CRace::m_iFinishTime" );
		pClient:Client().UpdateScoreBoard( NULL );
	end
end

function CRace:AddPlayer( pPlayer )
	if pPlayer.m_pRace == NULL then	
		if self.m_eState == RACE_STATE_READY then
			table.insert( self.m_Players, pPlayer );
			
			pPlayer.m_pRace		= self;
			
			return true;
		end
	end
	
	return false;
end

function CRace:RemovePlayer( pPlayer )
	if pPlayer.m_pRace == self then
		self:ClearClient( pPlayer );
		
		for i = table.getn( self.m_Players ), 0, -1 do
			if self.m_Players[ i ] == pPlayer then
				table.remove( self.m_Players, i );
			end
		end
		
		return true;
	end
	
	return false;
end

function CRace:UpdatePositions()
	local iRaceMs	= 0;
	
	if self.m_eState == RACE_STATE_STARTED then
		local iPlayers		= table.getn( self.m_Players );
		
		for i, pPlr in ipairs( self.m_Players ) do
			if self.m_CPs[ pPlr.m_iRaceCP ] then
				local iLen = ( pPlr.m_iRaceLap * self.m_iCPs ) + pPlr.m_iRaceCP;
				
				if not self.m_bReversed then
					iLen = ( self.m_iCPs * self.m_iLaps ) - iLen;
				end
				
				pPlr.m_fRaceDistance	= pPlr:GetPosition():Distance( self.m_CPs[ pPlr.m_iRaceCP ] ) + ( 10000 * iLen );
			elseif pPlr.m_iRaceFinished then
				pPlr.m_fRaceDistance	= -( iPlayers + 1 - pPlr.m_iRaceFinished );
			else
				pPlr.m_fRaceDistance	= self.m_iCPs * 9999.9 + i;
			end
		end
		
		table.sort( self.m_Players,
			function( a, b )
				return a.m_fRaceDistance < b.m_fRaceDistance;
			end
		);
		
		iRaceMs	= getTickCount() - self.m_iStartTick;
	end
	
	for _, pPlr in ipairs( self.m_Players ) do
		if pPlr.m_pRace == self then
			pPlr:Client().UpdateScoreBoard( self.m_Players, iRaceMs, pPlr.m_iRaceLap or 1, self.m_iLaps );
		end
	end
end

function CRace:SendMessage( sMessage, iReg, iGreen, iBlue )
	iReg	= tonumber( iReg ) or 0;
	iGreen	= tonumber( iGreen ) or 128;
	iBlue	= tonumber( iBlue ) or 255;
	
	for i, pPlr in ipairs( self:GetPlayers() ) do
		pPlr:GetChat():Send( sMessage, iReg, iGreen, iBlue );
	end
end

function CRace:OnPlayerLeave( pPlayer, sReason )
	if pPlayer.m_pRace == self then
		self:SendMessage( pPlayer:GetVisibleName() + " вышел из гонки " + ( sReason and ( "(" + sReason + ")" ) or "" ) );			
		
		self:RemovePlayer( pPlayer );
	end
end

function CRace:OnPlayerCP( pPlayer )
	if pPlayer.m_pRace == self and self.m_eState == RACE_STATE_STARTED then
		pPlayer.m_iRaceCP = pPlayer.m_iRaceCP + ( self.m_bReversed and -1 or 1 );
		pPlayer:PlaySoundFrontEnd( 13 );
		
		if pPlayer.m_pRaceMarker then
			delete ( pPlayer.m_pRaceMarker );
			pPlayer.m_pRaceMarker = NULL;
		end
		
		if self.m_CPs[ pPlayer.m_iRaceCP ] == NULL then
			if pPlayer.m_iRaceLap < self.m_iLaps then
				pPlayer.m_iRaceLap	= pPlayer.m_iRaceLap + 1;
				pPlayer.m_iRaceCP	= self.m_bReversed and self.m_iCPs + 1 or 0;
				
				return self:OnPlayerCP( pPlayer );
			end
			
			self.m_iFinished = self.m_iFinished + 1;
			
			pPlayer.m_iRaceFinished = self.m_iFinished;
			
			local iRaceMs	= getTickCount() - self.m_iStartTick;
			
			pPlayer:SetData( "CRace::m_iFinishTime", iRaceMs );
			
			self:SendMessage( ( pPlayer:GetVisibleName() + " финишировал (%02dm %02ds %02dms)" ):format( iRaceMs / 60000, ( iRaceMs % 60000 ) / 1000, ( iRaceMs % 1000 ) / 10 ), 0, 255, 255 );
			
			return true;
		end
		
		pPlayer.m_pRaceMarker 			= CMarker( self.m_CPs[ pPlayer.m_iRaceCP ], "checkpoint", self.m_fSize, self.m_iRed, self.m_iGreen, self.m_iBlue, 200, pPlayer );
		pPlayer.m_pRaceMarker.m_pBlip	= CBlip( pPlayer.m_pRaceMarker, BLIP_SPRITE_NONE, 2, self.m_iRed, self.m_iGreen, self.m_iBlue, 255, 0, 99999.0, pPlayer );
		
		pPlayer.m_pRaceMarker.m_pPlayer = pPlayer;
		pPlayer.m_pRaceMarker.OnHit 	= OnMarkerHit;
		pPlayer.m_pRaceMarker.m_pBlip:SetParent( pPlayer.m_pRaceMarker );
		
		local vecNextCP = self.m_CPs[ pPlayer.m_iRaceCP + ( self.m_bReversed and -1 or 1 ) ];
		
		if vecNextCP then
			pPlayer.m_pRaceMarker:SetIcon( "arrow" );
			pPlayer.m_pRaceMarker:SetTarget( vecNextCP );
			
			local pNextMarker 	= CMarker( vecNextCP, "checkpoint", self.m_fSize, self.m_iRed, self.m_iGreen, self.m_iBlue, 100, pPlayer );
			local pBlip 		= CBlip( vecNextCP, BLIP_SPRITE_NONE, 1, self.m_iRed, self.m_iGreen, self.m_iBlue, 128, 0, 99999.0, pPlayer );
			
			pNextMarker:SetParent( pPlayer.m_pRaceMarker.m_pBlip );
			pBlip:SetParent( pNextMarker );
		else
			pPlayer.m_pRaceMarker:SetIcon( pPlayer.m_iRaceLap < self.m_iLaps and "none" or "finish" );
		end
		
		return true;
	end
	
	return false;
end

function CRace:DoPulse( tReal )
	if self.m_eState == RACE_STATE_STARTING then
		self.m_iCount = self.m_iCount - 1;
		
		if self.m_iCount == 0 then
			self.m_eState		= RACE_STATE_STARTED;
			self.m_tStart		= tReal.timestamp;
			self.m_iStartTick	= getTickCount();
			self.m_iFinished	= 0;
			
			for _, pPlr in ipairs( self.m_Players ) do
				if pPlr.m_pRace == self then
					pPlr.m_iRaceLap				= 1;
					pPlr.m_iRaceCP				= self.m_bReversed and self.m_iCPs + 1 or 0;
					pPlr.m_iRaceFinished		= NULL;
					pPlr:RemoveData( "CRace::m_iFinishTime" );
					pPlr:PlaySoundFrontEnd( 45 );
					pPlr:Client().SetRaceCountText( "GO!!!" );
					
					self:OnPlayerCP( pPlr );
				end
			end
			
		else
			for _, pPlr in ipairs( self.m_Players ) do
				if pPlr.m_pRace == self then
					pPlr:PlaySoundFrontEnd( 44 );
					pPlr:Client().SetRaceCountText( (string)(self.m_iCount) );
				end
			end
		end
	end
	
	if self.m_eState == RACE_STATE_STARTED then
		self:UpdatePositions();
	end
end

function OnMarkerHit( pMarker, pVehicle, bDimension )
	if bDimension and getElementType( pVehicle ) == "vehicle" then
		local pPlayer = pVehicle:GetDriver();
		
		if pPlayer and pPlayer == pMarker.m_pPlayer and pPlayer:IsInGame() then
			local pRace = pPlayer.m_pRace;
			
			if pRace then
				pRace:OnPlayerCP( pPlayer );
			end
		end
	end
end