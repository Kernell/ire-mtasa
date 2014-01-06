-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CPedCommands"

function CPedCommands:Create( pPlayer, sCmd, sOption, sModel )
	local iModel = (int)(sModel);
	
	if iModel > 0 then
		local vecPosition	= pPlayer:GetPosition();
		local fRotation		= pPlayer:GetRotation();
		local iInterior		= pPlayer:GetInterior();
		local iDimension	= pPlayer:GetDimension();
		
		local pPed = g_pGame:GetPedManager():Create( iModel, vecPosition, fRotation, iInterior, iDimension );
		
		if pPed then
			return "Пед успешно создан, ID: " + (string)(pPed.m_ID), 0, 255, 128;
		end
		
		return "Не корректная модель", 255, 0, 0;
	end
	
	return false;
end

function CPedCommands:Remove( pPlayer, sCmd, sOption, sID )
	local iID = (int)(sID);
	
	if iID > 0 then
		if g_pGame:GetPedManager():Remove( iID ) then
			return "Пед ID " + iID + " успешно удалён", 128, 255, 0;
		end
		
		return "Ошибка при удалении педа ID " + iID, 255, 0, 0;
	end
		
	return false;
end

function CPedCommands:SetPosition( pPlayer, sCmd, sOption, sID, sX, sY, sZ, sRotation )
	local iID = (int)(sID);
	
	if iID > 0 then
		local pPed = g_pGame:GetPedManager():Get( iID );
		
		if pPed then
			local vecPosition = sX ~= "NULL" and sY ~= "NULL" and sZ ~= "NULL" and Vector3( sX, sY, sZ ) or pPlayer:GetPosition();
			
			if not g_pDB:Query( "UPDATE " + DBPREFIX + "peds SET position = '" + vecPosition + "'" + ( sRotation and ", rotation = " + (float)(sRotation) or "" ) + " WHERE id = " + iID ) then
				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			pPed:SetPosition( vecPosition );
			
			if sRotation then
				pPed:SetRotation( (float)(sRotation) );
			end
			
			return "Позиция педа ID " + iID + " успешно обновлена " + pPed:GetPosition() + " " + pPed:GetRotation(), 0, 255, 128;
		end
		
		return "Не удалось найти педа с ID " + iID, 255, 0, 0;
	end
	
	return false;
end

function CPedCommands:SetAnimation( pPlayer, sCmd, sOption, sID, sLib, sName, iTime, bLoop, bUpdatePosition, bInterruptable, bFreezeLastFrame )
	local iID = (int)(sID);
	
	if iID > 0 and sLib and sName then
		local pPed = g_pGame:GetPedManager():Get( iID );
		
		if pPed then
			pPed.m_sAnimLib 			= sLib;
			pPed.m_sAnimName			= sName;
			pPed.m_iAnimTime			= (int)(iTime);
			pPed.m_bAnimLoop			= (bool)(bLoop);
			pPed.m_bAnimUpdatePos		= (bool)(bUpdatePosition);
			pPed.m_bAnimInterruptable	= (bool)(bInterruptable);
			pPed.m_bAnimFreezeLastFrame	= (bool)(bFreezeLastFrame);
			
			if g_pDB:Query( "UPDATE " + DBPREFIX + "peds SET animation_lib = %q, animation_name = %q, animation_time = %d, animation_loop = %q, animation_update_position = %q, animation_interruptable = %q, animation_freeze_last_frame = %q WHERE id = " + pPed.m_ID,
				pPed.m_sAnimLib, pPed.m_sAnimName, pPed.m_iAnimTime, pPed.m_bAnimLoop and "Yes" or "No", pPed.m_bAnimUpdatePos and "Yes" or "No", pPed.m_bAnimInterruptable and "Yes" or "No", pPed.m_bAnimFreezeLastFrame and "Yes" or "No" )
			then
				pPed:SetAnimation( pPed.m_sAnimLib, pPed.m_sAnimName, pPed.m_iAnimTime, pPed.m_bAnimLoop, pPed.m_bAnimUpdatePos, pPed.m_bAnimInterruptable, pPed.m_bAnimFreezeLastFrame );
				
				return "Анимация педа ID " + iID + " успешно обновлена", 0, 255, 128;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return "Не возможно найти педа с ID " + iID, 255, 0, 0;
	end
	
	return false;
end

function CPedCommands:SetFrozen( pPlayer, sCmd, sOption, sID, sbFrozen )
	local iID = (int)(sID);
	
	if iID > 0 then
		local pPed = g_pGame:GetPedManager():Get( iID );
		
		if pPed then
			local bFrozen = (bool)(sbFrozen);
			
			if g_pDB:Query( "UPDATE " + DBPREFIX + "peds SET frozen = %q WHERE id = " + iID, bFrozen and 'Yes' or 'No' ) then
				pPed:SetFrozen( bFrozen );
				
				return "Пед ID " + iID + " успешно " + ( bFrozen and 'заморожен' or 'разморожен' ), 0, 255, 128;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return "Не возможно найти педа с ID " + iID, 255, 0, 0;
	end
	
	return false;
end

function CPedCommands:SetDamageProof( pPlayer, sCmd, sOption, sID, sbDamageProof )
	local iID = (int)(sID);
	
	if iID > 0 then
		local pPed = g_pGame:GetPedManager():Get( iID );
		
		if pPed then
			local bDamageProof = (bool)(sbDamageProof);
			
			if g_pDB:Query( "UPDATE " + DBPREFIX + "peds SET damage_proof = %q WHERE id = " + iID, bDamageProof and 'Yes' or 'No' ) then
				pPed:SetData( "DamageProof", bDamageProof );
				
				return "Повреждения для педа ID " + iID + " " + ( bDamageProof and 'выключены' or 'включены' ), 0, 255, 128;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return "Не возможно найти педа с ID " + iID, 255, 0, 0;
	end
	
	return false;
end

function CPedCommands:SetCollisions( pPlayer, sCmd, sOption, sID, sbCollisions )
	local iID = (int)(sID);
	
	if iID > 0 then
		local pPed = g_pGame:GetPedManager():Get( iID );
		
		if pPed then
			local bCollisions = (bool)(sbCollisions);
			
			if g_pDB:Query( "UPDATE " + DBPREFIX + "peds SET collisions_enabled = %q WHERE id = " + iID, bCollisions and 'Yes' or 'No' ) then
				pPed:SetCollisionsEnabled( bCollisions );
				
				return "Коллизия для педа ID " + iID + " успешно " + ( bCollisions and 'включена' or 'выключена' ), 0, 255, 128;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return "Не возможно найти педа с ID " + iID, 255, 0, 0;
	end
	
	return false;
end

function CPedCommands:ToggleLabels( pPlayer )
	pPlayer:SetData( "CPed::DrawLabels", not pPlayer:GetData( "CPed::DrawLabels" ) );
	
	return true;
end

function CPedCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end