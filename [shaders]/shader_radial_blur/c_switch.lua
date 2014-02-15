--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchRadialBlur", root, true )
--
--	To switch off:
--			triggerEvent( "switchRadialBlur", root, false )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		SetEnabled( getElementData( localPlayer, "Settings.Graphics.Shaders.RadialBlur" ) or false );
	end
);

--------------------------------
-- Switch effect on or off
--------------------------------
function SetEnabled( bOn )
	if bOn then
		enableRadialBlur()
	else
		disableRadialBlur()
	end
end

addEvent( "switchRadialBlur", true )
addEventHandler( "switchRadialBlur", resourceRoot, SetEnabled )
