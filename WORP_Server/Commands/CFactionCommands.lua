-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class "CFactionCommands"

function CFactionCommands:Edit( pPlayer, sCmd, sOption, siID, ... )
	if pPlayer:IsInGame() then
		if siID then		
			local pFaction = g_pGame:GetFactionManager():Get( (int)(siID) );
			
			if pFaction then
				if ( ... ) then
					local Update = {};
					
					for Param, Value in CCommand:ReadParams( ... ) do
						if Param == "owner_id" 			then
							Value = tonumber( Value );
							
							if Value then
								pFaction.m_iOwnerID		= Value;
							end
						elseif Param == "bank_acc_id" 	then
							pFaction.m_sBankAccountID	= Value;
						elseif Param == "name" 			then
							pFaction.m_sName			= Value;
						elseif Param == "tag" 			then
							pFaction.m_sTag				= Value;
						elseif Param == "address" 		then
							pFaction.m_sAddress			= Value;
						elseif Param == "type" 			then
							pFaction.m_iType			= Value;
						elseif Param == "flags" 		then
							pFaction.m_aFlags = {};
							
							for i, f in ipairs( Value:split( "," ) ) do								
								pFaction.m_aFlags[ f ] = true;
							end
						else
							return sCmd + " " + sOption + ": unknown option -- " + Param, 255, 0, 0;
						end
						
						if Value then
							Update[ Param ] = Value;
						end
					end
					
					local sUpdate = NULL;
					
					for k, v in pairs( Update ) do
						if sUpdate ~= NULL then
							sUpdate = sUpdate + ", ";
						end
						
						sUpdate = ( sUpdate or "" ) + "`" + k + "` = '" + v + "'";
					end
					
					if sUpdate then
						g_pDB:Query( "UPDATE " + DBPREFIX + "factions SET " + sUpdate + " WHERE id = " + pFaction:GetID() );
					end
				else
					pFaction:Show( pPlayer, true );
				end
				
				return true;
			end
		end
	end
	
	return false;
end

function CFactionCommands:Create( pPlayer, sCmd, sOption, sClass, sTag, ... )
	local sName = table.concat( { ... }, ' ' );
	
	if type( sClass ) == "string" and sTag and sName:len() > 0 then
		local TFaction = _G[ sClass ];
		
		if not TFaction or not TFaction.m_bIsFaction then
			return TEXT_FACTIONS_INVALID_CLASS:format( sClass ), 255, 0, 0;
		end
		
		for iFactionID, pFaction in pairs( g_pGame:GetFactionManager():GetAll() ) do
			if pFaction:GetName() == sName then
				return TEXT_FACTIONS_NAME_EXISTS:format( sName ), 255, 0, 0;
			end
			
			if pFaction:GetTag() == sTag then
				return TEXT_FACTIONS_TAG_EXISTS:format( sTag ), 255, 0, 0;
			end
		end
		
		local pFaction = g_pGame:GetFactionManager():Create( TFaction, sName, sTag );
		
		if pFaction then
			g_pServer:Print( "%s created faction - %s[%d]::%s", pPlayer:GetUserName(), classname( TFaction ), pFaction:GetID(), sName );
			
			return TEXT_FACTIONS_CREATION_SUCCESS:format( sName, sTag, pFaction:GetID() ), 0, 255, 0;
		end
		
		return TEXT_FACTIONS_CREATION_FAILED, 255, 0, 0;
	end
	
	return false;
end

function CFactionCommands:Help( pPlayer, sCmd, sOption )
	pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
	
	self:List( pPlayer );
	
	return true;
end