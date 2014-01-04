-- WORP Engine v1.0.0
--
-- Author		Kernell
-- Copyright	© 2011 - 2012
-- License		Proprietary Software
-- Version		1.0

class: item_base
{
	m_TClass			= CItem;
	m_bIsItem			= true;
	m_bCanDrop			= true;
	m_sName				= "";
	m_sName2			= "";
	m_sDescription		= "";
	m_iCost				= 0;
	m_iModel			= -1;
	m_fWeight			= 0.0;
	
	m_iSlot				= ITEM_SLOT_NONE;
	m_iType				= ITEM_TYPE_NONE;
};

class: bank_card ( item_base )
{
	m_sName			= "Банковская карточка";
	m_sName2		= "карточку";
	m_sDescription	= "Обычная пластиковая карточка";
	m_iCost			= 100;
	
	m_fWeight		= 0.0;
	
	m_bBankCard		= true;
};

class: bank_card_visa ( bank_card )
{
	m_sName			= "Банковская карточка Visa Gold";
};

class: bank_card_mastercard ( bank_card )
{
	m_sName			= "Банковская карточка MasterCard";
};

class: bank_card_americanexpress ( bank_card )
{
	m_sName			= "Банковская карточка American Express";
};

class: night_vision_goggles ( item_base )
{
	m_sName			= "Очки ночного виденья";
	m_sName2		= "очки";
	m_iCost			= 40000;
	m_iModel		= 368;
	
	m_fWeight		= 0.1;
};

class: infrared_goggles ( item_base )
{
	m_sName			= "Инфакрасные очки";
	m_sName2		= "очки";
	m_iCost			= 50000;
	m_iModel		= 369;
	
	m_fWeight		= 0.1;
};

class: parachute ( item_base )
{
	m_sName			= "Парашют";
	m_sName2		= "парашют";
	m_iCost			= 5000;
	m_iModel		= 371;
	
	m_fWeight		= 0.51;
};

class: food_base ( item_base )
{
	m_TClass			= CFood;
	m_iType				= ITEM_TYPE_FOOD;
	m_fWeight			= 0.1;
	m_iBone2			= 12;
};

class: item_food_buster ( food_base )
{
	m_sName				= "Buster";
	m_sName2			= "пиццу";
	m_sDescription		= "";
	m_iCost				= 2;
	m_iModel			= 2702;
	
	m_fHealth			= 10;
	m_fSatiety			= 10;
	m_fPower 			= 0;
	m_fAlcohol	 		= 0;
	
	m_sAnimLib			= "FOOD";
	m_sAnimName			= "EAT_Pizza";
	m_iAnimTime			= 5000;
	
	m_iBone2			= 12;
	m_vecBone2Pos		= Vector3( 0, .12, .05 );
	m_vecBone2Rot		= Vector3( 0, 285, 0 );
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};

class: item_food_double_d_luxe ( food_base )
{
	m_sName				= "Double D-Luxe";
	m_sName2			= "пиццу";
	m_sDescription		= "";
	m_iCost				= 5;
	m_iModel			= 2702;
	
	m_fHealth			= 20;
	m_fSatiety	 		= 20;
	m_fPower 			= 0;
	m_fAlcohol	 		= 0;
	
	m_sAnimLib			= "FOOD";
	m_sAnimName			= "EAT_Pizza";
	m_iAnimTime			= 5000;
	
	m_iBone2			= 12;
	m_vecBone2Pos		= Vector3( 0, .12, .05 );
	m_vecBone2Rot		= Vector3( 0, 285, 0 );
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};

class: item_food_full_rack ( food_base )
{
	m_sName				= "Full Rack";
	m_sName2			= "пиццу";
	m_sDescription		= "";
	m_iCost				= 10;
	m_iModel			= 2702;
	
	m_fHealth			= 30;
	m_fSatiety	 		= 20;
	m_fPower 			= 0;
	m_fAlcohol	 		= 0;
	
	m_sAnimLib			= "FOOD";
	m_sAnimName			= "EAT_Pizza";
	m_iAnimTime			= 5000;
	
	m_iBone2			= 12;
	m_vecBone2Pos		= Vector3( 0, .12, .05 );
	m_vecBone2Rot		= Vector3( 0, 285, 0 );
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};

class: item_food_salad_meal ( food_base )
{
	m_sName				= "Salad Meal";
	m_sName2			= "салат";
	m_sDescription		= "";
	m_iCost				= 10;
	m_iModel			= -1;
	
	m_fHealth			= 30;
	m_fSatiety			= 15;
	m_fPower 			= 0;
	m_fAlcohol	 		= 0;
	
	m_sAnimLib			= "FOOD";
	m_sAnimName			= "EAT_Pizza";
	m_iAnimTime			= 5000;
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};

class: item_food_moo_kids_meal ( food_base )
{
	m_sName				= "Moo Kids Meal";
	m_sName2			= "бургер";
	m_sDescription		= "";
	m_iCost				= 2;
	m_iModel			= 2703;
	
	m_fHealth			= 10;
	m_fSatiety	 		= 10;
	m_fPower 			= 0;
	m_fAlcohol	 		= 0;
	
	m_sAnimLib			= "FOOD";
	m_sAnimName			= "EAT_Burger";
	m_iAnimTime			= 5000;
	
	m_iBone2			= 12;
	m_vecBone2Pos		= Vector3( 0, .08, .1 );
	m_vecBone2Rot		= Vector3( 300, 90, 0 );
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};

class: item_food_beef_tower ( food_base )
{
	m_sName				= "Beef Tower";
	m_sName2			= "бургер";
	m_sDescription		= "";
	m_iCost				= 5;
	m_iModel			= 2703;
	
	m_fHealth			= 20;
	m_fSatiety	 		= 20;
	m_fPower 			= 0;
	m_fAlcohol	 		= 0;
	
	m_sAnimLib			= "FOOD";
	m_sAnimName			= "EAT_Burger";
	m_iAnimTime			= 5000;
	
	m_iBone2			= 12;
	m_vecBone2Pos		= Vector3( 0, .08, .1 );
	m_vecBone2Rot		= Vector3( 300, 90, 0 );
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};

class: item_food_meat_stack ( food_base )
{
	m_sName				= "Meat Stack";
	m_sName2			= "мясной стейк";
	m_sDescription		= "";
	m_iCost				= 10;
	m_iModel			= -1;
	
	m_fHealth			= 30;
	m_fSatiety	 		= 20;
	m_fPower 			= 0;
	m_fAlcohol		 		= 0;
	
	m_sAnimLib			= "FOOD";
	m_sAnimName			= "EAT_Burger";
	m_iAnimTime			= 5000;
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};

class: item_food_cluckin_little_meal ( food_base )
{
	m_sName				= "Cluckin' Little Meal";
	m_sName2			= "курицу";
	m_sDescription		= "";
	m_iCost				= 2;
	m_iModel			= -1;
	
	m_fHealth			= 10;
	m_fSatiety	 		= 10;
	m_fPower 			= 0;
	m_fAlcohol	 		= 0;
	
	m_sAnimLib			= "FOOD";
	m_sAnimName			= "EAT_Chicken";
	m_iAnimTime			= 4000;
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};	

class: item_food_cluckin_big_meal ( food_base )
{
	m_sName				= "Cluckin' Big Meal";
	m_sName2			= "курицу";
	m_sDescription		= "";
	m_iCost				= 5;
	m_iModel			= -1;
	
	m_fHealth			= 20;
	m_fSatiety			= 20;
	m_fPower 			= 0;
	m_fAlcohol				= 0;
	
	m_sAnimLib			= "FOOD";
	m_sAnimName			= "EAT_Chicken";
	m_iAnimTime			= 4000;
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};

class: item_food_cluckin_huge_meal ( food_base )
{
	m_sName				= "Cluckin' Huge Meal";
	m_sName2			= "курицу";
	m_sDescription		= "";
	m_iCost				= 10;
	m_iModel			= -1;
	
	m_fHealth			= 30;
	m_fSatiety	 		= 20;
	m_fPower 			= 0;
	m_fAlcohol	 		= 0;
	
	m_sAnimLib			= "FOOD";
	m_sAnimName			= "EAT_Chicken";
	m_iAnimTime			= 4000;
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};

class: drink_base ( item_base )
{
	m_TClass			= CDrink;
	m_iType				= ITEM_TYPE_DRINK;
	m_fWeight			= 0.1;
}

class: item_drink_rockstar ( drink_base )
{
	m_sName				= "Лимонад Rockstar";
	m_sName2			= "лимонад";
	m_sDescription		= "";
	m_iCost				= 10;
	m_iModel			= 1484;
	
	m_fHealth			= 5;
	m_fSatiety	 		= 0;
	m_fPower 			= 10;
	m_fAlcohol	 		= 0;
	
	m_sAnimLib			= "BAR";
	m_sAnimName			= "dnk_stndM_loop";
	m_iAnimTime			= 2500;
	
	m_iBone2			= 12;
	m_vecBone2Pos		= Vector3( 0, 0.05, -0.025 );
	m_vecBone2Rot		= Vector3( 30, 270, 0 );
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};

class: item_drink_beer ( drink_base )
{
	m_sName				= "Пиво";
	m_sName2			= "пиво";
	m_sDescription		= "";
	m_iCost				= 20;
	m_iModel			= 1544;
	
	m_fHealth			= 10;
	m_fSatiety	 		= 0;
	m_fPower 			= 3;
	m_fAlcohol	 		= 15;
	
	m_sAnimLib			= "BAR";
	m_sAnimName			= "dnk_stndM_loop";
	m_iAnimTime			= 2500;
	
	m_iBone2			= 12;
	m_vecBone2Pos		= Vector3( 0.25, 0.05, 0.05 );
	m_vecBone2Rot		= Vector3( 30, 270, 0 );
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};

class: item_drink_wine ( drink_base )
{
	m_sName				= "Вино";
	m_sName2			= "вино";
	m_sDescription		= "";
	m_iCost				= 40;
	m_iModel			= 1664;
	
	m_fHealth			= 15;
	m_fSatiety	 		= 0;
	m_fPower 			= 0;
	m_fAlcohol	 		= 10;
	
	m_sAnimLib			= "BAR";
	m_sAnimName			= "dnk_stndM_loop";
	m_iAnimTime			= 2500;
	
	m_iBone2			= 12;
	m_vecBone2Pos		= Vector3( 0, 0.05, 0.05 );
	m_vecBone2Rot		= Vector3( 300, 270, 0 );
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};

class: item_drink_vodka ( drink_base )
{
	m_sName				= "Водка";
	m_sName2			= "водку";
	m_sDescription		= "";
	m_iCost				= 30;
	m_iModel			= 1668;
	
	m_fHealth			= 20;
	m_fSatiety	 		= 0;
	m_fPower 			= 0;
	m_fAlcohol	 		= 30;
	
	m_sAnimLib			= "BAR";
	m_sAnimName			= "dnk_stndM_loop";
	m_iAnimTime			= 2500;
	
	m_iBone2			= 12;
	m_vecBone2Pos		= Vector3( 0, 0.05, 0.05 );
	m_vecBone2Rot		= Vector3( 300, 270, 0 );
	
	m_vecSpawnPos		= Vector3( 0.0, 0.0, -.98 );
	m_vecSpawnRot		= Vector3( 0.0, 0.0, 0.0 );
};