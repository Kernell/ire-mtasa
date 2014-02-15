-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

Settings	=
{
	Graphics	=
	{
		Blur		= 0;
		Clouds		= false;
		Birds		= false;
		
		Shaders	=
		{
			DepthOfField	= false;
			HDR				= false;
			Bloom			= false;
		--	Glow			= true;
			RadialBlur		= false;
		--	MotionBlur		= false;
			RoadShine3		= false;
			BumpMapping		= false;
			CarReflect		= false;
			Water			= false;
		};
	};
	
	Controls	=
	{
		Cruise	= 0.0;
		
		MouseSteering	=
		{
			Enabled			= false;
			Sensitivity		= 0.1;
			Angle			= 90.0;
			EasingIn		= "InCirc";
			EasingOut		= "OutCirc";
		};
	};
};

SettingsMeta	=
{
	Load	= function( pSettings, pSetting )
		for key, value in pairs( pSettings ) do
			if type( value ) == "table" then
				return Settings.Load( value, pSetting[ key ] );
			elseif value == "true" or value == "false" then
				pSetting[ key ] = (bool)(value);
			else
				pSetting[ key ] = tonumber( value ) or value;
			end
		end;
		
		Settings.Apply();
	end;
	
	Apply	= function()
		setBlurLevel		( Settings.Graphics.Blur );
		setCloudsEnabled	( Settings.Graphics.Clouds );
		setBirdsEnabled		( Settings.Graphics.Birds );
		
		resourceRoot.m_pClientShaderManager:Stop();
		resourceRoot.m_pClientShaderManager:Start();
	end;
};

SettingsMeta.__index = SettingsMeta;

setmetatable( Settings, SettingsMeta );