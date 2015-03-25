-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. ItemsManager : Manager
{
	static
	{
		Root	= createElement( "itemRoot", "itemRoot" );
	};

	ItemsManager	= function()
		this.Manager();
		
		this.LoadConfig( "Items/config.ini" );
	end;
	
	_ItemsManager	= function()
	
	end;
	
	Init			= function()
		this.ResetWeaponProperty();

		this.Load( NULL );
		
		return true;
	end;
	
	Load			= function( owner )
		local allFields = "`id`, `value`, `condition`, `section`, `data`, `position`, `rotation`, `interior`, `dimension`";
		
		local ownerString = ( owner and ( "= '" + classname( owner ) + "[" + (int)(owner.GetID()) + "]'" ) or "IS NULL" );
		
		local result = Server.DB.Query( "SELECT " + allFields + " FROM " + Server.DB.Prefix + "items WHERE owner " + ownerString + " ORDER BY id ASC" );
		
		if result then
			local array = result.GetArray();
			
			result.Free();
			
			for i, row in pairs( array ) do
				local item = this.Create( row.section );
				
				if item then
					local data		= row.data and fromJSON( row.data );
					
					if data then
						for key, value in pairs( data ) do
							item[ key ] = tonumber( value ) or value;
						end
					end
					
					item.ID			= (int)(row.id);
					item.Condition	= (float)(row.condition);
					item.Value		= (int)(row.value);
					
					if not owner then
						if row.position and row.rotation then
							item.Spawn( new. Vector3( row.position ), new. Vector3( row.rotation ), (int)(row.interior), (int)(row.dimension) );
						end
					else
						item.Give( owner );
					end
					
					this.AddToList( item );
				else
					Debug( "Cannot find item with section [" + (string)(row.section) + "]", 1 );
				end
			end
		else
			Debug( Server.DB.Error(), 1 );
		end

		if owner and classof( owner ) == Character then
			owner.Player.RPC.Items.SyncConfig( this.Config );
		end
	end;

	ClientHandle	= function( player, command, data, ... )
		if command == "Use" then
			local item = ( { ... } )[ 1 ];

			if item then
				local char = player.Character

				if char then
					local item = this.Get( item.ID );
					
					if item then			
						item.Use();
						
						char.Inventory.Sync();
					end
				end
			end

			return false;
		end

		if command == "Drop" then
			local char = player.Character
			
			if char then
				local item = ( { ... } )[ 1 ];

				if item then
					local item = this.Get( item.ID );
					
					if item then
						char.Inventory.DropItem( item );
					end
				end
			end

			return false;
		end

		if command == "Transfer" then
			return false;
		end

		return false;
	end;
	
	Create			= function( section )
		local config = this.Config[ section ];
		
		if config then
			local class = config[ "$class" ];

			if class == NULL then
				Debug( "undeclared item class in section '" + section + "'", 1 );

				return NULL;
			end

			if class ~= "Item" then
				class = "Item" + class;
			end

			if _G[ class ] == NULL then
				Debug( "invalid item class '" + class:sub( 1, 4 ) + "' in section '" + section + "'", 1 );

				return NULL;
			end

			local item = new[ class ]( config );

			item.SectionName = section;

			return item;
		end

		return NULL;
	end;
	
	Register		= function( item )
		local data = new {};
		
		for key, value in pairs( item ) do
			if this.Config[ item.SectionName ][ key ] ~= NULL and this.Config[ item.SectionName ][ key ] ~= value then
				data[ key ] = value;
			end
		end
		
		local fields	=
		{
			section		= item.SectionName;
			owner		= item.Owner and ( classname( item.Owner ) + "[" + (int)(item.Owner.GetID()) + "]" ) or NULL;
			position	= item.Position and item.Position.ToString() or NULL;
			rotation	= item.Rotation and item.Rotation.ToString() or NULL;
			interior	= item.Interior or NULL;
			dimension	= item.Dimension or NULL;
			value		= item.Value or NULL;
			condition	= item.Condition or NULL;
			data 		= data.Length() > 0 and data.ToJSON() or NULL;
		};
		
		local ID	= Server.DB.Insert( Server.DB.Prefix + "items", fields );
		
		if not ID then
			Debug( Server.DB.Error(), 1 );
			
			return NULL;
		end
		
		if owner then
			if not item.Give( owner ) then
				return false;
			end
		end
		
		item.ID = Server.DB.InsertID();
		
		this.AddToList( item );
		
		return item;
	end;
	
	Remove	= function( item )
		if Server.DB.Query( "DELETE FROM " + Server.DB.Prefix + "items WHERE id = " + item.GetID() ) then
			delete ( item );
			
			return true;
		end
		
		Debug( Server.DB.Error(), 1 );
		
		return false;
	end;
	
	LoadConfig		= function( path )
		local ini = new. IniFile( path );
		
		this.Config = ini.Sections;
		
		delete ( ini );
	end;

	ResetWeaponProperty	= function()
		local weaponsData =
		{
			[ 22 ] =
			{
				pro		=
				{
					flags					= 0x3033;
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.32;
					anim_loop_bullet_fire   = 0.20;
					anim2_loop_start 		= 0.20;
					anim2_loop_stop 		= 0.32;
					anim2_loop_bullet_fire  = 0.20;
				};
			};
			[ 23 ] =
			{
				pro		=
				{
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.32;
					anim_loop_bullet_fire   = 0.20;
					anim2_loop_start 		= 0.20;
					anim2_loop_stop 		= 0.32;
					anim2_loop_bullet_fire  = 0.20;
				};
			};
			[ 24 ] =
			{
				pro		=
				{
					accuracy        		= 2.5;
					damage  				= 100;
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.31;
					anim_loop_bullet_fire   = 0.20;
					anim2_loop_stop 		= 0.31;
				};
				std		=
				{
					accuracy        		= 1.725;
					damage  				= 100;
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.31;
					anim_loop_bullet_fire   = 0.20;
					anim2_loop_stop 		= 0.31;
				};
				poor	=
				{
					accuracy        		= 1.0;
					damage  				= 100;
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.31;
					anim_loop_bullet_fire   = 0.20;
					anim2_loop_stop 		= 0.31;
				};
			};
			[ 25 ] = -- Shotgun
			{
				pro		=
				{
					weapon_range   			= 80;
					target_range    		= 50;
					accuracy        		= 1.0;
					damage  				= 90;
					-- flags					= 0x7031;
					maximum_clip_ammo       = 7;
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.35;
					anim_loop_bullet_fire   = 0.23;
					anim2_loop_start        = 0.20;
					anim2_loop_stop 		= 0.35;
					anim2_loop_bullet_fire  = 0.23;
					anim_breakout_time      = 3.30;
				};
			};
			[ 29 ] = -- mp5
			{
				pro		=
				{
					weapon_range   			= 50;
					target_range    		= 50;
					accuracy        		= 1.5;
					move_speed      		= 1.5;
					maximum_clip_ammo       = 30;
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.2709;
					anim_loop_bullet_fire   = 0.23;
					anim2_loop_start        = 0.20;
					anim2_loop_stop 		= 0.2709;
					anim2_loop_bullet_fire  = 0.23;
					anim_breakout_time      = 3.30;
				};
			};
			[ 30 ] = -- ak47
			{
				pro		=
				{
					weapon_range   			= 90;
					target_range    		= 50;
					accuracy        		= 1.1;
					damage  				= 40;
					maximum_clip_ammo       = 30;
					move_speed      		= 0.7;
					flags   				= 0x7031;
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.29;
					anim_loop_bullet_fire   = 0.23;
					anim2_loop_start        = 0.20;
					anim2_loop_stop 		= 0.29;
					anim2_loop_bullet_fire  = 0.23;
					anim_breakout_time      = 3.30;
				};
				std		=
				{
					weapon_range   			= 70;
					target_range    		= 50;
					accuracy        		= 1.1;
					damage  				= 40;
					maximum_clip_ammo       = 30;
					move_speed      		= 0.7;
					flags   				= 0x7011;
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.29;
					anim_loop_bullet_fire   = 0.23;
					anim2_loop_start        = 0.20;
					anim2_loop_stop 		= 0.29;
					anim2_loop_bullet_fire  = 0.23;
					anim_breakout_time      = 3.30;
				};
				poor	=
				{
					weapon_range   			= 90;
					target_range    		= 50;
					accuracy        		= 1.1;
					damage  				= 40;
					maximum_clip_ammo       = 30;
					move_speed      		= 0.7;
					flags   				= 0x7031;
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.29;
					anim_loop_bullet_fire   = 0.23;
					anim2_loop_start        = 0.20;
					anim2_loop_stop 		= 0.29;
					anim2_loop_bullet_fire  = 0.23;
					anim_breakout_time      = 3.30;
				};
			};
			[ 31 ] = -- m4a1
			{
				pro		=
				{
					weapon_range    		= 90;
					target_range    		= 50;
					accuracy        		= 0.9;
					damage  				= 20;
					maximum_clip_ammo       = 30;
					move_speed      		= 0.7;
					flags   				= 0x7031;
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.27;
					anim_loop_bullet_fire   = 0.23;
					anim2_loop_start        = 0.20;
					anim2_loop_stop 		= 0.27;
					anim2_loop_bullet_fire  = 0.23;
					anim_breakout_time      = 3.30;
				};
				std		=
				{
					weapon_range    		= 70;
					target_range    		= 50;
					accuracy        		= 0.9;
					damage  				= 20;
					maximum_clip_ammo       = 30;
					move_speed      		= 0.7;
					flags   				= 0x7011;
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.27;
					anim_loop_bullet_fire   = 0.23;
					anim2_loop_start        = 0.20;
					anim2_loop_stop 		= 0.27;
					anim2_loop_bullet_fire  = 0.23;
					anim_breakout_time      = 3.30;
				};
				poor	=
				{
					weapon_range    		= 90;
					target_range    		= 50;
					accuracy        		= 0.9;
					damage  				= 20;
					maximum_clip_ammo       = 30;
					move_speed      		= 0.7;
					flags   				= 0x7031;
					anim_loop_start 		= 0.20;
					anim_loop_stop  		= 0.27;
					anim_loop_bullet_fire   = 0.23;
					anim2_loop_start        = 0.20;
					anim2_loop_stop 		= 0.27;
					anim2_loop_bullet_fire  = 0.23;
					anim_breakout_time      = 3.30;
				};
			};
			[ 33 ] = -- aug
			{
				pro		=
				{
					weapon_range			= 70;
					target_range			= 50;
					accuracy				= 1.5;
					damage					= 40;
					maximum_clip_ammo		= 999;--30;
					move_speed				= 0.7;
					flags					= 0x7031;
					anim_loop_start			= 0.20;
					anim_loop_stop			= 0.28;
					anim_loop_bullet_fire	= 0.23;
					anim2_loop_start		= 0.20;
					anim2_loop_stop			= 0.28;
					anim2_loop_bullet_fire	= 0.23;
					anim_breakout_time		= 3.30;
				};
			};
			[ 34 ] = -- scout
			{
				pro		=
				{
					weapon_range			= 70;
					target_range			= 50;
					accuracy				= 1.5;
					damage					= 100;
					maximum_clip_ammo		= 10;
					move_speed				= 0.7;
					flags					= 0x7035;
					anim_loop_start			= 0.20;
					anim_loop_stop			= 0.121;
					anim_loop_bullet_fire	= 0.23;
					anim2_loop_start		= 0.20;
					anim2_loop_stop			= 0.121;
					anim2_loop_bullet_fire	= 0.23;
					anim_breakout_time		= 3.30;
				};
			};
		};

		weaponsData[ 22 ].std		= weaponsData[ 22 ].pro;
		weaponsData[ 22 ].poor		= weaponsData[ 22 ].pro;

		weaponsData[ 23 ].std		= weaponsData[ 23 ].pro;
		weaponsData[ 23 ].poor		= weaponsData[ 23 ].pro;

		weaponsData[ 29 ].std		= weaponsData[ 29 ].pro;
		weaponsData[ 29 ].poor		= weaponsData[ 29 ].pro;

		weaponsData[ 33 ].std		= weaponsData[ 33 ].pro;
		weaponsData[ 33 ].poor		= weaponsData[ 33 ].pro;

		weaponsData[ 34 ].std		= weaponsData[ 34 ].pro;
		weaponsData[ 34 ].poor		= weaponsData[ 34 ].pro;

		for weaponID, skills in pairs( weaponsData ) do
			for skill, data in pairs( skills ) do
				for property, value in pairs( data ) do
					if property == "flags" then
						setWeaponProperty( weaponID, skill, "flags", getWeaponProperty( weaponID, skill, "flags" ) );
					end
					
					setWeaponProperty( weaponID, skill, property, value );
				end
			end
		end
	end;
};
