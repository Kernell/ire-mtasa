-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CGateManager ( CManager );

function CGateManager:CGateManager()
	self:CManager();
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
	
	for _, pRow in ipairs( pResult:GetArray() ) do
		local iID				= pRow.id;
		local iModel			= pRow.model;
		local pFaction			= g_pGame:GetFactionManager():Get( pRow.faction_id );
		local iInterior			= pRow.interior;
		local iDimension		= pRow.dimension;
		local vecPosition		= Vector3( pRow.x, pRow.y, pRow.z );
		local vecRotation		= Vector3( pRow.rx, pRow.ry, pRow.rz );
		local vecTargetPosition	= Vector3( pRow.target_x, pRow.target_y, pRow.target_z );
		local vecTargetRotation	= Vector3( pRow.target_rx, pRow.target_ry, pRow.target_rz );
		local iTime				= pRow.time;
		local fRadius			= pRow.radius;
		local sEasing			= pRow.easing;
		local fEasingPeriod		= pRow.easing_period;
		local fEasingAmplitude	= pRow.easing_amplitude;
		local fEasingOvershoot	= pRow.easing_overshoot;
		
		local pGate	= CGate( iID, iModel, pFaction, iInterior, iDimension, vecPosition, vecRotation, vecTargetPosition, vecTargetRotation, iTime, fRadius, sEasing, fEasingPeriod, fEasingAmplitude, fEasingOvershoot );
		
		iCount = iCount + 1;
	end
	
	delete ( pResult );
	
	return true;
end

function CGateManager:DoPulse( tReal )
	for _, pGate in pairs( self.m_List ) do
		pGate:DoPulse( tReal );
	end
end