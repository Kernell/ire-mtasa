-- WORP Engine v1.0.0
--
-- Author		Kernell
-- Copyright	© 2011 - 2012
-- License		Proprietary Software
-- Version		1.0

enum "eWeaponType"
{
	WEAPON_TYPE_NONE			= 0;
	WEAPON_TYPE_NIGHTSTICK		= 3;
	WEAPON_TYPE_KNIFECUR		= 4;
	WEAPON_TYPE_BASEBALL		= 5;
	WEAPON_TYPE_KATANA			= 8;
	WEAPON_TYPE_DILDO			= 10;
	WEAPON_TYPE_GRENADE			= 16;
	WEAPON_TYPE_GRENADE_GAS		= 17;
	WEAPON_TYPE_MOLOTOV			= 18;
	WEAPON_TYPE_COLT45			= 23;
	WEAPON_TYPE_EAGLE			= 24;
	WEAPON_TYPE_SHOTGUN			= 25;
	WEAPON_TYPE_SPAS12			= 27;
	WEAPON_TYPE_MP5				= 29;
	WEAPON_TYPE_AK47			= 30;
	WEAPON_TYPE_M4				= 31;
	WEAPON_TYPE_AUG				= 33;
	WEAPON_TYPE_SNIPER			= 34;
	WEAPON_TYPE_RPG7			= 35;
	WEAPON_TYPE_SPRAY			= 41;
	WEAPON_TYPE_CAMERA			= 43;

	WEAPON_TYPE_GRENADE_FLASH	= 100;
};

enum "eWeaponAmmoType"
{
	AMMO_TYPE_NONE			= 0;
	AMMO_TYPE_CLIP			= 1;
	AMMO_TYPE_ROUND			= 2;
};

class: default_weapon_params ( item_base )
{
	m_TClass				= CWeapon;
	
	m_sName					= "Неизвестное оружие";
	m_sName2				= "неизвестное оружие";
	
	m_iSlot					= ITEM_SLOT_WEAPON1;
	m_iType					= ITEM_TYPE_WEAPON;
	
	m_iWeaponType			= WEAPON_TYPE_NONE;
	m_iAmmoType				= AMMO_TYPE_NONE;
	
	m_bSprintAllowed		= true;
	
	m_vecSpawnPos			= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot			= Vector3( 90.0, 0.0, 0.0 );
	
	m_iBone					= NULL;
	m_vecBonePos			= NULL;
	m_vecBoneRot			= NULL;
	
	m_iBone2				= NULL; --12;
	m_vecBone2Pos			= Vector3( 0.0, 0.0, 0.0 );
	m_vecBone2Rot			= Vector3( 0.0, 270, 0.0 );
	
	-- addons
	m_iScope				= 0;	-- 0 - no addon
	m_iSilencer				= 0;	-- 1 - permanent
	m_iGrenadeLauncher		= 0;	-- 2 - attachable
	
	-- animations
	
	m_AnimReload			= { "RIFLE",	"RIFLE_load", 	1500 };
	
	m_sLicenseName			= "weapon";
	
	m_fMisfireProbability 	= 0.0;	-- вероятность осечки при максимальном износе
	m_fConditionShotDec 	= 0.0;	-- увеличение износа при каждом выстреле
};

class: wpn_shotgun ( default_weapon_params )
{
	m_sName					= "Benelli M3 Super 90";
	m_sName2				= "дробовик";
	m_sDescription			= "Ружьё М3 широко распространяется различными военными группировками по всему миру, и ещё распространяется на рынке как оружие самообороны. Для снаряжения используются боеприпасы калибра 12х76.";
	m_iSlot					= ITEM_SLOT_WEAPON1;
	m_iCost					= 3000;
	m_iModel				= 349;
	m_fWeight				= 3.5;
	
	m_FireModes				= { -1 };
	
	m_iWeaponType			= WEAPON_TYPE_SHOTGUN;
	
	m_sAmmoClass			= "ammo_12x76";
	m_iAmmoType				= AMMO_TYPE_ROUND;
	
	m_iBone					= 3;
	m_vecBonePos			= Vector3( 0, -.18, .2 );
	m_vecBoneRot			= Vector3( 5, 85, 5 );
	
	-- sounds
	m_SoundDraw				= { "ak74_draw.wav", 		.5, 20 };
	m_SoundHolster			= { "generic_holster.wav",	.5, 20 };
	m_SoundShoot			= { "m3-1.wav", 			.5, 70 };
	
	m_SoundEmpty			= { "generic_empty.ogg",	.3, 10 };
	m_SoundReload			= { "groza_reload",			.1, 10 };
	m_SoundShootGrenade		= { "gen_grenshoot",		.1, 10 };
	m_SoundReloadGrenade	= { "gen_grenload",			.1, 10 };
	m_SoundSwitch			= { "groza_switch",			.1, 10 };
	
	m_fMisfireProbability 	= 0.2;
	m_fConditionShotDec 	= 0.005;
};

class: wpn_spas12 ( default_weapon_params )
{
	m_sName					= "Franchi SPAS-12";
	m_sName2				= "дробовик";
	m_sDescription			= "Гладкоствольное самозарядное ружьё, разработанное в конце 1970-х в качестве универсального боевого оружия для полиции и штурмовых подразделений. Отличается высокой надёжностью и гибкостью применения. С другой стороны, масса этого оружия довольно велика, устройство сложно, а цена высока. Для снаряжения используются боеприпасы калибра 12х76.";
	m_iSlot					= ITEM_SLOT_WEAPON1;
	m_iCost					= 4000;
	m_iModel				= 351;
	
	m_fWeight				= 4.4;
	
	m_FireModes				= { -1 };
	
	m_iWeaponType			= WEAPON_TYPE_SPAS12;
	
	m_sAmmoClass			= "ammo_12x76";
	m_iAmmoType				= AMMO_TYPE_ROUND;
	
	m_iBone					= 3;
	m_vecBonePos			= Vector3( -.05, -.18, .35 );
	m_vecBoneRot			= Vector3( 5, 85, 5 );
	
	-- sounds
	m_SoundDraw				= { "ak74_draw.wav", 		.5, 20 };
	m_SoundHolster			= { "generic_holster.wav",	.5, 20 };
	m_SoundShoot			= { "m1014_fire.wav", 		.5, 70 };
	
	m_SoundEmpty			= { "generic_empty.ogg",	.3, 10 };
	m_SoundReload			= { "groza_reload",			.1, 10 };
	m_SoundShootGrenade		= { "gen_grenshoot",		.1, 10 };
	m_SoundReloadGrenade	= { "gen_grenload",			.1, 10 };
	m_SoundSwitch			= { "groza_switch",			.1, 10 };
	
	m_fMisfireProbability 	= 0.2;
	m_fConditionShotDec 	= 0.01;
};

class: wpn_mp5 ( default_weapon_params )
{
	m_sName					= "HK MP5 A2";
	m_sName2				= "пистолет-пулемёт";
	m_sDescription			= "Пистолеты-пулеметы Heckler und Koch MP5, общепризнанные лучшими представителями этого класса оружия во второй половине XX века, были разработаны на основе конструкции немецкой штурмовой винтовки G3, так же компании Heckler und Koch. Для снаряжения используются боеприпасы калибра 9х19 мм.";
	m_iSlot					= ITEM_SLOT_WEAPON1;
	m_iCost					= 3000;
	m_iModel				= 353;
	
	m_fWeight				= 2.54;
	
	m_FireModes				= { -1 };
	
	m_iWeaponType			= WEAPON_TYPE_MP5;
	
	m_sAmmoClass			= "ammo_9x19";
	m_iAmmoType				= AMMO_TYPE_CLIP;
	
	m_vecSpawnPos			= Vector3( 0.0, 0.0, -1.02 ); 
	m_vecSpawnRot			= Vector3( 80.0, -40.0, 0.0 );
	
	m_iBone					= 3;
	m_vecBonePos			= Vector3( -.05, -.15, .15 );
	m_vecBoneRot			= Vector3( 5, 85, 5 );
	
	-- sounds
	m_SoundDraw				= { "ak74_draw.wav", 		.5, 20 };
	m_SoundHolster			= { "generic_holster.wav",	.5, 20 };
	m_SoundShoot			= { "mp5k_fire.wav", 		.5, 70 };
	
	m_SoundEmpty			= { "generic_empty.ogg",	.3, 10 };
	m_SoundReload			= { "groza_reload",			.1, 10 };
	m_SoundShootGrenade		= { "gen_grenshoot",		.1, 10 };
	m_SoundReloadGrenade	= { "gen_grenload",			.1, 10 };
	m_SoundSwitch			= { "groza_switch",			.1, 10 };
	
	m_fMisfireProbability 	= 0.2;
	m_fConditionShotDec 	= 0.005;
};

class: wpn_ak107m ( default_weapon_params )
{
	m_sName					= "AK-107M";
	m_sName2				= "автомат";
	m_sDescription			= "Представляет собой простое и надёжное оружие, хотя дешевизна производства несколько отрицательно сказалась на приёмистости и точности боя. Для снаряжения используются боеприпасы калибра 5.45х39 мм.";
	m_iSlot					= ITEM_SLOT_WEAPON1;
	m_iCost					= 5000;
	m_iModel				= 355;
	
	m_fWeight				= 3.3;
	
	m_FireModes				= { -1, 1 };
	
	m_iWeaponType			= WEAPON_TYPE_AK47;
	
	m_sAmmoClass			= "ammo_5_45x39";
	m_iAmmoType				= AMMO_TYPE_CLIP;
	
	m_iBone					= 3;
	m_vecBonePos			= Vector3( 0, -.15, .2 );
	m_vecBoneRot			= Vector3( 0, 85, 5 );
	
	-- sounds
	m_SoundDraw				= { "ak74_draw.wav", 		.5, 20 };
	m_SoundHolster			= { "generic_holster.wav",	.5, 20 };
	m_SoundShoot			= { "ak47_fire.wav", 		.5, 70 };
	
	m_SoundEmpty			= { "generic_empty.ogg",	.3, 10 };
	m_SoundReload			= { "groza_reload",			.1, 10 };
	m_SoundShootGrenade		= { "gen_grenshoot",		.1, 10 };
	m_SoundReloadGrenade	= { "gen_grenload",			.1, 10 };
	m_SoundSwitch			= { "groza_switch",			.1, 10 };
	
	m_fMisfireProbability 	= 0.2;
	m_fConditionShotDec 	= 0.001;
};

class: wpn_m4a1 ( default_weapon_params )
{
	m_sName					= "Colt M4A1";
	m_sName2				= "автомат";
	m_sDescription			= "Новая ступень в развитии семейства знаменитой М-16. Благодаря исключительно ровному спуску, высокой эргономике и небольшому весу данное оружие отличается высокой точностью боя, хотя высокая чувствительность к загрязнению делает его малопригодным для использования в сложных условиях. Для снаряжения используются боеприпасы калибра 5.56х45 мм.";
	m_iSlot					= ITEM_SLOT_WEAPON1;
	m_iCost					= 5000;
	m_iModel				= 356;
	
	m_fWeight				= 2.91;
	
	m_FireModes				= { -1, 1, 3 };
	
	m_iWeaponType			= WEAPON_TYPE_M4;
	
	m_sAmmoClass			= "ammo_5_56x45";
	m_iAmmoType				= AMMO_TYPE_CLIP;
	
	m_iBone					= 3;
	m_vecBonePos			= Vector3( 0, -.15, .2 );
	m_vecBoneRot			= Vector3( 0, 85, 5 );
	
	-- sounds
	m_SoundDraw				= { "ak74_draw.wav", 		.5, 20 };
	m_SoundHolster			= { "generic_holster.wav",	.5, 20 };
	m_SoundShoot			= { "m4a1-un.wav", 			.5, 70 };
	
	m_SoundEmpty			= { "generic_empty.ogg",	.3, 10 };
	m_SoundReload			= { "groza_reload",			.1, 10 };
	m_SoundShootGrenade		= { "gen_grenshoot",		.1, 10 };
	m_SoundReloadGrenade	= { "gen_grenload",			.1, 10 };
	m_SoundSwitch			= { "groza_switch",			.1, 10 };
	
	m_fMisfireProbability 	= 0.3;
	m_fConditionShotDec 	= 0.05;
};

class: wpn_aug ( default_weapon_params )
{
	m_sName					= "Steyr AUG A1";
	m_sName2				= "автомат";
	m_sDescription			= "Автоматическое оружие, работающее по принципу отвода пороховых газов, с магазинным питанием, воздушным охлаждением сменного ствола, скомпонованное по схеме буллпап. Состоит в стандартной комплектации из шести легко заменяемых блоков. Для снаряжения используются боеприпасы калибра 5.56х45 мм.";
	m_iSlot					= ITEM_SLOT_WEAPON1;
	m_iCost					= 8000;
	m_iModel				= 357;
	
	m_fWeight				= 3.6;
	
	m_FireModes				= { -1 };
	
	m_iWeaponType			= WEAPON_TYPE_AUG;
	
	m_sAmmoClass			= "ammo_5_56x45";
	m_iAmmoType				= AMMO_TYPE_CLIP;
	
	m_iBone					= 3;
	m_vecBonePos			= Vector3( 0, -.17, .05 );
	m_vecBoneRot			= Vector3( 0, 85, 15 );
	
	-- sounds
	m_SoundDraw				= { "ak74_draw.wav", 		.5, 20 };
	m_SoundHolster			= { "generic_holster.wav",	.5, 20 };
	m_SoundShoot			= { "aug_fire.wav", 		.5, 70 };
	
	m_SoundEmpty			= { "generic_empty.ogg",	.3, 10 };
	m_SoundReload			= { "groza_reload",			.1, 10 };
	m_SoundShootGrenade		= { "gen_grenshoot",		.1, 10 };
	m_SoundReloadGrenade	= { "gen_grenload",			.1, 10 };
	m_SoundSwitch			= { "groza_switch",			.1, 10 };
	
	m_fMisfireProbability 	= 0.3;
	m_fConditionShotDec 	= 0.001;
};

class: wpn_scout ( default_weapon_params )
{
	m_sName					= "Steyr Scout";
	m_sName2				= "винтовку";
	m_sDescription			= "Австрийская снайперская винтовка производства фирмы Steyr. Изначально предназначалась для охоты. Одна из ключевых особенностей — оптический прицел, вынесеный далеко вперед и расположенный низко над стволом. Для снаряжения используются боеприпасы 7,62 7H14.";
	m_iSlot					= ITEM_SLOT_WEAPON1;
	m_iCost					= 11000;
	m_iModel				= 358;
	
	m_fWeight				= 3.3;
	
	m_FireModes				= { 1 };
	
	m_iWeaponType			= WEAPON_TYPE_SNIPER;
	
	m_sAmmoClass			= "ammo_7_62x54_7h1";
	m_iAmmoType				= AMMO_TYPE_CLIP;
	
	m_iBone					= 3;
	m_vecBonePos			= Vector3( 0, -.17, .2 );
	m_vecBoneRot			= Vector3( 10, 85, 5 );
	
	-- sounds
	m_SoundDraw				= { "ak74_draw.wav", 		.5, 20 };
	m_SoundHolster			= { "generic_holster.wav",	.5, 20 };
	m_SoundShoot			= { "dagnv_fire.wav", 		.5, 70 };
	
	m_SoundEmpty			= { "generic_empty.ogg",	.3, 10 };
	m_SoundReload			= { "groza_reload",			.1, 10 };
	m_SoundShootGrenade		= { "gen_grenshoot",		.1, 10 };
	m_SoundReloadGrenade	= { "gen_grenload",			.1, 10 };
	m_SoundSwitch			= { "groza_switch",			.1, 10 };
	
	m_fMisfireProbability 	= 0.3;
	m_fConditionShotDec 	= 0.001;
};

class: wpn_rpg ( default_weapon_params )
{
	m_sName					= "РПГ-7В";
	m_sName2				= "гранатомёт";
	m_iSlot					= ITEM_SLOT_WEAPON1;
	m_iCost					= 50000;
	m_iModel				= 359;
	
	m_fWeight				= 6.3;
	
	m_FireModes				= { 1 };
	
	m_iWeaponType			= WEAPON_TYPE_RPG7;
	
	m_sAmmoClass			= "ammo_og_7b";
	m_iAmmoType				= AMMO_TYPE_ROUND;
	
	m_iBone					= 3;
	m_vecBonePos			= Vector3( 0, -.17, -.1  );
	m_vecBoneRot			= Vector3( 10, 85, 5 );
};

class: wpn_usp45 ( default_weapon_params )
{
	m_sName					= "HK USP .45 Tactical";
	m_sName2				= "пистолет";
	m_sDescription			= "Пистолет, разработанный немецкой компанией Heckler & Koch. Впервые представлен в 1993 году. Предназначен для вооружения полиции и армии";
	m_iSlot					= ITEM_SLOT_WEAPON2;
	m_iCost					= 1000;
	m_iModel				= 347;
	
	m_fWeight				= 0.789;
	
	m_FireModes				= { 1 };
	
	m_iWeaponType			= WEAPON_TYPE_COLT45;
	
	m_sAmmoClass			= "ammo_11_43x23";
	m_iAmmoType				= AMMO_TYPE_CLIP;
	
	-- sounds
	m_SoundDraw				= { "ak74_draw.wav", 		.5, 20 };
	m_SoundHolster			= { "generic_holster.wav",	.5, 20 };
	m_SoundShoot			= { "usp_fire.wav", 		.5, 70 };
	
	m_SoundEmpty			= { "generic_empty.ogg",	.3, 10 };
	m_SoundReload			= { "groza_reload",			.1, 10 };
	m_SoundShootGrenade		= { "gen_grenshoot",		.1, 10 };
	m_SoundReloadGrenade	= { "gen_grenload",			.1, 10 };
	m_SoundSwitch			= { "groza_switch",			.1, 10 };
	
	m_fMisfireProbability 	= 0.5;
	m_fConditionShotDec 	= 0.003;
};

class: wpn_desert_eagle ( default_weapon_params )
{
	m_sName					= "Desert Eagle";
	m_sName2				= "пистолет";
	m_sDescription			= "Был разработан в 1983 году в США компанией Magnum Research с последующей доработкой израильской компанией Israel Military Industries. Очень чувствителен к уходу и никогда не испытывался на работу в сложных условиях, поскольку разрабатывался как специализированное оружие для охоты, а не для служебного использования";
	m_iSlot					= ITEM_SLOT_WEAPON2;
	m_iCost					= 2100;
	m_iModel				= 348;
	
	m_fWeight				= 2.0;
	
	m_FireModes				= { 1 };
	
	m_iWeaponType			= WEAPON_TYPE_EAGLE;
	
	m_sAmmoClass			= "ammo_11_43x23";
	m_iAmmoType				= AMMO_TYPE_CLIP;
	
	-- sounds
	m_SoundDraw				= { "ak74_draw.wav", 		.5, 20 };
	m_SoundHolster			= { "generic_holster.wav",	.5, 20 };
	m_SoundShoot			= { "deagle_fire.wav", 		.5, 70 };
	
	m_SoundEmpty			= { "generic_empty.ogg",	.3, 10 };
	m_SoundReload			= { "groza_reload",			.1, 10 };
	m_SoundShootGrenade		= { "gen_grenshoot",		.1, 10 };
	m_SoundReloadGrenade	= { "gen_grenload",			.1, 10 };
	m_SoundSwitch			= { "groza_switch",			.1, 10 };
	
	m_fMisfireProbability 	= 0.3;
	m_fConditionShotDec 	= 0.005;
};

class: wpn_nightstick ( default_weapon_params )
{
	m_sName			= "Полицейская дубинка";
	m_sName2		= "дубинку";
	m_iSlot			= ITEM_SLOT_WEAPON3;
	m_iCost			= 100;
	m_iModel		= 334;
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_NIGHTSTICK;
	
	m_sLicenseName	= NULL;
};

class: wpn_knife ( default_weapon_params )
{
	m_sName			= "Нож";
	m_sName2		= "нож";
	m_iSlot			= ITEM_SLOT_WEAPON3;
	m_iCost			= 200;
	m_iModel		= 335;
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_KNIFECUR;
	
	m_sLicenseName	= NULL;
};

class: wpn_baseball_bat ( default_weapon_params )
{
	m_sName			= "Бейсбольная бита";
	m_sName2		= "биту";
	m_iSlot			= ITEM_SLOT_WEAPON3;
	m_iCost			= 100;
	m_iModel		= 336;
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_BASEBALL;
	
	m_sLicenseName	= NULL;
};

class: wpn_shovel ( default_weapon_params ) -- TODO: Deprecated
{
	m_sName			= "Лопата";
	m_sName2		= "лопату";
	m_iSlot			= ITEM_SLOT_WEAPON3;
	m_iCost			= 100;
	m_iModel		= 337;
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_BASEBALL;
	
	m_sLicenseName	= NULL;
};

class: wpn_katana ( default_weapon_params )
{
	m_sName			= "Катана";
	m_sName2		= "катану";
	m_iSlot			= ITEM_SLOT_WEAPON3;
	m_iCost			= 100;
	m_iModel		= 339;
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_KATANA;
	
	m_sLicenseName	= NULL;
};

class: wpn_long_purple_dildo ( default_weapon_params )
{
	m_sName			= "Большой фалоиметатор";
	m_sName2		= "фалоиметатор";
	m_iSlot			= ITEM_SLOT_WEAPON3;
	m_iCost			= 100;
	m_iModel		= 321;
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_DILDO;
	
	m_sLicenseName	= NULL;
};

class: wpn_short_tan_dildo ( default_weapon_params )
{
	m_sName			= "Маленький железный фалоиметатор";
	m_sName2		= "фалоиметатор";
	m_iSlot			= ITEM_SLOT_WEAPON3;
	m_iCost			= 100;
	m_iModel		= 322;
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_DILDO;
	
	m_sLicenseName	= NULL;
};

class: wpn_vibrator ( default_weapon_params )
{
	m_sName			= "Вибратор";
	m_sName2		= "вибратор";
	m_iSlot			= ITEM_SLOT_WEAPON3;
	m_iCost			= 100;
	m_iModel		= 323;
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_DILDO;
	
	m_sLicenseName	= NULL;
};

class: wpn_flowers ( default_weapon_params ) -- TODO: Deprecated
{
	m_sName			= "Цветы";
	m_sName2		= "цветы";
	m_iSlot			= ITEM_SLOT_WEAPON3;
	m_iCost			= 100;
	m_iModel		= 325;
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_DILDO;
	
	m_sLicenseName	= NULL;
};

class: wpn_camera ( default_weapon_params )
{
	m_sName			= "Фотоаппарат";
	m_sName2		= "фотоаппарат";
	m_iSlot			= ITEM_SLOT_WEAPON3;
	m_iCost			= 300;
	m_iModel		= 367;
	
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_CAMERA;
	
	m_sLicenseName	= NULL;
};

class: wpn_spraycan ( default_weapon_params )
{
	m_sName			= "Балончик";
	m_sName2		= "балончик";
	m_iSlot			= ITEM_SLOT_WEAPON3;
	m_iCost			= 300;
	m_iModel		= 365;
	
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_SPRAY;
	
	m_sLicenseName	= NULL;
};

class: wpn_grenade ( default_weapon_params )
{
	m_sName			= "Граната F1";
	m_sName2		= "гранату";
	m_iSlot			= ITEM_SLOT_WEAPON4;
	m_iCost			= 1000;
	m_iModel		= 342;
	
	m_fWeight		= 0.57;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_GRENADE;
	
	m_sLicenseName	= NULL;
};

class: wpn_grenade_gas ( default_weapon_params )
{
	m_sName			= "Газовая граната";
	m_sName2		= "гранату";
	m_iSlot			= ITEM_SLOT_WEAPON4;
	m_iCost			= 1000;
	m_iModel		= 343;
	
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_GRENADE_GAS;
	
	m_sLicenseName	= NULL;
};

class: wpn_grenade_flash ( default_weapon_params )
{
	m_sName			= "Светошумовая граната M84";
	m_sName2		= "гранату";
	m_iSlot			= ITEM_SLOT_WEAPON4;
	m_iCost			= 1000;
	m_iModel		= 343;
	
	m_fWeight		= 0.236;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_GRENADE_FLASH;
	
	m_sLicenseName	= NULL;
};

class: wpn_molotov ( default_weapon_params )
{
	m_sName			= "Коктейль Молотова";
	m_sName2		= "коктейль Молотова";
	m_iSlot			= ITEM_SLOT_WEAPON4;
	m_iCost			= 900;
	m_iModel		= 344;
	
	m_fWeight		= 0.1;
	
	m_iIconWidth	= 1;
	m_iIconHeight	= 1;
	m_iIconX		= 11;
	m_iIconY		= 12;
	
	m_iWeaponType	= WEAPON_TYPE_MOLOTOV;
	
	m_sLicenseName	= NULL;
};
