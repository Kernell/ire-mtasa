-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local Commands = 
{
	get			= { cmd = 'player',	args = 'get' };
	goto		= { cmd = 'player', args = 'goto' };
	sethp		= { cmd = 'player', args = 'sethealth' };
	setarm		= { cmd = 'player', args = 'setarmor' };
	setarmor	= { cmd = 'player', args = 'setarmor' };
	jail		= { cmd = 'player', args = 'jail' };
	slap		= { cmd = 'player', args = 'slap' };
	kick		= { cmd = 'player', args = 'kick' };
	ban			= { cmd = 'player', args = 'ban' };
	mute		= { cmd = 'player', args = 'mute' };
	recon		= { cmd = 'player', args = 'spectate' };
	spectate	= { cmd = 'player', args = 'spectate' };
	setskin		= { cmd = 'player', args = 'setskin' };
	getpos		= { cmd = 'player', args = 'getposition' };
	getposition	= { cmd = 'player', args = 'getposition' };
	
	kiss		= { cmd = 'offer',	args = 'kiss' };
	propose		= { cmd = 'offer',	args = 'propose' };
	divorce		= { cmd = 'offer',	args = 'divorce' };
	hello		= { cmd = 'offer',	args = 'hello' };
	privet		= { cmd = 'offer',	args = 'hello' };
	
	veh			= { cmd = 'vehicle', args = 'spawn' };
	vget		= { cmd = 'vehicle', args = 'get' };
	getcar		= { cmd = 'vehicle', args = 'get' };
	vgoto		= { cmd = 'vehicle', args = 'goto' };
	gotocar		= { cmd = 'vehicle', args = 'goto' };
	fixcar		= { cmd = 'vehicle', args = 'repair' };
	fixveh		= { cmd = 'vehicle', args = 'repair' };
	vfix		= { cmd = 'vehicle', args = 'repair' };
	flip		= { cmd = 'vehicle', args = 'flip' };
};

for cmd, alias in pairs( Commands ) do
	addCommandHandler( cmd,
		function( pPlayer, cmd, ... )
			if not CCommand:Exec( pPlayer, alias.cmd, alias.args, ... ) then
				Debug( "invalid command link '" + cmd + "' for '" + alias.cmd + " " + alias.args + "'", 2 );
			end
		end
	);
end