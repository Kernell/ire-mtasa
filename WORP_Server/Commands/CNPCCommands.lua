-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CNPCCommands";

function CNPCCommands:Create( pPlayer, sCmd, sOption, sModel )
	local iModel = (int)(sModel);
	
	if iModel > 0 then
		local vecPosition	= pPlayer:GetPosition();
		local fRotation		= pPlayer:GetRotation();
		local iInterior		= pPlayer:GetInterior();
		local iDimension	= pPlayer:GetDimension();
		
		local pNPC = g_pGame:GetNPCManager():Create( iModel, vecPosition, fRotation, iInterior, iDimension );
		
		if pNPC then
			return TEXT_NPC_CREATED:format( pNPC:GetID() ), 0, 255, 128;
		end
		
		return TEXT_NPC_INVALID_MODEL, 255, 0, 0;
	end
	
	return false;
end

function CNPCCommands:Remove( pPlayer, sCmd, sOption, sID )
	local iID = (int)(sID);
	
	if iID > 0 then
		if g_pGame:GetNPCManager():Remove( iID ) then
			return TEXT_NPC_REMOVED:format( iID ), 128, 255, 0;
		end
		
		return TEXT_NPC_REMOVE_FAILED:format( iID ), 255, 0, 0;
	end
		
	return false;
end

function CNPCCommands:SetPosition( pPlayer, sCmd, sOption, sID, sX, sY, sZ, sRotation )
	local iID = (int)(sID);
	
	if iID > 0 then
		local pNPC = g_pGame:GetNPCManager():Get( iID );
		
		if pNPC then
			local vecPosition = sX ~= "NULL" and sY ~= "NULL" and sZ ~= "NULL" and Vector3( sX, sY, sZ ) or pPlayer:GetPosition();
			
			if not g_pDB:Query( "UPDATE " + DBPREFIX + "npc SET position = '" + vecPosition + "'" + ( sRotation and ", rotation = " + (float)(sRotation) or "" ) + " WHERE id = " + iID ) then
				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			pNPC:SetPosition( vecPosition );
			
			if sRotation then
				pNPC:SetRotation( (float)(sRotation) );
			end
			
			return TEXT_NPC_POSITION_UPDATED:format( iID, (string)(pNPC:GetPosition()), (string)(pNPC:GetRotation()) ), 0, 255, 128;
		end
		
		return TEXT_NPC_NOT_FOUND_ID:format( iID ), 255, 0, 0;
	end
	
	return false;
end

function CNPCCommands:AddAnimation( pPlayer, sCmd, sOption, sID, sLib, sName, iTime, bLoop, bUpdatePosition, bInterruptable, bFreezeLastFrame )
	local iID = (int)(sID);
	
	if iID == 0 and sLib and sName then
		return false;
	end
	
	local pNPC = g_pGame:GetNPCManager():Get( iID );
	
	if pNPC == NULL then
		return TEXT_NPC_NOT_FOUND_ID:format( iID ), 255, 0, 0;
	end
	
	local pAnimation =
	{
		[ PED_ANIMATION_LIB ] 					= sLib;
		[ PED_ANIMATION_NAME ]					= sName;
		[ PED_ANIMATION_TIME ]					= (int)(iTime);
		[ PED_ANIMATION_LOOP ]					= (bool)(bLoop);
		[ PED_ANIMATION_UPDATE_POS ]			= (bool)(bUpdatePosition);
		[ PED_ANIMATION_INTERRUPTABLE ]			= (bool)(bInterruptable);
		[ PED_ANIMATION_FREEZE_LAST_FRAME ]		= (bool)(bFreezeLastFrame);
	};
	
	table.insert( pNPC.m_aAnimationCycle, pAnimation );
	
	if not g_pDB:Query( "UPDATE " + DBPREFIX + "npc SET animation_cycle = '" + toJSON( pNPC.m_aAnimationCycle ) + "' WHERE id = " + iID ) then
		table.remove( pNPC.m_aAnimationCycle );
		
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR, 255, 0, 0;
	end
	
	pNPC.m_iAnimTimeEnd	= 0;
	pNPC.m_iAnimIndex	= 0;
	
	return TEXT_NPC_ANIMATION_UPDATED:format( iID ), 0, 255, 128;
	
end

function CNPCCommands:ClearAnimations( pPlayer, sCmd, sOption, sID )
	local iID = (int)(sID);
	
	if iID == 0 then
		return false;
	end
	
	local pNPC = g_pGame:GetNPCManager():Get( iID );
	
	if pNPC == NULL then
		return TEXT_NPC_NOT_FOUND_ID:format( iID ), 255, 0, 0;
	end
	
	if not g_pDB:Query( "UPDATE " + DBPREFIX + "npc SET animation_cycle = NULL WHERE id = " + iID ) then
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR, 255, 0, 0;
	end
	
	pNPC.m_aAnimationCycle = NULL;
	
	pNPC.m_iAnimTimeEnd		= 0;
	pNPC.m_iAnimIndex		= 0;
	
	return TEXT_NPC_ANIMATION_CLEARED:format( iID ), 0, 255, 128;
end

function CNPCCommands:SetFrozen( pPlayer, sCmd, sOption, sID, sbFrozen )
	local iID = (int)(sID);
	
	if iID > 0 then
		local pNPC = g_pGame:GetNPCManager():Get( iID );
		
		if pNPC then
			local bFrozen = (bool)(sbFrozen);
			
			if g_pDB:Query( "UPDATE " + DBPREFIX + "npc SET frozen = %q WHERE id = " + iID, bFrozen and "Yes" or "No" ) then
				pNPC:SetFrozen( bFrozen );
				
				return ( bFrozen and TEXT_NPC_FROZEN or TEXT_NPC_UNFROZEN ):format( iID ), 0, 255, 128;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return TEXT_NPC_NOT_FOUND_ID:format( iID ), 255, 0, 0;
	end
	
	return false;
end

function CNPCCommands:SetDamageProof( pPlayer, sCmd, sOption, sID, sbDamageProof )
	local iID = (int)(sID);
	
	if iID > 0 then
		local pNPC = g_pGame:GetNPCManager():Get( iID );
		
		if pNPC then
			local bDamageProof = (bool)(sbDamageProof);
			
			if g_pDB:Query( "UPDATE " + DBPREFIX + "npc SET damage_proof = %q WHERE id = " + iID, bDamageProof and "Yes" or "No" ) then
				pNPC:SetData( "DamageProof", bDamageProof );
				
				return ( bDamageProof and TEXT_NPC_DAMAGE_PROOF_ENABLED or TEXT_NPC_DAMAGE_PROOF_DISABLED ):format( iID ), 0, 255, 128;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return TEXT_NPC_NOT_FOUND_ID:format( iID ), 255, 0, 0;
	end
	
	return false;
end

function CNPCCommands:SetCollisions( pPlayer, sCmd, sOption, sID, sbCollisions )
	local iID = (int)(sID);
	
	if iID > 0 then
		local pNPC = g_pGame:GetNPCManager():Get( iID );
		
		if pNPC then
			local bCollisions = (bool)(sbCollisions);
			
			if g_pDB:Query( "UPDATE " + DBPREFIX + "npc SET collisions_enabled = %q WHERE id = " + iID, bCollisions and 'Yes' or 'No' ) then
				pNPC:SetCollisionsEnabled( bCollisions );
				
				return ( bCollisions and TEXT_NPC_COLLISIONS_ENABLED or TEXT_NPC_COLLISIONS_DISABLED ):format( iID ), 0, 255, 128;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return TEXT_NPC_NOT_FOUND_ID:format( iID ), 255, 0, 0;
	end
	
	return false;
end

function CNPCCommands:SetInteractive( pPlayer, sCmd, sOption, sID, sCommand )
	local iID = (int)(sID);
	
	if iID > 0 then
		local pNPC = g_pGame:GetNPCManager():Get( iID );
		
		if pNPC then
			if g_pDB:Query( "UPDATE " + DBPREFIX + "npc SET interactive_command = %q WHERE id = " + iID, sCommand ) then
				pNPC.m_sInteractiveCommand = sCommand;
				
				return TEXT_NPC_INTERACTIVE_COMMAND_UPDATED:format( iID, sCommand ), 0, 255, 128;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return TEXT_NPC_NOT_FOUND_ID:format( iID ), 255, 0, 0;
	end
	
	return false;
end

function CNPCCommands:ToggleLabels( pPlayer )
	pPlayer:SetData( "CPed::DrawLabels", not pPlayer:GetData( "CPed::DrawLabels" ) );
	
	return true;
end

function CNPCCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end