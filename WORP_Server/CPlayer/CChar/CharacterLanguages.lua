-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local languages =
{
	["cn"]	= { "Китайский", 		"Китайского",		male = "Китаец",		female = "Китаянка" };
	["de"]	= { "Немецкий", 		"Немецкого", 		male = "Немец",			female = "Немка" };
	["en"]	= { "Английский", 		"Английского",		male = "Американец",	female = "Американка" };
	["es"]	= { "Испанский", 		"Испанского", 		male = "Испанец",		female = "Испанка" };
	["fr"]	= { "Французский", 		"Французского", 	male = "Француз",		female = "Француженка" };
	["it"]	= { "Итальянский", 		"Итальянского", 	male = "Итальянец",		female = "Итальянка" };
	["jp"]	= { "Японский", 		"Японского", 		male = "Японец",		female = "Японка" };
	["kr"]	= { "Корейский", 		"Корейского", 		male = "Кореец",		female = "Кореянка" };
	["nl"]	= { "Голландский", 		"Голландского", 	male = "Голландец",		female = "Голландка" };
	["pl"]	= { "Польский", 		"Польского", 		male = "Поляк",			female = "Полька" };
	["ru"]	= { "Русский", 			"Русского", 		male = "Русский",		female = "Русская" };
	["se"]	= { "Шведский", 		"Шведского", 		male = "Швед",			female = "Шведка" };
	["uk"]	= { "Украинский", 		"Украинского", 		male = "Украинец",		female = "Украинка" };
};

function getLanguageName( tag, id )
	return languages[ tag ] and languages[ tag ][ id or 1 ] or "некорректный язык";
end

function isValidLanguage( tag )
	return getLanguageName( tag ) ~= "некорректный язык";
end

function getLanguages()
	return languages;
end

function CChar:InitLanguages( aLanguages )
	self.m_aLanguages = fromJSON( aLanguages );
	
	if not self.m_aLanguages or sizeof( self.m_aLanguages ) == 0 then
		self.m_aLanguages = { current = 'en'; en = 1000; };
	end
	
	if not self.m_aLanguages.current then
		for key in pairs( self.m_aLanguages ) do
			if key ~= 'current' then
				self.m_aLanguages.current = key;
				break;
			end
		end
	end
end

function CChar:GetLanguage( key )
	return isValidLanguage( key ) and
	{
		GetID		= function()
			return key;
		end;
		
		GetName		= function()
			return self.m_aLanguages[ key ] and getLanguageName( key );
		end;
		
		GetSkill	= function()
			return self.m_aLanguages[ key ] or false;
		end;
		
		SetSkill	= function( value )
			if self.m_aLanguages[ key ] then
				self.m_aLanguages[ key ] = math.max( math.min( value, 1000 ), 0 );
				
				self:SaveLanguages();
				
				return true;
			end
			
			return false;
		end;
		
		IncreaseSkill = function()
			if self.m_aLanguages[ key ] then
				self.m_aLanguages[ key ] = self.m_aLanguages[ key ] + 1;
				
				self.m_aLanguages[ key ] = math.max( math.min( self.m_aLanguages[ key ], 1000 ), 0 );
				
				self:SaveLanguages();
				
				return true;
			end
			
			return false;
		end;
		
		IsCurrent	= function()
			return key == self.m_aLanguages.current;
		end;
		
		GetNation	= function()
			return { male = getLanguageName( key, 'male' ); female = getLanguageName( key, 'female' ); };
		end;
	};
end

function CChar:GetLanguages()
	local aLanguages = {};
	
	for key, value in pairs( self.m_aLanguages ) do
		table.insert( aLanguages, self:GetLanguage( key ) );
	end
	
	return aLanguages;
end

function CChar:GetCurrentLanguage()
	return self:GetLanguage( self.m_aLanguages.current );
end

function CChar:SetCurrentLanguage( lang )
	if isValidLanguage( lang ) then
		if self.m_aLanguages[ lang ] then
			self.m_aLanguages.current = lang;
			
			self:SaveLanguages();
			
			return true;
		end
		
		return false, 1;
	end
	
	return false, 0;
end

function CChar:SaveLanguages()
	return g_pDB:Query( ( "UPDATE " + DBPREFIX + "characters SET languages = '%s' WHERE id = " + self:GetID() ):format( toJSON( self.m_aLanguages ) ) );
end

function CChar:GetNation()
	return getLanguageName( self.m_sNation, self:GetSkin().GetGender() );
end