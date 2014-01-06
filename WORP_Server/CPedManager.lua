-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CPedManager ( CManager );

function CPedManager:CPedManager()
	self:CManager();
end

function CPedManager:_CPedManager()
	
end

function CPedManager:Init()
	self.m_List	= {};
	
	local sQuery = 'SELECT id, model, position, rotation, dimension, interior, collisions_enabled, damage_proof, frozen, animation_lib, animation_name, animation_time, animation_loop, animation_update_position, animation_interruptable, animation_freeze_last_frame \
					FROM ' + DBPREFIX + 'peds WHERE deleted = "No" ORDER BY id ASC';
	
	local pResult = g_pDB:Query( sQuery );
	
	if pResult then
		for _, row in ipairs( pResult:GetArray() ) do
			self:Add( row.id, row.model, Vector3( row.position ), row.rotation, row.interior, row.dimension, row.animation_lib, row.animation_name, row.animation_time,
				row.animation_loop == 'Yes',
				row.animation_update_position == 'Yes',
				row.animation_interruptable == 'Yes',
				row.animation_freeze_last_frame == 'Yes',
				row.collisions_enabled == 'Yes',
				row.frozen == 'Yes',
				row.damage_proof == 'Yes'
			);
		end
		
		delete ( pResult );
	else
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
	return true;
end

function CPedManager:Create( iModel, vecPosition, fRotation, iInterior, iDimension, sAnimLib, sAnimName, iAnimTime, bAnimLoop, bAnimUpdatePos, bAnimInterruptable, bAnimFreezeLastFrame, bCollisions, bFrozen, bDamageProof )
	if g_pDB:Query( "INSERT INTO " + DBPREFIX + "peds ( model, position, rotation, interior, dimension, animation_lib, animation_name, animation_time, animation_loop, animation_update_position, animation_interruptable, animation_freeze_last_frame ) VALUES ( %d, %q, %f, %d, %d, %q, %q, %q, %q, %q, %q, %q )", 
		iModel, (string)(vecPosition), fRotation, iInterior, iDimension, sAnimLib or "", sAnimName or "", (int)(iAnimTime), bAnimLoop and 'Yes' or 'No', bAnimUpdatePos and 'Yes' or 'No', bAnimInterruptable and 'Yes' or 'No', bAnimFreezeLastFrame and 'Yes' or 'No' )
	then
		local iID = g_pDB:InsertID();
		
		if iID then
			return self:Add( iID, iModel, vecPosition, fRotation, iInterior, iDimension, sAnimLib, sAnimName, iAnimTime, bAnimLoop, bAnimUpdatePos, bAnimInterruptable, bAnimFreezeLastFrame, bCollisions, bFrozen, bDamageProof );
		end
		
		return NULL;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return NULL;
end

function CPedManager:Add( iID, iModel, vecPosition, fRotation, iInterior, iDimension, sAnimLib, sAnimName, iAnimTime, bAnimLoop, bAnimUpdatePos, bAnimInterruptable, bAnimFreezeLastFrame, bCollisions, bFrozen, bDamageProof )
	local pPed = CPed( iModel, vecPosition, fRotation );
	
	if pPed.m_ID ~= INVALID_ELEMENT_ID then
		pPed.m_ID 					= iID;
		pPed.m_sAnimLib 			= sAnimLib or NULL;
		pPed.m_sAnimName			= sAnimName or NULL;
		pPed.m_iAnimTime			= (int)(iAnimTime);
		pPed.m_bAnimLoop			= (bool)(bAnimLoop);
		pPed.m_bAnimUpdatePos		= (bool)(bAnimUpdatePos);
		pPed.m_bAnimInterruptable	= (bool)(bAnimInterruptable);
		pPed.m_bAnimFreezeLastFrame	= (bool)(bAnimFreezeLastFrame);
		
		pPed:SetInterior( iInterior );
		pPed:SetDimension( iDimension );
		pPed:SetCollisionsEnabled( bCollisions == NULL or (bool)(bCollisions) );
		pPed:SetFrozen( (bool)(bFrozen) );
		pPed:SetData( "DamageProof", (bool)(bDamageProof) );
		
		self:AddToList( pPed );
		
		return pPed;
	end
	
	return false;
end

function CPedManager:Remove( iID )
	local pPed = self:Get( iID );
	
	if pPed then
		if g_pDB:Query( "UPDATE " + DBPREFIX + "peds SET deleted = 'Yes' WHERE id = " + iID ) then
			delete ( pPed );
			
			return true;
		end
		
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
	return false;
end

function CPedManager:DoPulse( tReal )
	for _, pPed in pairs( self.m_List ) do
		pPed:DoPulse( tReal );
	end
end