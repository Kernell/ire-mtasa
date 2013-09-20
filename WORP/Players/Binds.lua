-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

function ToggleCursor()
	showCursor( not isCursorShowing() );
end

bindKey		( "mouse3", "down",		CRadialMenu.Show	);
bindKey		( "mouse3", "up",		CRadialMenu.Hide	);

bindKey		( "F1", "up", "view_help" );
bindKey		( "F2", "up", "stats" );
bindKey		( "F7", "up", "anim" );

bindKey		( "b", "up", "chatbox", "LocalOOC" );
bindKey		( "o", "up", "chatbox", "GlobalOOC" );

bindKey		( "m", "up", ToggleCursor );
bindKey		( "f", "up", "enter" );
bindKey		( "r", "up", "reload_weapon" );

bindKey		( "i", "up", "inventory" );

bindKey		( "0", "up", "drop_weapon" );
bindKey		( "1", "up", "weapon_slot", '1' );
bindKey		( "2", "up", "weapon_slot", '2' );
bindKey		( "3", "up", "weapon_slot", '3' );
bindKey		( "4", "up", "weapon_slot", '4' );
bindKey		( "5", "up", "weapon_slot", '5' );

bindKey		( ",", "up", "indicator", "left" );
bindKey		( ".", "up", "indicator", "right" );

bindKey		( "change_camera", "down", CCamera.ChangeMode );

bindKey		( "z", "up", "vehicle", "toggle_siren" );
bindKey		( "x", "up", "vehicle", "loop_siren" );

bindKey		( "n", "up", "vehicle", "toggle_whelen" );
bindKey		( "h", "up", "vehicle", "loop_whelen" );

bindKey		( "/", "up", "vehicle", "loop_wiper" );
