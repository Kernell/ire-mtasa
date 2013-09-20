-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CEventMarkerManager ( CManager )
{
	m_List		= NULL;
	
	m_sTable	= "markers";
	m_sQuery	= "SELECT `id`, `model`, `position`, `interior`, `dimension`, `size`, `color`, `onhit`, `onleave` FROM ";
};

function CEventMarkerManager:CEventMarkerManager()
	g_pDB:CreateTable( DBPREFIX + self.m_sTable,
		{
			{ Field = "id",			Type = "int(11) unsigned",			Null = "NO",	Key = "PRI", 	Default = NULL,	Extra = "auto_increment" };
			{ Field = "model",		Type = "varchar(64)",				Null = "NO",	Key = "", 		Default = NULL	};
			{ Field = "position",	Type = "varchar(256)",				Null = "NO",	Key = "", 		Default = NULL	};
			{ Field = "interior",	Type = "smallint(4)",				Null = "NO",	Key = "", 		Default = NULL	};
			{ Field = "dimension",	Type = "smallint(8)",				Null = "NO",	Key = "", 		Default = NULL	};
			{ Field = "size",		Type = "float",						Null = "YES",	Key = "", 		Default = NULL	};
			{ Field = "color",		Type = "varchar(32)",				Null = "YES",	Key = "", 		Default = NULL	};
			{ Field = "onhit",		Type = "varchar(128)",				Null = "YES",	Key = "", 		Default = NULL	};
			{ Field = "onleave",	Type = "varchar(128)",				Null = "YES",	Key = "", 		Default = NULL	};
			{ Field = "deleted",	Type = "timestamp",					Null = "YES",	Key = "", 		Default = NULL	};
		}
	);
end

function CEventMarkerManager:_CEventMarkerManager()
	self:DeleteAll();
end

function CEventMarkerManager:Init()
	local iTick, iCount = getTickCount(), 0;
	
	self.m_List	= {};
	
	local pResult = g_pDB:Query( self.m_sQuery + DBPREFIX + self.m_sTable + " WHERE deleted IS NULL" );
	
	if pResult then
		for i, pRow in ipairs( pResult:GetArray() ) do
			CEventMarker( self, pRow.id, pRow.model, Vector3( pRow.position ), pRow.interior, pRow.dimension, pRow.size, pRow.color and pRow.color:split( ',' ), pRow.onhit, pRow.onleave );
		end
		
		delete ( pResult );
	else
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
--	Debug( ( "Loaded %d event markers (%d ms)" ):format( iCount, getTickCount() - iTick ) );
	
	return true;
end

function CEventMarkerManager:Create( Data )
	local iID = g_pDB:Insert( DBPREFIX + self.m_sTable, Data );
	
	if iID then
		local pResult = g_pDB:Query( self.m_sQuery + DBPREFIX + self.m_sTable + " WHERE id = %d LIMIT 1", iID );
		
		if pResult then
			local pRow = pResult:FetchRow();
			
			delete ( pResult );
			
			return CEventMarker( self, pRow.id, pRow.model, Vector3( pRow.position ), pRow.interior, pRow.dimension, pRow.size, pRow.color and pRow.color:split( ',' ), pRow.onhit, pRow.onleave );
		end
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return NULL;
end

function CEventMarkerManager:Remove( pMarker )
	if g_pDB:Query( "DELETE FROM " + DBPREFIX + self.m_sTable + " WHERE id = " + pMarker:GetID() ) then
		delete ( pMarker );
		
		return true;
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	return false;
end