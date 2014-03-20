-- Author:      	Kernell
-- Version:     	1.0.1

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