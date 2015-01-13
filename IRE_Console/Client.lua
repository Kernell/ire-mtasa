-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

function OnStart()
	console = new. ClientConsole();
end

function OnStop()
	delete ( console );
end

addEventHandler( "onClientResourceStart", resourceRoot, OnStart );
addEventHandler( "onClientResourceStop", resourceRoot, OnStop );