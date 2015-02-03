-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

addEvent( "IRE_Models::Replace", true );

function OnStart()
	triggerServerEvent( "IRE_Models::Ready", CLIENT );
end

function decode( data, key )
    return base64decode( teaDecode( data, key ) )
end

function DoReplace( key )
	local delay = 200;

	for folder, data in pairs( MODELS ) do
		for modelID, model in pairs( data ) do
			if type( model ) == "table" then
				local txd = model.TXD and ( folder + "/" + model.TXD );
				local dff = model.DFF and ( folder + "/" + model.DFF );
				
				setTimer( Replace, delay, 1, modelID, txd, dff, folder == "world", key );
			else
				setTimer( Replace, delay, 1, modelID, folder + "/" + model, folder + "/" + model, folder == "world", key );
			end
			
			delay = delay + 200;
		end
	end
end

function Replace( modelID, txdName, dffName, world, key )
	if txdName then
		local txd = engineLoadTXD( txdName + ".txd", true );
		
		if txd then
			engineImportTXD( txd, modelID );
		end
		
		if fileExists( txdName + ".texture" ) then
			fileDelete( txdName + ".txd" );
		end
	end
	
	if dffName then
		local dff = engineLoadDFF( dffName + ".dff", world and 0 or modelID );
		
		if dff then
			engineReplaceModel( dff, modelID );
		end
		
		fileDelete( dffName + ".dff" );
	end
end

addEventHandler( "onClientResourceStart", resourceRoot, OnStart );
addEventHandler( "IRE_Models::Replace", root, DoReplace );