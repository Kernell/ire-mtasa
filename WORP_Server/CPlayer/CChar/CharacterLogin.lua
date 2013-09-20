-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

function CPlayer:LoginCharacter( name, surname, bForce )
	if not self:IsLoggedIn() then
		self:ShowLoginScreen();
		
		return true;
	end
	
	if self:IsInGame() and not bForce then
		Debug( self:GetName() + " arealy in game", 2 );
		
		return false;
	end
	
	if type( name ) == 'string' and type( surname ) == 'string' then
		if not bForce then
			for _, p in pairs( g_pGame:GetPlayerManager():GetAll() ) do
				if p:IsInGame() and p:GetName() == name then
					Debug( 'This character ("' + name + ' ' + surname + '") arealy in game', 2 );
					
					return false;
				end
			end
		end
		
		local pResult = g_pDB:Query( "SELECT *, \
		DATE_FORMAT( created, '%%d/%%m/%%Y %%h:%%i:%%s' ) AS created, \
		DATE_FORMAT( last_login, '%%d/%%m/%%Y %%h:%%i:%%s' ) AS last_login, \
		DATE_FORMAT( date_of_birdth, '%%d/%%m/%%Y' ) AS date_of_birdth, \
		UNIX_TIMESTAMP( c.last_logout ) AS last_logout_t FROM " + DBPREFIX + "characters c\
		LEFT JOIN " + DBPREFIX + "police_stats ps ON ps.character_id = c.id\
		WHERE c.name = %q AND c.surname = %q AND c.status = 'Активен'", name, surname ) or not Debug( g_pDB:Error(), 1 );
		
		if pResult then
			local pRow = pResult:FetchRow();
			
			delete ( pResult );
			
			if pRow then
				g_pDB:Query( "INSERT INTO " + DBPREFIX + "police_stats ( character_id ) VALUES ( " + pRow.id + " )" );
				
				self.m_pCamera:Fade( false );
				
				self.m_iInGameCount	= 0;
				
				self.m_pCharacter = CChar( self, pRow );
				
				self:SetName( self.m_pCharacter:GetName():gsub( ' ', '_' ) );
				self:SetAlpha( 255 );
				self:SetCollisionsEnabled( true );
				self:SetData( "player_level", self.m_pCharacter:GetLevel() );
				
				setTimer(
					function()
						self:Client().OnCharacterLogin( self.m_pCharacter:GetID(), self.m_pCharacter.m_sName, self.m_pCharacter.m_sSurname );
						triggerEvent( "onCharacterLogin", self );
						
						local vecSpawn, fRotation, iInterior, iDimension;
						
						pRow.last_logout_t = (int)(pRow.last_logout_t);
						
						if pRow.last_logout_t + 3600 >= getRealTime().timestamp then
							vecSpawn, fRotation, iInterior, iDimension = Vector3( pRow.position ), pRow.rotation, pRow.interior, pRow.dimension;
						else
							vecSpawn, fRotation, iInterior, iDimension = self:GetSpawnCoords();
						end
						
						self.m_pCharacter:LoadItems();
						
						self:Spawn( vecSpawn, fRotation, pRow.skin, iInterior, iDimension, t_logged_in );
						self:SetHealth( pRow.health );
						self:SetArmor( pRow.armor );
						self.m_pHUD:Show();
						self.m_pHUD:ShowComponents( "crosshair" );
						self.m_pChat:Show();
						self.m_pNametag:Show();
						
						self.m_pCamera:SetInterior( iInterior );
						self.m_pCamera:SetTarget();
						self.m_pCamera:Fade( true );
					end,
					1000, 1
				);
				
				if not g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET last_login = NOW() WHERE id = '" + pRow.id + "'" ) then
					Debug( g_pDB:Error(), 1 ); 
				end
				
				return true;
			else
				Debug( "invalid character - " + name + ' ' + surname, 1 );
			end
		end
	else
		Debug( 'Invalid argument #1 @ "CPlayer:LoginCharacter"', 2 );
	end
	
	return false;
end