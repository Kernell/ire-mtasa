-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CTeleportManager ( CManager );

function CTeleportManager:CTeleportManager()
	self:CManager();
end

function CTeleportManager:_CTeleportManager()
	
end

function CTeleportManager:Init()
	self.m_List	= {};
	
	local pResult = g_pDB:Query( 'SELECT id, position1, rotation1, dimension1, interior1, position2, rotation2, dimension2, interior2, faction_id FROM ' + DBPREFIX + 'teleports WHERE deleted IS NULL ORDER BY id ASC' );
	
	if pResult then
		for _, pRow in ipairs( pResult:GetArray() ) do
			CTeleport( pRow.id, 
				Vector3( pRow.position1 ), Vector3( 0, 0, pRow.rotation1 ), pRow.interior1, pRow.dimension1, 
				Vector3( pRow.position2 ), Vector3( 0, 0, pRow.rotation2 ), pRow.interior2, pRow.dimension2,
				pRow.faction_id
			);
		end
		
		delete ( pResult );
	else
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
	return true;
end

function CTeleportManager:Create( vecPosition1, fRotation1, iInterior1, iDimension1, vecPosition2, fRotation2, iInterior2, iDimension2 )
	local iID = g_pDB:Insert( DBPREFIX + "teleports",
		{
			position1		= (string)(vecPosition1);
			rotation1		= (float)(fRotation1);
			dimension1		= (int)(iDimension1);
			interior1		= (int)(iInterior1);
			position2		= (string)(vecPosition2);
			rotation2		= (float)(fRotation2);
			interior2		= (int)(iInterior2);
			dimension2		= (int)(iDimension2);
		}
	);
	
	if iID then
		return CTeleport( iID, vecPosition1, Vector3( 0, 0, fRotation1 ), iInterior1, iDimension1, vecPosition2, Vector3( 0, 0, fRotation2 ), iInterior2, iDimension2, 0 );
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return NULL;
end
