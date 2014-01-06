-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local OnClientDamage, OnClientChoke;

local SWAT_Models	=
{
	[285]	= true;
	[287]	= true;
	[288]	= true;
};

function OnClientDamage( pAttacker, iWeapon, iBodypart, fLoss )
	if ( weapon == 17 and SWAT_Models[ source:GetModel() ] ) or source:GetData( "adminduty" ) or source:GetData( "DamageProof" ) then
		cancelEvent();
	end
end

function OnClientChoke( iWeapon, pAttacker )
	if SWAT_Models[ source:GetModel() ] or source:GetData( "adminduty" ) then
		cancelEvent();
	end
end

function OnClientHeliKilled( pKiller )
	cancelEvent();
end

addEventHandler( "onClientPedDamage", root, OnClientDamage );
addEventHandler( "onClientPlayerDamage", CLIENT, OnClientDamage );
addEventHandler( "onClientPlayerChoke", CLIENT, OnClientChoke );
addEventHandler( "onClientPlayerHeliKilled", CLIENT, OnClientHeliKilled );