--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		SetEnabled( getElementData( localPlayer, "Settings.Graphics.Shaders.HDR" ) );
	end
);

--------------------------------
-- Switch effect on or off
--------------------------------
function SetEnabled( bOn )
	if bOn then
		enableContrast();
	else
		disableContrast();
	end
end

addEvent( "switchContrast", true );
addEventHandler( "switchContrast", resourceRoot, SetEnabled );


