-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CFaction
{
	m_bIsFaction		= true;
	
	m_iID				= 0;
	m_iOwnerID			= 0;
	m_iPropertyID		= 0;
	m_sBankAccountID	= NULL;
	m_sName				= "N/A";
	m_sTag				= "N/A";
	m_sCreated			= NULL;
	m_sRegistered		= NULL;
	m_iType				= FACTION_TYPE_GOV;
	m_aFlags			= NULL;
	m_pElement			= NULL;
};

function CFaction:CFaction( iID, sFlags )
	self.m_iID			= iID or self.m_iID;
	self.m_aFlags		= {};
	
	if sFlags then
		for _, sFlag in ipairs( sFlags:split( ',' ) ) do
			if eFactionFlags[ sFlag ] then
				self.m_aFlags[ sFlag ] = true;
			end
		end
	end
	
	self.m_Depts		= {};
	
	self.m_pElement		= createElement( "faction", "faction:" + self:GetID() );
	
	g_pGame:GetFactionManager():AddToList( self );
end

function CFaction:_CFaction()
	g_pGame:GetFactionManager():RemoveFromList( self );
	
	self.m_iID			= NULL;
	self.m_sName		= NULL;
	self.m_sTag			= NULL;
	self.m_iType		= NULL;
	self.m_Depts		= NULL;
	self.m_aFlags		= NULL;
	self.m_pElement		= NULL;
end

function CFaction:TestRight( pChar, xRight )
	local xRights	= eFactionRight.NONE;
	
	if type( pChar ) == "number" then
		xRights		= pChar;
	else
		if pChar:GetFaction() then
			xRights		= pChar:GetFactionRights();
		end
		
		if pChar:GetID() == self.m_iOwnerID then
			xRights		= eFactionRight.OWNER;
		end
		
		if pChar.m_pClient:HaveAccess( "command.faction:edit" ) then
			xRights		= eFactionRight.ALL;
		end
	end
	
	return ( xRights '&' ( xRight ) ) ~= 0;
end

function CFaction:SetName( sName )
	if type( sName ) == "string" and sName:len() > 3 then
		if g_pDB:Query( "UPDATE " + DBPREFIX + "factions SET name = %q WHERE id = " + self:GetID(), sName ) then
			self.m_sName = sName;
			
			return true;
		else
			Debug( g_pDB:Error(), 1 );
		end
	end
	
	return false;
end

function CFaction:SetTag( sTag )
	if type( sTag ) == "string" and sTag:len() > 0 and sTag:len() <= 4 then
		if g_pDB:Query( "UPDATE " + DBPREFIX + "factions SET tag = %q WHERE id = " + self:GetID(), sTag ) then
			self.m_sTag = sTag;
			
			return true;
		else
			Debug( g_pDB:Error(), 1 );
		end
	end
	
	return false;
end

function CFaction:SetType( iType )
	if eFactionType[ iType ] then
		if g_pDB:Query( "UPDATE " + DBPREFIX + "factions SET type = %q WHERE id = " + self:GetID(), iType ) then		
			self.m_iType = iType;
			
			return true;
		else
			Debug( g_pDB:Error(), 1 );
		end
	end
	
	return false;
end

function CFaction:SetFlag( sFlag )
	self.m_aFlags[ sFlag ] = true;
	
	local aFlags = {};
	
	for key in pairs( self.m_aFlags ) do
		if self.m_aFlags[ key ] then
			table.insert( aFlags, key );
		end
	end
	
	if g_pDB:Query( "UPDATE " + DBPREFIX + "factions SET flags = %q WHERE id = " + self:GetID(), table.concat( aFlags, ',' ) ) then
		return true;
	else
		self.m_aFlags[ sFlag ] = NULL;
		
		Debug( g_pDB:Error(), 1 );
	end
	
	return false;
end

function CFaction:RemoveFlag( sFlag )
	self.m_aFlags[ sFlag ] = NULL;
	
	local aFlags = {};
	
	for key in pairs( self.m_aFlags ) do
		if self.m_aFlags[ key ] then
			table.insert( aFlags, key );
		end
	end
	
	if g_pDB:Query( "UPDATE " + DBPREFIX + "factions SET flags = %q WHERE id = " + self:GetID(), table.concat( aFlags, ',' ) ) then
		return true;
	else
		self.m_aFlags[ sFlag ] = true;
		
		Debug( g_pDB:Error(), 1 );
	end
	
	return false;
end

function CFaction:HaveFlag( sFlag )
	return (bool)(self.m_aFlags[ sFlag ]);
end

function CFaction:GetID()
	return self.m_iID;
end

function CFaction:GetName()
	return self.m_sName;
end

function CFaction:GetTag()
	return self.m_sTag;
end

function CFaction:GetType()
	return self.m_iType;
end

function CFaction:SendMessage( sMessage, iRed, iGreen, iBlue )
	return outputChatBox( sMessage, self.m_pElement, iRed, iGreen, iBlue );
end

function CFaction:GiveMoney( iMoney, sReason )
	return self.m_sBankAccountID and g_pGame:GetBankManager():GiveMoney( self.m_sBankAccountID, iMoney, sReason );
end

function CFaction:TakeMoney( iMoney, sReason )
	return self.m_sBankAccountID and g_pGame:GetBankManager():TakeMoney( self.m_sBankAccountID, iMoney, sReason );
end

function CFaction:GetMoney()
	return (int)(self.m_sBankAccountID and g_pGame:GetBankManager():GetInfo( self.m_sBankAccountID ).amount);
end

function CFaction:Show( pClient )
	local pChar = pClient:GetChar();
	
	if pChar then
		local iAccess, Info;
		
		iAccess	= eFactionRight.NONE;
		
		if self:GetID() ~= 0 then
			if pChar:GetFaction() then
				iAccess		= pChar:GetFactionRights();
			end
			
			if pChar:GetID() == self.m_iOwnerID then
				iAccess		= eFactionRight.OWNER;
			end
			
			if pClient:HaveAccess( "command.faction:edit" ) then
				iAccess		= eFactionRight.ALL;
			end
		
			if iAccess ~= eFactionRight.NONE then
				Info = CClientRPC.Faction_GetData( pClient, sDataName, iFactionID );
			end
		end
		
		pChar:ShowUI( "CUIFaction", (string)(iAccess), Info );
	end
end

function CFaction:ShowMenu( pPlayer, bForce )
	if pPlayer:IsInGame() then
		-- no menu ..
	end
end
