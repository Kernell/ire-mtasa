-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local gl_aStrings	= NULL;
local gl_iStep		= 0;
local gl_iType		= 0;

function SendTutorialData( aStrings, iType )
	gl_aStrings		= aStrings;
	gl_iStep		= 0;
	gl_iType		= iType;
	
	NextTutorialString();
end

function NextTutorialString()
	if gl_aStrings then
		gl_iStep	= gl_iStep + 1;
		
		if gl_aStrings[ gl_iStep ] then
			local pDialog = MessageBox( gl_aStrings[ gl_iStep ], "Помощь по игре", MessageBoxButtons.OK, MessageBoxIcon.Information );
			
			pDialog.Button[ "OK" ].OnClick = NextTutorialString;
		else
			gl_aStrings	= NULL;
			
			SERVER.CompleteTutorial( gl_iType );
		end
	end
end