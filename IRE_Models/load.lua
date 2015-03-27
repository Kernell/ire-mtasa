-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

function OnStart()
	local delay = 50;

	for folder, data in pairs( Registry ) do
		for name, info in pairs( data ) do
			if info.TXD and info.DFF and info.ID then
				setTimer( Load, delay, 1, info, folder == "world" );
				
				delay = delay + 50;
			end
		end
	end

	for k, v in ipairs( { 347, 348, 349, 351, 353, 355, 356, 357, 358 } ) do
		local dff = engineLoadDFF( "dummy.dff", v );
		
		if dff then
			engineReplaceModel( dff, v );
		end
	end
end

function Load( info, world )
	if info.TXD and fileExists( info.TXD ) then
		local txd = engineLoadTXD( info.TXD, true );
		
		if txd then
			engineImportTXD( txd, info.ID );
		end
	end
	
	if info.DFF and fileExists( info.DFF ) then
		local dff = engineLoadDFF( info.DFF, world and 0 or info.ID );
		
		if dff then
			engineReplaceModel( dff, info.ID );
		end
	end
end

addEventHandler( "onClientResourceStart", resourceRoot, OnStart );