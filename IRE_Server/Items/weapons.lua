-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

item: default_weapon_params ( item_base )
{
	class					= Weapon;
	
	name					= "Неизвестное оружие";
	name2					= "неизвестное оружие";
	
	slot					= ITEM_SLOT_WEAPON1;
	type					= ITEM_TYPE_WEAPON;
	
	weapon_type				= WEAPON_TYPE_NONE;
	ammo_type				= AMMO_TYPE_NONE;
	
	fire_modes				= { -1, 1 };
	fire_rate				= 0;
	
	sprint_allowed			= true;
	
	spawn_position			= { 0.0, 0.0, -0.98 };
	spawn_rotation			= { 90.0, 0.0, 0.0 };
	
	bone					= 3;
	bone_position			= { -0.05, -0.15, 0.15 };
	bone_rotation			= { 5, 85, 5 };
	
	bone2					= NULL; --12;
	bone2_position			= { 0.0, 0.0, 0.0 };
	bone2_rotation			= { 0.0, 270, 0.0 };
	
	-- addons
	addon_slot_1			= false;
	addon_slot_2			= false;
	addon_slot_3			= false;
	addon_slot_4			= false;
	addon_slot_5			= false;
	addon_silencer			= false;
	
--	addon_scope				= 0;	-- 0 - no addon
--	addon_silencer			= 0;	-- 1 - permanent
--	addon_grenade_launcher	= 0;	-- 2 - attachable

	-- animations
	anim_reload				= { "RIFLE", "RIFLE_load", 1500 };
	
	-- sounds
	sound_draw				= { "ak74_draw.wav", 		0.5, 20 };
	sound_holster			= { "generic_holster.wav",	0.5, 20 };
	sound_shoot				= { "mp5k_fire.wav", 		0.5, 70 };
	
	sound_empty				= { "generic_empty.ogg",	0.3, 10 };
	sound_reload			= { "groza_reload",			0.1, 10 };
	sound_shoot_grenade		= { "gen_grenshoot",		0.1, 10 };
	sound_reload_grenade	= { "gen_grenload",			0.1, 10 };
	sound_switch			= { "groza_switch",			0.1, 10 };
	
	misfire_probability 	= 0.0;	-- вероятность осечки при максимальном износе
	condition_shot_dec 		= 0.0;	-- увеличение износа при каждом выстреле
}

item: wpn_acr ( default_weapon_params )
{
	name					= "Bushmaster ACR";
	name2					= "винтовку";
	description				= "В этой многофункциональной винтовке использовано множество самых современных оружейных технологий, и она представляет собой очень легкую платформу для множества функций. Использование современного, снижающего отдачу патрона “Грендель“, приспособленность к тяжелым погодным условиям и возможность применения стандартных магазинов STANAG позволяют с успехом использовать эту винтовку как в военных, так и в полицейских операциях.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_ACR;
	
	fire_rate				= 850;
	
	weight					= 3.18;
	
	weapon_type				= WEAPON_TYPE_M4;
	
	ammo_class				= "ammo_5_56x45";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_ak74m ( default_weapon_params )
{
	name					= "АК-74М";
	name2					= "винтовку";
	description				= "АК-74М - это последняя версия AK-47. Принятая на вооружение российской армией в качестве стандартного автомата, версия M включает складывающийся набок полимерный приклад и крепление для прицела с левой стороны оружия. Недавние разработки позволяют снабжать автоматы серии AK многими принадлежностями. Надежное и прочное оружие средней дальности.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_AK74M;
	
	fire_rate				= 650;
	
	weight					= 3.3;
	
	weapon_type				= WEAPON_TYPE_M4;
	
	ammo_class				= "ammo_5_45x39";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_ak12 ( default_weapon_params )
{
	name					= "АК-12";
	name2					= "винтовку";
	description				= "Новая автоматический винтовка АК-12, представляет собой перспективную разработку концерна «Калашников». Главной особенностью АК-12 является повышенная эргономика оружия в сравнении с его предшественниками. Проведенные работы повысили кучность стрельбы, надежность работы и служебный ресурс.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_AK12;
	
	fire_rate				= 650;
	
	weight					= 3.2;
	
	weapon_type				= WEAPON_TYPE_M4;
	
	ammo_class				= "ammo_5_45x39";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_aug ( default_weapon_params )
{
	name					= "AUG A3";
	name2					= "винтовку";
	description				= "Эта система с компоновкой «булл-пап» под патрон 5.56 была разработана в 70-х годах, отличается высокой модульностью и возможностью использования как правшами, так и левшами. С момента постановки на вооружение в австрийской армии в качестве стандартной винтовки, она стала отлично продаваться на экспорт, а покупатели не устают хвалить ее за неприхотливость к условиям и легкость в обращении.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_AUG;
	
	fire_rate				= 700;
	
	weight					= 3.9;
	
	weapon_type				= WEAPON_TYPE_M4;
	
	ammo_class				= "ammo_5_56x45";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_desert_eagle ( default_weapon_params )
{
	name					= "Desert Eagle";
	name2					= "пистолет";
	description				= "Самозарядный пистолет большого калибра. Позиционируется как охотничье оружие и оружие для самозащиты от диких зверей и преступных посягательств.";
	slot					= ITEM_SLOT_WEAPON2;
	cost					= 5000;
	model					= WEAPON_DESERT_EAGLE;
	
	fire_modes				= { 1 };
	fire_rate				= 500;
	
	weight					= 1.7;
	
	weapon_type				= WEAPON_TYPE_EAGLE;
	
	ammo_class				= "ammo_11_43x23";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_famas_f1 ( default_weapon_params )
{
	name					= "FAMAS F1";
	name2					= "винтовку";
	description				= "Штурмовая винтовка разработки оружейного предприятия MAS в Сент-Этьене) — французский автомат калибра 5,56 мм, имеющий компоновку «булл-пап». Неофициальное название — «клерон» (фр. «горн»)";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_FAMAS_F1;
	
	fire_rate				= 1000;
	
	weight					= 3.61;
	
	weapon_type				= WEAPON_TYPE_M4;
	
	ammo_class				= "ammo_5_56x45";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_scar_h ( default_weapon_params )
{
	name					= "FN SCAR-H";
	name2					= "карабин";
	description				= "Данная модель винтовки имеет конфигурацию SCAR-H CQB (SCAR для тяжелого ближнего боя), с укороченным стволом и магазином для мощных патронов НАТО калибра 7,62 мм. Благодаря этому дальность стрельбы модели SCAR-H повышается по сравнению с обычными карабинами - правда, за счет весьма серьезной отдачи.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_SCAR_H;
	
	fire_rate				= 700;
	
	weight					= 3.512;
	
	weapon_type				= WEAPON_TYPE_M4;
	
	ammo_class				= "ammo_7_62x51";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_scar_l ( default_weapon_params )
{
	name					= "FN SCAR-L";
	name2					= "винтовку";
	description				= "Модульное построение системы SCAR позволяет создавать множество конфигураций. В “Mk. 16 SCAR-L“ представлен 14-дюймовый ствол и магазин на 30 патронов. По сравнению с ее более тяжелым сородичем, карабином на 20 патронов Mk. 17, у SCAR-L есть серьезное преимущество при стрельбе на больших дистанциях из-за удлиненного ствола и сниженной отдачи.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_SCAR_L;
	
	fire_rate				= 620;
	
	weight					= 3.3;
	
	weapon_type				= WEAPON_TYPE_M4;
	
	ammo_class				= "ammo_5_56x45";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_spas12 ( default_weapon_params )
{
	name					= "Franchi SPAS-12";
	name2					= "дробовик";
	description				= "Итальянский дробовик практически стал иконой с момента своего появления на рынке в 80-х годах. Он стал широко использоваться по всему миру, благодаря совместимости с огромным количеством различных боеприпасов. Уникальный дизайн магазина делает использование разных патронов еще проще, позволяя SPAS-12 до сих пор оставаться на хорошем счету в полиции и армии многих стран.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_SPAS12;
	
	fire_modes				= { 1 };
	fire_rate				= 500;
	
	weight					= 4.4;
	
	weapon_type				= WEAPON_TYPE_SPAS12;
	
	ammo_class				= "ammo_12x76";
	ammo_type				= AMMO_TYPE_ROUND;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_glock17 ( default_weapon_params )
{
	name					= "Glock 17";
	name2					= "пистолет";
	description				= "Этот полноразмерный боевой пистолет отличается полимерной рамкой и антикоррозионным покрытием, что делает его очень надежным. Glock 17 невероятно популярен у служб охраны правопорядка и военных частей во всем мире. Эта версия Glock 17 оснащена встроенным лазерным целеуказателем, повышающим точность неприцельного огня.";
	slot					= ITEM_SLOT_WEAPON2;
	cost					= 5000;
	model					= WEAPON_GLOCK17;
	
	fire_modes				= { 1 };
	fire_rate				= 600;
	
	weight					= 0.625;
	
	weapon_type				= WEAPON_TYPE_COLT45;
	
	ammo_class				= "ammo_9x19";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_glock18 ( default_weapon_params )
{
	name					= "Glock 18";
	name2					= "пистолет";
	description				= "Пистолет Glock 18 был разработан для австрийских антитеррористических отрядов «ЭКО Кобра». Классифицируемый как автоматический пистолет, Glock 18 оснащен рядом модификаций, позволяющих лучше контролировать его высокоскоростную стрельбу. В автоматическом режиме из Glock 18 невероятно трудно стрелять эффективно, если речь не идет о предельно малой дальности.";
	slot					= ITEM_SLOT_WEAPON2;
	cost					= 5000;
	model					= WEAPON_GLOCK18;
	
	fire_modes				= { -1, 1 };
	fire_rate				= 900;
	
	weight					= 0.625;
	
	weapon_type				= WEAPON_TYPE_COLT45;
	
	ammo_class				= "ammo_9x19";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_hk416 ( default_weapon_params )
{
	name					= "HK416";
	name2					= "винтовку";
	description				= "Винтовка HK416 была разработана знаменитым немецким производителем оружия как более надежная версия классической M16. В сущности оружие является комбинацией винтовок M16 и G36. M416 - надежное и точное оружие со средними отдачей и скорострельностью, которые делают его эффективным и универсальным.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_HK416;
	
	fire_rate				= 750;
	
	weight					= 3.02;
	
	weapon_type				= WEAPON_TYPE_M4;
	
	ammo_class				= "ammo_5_56x45";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_hk417 ( default_weapon_params )
{
	name					= "HK417";
	name2					= "винтовку";
	description				= "Старший брат HK416 получил 16-дюймовый ствол, а также увеличенную ствольную коробку для работы с патроном 7.62. Высокая точность и останавливающее действие этой винтовки сделали ее идеальным выбором для снайпера. Состоит на вооружении во многих армиях мира.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_HK417;
	
	fire_rate				= 600;
	
	weight					= 4.15;
	
	weapon_type				= WEAPON_TYPE_M4;
	
	ammo_class				= "ammo_7_62x51";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_g36c ( default_weapon_params )
{
	name					= "HK G36C";
	name2					= "карабин";
	description				= "G36C - карабин со значительными возможностями использования индивидуальных компонентов, оснащенный рядом креплений и набором резервных механических прицелов вместо встроенной оптики и рукоятки для переноски у G36. Идеален для боев на ближней дистанции. Один из режимов стрельбы G36C - очередями с отсечкой по два патрона.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_G36C;
	
	fire_modes				= { -1, 2, 1 };
	fire_rate				= 750;
	
	weight					= 2.82;
	
	weapon_type				= WEAPON_TYPE_M4;
	
	ammo_class				= "ammo_5_56x45";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_jng90 ( default_weapon_params )
{
	name					= "JNG-90";
	name2					= "винтовку";
	description				= "JNG-90 легко узнать по ее огромному дульному тормозу. Состоит на вооружении турецкой армии как стандартная снайперская винтовка. Обладает встроенной системой крепления и обширными возможностями по модификации. Винтовка характеризуется высоким останавливающим действием и отличной точностью даже на предельной дальности.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_JNG90;
	
	fire_modes				= { 1 };
	fire_rate				= -1;
	
	weight					= 6.4;
	
	weapon_type				= WEAPON_TYPE_SNIPER;
	
	ammo_class				= "ammo_7_62x51";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_m4a1 ( default_weapon_params )
{
	name					= "M4A1";
	name2					= "карабин";
	description				= "Являясь укороченной версией M16, карабин M4A1 был спроектирован для Объединенного командования специальных операций вооруженных сил США (SOCOM) в годы войны во Вьетнаме. Версия M4A1 может вести полностью автоматический огонь и имеет крепления, позволяющие пользователю установить большое количество принадлежностей.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_M4A1;
	
	fire_modes				= { -1 };
	fire_rate				= 800;
	
	weight					= 2.68;
	
	weapon_type				= WEAPON_TYPE_M4;
	
	ammo_class				= "ammo_5_56x45";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_m9 ( default_weapon_params )
{
	name					= "Beretta M9";
	name2					= "пистолет";
	description				= "Разработанный в Италии, М9 стал победителем в серии испытаний (зачастую довольно спорных) и лишь чудом опередил конкурентов, сумев обеспечить высокое качество работы при низкой цене.";
	slot					= ITEM_SLOT_WEAPON2;
	cost					= 5000;
	model					= WEAPON_M9;
	
	fire_modes				= { 1 };
	fire_rate				= 500;
	
	weight					= 0.952;
	
	weapon_type				= WEAPON_TYPE_COLT45;
	
	ammo_class				= "ammo_9x19";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_m1911 ( default_weapon_params )
{
	name					= "M1911";
	name2					= "пистолет";
	description				= "M1911 - это один из самых популярных пистолетов в мире. Состоял на вооружении ВС США до 1985 года. Существует множество клонов и копий M1911, а его внутренний механизм применяется почти во всех современных пистолетах. Модернизированные и усовершенствованные версии M1911 по-прежнему используются войсками специального назначения Корпуса морской пехоты США.";
	slot					= ITEM_SLOT_WEAPON2;
	cost					= 5000;
	model					= WEAPON_M1911;
	
	fire_modes				= { 1 };
	fire_rate				= 500;
	
	weight					= 1.12;
	
	weapon_type				= WEAPON_TYPE_COLT45;
	
	ammo_class				= "ammo_11_43x23";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_mp443 ( default_weapon_params )
{
	name					= "MP-443";
	name2					= "пистолет";
	description				= "МР-443 «Грач» стреляет бронебойными 9-мм патронами российского образца. Пистолет представляет собой конструкцию, сочетающую полимеры и сталь, и принят на вооружение избранными подразделениями специального назначения российских вооруженных сил.";
	slot					= ITEM_SLOT_WEAPON2;
	cost					= 5000;
	model					= WEAPON_MP443;
	
	fire_modes				= { 1 };
	fire_rate				= 500;
	
	weight					= 0.95;
	
	weapon_type				= WEAPON_TYPE_MP5;
	
	ammo_class				= "ammo_9x19";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_mp5 ( default_weapon_params )
{
	name					= "HK MP5";
	name2					= "пистолет-пулемёт";
	description				= "Тактический автоматический пистолет создан на базе одного из самых успешных в мире пистолетов-пулеметов. С полностью убранным прикладом и укороченной ствольной коробкой, это ультра-компактное оружие самообороны может вести огонь с очень высокой скорострельностью и обладает отличным останавливающим действием в ближнем бою.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_MP5;
	
	fire_modes				= { -1, 1 };
	fire_rate				= 900;
	
	weight					= 2.54;
	
	weapon_type				= WEAPON_TYPE_MP5;
	
	ammo_class				= "ammo_9x19";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_mp7 ( default_weapon_params )
{
	name					= "HK MP7";
	name2					= "пистолет-пулемёт";
	description				= "MP7 состоит на вооружении у немецкого Бундесвера и Вооруженных сил Норвегии. MP7A1 имеет улучшенный приклад, дополнительные защитные приспособления и дополнительные крепления для установки фонариков, лазеров и прицелов. Оружие также может быть оснащено глушителем и пламегасителем, что позволяет ему превосходно проявлять себя в ближнем бою.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_MP7;
	
	fire_modes				= { -1, 1 };
	fire_rate				= 950;
	
	weight					= 1.8;
	
	weapon_type				= WEAPON_TYPE_MP5;
	
	ammo_class				= "ammo_4_6x30";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_p90 ( default_weapon_params )
{
	name					= "FN P90";
	name2					= "пистолет-пулемёт";
	description				= "Три крепления спереди позволяют пользователю установить широкий спектр принадлежностей, а специальные бронебойные боеприпасы 5,7x28 мм выстреливаются со скоростью, близкой к автомату. Имеющий в стандартной комплектации магазин на 50 патронов, P90 прекрасно подходит в качестве наступательного оружия ближнего боя для высокомобильных подразделений.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_P90;
	
	fire_modes				= { -1, 1 };
	fire_rate				= 900;
	
	weight					= 2.78;
	
	weapon_type				= WEAPON_TYPE_MP5;
	
	ammo_class				= "ammo_5_7x28";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_qbu88 ( default_weapon_params )
{
	name					= "QBU-88";
	name2					= "винтовку";
	description				= "Китайская полуавтоматическая снайперская винтовка с компоновкой «булл-пап».";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_QBU88;
	
	fire_modes				= { 1 };
	fire_rate				= 600;
	
	weight					= 4.1;
	
	weapon_type				= WEAPON_TYPE_SNIPER;
	
	ammo_class				= "ammo_5_8x42";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_qjy88 ( default_weapon_params )
{
	name					= "QBU-88 LMG";
	name2					= "пулемёт";
	description				= "TYPE-88 также известен под китайским обозначением QJY-88. Несмотря на название TYPE-88 (имеется в виду 1988 г. - год принятия на вооружение), данное оружие лишь недавно стало широко применимо в Китае. В TYPE-88 используются особые тяжелые патроны 5,8x42 мм китайского образца. Оснащен сошками для стрельбы с опорой.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_QJY88;
	
	fire_modes				= { -1 };
	fire_rate				= 700;
	
	weight					= 11.8;
	
	weapon_type				= WEAPON_TYPE_AK47;
	
	ammo_class				= "ammo_5_8x42";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_rpg ( default_weapon_params )
{
	name					= "РПГ-7В2";
	name2					= "гранатомёт";
	description				= "Получивший широкое распространение ручной противотанковый гранатомет РПГ-7 использовался почти во всех вооруженных конфликтах на всех континентах с середины 1960-х годов. Была разработана модернизированная версия РПГ-7В2, обладающая меньшим весом и предназначенная для стрельбы снарядами ПГ-7ВЛ, эффективными как против укреплений, так и против бронированной техники.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_RPG;
	
	fire_modes				= { 1 };
	fire_rate				= -1;
	
	weight					= 6.3;
	
	weapon_type				= WEAPON_TYPE_RPG7;
	
	ammo_class				= "ammo_og_7b";
	ammo_type				= AMMO_TYPE_NONE;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_rpk74m ( default_weapon_params )
{
	name					= "РПК-74М";
	name2					= "пулемёт";
	description				= "РПК-74М - улучшенная версия оригинального пулемета РПК, разработанного в 1950-х годах. Являясь в сущности АК-74 с утяжеленным стволом, РПК снабжен более длинным магазином и полимерной фурнитурой для облегчения конструкции оружия. РПК-74М также отличается креплением прицела, аналогичным AK-74M, а по умолчанию оснащен сошками для стрельбы с опорой.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_RPK74M;
	
	fire_modes				= { -1, 1 };
	fire_rate				= 600;
	
	weight					= 5.0;
	
	weapon_type				= WEAPON_TYPE_AK47;
	
	ammo_class				= "ammo_5_45x39";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}

item: wpn_ump45 ( default_weapon_params )
{
	name					= "HK UMP-45";
	name2					= "пистолет-пулемёт";
	description				= "UMP-45 - это полностью автоматическое персональное оружие самообороны. Являясь улучшенной версией MP5, UMP-45 функционально схож с ним, но значительно дешевле в производстве и имеет некоторые усовершенствования, такие как крепления для принадлежностей сверху и спереди.";
	slot					= ITEM_SLOT_WEAPON1;
	cost					= 5000;
	model					= WEAPON_UMP45;
	
	fire_modes				= { -1, 2, 1 };
	fire_rate				= 600;
	
	weight					= 2.25;
	
	weapon_type				= WEAPON_TYPE_MP5;
	
	ammo_class				= "ammo_11_43x23";
	ammo_type				= AMMO_TYPE_CLIP;
	
	misfire_probability 	= 0.2;
	condition_shot_dec 		= 0.005;
}
