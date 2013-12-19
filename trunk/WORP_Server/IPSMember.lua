-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local HOST		= get "IPSMember.mysql->host" or NULL;
local USER		= get "IPSMember.mysql->user" or "root";
local PASS		= (string)(get "IPSMember.mysql->password");
local NAME		= (string)(get "IPSMember.mysql->dbname");
local ENGINE	= get "IPSMember.mysql->engine" or "MyISAM";
local PREFIX	= get "IPSMember.mysql->prefix" or "ibf_";

class: IPSMember
{
	PREFIX	= PREFIX;
	
	DB	= CMySQL( USER, PASS, NAME, HOST );
	--[[
	 - Remapped table array used in load and save
	 -
	 - @var		array
	 -]]
	Remap =
	{
		core				= 'members';
		extendedProfile 	= 'profile_portal';
		customFields       	= 'pfields_content';
		itemMarkingStorage 	= 'core_item_markers_storage';
	};
   
	--[[
	 - Create new member
	 - Very basic functionality at this point.
	 -
	 - @param	array 	Fields to save in the following format: array( 'members'      => array( 'email'     => 'test@test.com',
	 -																				         'joined'   => time() ),
	 -															   'extendedProfile' => array( 'signature' => 'My signature' ) );
	 -					Tables: members, pfields_content, profile_portal.
	 -					You can also use the aliases: 'core [members]', 'extendedProfile [profile_portal]', and 'customFields [pfields_content]'
	 - @return	@array	Final member data including member_id
	 -]]
	Create	= function( this, Tables, bAutoCreateName )
		bAutoCreateName	= (bool)(bAutoCreateName);
		
		-------------------------------------------
		-- INIT
		-------------------------------------------
		
		local FinalTables		= {};
		local password			= '';
		local plainPassword		= '';
		local md_5_password		= '';
		
		-------------------------------------------
		-- Remap tables if required
		-------------------------------------------
			
		for sField, data in pairs( Tables ) do
			local _name = IPSMember.Remap[ sField ] or sField;
			
			if _name == "members" then
				--[[ Magic password field ]]
				password		= data[ "password" ] or IPSMember:MakePassword();
				plainPassword	= password;
				md_5_password	= md5( password );
				
				data[ 'password' ] = NULL;
			end
			
			FinalTables[ _name ] = data;
		end
		
		-------------------------------------------
    	-- Make sure the account doesn't exist
    	-------------------------------------------
    	
    	if FinalTables[ 'members' ][ 'email' ] then
    		local existing			= IPSMember:Load( FinalTables[ 'members' ][ 'email' ], 'all' );
    		
    		if existing and existing[ 'member_id' ] then
    			existing[ 'full' ]		= true;
    			existing[ 'timenow' ]	= getRealTime().timestamp;
    			
    			return existing;
    		end
    	end
    	
		-------------------------------------------
		-- Fix up usernames and display names
		-------------------------------------------
		
		--[[ Ensure we have a display name ]]
		if bAutoCreateName and FinalTables[ 'members' ][ 'members_display_name' ] ~= false then
			FinalTables[ 'members' ][ 'members_display_name' ]	= FinalTables[ 'members' ][ 'members_display_name' ] or FinalTables[ 'members' ][ 'name' ];
		end
		
		-------------------------------------------
		-- Remove some basic HTML tags
		-------------------------------------------
		
		if FinalTables[ 'members' ][ 'members_display_name' ] then
			FinalTables[ 'members' ][ 'members_display_name' ]	= FinalTables[ 'members' ][ 'members_display_name' ]:gsub( "[<>]", "" );
		end
		
		if FinalTables[ 'members' ][ 'name' ] then
			FinalTables[ 'members' ][ 'name' ] 					= FinalTables[ 'members' ][ 'name' ]:gsub( "[<>]", "" );
		end
		
		-------------------------------------------
		-- Make sure the names are unique
		-------------------------------------------
		
		--[[ Can specify display name of FALSE to force no entry to force partial member ]]
		if FinalTables[ 'members' ][ 'members_display_name' ] ~= false then
			if IPSMember:CheckNameExists( FinalTables[ 'members' ][ 'members_display_name' ], 'members_display_name' ) == true then
				if bAutoCreateName == true then
					--[[ Now, make sure we have a unique display name ]]
					local pResult = IPSMember.DB:Query( "SELECT MAX( member_id ) AS max FROM " + PREFIX + "members WHERE members_l_display_name LIKE '%s%%'", FinalTables[ 'members' ][ 'members_display_name' ]:lower() );
					
					if pResult then
						local pRow = pResult:FetchRow();
						
						if pRow and pRow[ 'max' ] then
							FinalTables[ 'members' ][ 'members_display_name' ] = FinalTables[ 'members' ][ 'members_display_name' ] + '_' + pRow[ 'max' ] + 1;
						end
						
						delete ( pResult );
					end
				else
					FinalTables[ 'members' ][ 'members_display_name' ] = "";
				end
			end
		end
		
		if FinalTables[ 'members' ][ 'name' ] then
			if IPSMember:CheckNameExists( FinalTables[ 'members' ][ 'name' ], 'name' ) == true then
				if bAutoCreateName == true then
					--[[ Now, make sure we have a unique username ]]
					local pResult = IPSMember.DB:Query( "SELECT MAX( member_id ) AS max FROM " + PREFIX + "members WHERE members_l_username LIKE '%s%%'", FinalTables[ 'members' ][ 'name' ]:lower() );
					
					if pResult then
						local pRow = pResult:FetchRow();
						
						if pRow and pRow[ 'max' ] then
							FinalTables[ 'members' ][ 'name' ] = FinalTables[ 'members' ][ 'name' ] + '_' + pRow[ 'max' ] + 1;
						end
						
						delete ( pResult );
					end
				else
					FinalTables[ 'members' ][ 'name' ] = '';
				end
			end
		end
		
		-------------------------------------------
		-- Populate member table(s)
		-------------------------------------------

		FinalTables[ 'members' ][ 'members_l_username' ]		= FinalTables[ 'members' ][ 'name' ] and FinalTables[ 'members' ][ 'name' ]:lower() or "";
		FinalTables[ 'members' ][ 'joined' ]					= FinalTables[ 'members' ][ 'joined' ] or getRealTime().timestamp;
		FinalTables[ 'members' ][ 'email' ]						= FinalTables[ 'members' ][ 'email' ] or FinalTables[ 'members' ][ 'name' ] + '@' + FinalTables[ 'members' ][ 'joined' ];
		FinalTables[ 'members' ][ 'member_group_id' ]			= FinalTables[ 'members' ][ 'member_group_id' ] or 3; -- ipsRegistry::$settings[ 'member_group' ];
		FinalTables[ 'members' ][ 'ip_address' ]				= (string)(FinalTables[ 'members' ][ 'ip_address' ]);
		FinalTables[ 'members' ][ 'members_created_remote' ]	= (int)(FinalTables[ 'members' ][ 'members_created_remote' ]);
		FinalTables[ 'members' ][ 'view_sigs' ]					= 1;
		FinalTables[ 'members' ][ 'bday_day' ]					= (int)(FinalTables[ 'members' ][ 'bday_day' ]);
		FinalTables[ 'members' ][ 'bday_month' ]				= (int)(FinalTables[ 'members' ][ 'bday_month' ]);
		FinalTables[ 'members' ][ 'bday_year' ]					= (int)(FinalTables[ 'members' ][ 'bday_year' ]);
		FinalTables[ 'members' ][ 'restrict_post' ]				= (int)(FinalTables[ 'members' ][ 'restrict_post' ]);
		FinalTables[ 'members' ][ 'auto_track' ]				= (string)(FinalTables[ 'members' ][ 'auto_track' ] or "0"):sub( 1, 50 );
		FinalTables[ 'members' ][ 'msg_count_total' ]			= 0;
		FinalTables[ 'members' ][ 'msg_count_new' ]				= 0;
		FinalTables[ 'members' ][ 'msg_show_notification' ]		= 1;
		FinalTables[ 'members' ][ 'coppa_user' ]				= 0;
		FinalTables[ 'members' ][ 'last_visit' ]				= FinalTables[ 'members' ][ 'last_visit' ] or getRealTime().timestamp;
		FinalTables[ 'members' ][ 'last_activity' ]				= FinalTables[ 'members' ][ 'last_activity' ] or getRealTime().timestamp;
		FinalTables[ 'members' ][ 'language' ]					= 1;
--		FinalTables[ 'members' ][ 'members_editor_choice' ]		= 'std';
		FinalTables[ 'members' ][ 'member_uploader' ]			= 'default';
		FinalTables[ 'members' ][ 'members_pass_salt' ]			= IPSMember:GeneratePasswordSalt( 5 );
		FinalTables[ 'members' ][ 'members_pass_hash' ]			= IPSMember:GenerateCompiledPasshash( FinalTables[ 'members' ][ 'members_pass_salt' ], md_5_password );
		FinalTables[ 'members' ][ 'members_display_name' ]		= FinalTables[ 'members' ][ 'members_display_name' ] or '';
		FinalTables[ 'members' ][ 'members_l_display_name' ]	= FinalTables[ 'members' ][ 'members_display_name' ]:lower();
		FinalTables[ 'members' ][ 'members_seo_name' ]         	= FinalTables[ 'members' ][ 'members_display_name' ]:lower();
		FinalTables[ 'members' ][ 'fb_uid' ]	 	            = FinalTables[ 'members' ][ 'fb_uid' ] or 0;
		FinalTables[ 'members' ][ 'fb_emailhash' ]	            = FinalTables[ 'members' ][ 'fb_emailhash' ] and FinalTables[ 'members' ][ 'fb_emailhash' ]:lower() or "";
--		FinalTables[ 'members' ][ 'bw_is_spammer' ]            	= (int)(FinalTables[ 'members' ][ 'bw_is_spammer' ]);
		
		-------------------------------------------
		-- Insert: MEMBERS
		-------------------------------------------
		
		FinalTables[ 'members' ][ 'member_id' ]		= IPSMember.DB:Insert( PREFIX + "members", FinalTables[ 'members' ] );
		
		if not FinalTables[ 'members' ][ 'member_id' ] then
			Debug( IPSMember.DB:Error(), 1 );
			
			return false;
		end
		
		-------------------------------------------
		-- Insert: PROFILE PORTAL
		-------------------------------------------
		
		if not FinalTables[ 'profile_portal' ] then
			FinalTables[ 'profile_portal' ] = {};
		end

		FinalTables[ 'profile_portal' ][ 'pp_member_id' ]             	= FinalTables[ 'members' ][ 'member_id' ];
		FinalTables[ 'profile_portal' ][ 'pp_setting_count_friends' ] 	= 1;
		FinalTables[ 'profile_portal' ][ 'pp_setting_count_comments' ]	= 1;
		FinalTables[ 'profile_portal' ][ 'pp_setting_count_visitors' ]	= 1;
		FinalTables[ 'profile_portal' ][ 'pp_customization' ]			= "a:0:{}";
		
		for i, f in ipairs( { 'pp_last_visitors', 'pp_about_me', 'signature', 'fb_photo', 'fb_photo_thumb', 'pconversation_filters' } ) do
			FinalTables[ 'profile_portal' ][ f ] = FinalTables[ 'profile_portal' ][ f ] or "";
		end
		
		if not IPSMember.DB:Insert( PREFIX + "profile_portal", FinalTables[ 'profile_portal' ] ) then
			Debug( IPSMember.DB:Error(), 1 );
			
			return false;
		end
		
		local bFullAccount 	= false;
		
		if FinalTables[ 'members' ][ 'members_display_name' ] and FinalTables[ 'members' ][ 'name' ] and FinalTables[ 'members' ][ 'email' ] and FinalTables[ 'members' ][ 'email' ] ~= FinalTables[ 'members' ][ 'name' ] + '@' + FinalTables[ 'members' ][ 'joined' ] then
			bFullAccount	= true;
		end
		
		if not bFullAccount then
			if not IPSMember.DB:Insert( PREFIX + "members_partial", 
				{
					partial_member_id = FinalTables[ 'members' ][ 'member_id' ];
					partial_date      = FinalTables[ 'members' ][ 'joined' ];
					partial_email_ok  = ( FinalTables[ 'members' ][ 'email' ] == FinalTables[ 'members' ][ 'name' ] + '@' + FinalTables[ 'members' ][ 'joined' ] ) and 0 or 1;
				}
			) then
				Debug( IPSMember.DB:Error(), 1 );
				
				return false;
			end
		end
		
		for key, value in pairs( FinalTables[ 'profile_portal' ] ) do
			FinalTables[ 'members' ][ key ] = value;
		end
		
		FinalTables[ 'members' ][ 'timenow' ]	= FinalTables[ 'members' ][ 'joined' ];
		FinalTables[ 'members' ][ 'full' ]		= bFullAccount;
		
		return FinalTables[ 'members' ];
	end;
	
	--[[
	 - Load member
	 -
	 - @param string Member key: Either ID or email address OR array of IDs when $key_type is either ID or not set OR a list of $key_type strings (email address, name, etc)
	 - @param string Extra tables to load(all, none or comma delisted tables) Tables: members, pfields_content, profile_portal, groups, sessions, core_item_markers_storage.
	 - @param string Key type. Leave it blank to auto-detect or specify "id", "email", "username", "displayname".
	 - @return @array Array containing member data
	 -]]
	Load = function( member_key, extra_tables, key_type )
		extra_tables	= extra_tables or "all";
		key_type		= (string)(key_type);
		
		return NULL;
	end;
	
	--[[
	 - Generates a compiled passhash.
	 - Returns a new MD5 hash of the supplied salt and MD5 hash of the password
	 -
	 - @param	string		User's salt (5 random chars)
	 - @param	string		User's MD5 hash of their password
	 - @return	string		MD5 hash of compiled salted password
	 -]]
	GenerateCompiledPasshash = function( this, sSalt, md5_once_password )
		return md5( md5( sSalt ):lower() + md5_once_password:lower() ):lower();
	end;
	
	--[[
	 - Generates a password salt.
	 - Returns n length string of any char except backslash
	 -
	 - @param	integer		Length of desired salt, 5 by default
	 - @return	string		n character random string
	 -]]
	GeneratePasswordSalt = function( this, iLen )
		iLen = tonumber( iLen ) or 5;
		
		local sSalt = "";

		for i = 1, iLen do
			local iNum   = math.random( 33, 126 );

			if iNum == 92 then
				iNum = 93;
			end

			sSalt = sSalt + string.char( iNum );
		end

		return sSalt;
	end;
	
	--[[
	 - Create a random 15 character password
	 -
	 - @return	string	Password
	 -]]
	MakePassword = function( this )
		local pass = "";

		-- Want it random you say, eh?
		-- (enter evil laugh)

		local unique_id 	= uniqid( math.random(), true );
		local prefix		= this:GeneratePasswordSalt();
		local unique_id 	= unique_id + md5( prefix );

		local new_uniqueid	= uniqid( math.random(), true );

		local final_rand	= md5( unique_id + new_uniqueid );

		for i = 1, 15 do
			pass	= pass + final_rand[ math.random( 1, 32 ) ];
		end

		return pass;
	end;
	
	CheckNameExists = function( this, name, field )
		field = field or "members_display_name";
		
		local pResult = IPSMember.DB:Query( "SELECT COUNT( `member_id` ) AS count FROM " + PREFIX + "members WHERE `" + field + "` = %q", name );
		
		if pResult then
			local pRow = pResult:FetchRow();
			
			delete ( pResult );
			
			return pRow[ 'count' ] == 0;
		else
			Debug( IPSMember.DB:Error(), 1 );
		end
		
		return false;
	end;
};
