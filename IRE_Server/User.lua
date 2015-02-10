-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. User
{
	static
	{
		IsStringValid = function( str )
			if type( str ) == "string" and str:len() > 0 then
				return not str:find( "[^A-Za-z]" );
			end
			
			return false;
		end;
		
		IsEmailValid	= function( email )
			if email:len() < 3 then
				return false;
			end
			
			if email[ 1 ] == "@" then
				return false;
			end
			
			local loc, domain = unpack( email:split( '@' ) );

			if not pregFind( '/^[a-zA-Z0-9!#$%&\'*+\/=?^_`{|}~\.-]+$/', loc ) then
				return false;
			end
			
			if pregFind( '\.{2,}', domain ) then
				return false;
			end

			if domain:trim( " \t\n\r\0\x0B." ) ~= domain then
				return false;
			end
			
			local subs = domain:split( '.' );

			if table.getn( subs ) < 2 then
				return false;
			end
			
			for sub in pairs( subs ) do
				if sub:trim( " \t\n\r\0\x0B-" ) ~= sub then
					return false;
				end
				
				if not pregFind( '^[a-z0-9-]+$', sub, 'i' ) then
					return false;
				end
			end
			
			return true;
		end;
		
		GeneratePassword = function( length, specialChars, extraSpecialChars )
			local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			
			if specialChars then
				chars = chars + "!@#$%^&*()";
			end
			
			if extraSpecialChars then
				chars = chars + "-_ []{}<>~`+=,.;:/?|";
			end
			
			local password = "";
			
			for i = 1, ( length or 12 ) do
				password = password + chars[ math.random( 1, chars:len() ) ];
			end
		end;
		
		GenerateSalt	= function( length )
			local salt = "";
			
			for i = 1, length do
				salt = salt + string.format( "%c", math.random( 33, 127 ) );
			end
			
			return salt;
		end;
		
		HashPassword	= function( password, salt )
			if not salt then
				salt 			= User.GenerateSalt( 16 );
			end
			
			local passwordEnc 	= Server.Blowfish.Encrypt( password );
			local saltEnc 		= Server.Blowfish.Encrypt( salt );
			
			return hash( "sha256", hash( "sha512", passwordEnc ) + hash( "sha512", saltEnc ) );
		end;
		
		CheckPassword	= function( password, passwordHashed, salt )
			if password:len() == 0 then
				return false;
			end
			
			if passwordHashed:len() < 64 then
				return false;
			end
			
			if salt:len() == 0 then
				return false;
			end
			
			return User.HashPassword( password, salt ) == passwordHashed;
		end;
	};
};
