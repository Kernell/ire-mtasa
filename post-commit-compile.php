#!/bin/php
<?php

$dirs = array
(
	"Shared",
	"IRE_Shaders",
	"rp_models",
	"rp_nametags" 
	"WORP",
	"WORP_Headmove",
);

foreach( $dirs as $dir )
{
	if( $xml = @simplexml_load_file( $dir . "/meta.xml" ) )
	{
		echo $dir . "\n";
		
		foreach( $xml->script as $script )
		{
			if( $script[ "type" ] == "client" )
			{
				echo "Compiling ", $script[ "src" ], " ";
				
				$file_path = $dir . '/' . $script[ "src" ];
				
				if( $handle = @fopen( $file_path, "r" ) )
				{
					$buffer = fread( $handle, 5 );
					
					fclose( $handle );
					
					if( substr( $buffer, 1, 4 ) != "MvbR" )
						exec( "luac_mta -b -e -o $file_path $file_path" );
					else
						echo "skipped";
				}
				else
					echo "failed to open";
				
				echo "\n";
			}
		}
		
		echo "\n";
	}
}

?>