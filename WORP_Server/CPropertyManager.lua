-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CPropertyManager ( CManager )
{
	static
	{
		m_sTableName	= "property";
		m_sSelectFields	= "id, owner_id, owner_type, interior_id, type, name, price, locked, drop_position, position, rotation, interior, dimension, store";
		
		m_Colors = 
		{
			[ ePropertyType.COMMERCIAL ]	= { 0, 128, 255, 128 };
			[ ePropertyType.HOUSE ]			= { 0, 255, 0, 128 };
		};
		
		GetColor	= function( this, pProperty )
			return CPropertyManager.m_Colors[ pProperty.m_iType ];
		end;
		
		GetInterior		= function( this, sInterior )
			return INTERIORS_LIST[ sInterior ];
		end;
	};
	
	CPropertyManager	= function( this )
		this:CManager();
		
		g_pDB:CreateTable( DBPREFIX + CPropertyManager.m_sTableName,
			{
				{ Field = "id",					Type = "int(11) unsigned",		Null = "NO",	Key = "PRI", 	Default = NULL,	Extra = "auto_increment" };
				{ Field = "owner_id",			Type = "int(11) unsigned",		Null = "NO",	Key = "", 		Default = CProperty.m_iOwnerID };
				{ Field = "owner_type",			Type = "tinyint(1)",			Null = "NO",	Key = "", 		Default = CProperty.m_iOwnerType };
				{ Field = "interior_id",		Type = "varchar(64)",			Null = "NO",	Key = "", 		Default = CProperty.m_sInteriorID };
				{ Field = "type",				Type = "tinyint(1)",			Null = "NO",	Key = "", 		Default = CProperty.m_iType };
				{ Field = "name",				Type = "varchar(255)",			Null = "NO",	Key = "", 		Default = CProperty.m_sName };
				{ Field = "price",				Type = "int(11) unsigned",		Null = "NO",	Key = "", 		Default = CProperty.m_iPrice };
				{ Field = "locked",				Type = "enum('true','false')",	Null = "NO",	Key = "", 		Default = (string)(CProperty.m_bLocked) };
				{ Field = "drop_position",		Type = "varchar(255)",			Null = "NO",	Key = "", 		Default = CProperty.m_vecDropPosition };
				{ Field = "position",			Type = "varchar(255)",			Null = "NO",	Key = "", 		Default = CProperty.m_vecPosition };
				{ Field = "rotation",			Type = "float",					Null = "NO",	Key = "", 		Default = CProperty.m_fRotation };
				{ Field = "interior",			Type = "smallint(3)",			Null = "NO",	Key = "", 		Default = CProperty.m_iInterior };
				{ Field = "dimension",			Type = "smallint(4)",			Null = "NO",	Key = "", 		Default = CProperty.m_iDimension };
				{ Field = "store",				Type = "text",					Null = "YES",	Key = "", 		Default = NULL };
				{ Field = "deleted",			Type = "timestamp",				Null = "YES",	Key = "", 		Default = NULL };
			}
		);
	end;
	
	Init		= function( this )
		this.m_List	= {};
		
		local pResult = g_pDB:Query( "SELECT " + CPropertyManager.m_sSelectFields + " FROM " + DBPREFIX + CPropertyManager.m_sTableName + " WHERE deleted IS NULL ORDER BY id ASC" );
		
		if pResult then
			for _, pRow in ipairs( pResult:GetArray() ) do
				local pProperty		= CProperty( iID );
				
				if sInteriorID then
					pProperty.m_pInterior		= CPropertyManager:GetInterior( sInteriorID )
					
					if not pProperty.m_pInterior then
						Debug( "Bad interior '" + (string)(sInteriorID) + "'", 2 );
					end
				end
				
				pProperty.m_iOwnerID		= pRow.owner_id;
				pProperty.m_iOwnerType		= pRow.owner_type;
				pProperty.m_iType			= pRow.type;
				pProperty.m_iPrice			= (int)(pRow.price);
				pProperty.m_sName			= pRow.name;
				pProperty.m_bLocked			= (bool)(pRow.locked);
				pProperty.m_vecDropPosition	= Vector3( pRow.drop_position );
				pProperty.m_vecPosition		= Vector3( pRow.position );
				pProperty.m_fRotation		= pRow.rotation;
				pProperty.m_iInterior		= pRow.interior;
				pProperty.m_iDimension		= pRow.dimension;
				pProperty.m_Store			= pRow.store and fromJSON( pRow.store ) or NULL;
				
				pProperty:Update();
				
				this:AddToList( pProperty );
			end
			
			delete ( pResult );
		else
			Debug( g_pDB:Error(), 1 );
			
			return false;
		end
		
		return true;
	end;
};
