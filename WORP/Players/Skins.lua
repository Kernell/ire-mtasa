-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local SKINS =
{
	male =
	{ 
		black =
		{
			7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 24, 25, 28, 51, 66, 67, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 
			156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262, 293, 296, 297, 300, 301, 302, 310, 311, 265, 269, 270, 271
		};
		white = 
		{
			1, 2, 23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 52, 57, 58, 59, 60, 61, 62, 68, 70, 71, 72, 73, 78, 81, 82, 
			94, 95, 96, 97, 98, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133,
			135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 167, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 
			189, 200, 202, 203, 204, 206, 209, 210, 212, 213, 217, 223, 227, 228, 229, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 250, 252, 254, 
			255, 258, 259, 261, 264, 274, 275, 276, 290, 291, 292, 294, 295, 299, 303, 305, 306, 307, 308, 309, 310, 311,
			280, 281, 282, 283, 284, 285, 286, 287, 288,
			266, 267, 268, 272, 291, 292, 294, 295, 298, 299, 303, 305, 306, 307, 308, 309, 312
		};
	};
	female =
	{
		black = 
		{ 
			9, 10, 11, 13, 63, 69, 76, 139, 148, 190, 195, 207, 215, 218, 219, 238, 244, 245, 256, 304
		};
		white = 
		{ 
			12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 87, 88, 89, 90, 91, 93, 129, 130, 131, 138, 140, 141, 145, 150, 151, 152, 157,
			169, 172, 178, 191, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263,
			298
		};
	};
};

local SKIN_NAMES =
{
	[0] = "CJ";
	[1] = "Truth";
	[2] = "Maccer";
	[7] = "Casual Jeanjacket";
	[9] = "Business Lady";
	[10] = "Old Fat Lady";
	[11] = "Card Dealer 1";
	[12] = "Classy Gold Hooker";
	[13] = "Homegirl";
	[14] = "Floral Shirt";
	[15] = "Plaid Baldy";
	[16] = "Earmuff Worker";
	[17] = "Black suit";
	[18] = "Black Beachguy";
	[19] = "Beach Gangsta";
	[20] = "Fresh Prince";
	[21] = "Striped Gangsta";
	[22] = "Orange Sportsman";
	[23] = "Skater Kid";
	[24] = "LS Coach";
	[25] = "Varsity jacket";
	[26] = "Hiker";
	[27] = "Construction 1";
	[28] = "Black Dealer";
	[29] = "White Dealer";
	[30] = "Religious Essey";
	[31] = "Fat Cowgirl";
	[32] = "Eyepatch";
	[33] = "Bounty Hunter";
	[34] = "Marlboro Man";
	[35] = "Fisherman";
	[36] = "Mailman";
	[37] = "Baseball Dad";
	[38] = "Old Golf Lady";
	[39] = "Old Maid";
	[40] = "Classy Dark Hooker";
	[41] = "Tracksuit Girl";
	[43] = "Porn Producer";
	[44] = "Tatooed Plaid";
	[45] = "Beach Mustache";
	[46] = "Dark Romeo";
	[47] = "Top Button Essey";
	[48] = "Top Button Essey 2";
	[49] = "Ninja Sensei";
	[50] = "Mechanic";
	[51] = "Black Bicyclist";
	[52] = "White Bicyclist";
	[53] = "Golf Lady";
	[54] = "Hispanic Woman";
	[55] = "Rich Bitch";
	[56] = "Legwarmers 1";
	[57] = "Chinese Businessman";
	[58] = "Chinese Plaid";
	[59] = "Chinese Romeo";
	[60] = "Chinese Casual";
	[61] = "Pilot";
	[62] = "Pajama Man 1";
	[63] = "Trashy Hooker";
	[64] = "Transvestite";
	[66] = "Varsity Bandits";
	[67] = "Red Bandana";
	[68] = "Preist";
	[69] = "Denim Girl";
	[70] = "Scientist";
	[71] = "Security Guard";
	[72] = "Bearded Hippie";
	[73] = "Flag Bandana";
	[75] = "Skanky Hooker";
	[76] = "Businesswoman 1";
	[77] = "Bag Lady";
	[78] = "Homeless Scarf";
	[79] = "Fat Homeless";
	[80] = "Red Boxer";
	[81] = "Blue Boxer";
	[82] = "Fatty Elvis";
	[83] = "Whitesuit Elvis";
	[84] = "Bluesuit Elvis";
	[85] = "Furcoat Hooker";
	[87] = "Firecrotch";
	[88] = "Casual Old Lady";
	[89] = "Cleaning Lady";
	[90] = "Barely Covered";
	[91] = "Sharon Stone";
	[92] = "Rollergirl";
	[93] = "Hoop Earrings 1";
	[94] = "Andy Capp";
	[95] = "Poor Old Man";
	[96] = "Soccer Player";
	[97] = "Baywatch Dude";
	[98] = "Dark Nightclubber";
	[99] = "Rollerguy";
	[100] = "Biker Blackshirt";
	[101] = "Jacket Hippie";
	[102] = "Baller Shirt";
	[103] = "Baller Jacket";
	[104] = "Baller Sweater";
	[105] = "Grove Sweater";
	[106] = "Grove Topbutton";
	[107] = "Grove Jersey";
	[108] = "Vagos Topless";
	[109] = "Vagos Pants";
	[110] = "Vagos Shorts";
	[111] = "Russian Muscle";
	[112] = "Russian Hitman";
	[113] = "Russian Boss";
	[114] = "Aztecas Stripes";
	[115] = "Aztecas Jacket";
	[116] = "Aztecas Shorts";
	[117] = "Triad 1";
	[118] = "Triad 2";
	[119] = "Triad 3";
	[120] = "Sindacco Suit";
	[121] = "Da Nang Army";
	[122] = "Da Nang Bandana";
	[123] = "Da Nang Shades";
	[124] = "Sindacco Muscle";
	[125] = "Mafia Enforcer";
	[126] = "Mafia Wiseguy";
	[127] = "Mafia Hitman";
	[128] = "Native Rancher";
	[129] = "Native Librarian";
	[130] = "Native Ugly";
	[131] = "Native Sexy";
	[132] = "Native Geezer";
	[133] = "Furys Trucker";
	[134] = "Homeless Smoker";
	[135] = "Skullcap Hobo";
	[136] = "Old Rasta";
	[137] = "Boxhead";
	[138] = "Bikini Tattoo";
	[139] = "Yellow Bikini";
	[140] = "Buxom Bikini";
	[141] = "Cute Librarian";
	[142] = "African 1";
	[143] = "Sam Jackson";
	[144] = "Drug Worker 1";
	[145] = "Drug Worker 2";
	[146] = "Drug Worker 3";
	[147] = "Sigmund Freud";
	[148] = "Businesswoman 2";
	[149] = "Businesswoman 2 b";
	[150] = "Businesswoman 3";
	[151] = "Melanie";
	[152] = "Schoolgirl 1";
	[153] = "Foreman";
	[154] = "Beach Blonde";
	[155] = "Pizza Guy";
	[156] = "Old Reece";
	[157] = "Farmer Girl";
	[158] = "Farmer";
	[159] = "Farmer Redneck";
	[160] = "Bald Redneck";
	[161] = "Smoking Cowboy";
	[162] = "Inbred";
	[163] = "Casino Bouncer 1";
	[164] = "Casino Bouncer 2";
	[165] = "Agent Kay";
	[166] = "Agent Jay";
	[167] = "Chicken";
	[168] = "Hotdog Vender";
	[169] = "Asian Escort ";
	[170] = "PubeStache Tshirt";
	[171] = "Card Dealer 2";
	[172] = "Card Dealer 3";
	[173] = "Rifa Hat";
	[174] = "Rifa Vest";
	[175] = "Rifa Suspenders";
	[176] = "Style Barber";
	[177] = "Vanilla Ice Barber";
	[178] = "Masked Stripper";
	[179] = "War Vet";
	[180] = "Bball Player";
	[181] = "Punk";
	[182] = "Pajama Man 2";
	[183] = "Klingon";
	[184] = "Neckbeard";
	[185] = "Nervous Guy";
	[186] = "Teacher";
	[187] = "Japanese Businessman 1";
	[188] = "Green Shirt";
	[189] = "Valet";
	[190] = "Barbara Schternvart";
	[191] = "Helena Wankstein";
	[192] = "Michelle Cannes";
	[193] = "Katie Zhan";
	[194] = "Millie Perkins";
	[195] = "Denise Robinson";
	[196] = "Aunt May";
	[197] = "Smoking Maid";
	[198] = "Ranch Cowgirl";
	[199] = "Heidi";
	[200] = "Hairy Redneck";
	[201] = "Trucker Girl";
	[202] = "Beer Trucker";
	[203] = "Ninja 1";
	[204] = "Ninja 2";
	[205] = "Burger Girl";
	[206] = "Money Trucker";
	[207] = "Grove Booty";
	[209] = "Noodle Vender";
	[210] = "Sloppy Tourist";
	[211] = "Staff Girl";
	[212] = "Tin Foil Hat";
	[213] = "Hobo Elvis";
	[214] = "Caligula Waitress";
	[215] = "Explorer";
	[216] = "Turtleneck";
	[217] = "Staff Guy";
	[218] = "Old Woman";
	[219] = "Lady In Red";
	[220] = "African 2";
	[221] = "Beardo Casual";
	[222] = "Beardo Clubbing";
	[223] = "Greasy Nightclubber";
	[224] = "Elderly Asian 1";
	[225] = "Elderly Asian 2";
	[226] = "Legwarmers 2";
	[227] = "Japanese Businessman 2";
	[228] = "Japanese Businessman 3";
	[229] = "Asian Tourist";
	[230] = "Hooded Hobo";
	[231] = "Grannie";
	[232] = "Grouchy lady";
	[233] = "Hoop Earrings 2";
	[234] = "Buzzcut";
	[235] = "Retired Tourist";
	[236] = "Happy Old Man";
	[237] = "Leopard Hooker";
	[238] = "Amazon";
	[240] = "Hugh Grant";
	[241] = "Afro Brother";
	[242] = "Dreadlock Brother";
	[243] = "Ghetto Booty";
	[244] = "Lace Stripper";
	[245] = "Ghetto Ho";
	[246] = "Cop Stripper";
	[247] = "Biker Vest";
	[248] = "Biker Headband";
	[249] = "Pimp";
	[250] = "Green Tshirt";
	[251] = "Lifeguard";
	[252] = "Naked Freak";
	[253] = "Bus Driver";
	[254] = "Biker Vest b";
	[255] = "Limo Driver";
	[256] = "Shoolgirl 2";
	[257] = "Bondage Girl";
	[258] = "Joe Pesci";
	[259] = "Chris Penn";
	[260] = "Construction 2";
	[261] = "Southerner";
	[262] = "Pajama Man 2 b";
	[263] = "Asian Hostess";
	[264] = "Whoopee the Clown";
	[265] = "Tenpenny";
	[266] = "Pulaski";
	[267] = "Hern";
	[268] = "Dwayne";
	[269] = "Big Smoke";
	[270] = "Sweet";
	[271] = "Ryder";
	[272] = "Forelli Guy";
	[274] = "Medic 1";
	[275] = "Medic 2";
	[276] = "Medic 3";
	[277] = "Fireman LS";
	[278] = "Fireman LV";
	[279] = "Fireman SF";
	[280] = "Cop 1";
	[281] = "Cop 2";
	[282] = "Cop 3";
	[283] = "Cop 4";
	[284] = "Cop 5";
	[285] = "SWAT";
	[286] = "FBI";
	[287] = "FBI SWAT";
	[288] = "Army";
	[290] = "Rose";
	[291] = "Kent Paul";
	[292] = "Cesar";
	[293] = "OG Loc";
	[294] = "Wuzi Mu";
	[295] = "Mike Toreno";
	[296] = "Jizzy";
	[297] = "Madd Dogg";
	[298] = "Catalina";
	[299] = "Claude";
	[300] = "Ryder";
	[301] = "Ryder Robber";
	[302] = "Emmet";
	[303] = "Andre";
	[304] = "Kendl";
	[305] = "Jethro";
	[306] = "Zero";
	[307] = "T-bone Mendez";
	[308] = "Sindaco Guy";
	[309] = "Janitor";
	[310] = "Big Bear";
	[311] = "Big Smoke Vest";
	[312] = "Physco";
};

local SKIN_ANIM_GROUPS = -- from peds.ide
{
	[0] = 'player';		
	[1] = 'man';		
	[2] = 'man';		
	[7] = 'man';
	[9] = "woman";
	[10] = "oldfatwoman";
	[11] = "woman";
	[12] = "sexywoman";
	[13] = "woman";
	[14] = "man";
	[15] = "man";
	[16] = "man";
	[17] = "man";
	[18] = "man";
	[19] = "gang1";
	[20] = "man";
	[21] = "gang1";
	[22] = "gang2";
	[23] = "man";
	[24] = "man";
	[25] = "man";
	[26] = "man";
	[27] = "man";
	[28] = "gang2";
	[29] = "man";
	[30] = "man";
	[31] = "oldfatwoman";
	[32] = "man";
	[33] = "man";
	[34] = "man";
	[35] = "man";
	[36] = "man";
	[37] = "man";
	[38] = "woman";
	[39] = "oldfatwoman";
	[40] = "sexywoman";
	[41] = "woman";
	[43] = "man";
	[44] = "man";
	[45] = "man";
	[46] = "man";
	[47] = "man";
	[48] = "man";
	[49] = "oldman";
	[50] = "man";
	[51] = "man";
	[52] = "man";
	[53] = "oldwoman";
	[54] = "oldwoman";
	[55] = "woman";
	[56] = "woman";
	[57] = "man";
	[58] = "man";
	[59] = "man";
	[60] = "man";
	[61] = "man";
	[62] = "oldman";
	[63] = "pro";
	[64] = "pro";
	[66] = "man";
	[67] = "man";
	[68] = "man";
	[69] = "woman";
	[70] = "man";
	[71] = "man";
	[72] = "man";
	[73] = "man";
	[75] = "pro";
	[76] = "sexywoman";
	[77] = "man";
	[78] = "man";
	[79] = "man";
	[80] = "man";
	[81] = "man";
	[82] = "man";
	[83] = "man";
	[84] = "man";
	[85] = "pro";
	[87] = "sexywoman";
	[88] = "oldwoman";
	[89] = "oldfatwoman";
	[90] = "jogwoman";
	[91] = "sexywoman";
	[92] = "skate";
	[93] = "sexywoman";
	[94] = "man";
	[95] = "man";
	[96] = "jogger";
	[97] = "jogger";
	[98] = "man";
	[99] = "skate";
	[100] = "man";
	[101] = "man";
	[102] = "gang1";
	[103] = "gang2";
	[104] = "gang1";
	[105] = "gang2";
	[106] = "gang1";
	[107] = "gang2";
	[108] = "gang1";
	[109] = "gang2";
	[110] = "gang1";
	[111] = "man";
	[112] = "man";
	[113] = "man";
	[114] = "gang1";
	[115] = "gang2";
	[116] = "gang1";
	[117] = "man";
	[118] = "man";
	[120] = "man";
	[121] = "gang1";
	[122] = "gang2";
	[123] = "gang1";
	[124] = "gang1";
	[125] = "man";
	[126] = "man";
	[127] = "man";
	[128] = "man";
	[129] = "oldwoman";
	[130] = "oldwoman";
	[131] = "sexywoman";
	[132] = "man";
	[133] = "man";
	[134] = "oldman";
	[135] = "man";
	[136] = "man";
	[137] = "man";
	[138] = "woman";
	[139] = "woman";
	[140] = "woman";
	[141] = "busywoman";
	[142] = "man";
	[143] = "gang1";
	[144] = "gang2";
	[145] = "woman";
	[146] = "man";
	[147] = "man";
	[148] = "busywoman";
	[150] = "busywoman";
	[151] = "sexywoman";
	[152] = "pro";
	[153] = "man";
	[154] = "man";
	[155] = "man";
	[156] = "man";
	[157] = "woman";
	[158] = "man";
	[159] = "man";
	[160] = "oldman";
	[161] = "man";
	[162] = "oldman";
	[163] = "man";
	[164] = "man";
	[165] = "man";
	[166] = "man";
	[167] = "man";
	[168] = "man";
	[169] = "sexywoman";
	[170] = "man";
	[171] = "man";
	[172] = "busywoman";
	[173] = "gang1";
	[174] = "gang2";
	[175] = "gang1";
	[176] = "man";
	[177] = "man";
	[178] = "sexywoman";
	[179] = "man";
	[180] = "man";
	[181] = "man";
	[182] = "man";
	[183] = "man";
	[184] = "man";
	[185] = "man";
	[186] = "man";
	[187] = "man";
	[188] = "man";
	[189] = "man";
	[190] = "busywoman";
	[191] = "woman";
	[192] = "sexywoman";
	[193] = "sexywoman";
	[194] = "sexywoman";
	[195] = "woman";
	[196] = "oldwoman";
	[197] = "oldwoman";
	[198] = "woman";
	[199] = "woman";
	[200] = "man";
	[201] = "woman";
	[202] = "man";
	[203] = "man";
	[204] = "man";
	[205] = "woman";
	[206] = "man";
	[207] = "pro";
	[209] = "oldman";
	[210] = "oldman";
	[211] = "woman";
	[212] = "man";
	[213] = "man";
	[214] = "woman";
	[215] = "woman";
	[216] = "woman";
	[217] = "man";
	[218] = "woman";
	[219] = "woman";
	[220] = "man";
	[221] = "man";
	[222] = "man";
	[223] = "man";
	[224] = "woman";
	[225] = "woman";
	[226] = "woman";
	[227] = "man";
	[228] = "man";
	[229] = "man";
	[230] = "man";
	[231] = "woman";
	[232] = "woman";
	[233] = "woman";
	[234] = "man";
	[235] = "man";
	[236] = "man";
	[237] = "pro";
	[238] = "pro";
	[239] = "man";
	[240] = "man";
	[241] = "man";
	[242] = "man";
	[243] = "pro";
	[244] = "sexywoman";
	[245] = "pro";
	[246] = "sexywoman";
	[247] = "man";
	[248] = "man";
	[249] = "man";
	[250] = "man";
	[251] = "woman";
	[252] = "man";
	[253] = "man";
	[254] = "man";
	[255] = "man";
	[256] = "sexywoman";
	[257] = "sexywoman";
	[258] = "man";
	[259] = "man";
	[260] = "man";
	[261] = "man";
	[262] = "man";
	[263] = "woman";
	[264] = "man";
	[274] = "swat";
	[275] = "swat";
	[276] = "swat";
	[277] = "swat";
	[278] = "swat";
	[279] = "swat";
	[280] = "swat";
	[281] = "swat";
	[282] = "swat";
	[283] = "swat";
	[284] = "swat";
	[285] = "swat";
	[286] = "swat";
	[287] = "swat";
	[288] = "swat";
	-- special skins
	[265] = "man";
	[266] = "man";
	[267] = "man";
	[268] = "man";
	[269] = "fatman";
	[270] = "gang2";
	[271] = "gang1";
	[272] = "man";
	[290] = "man";
	[291] = "man";
	[292] = "man";
	[293] = "gang2";
	[294] = "blindman";
	[295] = "man";
	[296] = "man";
	[297] = "man";
	[298] = "woman";
	[299] = "man";
	[300] = "gang1";
	[301] = "gang1";
	[302] = "man";
	[303] = "man";
	[304] = "woman";
	[305] = "man";
	[306] = "man";
	[307] = "man";
	[308] = "man";
	[309] = "man";
	[310] = "man";
	[311] = "fatman";
	[312] = "man";
};

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

local SKIN_WALKING_STYLES =
{
	[0] 	= MOVE_PLAYER;		
	[1] 	= MOVE_MAN;		
	[2] 	= MOVE_MAN;		
	[7] 	= MOVE_MAN;
	[9] 	= MOVE_WOMAN;
	[10] 	= MOVE_OLDFATWOMAN;
	[11] 	= MOVE_WOMAN;
	[12] 	= MOVE_SEXYWOMAN;
	[13] 	= MOVE_WOMAN;
	[14] 	= MOVE_MAN;
	[15] 	= MOVE_MAN;
	[16] 	= MOVE_MAN;
	[17] 	= MOVE_MAN;
	[18] 	= MOVE_MAN;
	[19] 	= MOVE_GANG1;
	[20] 	= MOVE_MAN;
	[21] 	= MOVE_GANG1;
	[22] 	= MOVE_GANG2;
	[23] 	= MOVE_MAN;
	[24] 	= MOVE_MAN;
	[25] 	= MOVE_MAN;
	[26] 	= MOVE_MAN;
	[27] 	= MOVE_MAN;
	[28] 	= MOVE_GANG2;
	[29] 	= MOVE_MAN;
	[30] 	= MOVE_MAN;
	[31] 	= MOVE_OLDFATWOMAN;
	[32] 	= MOVE_MAN;
	[33] 	= MOVE_MAN;
	[34] 	= MOVE_MAN;
	[35] 	= MOVE_MAN;
	[36] 	= MOVE_MAN;
	[37] 	= MOVE_MAN;
	[38] 	= MOVE_WOMAN;
	[39] 	= MOVE_OLDFATWOMAN;
	[40] 	= MOVE_SEXYWOMAN;
	[41] 	= MOVE_WOMAN;
	[43] 	= MOVE_MAN;
	[44] 	= MOVE_MAN;
	[45] 	= MOVE_MAN;
	[46] 	= MOVE_MAN;
	[47] 	= MOVE_MAN;
	[48] 	= MOVE_MAN;
	[49] 	= MOVE_OLDMAN;
	[50] 	= MOVE_MAN;
	[51] 	= MOVE_MAN;
	[52] 	= MOVE_MAN;
	[53] 	= MOVE_OLDWOMAN;
	[54] 	= MOVE_OLDWOMAN;
	[55] 	= MOVE_WOMAN;
	[56] 	= MOVE_WOMAN;
	[57] 	= MOVE_MAN;
	[58] 	= MOVE_MAN;
	[59] 	= MOVE_MAN;
	[60] 	= MOVE_MAN;
	[61] 	= MOVE_MAN;
	[62] 	= MOVE_OLDMAN;
	[63] 	= MOVE_PRO;
	[64] 	= MOVE_PRO;
	[66] 	= MOVE_MAN;
	[67] 	= MOVE_MAN;
	[68] 	= MOVE_MAN;
	[69] 	= MOVE_WOMAN;
	[70] 	= MOVE_MAN;
	[71] 	= MOVE_MAN;
	[72] 	= MOVE_MAN;
	[73] 	= MOVE_MAN;
	[75] 	= MOVE_PRO;
	[76] 	= MOVE_SEXYWOMAN;
	[77] 	= MOVE_MAN;
	[78] 	= MOVE_MAN;
	[79] 	= MOVE_MAN;
	[80] 	= MOVE_MAN;
	[81] 	= MOVE_MAN;
	[82] 	= MOVE_MAN;
	[83] 	= MOVE_MAN;
	[84] 	= MOVE_MAN;
	[85] 	= MOVE_PRO;
	[87] 	= MOVE_SEXYWOMAN;
	[88] 	= MOVE_OLDWOMAN;
	[89] 	= MOVE_OLDFATWOMAN;
	[90] 	= MOVE_JOGWOMAN;
	[91] 	= MOVE_SEXYWOMAN;
	[92] 	= MOVE_SKATE;
	[93] 	= MOVE_SEXYWOMAN;
	[94] 	= MOVE_MAN;
	[95] 	= MOVE_MAN;
	[96] 	= MOVE_JOGGER;
	[97] 	= MOVE_JOGGER;
	[98] 	= MOVE_MAN;
	[99] 	= MOVE_SKATE;
	[100] 	= MOVE_MAN;
	[101] 	= MOVE_MAN;
	[102] 	= MOVE_GANG1;
	[103] 	= MOVE_GANG2;
	[104] 	= MOVE_GANG1;
	[105] 	= MOVE_GANG2;
	[106] 	= MOVE_GANG1;
	[107] 	= MOVE_GANG2;
	[108] 	= MOVE_GANG1;
	[109] 	= MOVE_GANG2;
	[110] 	= MOVE_GANG1;
	[111] 	= MOVE_MAN;
	[112] 	= MOVE_MAN;
	[113] 	= MOVE_MAN;
	[114] 	= MOVE_GANG1;
	[115] 	= MOVE_GANG2;
	[116] 	= MOVE_GANG1;
	[117] 	= MOVE_MAN;
	[118] 	= MOVE_MAN;
	[120] 	= MOVE_MAN;
	[121] 	= MOVE_GANG1;
	[122] 	= MOVE_GANG2;
	[123] 	= MOVE_GANG1;
	[124] 	= MOVE_GANG1;
	[125] 	= MOVE_MAN;
	[126] 	= MOVE_MAN;
	[127] 	= MOVE_MAN;
	[128] 	= MOVE_MAN;
	[129] 	= MOVE_OLDWOMAN;
	[130] 	= MOVE_OLDWOMAN;
	[131] 	= MOVE_SEXYWOMAN;
	[132] 	= MOVE_MAN;
	[133] 	= MOVE_MAN;
	[134] 	= MOVE_OLDMAN;
	[135] 	= MOVE_MAN;
	[136] 	= MOVE_MAN;
	[137] 	= MOVE_MAN;
	[138] 	= MOVE_WOMAN;
	[139] 	= MOVE_WOMAN;
	[140] 	= MOVE_WOMAN;
	[141] 	= MOVE_BUSYWOMAN;
	[142] 	= MOVE_MAN;
	[143] 	= MOVE_GANG1;
	[144] 	= MOVE_GANG2;
	[145] 	= MOVE_WOMAN;
	[146] 	= MOVE_MAN;
	[147] 	= MOVE_MAN;
	[148] 	= MOVE_BUSYWOMAN;
	[150] 	= MOVE_BUSYWOMAN;
	[151] 	= MOVE_SEXYWOMAN;
	[152] 	= MOVE_PRO;
	[153] 	= MOVE_MAN;
	[154] 	= MOVE_MAN;
	[155] 	= MOVE_MAN;
	[156] 	= MOVE_MAN;
	[157] 	= MOVE_WOMAN;
	[158] 	= MOVE_MAN;
	[159] 	= MOVE_MAN;
	[160] 	= MOVE_OLDMAN;
	[161] 	= MOVE_MAN;
	[162] 	= MOVE_OLDMAN;
	[163] 	= MOVE_MAN;
	[164] 	= MOVE_MAN;
	[165] 	= MOVE_MAN;
	[166] 	= MOVE_MAN;
	[167] 	= MOVE_MAN;
	[168] 	= MOVE_MAN;
	[169] 	= MOVE_SEXYWOMAN;
	[170] 	= MOVE_MAN;
	[171] 	= MOVE_MAN;
	[172] 	= MOVE_BUSYWOMAN;
	[173] 	= MOVE_GANG1;
	[174] 	= MOVE_GANG2;
	[175] 	= MOVE_GANG1;
	[176] 	= MOVE_MAN;
	[177] 	= MOVE_MAN;
	[178] 	= MOVE_SEXYWOMAN;
	[179] 	= MOVE_MAN;
	[180] 	= MOVE_MAN;
	[181] 	= MOVE_MAN;
	[182] 	= MOVE_MAN;
	[183] 	= MOVE_MAN;
	[184] 	= MOVE_MAN;
	[185] 	= MOVE_MAN;
	[186] 	= MOVE_MAN;
	[187] 	= MOVE_MAN;
	[188] 	= MOVE_MAN;
	[189] 	= MOVE_MAN;
	[190] 	= MOVE_BUSYWOMAN;
	[191] 	= MOVE_WOMAN;
	[192] 	= MOVE_SEXYWOMAN;
	[193] 	= MOVE_SEXYWOMAN;
	[194] 	= MOVE_SEXYWOMAN;
	[195] 	= MOVE_WOMAN;
	[196] 	= MOVE_OLDWOMAN;
	[197] 	= MOVE_OLDWOMAN;
	[198] 	= MOVE_WOMAN;
	[199] 	= MOVE_WOMAN;
	[200] 	= MOVE_MAN;
	[201] 	= MOVE_WOMAN;
	[202] 	= MOVE_MAN;
	[203] 	= MOVE_MAN;
	[204] 	= MOVE_MAN;
	[205] 	= MOVE_WOMAN;
	[206] 	= MOVE_MAN;
	[207] 	= MOVE_PRO;
	[209] 	= MOVE_OLDMAN;
	[210] 	= MOVE_OLDMAN;
	[211] 	= MOVE_WOMAN;
	[212] 	= MOVE_MAN;
	[213] 	= MOVE_MAN;
	[214] 	= MOVE_WOMAN;
	[215] 	= MOVE_WOMAN;
	[216] 	= MOVE_WOMAN;
	[217] 	= MOVE_MAN;
	[218] 	= MOVE_WOMAN;
	[219] 	= MOVE_WOMAN;
	[220] 	= MOVE_MAN;
	[221] 	= MOVE_MAN;
	[222] 	= MOVE_MAN;
	[223] 	= MOVE_MAN;
	[224] 	= MOVE_WOMAN;
	[225] 	= MOVE_WOMAN;
	[226] 	= MOVE_WOMAN;
	[227] 	= MOVE_MAN;
	[228] 	= MOVE_MAN;
	[229] 	= MOVE_MAN;
	[230] 	= MOVE_MAN;
	[231] 	= MOVE_WOMAN;
	[232] 	= MOVE_WOMAN;
	[233] 	= MOVE_WOMAN;
	[234] 	= MOVE_MAN;
	[235] 	= MOVE_MAN;
	[236] 	= MOVE_MAN;
	[237] 	= MOVE_PRO;
	[238] 	= MOVE_PRO;
	[239] 	= MOVE_MAN;
	[240] 	= MOVE_MAN;
	[241] 	= MOVE_MAN;
	[242] 	= MOVE_MAN;
	[243] 	= MOVE_PRO;
	[244] 	= MOVE_SEXYWOMAN;
	[245] 	= MOVE_PRO;
	[246] 	= MOVE_SEXYWOMAN;
	[247] 	= MOVE_MAN;
	[248] 	= MOVE_MAN;
	[249] 	= MOVE_MAN;
	[250] 	= MOVE_MAN;
	[251] 	= MOVE_WOMAN;
	[252] 	= MOVE_MAN;
	[253] 	= MOVE_MAN;
	[254] 	= MOVE_MAN;
	[255] 	= MOVE_MAN;
	[256] 	= MOVE_SEXYWOMAN;
	[257] 	= MOVE_SEXYWOMAN;
	[258] 	= MOVE_MAN;
	[259] 	= MOVE_MAN;
	[260] 	= MOVE_MAN;
	[261] 	= MOVE_MAN;
	[262] 	= MOVE_MAN;
	[263] 	= MOVE_WOMAN;
	[264] 	= MOVE_MAN;
	[274] 	= MOVE_SWAT;
	[275] 	= MOVE_SWAT;
	[276] 	= MOVE_SWAT;
	[277] 	= MOVE_SWAT;
	[278] 	= MOVE_SWAT;
	[279] 	= MOVE_SWAT;
	[280] 	= MOVE_SWAT;
	[281] 	= MOVE_SWAT;
	[282] 	= MOVE_SWAT;
	[283] 	= MOVE_SWAT;
	[284] 	= MOVE_SWAT;
	[285] 	= MOVE_SWAT;
	[286] 	= MOVE_SWAT;
	[287] 	= MOVE_SWAT;
	[288] 	= MOVE_SWAT;
	-- special skins
	[265] 	= MOVE_MAN;
	[266] 	= MOVE_MAN;
	[267] 	= MOVE_MAN;
	[268] 	= MOVE_MAN;
	[269] 	= MOVE_FATMAN;
	[270] 	= MOVE_GANG2;
	[271] 	= MOVE_GANG1;
	[272] 	= MOVE_MAN;
	[290] 	= MOVE_MAN;
	[291] 	= MOVE_MAN;
	[292] 	= MOVE_MAN;
	[293] 	= MOVE_GANG2;
	[294] 	= MOVE_BLINDMAN;
	[295] 	= MOVE_MAN;
	[296] 	= MOVE_MAN;
	[297] 	= MOVE_MAN;
	[298] 	= MOVE_WOMAN;
	[299] 	= MOVE_MAN;
	[300] 	= MOVE_GANG1;
	[301] 	= MOVE_GANG1;
	[302] 	= MOVE_MAN;
	[303] 	= MOVE_MAN;
	[304] 	= MOVE_WOMAN;
	[305] 	= MOVE_MAN;
	[306] 	= MOVE_MAN;
	[307] 	= MOVE_MAN;
	[308] 	= MOVE_MAN;
	[309] 	= MOVE_MAN;
	[310] 	= MOVE_MAN;
	[311] 	= MOVE_FATMAN;
	[312] 	= MOVE_MAN;
};

local SPEC_SKINS = 
{
	[95]  = true; 	-- Terror: Arctic
	[96]  = true; 	-- Terror: Guerilla
	[71]  = true;
	[211] = true;	--// Police girl
	[265] = true;
	[266] = true;
	[267] = true;
	[274] = true; 
	[275] = true; 
	[276] = true; 
	[280] = true; 
	[281] = true; 
	[282] = true; 
	[283] = true;
	[284] = true; 
	[285] = true;	--// SWAT
	[286] = true;	--// FBI
	[287] = true;	--// FBI SWAT
	[288] = true;	--// US Army
};

local ARMOR_SKINS =
{
	[285] = true;	--// SWAT
	[287] = true;	--// FBI SWAT
	[288] = true;	--// US Army
	-- TODO: K-9 skin
};

REG_SKINS = { 1, 2, 7, 12, 28, 30, 41, 47, 48, 50, 56, 60, 61, 62, 68, 170, 180, 250, 255, 268, 291, 305, 306, 307, 308, 309, 312 };

local skins = {};

for _gender, _colors in pairs( SKINS ) do
	for _color, _skins in pairs( _colors ) do
		for _, _skin in ipairs( _skins ) do
			skins[ _skin ] =
			{
				gender 	= _gender;
				color 	= _color;
			};
		end
	end
end

function GetSkins()
	local _skins = {};
	
	for skin in pairs( skins ) do
		table.insert( _skins, CPed.GetSkin( skin ) );
	end
	
	return _skins;
end

function CPed:GetSkin()
	local skin = typeof( self ) == "object" and self:GetModel() or tonumber( self );
	
	return skin and
	{
		GetID			= function() return skin; end;
		GetName			= function() return SKIN_NAMES[ skin ] or 'invalid skin ' + skin; end;
		GetColor		= function() return skins[ skin ] and skins[ skin ].color; end;
		GetGender		= function() return skins[ skin ] and skins[ skin ].gender; end;
		GetAnimGroup	= function() return SKIN_ANIM_GROUPS[ skin ]; end;
		GetWalkingStyle	= function() return SKIN_WALKING_STYLES[ skin ] end;
		IsValid			= function() return tobool( SKIN_NAMES[ skin ] and skins[ skin ] and SKIN_ANIM_GROUPS[ skin ] ); end;
		IsSpecial		= function() return SPEC_SKINS[ skin ] end;
		HaveArmor		= function() return ARMOR_SKINS[ skin ] end;
	};
end

CPlayer.GetSkin	= CPed.GetSkin;