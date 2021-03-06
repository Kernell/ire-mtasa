-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. CC_Vehicle : IConsoleCommand
{
	CC_Vehicle	= function( ... )
		this.IConsoleCommand( ... );
	end;
	
	Execute		= function( player, option, option2, ... )
		if not player.IsInGame() then
			return true;
		end
		
		if option2 == "-h" or option2 == "--help" then
			return this.Info( option );
		end
		
		if option == "create" then
			return this.VehicleCreate( player, option, option2, ... );
		end
		
		if option == "delete" then
			return this.VehicleDelete( player, option, option2 );
		end
		
		if option == "restore" then
			return this.VehicleRestore( player, option, option2 );
		end
		
		if option == "get" then
			return this.VehicleGet( player, option, option2 );
		end
		
		if option == "goto" then
			return this.VehicleGoTo( player, option, option2 );
		end
		
		if option == "spawn" then
			return this.VehicleSpawn( player, option, option2, ... );
		end
		
		if option == "respawn" then
			return this.VehicleRespawn( player, option, option2 );
		end
		
		if option == "respawnall" then
			return this.VehicleRespawnAll( player, option, option2 );
		end
		
		if option == "repair" then
			return this.VehicleRepair( player, option, option2 );
		end
		
		if option == "flip" then
			return this.VehicleFlip( player, option, option2 );
		end
		
		if option == "setfrozen" then
			return this.VehicleSetFrozen( player, option, option2, ... );
		end
		
		if option == "setfuel" then
			return this.VehicleSetFrozen( player, option, option2, ... );
		end
		
		if option == "setcolor" then
			return this.VehicleSetColor( player, option, option2, ... );
		end
		
		if option == "setmodel" then
			return this.VehicleSetModel( player, option, option2, ... );
		end
		
		if option == "setspawn" then
			return this.VehicleSetSpawn( player, option, option2, ... );
		end
		
		if option == "setplate" then
			return this.VehicleSetPlate( player, option, option2, ... );
		end
		
		if option == "setvariant" then
			return this.VehicleSetVariant( player, option, option2, ... );
		end
		
		if option == "setupgrade" then
			return this.VehicleSetUpgrade( player, option, option2, ... );
		end
		
		if option == "setdata" then
			return this.VehicleSetData( player, option, option2, ... );
		end
		
		if option == "setcharacter" then
			return this.VehicleSetCharacter( player, option, option2, ... );
		end
		
		if option == "setfaction" then
			return this.VehicleSetFaction( player, option, option2, ... );
		end
		
		if option == "saveall" then
			return this.VehicleSaveAll( player, option );
		end
		
		if option == "setdebug" then
			return this.VehicleSetDebug( player, option, option2, ... );
		end
		
		if option == "-h" or option == "--help" then
			return this.Info();
		end
		
		return "Syntax: /" + this.Name + " <option>", 255, 255, 255;
	end;
	
	VehicleCreate	= function( player, option, model, ... )
		if model then
			local modelID = tonumber( model ) or VehicleManager.GetModelByName( model );
			
			local vehicleManager = Server.Game.VehicleManager;
			
			if vehicleManager.IsValidModel( modelID ) then
				local rotation		= player.GetRotation();
				local dimension		= player.GetDimension();
				local interior		= player.GetInterior();
				local position		= player.GetPosition().Offset( 1.4, rotation.Z );
				
				rotation.X	= 0.0;
				rotation.Y	= 0.0;
				rotation.Z	= rotation.Z + 90.0;
				
				local data	=
				{
					model		= modelID;
					position	= position;
					rotation	= rotation;
					interior	= interior;
					dimension	= dimension;
				};
				
				local flags		= { ... };
				
				if table.getn( flags ) > 0 then
					local i, f = next( flags );
					
					while i do
						local ii, ff = next( flags, i );
						
						if ff == NULL or ii == NULL or ff[ 1 ] == '-' then
							return "Syntax: /" + this.Name + " " + option + " <model> " + f + " <value> [flags...]", 255, 0, 0;
						end
						
						if 		f == '-c' or f == '--color' then
							local color;
							
							i, color		= next( flags, i );
							
							color = color:split( "," );
							
							local r, g, b = tonumber( color[ 1 ] ), tonumber( color[ 2 ] ), tonumber( color[ 3 ] );
							
							if r and g and b then
								data.color = { r % 255, g % 255, b % 255 };
							else
								return "Не верно задан цвет", 255, 0, 0;
							end
						elseif 		f == '-p' or f == '--plate' then
							local plate;
							
							i, plate		= next( flags, i );
							
							data.plate		= plate;
						elseif 		f == '-v' or f == '--variants' then
							local variants;
							
							i, variants		= next( flags, i );
							
							variants = variants:split( "," );
							
							local a, b = tonumber( variants[ 1 ] ), tonumber( variants[ 2 ] );
							
							if a and b then
								data.variants = { a % 255, b % 255 };
							else
								return "Не верно задан extra parts", 255, 0, 0;
							end
						elseif 		f == '-E' or f == '--element_data' then
							local element_data;
							
							i, element_data		= next( flags, i );
							
							local E = element_data:split( "=" );
							
							if table.getn( E ) == 2 then
								data.element_data	= { [ E[ 1 ] ] = E[ 2 ] };
							else
								return "Не правильно задан Element Data. Используйте формат: " + f + " key=value", 255, 0, 0;
							end
						else
							return "Неизвестный флаг '" + f + "'", 255, 0, 0;
						end
						
						i, f = next( flags, i );
					end
				end
				
				local vehicle = vehicleManager.Create( data );
				
				if vehicle then
					return string.format( "Автомобиль %q успешно создан (ID: %d)", vehicle.GetName(), vehicle.GetID() ), 0, 255, 64;
				end
				
				return "Ошибка: Не удалось получить идентификатор", 255, 0, 0;
			end
			
			return TEXT_VEHICLES_INVALID_MODEL, 255, 0, 0;
		end
		
		return "Syntax: /" + this.Name + " " + option + " <model> [flags]";
	end;
	
	VehicleDelete	= function( player, option, id )
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			if vehicle.GetID() < 0 or player.HaveAccess( "command." + this.Name + ".create" ) then
				if Server.DB.Query( "UPDATE " + Server.DB.Prefix + "vehicles SET deleted = NOW() WHERE id = " + vehicle.GetID() ) then
					
					local occupants = vehicle.GetOccupants();
					
					if occupants then
						for i, plr in pairs( occupants ) do
							plr.RemoveFromVehicle();
						end
					end
					
					local text = TEXT_VEHICLES_REMOVE_SUCCESS:format( vehicle.GetName(), vehicle.GetID() );
					
					delete( vehicle );
					
					return text, 0, 255, 64;
				else
					Debug( Server.DB.Error(), 1 );
					
					return TEXT_DB_ERROR, 255, 0, 0;
				end
			else
				return TEXT_VEHICLES_ACCESS_DENIED, 255, 128, 0;
			end
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id]", 255, 255, 255;
	end;
	
	VehicleRestore	= function( player, option, id )
		local ID = tonumber( id );
		
		if ID then
			local result = Server.DB.Query( "SELECT * FROM " + Server.DB.Prefix + "vehicles WHERE id = %d AND deleted IS NOT NULL", ID );
			
			if result then
				local row = result.GetRow();
				
				result.Free();
				
				if row then
					if Server.DB.Query( "UPDATE " + Server.DB.Prefix + "vehicles SET deleted = NULL WHERE id = %d", sDBID ) then
						local vehicle = Server.Game.VehicleManager.Add( row.id, row.model, new. Vector3( row.position ), new. Vector3( row.rotation ), row );
						
						return TEXT_VEHICLES_RESTORE_SUCCESS:format( vehicle.GetName(), vehicle.GetID() ), 0, 255, 64;
					end
					
					Debug( Server.DB.Error(), 1 );
					
					return TEXT_DB_ERROR, 255, 0, 0;
				end
				
				return TEXT_VEHICLES_INVALID_DB_ID, 255, 0, 0;
			end
			
			Debug( Server.DB.Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return "Syntax: /" + this.Name + " " + option + " <id в базе>", 255, 255, 255;
	end;
	
	VehicleGet		= function( player, option, id )
		local ID = tonumber( id );
		
		if ID then
			local vehicle = Server.Game.VehicleManager.Get( ID );
			
			if vehicle then	
				local rotation		= player.GetRotation();
				
				rotation.X	= 0;
				rotation.Y	= 0;
				
				vehicle.SetVelocity()
				vehicle.SetPosition( player.GetPosition().Offset( 2.5, rotation.Z ) );
				
				rotation.Z	= rotation.Z + 90;
				
				vehicle.SetRotation( rotation );
				vehicle.SetInterior( player.GetInterior() );
				vehicle.SetDimension( player.GetDimension() );
				
				return true;
			end
			
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		return "Syntax: /" + this.Name + " " + option + " <id>", 255, 255, 255;
	end;
	
	VehicleGoTo		= function( player, option, id )
		local ID = tonumber( id );
		
		if ID then
			local vehicle = Server.Game.VehicleManager.Get( ID );
			
			if vehicle then
				local rotation	= vehicle.GetRotation();
				
				player.SetPosition( vehicle.GetPosition().Offset( 2.5, rotation.Z ) );
				
				rotation.Z = rotation.Z + 90;
				
				player.SetRotation( rotation );
				player.SetInterior( vehicle.GetInterior() );
				player.SetDimension( vehicle.GetDimension() );
				
				return true;
			end
			
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		return "Syntax: /" + this.Name + " " + option + " <id>", 255, 255, 255;
	end;
	
	VehicleSpawn	= function( player, option, ... )
		local model = table.concat( { ... }, " " );
		
		if model:len() > 0 then
			local vehicleManager = Server.Game.VehicleManager;
			
			local model = tonumber( model ) or vehicleManager.GetModelByName( model );
			
			if model then
				if vehicleManager.IsValidModel( model ) then
					local ID = NULL;
					
					for i = -1, -64, -1 do
						if not vehicleManager.Get( i ) then
							ID = i;
							
							break;
						end
					end
					
					if ID then
						local rotation	= player.GetRotation();
						
						local position	= player.GetPosition().Offset( 2.5, rotation.Z );
						
						rotation.X	= 0.0;
						rotation.Y	= 0.0;
						rotation.Z	= rotation.Z + 90.0;
						
						local data	=
						{
							interior	= player.GetInterior();
							dimension	= player.GetDimension();
							plate		= ( "%03d NULL" ):format( ID );
						};
						
						local vehicle = vehicleManager.Add( ID, model, position, rotation, data );
						
						return TEXT_VEHICLES_TEMP_CAR_CREATED:format( vehicle.GetName(), vehicle.GetID() ), 0, 255, 128;
					end
					
					return TEXT_NOT_ENOUGH_MEMORY, 255, 0, 0;
				end
				
				return TEXT_VEHICLES_INVALID_MODEL, 255, 0, 0;
			end
		end
		
		return "Syntax: /" + this.Name + " " + option + " <model>", 255, 255, 255;
	end;
	
	VehicleRespawn	= function( player, option, id )
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			local result = Server.DB.Query( "SELECT * FROM " + Server.DB.Prefix + "vehicles WHERE id = " + vehicle.GetID() );
			
			if result then
				local row = result.GetRow();
				
				result.Free();
				
				if row then
					vehicle.RespawnSafe();
					
					return TEXT_VEHICLES_RESPAWNED:format( vehicle.GetName(), vehicle.GetID() ), 0, 255, 128;
				end
				
				return TEXT_VEHICLES_INVALID_DB_ID, 255, 0, 0;
			end
			
			Debug( Server.DB.Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id]", 255, 255, 255;
	end;
	
	VehicleRespawnAll	= function( player, option )
		for i, vehicle in pairs( Server.Game.VehicleManager.GetAll() ) do
			local occupants = vehicle.GetOccupants();
			
			if occupants then
				if sizeof( occupants ) == 0 then
					vehicle.RespawnSafe();
				end
			elseif _DEBUG then
				Debug( "Invalid vehicle, ID: " + (string)(vehicle.ID) );
			end
		end

		Server.Game.VehicleManager.SaveAll();
		
		AdminManager.SendMessage( player.UserName + " respawned all vehicles" );
		
		return true;
	end;
	
	VehicleRepair	= function( player, option, id )
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			vehicle.Fix();
			vehicle.SetDamageProof( false );
			
			return TEXT_VEHICLES_VEHICLE_FIXED:format( vehicle.GetName(), vehicle.GetID() ), 0, 255, 128;
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id]", 255, 255, 255;
	end;
	
	VehicleFlip		= function( player, option, id )
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			vehicle.SetRotation( new. Vector3( 0.0, 0.0, vehicle.GetRotation().Z - 180.0 ) );
			
			return true;
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id]", 255, 255, 255;
	end;
	
	VehicleSetFrozen	= function( player, option, ... )
		local id, frozen;
		
		local args = { ... };
		local len = table.getn( args );
		
		if len == 2 then
			id		= args[ 1 ];
			frozen	= args[ 2 ];
		elseif len == 1 then
			frozen	= args[ 1 ];
		end
		
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			vehicle.Frozen = (bool)(frozen);
			vehicle.SetFrozen( vehicle.Frozen );
			
			return "Автомобиль #" + vehicle.GetID() + ( vehicle.Frozen and " заморожен" or " разморожен" ), 0, 255, 128;
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id] [frozen = false]", 255, 255, 255;
	end;
	
	VehicleSetFuel	= function( player, option, ... )
		local id, fuel;
		
		local args = { ... };
		local len = table.getn( args );
		
		if len == 2 then
			id		= args[ 1 ];
			fuel	= args[ 2 ];
		elseif len == 1 then
			fuel	= args[ 1 ];
		end
		
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			fuel = Clamp( 0, fuel, 100 );
			
			vehicle.SetFuel( fuel );
			
			return TEXT_VEHICLES_FUEL_CHANGED:format( vehicle.GetName(), vehicle.GetID(), fuel ), 0, 255, 128;
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id] <fuel>", 255, 255, 255;
	end;
	
	VehicleSetColor	= function( player, option, ... )
		local id;
		local colors = {};
		
		local args = { ... };
		local len = table.getn( args );
		
		if len > 1 then
			for i = 1, len do
				local arg = args[ i ];
				
				if arg:lower():match( "0x%x%x%x%x%x%x" ) or arg:lower():match( "%x%x%x%x%x%x" ) then
					colors[ i ] = tonumber( arg, 16 );
				elseif tonumber( arg ) then
					id = tonumber( arg );
				end
			end
		elseif len == 1 then
			colors[ 1 ]	= args[ 1 ];
		end
		
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			local color = {};
			
			for i, c in ipairs( colors ) do
				table.insert( color, (byte)(c ">>" (16)) );
				table.insert( color, (byte)(c ">>" (8) ));
				table.insert( color, (byte)(c ">>" (0) ));
			end
			
			if vehicle.SetColor( unpack( color ) ) then
				local jsonColor	= toJSON( color );
				
				if Server.DB.Query( "UPDATE " + Server.DB.Prefix + "vehicles SET color = '" + jsonColor + "' WHERE id = " + vehicle.GetID() ) then
					return TEXT_VEHICLES_COLOR_CHANGED:format( vehicle.GetName(), vehicle.GetID(), jsonColor ), 0, 255, 128;
				end
				
				Debug( Server.DB.Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id] <color1> [color2] [color3] [color4]", 255, 255, 255;
	end;
	
	VehicleSetModel	= function( player, option, ... )
		local id, model;
		
		local args = { ... };
		local len = table.getn( args );
		
		if len == 2 then
			id		= args[ 1 ];
			model	= args[ 2 ];
		elseif len == 1 then
			model	= args[ 1 ];
		end
		
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			local oldName	= vehicle.GetName();
			local oldModel	= vehicle.GetModel();
			
			if vehicle.SetModel( model ) then
				if vehicle.GetID() < 0 or Server.DB.Query( "UPDATE " + Server.DB.Prefix + "vehicles SET model = " + vehicle.GetModel() + " WHERE id = " + vehicle.GetID() ) then
					Console.Log( "CC_Vehicle->SetModel( %s, %d, " + oldModel + " -> " + model + " )", player.UserName, vehicle.GetID() );
					
					return TEXT_VEHICLES_MODEL_CHANGED:format( oldName, vehicle.GetID(), vehicle.GetName(), vehicle.GetModel() ), 0, 255, 128;
				end
				
				Debug( Server.DB.Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return TEXT_VEHICLES_INVALID_MODEL, 255, 0, 0;
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id] <model>", 255, 255, 255;
	end;
	
	VehicleSetSpawn	= function( player, option, id )
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			local position	= vehicle.GetPosition();
			local rotation	= vehicle.GetRotation();
			local interior	= vehicle.GetInterior();
			local dimension	= vehicle.GetDimension();
			
			vehicle.DefaultPosition		= position;
			vehicle.DefaultRotation		= rotation;
			vehicle.DefaultInterior		= interior;
			vehicle.DefaultDimension	= dimension;
			
			vehicle.SetRespawnPosition( position, rotation );
			
			local query = "UPDATE " + Server.DB.Prefix + "vehicles SET default_position = %q, default_rotation = %q, default_interior = %d, default_dimension = %d WHERE id = %d";
			
			if Server.DB.Query( query, position.ToString(), rotation.ToString(), interior, dimension, vehicle.GetID() ) then
				return TEXT_VEHICLES_RESPAWN_CHANGED:format( vehicle.GetName(), vehicle.GetID() ), 0, 255, 128;
			end
			
			Debug( Server.DB.Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id]", 255, 255, 255;
	end;
	
	VehicleSetPlate	= function( player, option, ... )
		local id, plate;
		
		local args = { ... };
		local len = table.getn( args );
		
		if len == 2 then
			id		= args[ 1 ];
			plate	= args[ 2 ];
		elseif len == 1 then
			plate	= args[ 1 ];
		end
		
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			if vehicle.SetRegPlate( plate ) then
				return TEXT_VEHICLES_PLATE_CHANGED:format( vehicle.GetName(), vehicle.GetID(), plate ), 0, 255, 128;
			end
			
			Debug( Server.DB.Error(), 1 );
			
			return TEXT_DB_ERROR, 255, 0, 0;
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id] <text>", 255, 255, 255;
	end;
	
	VehicleSetVariant	= function( player, option, ... )
		local id, variant1, variant2;
		
		local args = { ... };
		local len = table.getn( args );
		
		if len == 3 then
			id			= args[ 1 ];
			variant1	= args[ 2 ];
			variant2	= args[ 3 ];
		elseif len == 1 then
			variant1	= args[ 1 ];
			variant2	= args[ 2 ];
		end
		
		if variant1 and variant2 then
			local vehicle = this.GetVehicle( id );
			
			if vehicle == false then
				return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
			end
			
			if vehicle then
				if Server.DB.Query( "UPDATE " + Server.DB.Prefix + "vehicles SET variants = '" + toJSON( { variant1, variant2 } ) + "' WHERE id = " + vehicle.GetID() ) then
					vehicle.SetVariant( variant1, variant2 );
					
					return TEXT_VEHICLES_VARIANT_CHANGED:format( vehicle.GetName(), vehicle.GetID(), variant1, variant2 ), 0, 255, 128;
				end
				
				Debug( Server.DB.Error(), 1 );
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id] <variant1> <variant2>", 255, 255, 255;
	end;
	
	VehicleSetUpgrade	= function( player, option, ... )
		local id, upgrade, install;
		
		local args 		= { ... };
		local len 		= table.getn( args );
		
		if len == 3 then
			id			= args[ 1 ];
			upgrade		= args[ 2 ];
			install		= args[ 3 ];
		elseif len == 2 then
			if tonumber( args[ 1 ] ) then
				id		= args[ 1 ];
			else
				upgrade	= args[ 1 ];
			end
			
			install		= args[ 2 ];
		elseif len == 1 then
			upgrade		= args[ 1 ];
		end
		
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			if vehicle.Upgrades.IsInstalled( upgrade ) then
				vehicle.Upgrades.Remove( upgrade )
			else
				if not vehicle.Upgrades.Add( upgrade ) then
					return "Ошибка при установке компонента (возможно не совместим)", 255, 0, 0;
				end
			end
			
			if vehicle.GetID() > 0 then
				local upgrade	= vehicle.Upgrades.ToJSON();
				
				if upgrade then
					upgrade = "'" + upgrade + "'";
				else
					upgrade = "NULL";
				end
				
				if not Server.DB.Query( "UPDATE " + Server.DB.Prefix + "vehicles SET upgrades = " + upgrade + " WHERE id = " + vehicle.GetID() ) then
					Debug( Server.DB.Error(), 1 );
					
					return TEXT_DB_ERROR, 255, 0, 0;
				end
			end
			
			return true;
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id] <upgrade> [install = true]", 255, 255, 255;
	end;
	
	VehicleSetData	= function( player, option, ... )
		local id, data, value;
		
		local args 		= { ... };
		local len 		= table.getn( args );
		
		if len == 3 then
			id			= args[ 1 ];
			data		= args[ 2 ];
			value		= args[ 3 ];
		elseif len == 2 then
			data		= args[ 1 ];
			value		= args[ 2 ];
		end
		
		if data and value then
			local vehicle = this.GetVehicle( id );
			
			if vehicle == false then
				return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
			end
			
			if vehicle then
				if not vehicle.Data then
					vehicle.Data = {};
				end
				
				if value == "NULL" then
					vehicle.Data[ data ] = NULL;
					
					vehicle.RemoveData( data );
				else
					vehicle.Data[ data ] = value;
					
					vehicle.SetData( data, value );
				end
				
				local jsonData	= toJSON( vehicle.Data );
				
				if jsonData then
					jsonData = "'" + jsonData + "'";
				else
					jsonData = "NULL";
				end
				
				if not Server.DB.Query( "UPDATE " + Server.DB.Prefix + "vehicles SET element_data = " + jsonData + " WHERE id = " + vehicle.GetID() ) then
					Debug( Server.DB.Error(), 1 );
					
					return TEXT_DB_ERROR, 255, 0, 0;
				end
				
				return true;
			end
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id] <data> <value (NULL для удаления)>", 255, 255, 255;
	end;
	
	VehicleSetCharacter	= function( player, option, ... )
		local id, characterID;
		
		local args = { ... };
		local len = table.getn( args );
		
		if len == 2 then
			id			= args[ 1 ];
			characterID	= args[ 2 ];
		elseif len == 1 then
			characterID	= args[ 1 ];
		end
		
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			local target = Server.Game.PlayerManager.Get( iTargetID );
			
			if target then
				if vehicle.SetOwner( target.GetChar() ) then
					Console.Log( "%s changed owner vehicle ID %d for %s (User: %s ID: %d)", player.UserName, vehicle.GetID(), target.GetName(), target.UserName, target.UserID );
					
					target.Chat.Send( string.format( "Теперь Вы владелец автомобиля %s (ID %d)", vehicle.GetName(), vehicle.GetID() ), 0, 255, 128 );
					
					return TEXT_VEHICLES_OWNER_CHANGED:format( target.GetName(), target.GetID(), vehicle.GetName(), vehicle.GetID() ), 0, 255, 128;
				end
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return TEXT_PLAYER_NOT_FOUND, 255, 0, 0;
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id] <character id>", 255, 255, 255;
	end;
	
	VehicleSetFaction	= function( player, option, ... )
		local id, factionID;
		
		local args = { ... };
		local len = table.getn( args );
		
		if len == 2 then
			id			= args[ 1 ];
			factionID	= args[ 2 ];
		elseif len == 1 then
			factionID	= args[ 1 ];
		end
		
		local vehicle = this.GetVehicle( id );
		
		if vehicle == false then
			return TEXT_VEHICLES_INVALID_ID, 255, 0, 0;
		end
		
		if vehicle then
			local faction = Server.Game.FactionManager.Get( factionID );
			
			if faction then
				if vehicle.SetFaction( faction ) then
					Console.Log( "%s changed faction vehicle %s (ID %d) for %s (ID: %d)", player.UserName, vehicle.GetName(), vehicle.GetID(), faction.GetName(), faction.GetID() );
					
					return TEXT_VEHICLES_FACTION_CHANGED:format( vehicle.GetName(), vehicle.GetID(), faction.GetName() ), 0, 255, 128;
				end
				
				return TEXT_DB_ERROR, 255, 0, 0;
			end
			
			return TEXT_FACTIONS_INVALID_ID, 255, 0, 0;
		end
		
		return "Syntax: /" + this.Name + " " + option + " [id] <faction id>", 255, 255, 255;
	end;
	
	VehicleSaveAll	= function( player )
		Server.Game.VehicleManager.SaveAll();
		
		AdminManager.SendMessage( player.UserName + " saved all vehicles" );
		
		return true;
	end;
	
	VehicleSetDebug	= function( player, option, enabled, distance )
		player.RPC.VehicleManager.SetDebug( (bool)(enabled), distance );
		
		return true;
	end;
	
	Info		= function( option )
		if not option then
			return
			{
				{ "Syntax: /" + this.Name + " <option>", 255, 255, 255 };
				{ "List of options:", 200, 200, 200 };
				{ "  create                    создание нового автомобиля", 200, 200, 200 };
				{ "  delete                    удаление автомобиля с сервера", 200, 200, 200 };
				{ "  restore                   вернуть удалённый автомобиль на сервер", 200, 200, 200 };
				{ "  get                       телепортирует указанный автомобиль к персонажу", 200, 200, 200 };
				{ "  goto                      телепортирует персонаж к указанному автомобилю", 200, 200, 200 };
				{ "  spawn                     заспавнить временный автомобиль (не сохраняется в БД)", 200, 200, 200 };
				{ "  respawn                   возвращает автомобиль на место создания, заправляет его и чинит", 200, 200, 200 };
				{ "  respawnall                возвращает все автомобили на место создания", 200, 200, 200 };
				{ "  repair                    ремонтирует автомобиль", 200, 200, 200 };
				{ "  flip                      переворачивает автомобиль на колёса", 200, 200, 200 };
				{ "  setfrozen                 статус заморозки (не может двигаться)", 200, 200, 200 };
				{ "  setfuel                   уровень топлива", 200, 200, 200 };
				{ "  setcolor                  цвет в HEX формате", 200, 200, 200 };
				{ "  setmodel                  модель автомобиля", 200, 200, 200 };
				{ "  setspawn                  начальная позиция (переписывает место создания)", 200, 200, 200 };
				{ "  setplate                  регистрационный номер на автомобиле", 200, 200, 200 };
				{ "  setvariant                extra parts", 200, 200, 200 };
				{ "  setupgrade                апгрейды", 200, 200, 200 };
				{ "  setdata                   element data", 200, 200, 200 };
				{ "  setcharacter              персонаж который владеет этим автомобилем", 200, 200, 200 };
				{ "  setfaction                организация которая владеет этим автомобилем", 200, 200, 200 };
				{ "  saveall                   сохранение всех машин", 200, 200, 200 };
				{ "  setdebug                  отображение отладочной информации", 200, 200, 200 };
			};
		end
		
		if option == "create" then
			return
			{
				{ "Syntax: /" + this.Name + " " + option + " <model> [flags]", 255, 255, 255 };
				{ "List of flags:", 200, 200, 200 };
				{ "  -с, --color               цвет автомобиля в формате R,G,B", 200, 200, 200 };
				{ "  -p, --plate               номерной знак автомобиля (8 символов)", 200, 200, 200 };
				{ "  -v, --variants            extra parts через запятую (например 1,255)", 200, 200, 200 };
				{ "  -E, --element_data        Element Data. -E key=value", 200, 200, 200 };
			};
		end
		
		if option == "delete" then
			return "Syntax: /" + this.Name + " " + option + " [id]", 255, 255, 255;
		end
		
		if option == "restore" then
			return "Syntax: /" + this.Name + " " + option + " <id в базе>", 255, 255, 255;
		end
		
		if option == "get" then
			return "Syntax: /" + this.Name + " " + option + " <id>", 255, 255, 255;
		end
		
		if option == "goto" then
			return "Syntax: /" + this.Name + " " + option + " <id>", 255, 255, 255;
		end
		
		if option == "spawn" then
			return "Syntax: /" + this.Name + " " + option + " <model>", 255, 255, 255;
		end
		
		if option == "respawn" then
			return "Syntax: /" + this.Name + " " + option + " [id]", 255, 255, 255;
		end
		
		if option == "respawnall" then
			return "Syntax: /" + this.Name + " " + option, 255, 255, 255;
		end
		
		if option == "repair" then
			return "Syntax: /" + this.Name + " " + option + " [id]", 255, 255, 255;
		end
		
		if option == "flip" then
			return "Syntax: /" + this.Name + " " + option + " [id]", 255, 255, 255;
		end
		
		if option == "setfrozen" then
			return "Syntax: /" + this.Name + " " + option + " [id] [frozen = false]", 255, 255, 255;
		end
		
		if option == "setfuel" then
			return "Syntax: /" + this.Name + " " + option + " [id] <fuel>", 255, 255, 255;
		end
		
		if option == "setcolor" then
			return "Syntax: /" + this.Name + " " + option + " [id] <color1> [color2] [color3] [color4]", 255, 255, 255;
		end
		
		if option == "setmodel" then
			return "Syntax: /" + this.Name + " " + option + " [id] <model>", 255, 255, 255;
		end
		
		if option == "setspawn" then
			return "Syntax: /" + this.Name + " " + option + " [id]", 255, 255, 255;
		end
		
		if option == "setplate" then
			return "Syntax: /" + this.Name + " " + option + " [id] <text>", 255, 255, 255;
		end
		
		if option == "setvariant" then
			return "Syntax: /" + this.Name + " " + option + " [id] <variant1> <variant2>", 255, 255, 255;
		end
		
		if option == "setupgrade" then
			return "Syntax: /" + this.Name + " " + option + " [id] <upgrade> [install = true]", 255, 255, 255;
		end
		
		if option == "setdata" then
			return "Syntax: /" + this.Name + " " + option + " [id] <data> <value (NULL для удаления)>", 255, 255, 255;
		end
		
		if option == "setcharacter" then
			return "Syntax: /" + this.Name + " " + option + " [id] <character id>", 255, 255, 255;
		end
		
		if option == "setfaction" then
			return "Syntax: /" + this.Name + " " + option + " [id] <faction id>", 255, 255, 255;
		end
		
		if option == "saveall" then
			return "Syntax: /" + this.Name + " " + option, 255, 255, 255;
		end
		
		if option == "setdebug" then
			return "Syntax: /" + this.Name + " " + option + " <enabled> [distance = 30]", 255, 255, 255;
		end
		
		return "Неизвестный параметр «" + option + "». Используйте «" + this.Name + " --help» для получения списка параметров.", 255, 255, 255;
	end;
	
	GetVehicle	= function( id )
		local vehicleID = tonumber( id );
		
		local vehicle = NULL;
		
		if vehicleID then
			vehicle = Server.Game.VehicleManager.Get( vehicleID );
			
			if not vehicle then
				return false;
			end
		else
			vehicle = player.GetVehicle();
		end
		
		return vehicle;
	end;
};