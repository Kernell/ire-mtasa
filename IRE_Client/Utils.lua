-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

function Execute( code )
	local Function, Error = loadstring( "return " + code );
	
	if Error then
		Function, Error = loadstring( code );
	end
	
	if Error then
		return "Error: " + Error;
	end
	
	local results = { pcall( Function ) };
	
	if not results[ 1 ] then
		return "Error: " + results[ 2 ];
	end
	
	local Result = {};
	
	for i = 2, table.getn( results ) do
		local resultType = isElement( results[ i ] ) and ( "element:" + getElementType( results[ i ] ) ) or typeof( results[ i ] );
		
		table.insert( Result, (string)(results[ i ]) + " [" + resultType + "]" );
	end
	
	return table.concat( Result, ", " );
end