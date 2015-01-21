-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

addEvent( "ToggleClientConsole", true );

function Toggle()
	if not console then
		console = new. ClientConsole();
	end
	
	if console.m_bVisible then
		console.Hide();
	else
		console.Show();
	end
end

function OnStop()
	if console then
		delete ( console );
		
		console = NULL;
	end
end

addEventHandler( "ToggleClientConsole", root, Toggle );
addEventHandler( "onClientResourceStop", resourceRoot, OnStop );