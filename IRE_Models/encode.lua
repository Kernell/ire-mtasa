-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

addEvent( "IRE_Models::Ready", true );

local KEY = "0xBADA55";

local readyClients = {};

function OnClientReady()
	if client then
		readyClients[ client ] = true;
	end
end

function OnStart( player )
if false then
	Debug( "Encoding models..." );
	
	local tick 			= getTickCount();
	local dffCount		= 0;
	local txdCount		= 0;
	
	for folder, data in pairs( MODELS ) do
		for modelID, model in pairs( data ) do
			local txd, dff;
			
			if type( model ) == "table" then
				txd = model.TXD;
				dff = model.DFF;
			else
				txd = model;
				dff = model;
			end
			
			if dff then
				if encode( folder + "/" + dff + ".dff", "model" ) then
					dffCount = dffCount + 1;
				end
			end
			
			if txd then
				if encode( folder + "/" + txd + ".txd", "texture" ) then
					txdCount = txdCount + 1;
				end
			end
		end
	end
	
	Debug( string.format( "Encoded %d DFFs and %d TXDs for %.1f ms", dffCount, txdCount, getTickCount() - tick ) );
end
	
	for client in pairs( readyClients ) do
		readyClients[ client ] = NULL;
		
		triggerClientEvent( client, "IRE_Models::Replace", client, KEY );
	end
end

addEventHandler( "onResourceStart", resourceRoot, OnStart );

addEventHandler( "IRE_Models::Ready", root, OnClientReady );

function encode( filePath, outExt )
	local file = fileOpen( filePath );
	
	if file then
		local data = fileRead( file, fileGetSize( file ) );
		
		fileClose( file );
		
		local file = fileCreate( filePath:sub( 1, -4 ) + outExt );
		
		ASSERT( file );
		
		fileWrite( file, teaEncode( base64Encode( data ), KEY ) );
		
		fileClose( file );
		
		return true;
	end
	
	Debug( "unable to open file '" + filePath + "'", 2 );
	
	return false;
end