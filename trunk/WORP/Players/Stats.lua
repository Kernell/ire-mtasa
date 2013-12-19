-- Author:      	Kernell
-- Version:     	1.0.3

enum "eStats"
{
	MONEY_GIVE		= 2,
	MONEY_TAKE		= 3,
	MONEY_MAX		= 4,

	TIME_INGAME		= 6,
	TIME_COUNT		= 7,
	LAST_QUIT		= 8,

	KISS_COUNT		= 10,
	KISS_LAST_NAME	= 11,

	RESPECT_POINTS	= 13,

	JAIL_COUNT		= 30,
	JAIL_TIME_COUNT	= 31,

	JOB_COUNT		= 40,
	JOB_CURRENT		= 41,
	JOB_LAST		= 42,
	JOB_SKILL		= 43
};

-- Weapon skills:
WEAPON_PISTOL_SKILL 			= 69
WEAPON_PISTOL_SILENCED_SKILL	= 70
WEAPON_DESERT_EAGLE_SKILL 		= 71
WEAPON_SHOTGUN_SKILL 			= 72
WEAPON_SAWNOFF_SHOTGUN_SKILL	= 73
WEAPON_SPAS12_SHOTGUN_SKILL		= 74
WEAPON_MICRO_UZI_SKILL			= 75
WEAPON_MP5_SKILL				= 76
WEAPON_AK47_SKILL 				= 77
WEAPON_M4_SKILL 				= 78
WEAPON_SNIPERRIFLE_SKILL 		= 79

STAT_NAMES = 
{
	[ MONEY_GIVE ]			= "Денег получено";
	[ MONEY_TAKE ]			= "Денег потрачено";
	[ MONEY_MAX ]			= "Рекордная сумма";
	[ TIME_INGAME ]			= "Времени в игре";
	[ TIME_COUNT ]			= "Всего в игре";
	[ LAST_QUIT ]			= "Последний раз был в игре";
	[ KISS_COUNT ]			= "Поцелуев";
	[ KISS_LAST_NAME ]		= "Последний поцелуй с";
	[ RESPECT_POINTS ]		= "Очков уважения";
	[ JAIL_COUNT ]			= "Заключений в тюрьму";
	[ JAIL_TIME_COUNT ]		= "Всего просидел в тюрьме";
	[ JOB_COUNT ]			= "Устройств на работу";
	[ JOB_CURRENT ]			= "Текущая работа";
	[ JOB_LAST ]			= "Предыдущая работа";
	[ JOB_SKILL ]			= "Навык текущей работы";
};

WEAPON_STAT_NAMES = 
{
	[ WEAPON_PISTOL_SKILL ]				= "Навык владения HK USP",
	[ WEAPON_PISTOL_SILENCED_SKILL ]	= "Навык владения HK USP-Silenced",
	[ WEAPON_DESERT_EAGLE_SKILL ]		= "Навык владения Desert Eagle",
	[ WEAPON_SHOTGUN_SKILL ]			= "Навык владения дробовиком",
	[ WEAPON_SAWNOFF_SHOTGUN_SKILL ]	= "Навык владения обрезом",
	[ WEAPON_SPAS12_SHOTGUN_SKILL ]		= "Навык владения SPAS12",
	[ WEAPON_MICRO_UZI_SKILL ]			= "Навык владения Mac-10",
	[ WEAPON_MP5_SKILL ]				= "Навык владения MP5",
	[ WEAPON_AK47_SKILL ]				= "Навык владения AK47",
	[ WEAPON_M4_SKILL ]					= "Навык владения M4A1",
	[ WEAPON_SNIPERRIFLE_SKILL ]		= "Навык владения Steyr Scout",
};

STAT_TYPES =
{
	[ MONEY_GIVE ]						= "number",
	[ MONEY_TAKE ]						= "number",
	[ MONEY_MAX ]						= "number",
	[ TIME_INGAME ]						= "time",
	[ TIME_COUNT ]						= "time",
	[ LAST_QUIT ]						= "string",
	[ KISS_COUNT ]						= "number",
	[ KISS_LAST_NAME ]					= "string",
	[ RESPECT_POINTS ]					= "number",
	[ JAIL_COUNT ]						= "number",
	[ JAIL_TIME_COUNT ]					= "time",
	[ JOB_COUNT ]						= "number",
	[ JOB_CURRENT ]						= "string",
	[ JOB_LAST ]						= "string",
	[ JOB_SKILL ]						= "number",
	-- [ WEAPON_PISTOL_SKILL ]				= "number",
	-- [ WEAPON_PISTOL_SILENCED_SKILL ]		= "number",
	-- [ WEAPON_DESERT_EAGLE_SKILL ]		= "number",
	-- [ WEAPON_SHOTGUN_SKILL ]				= "number",
	-- [ WEAPON_SAWNOFF_SHOTGUN_SKILL ]		= "number",
	-- [ WEAPON_SPAS12_SHOTGUN_SKILL ]		= "number",
	-- [ WEAPON_MICRO_UZI_SKILL ]			= "number",
	-- [ WEAPON_MP5_SKILL ]					= "number",
	-- [ WEAPON_AK47_SKILL ]				= "number",
	-- [ WEAPON_M4_SKILL ]					= "number",
	-- [ WEAPON_SNIPERRIFLE_SKILL ]			= "number",
};

function getStatName( int )
	return STAT_NAMES[ int ] or tostring( int );
end

function getStatType( int )
	return STAT_TYPES[ int ] or 'nil';
end