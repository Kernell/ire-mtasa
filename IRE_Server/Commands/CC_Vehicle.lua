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
			if vehicle.GetID() < 0 or player.HaveAccess( "command." + this.Name + ":create" ) then
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