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
	
	Execute		= function( player, option, ... )
		if option == "create" then
			return this.VehicleCreate( player, option, ... );
		end
		
		if option == "-h" or option == "--help" then
			return this.Info();
		end
		
		return "Syntax: /" + this.Name + " <option>", 255, 255, 255;
	end;
	
	VehicleCreate	= function( player, option, model, ... )
		if not player.IsInGame() then
			return true;
		end
		
		if model == "-h" or model == "--help" then
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
		
		Debug( "vehicle create " + model + " " + table.concat( { ... }, " " ) );
		
		local modelID = model and tonumber( model ) or VehicleManager.GetModelByName( model );
		
		if modelID then
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
	
	Info		= function()
		
	end;
};