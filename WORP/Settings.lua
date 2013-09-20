-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

Settings	=
{
	Graphics	=
	{
		Shaders	=
		{
			DepthOfField	= false;
			HDR				= false;
			Bloom			= false;
			Glow			= true;
			RadialBlur		= false;
			RoadShine3		= false;
			BumpMapping		= false;
			CarReflect		= false;
			Water			= false;
		};
		Blur		= 0;
		Clouds		= true;		
		Birds		= true;		
	};
	AnalogControl	=
	{
		Enabled			= false;
		Sensitivity		= 0.1;
		Angle			= 270.0;
		EasingIn		= "InCirc";
		EasingOut		= "OutCirc";
	};
};

function ApplySettings()
	setBlurLevel		( Settings.Graphics.Blur );
	setCloudsEnabled	( Settings.Graphics.Clouds );
	setBirdsEnabled		( Settings.Graphics.Birds );
end

addEventHandler( "onClientResourceStart", resourceRoot, ApplySettings );
