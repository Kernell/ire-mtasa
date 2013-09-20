-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CGateManager ( CManager );

function CGateManager:CGateManager()
	self:CManager();
	self.CManager = NULL;
end

function CGateManager:_CGateManager()
	self:DeleteAll();
end

function CGateManager:Init()
	self.m_List = {};
	
	local iTick, iCount = getTickCount(), 0;
	
	local pResult = g_pDB:Query( "SELECT * FROM " + DBPREFIX + "gates WHERE deleted = 'No' ORDER BY id ASC" );
	
	if not pResult then
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
	for _, row in ipairs( pResult:GetArray() ) do
		local iID				= row.id;
		local iModel			= row.model;
		local pFaction			= g_pGame:GetFactionManager():Get( row.faction_id );
		local pJob				= CJob.GetByID( row.job_id );
		local iInterior			= row.interior;
		local iDimension		= row.dimension;
		local vecPosition		= Vector3( row.x, row.y, row.z );
		local vecRotation		= Vector3( row.rx, row.ry, row.rz );
		local vecTargetPosition	= Vector3( row.target_x, row.target_y, row.target_z );
		local vecTargetRotation	= Vector3( row.target_rx, row.target_ry, row.target_rz );
		local iTime				= row.time;
		local fRadius			= row.radius;
		local sEasing			= row.easing;
		local fEasingPeriod		= row.easing_period;
		local fEasingAmplitude	= row.easing_amplitude;
		local fEasingOvershoot	= row.easing_overshoot;
		
		local pGate		= CGate( self, iID, iModel, pFaction, pJob, iInterior, iDimension, vecPosition, vecRotation, vecTargetPosition, vecTargetRotation, iTime, fRadius, sEasing, fEasingPeriod, fEasingAmplitude, fEasingOvershoot );
		
		iCount = iCount + 1;
	end
	
	delete ( result );
	
--	Debug( ( "Loaded %d gates (%d ms)" ):format( iCount, getTickCount() - iTick ) );
	
	return true;
end

function CGateManager:DoPulse( tReal )
	for _, pGate in pairs( self.m_List ) do
		pGate:DoPulse( tReal );
	end
end