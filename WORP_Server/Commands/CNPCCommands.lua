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

function CNPCCommands:SetAnimation( pPlayer, sCmd, sOption, sID, sLib, sName, iTime, bLoop, bUpdatePosition, bInterruptable, bFreezeLastFrame )
	local iID = (int)(sID);
	
	if iID > 0 and sLib and sName then
		local pNPC = g_pGame:GetNPCManager():Get( iID );
		
		if pNPC then
			pNPC.m_sAnimLib 			= sLib;
			pNPC.m_sAnimName			= sName;
			pNPC.m_iAnimTime			= (int)(iTime);
			pNPC.m_bAnimLoop			= (bool)(bLoop);
			pNPC.m_bAnimUpdatePos		= (bool)(bUpdatePosition);
			pNPC.m_bAnimInterruptable	= (bool)(bInterruptable);
			pNPC.m_bAnimFreezeLastFrame	= (bool)(bFreezeLastFrame);
			
			if g_pDB:Query( "UPDATE " + DBPREFIX + "npc SET animation_lib = %q, animation_name = %q, animation_time = %d, animation_loop = %q, animation_update_position = %q, animation_interruptable = %q, animation_freeze_last_frame = %q WHERE id = " + pNPC:GetID(),
				pNPC.m_sAnimLib, pNPC.m_sAnimName, pNPC.m_iAnimTime, pNPC.m_bAnimLoop and "Yes" or "No", pNPC.m_bAnimUpdatePos and "Yes" or "No", pNPC.m_bAnimInterruptable and "Yes" or "No", pNPC.m_bAnimFreezeLastFrame and "Yes" or "No" )
			then
				pNPC:SetAnimation( pNPC.m_sAnimLib, pNPC.m_sAnimName, pNPC.m_iAnimTime, pNPC.m_bAnimLoop, pNPC.m_bAnimUpdatePos, pNPC.m_bAnimInterruptable, pNPC.m_bAnimFreezeLastFrame );
				
				return TEXT_NPC_ANIMATION_UPDATED:format( iID ), 0, 255, 128;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return TEXT_NPC_NOT_FOUND_ID:format( iID ), 255, 0, 0;
	end
	
	return false;
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