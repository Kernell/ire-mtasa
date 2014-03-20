-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

DIRECT3D_VERSION	= 0x9;

class: CShaderManager ( LuaBehaviour )
{
	m_pScreen			= NULL;
	
	m_ShaderPriority	=
	{
		"Water";
		"Shine";
		"GaussianBlur";
		"DepthOfField";
		"HDR";
		"RadialBlur";
	};
	
	m_Textures			=
	{
		"smallnoise3d", "cube_env256", "vignette1", "radial_mask"
	};
	
	m_iLastTick				= 0;
	m_fDeltaTime			= 0.0;
	
	m_iFPS					= 0;
	m_iFPSUpdateInterval	= 100;
	m_iFPSLastUpdate		= 0;
	m_pFPSFont				= "default-bold-small";
	m_iFPSColor1			= tocolor( 255, 255, 255 );
	m_iFPSColor2			= tocolor( 0, 0, 0 );
	
	CShaderManager		= function( this )
		this.m_pFPSFont				= exports.WORP:DXFont( "Consolas", 16 ) or CShaderManager.m_pFPSFont;
		
		this.m_fScreenX, this.m_fScreenY	= guiGetScreenSize();
		
		this.m_pScreen	= dxCreateScreenSource( this.m_fScreenX, this.m_fScreenY );
		
		this.m_Textures = {};
		
		this.Textures	=
		{
			__index		= function( self, sName )
				if this.m_Textures[ sName ] == NULL then
					this.m_Textures[ sName ] = dxCreateTexture( "Textures/" + sName + ".dds" );
				end
				
				return this.m_Textures[ sName ];
			end;
			
			__newindex	= function() return NULL; end;
		};
		
		setmetatable( this.Textures, this.Textures );
		
		local Settings = exports.WORP:GetSettings();
		
		this:LuaBehaviour();
		
		this:OnSettingsUpdate( Settings.Graphics.Shaders );
	end;
	
	_CShaderManager		= function( this )
		this:_LuaBehaviour();
		
		this:Disable();
		
		delete ( this.m_pScreen );
	end;
	
	Enable				= function( this )
		for i, sName in ipairs( this.m_ShaderPriority ) do
			if not this[ "m_p" + sName ] then
				this[ "m_p" + sName ]		 = _G[ "CShader" + sName ]( this );
			end
		end
	end;
	
	Disable				= function( this )
		for i, sName in ipairs( this.m_ShaderPriority ) do
			if this[ "m_p" + sName ] then
				delete ( this[ "m_p" + sName ] );
				
				this[ "m_p" + sName ] = NULL;
			end
		end
	end;
	
	OnSettingsUpdate	= function( this, Settings )
		this:Disable();
		
		this.m_ShaderPriority	= {};
		
		for i, sName in ipairs( CShaderManager.m_ShaderPriority ) do
			if Settings[ sName ] then
				table.insert( this.m_ShaderPriority, sName );
			end
		end
		
		this:Enable();
	end;
	
	OnRenderObject		= function( this )
		dxUpdateScreenSource( this.m_pScreen );
	end;
	
	OnRenderImage		= function( this )
		if isDebugViewActive() then
			local iTick = getTickCount();
			
			if iTick - this.m_iFPSLastUpdate >= this.m_iFPSUpdateInterval then
				this.m_iFPS = ( 1000 / ( iTick - this.m_iLastTick ) ):floor();
				
				this.m_iFPSLastUpdate	= iTick;
			end

			dxDrawText( this.m_iFPS, this.m_fScreenX, 2, this.m_fScreenX - 4, 2, this.m_iFPSColor2, 1.05, this.m_pFPSFont, "right", "top", false, false, true );
			dxDrawText( this.m_iFPS, this.m_fScreenX, 2, this.m_fScreenX - 6, 2, this.m_iFPSColor2, 1.05, this.m_pFPSFont, "right", "top", false, false, true );
			dxDrawText( this.m_iFPS, this.m_fScreenX, 2, this.m_fScreenX - 6, 0, this.m_iFPSColor2, 1.05, this.m_pFPSFont, "right", "top", false, false, true );
			dxDrawText( this.m_iFPS, this.m_fScreenX, 0, this.m_fScreenX - 5, 2, this.m_iFPSColor2, 1.05, this.m_pFPSFont, "right", "top", false, false, true );
			dxDrawText( this.m_iFPS, this.m_fScreenX, 1, this.m_fScreenX - 5, 1, this.m_iFPSColor1, 1.05, this.m_pFPSFont, "right", "top", false, false, true );
		end
		
		this.m_iLastTick	= getTickCount();
	end;
};