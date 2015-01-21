-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

addEvent( "ToggleClientConsole", true );

local function Toggle()
	if not console then
		console = new. ClientConsole();
		
		downloadFile( "consola.ttf" );
	end
	
	if console.m_bVisible then
		console.Hide();
	else
		console.Show();
	end
end

local function OnFileDownload( fileName, success )
	if fileName == "consola.ttf" and success then
		console.m_pFont = dxCreateFont( "consola.ttf", 9, false );
	end
end

local function OnStop()
	if console then
		delete ( console );
		
		console = NULL;
	end
end

addEventHandler( "ToggleClientConsole", root, Toggle );
addEventHandler( "onClientFileDownloadComplete", root, OnFileDownload );
addEventHandler( "onClientResourceStop", resourceRoot, OnStop );