-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

item: item_base
{
	class				= Item;
	can_drop			= true;
	name				= "";
	name2				= "";
	description			= "";
	cost				= 0;
	model				= -1;
	weight				= 0.0;
	
	slot				= ITEM_SLOT_NONE;
	type				= ITEM_TYPE_NONE;
}

item: item_radio ( item_base )
{
	name			= "Рация";
	name2			= "рацию";
	description		= "";
	cost			= 500;
	model			= -1;
	weight			= 0.1;
}

item: bank_card ( item_base )
{
	name			= "Банковская карточка";
	name2			= "карточку";
	description		= "Обычная пластиковая карточка";
	cost			= 100;
	
	weight			= 0.0;
	
	bank_card		= true;
}

item: bank_card_visa ( bank_card )
{
	name			= "Банковская карточка Visa Gold";
}

item: bank_card_mastercard ( bank_card )
{
	name			= "Банковская карточка MasterCard";
}

item: bank_card_americanexpress ( bank_card )
{
	name			= "Банковская карточка American Express";
}

item: night_vision_goggles ( item_base )
{
	name			= "Очки ночного виденья";
	name2			= "очки";
	cost			= 40000;
	model			= 368;
	
	weight			= 0.1;
}

item: infrared_goggles ( item_base )
{
	name			= "Инфракрасные очки";
	name2			= "очки";
	cost			= 50000;
	model			= 369;
	
	weight			= 0.1;
}

item: parachute ( item_base )
{
	name			= "Парашют";
	name2			= "парашют";
	cost			= 5000;
	model			= 371;
	
	m_fWeight		= 0.51;
}

item: food_base ( item_base )
{
	class			= Food;
	type			= ITEM_TYPE_FOOD;
	weight			= 0.1;
	bone2			= 12;
}

item: item_food_buster ( food_base )
{
	name				= "Buster";
	name2				= "пиццу";
	description			= "";
	cost				= 2;
	model				= 2702;
	
	health				= 10;
	satiety				= 10;
	power 				= 0;
	alcohol	 			= 0;
	
	anim_lib			= "FOOD";
	anim_name			= "EAT_Pizza";
	anim_time			= 5000;
	
	bone2				= 12;
	bone2_position		= { 0, .12, .05 };
	bone2_rotation		= { 0, 285, 0 };
	
	spawn_position		= { 0.0, 0.0, -.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: item_food_double_d_luxe ( food_base )
{
	name				= "Double D-Luxe";
	name2				= "пиццу";
	description			= "";
	cost				= 5;
	model				= 2702;
	
	health				= 20;
	satiety	 			= 20;
	power 				= 0;
	alcohol	 			= 0;
	
	anim_lib			= "FOOD";
	anim_name			= "EAT_Pizza";
	anim_time			= 5000;
	
	bone2				= 12;
	bone2_position		= { 0, 0.12, 0.05 };
	bone2_rotation		= { 0, 285, 0 };
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: item_food_full_rack ( food_base )
{
	name				= "Full Rack";
	name2				= "пиццу";
	description			= "";
	cost				= 10;
	model				= 2702;
	
	health				= 30;
	satiety	 			= 20;
	power 				= 0;
	alcohol	 			= 0;
	
	anim_lib			= "FOOD";
	anim_name			= "EAT_Pizza";
	anim_time			= 5000;
	
	bone2				= 12;
	bone2_position		= { 0, 0.12, 0.05 };
	bone2_rotation		= { 0, 285, 0 };
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: item_food_salad_meal ( food_base )
{
	name				= "Salad Meal";
	name2				= "салат";
	description			= "";
	cost				= 10;
	model				= -1;
	
	health				= 30;
	satiety				= 15;
	power 				= 0;
	alcohol	 			= 0;
	
	anim_lib			= "FOOD";
	anim_name			= "EAT_Pizza";
	anim_time			= 5000;
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: item_food_moo_kids_meal ( food_base )
{
	name				= "Moo Kids Meal";
	name2				= "бургер";
	description			= "";
	cost				= 2;
	model				= 2703;
	
	health				= 10;
	satiety	 			= 10;
	power 				= 0;
	alcohol	 			= 0;
	
	anim_lib			= "FOOD";
	anim_name			= "EAT_Burger";
	anim_time			= 5000;
	
	bone2				= 12;
	bone2_position		= { 0, 0.08, 0.1 };
	bone2_rotation		= { 300, 90, 0 };
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: item_food_beef_tower ( food_base )
{
	name				= "Beef Tower";
	name2				= "бургер";
	description			= "";
	cost				= 5;
	model				= 2703;
	
	health				= 20;
	satiety	 			= 20;
	power 				= 0;
	alcohol	 			= 0;
	
	anim_lib			= "FOOD";
	anim_name			= "EAT_Burger";
	anim_time			= 5000;
	
	bone2				= 12;
	bone2_position		= { 0, 0.08, 0.1 };
	bone2_rotation		= { 300, 90, 0 };
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: item_food_meat_stack ( food_base )
{
	name				= "Meat Stack";
	name2				= "мясной стейк";
	description			= "";
	cost				= 10;
	model				= -1;
	
	health				= 30;
	satiety	 			= 20;
	power 				= 0;
	alcohol		 		= 0;
	
	anim_lib			= "FOOD";
	anim_name			= "EAT_Burger";
	anim_time			= 5000;
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: item_food_cluckin_little_meal ( food_base )
{
	name				= "Cluckin' Little Meal";
	name2				= "курицу";
	description			= "";
	cost				= 2;
	model				= -1;
	
	health				= 10;
	satiety	 			= 10;
	power 				= 0;
	alcohol	 			= 0;
	
	anim_lib			= "FOOD";
	anim_name			= "EAT_Chicken";
	anim_time			= 4000;
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: item_food_cluckin_big_meal ( food_base )
{
	name				= "Cluckin' Big Meal";
	name2				= "курицу";
	description			= "";
	cost				= 5;
	model				= -1;
	
	health				= 20;
	satiety				= 20;
	power 				= 0;
	alcohol				= 0;
	
	anim_lib			= "FOOD";
	anim_name			= "EAT_Chicken";
	anim_time			= 4000;
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: item_food_cluckin_huge_meal ( food_base )
{
	name				= "Cluckin' Huge Meal";
	name2				= "курицу";
	description			= "";
	cost				= 10;
	model				= -1;
	
	health				= 30;
	satiety	 			= 20;
	power 				= 0;
	alcohol	 			= 0;
	
	anim_lib			= "FOOD";
	anim_name			= "EAT_Chicken";
	anim_time			= 4000;
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: drink_base ( item_base )
{
	class				= Drink;
	type				= ITEM_TYPE_DRINK;
	weight				= 0.1;
}

item: item_drink_rockstar ( drink_base )
{
	name				= "Лимонад Rockstar";
	name2				= "лимонад";
	description			= "";
	cost				= 10;
	model				= 1484;
	
	health				= 5;
	satiety	 			= 0;
	power 				= 10;
	alcohol	 			= 0;
	
	anim_lib			= "BAR";
	anim_name			= "dnk_stndM_loop";
	anim_time			= 2500;
	
	bone2				= 12;
	bone2_position		= { 0, 0.05, -0.025 };
	bone2_rotation		= { 30, 270, 0 };
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: item_drink_beer ( drink_base )
{
	name				= "Пиво";
	name2				= "пиво";
	description			= "";
	cost				= 20;
	model				= 1544;
	
	health				= 10;
	satiety	 			= 0;
	power 				= 3;
	alcohol	 			= 15;
	
	anim_lib			= "BAR";
	anim_name			= "dnk_stndM_loop";
	anim_time			= 2500;
	
	bone2				= 12;
	bone2_position		= { 0.25, 0.05, 0.05 };
	bone2_rotation		= { 30, 270, 0 };
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: item_drink_wine ( drink_base )
{
	name				= "Вино";
	name2				= "вино";
	description			= "";
	cost				= 40;
	model				= 1664;
	
	health				= 15;
	satiety	 			= 0;
	power 				= 0;
	alcohol	 			= 10;
	
	anim_lib			= "BAR";
	anim_name			= "dnk_stndM_loop";
	anim_time			= 2500;
	
	bone2				= 12;
	bone2_position		= { 0, 0.05, 0.05 };
	bone2_rotation		= { 300, 270, 0 };
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}

item: item_drink_vodka ( drink_base )
{
	name				= "Водка";
	name2				= "водку";
	description			= "";
	cost				= 30;
	model				= 1668;
	
	health				= 20;
	satiety	 			= 0;
	power 				= 0;
	alcohol	 			= 30;
	
	anim_lib			= "BAR";
	anim_name			= "dnk_stndM_loop";
	anim_time			= 2500;
	
	bone2				= 12;
	bone2_position		= { 0, 0.05, 0.05 };
	bone2_rotation		= { 300, 270, 0 };
	
	spawn_position		= { 0.0, 0.0, -0.98 };
	spawn_rotation		= { 0.0, 0.0, 0.0 };
}