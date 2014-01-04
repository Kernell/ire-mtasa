-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CItemManager ( CManager );

function CItemManager:CItemManager()
	self:CManager();
	
	g_pDB:CreateTable( DBPREFIX + "items",
		{
			{ Field = "id",			Type = "bigint(20) unsigned",	Null = "NO",	Key = "PRI", 	Default = NULL,	Extra = "auto_increment" };
			{ Field = "class",		Type = "varchar(255)",			Null = "NO",	Key = "",		Default = NULL,	};
			{ Field = "owner",		Type = "varchar(128)",			Null = "YES",	Key = "",		Default = NULL,	};
			{ Field = "position",	Type = "varchar(255)",			Null = "YES",	Key = "",		Default = NULL,	};
			{ Field = "rotation",	Type = "varchar(255)",			Null = "YES",	Key = "",		Default = NULL,	};
			{ Field = "interior",	Type = "smallint(3)",			Null = "YES",	Key = "",		Default = NULL,	};
			{ Field = "dimension",	Type = "smallint(4)",			Null = "YES",	Key = "",		Default = NULL,	};
			{ Field = "value",		Type = "int(10)",				Null = "NO",	Key = "",		Default = 0		};
			{ Field = "condition",	Type = "float",					Null = "NO",	Key = "",		Default = 100.0	};
			{ Field = "data",		Type = "text",					Null = "YES",	Key = "",		Default = NULL,	};
		}
	);
	
	self.m_List	= {};
	
	self:Load( NULL );
end

function CItemManager:_CItemManager()
	
end

function CItemManager:Load( pOwner )
	if pOwner then
		assert( pOwner.m_Items );
	end
	
	local pResult = g_pDB:Query( "SELECT `id`, `value`, `condition`, `class`, `data`, `position`, `rotation`, `interior`, `dimension` FROM " + DBPREFIX + "items WHERE owner " + ( pOwner and ( "= '" + classname( pOwner ) + "[" + (int)(pOwner:GetID()) + "]'" ) or "IS NULL" ) + " ORDER BY id ASC" );
	
	if pResult then
		for i, row in pairs( pResult:GetArray() ) do
			local rItem = self:GetItem( row.class );
			
			if rItem then
				local pItem			= rItem.m_TClass( rItem );
				local Data			= fromJSON( row.data );
				
				if Data then				
					for key, value in pairs( Data ) do
						pItem.m_Data[ key ] = tonumber( value ) or value;
					end
				end
				
				pItem.m_ID			= (int)(row.id);
				pItem.m_fCondition	= (float)(row.condition);
				pItem.m_iValue		= (int)(row.value);
				
				if not pOwner then
					if row.position and row.rotation then
						pItem:Spawn( Vector3( row.position ), Vector3( row.rotation ), (int)(row.interior), (int)(row.dimension) );
					end
				else
					pItem:Give( pOwner );
				end
				
				self:AddToList( pItem );
			end
		end
		
		delete ( pResult );
	else
		Debug( g_pDB:Error(), 1 );
	end
end

function CItemManager:DoPulse( tReal )
	-- TODO: Сборщик мусора
end

function CItemManager:Create( rItem, 				pOwner, vecPosition, vecRotation, iInterior, iDimension, iValue, fCondition, Data )
	return self:Register( rItem.m_TClass( rItem ), 	pOwner, vecPosition, vecRotation, iInterior, iDimension, iValue, fCondition, Data );
end

function CItemManager:Register( pItem, pOwner, vecPosition, vecRotation, iInterior, iDimension, iValue, fCondition, Data )
	local Fields	=
	{
		owner		= pOwner and ( classname( pOwner ) + "[" + (int)(pOwner:GetID()) + "]" ) or NULL;
		position	= vecPosition or NULL;
		rotation	= vecRotation or NULL;
		interior	= iInterior or NULL;
		dimension	= iDimension or NULL;
		value		= iValue or NULL;
		condition	= fCondition or NULL;
		data 		= Data and toJSON( Data ) or NULL;
	};
	
	local sFields	= "`class`";
	local sValues	= "'" + pItem.m_sClassName + "'";
	
	for key, value in pairs( Fields ) do
		sFields		= sFields + ", `" + key + "`";
		sValues		= sValues + ", '" + value + "'";
	end
	
	if pOwner then
		if not pItem:Give( pOwner ) then
			return false;
		end
	end
	
	if g_pDB:Query( "INSERT INTO " + DBPREFIX + "items ( " + sFields + " ) VALUES ( " + sValues + " )" ) then
		pItem.m_ID			= g_pDB:InsertID();
		pItem.m_pOwner		= pOwner;
		pItem.m_vecPosition	= vecPosition;
		pItem.m_vecRotation	= vecRotation;
		pItem.m_iInterior	= iInterior;
		pItem.m_iDimension	= iDimension;
		pItem.m_iValue		= iValue or pItem.m_iValue;
		pItem.m_fCondition	= fCondition or pItem.m_fCondition;
		
		if Data then
			for key, value in pairs( Data ) do
				pItem.m_Data[ key ] = value;
			end
		end
		
		self:AddToList( pItem );
		
		return pItem;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return NULL;
end

function CItemManager:Remove( pItem )
	if g_pDB:Query( "DELETE FROM " + DBPREFIX + "items WHERE id = " + pItem:GetID() ) then
		delete ( pItem );
		
		return true;
	end
	
	Debug( g_pDB:Error(), 1 );
	
	return false;
end

-- static TItem* CItemManager:GetItem( std::string* sItem )
function CItemManager:GetItem( sItem )
	local rItem = _G[ sItem ];
	
	return rItem and rItem.m_bIsItem and rItem or NULL;
end
