-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local MailResult;

function MailResult( responseData, errno, playerToReceive ) 
	print( "errno: ", errno, "responseData: ", responseData );
end

PHP_MAIL_PATH	= "http://mtaroleplay.ru/send_mailjg349r13c4ki535.php";

class "CMail"
{
	m_From		= NULL;
	m_Address	= NULL;
	Subject		= NULL;
	Body		= NULL;
	
	CMail		= function( this )
		this.m_Address = {};
	end;
	
	SetFrom 	= function( this, sAddress, sName )
		this.m_From	= sName and ( sName + " <" + sAddress + ">" ) or sAddress;
	end;
	
	AddAddress	= function( this, sAddress, sName )
		table.insert( this.m_Address, sName and ( sName + " <" + sAddress + ">" ) or sAddress );
	end;
	
	Send		= function( this )
		if this.Body and this.m_Address and table.getn( this.m_Address ) > 0 and this.Subject and this.m_From then
			return fetchRemote( PHP_MAIL_PATH + "?To=" + table.concat( this.m_Address, "," ) + "&From=" + this.m_From + "&Subject=" + this.Subject + "&Body=" + this.Body:gsub( '\n', '%%0D' ), MailResult );
		end
		
		return false, "Bad arguments";
	end;
};