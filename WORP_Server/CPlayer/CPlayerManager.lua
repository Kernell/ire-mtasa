-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CPlayerManager ( CManager );

function CPlayerManager:CPlayerManager()
	self:CManager();
	self.CManager = NULL;
	
	g_pDB:CreateTable( DBPREFIX + "characters",
		{
			{ Field = "id",					Type = "int(11) unsigned",					Null = "NO",	Key = "PRI", 		Default = NULL,	Extra = "auto_increment" };
			{ Field = "user_id",			Type = "int(11)",							Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "spawn_id",			Type = "smallint(4)",						Null = "YES",	Key = "",			Default = NULL,	};
			{ Field = "faction_id",			Type = "int(5) unsigned",					Null = "NO",	Key = "",			Default = 0,	};
			{ Field = "faction_dept_id",	Type = "smallint(5) unsigned",				Null = "NO",	Key = "",			Default = 0,	};
			{ Field = "faction_rank_id",	Type = "smallint(5) unsigned",				Null = "NO",	Key = "",			Default = 0,	};
			{ Field = "faction_rights",		Type = "varchar(8)",						Null = "NO",	Key = "",			Default = "0",	};
			{ Field = "level",				Type = "smallint(3)",						Null = "NO",	Key = "",			Default = 1,	};
			{ Field = "level_points",		Type = "int(11)",							Null = "NO",	Key = "",			Default = 0,	};
			{ Field = "name",				Type = "varchar(11)",						Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "surname",			Type = "varchar(11)",						Null = "NO",	Key = "",			Default = NULL,	};
			{ Field = "created",			Type = "timestamp",							Null = "NO",	Key = "",			Default = "0000-00-00 00:00:00",	};
			{ Field = "last_login",			Type = "timestamp",							Null = "NO",	Key = "",			Default = "0000-00-00 00:00:00",	};
			{ Field = "last_logout",		Type = "timestamp",							Null = "NO",	Key = "",			Default = CMySQL.CURRENT_TIMESTAMP,	};
			{ Field = "status",	Type = "enum('Активен','Заблокирован','Убит','Скрыт')",	Null = "NO", 	Key = "",			Default = "Активен",	};
			{ Field = "date_of_birdth",		Type = "datetime",							Null = "NO", 	Key = "",			Default = "0000-00-00 00:00:00",	};
			{ Field = "place_of_birdth",	Type = "varchar(255)",						Null = "NO", 	Key = "",			Default = "Неизвестно",	};
			{ Field = "nation",				Type = "varchar(3)",						Null = "NO", 	Key = "",			Default = "en",	};
			{ Field = "languages",			Type = "text",								Null = "NO", 	Key = "",			Default = NULL,	};
			{ Field = "interior",			Type = "smallint(6)",						Null = "NO", 	Key = "",			Default = 0,	};
			{ Field = "dimension",			Type = "smallint(6)",						Null = "NO", 	Key = "",			Default = 0,	};
			{ Field = "position",			Type = "varchar(255)",						Null = "NO", 	Key = "",			Default = "(0,0,0)",	};
			{ Field = "rotation",			Type = "float",								Null = "NO", 	Key = "",			Default = 0,	};
			{ Field = "skin",				Type = "smallint(6)",						Null = "NO", 	Key = "",			Default = 0,	};
			{ Field = "money",				Type = "double",							Null = "NO", 	Key = "",			Default = 1000,	};
			{ Field = "pay",				Type = "int(10) unsigned",					Null = "NO", 	Key = "",			Default = 0,	};
			{ Field = "health",				Type = "float",								Null = "NO", 	Key = "",			Default = 100,	};
			{ Field = "armor",				Type = "float",								Null = "NO", 	Key = "",			Default = 0,	};
			{ Field = "alcohol",			Type = "float",								Null = "NO", 	Key = "",			Default = 0,	};
			{ Field = "power",				Type = "float",								Null = "NO", 	Key = "",			Default = 100,	};
			{ Field = "licenses",			Type = "text",								Null = "NO", 	Key = "",			Default = NULL,	};
			{ Field = "jailed",			Type = "enum('No','Police','FBI','Prison')",	Null = "NO", 	Key = "",			Default = "No",	};
			{ Field = "jailed_time",		Type = "int(11)",							Null = "NO", 	Key = "",			Default = 0,	};
			{ Field = "married",			Type = "varchar(255)",						Null = "YES", 	Key = "",			Default = NULL,	};
			{ Field = "job",				Type = "varchar(128)",						Null = "YES", 	Key = "",			Default = NULL,	};
			{ Field = "job_skill",			Type = "int(11)",							Null = "NO", 	Key = "",			Default = 0,	};
			{ Field = "phone",				Type = "int(11)",							Null = "YES", 	Key = "UNI",		Default = NULL,	};
			{ Field = "events",				Type = "text",								Null = "YES", 	Key = "",			Default = NULL,	};
		}
	);
	
	local scoreboard_columns =
	{
		{ 'player_id', 		40, 'ID', 1 };
		{ 'player_level',	80, 'Level', 10 };
	};
	
	t_logged_in			= CTeam( 'Players', 255, 255, 255 );
	t_not_logged_in		= CTeam( 'Not logged in', 120, 120, 120 );
	
	exports.scoreboard:scoreboardSetColumnPriority( "name", 5 );
	
	for _, value in ipairs( scoreboard_columns ) do
		exports.scoreboard:scoreboardAddColumn( value[ 1 ], nil, value[ 2 ], value[ 3 ], value[ 4 ] );
	end
	
	exports.scoreboard:scoreboardSetSortBy( "player_id", true );

	self.m_List	= {};
	
	function self.__onPlayerModInfo( sFile, List )
		self:OnPlayerModInfo( source, sFile, List );
	end
	
	addEventHandler( "onPlayerModInfo", root, self.__onPlayerModInfo );
	
	return true;
end

function CPlayerManager:_CPlayerManager()
	self:DeleteAll();
	
	self.m_List	= NULL;
	
	removeEventHandler( "onPlayerModInfo", root, self.__onPlayerModInfo );
end

function CPlayerManager:OnPlayerModInfo( pPlayer, sFile, List )
	if _DEBUG then
		Debug( "ModInfo: " + pPlayer:GetName() + " - " + sFile );
		
		for i, pMod in ipairs( List ) do
			Debug( (string)(pMod.id) + ": " + (string)(pMod.name) + " (" + (string)(pMod.hash) + ")" );
		end
	end
end

function CPlayerManager:DoPulse( tReal )
	for iter, pPlayer in pairs( self.m_List ) do
		pPlayer:DoPulse( tReal );
	end
end

function CPlayerManager:Create( pPlayerEntity )
    local pPlayer = CPlayer( self, pPlayerEntity );
	
    if pPlayer:GetID() == INVALID_ELEMENT_ID then
        delete ( pPlayer );
		
        return NULL;
    end
	
    return pPlayer;
end

function CPlayerManager:GetAll()
	return self.m_List;
end

function CPlayerManager:GetByCharID( iCharID )
	for i, p in pairs( self.m_List ) do
		if p:IsInGame() and p:GetChar():GetID() == iCharID then
			return p;
		end
	end
	
	return NULL;
end

function CPlayerManager:Get( vArg1, bCaseSensitive )
	if tonumber( vArg1 ) then
		return self.m_List[ tonumber( vArg1 ) ];
	elseif type( vArg1 ) == "string" then
		local sName = vArg1:gsub( " ", "_" );
		
		bCaseSensitive = bCaseSensitive == NULL or false;
		
		if not bCaseSensitive then
			sName = sName:lower();
		end
		
		for i, p in pairs( self.m_List ) do
			if bCaseSensitive and p:GetName():find( sName ) or p:GetName():lower():find( sName ) then
				return p;
			end
		end
	end
	
	return NULL;
end

function CPlayerManager:DeleteAll()
	local iTick, iCount = getTickCount(), 0;
	
    for iter, pPlayer in pairs( self.m_List ) do
		pPlayer:Unlink();
		
		self.m_List[ iter ] = NULL;
		
		iCount = iCount + 1;
	end
	
	if _DEBUG then Debug( ( 'All players (%d) saved (%d ms)' ):format( iCount, getTickCount() - iTick ) ); end
end

function CPlayerManager:AddToList( pPlayer )
	local iID = 0;
	
	for key in ipairs( self.m_List ) do
		iID = key;
	end
	
	pPlayer.m_iID = iID + 1;
	
	self.m_List[ pPlayer.m_iID ] = pPlayer.__instance;
	
	pPlayer:SetID( "player:" + pPlayer.m_iID );
end

function CPlayerManager:RemoveFromList( pPlayer )
	self.m_List[ pPlayer:GetID() ]	= NULL;
	
	delete ( pPlayer );
	pPlayer = NULL;	
end
