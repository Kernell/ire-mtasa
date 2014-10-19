<?php

$dirs = array
(
	"IRE_Shaders",
	"rp_models",
	"rp_nametags",
	"WORP",
	"WORP_Headmove",
//	"WORP_Server",
);

function luac( $path )
{
	if( $handle = @fopen( $path, "r" ) )
	{
		$buffer = fread( $handle, 5 );
		
		fclose( $handle );
		
		if( substr( $buffer, 1, 4 ) != "MvbR" )
		{
			exec( "luac_mta -b -e -o $path $path" );
			
			return "\e[32;40m  OK  ";
		}
		
		return "\e[33;40mPASSED";
	}
	
	return "\e[31;40mFAILED";
}

foreach( $dirs as $dir )
{
	if( $xml = @simplexml_load_file( $dir . "/meta.xml" ) )
	{
		echo $dir . "\n";
		
		foreach( $xml->script as $script )
		{
			if( $script[ "type" ] == "client" )
			{
				$result = luac( 'uploads/' . $dir . '/' . $script[ "src" ] );
				
				printf( "Compiling %-70s [%s\e[m]\n", $script[ "src" ], $result );
			}
		}
		
		echo "\n";
	}
}

?>