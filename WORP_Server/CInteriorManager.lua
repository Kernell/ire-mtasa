-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CInteriorManager ( CManager )
{
	m_InteriorColors	= 
	{
		[ INTERIOR_TYPE_NONE ]			= { 255, 255, 255, 128 };
		[ INTERIOR_TYPE_COMMERCIAL ]	= { 0, 128, 255, 128 };
		[ INTERIOR_TYPE_HOUSE ]			= { 0, 255, 0, 128 };
	};
};

function CInteriorManager:CInteriorManager()
	self:CManager();
	
	g_pDB:CreateTable( DBPREFIX + "interiors",
		{
			{ Field = "id",					Type = "int(11) unsigned",		Null = "NO",	Key = "PRI", 	Default = NULL,	Extra = "auto_increment" };
			{ Field = "character_id",		Type = "int(11) unsigned",		Null = "NO",	Key = "", 		Default = 0 };
			{ Field = "interior_id",		Type = "varchar(255)",			Null = "NO",	Key = "", 		Default = NULL };
			{ Field = "faction_id",			Type = "int(11) unsigned",		Null = "YES",	Key = "", 		Default = NULL };
			{ Field = "type",				Type = "enum('interior','business','house')",	Null = "NO",	Key = "", 		Default = CInterior.m_sType };
			{ Field = "name",				Type = "varchar(255)",			Null = "NO",	Key = "", 		Default = NULL };
			{ Field = "price",				Type = "int(11)",				Null = "NO",	Key = "", 		Default = NULL };
			{ Field = "locked",				Type = "enum('Yes','No')",		Null = "NO",	Key = "", 		Default = "Yes" };
			{ Field = "outside_x",			Type = "float",					Null = "NO",	Key = "", 		Default = NULL };
			{ Field = "outside_y",			Type = "float",					Null = "NO",	Key = "", 		Default = NULL };
			{ Field = "outside_z",			Type = "float",					Null = "NO",	Key = "", 		Default = NULL };
			{ Field = "outside_rotation",	Type = "float",					Null = "NO",	Key = "", 		Default = NULL };
			{ Field = "dropoff_x",			Type = "float",					Null = "NO",	Key = "", 		Default = 0 };
			{ Field = "dropoff_y",			Type = "float",					Null = "NO",	Key = "", 		Default = 0 };
			{ Field = "dropoff_z",			Type = "float",					Null = "NO",	Key = "", 		Default = 0 };
			{ Field = "store",				Type = "text",					Null = "YES",	Key = "", 		Default = NULL };
			{ Field = "upgrades",			Type = "text",					Null = "YES",	Key = "", 		Default = NULL };
			{ Field = "deleted",			Type = "timestamp",				Null = "YES",	Key = "", 		Default = NULL };
		}
	);
end

function CInteriorManager:Init()
	self.m_List	= {};
	
	local pResult = g_pDB:Query( "SELECT id, interior_id, character_id, name, type, price, locked, faction_id, outside_x, outside_y, outside_z, outside_rotation FROM " + DBPREFIX + "interiors WHERE deleted IS NULL ORDER BY id ASC" );
	
	if pResult then
		for _, pRow in ipairs( pResult:GetArray() ) do
			local iID			= pRow.id;
			local sInteriorID	= pRow.interior_id;
			local iCharacterID	= pRow.character_id;
			local sName			= pRow.name;
			local sType			= pRow.type;
			local iPrice		= pRow.price;
			local bLocked		= pRow.locked == 'Yes';
			local iFactionID	= pRow.faction_id;
			
			local vecPosition	= Vector3( pRow.outside_x, pRow.outside_y, pRow.outside_z );
			local fRotation		= pRow.outside_rotation;
			
			local Store			= pRow.store and fromJSON( pRow.store );
			local Upgrades		= pRow.upgrades and fromJSON( pRow.upgrades );
			
			local pInterior		= CInterior( iID, sInteriorID, iCharacterID, sName, sType, iPrice, bLocked, iFactionID, vecPosition, fRotation, Store, Upgrades );
		end
		
		delete ( pResult );		
		
		g_pInteriorFisc = self.m_List[ 1 ];
	else
		Debug( g_pDB:Error(), 1 );
		
		return false;
	end
	
	return true;
end

function CInteriorManager:Create( sInteriorID, iCharacterID, sName, sType, iPrice, bLocked, iFactionID, vecPosition, fRotation )
	if not self:IsValid( sInteriorID ) then
		return NULL;
	end
	
	iCharacterID	= (int)(iCharacterID);
	iFactionID		= (int)(iFactionID);
	sType			= eInteriorType[ sType ] and sType or CInterior.m_sType;
	iPrice			= (int)(iPrice);
	bLocked			= bLocked == NULL or bLocked == true;
	fRotation		= (float)(fRotation);
	
	local iID = g_pDB:Insert( DBPREFIX + "interiors",
		{
			interior_id			= sInteriorID;
			character_id		= iCharacterID;
			faction_id			= iFactionID;
			name				= sName;
			type				= sType;
			price				= iPrice;
			locked				= bLocked and "Yes" or "No";
			outside_x			= vecPosition.X;
			outside_y			= vecPosition.Y;
			outside_z			= vecPosition.Z;
			outside_rotation	= fRotation;
		}
	);
	
	if iID then
		return CInterior( iID, sInteriorID, iCharacterID, sName, sType, iPrice, bLocked, iFactionID, vecPosition, fRotation, {}, {} );
	else
		Debug( g_pDB:Error(), 1 );
	end
	
	return NULL;
end

function CInteriorManager:GenerateLocations()
	local iTick = getTickCount();
	local Zones = {};
	
	for iID, pProperty in pairs( self.m_List ) do
		if pProperty.m_pOutsideMarker and pProperty.m_pOutsideMarker:GetDimension() == 0 then
			local vecPosition = pProperty.m_pOutsideMarker:GetPosition();
			
			local sZoneName = GetZoneName( vecPosition, false );
			
			if not Zones[ sZoneName ] then
				Zones[ sZoneName ] = {};
			end
			
			table.insert( Zones[ sZoneName ], pProperty );
		end
	end
	
	local function SortFunction( pIntA, pIntB )
		local vecA = pIntA.m_pOutsideMarker:GetPosition();
		local vecB = pIntB.m_pOutsideMarker:GetPosition();
		
		vecA.X	= vecA.X - 3000;
		vecA.Y	= vecA.Y - 3000;
		vecA.Z	= 0;
		
		vecB.X	= vecB.X - 3000;
		vecB.Y	= vecB.Y - 3000;
		vecB.Z	= 0;
		
		return vecA:Length() < vecB:Length();
	end
	
	for sZoneName, List in pairs( Zones ) do
		table.sort( List, SortFunction );
		
		for i, pInt in ipairs( List ) do
			pInt:SetName( sZoneName + ", " + i );
		end
	end
	
	Debug( ( "pInteriorManager->GenerateLocations() - %d ms." ):format( getTickCount() - iTick ) );
end

function CInteriorManager:GetColor( void )
	if eInteriorType[ void ] then
		return self.m_InteriorColors[ void ];
	elseif type( void ) == "number" then
		local pInt = self:Get( void );
		
		return pInt and self.m_InteriorColors[ pInt:GetColor() ];
	elseif classof( void ) == CInterior then
		return self.m_InteriorColors[ void:GetType() ];
	end
	
	return NULL;
end

function CInteriorManager:IsValid( void )
	if type( void ) == 'string' then
		return INTERIORS_LIST[ void ] ~= NULL;
	elseif type( void ) == 'number' then
		local pInt = self:Get( void );
		
		return pInt and INTERIORS_LIST[ pInt.m_sInteriorID ];
	elseif classof( void ) == CInterior then
		return self:IsValid( void:GetID() );
	end
	
	return false;
end

function CInteriorManager:GetInterior( sInterior )
	return INTERIORS_LIST[ sInterior ];
end
