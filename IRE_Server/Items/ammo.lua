-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class: clip_base ( item_base )
{
	m_TClass		= CClipAmmo;
	
	m_sName			= "Магазин неизвестного оружия";
	m_sName2		= "магазин";
	m_sDescription	= "Видимо от игрушечного пистолета...";
	m_iCost			= 300;
	m_iModel		= -1;
	m_iSlot			= ITEM_SLOT_CLIP_AMMO;
	m_iType			= ITEM_TYPE_CLIP_AMMO;
	
	m_iClipSize		= 10;
	
	m_fWeight		= .1;
	
	m_vecSpawnPos	= Vector3( 0.0, 0.0, 0.0 );
	m_vecSpawnRot	= Vector3( 0.0, 0.0, 0.0 );
};

class: clip_mp5 ( clip_base )
{
	m_sName			= "Магазин HK MP5 A4";
	m_sName2		= "магазин";
	m_sDescription	= "";
	m_iCost			= 300;
	
	m_iClipSize		= 30;
	
	m_fWeight		= .1;
	
	m_sWeaponClass	= "wpn_mp5";
	m_sAmmoClass	= "ammo_9x19";
};

class: clip_ak107m ( clip_base )
{
	m_sName			= "Магазин AK-107M";
	m_sName2		= "магазин";
	m_sDescription	= "";
	m_iCost			= 300;
	
	m_iClipSize		= 30;
	
	m_fWeight		= .1;
	
	m_sWeaponClass	= "wpn_ak107m";
	m_sAmmoClass	= "ammo_5_45x39";
};

class: clip_m4a1 ( clip_base )
{
	m_sName			= "Магазин Colt M4A1";
	m_sName2		= "магазин";
	m_sDescription	= "";
	m_iCost			= 300;
	
	m_iClipSize		= 30;
	
	m_fWeight		= .1;
	
	m_sWeaponClass	= "wpn_m4a1";
	m_sAmmoClass	= "ammo_5_56x45";
};

class: clip_aug ( clip_base )
{
	m_sName			= "Магазин Steyr AUG A1";
	m_sName2		= "магазин";
	m_sDescription	= "";
	m_iCost			= 300;
	
	m_iClipSize		= 30;
	
	m_fWeight		= .1;
	
	m_sWeaponClass	= "wpn_aug";
	m_sAmmoClass	= "ammo_5_56x45";
};

class: clip_scout ( clip_base )
{
	m_sName			= "Магазин Steyr Scout";
	m_sName2		= "магазин";
	m_sDescription	= "";
	m_iCost			= 300;
	
	m_iClipSize		= 10;
	
	m_fWeight		= .1;
	
	m_sWeaponClass	= "wpn_scout";
	m_sAmmoClass	= "ammo_7_62x54_7h1";
};

class: clip_usp45 ( clip_base )
{
	m_sName			= "Магазин HK USP .45";
	m_sName2		= "магазин";
	m_sDescription	= "";
	m_iCost			= 300;
	
	m_iClipSize		= 10;
	
	m_fWeight		= .1;
	
	m_sWeaponClass	= "wpn_usp45";
	m_sAmmoClass	= "ammo_11_43x23";
};

class: clip_desert_eagle ( clip_base )
{
	m_sName			= "Магазин Desert Eagle";
	m_sName2		= "магазин";
	m_sDescription	= "";
	m_iCost			= 300;
	
	m_iClipSize		= 7;
	
	m_fWeight		= .1;
	
	m_sWeaponClass	= "wpn_desert_eagle";
	m_sAmmoClass	= "ammo_11_43x23";
};

---

class: ammo_base ( item_base )
{
	m_iSlot			= ITEM_SLOT_NONE;
	m_iType			= ITEM_TYPE_AMMO;
	m_fImpair		= 1.0;				-- коэффициент износа ствола от пули 
--	m_iBuckShot		= 1;				-- кол-во составляющих в пуле (напр картечь - 4, пуля - 1) 
	m_bTracer		= false;			-- является ли патрон трассирующим
	m_bExplosive	= false;			-- зажигательный боеприпас
	
--	m_fDistance		= 1.0;				-- коэффициент дальности, сама дальность - в стволе, тупо расстояние. 
--	m_fDisp			= 1.0;				-- кучность, завязана с кучностью в стволе 
--	m_fHit 			= 1.0;				-- убойность, завязана с убойностью в стволе 
--	m_fImpulse 		= 1.0;				-- чисто наскока эффектно ногами дрыгнет во время кердыка 
--	m_fPierce 		= 0.1;				-- коэффициент наскока испорится броня при попадании
};

class: ammo_9x19 ( ammo_base )
{
	m_sName			= "Патроны 9x19"; 
	m_sName2		= "патроны";
	m_sDescription	= "";
	m_iCost			= 400;
	m_iModel		= 2043;
	
	m_iBoxSize		= 50;
	
	m_fWeight		= .2;
	
	m_vecSpawnPos	= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot	= Vector3( 0.0, 0.0, 0.0 );
};

class: ammo_5_45x39 ( ammo_base )
{
	m_sName			= "Патроны 5.45x39"; 
	m_sName2		= "патроны";
	m_sDescription	= "При проектировании патрона 5,45×39 мм разработчики учитывали опыт создания и боевого применения американского патрона 5,56×45 мм, поэтому новый патрон получился сопоставимым по эффективности, несмотря на меньшую мощность. Малокалиберная пуля с высокой начальной скоростью, обеспечивает высокую настильность траектории (в сравнении с патроном 7,62×39 мм, дальность прямого выстрела увеличилась на 100 метров), обладает неплохим пробивным действием и значительной убойной силой. Малый импульс отдачи в момент выстрела благоприятно сказывается на кучности и меткости стрельбы.";
	m_iCost			= 800;
	m_iModel		= 2043;
	
	m_iBoxSize		= 50;
	
	m_fWeight		= .32;
	
	m_vecSpawnPos	= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot	= Vector3( 0.0, 0.0, 0.0 );
};

class: ammo_5_56x45 ( ammo_base )
{
	m_sName			= "Патроны 5.56x45 НАТО"; 
	m_sName2		= "патроны";
	m_sDescription	= "В 1970-х годах странами НАТО было подписано соглашение на выбор второго, более малого калибра, который заменит 7,62 мм НАТО. Из представленных калибров был выбран 5,56 мм, но не американского образца (M193 Ball), а бельгийский образец компании Fabrique Nationale SS109. У SS109 была более тяжёлая пуля и более низкая начальная скорость, что позволило ей отвечать требованию пробивать стальной шлем на расстоянии 600 метров.";
	m_iCost			= 700;
	m_iModel		= 2043;
	
	m_iBoxSize		= 50;
	
	m_fWeight		= .33;
	
	m_vecSpawnPos	= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot	= Vector3( 0.0, 0.0, 0.0 );
};

item: ammo_7_62x51 ( ammo_base )
{
	name			= "Патроны 7.62x51";
	description		= "Стандартный винтовочно-пулемётный боеприпас стран-участниц НАТО. Принят в 1954 году под обозначением T65, впоследствии неоднократно модернизирован.";
}

class: ammo_7_62x54_7h1 ( ammo_base )
{
	m_sName			= "Патроны 7.62x54 7h1"; 
	m_sName2		= "патроны";
	m_sDescription	= "Валовый современный 7,62 мм винтовочный патрон для снайперских винтовок.\nПуля 7Н13, несмотря на схожие со снайперскими боеприпасами баллистические характеристики, имеет довольно большое (по снайперским требованиям) рассеивание даже на средних дистанциях, однако обладает повышенным пробивным действием за счёт введения в конструкцию пули бронебойного сердечника из закалённой инструментальной стали.";
	m_iCost			= 850;
	m_iModel		= 2043;
	
	m_iBoxSize		= 50;
	
	m_fWeight		= .3;
	
	m_vecSpawnPos	= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot	= Vector3( 0.0, 0.0, 0.0 );
};

class: ammo_11_43x23 ( ammo_base )
{
	m_sName			= "Патроны 11.43x23 (.45 ACP)"; 
	m_sName2		= "патроны";
	m_sDescription	= "Патрон имеет низкую начальную скорость и поэтому он часто используется для создания «бесшумных» вариантов оружия с глушителями.";
	m_iCost			= 250;
	m_iModel		= 2043;
	
	m_iBoxSize		= 30;
	
	m_fWeight		= .23;
	
	m_vecSpawnPos	= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot	= Vector3( 0.0, 0.0, 0.0 );
};

class: ammo_12x76 ( ammo_base )
{
	m_sName			= "Патроны 12x70"; 
	m_sName2		= "патроны";
	m_sDescription	= "Обычный патрон 12-го калибра, снаряжённый 6 мм дробью. На близких дистанциях обладает огромным убойным действием. Наиболее эффективен на дальностях до 30 метров.";
	m_iCost			= 250;
	m_iModel		= 2043;
	
	m_iBoxSize		= 30;
	
	m_fWeight		= .45;
	
	m_vecSpawnPos	= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot	= Vector3( 0.0, 0.0, 0.0 );
};

class: ammo_og_7b ( ammo_base )
{
	m_sName			= "Граната ОГ-7Б"; 
	m_sName2		= "граната";
	m_sDescription	= "Осколочно-фугасный выстрел для РПГ-7В. Одинаково эффективен как против живой силы, так и против легкобронированой техники.";
	m_iCost			= 250;
	m_iModel		= 2043;
	
	m_iBoxSize		= 30;
	
	m_fWeight		= 2.0;
	
	m_vecSpawnPos	= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot	= Vector3( 0.0, 0.0, 0.0 );
};