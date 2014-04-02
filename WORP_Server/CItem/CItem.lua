-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

enum "eItemSlot"
{
	"ITEM_SLOT_NONE";
	"ITEM_SLOT_WEAPON1";	-- 'wpn_shotgun','wpn_spas12','wpn_mp5','wpn_ak47','wpn_m4a1','wpn_aug','wpn_scout','wpn_rpg'
	"ITEM_SLOT_WEAPON2";	-- 'wpn_usp45','wpn_usp45_silinced','wpn_desert_eagle'
	"ITEM_SLOT_WEAPON3";	-- 'wpn_nightstick','wpn_knife','wpn_baseball_bat','wpn_shovel','wpn_katana','wpn_long_purple_dildo','wpn_short_tan_dildo','wpn_vibrator','wpn_flowers',
							-- 'wpn_camera','wpn_spraycan'
	"ITEM_SLOT_WEAPON4";	-- 'wpn_grenade','wpn_tear_gas','wpn_grenade_flash','wpn_molotov'
	"ITEM_SLOT_CLIP_AMMO";
	"ITEM_SLOT_SKINS";
};

enum "eItemType"
{
	"ITEM_TYPE_NONE";
	"ITEM_TYPE_WEAPON";
	"ITEM_TYPE_AMMO";
	"ITEM_TYPE_CLIP_AMMO";
	"ITEM_TYPE_SKINS";
	"ITEM_TYPE_FOOD";
	"ITEM_TYPE_DRINK";
};

local pItemRoot		= createElement( "itemRoot", "itemRoot" );

class: CItem
{
	m_ID			= 1;
	m_sClassName	= NULL;
	m_iValue		= 0;
	m_fCondition	= 100.0;
	
	m_pEntity		= NULL;
	m_pOwner		= NULL;
	m_Data			= NULL;
	
	GetID			= function( self ) return self.m_ID; end
};

function CItem:CItem( rItem )
	self.m_sClassName	= classname( rItem );
	
	for k, v in pairs( rItem ) do
		if k:sub( 1, 2 ) == "m_" then
			self[ k ] = v;
		end
	end
	
	self.m_Data = {};
end

function CItem:_CItem()
	g_pGame:GetItemManager():RemoveFromList( self );
	
	if self.m_pEntity then
		delete ( self.m_pEntity );
		self.m_pEntity = NULL;
	end
	
	self.m_Data = NULL;
	
	self:Take();
end

function CItem:SetOwner( pOwner )
	self.m_pOwner = pOwner;
	
	g_pDB:Query( "UPDATE " + DBPREFIX + "items SET owner = '%s[%i]' WHERE id = %i", classname( pOwner ), pOwner:GetID(), self:GetID() );
end

function CItem:Spawn( vecPosition, vecRotation, iInterior, iDimension )
	self.m_pOwner	= NULL;
	
	if self.m_iModel ~= -1 then
		self.m_vecPosition		= vecPosition;
		self.m_vecRotation		= vecRotation;
		
		local vecPosition		= self.m_vecPosition + self.m_vecSpawnPos;
		local vecRotation		= self.m_vecRotation + self.m_vecSpawnRot;
		
		self.m_pEntity 			= CObject( self.m_iModel, vecPosition, vecRotation );
		
		self.m_pEntity:SetInterior		( iInterior );
		self.m_pEntity:SetDimension		( iDimension );
		self.m_pEntity:SetParent		( pItemRoot );
		
		self.m_pEntity.m_pColShape		= CColShape ( "Sphere", vecPosition.X, vecPosition.Y, vecPosition.Z + .5, 1.0 );
		
		self.m_pEntity.m_pColShape:SetData			( "object_id", self.m_ID );
		self.m_pEntity.m_pColShape:SetData			( "item", self.m_sClassName );
		self.m_pEntity.m_pColShape:SetData			( "item_name", self.m_sName );
		self.m_pEntity.m_pColShape:SetInterior		( iInterior );
		self.m_pEntity.m_pColShape:SetDimension		( iDimension );
		self.m_pEntity.m_pColShape:SetParent		( self.m_pEntity );
		
		return self.m_pEntity;
	end
	
	return NULL;
end

function CItem:Drop()
	if self.m_pOwner then
		local vecPosition	= self.m_pOwner:GetPosition();
		local vecRotation	= self.m_pOwner:GetRotation();
		local iInterior		= self.m_pOwner:GetInterior();
		local iDimension	= self.m_pOwner:GetDimension();
		
		self:Take();
		
		return self:Spawn( vecPosition, vecRotation, iInterior, iDimension );
	end
	
	return false;
end

function CItem:Give( pOwner )
	if pOwner.m_Items == NULL then error( "pOwner->m_Items == NULL", 2 ); end
	
	self:Take();
	
	if classof( pOwner ) == CChar then
		if pOwner.m_SlotLimits[ self.m_iSlot ] == 0 then
			-- self.m_pOwner = pOwner;
			
			-- self:Use();
			
			-- return true;
			return false;
		elseif pOwner.m_SlotLimits[ self.m_iSlot ] > 1 then
			if table.getn( pOwner.m_Items[ self.m_iSlot ] ) >= CChar.m_SlotLimits[ self.m_iSlot ] then
				return false;
			end
			
			table.insert( pOwner.m_Items[ self.m_iSlot ], self );
		else
			if pOwner.m_Items[ self.m_iSlot ] then
				return false;
			end
			
			pOwner.m_Items[ self.m_iSlot ] = self;
		end
		
		if self.m_iBone and self.m_iModel ~= -1 then
			self.m_pEntity = pOwner.m_pPlayer:GetBones():AttachObject( self.m_iBone, self.m_iModel, self.m_vecBonePos, self.m_vecBoneRot );
		end
	else
		table.insert( pOwner.m_Items, self );
	end
	
	self.m_pOwner = pOwner;
	
	return true;
end

function CItem:Take()
	if self.m_pEntity then
		delete ( self.m_pEntity );
		self.m_pEntity = NULL;
	end
	
	if self.m_pOwner then
		local iCount = 0;
		
		if self.m_pOwner.m_SlotLimits and self.m_pOwner.m_SlotLimits[ self.m_iSlot ] > 1 then
			for i = table.getn( self.m_pOwner.m_Items[ self.m_iSlot ] ), 1, -1 do
				if self.m_pOwner.m_Items[ self.m_iSlot ][ i ] == self then
					table.remove( self.m_pOwner.m_Items[ self.m_iSlot ], i );
					
					iCount = iCount + 1;
				end
			end
		elseif self.m_pOwner.m_Items[ self.m_iSlot ] then
			self.m_pOwner.m_Items[ self.m_iSlot ] = NULL;
			
			iCount = iCount + 1;
		end
		
		self.m_pOwner = NULL;
		
		return iCount;
	end
	
	return 0;
end

function CItem:Use()
	if self.m_iType == ITEM_TYPE_NONE then
		return true;
	elseif self.m_iType == ITEM_TYPE_AMMO then
		return true;
	elseif self.m_iType == ITEM_TYPE_SKINS then			-- // TODO: надеть скин
		return true;
	else
		Debug( "bad item type " + (string)(self.m_iType), 2 );
	end
	
	return false;
end

function CItem:Save()
	local Data = NULL;
	
	if self.m_Data then
		Data = {};
		
		for key, value in pairs( self.m_Data ) do
			-- if key:sub( 1, 3 ) == 'm_p' then
				-- Data[ key ] = value:GetID();
			-- else
				Data[ key ] = value;
			-- end
		end
	end
	
	local SaveData	=
	{
		"`owner`		= " + ( self.m_pOwner and ( "'" + classname( self.m_pOwner ) + "[" + (int)(self.m_pOwner:GetID()) + "]'" ) or "NULL" );
		"`position` 	= " + ( self.m_vecPosition and ( "'" + self.m_vecPosition + "'" ) or "NULL" );
		"`rotation` 	= " + ( self.m_vecRotation and ( "'" + self.m_vecRotation + "'" ) or "NULL" );
		"`interior` 	= " + ( self.m_pEntity and self.m_pEntity:GetInterior() or "NULL" );
		"`dimension` 	= " + ( self.m_pEntity and self.m_pEntity:GetDimension() or "NULL" );
		"`value`		= '" + self.m_iValue + "'";
		"`condition`	= '" + self.m_fCondition + "'";
		"`data`			= " + ( Data and ( "'" + toJSON( Data ) + "'" ) or "NULL" );
	};
	
	return g_pDB:Query( "UPDATE " + DBPREFIX + "items SET " + table.concat( SaveData, ', ' ) + "  WHERE id = " + self:GetID() ) or not Debug( g_pDB:Error(), 1 );
end