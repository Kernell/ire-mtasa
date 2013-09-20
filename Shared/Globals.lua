-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

CreateMarker	= createMarker;
CreatePickup	= createPickup;
CreateBlip		= createBlip;
CreateVehicle	= createVehicle;

FACTION_MAX_DEPTS		= 5;
FACTION_MAX_RANKS		= 16;

eFactionFlags			=
{
	government			= "government";
	police				= "police";
	fbi					= "fbi";
	medical				= "medical";
	news				= "news";
	licenses			= "licenses";
	ckill				= "ckill";
};

enum "eFactionType"
{
	FACTION_TYPE_GOV	= 0;
	FACTION_TYPE_LLC	= 1;
	FACTION_TYPE_CORP	= 2;
	FACTION_TYPE_SOLE	= 3;
};

eFactionTypeNames		=
{
	[ FACTION_TYPE_GOV ]	= "Государственная организация";
	[ FACTION_TYPE_LLC ]	= "Limited liability company (LLC)";
	[ FACTION_TYPE_CORP ]	= "Corporation";
	[ FACTION_TYPE_SOLE ]	= "Sole proprietorship";
};

eFactionRight		=
{
	STAFF_LIST		= 0x00000001;
	VIEW_STAFF		= 0x00000002;
	INVITE			= 0x00000004;
	UNINVITE		= 0x00000008;
	CHANGE_DEPT		= 0x00000010;
	CHANGE_RANK		= 0x00000020;
	CHANGE_RIGHTS	= 0x00000040;
	EDIT_NAME		= 0x00000080;
	EDIT_TAG		= 0x00000100;
	EDIT_DEPTS		= 0x00000200;
	BANK_LOG		= 0x00000400;
	BANK_TRANSFER	= 0x00000800;
	
	NONE			= 0x00000000;
	ALL				= 4294967295; -- 0xFFFFFFFF; -- TODO: MTA Lua client-side bug
};

-- TODO: MTA Lua client-side bug
eFactionRight.OWNER	= 4294966911; -- 0xFFFFFE7F; -- eFactionRight.ALL '^' ( ( eFactionRight.EDIT_NAME ) '|' ( eFactionRight.EDIT_TAG ) );

eFactionRightNames	=
{
	[ eFactionRight.STAFF_LIST ]		= "Просмотр списка сотрудников";
	[ eFactionRight.VIEW_STAFF ]		= "Просмотр информации сотрудников";
	[ eFactionRight.INVITE ]			= "Нанимать новых сотрудников";
	[ eFactionRight.UNINVITE ]			= "Увольнять сотрудников";
	[ eFactionRight.CHANGE_DEPT ]		= "Изменять отдел сотрудника";
	[ eFactionRight.CHANGE_RANK ]		= "Изменять должность сотрудника";
	[ eFactionRight.CHANGE_RIGHTS ]		= "Изменять права доступа сотрудников";
	[ eFactionRight.EDIT_NAME ]			= "Редактировать название организации";
	[ eFactionRight.EDIT_TAG ]			= "Редактировать аббревиатуру организации";
	[ eFactionRight.EDIT_DEPTS ]		= "Редактировать отделы организации";
	[ eFactionRight.BANK_LOG ]			= "Просматривать историю переводов";
	[ eFactionRight.BANK_TRANSFER ]		= "Управление счётом (перевод средств)";
};

enum "eInteriorType"
{
	INTERIOR_TYPE_NONE			= "interior";
	INTERIOR_TYPE_COMMERCIAL	= "business";
	INTERIOR_TYPE_HOUSE			= "house";
};

eInteriorTypeNames =
{
	[ INTERIOR_TYPE_NONE ]			= "Государственная недвижимость";
	[ INTERIOR_TYPE_COMMERCIAL ]	= "Коммерческая недвижимость";
	[ INTERIOR_TYPE_HOUSE ]			= "Дом/квартира";
};

ePropertyUpgrade	=
{
	FACTION_MARKER	= { Price = 1000; Type = INTERIOR_TYPE_COMMERCIAL; Name = "Маркер управления организацией"; };
	BLIP			= { Price = 3000; Type = INTERIOR_TYPE_COMMERCIAL; Name = "Иконка на карте"; };
};

enum "eVehicle"
{
	ADMIRAL		= 445;
	ALPHA		= 602;
	AMBULAN		= 416;
	ANDROM		= 592;
	ARTICT1		= 435;
	ARTICT2		= 450;
	ARTICT3		= 591;
	AT400		= 577;
	BAGBOXA		= 606;
	BAGBOXB		= 607;
	BAGGAGE		= 485;
	BANDITO		= 568;
	BANSHEE		= 429;
	BARRACKS	= 433;
	BEAGLE		= 511;
	BENSON		= 499;
	BF400		= 581;
	BFINJECT	= 424;
	BIKE		= 509;
	BLADE		= 536;
	BLISTAC		= 496;
	BLOODRA		= 504;
	BMX			= 481;
	BOBCAT		= 422;
	BOXBURG		= 609;
	BOXVILLE	= 498;
	BRAVURA		= 401;
	BROADWAY	= 575;
	BUCCANEE	= 518;
	BUFFALO		= 402;
	BULLET		= 541;
	BURRITO		= 482;
	BUS			= 431;
	CABBIE		= 438;
	CADDY		= 457;
	CADRONA		= 527;
	CAMPER		= 483;
	CARGOBOB	= 548;
	CEMENT		= 524;
	CHEETAH		= 415;
	CLOVER		= 542;
	CLUB		= 589;
	COACH		= 437;
	COASTG		= 472;
	COMBINE		= 532;
	COMET		= 480;
	COPBIKE		= 523;
	COPCARLA	= 596;
	COPCARRU	= 599;
	COPCARSF	= 597;
	COPCARVG	= 598;
	CROPDUST	= 512;
	DFT30		= 578;
	DINGHY		= 473;
	DODO		= 593;
	DOZER		= 486;
	DUMPER		= 406;
	DUNERIDE	= 573;
	ELEGANT		= 507;
	ELEGY		= 562;
	EMPEROR		= 585;
	ENFORCER	= 427;
	ESPERANT	= 419;
	EUROS		= 587;
	FAGGIO		= 462;
	FARMTR1		= 610;
	FBIRANCH	= 490;
	FBITRUCK	= 528;
	FCR900		= 521;
	FELTZER		= 533;
	FIRELA		= 544;
	FIRETRUK	= 407;
	FLASH		= 565;
	FLATBED		= 455;
	FORKLIFT	= 530;
	FORTUNE		= 526;
	FREEWAY		= 463;
	FREIBOX		= 590;
	FREIFLAT	= 569;
	FREIGHT		= 537;
	GLENDALE	= 466;
	GLENSHIT	= 604;
	GREENWOO	= 492;
	HERMES		= 474;
	HOTDOG		= 588;
	HOTKNIFE	= 434;
	HOTRINA		= 502;
	HOTRINB		= 503;
	HOTRING		= 494;
	HUNTER		= 425;
	HUNTLEY		= 579;
	HUSTLER		= 545;
	HYDRA		= 520;
	INFERNUS	= 411;
	INTRUDER	= 546;
	JESTER		= 559;
	JETMAX		= 493;
	JOURNEY		= 508;
	KART		= 571;
	LANDSTAL	= 400;
	LAUNCH		= 595;
	LEVIATHN	= 417;
	LINERUN		= 403;
	MAJESTIC	= 517;
	MANANA		= 410;
	MARQUIS		= 484;
	MAVERICK	= 487;
	MERIT		= 551;
	MESA		= 500;
	MONSTER		= 444;
	MONSTERA	= 556;
	MONSTERB	= 557;
	MOONBEAM	= 418;
	MOWER		= 572;
	MRWHOOP		= 423;
	MTBIKE		= 510;
	MULE		= 414;
	NEBULA		= 516;
	NEVADA		= 553;
	NEWSVAN		= 582;
	NRG500		= 522;
	OCEANIC		= 467;
	PACKER		= 443;
	PATRIOT		= 470;
	PCJ600		= 461;
	PEREN		= 404;
	PETRO		= 514;
	PETROTR		= 584;
	PHOENIX		= 603;
	PICADOR		= 600;
	PIZZABOY	= 448;
	POLMAV		= 497;
	PONY		= 413;
	PREDATOR	= 430;
	PREMIER		= 426;
	PREVION		= 436;
	PRIMO		= 547;
	QUAD		= 471;
	RAINDANC	= 563;
	RANCHER		= 489;
	RCBANDIT	= 441;
	RCBARON		= 464;
	RCCAM		= 594;
	RCGOBLIN	= 501;
	RCRAIDER	= 465;
	RCTIGER		= 564;
	RDTRAIN		= 515;
	REEFER		= 453;
	REGINA		= 479;
	REMINGTN	= 534;
	RHINO		= 432;
	RNCHLURE	= 505;
	ROMERO		= 442;
	RUMPO		= 440;
	RUSTLER		= 476;
	SABRE		= 475;
	SADLER		= 543;
	SADLSHIT	= 605;
	SANCHEZ		= 468;
	SANDKING	= 495;
	SAVANNA		= 567;
	SEASPAR		= 447;
	SECURICA	= 428;
	SENTINEL	= 405;
	SHAMAL		= 519;
	SKIMMER		= 460;
	SLAMVAN		= 535;
	SOLAIR		= 458;
	SPARROW		= 469;
	SPEEDER		= 452;
	SQUALO		= 446;
	STAFFORD	= 580;
	STALLION	= 439;
	STRATUM		= 561;
	STREAK		= 538;
	STREAKC		= 570;
	STRETCH		= 409;
	STUNT		= 513;
	SULTAN		= 560;
	SUNRISE		= 550;
	SUPERGT		= 506;
	SWATVAN		= 601;
	SWEEPER		= 574;
	TAHOMA		= 566;
	TAMPA		= 549;
	TAXI		= 420;
	TOPFUN		= 459;
	TORNADO		= 576;
	TOWTRUCK	= 525;
	TRACTOR		= 531;
	TRAM		= 449;
	TRASH		= 408;
	TROPIC		= 454;
	TUG			= 583;
	TUGSTAIR	= 608;
	TURISMO		= 451;
	URANUS		= 558;
	UTILITY		= 552;
	UTILTR1		= 611;
	VCNMAV		= 488;
	VINCENT		= 540;
	VIRGO		= 491;
	VOODOO		= 412;
	VORTEX		= 539;
	WALTON		= 478;
	WASHING		= 421;
	WAYFARER	= 586;
	WILLARD		= 529;
	WINDSOR		= 555;
	YANKEE		= 456;
	YOSEMITE	= 554;
	ZR350		= 477;
};
