-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

local Licenses;

class "CCharacterLicense"

function CCharacterLicense:CCharacterLicense( ... )
	self.m_Names	= { ... };
end

function CCharacterLicense:GetName( index )
	return self.m_Names[ index ];
end

function CCharacterLicense:GetName2()
	return self.m_Names[ 2 ];
end

function CCharacterLicense:Get( sLicense )
	return Licenses[ sLicense ];
end

Licenses	=
{
	aircraft	= CCharacterLicense( "Лицензия пилота", "лицензию пилота", "лицензии пилота" );
	vehicle		= CCharacterLicense( "Водительское удостоверение", "водительское удостоверение", "водительского удостоверения" );
	weapon		= CCharacterLicense( "Лицензия на оружие", "лицензия на оружие", "лицензии на оружие" );
};

function CChar:InitLicenses( Data )
	self.m_Licenses	= fromJSON( Data ) or {};	
end

function CChar:GiveLicense( sLicenseName )
	local pLicense = Licenses[ sLicenseName ];
	
	if pLicense then
		if not self:GetLicense( sLicenseName ) then
			local Licenses = table.clone( self.m_Licenses );
			
			table.insert( Licenses, sLicenseName );
				
			if g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET licenses = '" + toJSON( Licenses ) + "' WHERE id = " + self:GetID() ) then
				table.insert( self.m_Licenses, sLicenseName );
				
				return pLicense;
			end
			
			Debug( g_pDB:Error(), 1 );
		end
	end
	
	return false;
end

function CChar:TakeLicense( sLicenseName )
	local _, iLicenseIdx = self:GetLicense( sLicenseName );
	
	if iLicenseIdx then
		table.remove( self.m_Licenses, iLicenseIdx );
		
		if not g_pDB:Query( "UPDATE " + DBPREFIX + "characters SET licenses = '" + toJSON( self.m_Licenses ) + "' WHERE id = " + self:GetID() ) then
			Debug( g_pDB:Error(), 1 );
		end
		
		return true;
	end
end

function CChar:GetLicense( sLicenseName )
	local pLicense = Licenses[ sLicenseName ];
	
	if pLicense then
		for i, sLicName in ipairs( self.m_Licenses ) do
			if sLicName == sLicenseName then
				return pLicense, i;
			end
		end
	end
	
	return false;
end