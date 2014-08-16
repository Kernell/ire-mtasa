-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: PasswordStrength
{
	static
	{
		Meter	= function( this, strPassword, iMinLength )			
			if type( strPassword ) ~= "string" then
				Error( 2, 2342, "strPassword", "string", type( strPassword ) );
			end
			
			iMinLength = tonumber( iMinLength ) or 5;
			
			local iBall = math.floor( strPassword:len() / iMinLength );
			
			if iBall > 0 then
				if pregFind( strPassword, "[a-z]" ) then
					iBall = iBall + 1;
				end
				
				if pregFind( strPassword, "[A-Z]" ) then
					iBall = iBall + 1;
				end
				
				if pregFind( strPassword, "[d+]" ) then
					iBall = iBall + 1;
				end
				
				if pregFind( strPassword, "(.*[0-9].*[0-9].*[0-9])" ) then
					iBall = iBall + 1;
				end
				
				if pregFind( strPassword, ".[!,@,#,$,%,^,&,*,?,_,~]" ) then
					iBall = iBall + 1;
				end
				
				if pregFind( strPassword, "(.*[!,@,#,$,%,^,&,*,?,_,~].*[!,@,#,$,%,^,&,*,?,_,~]) ") then
					iBall = iBall + 1;
				end
				
				if pregFind( strPassword, "([a-z].*[A-Z])|([A-Z].*[a-z])" ) then
					iBall = iBall + 1;
				end
				
				if pregFind( strPassword, "([a-zA-Z])" ) and pregFind( strPassword, "([0-9])" ) then
					iBall = iBall + 1;
				end
				
				if pregFind( strPassword, "([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])" ) then
					iBall = iBall + 1;
				end
			end
			
			return math.max( 0, iBall );
		end;
	};
};