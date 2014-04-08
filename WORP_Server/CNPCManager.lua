-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CNPCManager ( CManager )
{
	CNPCManager			= function( this )
		this:CManager();
	end;
	
	Init			= function( this )
		g_pDB:CreateTable( DBPREFIX + "npc",
			{
				{ Field = "id",								Type = "int(11) unsigned",		Null = "NO",	Key = "PRI", 	Default = NULL,	Extra = "auto_increment" };
				{ Field = "model",							Type = "int(3)",				Null = "NO",	Key = "", 		Default = NULL };
				{ Field = "position",						Type = "text",					Null = "NO",	Key = "", 		Default = NULL };
				{ Field = "rotation",						Type = "text",					Null = "NO",	Key = "", 		Default = NULL };
				{ Field = "interior",						Type = "smallint(3)",			Null = "NO",	Key = "", 		Default = 0 };
				{ Field = "dimension",						Type = "smallint(6)",			Null = "NO",	Key = "", 		Default = 0 };
				{ Field = "interactive_command",			Type = "varchar(255)",			Null = "YES",	Key = "", 		Default = NULL };
				{ Field = "collisions_enabled",				Type = "enum('Yes', 'No')",		Null = "NO",	Key = "", 		Default = "Yes" };
				{ Field = "damage_proof",					Type = "enum('Yes', 'No')",		Null = "NO",	Key = "", 		Default = "No" };
				{ Field = "frozen",							Type = "enum('Yes', 'No')",		Null = "NO",	Key = "", 		Default = "No" };
				{ Field = "animation_lib",					Type = "varchar(255)",			Null = "YES",	Key = "", 		Default = NULL };
				{ Field = "animation_name",					Type = "varchar(255)",			Null = "YES",	Key = "", 		Default = NULL };
				{ Field = "animation_time",					Type = "int(4)",				Null = "No",	Key = "", 		Default = -1 };
				{ Field = "animation_loop",					Type = "enum('Yes', 'No')",		Null = "NO",	Key = "", 		Default = "Yes" };
				{ Field = "animation_update_position",		Type = "enum('Yes', 'No')",		Null = "NO",	Key = "", 		Default = "Yes" };
				{ Field = "animation_interruptable",		Type = "enum('Yes', 'No')",		Null = "NO",	Key = "", 		Default = "Yes" };
				{ Field = "animation_freeze_last_frame",	Type = "enum('Yes', 'No')",		Null = "NO",	Key = "", 		Default = "Yes" };
				{ Field = "deleted",						Type = "timestamp",				Null = "YES",	Key = "", 		Default = NULL };
			}
		);
		
		this.m_List	= {};
		
		local sQuery = "\
			SELECT \
				id, model, position, rotation, dimension, interior, interactive_command, \
				collisions_enabled, damage_proof, frozen, \
				animation_lib, animation_name, animation_time, animation_loop, animation_update_position, \
				animation_interruptable, animation_freeze_last_frame \
			FROM " + DBPREFIX + "npc \
			WHERE deleted IS NULL \
			ORDER BY id ASC";
		
		local pResult = g_pDB:Query( sQuery );
		
		if pResult then
			for i, pRow in ipairs( pResult:GetArray() ) do
				this:Add( pRow.id, pRow.model, Vector3( pRow.position ), pRow.rotation, pRow.interior, pRow.dimension, pRow.animation_lib, pRow.animation_name, pRow.animation_time,
					pRow.animation_loop == "Yes",
					pRow.animation_update_position == "Yes",
					pRow.animation_interruptable == "Yes",
					pRow.animation_freeze_last_frame == "Yes",
					pRow.collisions_enabled == "Yes",
					pRow.frozen == "Yes",
					pRow.damage_proof == "Yes",
					pRow.interactive_command
				);
			end
			
			delete ( pResult );
		else
			Debug( g_pDB:Error(), 1 );
			
			return false;
		end
		
		return true;
	end;
	
	ClientHandle		= function( this, pClient, sCommand, pNPC, ... )
		local pChar = pClient:GetChar();
		
		if not pChar then
			return AsyncQuery.UNAUTHORIZED;
		end
		
		if not pNPC or not pNPC:IsValid() or this:Get( pNPC:GetID() ) ~= pNPC then
			Debug( "NPC is invalid (" + (string)(pNPC) + ")", 2 );
			
			return AsyncQuery.BAD_REQUEST;
		end
		
		if sCommand == "Interact" then
			local sNPCCommand = pNPC.m_sInteractiveCommand;
			
			if sNPCCommand == "test" then
				Debug( "CPedManager->ClientHandle( " + pClient:GetID() + ", " + pNPC:GetID() + " )" );
			elseif sNPCCommand then
				Debug( "NPC interactive command '" + (string)(sNPCCommand) + "' not found", 2 );
			end
			
			return true;
		end
		
		return AsyncQuery.BAD_REQUEST;
	end;
	
	Create	= function( this, iModel, vecPosition, fRotation, iInterior, iDimension, sAnimLib, sAnimName, iAnimTime, bAnimLoop, bAnimUpdatePos, bAnimInterruptable, bAnimFreezeLastFrame, bCollisions, bFrozen, bDamageProof, sInteractiveCommand )
		local Data	=
		{
			model						= iModel;
			position					= (string)(vecPosition);
			rotation					= fRotation;
			interior					= iInterior;
			dimension					= iDimension;
			interactive_command			= sInteractiveCommand;
			animation_lib				= sAnimLib;
			animation_name				= sAnimName;
			animation_time				= (int)(iAnimTime);
			animation_loop				= bAnimLoop and "Yes" or "No";
			animation_update_position	= bAnimUpdatePos and "Yes" or "No";
			animation_interruptable		= bAnimInterruptable and "Yes" or "No";
			animation_freeze_last_frame	= bAnimFreezeLastFrame and "Yes" or "No";
		};
		
		local iID = g_pDB:Insert( DBPREFIX + "npc", Data );
		
		if iID then
			return this:Add( iID, iModel, vecPosition, fRotation, iInterior, iDimension, sAnimLib, sAnimName, iAnimTime, bAnimLoop, bAnimUpdatePos, bAnimInterruptable, bAnimFreezeLastFrame, bCollisions, bFrozen, bDamageProof, sInteractiveCommand );
		end
		
		Debug( g_pDB:Error(), 1 );
		
		return NULL;
	end;
	
	Add	= function( this, iID, iModel, vecPosition, fRotation, iInterior, iDimension, sAnimLib, sAnimName, iAnimTime, bAnimLoop, bAnimUpdatePos, bAnimInterruptable, bAnimFreezeLastFrame, bCollisions, bFrozen, bDamageProof, sInteractiveCommand )
		local pNPC = CNPC( iID, iModel, vecPosition, fRotation );
		
		if pNPC:IsValid() then
			pNPC.m_sInteractiveCommand	= sInteractiveCommand;
			pNPC.m_sAnimLib 			= sAnimLib or NULL;
			pNPC.m_sAnimName			= sAnimName or NULL;
			pNPC.m_iAnimTime			= (int)(iAnimTime);
			pNPC.m_bAnimLoop			= (bool)(bAnimLoop);
			pNPC.m_bAnimUpdatePos		= (bool)(bAnimUpdatePos);
			pNPC.m_bAnimInterruptable	= (bool)(bAnimInterruptable);
			pNPC.m_bAnimFreezeLastFrame	= (bool)(bAnimFreezeLastFrame);
			
			pNPC:SetID( "npc:" + iID );
			pNPC:SetInterior( iInterior );
			pNPC:SetDimension( iDimension );
			pNPC:SetCollisionsEnabled( bCollisions == NULL or (bool)(bCollisions) );
			pNPC:SetFrozen( (bool)(bFrozen) );
			pNPC:SetData( "DamageProof", (bool)(bDamageProof) );
			pNPC:SetData( "Interactive", sInteractiveCommand );
			
			if pNPC.m_sAnimLib then
				pNPC:SetAnimation( pNPC.m_sAnimLib, pNPC.m_sAnimName, pNPC.m_iAnimTime, pNPC.m_bAnimLoop, pNPC.m_bAnimUpdatePos, pNPC.m_bAnimInterruptable, pNPC.m_bAnimFreezeLastFrame );
			end
			
			return pNPC;
		end
		
		return false;
	end;
	
	Remove		= function( this, iID )
		local pNPC = this:Get( iID );
		
		if pNPC then
			if g_pDB:Query( "UPDATE " + DBPREFIX + "npc SET deleted = NOW() WHERE id = " + iID ) then
				delete ( pNPC );
				
				return true;
			end
			
			Debug( g_pDB:Error(), 1 );
			
			return false;
		end
		
		return false;
	end;

	DoPulse		= function( this, tReal )
		for i, pNPC in pairs( this.m_List ) do
			pNPC:DoPulse( tReal );
		end
	end;
};