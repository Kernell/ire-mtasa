-- WORP Engine v1.0.0
--
-- Author		Kernell
-- Copyright	© 2011 - 2012
-- License		Proprietary Software
-- Version		1.0

enum "eWalkingStyle"
{
	MOVE_PLAYER			= 54; 
	MOVE_PLAYER_F 		= 55;
	MOVE_PLAYER_M 		= 56;
	MOVE_ROCKET 		= 57;
	MOVE_ROCKET_F 		= 58;
	MOVE_ROCKET_M 		= 59;
	MOVE_ARMED 			= 60;
	MOVE_ARMED_F 		= 61;
	MOVE_ARMED_M 		= 62;
	MOVE_BBBAT 			= 63;
	MOVE_BBBAT_F 		= 64;
	MOVE_BBBAT_M 		= 65;
	MOVE_CSAW 			= 66;
	MOVE_CSAW_F 		= 67;
	MOVE_CSAW_M 		= 68;
	MOVE_SNEAK 			= 69;
	MOVE_JETPACK 		= 70;
	MOVE_MAN 			= 118;
	MOVE_SHUFFLE 		= 119;
	MOVE_OLDMAN 		= 120;
	MOVE_GANG1 			= 121;
	MOVE_GANG2 			= 122;
	MOVE_OLDFATMAN 		= 123;
	MOVE_FATMAN 		= 124;
	MOVE_JOGGER 		= 125;
	MOVE_DRUNKMAN 		= 126;
	MOVE_BLINDMAN 		= 127;
	MOVE_SWAT 			= 128;
	MOVE_WOMAN 			= 129;
	MOVE_SHOPPING 		= 130;
	MOVE_BUSYWOMAN 		= 131;
	MOVE_SEXYWOMAN 		= 132;
	MOVE_PRO 			= 133; 
	MOVE_OLDWOMAN 		= 134; 
	MOVE_FATWOMAN 		= 135; 
	MOVE_JOGWOMAN 		= 136; 
	MOVE_OLDFATWOMAN 	= 137; 
	MOVE_SKATE 			= 138;
};

class: skin_base ( item_base )
{
	m_sName				= "Одежда";
	m_sName2			= "одежду";
	m_sDescription		= "";
	m_iSlot				= ITEM_SLOT_SKINS;
	m_iType				= ITEM_TYPE_SKINS;
	m_iCost				= 300;
	m_iModel			= -1;
	m_iSkin				= 0;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "player";
	m_iWalkingStyle		= MOVE_PLAYER;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_1 ( skin_base )
{
	m_sName				= "Truth";
	m_iCost				= 300;
	m_iSkin				= 1;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_2 ( skin_base )
{
	m_sName				= "Maccer";
	m_iCost				= 300;
	m_iSkin				= 2;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_7 ( skin_base )
{
	m_sName				= "Casual Jeanjacket";
	m_iCost				= 300;
	m_iSkin				= 7;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_9 ( skin_base )
{
	m_sName				= "Business Lady";
	m_iCost				= 300;
	m_iSkin				= 9;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_10 ( skin_base )
{
	m_sName				= "Old Fat Lady";
	m_iCost				= 300;
	m_iSkin				= 10;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "oldfatwoman";
	m_iWalkingStyle		= MOVE_OLDFATWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_11 ( skin_base )
{
	m_sName				= "Card Dealer 1";
	m_iCost				= 300;
	m_iSkin				= 11;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_12 ( skin_base )
{
	m_sName				= "Classy Gold Hooker";
	m_iCost				= 300;
	m_iSkin				= 12;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_13 ( skin_base )
{
	m_sName				= "Homegirl";
	m_iCost				= 300;
	m_iSkin				= 13;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_14 ( skin_base )
{
	m_sName				= "Floral Shirt";
	m_iCost				= 300;
	m_iSkin				= 14;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_15 ( skin_base )
{
	m_sName				= "Plaid Baldy";
	m_iCost				= 300;
	m_iSkin				= 15;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_16 ( skin_base )
{
	m_sName				= "Earmuff Worker";
	m_iCost				= 300;
	m_iSkin				= 16;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_17 ( skin_base )
{
	m_sName				= "Black suit";
	m_iCost				= 300;
	m_iSkin				= 17;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_18 ( skin_base )
{
	m_sName				= "Black Beachguy";
	m_iCost				= 300;
	m_iSkin				= 18;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_19 ( skin_base )
{
	m_sName				= "Beach Gangsta";
	m_iCost				= 300;
	m_iSkin				= 19;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_20 ( skin_base )
{
	m_sName				= "Fresh Prince";
	m_iCost				= 300;
	m_iSkin				= 20;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_21 ( skin_base )
{
	m_sName				= "Striped Gangsta";
	m_iCost				= 300;
	m_iSkin				= 21;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_22 ( skin_base )
{
	m_sName				= "Orange Sportsman";
	m_iCost				= 300;
	m_iSkin				= 22;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang2";
	m_iWalkingStyle		= MOVE_GANG2;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_23 ( skin_base )
{
	m_sName				= "Skater Kid";
	m_iCost				= 300;
	m_iSkin				= 23;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_24 ( skin_base )
{
	m_sName				= "LS Coach";
	m_iCost				= 300;
	m_iSkin				= 24;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_25 ( skin_base )
{
	m_sName				= "Varsity jacket";
	m_iCost				= 300;
	m_iSkin				= 25;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_26 ( skin_base )
{
	m_sName				= "Hiker";
	m_iCost				= 300;
	m_iSkin				= 26;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_27 ( skin_base )
{
	m_sName				= "Construction 1";
	m_iCost				= 300;
	m_iSkin				= 27;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_28 ( skin_base )
{
	m_sName				= "Black Dealer";
	m_iCost				= 300;
	m_iSkin				= 28;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang2";
	m_iWalkingStyle		= MOVE_GANG2;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_29 ( skin_base )
{
	m_sName				= "White Dealer";
	m_iCost				= 300;
	m_iSkin				= 29;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_30 ( skin_base )
{
	m_sName				= "Religious Essey";
	m_iCost				= 300;
	m_iSkin				= 30;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_31 ( skin_base )
{
	m_sName				= "Fat Cowgirl";
	m_iCost				= 300;
	m_iSkin				= 31;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "oldfatwoman";
	m_iWalkingStyle		= MOVE_OLDFATWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_32 ( skin_base )
{
	m_sName				= "Eyepatch";
	m_iCost				= 300;
	m_iSkin				= 32;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_33 ( skin_base )
{
	m_sName				= "Bounty Hunter";
	m_iCost				= 300;
	m_iSkin				= 33;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_34 ( skin_base )
{
	m_sName				= "Marlboro Man";
	m_iCost				= 300;
	m_iSkin				= 34;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_35 ( skin_base )
{
	m_sName				= "Fisherman";
	m_iCost				= 300;
	m_iSkin				= 35;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_36 ( skin_base )
{
	m_sName				= "Mailman";
	m_iCost				= 300;
	m_iSkin				= 36;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_37 ( skin_base )
{
	m_sName				= "Baseball Dad";
	m_iCost				= 300;
	m_iSkin				= 37;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_38 ( skin_base )
{
	m_sName				= "Old Golf Lady";
	m_iCost				= 300;
	m_iSkin				= 38;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_39 ( skin_base )
{
	m_sName				= "Old Maid";
	m_iCost				= 300;
	m_iSkin				= 39;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "oldfatwoman";
	m_iWalkingStyle		= MOVE_OLDFATWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_40 ( skin_base )
{
	m_sName				= "Classy Dark Hooker";
	m_iCost				= 300;
	m_iSkin				= 40;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_41 ( skin_base )
{
	m_sName				= "Tracksuit Girl";
	m_iCost				= 300;
	m_iSkin				= 41;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_43 ( skin_base )
{
	m_sName				= "Porn Producer";
	m_iCost				= 300;
	m_iSkin				= 43;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_44 ( skin_base )
{
	m_sName				= "Tatooed Plaid";
	m_iCost				= 300;
	m_iSkin				= 44;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_45 ( skin_base )
{
	m_sName				= "Beach Mustache";
	m_iCost				= 300;
	m_iSkin				= 45;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_46 ( skin_base )
{
	m_sName				= "Dark Romeo";
	m_iCost				= 300;
	m_iSkin				= 46;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_47 ( skin_base )
{
	m_sName				= "Top Button Essey";
	m_iCost				= 300;
	m_iSkin				= 47;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_48 ( skin_base )
{
	m_sName				= "Top Button Essey 2";
	m_iCost				= 300;
	m_iSkin				= 48;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_49 ( skin_base )
{
	m_sName				= "Ninja Sensei";
	m_iCost				= 300;
	m_iSkin				= 49;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "oldman";
	m_iWalkingStyle		= MOVE_OLDMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_50 ( skin_base )
{
	m_sName				= "Mechanic";
	m_iCost				= 300;
	m_iSkin				= 50;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_51 ( skin_base )
{
	m_sName				= "Black Bicyclist";
	m_iCost				= 300;
	m_iSkin				= 51;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_52 ( skin_base )
{
	m_sName				= "White Bicyclist";
	m_iCost				= 300;
	m_iSkin				= 52;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_53 ( skin_base )
{
	m_sName				= "Golf Lady";
	m_iCost				= 300;
	m_iSkin				= 53;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "oldwoman";
	m_iWalkingStyle		= MOVE_OLDWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_54 ( skin_base )
{
	m_sName				= "Hispanic Woman";
	m_iCost				= 300;
	m_iSkin				= 54;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "oldwoman";
	m_iWalkingStyle		= MOVE_OLDWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_55 ( skin_base )
{
	m_sName				= "Rich Bitch";
	m_iCost				= 300;
	m_iSkin				= 55;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_56 ( skin_base )
{
	m_sName				= "Legwarmers 1";
	m_iCost				= 300;
	m_iSkin				= 56;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_57 ( skin_base )
{
	m_sName				= "Chinese Businessman";
	m_iCost				= 300;
	m_iSkin				= 57;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_58 ( skin_base )
{
	m_sName				= "Chinese Plaid";
	m_iCost				= 300;
	m_iSkin				= 58;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_59 ( skin_base )
{
	m_sName				= "Chinese Romeo";
	m_iCost				= 300;
	m_iSkin				= 59;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_60 ( skin_base )
{
	m_sName				= "Chinese Casual";
	m_iCost				= 300;
	m_iSkin				= 60;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_61 ( skin_base )
{
	m_sName				= "Pilot";
	m_iCost				= 300;
	m_iSkin				= 61;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_62 ( skin_base )
{
	m_sName				= "Pajama Man 1";
	m_iCost				= 300;
	m_iSkin				= 62;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "oldman";
	m_iWalkingStyle		= MOVE_OLDMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_63 ( skin_base )
{
	m_sName				= "Trashy Hooker";
	m_iCost				= 300;
	m_iSkin				= 63;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "pro";
	m_iWalkingStyle		= MOVE_PRO;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_64 ( skin_base )
{
	m_sName				= "Transvestite";
	m_iCost				= 300;
	m_iSkin				= 64;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "pro";
	m_iWalkingStyle		= MOVE_PRO;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_66 ( skin_base )
{
	m_sName				= "Varsity Bandits";
	m_iCost				= 300;
	m_iSkin				= 66;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_67 ( skin_base )
{
	m_sName				= "Red Bandana";
	m_iCost				= 300;
	m_iSkin				= 67;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_68 ( skin_base )
{
	m_sName				= "Preist";
	m_iCost				= 300;
	m_iSkin				= 68;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_69 ( skin_base )
{
	m_sName				= "Denim Girl";
	m_iCost				= 300;
	m_iSkin				= 69;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_70 ( skin_base )
{
	m_sName				= "Scientist";
	m_iCost				= 300;
	m_iSkin				= 70;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_71 ( skin_base )
{
	m_sName				= "Security Guard";
	m_iCost				= 300;
	m_iSkin				= 71;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_72 ( skin_base )
{
	m_sName				= "Bearded Hippie";
	m_iCost				= 300;
	m_iSkin				= 72;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_73 ( skin_base )
{
	m_sName				= "Flag Bandana";
	m_iCost				= 300;
	m_iSkin				= 73;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_75 ( skin_base )
{
	m_sName				= "Skanky Hooker";
	m_iCost				= 300;
	m_iSkin				= 75;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "pro";
	m_iWalkingStyle		= MOVE_PRO;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_76 ( skin_base )
{
	m_sName				= "Businesswoman 1";
	m_iCost				= 300;
	m_iSkin				= 76;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_77 ( skin_base )
{
	m_sName				= "Bag Lady";
	m_iCost				= 300;
	m_iSkin				= 77;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_78 ( skin_base )
{
	m_sName				= "Homeless Scarf";
	m_iCost				= 300;
	m_iSkin				= 78;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_79 ( skin_base )
{
	m_sName				= "Fat Homeless";
	m_iCost				= 300;
	m_iSkin				= 79;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_80 ( skin_base )
{
	m_sName				= "Red Boxer";
	m_iCost				= 300;
	m_iSkin				= 80;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_81 ( skin_base )
{
	m_sName				= "Blue Boxer";
	m_iCost				= 300;
	m_iSkin				= 81;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_82 ( skin_base )
{
	m_sName				= "Fatty Elvis";
	m_iCost				= 300;
	m_iSkin				= 82;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_83 ( skin_base )
{
	m_sName				= "Whitesuit Elvis";
	m_iCost				= 300;
	m_iSkin				= 83;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_84 ( skin_base )
{
	m_sName				= "Bluesuit Elvis";
	m_iCost				= 300;
	m_iSkin				= 84;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_85 ( skin_base )
{
	m_sName				= "Furcoat Hooker";
	m_iCost				= 300;
	m_iSkin				= 85;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "pro";
	m_iWalkingStyle		= MOVE_PRO;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_87 ( skin_base )
{
	m_sName				= "Firecrotch";
	m_iCost				= 300;
	m_iSkin				= 87;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_88 ( skin_base )
{
	m_sName				= "Casual Old Lady";
	m_iCost				= 300;
	m_iSkin				= 88;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "oldwoman";
	m_iWalkingStyle		= MOVE_OLDWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_89 ( skin_base )
{
	m_sName				= "Cleaning Lady";
	m_iCost				= 300;
	m_iSkin				= 89;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "oldfatwoman";
	m_iWalkingStyle		= MOVE_OLDFATWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_90 ( skin_base )
{
	m_sName				= "Barely Covered";
	m_iCost				= 300;
	m_iSkin				= 90;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "jogwoman";
	m_iWalkingStyle		= MOVE_JOGWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_91 ( skin_base )
{
	m_sName				= "Sharon Stone";
	m_iCost				= 300;
	m_iSkin				= 91;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_93 ( skin_base )
{
	m_sName				= "Hoop Earrings 1";
	m_iCost				= 300;
	m_iSkin				= 93;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_94 ( skin_base )
{
	m_sName				= "Andy Capp";
	m_iCost				= 300;
	m_iSkin				= 94;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_95 ( skin_base )
{
	m_sName				= "Poor Old Man";
	m_iCost				= 300;
	m_iSkin				= 95;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_96 ( skin_base )
{
	m_sName				= "Soccer Player";
	m_iCost				= 300;
	m_iSkin				= 96;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "jogger";
	m_iWalkingStyle		= MOVE_JOGGER;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_97 ( skin_base )
{
	m_sName				= "Baywatch Dude";
	m_iCost				= 300;
	m_iSkin				= 97;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "jogger";
	m_iWalkingStyle		= MOVE_JOGGER;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_98 ( skin_base )
{
	m_sName				= "Dark Nightclubber";
	m_iCost				= 300;
	m_iSkin				= 98;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_100 ( skin_base )
{
	m_sName				= "Biker Blackshirt";
	m_iCost				= 300;
	m_iSkin				= 100;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_101 ( skin_base )
{
	m_sName				= "Jacket Hippie";
	m_iCost				= 300;
	m_iSkin				= 101;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_102 ( skin_base )
{
	m_sName				= "Baller Shirt";
	m_iCost				= 300;
	m_iSkin				= 102;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_103 ( skin_base )
{
	m_sName				= "Baller Jacket";
	m_iCost				= 300;
	m_iSkin				= 103;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang2";
	m_iWalkingStyle		= MOVE_GANG2;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_104 ( skin_base )
{
	m_sName				= "Baller Sweater";
	m_iCost				= 300;
	m_iSkin				= 104;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_105 ( skin_base )
{
	m_sName				= "Grove Sweater";
	m_iCost				= 300;
	m_iSkin				= 105;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang2";
	m_iWalkingStyle		= MOVE_GANG2;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_106 ( skin_base )
{
	m_sName				= "Grove Topbutton";
	m_iCost				= 300;
	m_iSkin				= 106;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_107 ( skin_base )
{
	m_sName				= "Grove Jersey";
	m_iCost				= 300;
	m_iSkin				= 107;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang2";
	m_iWalkingStyle		= MOVE_GANG2;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_108 ( skin_base )
{
	m_sName				= "Vagos Topless";
	m_iCost				= 300;
	m_iSkin				= 108;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_109 ( skin_base )
{
	m_sName				= "Vagos Pants";
	m_iCost				= 300;
	m_iSkin				= 109;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang2";
	m_iWalkingStyle		= MOVE_GANG2;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_110 ( skin_base )
{
	m_sName				= "Vagos Shorts";
	m_iCost				= 300;
	m_iSkin				= 110;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_111 ( skin_base )
{
	m_sName				= "Russian Muscle";
	m_iCost				= 300;
	m_iSkin				= 111;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_112 ( skin_base )
{
	m_sName				= "Russian Hitman";
	m_iCost				= 300;
	m_iSkin				= 112;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_113 ( skin_base )
{
	m_sName				= "Russian Boss";
	m_iCost				= 300;
	m_iSkin				= 113;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_114 ( skin_base )
{
	m_sName				= "Aztecas Stripes";
	m_iCost				= 300;
	m_iSkin				= 114;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_115 ( skin_base )
{
	m_sName				= "Aztecas Jacket";
	m_iCost				= 300;
	m_iSkin				= 115;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang2";
	m_iWalkingStyle		= MOVE_GANG2;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_116 ( skin_base )
{
	m_sName				= "Aztecas Shorts";
	m_iCost				= 300;
	m_iSkin				= 116;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_117 ( skin_base )
{
	m_sName				= "Triad 1";
	m_iCost				= 300;
	m_iSkin				= 117;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_118 ( skin_base )
{
	m_sName				= "Triad 2";
	m_iCost				= 300;
	m_iSkin				= 118;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_120 ( skin_base )
{
	m_sName				= "Sindacco Suit";
	m_iCost				= 300;
	m_iSkin				= 120;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_121 ( skin_base )
{
	m_sName				= "Da Nang Army";
	m_iCost				= 300;
	m_iSkin				= 121;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_122 ( skin_base )
{
	m_sName				= "Da Nang Bandana";
	m_iCost				= 300;
	m_iSkin				= 122;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang2";
	m_iWalkingStyle		= MOVE_GANG2;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_123 ( skin_base )
{
	m_sName				= "Da Nang Shades";
	m_iCost				= 300;
	m_iSkin				= 123;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_124 ( skin_base )
{
	m_sName				= "Sindacco Muscle";
	m_iCost				= 300;
	m_iSkin				= 124;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_125 ( skin_base )
{
	m_sName				= "Mafia Enforcer";
	m_iCost				= 300;
	m_iSkin				= 125;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_126 ( skin_base )
{
	m_sName				= "Mafia Wiseguy";
	m_iCost				= 300;
	m_iSkin				= 126;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_127 ( skin_base )
{
	m_sName				= "Mafia Hitman";
	m_iCost				= 300;
	m_iSkin				= 127;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_128 ( skin_base )
{
	m_sName				= "Native Rancher";
	m_iCost				= 300;
	m_iSkin				= 128;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_129 ( skin_base )
{
	m_sName				= "Native Librarian";
	m_iCost				= 300;
	m_iSkin				= 129;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "oldwoman";
	m_iWalkingStyle		= MOVE_OLDWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_130 ( skin_base )
{
	m_sName				= "Native Ugly";
	m_iCost				= 300;
	m_iSkin				= 130;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "oldwoman";
	m_iWalkingStyle		= MOVE_OLDWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_131 ( skin_base )
{
	m_sName				= "Native Sexy";
	m_iCost				= 300;
	m_iSkin				= 131;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_132 ( skin_base )
{
	m_sName				= "Native Geezer";
	m_iCost				= 300;
	m_iSkin				= 132;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_133 ( skin_base )
{
	m_sName				= "Furys Trucker";
	m_iCost				= 300;
	m_iSkin				= 133;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_134 ( skin_base )
{
	m_sName				= "Homeless Smoker";
	m_iCost				= 300;
	m_iSkin				= 134;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "oldman";
	m_iWalkingStyle		= MOVE_OLDMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_135 ( skin_base )
{
	m_sName				= "Skullcap Hobo";
	m_iCost				= 300;
	m_iSkin				= 135;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_136 ( skin_base )
{
	m_sName				= "Old Rasta";
	m_iCost				= 300;
	m_iSkin				= 136;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_137 ( skin_base )
{
	m_sName				= "Boxhead";
	m_iCost				= 300;
	m_iSkin				= 137;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_138 ( skin_base )
{
	m_sName				= "Bikini Tattoo";
	m_iCost				= 300;
	m_iSkin				= 138;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_139 ( skin_base )
{
	m_sName				= "Yellow Bikini";
	m_iCost				= 300;
	m_iSkin				= 139;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_140 ( skin_base )
{
	m_sName				= "Buxom Bikini";
	m_iCost				= 300;
	m_iSkin				= 140;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_141 ( skin_base )
{
	m_sName				= "Cute Librarian";
	m_iCost				= 300;
	m_iSkin				= 141;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "busywoman";
	m_iWalkingStyle		= MOVE_BUSYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_142 ( skin_base )
{
	m_sName				= "African 1";
	m_iCost				= 300;
	m_iSkin				= 142;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_143 ( skin_base )
{
	m_sName				= "Sam Jackson";
	m_iCost				= 300;
	m_iSkin				= 143;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_144 ( skin_base )
{
	m_sName				= "Drug Worker 1";
	m_iCost				= 300;
	m_iSkin				= 144;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang2";
	m_iWalkingStyle		= MOVE_GANG2;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_145 ( skin_base )
{
	m_sName				= "Drug Worker 2";
	m_iCost				= 300;
	m_iSkin				= 145;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_146 ( skin_base )
{
	m_sName				= "Drug Worker 3";
	m_iCost				= 300;
	m_iSkin				= 146;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_147 ( skin_base )
{
	m_sName				= "Sigmund Freud";
	m_iCost				= 300;
	m_iSkin				= 147;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_148 ( skin_base )
{
	m_sName				= "Businesswoman 2";
	m_iCost				= 300;
	m_iSkin				= 148;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "busywoman";
	m_iWalkingStyle		= MOVE_BUSYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_150 ( skin_base )
{
	m_sName				= "Businesswoman 3";
	m_iCost				= 300;
	m_iSkin				= 150;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "busywoman";
	m_iWalkingStyle		= MOVE_BUSYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_151 ( skin_base )
{
	m_sName				= "Melanie";
	m_iCost				= 300;
	m_iSkin				= 151;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_152 ( skin_base )
{
	m_sName				= "Schoolgirl 1";
	m_iCost				= 300;
	m_iSkin				= 152;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "pro";
	m_iWalkingStyle		= MOVE_PRO;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_153 ( skin_base )
{
	m_sName				= "Foreman";
	m_iCost				= 300;
	m_iSkin				= 153;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_154 ( skin_base )
{
	m_sName				= "Beach Blonde";
	m_iCost				= 300;
	m_iSkin				= 154;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_155 ( skin_base )
{
	m_sName				= "Pizza Guy";
	m_iCost				= 300;
	m_iSkin				= 155;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_156 ( skin_base )
{
	m_sName				= "Old Reece";
	m_iCost				= 300;
	m_iSkin				= 156;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_157 ( skin_base )
{
	m_sName				= "Farmer Girl";
	m_iCost				= 300;
	m_iSkin				= 157;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_158 ( skin_base )
{
	m_sName				= "Farmer";
	m_iCost				= 300;
	m_iSkin				= 158;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_159 ( skin_base )
{
	m_sName				= "Farmer Redneck";
	m_iCost				= 300;
	m_iSkin				= 159;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_160 ( skin_base )
{
	m_sName				= "Bald Redneck";
	m_iCost				= 300;
	m_iSkin				= 160;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "oldman";
	m_iWalkingStyle		= MOVE_OLDMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_161 ( skin_base )
{
	m_sName				= "Smoking Cowboy";
	m_iCost				= 300;
	m_iSkin				= 161;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_162 ( skin_base )
{
	m_sName				= "Inbred";
	m_iCost				= 300;
	m_iSkin				= 162;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "oldman";
	m_iWalkingStyle		= MOVE_OLDMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_163 ( skin_base )
{
	m_sName				= "Casino Bouncer 1";
	m_iCost				= 300;
	m_iSkin				= 163;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_164 ( skin_base )
{
	m_sName				= "Casino Bouncer 2";
	m_iCost				= 300;
	m_iSkin				= 164;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_165 ( skin_base )
{
	m_sName				= "Agent Kay";
	m_iCost				= 300;
	m_iSkin				= 165;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_166 ( skin_base )
{
	m_sName				= "Agent Jay";
	m_iCost				= 300;
	m_iSkin				= 166;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_167 ( skin_base )
{
	m_sName				= "Chicken";
	m_iCost				= 300;
	m_iSkin				= 167;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_168 ( skin_base )
{
	m_sName				= "Hotdog Vender";
	m_iCost				= 300;
	m_iSkin				= 168;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_169 ( skin_base )
{
	m_sName				= "Asian Escort ";
	m_iCost				= 300;
	m_iSkin				= 169;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_170 ( skin_base )
{
	m_sName				= "PubeStache Tshirt";
	m_iCost				= 300;
	m_iSkin				= 170;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_171 ( skin_base )
{
	m_sName				= "Card Dealer 2";
	m_iCost				= 300;
	m_iSkin				= 171;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_172 ( skin_base )
{
	m_sName				= "Card Dealer 3";
	m_iCost				= 300;
	m_iSkin				= 172;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "busywoman";
	m_iWalkingStyle		= MOVE_BUSYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_173 ( skin_base )
{
	m_sName				= "Rifa Hat";
	m_iCost				= 300;
	m_iSkin				= 173;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_174 ( skin_base )
{
	m_sName				= "Rifa Vest";
	m_iCost				= 300;
	m_iSkin				= 174;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang2";
	m_iWalkingStyle		= MOVE_GANG2;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_175 ( skin_base )
{
	m_sName				= "Rifa Suspenders";
	m_iCost				= 300;
	m_iSkin				= 175;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_176 ( skin_base )
{
	m_sName				= "Style Barber";
	m_iCost				= 300;
	m_iSkin				= 176;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_177 ( skin_base )
{
	m_sName				= "Vanilla Ice Barber";
	m_iCost				= 300;
	m_iSkin				= 177;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_178 ( skin_base )
{
	m_sName				= "Masked Stripper";
	m_iCost				= 300;
	m_iSkin				= 178;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_179 ( skin_base )
{
	m_sName				= "War Vet";
	m_iCost				= 300;
	m_iSkin				= 179;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_180 ( skin_base )
{
	m_sName				= "Bball Player";
	m_iCost				= 300;
	m_iSkin				= 180;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_181 ( skin_base )
{
	m_sName				= "Punk";
	m_iCost				= 300;
	m_iSkin				= 181;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_182 ( skin_base )
{
	m_sName				= "Pajama Man 2";
	m_iCost				= 300;
	m_iSkin				= 182;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_183 ( skin_base )
{
	m_sName				= "Klingon";
	m_iCost				= 300;
	m_iSkin				= 183;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_184 ( skin_base )
{
	m_sName				= "Neckbeard";
	m_iCost				= 300;
	m_iSkin				= 184;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_185 ( skin_base )
{
	m_sName				= "Nervous Guy";
	m_iCost				= 300;
	m_iSkin				= 185;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_186 ( skin_base )
{
	m_sName				= "Teacher";
	m_iCost				= 300;
	m_iSkin				= 186;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_187 ( skin_base )
{
	m_sName				= "Japanese Businessman 1";
	m_iCost				= 300;
	m_iSkin				= 187;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_188 ( skin_base )
{
	m_sName				= "Green Shirt";
	m_iCost				= 300;
	m_iSkin				= 188;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_189 ( skin_base )
{
	m_sName				= "Valet";
	m_iCost				= 300;
	m_iSkin				= 189;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_190 ( skin_base )
{
	m_sName				= "Barbara Schternvart";
	m_iCost				= 300;
	m_iSkin				= 190;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "busywoman";
	m_iWalkingStyle		= MOVE_BUSYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_191 ( skin_base )
{
	m_sName				= "Helena Wankstein";
	m_iCost				= 300;
	m_iSkin				= 191;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_192 ( skin_base )
{
	m_sName				= "Michelle Cannes";
	m_iCost				= 300;
	m_iSkin				= 192;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_193 ( skin_base )
{
	m_sName				= "Katie Zhan";
	m_iCost				= 300;
	m_iSkin				= 193;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_194 ( skin_base )
{
	m_sName				= "Millie Perkins";
	m_iCost				= 300;
	m_iSkin				= 194;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_195 ( skin_base )
{
	m_sName				= "Denise Robinson";
	m_iCost				= 300;
	m_iSkin				= 195;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_196 ( skin_base )
{
	m_sName				= "Aunt May";
	m_iCost				= 300;
	m_iSkin				= 196;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "oldwoman";
	m_iWalkingStyle		= MOVE_OLDWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_197 ( skin_base )
{
	m_sName				= "Smoking Maid";
	m_iCost				= 300;
	m_iSkin				= 197;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "oldwoman";
	m_iWalkingStyle		= MOVE_OLDWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_198 ( skin_base )
{
	m_sName				= "Ranch Cowgirl";
	m_iCost				= 300;
	m_iSkin				= 198;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_199 ( skin_base )
{
	m_sName				= "Heidi";
	m_iCost				= 300;
	m_iSkin				= 199;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_200 ( skin_base )
{
	m_sName				= "Hairy Redneck";
	m_iCost				= 300;
	m_iSkin				= 200;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_201 ( skin_base )
{
	m_sName				= "Trucker Girl";
	m_iCost				= 300;
	m_iSkin				= 201;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_202 ( skin_base )
{
	m_sName				= "Beer Trucker";
	m_iCost				= 300;
	m_iSkin				= 202;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_203 ( skin_base )
{
	m_sName				= "Ninja 1";
	m_iCost				= 300;
	m_iSkin				= 203;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_204 ( skin_base )
{
	m_sName				= "Ninja 2";
	m_iCost				= 300;
	m_iSkin				= 204;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_205 ( skin_base )
{
	m_sName				= "Burger Girl";
	m_iCost				= 300;
	m_iSkin				= 205;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_206 ( skin_base )
{
	m_sName				= "Money Trucker";
	m_iCost				= 300;
	m_iSkin				= 206;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_207 ( skin_base )
{
	m_sName				= "Grove Booty";
	m_iCost				= 300;
	m_iSkin				= 207;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "pro";
	m_iWalkingStyle		= MOVE_PRO;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_209 ( skin_base )
{
	m_sName				= "Noodle Vender";
	m_iCost				= 300;
	m_iSkin				= 209;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "oldman";
	m_iWalkingStyle		= MOVE_OLDMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_210 ( skin_base )
{
	m_sName				= "Sloppy Tourist";
	m_iCost				= 300;
	m_iSkin				= 210;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "oldman";
	m_iWalkingStyle		= MOVE_OLDMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_211 ( skin_base )
{
	m_sName				= "Staff Girl";
	m_iCost				= 300;
	m_iSkin				= 211;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_212 ( skin_base )
{
	m_sName				= "Tin Foil Hat";
	m_iCost				= 300;
	m_iSkin				= 212;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_213 ( skin_base )
{
	m_sName				= "Hobo Elvis";
	m_iCost				= 300;
	m_iSkin				= 213;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_214 ( skin_base )
{
	m_sName				= "Caligula Waitress";
	m_iCost				= 300;
	m_iSkin				= 214;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_215 ( skin_base )
{
	m_sName				= "Explorer";
	m_iCost				= 300;
	m_iSkin				= 215;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_216 ( skin_base )
{
	m_sName				= "Turtleneck";
	m_iCost				= 300;
	m_iSkin				= 216;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_217 ( skin_base )
{
	m_sName				= "Staff Guy";
	m_iCost				= 300;
	m_iSkin				= 217;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_218 ( skin_base )
{
	m_sName				= "Old Woman";
	m_iCost				= 300;
	m_iSkin				= 218;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_219 ( skin_base )
{
	m_sName				= "Lady In Red";
	m_iCost				= 300;
	m_iSkin				= 219;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_220 ( skin_base )
{
	m_sName				= "African 2";
	m_iCost				= 300;
	m_iSkin				= 220;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_221 ( skin_base )
{
	m_sName				= "Beardo Casual";
	m_iCost				= 300;
	m_iSkin				= 221;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_222 ( skin_base )
{
	m_sName				= "Beardo Clubbing";
	m_iCost				= 300;
	m_iSkin				= 222;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_223 ( skin_base )
{
	m_sName				= "Greasy Nightclubber";
	m_iCost				= 300;
	m_iSkin				= 223;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_224 ( skin_base )
{
	m_sName				= "Elderly Asian 1";
	m_iCost				= 300;
	m_iSkin				= 224;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_225 ( skin_base )
{
	m_sName				= "Elderly Asian 2";
	m_iCost				= 300;
	m_iSkin				= 225;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_226 ( skin_base )
{
	m_sName				= "Legwarmers 2";
	m_iCost				= 300;
	m_iSkin				= 226;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_227 ( skin_base )
{
	m_sName				= "Japanese Businessman 2";
	m_iCost				= 300;
	m_iSkin				= 227;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_228 ( skin_base )
{
	m_sName				= "Japanese Businessman 3";
	m_iCost				= 300;
	m_iSkin				= 228;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_229 ( skin_base )
{
	m_sName				= "Asian Tourist";
	m_iCost				= 300;
	m_iSkin				= 229;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_230 ( skin_base )
{
	m_sName				= "Hooded Hobo";
	m_iCost				= 300;
	m_iSkin				= 230;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_231 ( skin_base )
{
	m_sName				= "Grannie";
	m_iCost				= 300;
	m_iSkin				= 231;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_232 ( skin_base )
{
	m_sName				= "Grouchy lady";
	m_iCost				= 300;
	m_iSkin				= 232;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_233 ( skin_base )
{
	m_sName				= "Hoop Earrings 2";
	m_iCost				= 300;
	m_iSkin				= 233;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_234 ( skin_base )
{
	m_sName				= "Buzzcut";
	m_iCost				= 300;
	m_iSkin				= 234;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_235 ( skin_base )
{
	m_sName				= "Retired Tourist";
	m_iCost				= 300;
	m_iSkin				= 235;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_236 ( skin_base )
{
	m_sName				= "Happy Old Man";
	m_iCost				= 300;
	m_iSkin				= 236;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_237 ( skin_base )
{
	m_sName				= "Leopard Hooker";
	m_iCost				= 300;
	m_iSkin				= 237;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "pro";
	m_iWalkingStyle		= MOVE_PRO;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_238 ( skin_base )
{
	m_sName				= "Amazon";
	m_iCost				= 300;
	m_iSkin				= 238;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "pro";
	m_iWalkingStyle		= MOVE_PRO;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_239 ( skin_base )
{
	m_sName				= "invalid skin 239";
	m_iCost				= 300;
	m_iSkin				= 239;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_240 ( skin_base )
{
	m_sName				= "Hugh Grant";
	m_iCost				= 300;
	m_iSkin				= 240;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_241 ( skin_base )
{
	m_sName				= "Afro Brother";
	m_iCost				= 300;
	m_iSkin				= 241;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_242 ( skin_base )
{
	m_sName				= "Dreadlock Brother";
	m_iCost				= 300;
	m_iSkin				= 242;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_243 ( skin_base )
{
	m_sName				= "Ghetto Booty";
	m_iCost				= 300;
	m_iSkin				= 243;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "pro";
	m_iWalkingStyle		= MOVE_PRO;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_244 ( skin_base )
{
	m_sName				= "Lace Stripper";
	m_iCost				= 300;
	m_iSkin				= 244;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_245 ( skin_base )
{
	m_sName				= "Ghetto Ho";
	m_iCost				= 300;
	m_iSkin				= 245;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "pro";
	m_iWalkingStyle		= MOVE_PRO;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_246 ( skin_base )
{
	m_sName				= "Cop Stripper";
	m_iCost				= 300;
	m_iSkin				= 246;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_247 ( skin_base )
{
	m_sName				= "Biker Vest";
	m_iCost				= 300;
	m_iSkin				= 247;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_248 ( skin_base )
{
	m_sName				= "Biker Headband";
	m_iCost				= 300;
	m_iSkin				= 248;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_249 ( skin_base )
{
	m_sName				= "Pimp";
	m_iCost				= 300;
	m_iSkin				= 249;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_250 ( skin_base )
{
	m_sName				= "Green Tshirt";
	m_iCost				= 300;
	m_iSkin				= 250;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_251 ( skin_base )
{
	m_sName				= "Lifeguard";
	m_iCost				= 300;
	m_iSkin				= 251;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_252 ( skin_base )
{
	m_sName				= "Naked Freak";
	m_iCost				= 300;
	m_iSkin				= 252;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_253 ( skin_base )
{
	m_sName				= "Bus Driver";
	m_iCost				= 300;
	m_iSkin				= 253;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_254 ( skin_base )
{
	m_sName				= "Biker Vest b";
	m_iCost				= 300;
	m_iSkin				= 254;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_255 ( skin_base )
{
	m_sName				= "Limo Driver";
	m_iCost				= 300;
	m_iSkin				= 255;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_256 ( skin_base )
{
	m_sName				= "Shoolgirl 2";
	m_iCost				= 300;
	m_iSkin				= 256;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_290 ( skin_base )
{
	m_sName				= "Rose";
	m_iCost				= 300;
	m_iSkin				= 290;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_291 ( skin_base )
{
	m_sName				= "Kent Paul";
	m_iCost				= 300;
	m_iSkin				= 291;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_292 ( skin_base )
{
	m_sName				= "Cesar";
	m_iCost				= 300;
	m_iSkin				= 292;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_293 ( skin_base )
{
	m_sName				= "OG Loc";
	m_iCost				= 300;
	m_iSkin				= 293;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang2";
	m_iWalkingStyle		= MOVE_GANG2;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_294 ( skin_base )
{
	m_sName				= "Wuzi Mu";
	m_iCost				= 300;
	m_iSkin				= 294;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "blindman";
	m_iWalkingStyle		= MOVE_BLINDMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_295 ( skin_base )
{
	m_sName				= "Mike Toreno";
	m_iCost				= 300;
	m_iSkin				= 295;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_296 ( skin_base )
{
	m_sName				= "Jizzy";
	m_iCost				= 300;
	m_iSkin				= 296;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_297 ( skin_base )
{
	m_sName				= "Madd Dogg";
	m_iCost				= 300;
	m_iSkin				= 297;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_298 ( skin_base )
{
	m_sName				= "Catalina";
	m_iCost				= 300;
	m_iSkin				= 298;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_299 ( skin_base )
{
	m_sName				= "Claude";
	m_iCost				= 300;
	m_iSkin				= 299;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_300 ( skin_base )
{
	m_sName				= "Ryder";
	m_iCost				= 300;
	m_iSkin				= 300;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_301 ( skin_base )
{
	m_sName				= "Ryder Robber";
	m_iCost				= 300;
	m_iSkin				= 301;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_302 ( skin_base )
{
	m_sName				= "Emmet";
	m_iCost				= 300;
	m_iSkin				= 302;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_303 ( skin_base )
{
	m_sName				= "Andre";
	m_iCost				= 300;
	m_iSkin				= 303;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_304 ( skin_base )
{
	m_sName				= "Kendl";
	m_iCost				= 300;
	m_iSkin				= 304;
	m_sGender			= "female";
	m_sColor			= "black";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_305 ( skin_base )
{
	m_sName				= "Jethro";
	m_iCost				= 300;
	m_iSkin				= 305;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_306 ( skin_base )
{
	m_sName				= "Zero";
	m_iCost				= 300;
	m_iSkin				= 306;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_307 ( skin_base )
{
	m_sName				= "T-bone Mendez";
	m_iCost				= 300;
	m_iSkin				= 307;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_308 ( skin_base )
{
	m_sName				= "Sindaco Guy";
	m_iCost				= 300;
	m_iSkin				= 308;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_309 ( skin_base )
{
	m_sName				= "Janitor";
	m_iCost				= 300;
	m_iSkin				= 309;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_310 ( skin_base )
{
	m_sName				= "Big Bear";
	m_iCost				= 300;
	m_iSkin				= 310;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_311 ( skin_base )
{
	m_sName				= "Big Smoke Vest";
	m_iCost				= 300;
	m_iSkin				= 311;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "fatman";
	m_iWalkingStyle		= MOVE_FATMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_312 ( skin_base )
{
	m_sName				= "Physco";
	m_iCost				= 300;
	m_iSkin				= 312;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_257 ( skin_base )
{
	m_sName				= "Bondage Girl";
	m_iCost				= 300;
	m_iSkin				= 257;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "sexywoman";
	m_iWalkingStyle		= MOVE_SEXYWOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_258 ( skin_base )
{
	m_sName				= "Joe Pesci";
	m_iCost				= 300;
	m_iSkin				= 258;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_259 ( skin_base )
{
	m_sName				= "Chris Penn";
	m_iCost				= 300;
	m_iSkin				= 259;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_260 ( skin_base )
{
	m_sName				= "Construction 2";
	m_iCost				= 300;
	m_iSkin				= 260;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_261 ( skin_base )
{
	m_sName				= "Southerner";
	m_iCost				= 300;
	m_iSkin				= 261;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_262 ( skin_base )
{
	m_sName				= "Pajama Man 2 b";
	m_iCost				= 300;
	m_iSkin				= 262;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_263 ( skin_base )
{
	m_sName				= "Asian Hostess";
	m_iCost				= 300;
	m_iSkin				= 263;
	m_sGender			= "female";
	m_sColor			= "white";
	m_sAnimGroup		= "woman";
	m_iWalkingStyle		= MOVE_WOMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_264 ( skin_base )
{
	m_sName				= "Whoopee the Clown";
	m_iCost				= 300;
	m_iSkin				= 264;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_265 ( skin_base )
{
	m_sName				= "Tenpenny";
	m_iCost				= 300;
	m_iSkin				= 265;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_266 ( skin_base )
{
	m_sName				= "Pulaski";
	m_iCost				= 300;
	m_iSkin				= 266;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_267 ( skin_base )
{
	m_sName				= "Hern";
	m_iCost				= 300;
	m_iSkin				= 267;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_268 ( skin_base )
{
	m_sName				= "Dwayne";
	m_iCost				= 300;
	m_iSkin				= 268;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_269 ( skin_base )
{
	m_sName				= "Big Smoke";
	m_iCost				= 300;
	m_iSkin				= 269;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "fatman";
	m_iWalkingStyle		= MOVE_FATMAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_270 ( skin_base )
{
	m_sName				= "Sweet";
	m_iCost				= 300;
	m_iSkin				= 270;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang2";
	m_iWalkingStyle		= MOVE_GANG2;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_271 ( skin_base )
{
	m_sName				= "Ryder";
	m_iCost				= 300;
	m_iSkin				= 271;
	m_sGender			= "male";
	m_sColor			= "black";
	m_sAnimGroup		= "gang1";
	m_iWalkingStyle		= MOVE_GANG1;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_272 ( skin_base )
{
	m_sName				= "Forelli Guy";
	m_iCost				= 300;
	m_iSkin				= 272;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "man";
	m_iWalkingStyle		= MOVE_MAN;
	m_bSpecial			= false;
	m_bHaveArmor		= false;
};

class: skin_274 ( skin_base )
{
	m_sName				= "Medic 1";
	m_iCost				= 300;
	m_iSkin				= 274;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "swat";
	m_iWalkingStyle		= MOVE_SWAT;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_275 ( skin_base )
{
	m_sName				= "Medic 2";
	m_iCost				= 300;
	m_iSkin				= 275;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "swat";
	m_iWalkingStyle		= MOVE_SWAT;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_276 ( skin_base )
{
	m_sName				= "Medic 3";
	m_iCost				= 300;
	m_iSkin				= 276;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "swat";
	m_iWalkingStyle		= MOVE_SWAT;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_280 ( skin_base )
{
	m_sName				= "Cop 1";
	m_iCost				= 300;
	m_iSkin				= 280;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "swat";
	m_iWalkingStyle		= MOVE_SWAT;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_281 ( skin_base )
{
	m_sName				= "Cop 2";
	m_iCost				= 300;
	m_iSkin				= 281;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "swat";
	m_iWalkingStyle		= MOVE_SWAT;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_282 ( skin_base )
{
	m_sName				= "Cop 3";
	m_iCost				= 300;
	m_iSkin				= 282;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "swat";
	m_iWalkingStyle		= MOVE_SWAT;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_283 ( skin_base )
{
	m_sName				= "Cop 4";
	m_iCost				= 300;
	m_iSkin				= 283;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "swat";
	m_iWalkingStyle		= MOVE_SWAT;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_284 ( skin_base )
{
	m_sName				= "Cop 5";
	m_iCost				= 300;
	m_iSkin				= 284;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "swat";
	m_iWalkingStyle		= MOVE_SWAT;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_285 ( skin_base )
{
	m_sName				= "SWAT";
	m_iCost				= 300;
	m_iSkin				= 285;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "swat";
	m_iWalkingStyle		= MOVE_SWAT;
	m_bSpecial			= true;
	m_bHaveArmor		= true;
};

class: skin_286 ( skin_base )
{
	m_sName				= "FBI";
	m_iCost				= 300;
	m_iSkin				= 286;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "swat";
	m_iWalkingStyle		= MOVE_SWAT;
	m_bSpecial			= true;
	m_bHaveArmor		= false;
};

class: skin_287 ( skin_base )
{
	m_sName				= "FBI SWAT";
	m_iCost				= 300;
	m_iSkin				= 287;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "swat";
	m_iWalkingStyle		= MOVE_SWAT;
	m_bSpecial			= true;
	m_bHaveArmor		= true;
};

class: skin_288 ( skin_base )
{
	m_sName				= "Army";
	m_iCost				= 300;
	m_iSkin				= 288;
	m_sGender			= "male";
	m_sColor			= "white";
	m_sAnimGroup		= "swat";
	m_iWalkingStyle		= MOVE_SWAT;
	m_bSpecial			= true;
	m_bHaveArmor		= true;
};
