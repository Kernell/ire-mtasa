-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local eTutorialType	=
{
	CONNECT			= 0;
	NEW_CHARACTER	= 1;
	DEATH			= 2;
};

class: CTutorialManager ( CManager )
{
	m_TutorialStrings	= NULL;
	
	CTutorialManager	= function( this )
		this:CManager();
	end;
	
	Init				= function( this )
		g_pDB:CreateTable( DBPREFIX + "tutorials",
			{
				{ Field = "id", 		Type = "int(11) unsigned", 		Null = "NO", 	Default = false, Key = "PRI", Extra = "auto_increment" };
				{ Field = "type",		Type = "smallint(1) unsigned", 	Null = "NO", 	Default = false };
				{ Field = "text",		Type = "text", 					Null = "NO", 	Default = false };
			}
		);
		
		this.m_TutorialStrings	= {};
		
		ASSERT( g_pGame:GetEventManager():Add( CTutorialManager.HandleConnect, 		EVENT_TYPE_CONNECT,			this ) );
		ASSERT( g_pGame:GetEventManager():Add( CTutorialManager.HandleNewCharacter,	EVENT_TYPE_NEW_CHARACTER,	this ) );
		ASSERT( g_pGame:GetEventManager():Add( CTutorialManager.HandleDeath,		EVENT_TYPE_DEATH,			this ) );
		
		local pResult = g_pDB:Query( "SELECT `id`, `type`, `text` FROM `" + DBPREFIX + "tutorials` ORDER BY `id` ASC" );
		
		if not pResult then
			Debug( g_pDB:Error(), 1 );
			
			return false;
		end
		
		for i, pRow in ipairs( pResult:GetArray() ) do
			if not this.m_TutorialStrings[ pRow.type ] then
				this.m_TutorialStrings[ pRow.type ] = {};
			end
			
			table.insert( this.m_TutorialStrings[ pRow.type ], pRow.text );
		end
		
		delete ( pResult );
		
		return true;
	end;
	
	Complete			= function( this, pClient, iType )
		local pChar	= pClient:GetChar();
		
		if pChar then
			pChar:SetEventComplete( iType );
			
			if iType == eTutorialType.CONNECT then
				
			elseif iType == eTutorialType.NEW_CHARACTER then
				pClient:SetShader( "GrayScale", false );
				pClient:GetCamera():SetTarget();
				pClient:SetCollisionsEnabled( true );
				pClient:SetFrozen( false );
			elseif iType == eTutorialType.DEATH then
				
			end
		end
	end;
	
	HandleConnect		= function( this, pClient )
		if this.m_TutorialStrings[ eTutorialType.CONNECT ] then
			local pChar	= pClient:GetChar();
			
			if pChar and not pChar:IsEventComplete( eTutorialType.CONNECT ) then
				pClient:SendTutorialData( this.m_TutorialStrings[ eTutorialType.CONNECT ], eTutorialType.CONNECT );
			end
		end
	end;
	
	HandleNewCharacter	= function( this, pClient )
		if this.m_TutorialStrings[ eTutorialType.NEW_CHARACTER ] then
			local pChar	= pClient:GetChar();
			
			if pChar and not pChar:IsEventComplete( eTutorialType.NEW_CHARACTER ) then
				pClient:SetCollisionsEnabled( false );
				pClient:SetFrozen( true );
				
				setTimer(
					function()
						if pClient and pClient:IsInGame() then						
							pClient:SetShader( "GrayScale", true );
							pClient.m_pCamera:Fade( true );
							pClient:GetCamera():MoveTo( Vector3( 1648.15, -2244.8, 15.14 ), 200, "OutQuad" );
							pClient:GetCamera():RotateTo( Vector3( 1556.7, -2206.25, 2.75 ), 1 );
							pClient:SetCollisionsEnabled( false );
							pClient:SendTutorialData( this.m_TutorialStrings[ eTutorialType.NEW_CHARACTER ], eTutorialType.NEW_CHARACTER );					
						end
					end,
					1100, 1
				);
			end
		end
	end;
	
	HandleDeath			= function( this, pClient )
		if this.m_TutorialStrings[ eTutorialType.DEATH ] then
			local pChar	= pClient:GetChar();
			
			if pChar and not pChar:IsEventComplete( eTutorialType.DEATH ) then
				pClient:SendTutorialData( this.m_TutorialStrings[ eTutorialType.DEATH ], eTutorialType.DEATH );
			end
		end
	end;
};