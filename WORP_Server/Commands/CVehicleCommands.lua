-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CVehicleCommands"

function CVehicleCommands:Create( pPlayer, sCmd, sOption, ... )
	if not pPlayer:IsInGame() then
		return true;
	end
	
	local sModel = table.concat( { ... }, ' ' );
	
	local iModel = tonumber( sModel ) or g_pGame:GetVehicleManager():GetModelByName( sModel );
	
	if iModel then
		local pVehicleManager = g_pGame:GetVehicleManager();
		
		if pVehicleManager:IsValidModel( iModel ) then
			local fRotation		= pPlayer:GetRotation();
			local iDimension	= pPlayer:GetDimension();
			local iInterior		= pPlayer:GetInterior();
			local vecPosition	= pPlayer:GetPosition():Offset( 1.4, fRotation );
			local vecRotation	= Vector3( 0, 0, fRotation + 90 );
			
			local pVehicle = pVehicleManager:Create( iModel, vecPosition, vecRotation, iInterior, iDimension );
			
			if pVehicle then
				pPlayer:GetChat():Send( ( "Автомобиль %q успешно создан (ID: %d)" ):format( pVehicle:GetName(), pVehicle:GetID() ), 0, 255, 64 );
			else
				pPlayer:GetChat():Error( "Не удалось получить идентификатор" );
			end
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_MODEL );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:Delete( pPlayer, sCmd, sOption, sVehicleID )
	local iVehicleID = tonumber( sVehicleID );
	
	if iVehicleID then
		local pVehicle = g_pGame:GetVehicleManager():Get( iVehicleID );
		
		if pVehicle then
			if pVehicle:GetID() < 0 or pPlayer:HaveAccess( 'command.' + sCmd + ':create' ) then
				if g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET deleted = NOW() WHERE id = " + pVehicle:GetID() ) then
					pPlayer:GetChat():Send( TEXT_VEHICLES_REMOVE_SUCCESS:format( pVehicle:GetName(), pVehicle:GetID() ), 0, 255, 64 );
					
					local Occupants = pVehicle:GetOccupants();
					
					if Occupants then
						for i, pPlr in pairs( Occupants ) do
							pPlr:RemoveFromVehicle();
						end
					end
					
					delete( pVehicle );
				else
					pPlayer:GetChat():Send( TEXT_DB_ERROR, 255, 0, 0 );
					
					Debug( g_pDB:Error(), 1 );
				end
			else
				pPlayer:GetChat():Error( TEXT_VEHICLES_ACCESS_DENIED );
			end
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_ID );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:Restore( pPlayer, sCmd, sOption, sDBID )
	local iDBID = tonumber( sDBID );
	
	if iDBID then
		local pResult = g_pDB:Query( "SELECT * FROM " + DBPREFIX + "vehicles WHERE id = %d AND deleted IS NOT NULL", iDBID );
		
		if pResult then
			local pRow = pResult:FetchRow();
			
			delete ( pResult );
			
			if pRow then
				if g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET deleted = NULL WHERE id = %d", sDBID ) then
					local pVehicle	= g_pGame:GetVehicleManager():Add( pRow.id, pRow.model, Vector3( pRow.x, pRow.y, pRow.z ), Vector3( pRow.rx, pRow.ry, pRow.rz ), pRow.plate, 0, 0, pRow );
					
					pVehicle:SetInterior( pRow.interior );
					pVehicle:SetDimension( pRow.dimension );
					
					return TEXT_VEHICLES_RESTORE_SUCCESS:format( pVehicle:GetName(), pVehicle:GetID() ), 0, 255, 64;
				end
				
				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return TEXT_VEHICLES_INVALID_DB_ID, 255, 0, 0;
		end
		
		Debug( g_pDB:Error(), 1 );
		
		return TEXT_DB_ERROR, 255, 0, 0;
	end
	
	return false;
end

function CVehicleCommands:SetFrozen( pPlayer, sCmd, sOption, sID, bFrozen )
	local iID	= tonumber( sID );
	
	if iID then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			pVehicle.m_bFrozen = (bool)(bFrozen);
			pVehicle:SetFrozen( pVehicle.m_bFrozen );
			
			return "Автомобиль #" + iID + ( pVehicle.m_bFrozen and " заморожен" or " разморожен" ), 0, 255, 128;
		end
		
		return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CVehicleCommands:SetFuel( pPlayer, sCmd, sOption, sID, sFuel )
	if not pPlayer:IsInGame() then
		return true;
	end
	
	local iID 		= tonumber( sID );
	local fFuel		= tonumber( sFuel );
	
	if iID and fFuel then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			fFuel = Clamp( 0, fFuel, 100 );
			
			pVehicle:SetFuel( fFuel );
			
			pPlayer:GetChat():Send( TEXT_VEHICLES_FUEL_CHANGED:format( pVehicle:GetName(), pVehicle:GetID(), fFuel ), 0, 255, 128 );
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_ID );
		end
		
		return true;
	end	
	
	return false;
end

function CVehicleCommands:SetColor( pPlayer, sCmd, sOption, sID, ... )
	local Args = { ... };
	
	if sID and table.getn( Args ) > 0 then
		if Args[ 1 ]:len() == 3 then
			return CVehicleCommands:SetColor_1( pPlayer, sCmd, sOption, sID, ... );
		elseif Args[ 1 ]:len() == 6 then
			return CVehicleCommands:SetColor_2( pPlayer, sCmd, sOption, sID, ... );
		end
	end
	
	return false;
end

function CVehicleCommands:SetColor_1( pPlayer, sCmd, sOption, sID, iR1, iG1, iB1, iR2, iG2, iB2, iR3, iG3, iB3, iR4, iG4, iB4 )
	local iID	= tonumber( sID );
	
	if iID then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			iR1	= ( iR1 or 255 ) % 256;
			iG1	= ( iG1 or 255 ) % 256;
			iB1	= ( iB1 or 255 ) % 256;
			
			iR2	= ( iR2 or 255 ) % 256;
			iG2	= ( iG2 or 255 ) % 256;
			iB2	= ( iB2 or 255 ) % 256;
			
			iR3	= ( iR3 or 255 ) % 256;
			iG3	= ( iG3 or 255 ) % 256;
			iB3	= ( iB3 or 255 ) % 256;
			
			iR4	= ( iR4 or 255 ) % 256;
			iG4	= ( iG4 or 255 ) % 256;
			iB4	= ( iB4 or 255 ) % 256;
			
			if pVehicle:SetColor( iR1, iG1, iB1, iR2, iG2, iB2, iR3, iG3, iB3, iR4, iG4, iB4 ) then
				local sJsonColor	= toJSON( { iR1, iG1, iB1, iR2, iG2, iB2, iR3, iG3, iB3, iR4, iG4, iB4 } );
				
				if g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET color = '" + sJsonColor + "' WHERE id = " + pVehicle:GetID() ) then
					return TEXT_VEHICLES_COLOR_CHANGED:format( pVehicle:GetName(), pVehicle:GetID(), sJsonColor ), 0, 255, 128;
				end
				
				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return TEXT_VEHICLES_INVALID_COLOR, 255, 0, 0;
		end
		
		return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CVehicleCommands:SetColor_2( pPlayer, sCmd, sOption, sID, sHex1, sHex2, sHex3, sHex4 )
	local iID	= tonumber( sID );
	
	if iID then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			local iHex1	= ( sHex1 or "FFFFFF" ):ToNumber( 16 );
			local iHex2	= ( sHex2 or "FFFFFF" ):ToNumber( 16 );
			local iHex3	= ( sHex3 or "FFFFFF" ):ToNumber( 16 );
			local iHex4	= ( sHex4 or "FFFFFF" ):ToNumber( 16 );
			
			local iR1 = (byte)(iHex1 ">>" (16));
			local iG1 = (byte)(iHex1 ">>" (8));
			local iB1 = (byte)(iHex1 ">>" (0));
			
			local iR2 = (byte)(iHex2 ">>" (16));
			local iG2 = (byte)(iHex2 ">>" (8));
			local iB2 = (byte)(iHex2 ">>" (0));
			
			local iR3 = (byte)(iHex3 ">>" (16));
			local iG3 = (byte)(iHex3 ">>" (8));
			local iB3 = (byte)(iHex3 ">>" (0));
			
			local iR4 = (byte)(iHex4 ">>" (16));
			local iG4 = (byte)(iHex4 ">>" (8));
			local iB4 = (byte)(iHex4 ">>" (0));
			
			if pVehicle:SetColor( iR1, iG1, iB1, iR2, iG2, iB2, iR3, iG3, iB3, iR4, iG4, iB4 ) then
				local sJsonColor	= toJSON( { iR1, iG1, iB1, iR2, iG2, iB2, iR3, iG3, iB3, iR4, iG4, iB4 } );
				
				if g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET color = '" + sJsonColor + "' WHERE id = " + pVehicle:GetID() ) then
					return TEXT_VEHICLES_COLOR_CHANGED:format( pVehicle:GetName(), pVehicle:GetID(), sJsonColor ), 0, 255, 128;
				end
				
				Debug( g_pDB:Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return TEXT_VEHICLES_INVALID_COLOR, 255, 0, 0;
		end
		
		return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CVehicleCommands:Repair( pPlayer, sCmd, sOption, sID )
	if not pPlayer:IsInGame() then
		return true;
	end
	
	local sID = tonumber( sID );
	
	local pVehicle = g_pGame:GetVehicleManager():Get( sID ) or pPlayer:GetVehicle();
	
	if pVehicle then
		pVehicle:Fix();
		pVehicle:SetDamageProof( false );
		
		pPlayer:GetChat():Send( TEXT_VEHICLES_VEHICLE_FIXED:format( pVehicle:GetName(), pVehicle:GetID() ), 0, 255, 128 );
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:Flip( pPlayer, sCmd, sOption, sID )
	if not pPlayer:IsInGame() then
		return true;
	end
	
	local pVehicle = g_pGame:GetVehicleManager():Get( tonumber( sID ) ) or pPlayer:GetVehicle();
	
	if pVehicle then
		pVehicle:SetRotation( Vector3( 0, 0, pVehicle:GetRotation().Z - 180 ) );
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:ToggleLabels( pPlayer, sCmd, sOption, sfDistance )
	if not pPlayer:IsInGame() then
		return true;
	end
	
	pPlayer:Client().VehiclesToggleLabels( sfDistance );
	
	return true;
end

function CVehicleCommands:Get( pPlayer, sCmd, sOption, sID )
	local iID = tonumber( sID );
	
	if iID then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then	
			local fRotation		= pPlayer:GetRotation();
			
			pVehicle:SetVelocity()
			pVehicle:SetPosition( pPlayer:GetPosition():Offset( 2.5, fRotation ) );
			pVehicle:SetRotation( Vector3( 0, 0, fRotation + 90 ) );
			pVehicle:SetInterior( pPlayer:GetInterior() );
			pVehicle:SetDimension( pPlayer:GetDimension() );
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_ID );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:Goto( pPlayer, sCmd, sOption, sID )
	local iID = tonumber( sID );
	
	if iID then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			local vecRotation	= pVehicle:GetRotation();
			
			pPlayer:SetPosition( pVehicle:GetPosition():Offset( 2.5, vecRotation.Z ) );
			pPlayer:SetRotation( vecRotation.Z + 90 );
			pPlayer:SetInterior( pVehicle:GetInterior() );
			pPlayer:SetDimension( pVehicle:GetDimension() );
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_ID );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:Spawn( pPlayer, sCmd, sOption, ... )
	if not pPlayer:IsInGame() then
		return true;
	end
	
	local sModel = table.concat( { ... }, ' ' );
	
	local iModel = tonumber( sModel ) or g_pGame:GetVehicleManager():GetModelByName( sModel );
	
	if iModel then
		local pVehicleManager = g_pGame:GetVehicleManager();
		
		if pVehicleManager:IsValidModel( iModel ) then
			local iID = NULL;
			
			for i = -1, -64, -1 do
				if not pVehicleManager:Get( i ) then
					iID = i;
					
					break;
				end
			end
			
			if iID then
				local fRotation		= pPlayer:GetRotation();
				local vecPosition	= pPlayer:GetPosition():Offset( 2.5, fRotation );
				local vecRotation	= Vector3( 0, 0, fRotation + 90 );
				local sPlate		= ( "%03d NULL" ):format( iID );
				
				local pVehicle = CVehicle( pVehicleManager, iID, iModel, vecPosition, vecRotation, sPlate );
				
				pVehicle:SetInterior( pPlayer:GetInterior() );
				pVehicle:SetDimension( pPlayer:GetDimension() );
				
				pPlayer:GetChat():Send( TEXT_VEHICLES_TEMP_CAR_CREATED:format( pVehicle:GetName(), pVehicle:GetID() ), 0, 255, 128 );
			else
				pPlayer:GetChat():Error( TEXT_NOT_ENOUGH_MEMORY );
			end
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_MODEL );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:Respawn( pPlayer, sCmd, sOption, sID )
	if not pPlayer:IsInGame() then
		return true;
	end
	
	local iID = tonumber( sID );
	
	if iID then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			local result = g_pDB:Query( "SELECT * FROM " + DBPREFIX + "vehicles WHERE id = " + pVehicle:GetID() );
			
			if result then
				local row = result:FetchRow();
				
				delete ( result );
				
				if row then
					pVehicle:RespawnSafe();
					
					pPlayer:GetChat():Send( TEXT_VEHICLES_RESPAWNED:format( pVehicle:GetName(), pVehicle:GetID() ), 0, 255, 128 );
				else
					pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_DB_ID );
				end
			else
				pPlayer:GetChat():Send( TEXT_DB_ERROR, 255, 0, 0 );
				
				Debug( g_pDB:Error(), 1 );
			end
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_ID );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:RespawnAll( pPlayer, sCmd, sOption )
	
	for i, pVeh in pairs( g_pGame:GetVehicleManager():GetAll() ) do
		local Occupants = pVeh:GetOccupants();
		
		if Occupants then
			if sizeof( Occupants ) == 0 then
				pVeh:RespawnSafe();
			end
		elseif _DEBUG then
			Debug( "Invalid vehicle, ID: " + (string)(pVeh:GetID()) );
		end
	end

	g_pGame:GetVehicleManager():SaveAll();
	
	SendAdminsMessage( pPlayer:GetUserName() + ' respawned all vehicles' );
	
	return true;
end

function CVehicleCommands:SaveAll( pPlayer )
	g_pGame:GetVehicleManager():SaveAll();
	
	SendAdminsMessage( pPlayer:GetUserName() + ' saved all vehicles' );
	
	return true;
end

function CVehicleCommands:SetModel( pPlayer, sCmd, sOption, sID, ... )
	if not pPlayer:IsInGame() then
		return true;
	end
	
	local iID		= tonumber( sID );
	local sModel	= table.concat( { ... }, ' ' );
	
	if iID and sModel:len() > 0 then
		local iModel	= tonumber( sModel ) or g_pGame:GetVehicleManager():GetModelByName( sModel );
		
		if iModel then
			local pVehicle = g_pGame:GetVehicleManager():Get( iID );
			
			if pVehicle then
				local sOldName	= pVehicle:GetName();
				local sOldModel	= pVehicle:GetModel();
				
				if pVehicle:SetModel( iModel ) then
					if g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET model = " + pVehicle:GetModel() + " WHERE id = " + pVehicle:GetID() ) then
						g_pServer:Print( "CVehicleCommands:SetModel( %s, %s, " + sOldModel + " -> " + sModel + " )", pPlayer:GetUserName(), sID );
						
						pPlayer:GetChat():Send( TEXT_VEHICLES_MODEL_CHANGED:format( sOldName, pVehicle:GetID(), pVehicle:GetName(), pVehicle:GetModel() ), 0, 255, 128 );
					else
						pPlayer:GetChat():Send( TEXT_DB_ERROR, 255, 0, 0 );
						
						Debug( g_pDB:Error(), 1 );
					end
				else
					pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_MODEL );
				end
			else
				pPlayer:GetChat():Send( TEXT_VEHICLES_INVALID_ID, 255, 0, 0 );
			end
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_MODEL );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:SetSpawn( pPlayer, sCmd, sOption, sID )
	if not pPlayer:IsInGame() then
		return true;
	end
	
	local pVehicle = g_pGame:GetVehicleManager():Get( tonumber( sID ) ) or pPlayer:GetVehicle();
	
	if pVehicle then
		local vecPosition	= pVehicle:GetPosition();
		local vecRotation	= pVehicle:GetRotation();
		local iInterior		= pVehicle:GetInterior();
		local iDimension	= pVehicle:GetDimension();
		
		pVehicle.m_vecDefaultPosition	= vecPosition;
		pVehicle.m_vecDefaultRotation	= vecRotation;
		pVehicle.m_iDefaultInterior		= iInterior;
		pVehicle.m_iDefaultDimension	= iDimension;
		
		pVehicle:SetRespawnPosition		( vecPosition, vecRotation );
		
		if g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET default_x = %f, default_y = %f, default_z = %f, default_rx = %f, default_ry = %f, default_rz = %f, default_interior = %d, default_dimension = %d WHERE id = " + pVehicle:GetID(), vecPosition.X, vecPosition.Y, vecPosition.Z, vecRotation.X, vecRotation.Y, vecRotation.Z, iInterior, iDimension ) then
			pPlayer:GetChat():Send( TEXT_VEHICLES_RESPAWN_CHANGED:format( pVehicle:GetName(), pVehicle:GetID() ), 0, 255, 128 );
		else
			pPlayer:GetChat():Send( TEXT_DB_ERROR, 255, 0, 0 );
			
			Debug( g_pDB:Error(), 1 );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:SetPlate( pPlayer, sCmd, sOption, sID, ... )
	if not pPlayer:IsInGame() then
		return true;
	end
	
	local iID		= tonumber( sID );
	local sPlate	= table.concat( { ... }, ' ' );
	
	if iID and sPlate:len() > 0 then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			if pVehicle:SetRegPlate( sPlate ) then
				pPlayer:GetChat():Send( TEXT_VEHICLES_PLATE_CHANGED:format( pVehicle:GetName(), iID, sPlate ), 0, 255, 128 );
			else
				pPlayer:GetChat():Send( TEXT_DB_ERROR, 255, 0, 0 );
				
				Debug( g_pDB:Error(), 1 );
			end
		else
			pPlayer:GetChat():Send( TEXT_VEHICLES_INVALID_ID, 255, 0, 0 );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:SetVariant( pPlayer, sCmd, sOption, sID, sVariant1, sVariant2 )
	local iID		= tonumber( sID );
	local iVariant1	= tonumber( sVariant1 );
	local iVariant2	= tonumber( sVariant2 );
	
	if iID and iVariant1 and iVariant2 then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			if g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET variants = '" + toJSON( { iVariant1, iVariant2 } ) + "' WHERE id = " + pVehicle:GetID() ) then
				pPlayer:GetChat():Send( TEXT_VEHICLES_VARIANT_CHANGED:format( pVehicle:GetName(), pVehicle:GetID(), iVariant1, iVariant2 ), 0, 255, 128 );
				
				pVehicle:SetVariant( iVariant1, iVariant2 );
			else
				pPlayer:GetChat():Send( TEXT_DB_ERROR, 255, 0, 0 );
			end
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_ID );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:SetUpgrade( pPlayer, sCmd, sOption, sID, sUpgrade )
	local iID		= tonumber( sID );
	
	if iID then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			sUpgrade = sUpgrade:ToNumber() or sUpgrade;
			
			if pVehicle:GetUpgrades().m_Upgrades[ sUpgrade ] then
				pVehicle:GetUpgrades():Remove( sUpgrade )
			else
				if not pVehicle:GetUpgrades():Add( sUpgrade ) then
					return "Ошибка при установке компонента (возможно не совместим)", 255, 0, 0;
				end
			end
			
			if pVehicle:GetID() > 0 then
				local sUpgrades	= pVehicle:GetUpgrades():ToJSON();
				
				if sUpgrades then
					sUpgrades = "'" + sUpgrades + "'";
				else
					sUpgrades = "NULL";
				end
				
				if not g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET upgrades = " + sUpgrades + " WHERE id = " + pVehicle:GetID() ) then
					return TEXT_DB_ERROR, 255, 0, 0;
				end
			end
			
			return true;
		end
		
		return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CVehicleCommands:SetData( pPlayer, sCmd, sOption, sID, sDataName, sValue )
	local iID		= tonumber( sID );
	
	if iID and sDataName and sValue then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			if not pVehicle.m_Data then
				pVehicle.m_Data = {};
			end
			
			if sValue == "NULL" then
				pVehicle.m_Data[ sDataName ] = NULL;
				
				pVehicle:RemoveData( sDataName );
			else
				pVehicle.m_Data[ sDataName ] = sValue;
				
				pVehicle:SetData( sDataName, sValue );
			end
			
			local sData	= toJSON( pVehicle.m_Data );
			
			if sData then
				sData = "'" + sData + "'";
			else
				sData = "NULL";
			end
			
			if not g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET element_data = " + sData + " WHERE id = " + pVehicle:GetID() ) then
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return true;
		end
		
		return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
	end
	
	return false;
end

function CVehicleCommands:SetOwner( pPlayer, sCmd, sOption, sID, sTargetID )
	local iID		= tonumber( sID );
	local iTargetID	= tonumber( sTargetID );
	
	if iID and iTargetID then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			local pTarget = g_pGame:GetPlayerManager():Get( iTargetID );
			
			if pTarget then
				if pVehicle:SetOwner( pTarget:GetChar() ) then
					printf( "%s changed owner vehicle %s (ID %d) for %s (User: %s ID: %d)", pPlayer:GetUserName(), pVehicle:GetName(), pVehicle:GetID(), pTarget:GetName(), pTarget:GetUserName(), pTarget:GetUserID() );
					
					pPlayer:GetChat():Send( TEXT_VEHICLES_OWNER_CHANGED:format( pTarget:GetName(), pTarget:GetID(), pVehicle:GetName(), pVehicle:GetID() ), 0, 255, 128 );
					pTarget:GetChat():Send( ( "%s %s сделал Вас владельцем автомобиля %s (ID %d)" ):format( pPlayer:GetGroups()[1]:GetCaption(), pPlayer:GetUserName(), pVehicle:GetName(), pVehicle:GetID() ), 0, 255, 128 );
				else
					pPlayer:GetChat():Send( TEXT_DB_ERROR, 255, 0, 0 );
				end
			else
				pPlayer:GetChat():Error( TEXT_PLAYER_NOT_FOUND );
			end
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_ID );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:SetRentable( pPlayer, sCmd, sOption, sID, sbRentable )
	local iID			= tonumber( sID );
	
	if iID and sbRentable then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			pVehicle:SetRentable( tobool( sbRentable ) );
			pVehicle:SetRentTime( 0 );
			
			pPlayer:GetChat():Send( "›› Done", 0, 128, 255 );
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_ID );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:SetRentPrice( pPlayer, sCmd, sOption, sID, sAmount )
	local iID		= tonumber( sID );
	local iAmount	= (int)(sAmount);
	
	if iID and iAmount > 0 then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			pVehicle:SetRentPrice( iAmount );
			
			pPlayer:GetChat():Send( "›› Done", 0, 128, 255 );
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_ID );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:SetFaction( pPlayer, sCmd, sOption, sID, sFactionID )
	local iID		= tonumber( sID );
	local iFaction	= tonumber( sFactionID );
	
	if iID and iFaction then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			local pFaction = g_pGame:GetFactionManager():Get( iFaction );
			
			if pFaction then
				if pVehicle:SetFaction( pFaction ) then
					printf( "%s changed faction vehicle %s (ID %d) for %s (ID: %d)", pPlayer:GetUserName(), pVehicle:GetName(), pVehicle:GetID(), pFaction:GetName(), pFaction:GetID() );
					
					pPlayer:GetChat():Send( TEXT_VEHICLES_FACTION_CHANGED:format( pVehicle:GetName(), pVehicle:GetID(), pFaction:GetName() ), 0, 255, 128 );
				else
					pPlayer:GetChat():Send( TEXT_DB_ERROR, 255, 0, 0 );
				end
			else
				pPlayer:GetChat():Error( TEXT_FACTIONS_INVALID_ID );
			end
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_ID );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:SetJob( pPlayer, sCmd, sOption, sID, sJobID ) -- TODO: CVehicle::SetJob
	local iID		= tonumber( sID );
	
	if iID and sJobID then
		local pVehicle = g_pGame:GetVehicleManager():Get( iID );
		
		if pVehicle then
			local pJob = CJob.GetByID( sJobID ) or CJob.GetByCode( (int)(sJobID) );
			
			if pJob then
				if g_pDB:Query( "UPDATE " + DBPREFIX + "vehicles SET character_id = " + ( -pJob:GetCode() ) + " WHERE id = " + pVehicle:GetID() ) then
					pVehicle.m_iCharID = -pJob:GetCode();
					pVehicle:SetData( 'character_id', pVehicle.m_iCharID );
					
					printf( "%s changed job vehicle %s (ID %d) for %s (ID: %d)", pPlayer:GetUserName(), pVehicle:GetName(), pVehicle:GetID(), pJob:GetName(), pJob:GetCode() );
					
					pPlayer:GetChat():Send( TEXT_VEHICLES_JOB_CHANGED:format( pVehicle:GetName(), pVehicle:GetID(), pJob:GetName() ), 0, 255, 128 );
				else
					pPlayer:GetChat():Send( TEXT_DB_ERROR, 255, 0, 0 );
				end
			else
				pPlayer:GetChat():Error( TEXT_JOBS_INVALID_ID );
			end
		else
			pPlayer:GetChat():Error( TEXT_VEHICLES_INVALID_ID );
		end
		
		return true;
	end
	
	return false;
end

function CVehicleCommands:Shop( pPlayer, sCmd, sOption, sOption2, ... )
	if not pPlayer:IsInGame() then return (1) end
	
	local options = 
	{ 
		reload = function() 
			return CVehicle.InitShops( true );
		end;
		
		create = function( ... )
			local models = { ... };
			
			if models and #models > 0 then
				local m = {};
				
				for _, _model in ipairs( models ) do
					local model = tonumber( _model ) or g_pGame:GetVehicleManager():GetModelByName( _model );
					
					if model then
						table.insert( m, model );
					else
						pPlayer:GetChat():Error( "Неизвестная модель " + (string)( _model ) );
						
						return true;
					end
				end
				
				local pos = pPlayer:GetPosition();
				
				assert( g_pDB:Query( "INSERT INTO " + DBPREFIX + "vehicles_shop (models,x,y,z) VALUES ('" + table.concat( m, ',' ) + "', " + pos.X + ", " + pos.Y + ", " + pos.Z + ")" ) );
				
				CVehicle.InitShops();
				
				pPlayer:GetChat():Send( "Автосалон успешно добавлен в базу (ID: " .. g_pDB:InsertID() .. ")", 0, 255, 255 );
			else
				pPlayer:GetChat():Error( "Впишите модели через пробел" );
			end
		end;
		
		remove = function( shop_id )
			
		end;
		
		addspot = function( shop_id )
			shop_id = tonumber( shop_id );
			
			if shop_id then
				local result = assert( g_pDB:Query( "SELECT COUNT(id) AS count FROM " .. DBPREFIX .. "vehicles_shop WHERE deleted = 'No' AND id = " .. shop_id ) );
				
				local row = result:FetchRow();
				
				delete ( result );
				
				if row.count == 0 then
					pPlayer:GetChat():Error( "Invalid shop id" );
					
					return true;
				end
				
				local vehicle = pPlayer:GetVehicle();
				
				local pos = vehicle and vehicle:GetPosition() or pPlayer:GetPosition();
				local rot = vehicle and vehicle:GetRotation() or Vector3( 0, 0, pPlayer:GetRotation() );
				local int = pPlayer:GetInterior();
				local dim = pPlayer:GetDimension();
				
				assert( g_pDB:Query( "INSERT INTO " .. DBPREFIX .. "vehicles_shop_spots (shop_id,x,y,z,rx,ry,rz,interior,dimension) VALUES (%d,%f,%f,%f,%f,%f,%f,%d,%d)", shop_id, pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z, int, dim ) );
				
				pPlayer:GetChat():Send( "Spot added (ID: " .. g_pDB:InsertID() .. ")", 0, 255, 255 );
			else
				pPlayer:GetChat():Error( "Shop id is required" );
			end
		end;
		
		removespot = function( spot_id )
			
		end;
	};
	
	if options[ sOption2 ] then
		options[ sOption2 ]( ... );
		
		return true;
	end	
	
	return false;
end

function CVehicleCommands:Fuelpoint( pPlayer,sCmd, sOption, sOption2, ... )
	if not pPlayer:IsInGame() then return (1) end
	
	local options =
	{
		add = function()
			local vecPosition = pPlayer:GetPosition();
			
			assert( g_pDB:Query( "INSERT INTO " + DBPREFIX + "fuelpoints (x,y,z) VALUES (" + vecPosition.X + "," + vecPosition.Y + ", " + ( vecPosition.Z - .7 ) + ")" ) );
			
			local iID		= g_pDB:InsertID();
			local pResult	= g_pDB:Query( "SELECT * FROM " + DBPREFIX + "fuelpoints WHERE id = " + iID );
			
			if pResult then
				AddFuelpoint( pResult:FetchRow() );
			else
				Debug( g_pDB:Error(), 1 );
			end
			
			delete ( pResult );
			
			pPlayer:GetChat():Send( "Fuelpoint added, ID: " + (string)(iID), 0, 255, 128 );
		end;
	};
	
	if options[ sOption2 ] then
		options[ sOption2 ]( ... );
		
		return true;
	end
	
	return false;
end