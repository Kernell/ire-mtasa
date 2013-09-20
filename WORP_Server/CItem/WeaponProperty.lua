local weapons_data =
{
	[22] =
	{
		pro		=
		{
			flags					= 12339;
			anim_loop_start 		= 0.20;
			anim_loop_stop  		= 0.32;
			anim_loop_bullet_fire   = 0.20;
			anim2_loop_start 		= 0.20;
			anim2_loop_stop 		= 0.32;
			anim2_loop_bullet_fire  = 0.20;
		};
	};
	[23] =
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
	[24] =
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
--[[ 	[25] = -- Shotgun
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
	}; ]]
	[29] = -- mp5
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
	[30] = -- ak47
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
	[31] = -- m4a1
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
	[33] = -- aug
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
	[34] = -- scout
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

weapons_data[ 22 ].std		= weapons_data[ 22 ].pro;
weapons_data[ 22 ].poor		= weapons_data[ 22 ].pro;

weapons_data[ 23 ].std		= weapons_data[ 23 ].pro;
weapons_data[ 23 ].poor		= weapons_data[ 23 ].pro;

weapons_data[ 29 ].std		= weapons_data[ 29 ].pro;
weapons_data[ 29 ].poor		= weapons_data[ 29 ].pro;

weapons_data[ 33 ].std		= weapons_data[ 33 ].pro;
weapons_data[ 33 ].poor		= weapons_data[ 33 ].pro;

weapons_data[ 34 ].std		= weapons_data[ 34 ].pro;
weapons_data[ 34 ].poor		= weapons_data[ 34 ].pro;

for weapon_id, skills in pairs( weapons_data ) do
	for skill, weapon_data in pairs( skills ) do
		for property, value in pairs( weapon_data ) do
			if property == 'flags' then
				assert( setWeaponProperty( weapon_id, skill, "flags", getWeaponProperty( weapon_id, skill, "flags" ) ), 'flags' );
			end
			
			assert( setWeaponProperty( weapon_id, skill, property, value ), property );
		end
	end
end