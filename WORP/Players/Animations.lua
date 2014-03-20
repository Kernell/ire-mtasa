-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local anim_groups =
{
	player =
	{
		[0] = 'walk_player';
		[1] = 'run_player';
		[2] = 'SPRINT_civi';
		[3] = 'IDLE_STANCE';
		[4] = 'roadcross';
		[5] = 'walk_start';
	};
	man	=
	{
		[0] = 'walk_civi';
		[1] = 'run_civi';
		[2] = 'sprint_panic';
		[3] = 'idle_stance';
		[4] = 'roadcross';
		[5] = 'walk_start';
	};
	shuffle =
	{
		[0] = 'WALK_shuffle';
		[1] = 'RUN_civi';
		[2] = 'sprint_panic';
		[3] = 'IDLE_STANCE';
		[4] = 'roadcross';
		[5] = 'walk_start';
	};
	oldman =
	{
		[0] = 'walk_old';
		[1] = 'run_old';
		[2] = 'sprint_panic';
		[3] = 'idlestance_old';
		[4] = 'roadcross_old';
		[5] = 'walk_start';
	};
	gang1 =
	{
		[0] = "walk_gang1";
		[1] = "run_gang1";
		[2] = "sprint_panic";
		[3] = "idle_gang1";
		[4] = "roadcross_gang";
		[5] = "walk_start";
	};
	gang2 =
	{
		[0] = "walk_gang2";
		[1] = "run_gang1";
		[2] = "sprint_panic";
		[3] = "idle_gang1";
		[4] = "roadcross_gang";
		[5] = "walk_start";
	};
	oldfatman =
	{
		[0] = "walk_fatold";
		[1] = "run_fatold";
		[2] = "woman_runpanic";
		[3] = "idle_stance";
		[4] = "roadcross";
		[5] = "walk_start";
	};
	fatman =
	{
		[0] = "walk_fat";
		[1] = "run_fat";
		[2] = "woman_runpanic";
		[3] = "Idlestance_fat";
		[4] = "roadcross";
		[5] = "walk_start";
	};
	jogger =
	{
		[0] = "JOG_maleA";
		[1] = "run_civi";
		[2] = "sprint_panic";
		[3] = "idle_stance";
		[4] = "roadcross";
		[5] = "walk_start";
	};
	drunkman =
	{
		[0] = "walk_drunk";
		[1] = "run_civi";
		[2] = "sprint_panic";
		[3] = "idle_stance";
		[4] = "roadcross";
		[5] = "walk_start";
	};
	blindman =
	{
		[0] = "Walk_Wuzi";
		[1] = "run_wuzi";
		[2] = "sprint_wuzi";
		[3] = "idle_stance";
		[4] = "roadcross";
		[5] = "walk_start";
	};
	swat =
	{
		[0] = "walk_civi";
		[1] = "swat_run";
		[2] = "sprint_panic";
		[3] = "idle_stance";
		[4] = "roadcross";
		[5] = "walk_start";
	};
	woman =
	{
		[0] = "woman_walknorm";
		[1] = "woman_run";
		[2] = "woman_runpanic";
		[3] = "woman_idlestance";
		[4] = "roadcross_female";
		[5] = "walk_start";
	};
	shopping =
	{
		[0] = "woman_walkshop";
		[1] = "woman_run";
		[2] = "woman_run";
		[3] = "woman_idlestance";
		[4] = "roadcross_female";
		[5] = "walk_start";
	};
	busywoman =
	{
		[0] = "woman_walkbusy";
		[1] = "woman_runbusy";
		[2] = "woman_runpanic";
		[3] = "woman_idlestance";
		[4] = "roadcross_female";
		[5] = "walk_start";
	};
	sexywoman =
	{
		[0] = "woman_walksexy";
		[1] = "woman_runsexy";
		[2] = "woman_runpanic";
		[3] = "woman_idlestance";
		[4] = "roadcross_female";
		[5] = "walk_start";
	};
	pro =
	{
		[0] = "WOMAN_walkpro";
		[1] = "woman_runsexy";
		[2] = "woman_runpanic";
		[3] = "woman_idlestance";
		[4] = "roadcross_female";
		[5] = "walk_start";
	};
	oldwoman =
	{
		[0] = "woman_walkold";
		[1] = "woman_run";
		[2] = "woman_runpanic";
		[3] = "woman_idlestance";
		[4] = "roadcross_female";
		[5] = "walk_start";
	};
	fatwoman =
	{
		[0] = "walk_fat";
		[1] = "woman_run";
		[2] = "woman_runpanic";
		[3] = "woman_idlestance";
		[4] = "roadcross_female";
		[5] = "walk_start";
	};
	jogwoman =
	{
		[0] = "JOG_femaleA";
		[1] = "woman_run";
		[2] = "woman_runpanic";
		[3] = "woman_idlestance";
		[4] = "roadcross_female";
		[5] = "walk_start";
	};
	oldfatwoman =
	{
		[0] = "woman_walkfatold";
		[1] = "woman_runfatold";
		[2] = "woman_runpanic";
		[3] = "woman_idlestance";
		[4] = "roadcross_female";
		[5] = "walk_start";
	};
};

function GetAnimation( anim_group, index )
	return anim_groups[ anim_group ][ index ];
end