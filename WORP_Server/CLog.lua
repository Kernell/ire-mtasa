-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "CLog"
{
	m_sName;
}

function CLog:CLog( sName, bDate )
	assert( is_type( sName, "string", "name" ) );

	local tReal = getRealTime();
	
	self.m_sName = sName + ( bDate and ( " (%02d-%02d-%04d)" ):format( tReal.monthday, tReal.month + 1, tReal.year + 1900 ) or "" );
	
	local sPath = "Core/Logs/" + self.m_sName + ".log";
	
	local pFile = fileExists( sPath ) and fileOpen( sPath ) or fileCreate( sPath );
	
	assert( pFile, "failed to create file " + self.m_sName + ".log" );
	
--	fileSetPos( pFile, fileGetSize( pFile ) );
--	fileWrite( pFile, ( "===========================================================\nLog start: %02d:%02d:%02d %02d:%02d:%04d\n===========================================================\n" ):format( time.hour, time.minute, time.second, time.monthday, time.month + 1, time.year + 1900 ) );
	fileClose( pFile );
end

function CLog:Write( ... )
	local bResult, sResult = pcall( string.format, ... );
	
	if bResult and sResult:len() > 0 then
		if fileExists( "Core/Logs/" + self.m_sName + ".log" ) then
			local pFile = fileOpen( "Core/Logs/" + self.m_sName + ".log" );
			
			if pFile then
				local tReal = getRealTime();
				
				fileSetPos( pFile, fileGetSize( pFile ) );
				
				fileWrite( pFile, ( "[%02d:%02d:%02d - %02d:%02d:%04d] %s\n" ):format( 
					tReal.hour, tReal.minute, tReal.second, tReal.monthday, tReal.month + 1, tReal.year + 1900, sResult ) );
				
				g_pServer:Print( sResult:gsub( "%%", "%%%%" ) );
					
				fileClose( pFile );
				
				return true;
			else
				Debug( "failed to open log pFile " + self.m_sName + ".log", 1 );
			end
		else
			Debug( "failed to write log " + self.m_sName + ".log - file not exists", 1 );
		end
	else
		error( sResult, 2 );
	end
	
	return false;
end