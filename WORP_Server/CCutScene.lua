-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local List = {};

class "CCutScene";

function CCutScene:CCutScene( pPlayer, sName )
	if pPlayer.m_pCutScene then
		delete ( pPlayer.m_pCutScene );
	end
	
	local sPath = "Resources/CutScenes/" + (string)(sName) + ".lua";
		
	if not fileExists( sPath ) then
		return false;
	end
	
	local pFile = fileOpen( sPath );
		
	if not pFile then
		return false;
	end
	
	local Result = fileRead( pFile, fileGetSize( pFile ) );
	
	fileClose( pFile );
	
	if not Result then
		return false;
	end
	
	assert( loadstring( Result ) )();
	
	local pCutScene 	= _G[ sName ];
	
	if not pCutScene then
		return false;
	end
	
	local ID = (string)(self);
	
	self.m_ID		= ID;
	self.m_sName	= sName;
	
	List[ ID ]	= self;
	
	pPlayer:GetCamera():Fade( false );
	
	pPlayer:Client( true ).CCutScene( pCutScene, ID );
	
	self.m_pPlayer = pPlayer;
end

function CCutScene:_CCutScene()
	if List[ self.m_ID ] then
		if self.m_pPlayer and self.m_pPlayer:IsInGame() then
			self.m_pPlayer:Client().CCutScene();
		end
	else
		if type( self.OnComplete ) == 'function' and self.m_pPlayer and self.m_pPlayer:IsInGame() then
			self:OnComplete( self.m_pPlayer );
		end
	end
end

function CClientRPC:_CCutScene( ID )
	local pCutScene = List[ ID ];
	
	if pCutScene then
		List[ ID ] = NULL;
		
		delete ( pCutScene );
	end
end