-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local COLOR_BLUE		= tocolor( 64, 255, 255 );

local gl_TexturesRoot	= "Resources/Textures/HUD/";

local HUDInfoDefaults	= 
{
	[ 1 ]		= 0; 			-- Exp
	[ 2 ]		= "00"; 		-- Level
	[ 3 ]		= "00000000";	-- Money
	[ 4 ]		= "none"; 		-- Weapon
	[ 5 ]		= "  0%"; 		-- Health
	[ 6 ]		= "  0%"; 		-- Armor
	[ 7 ]		= "  0%"; 		-- Power
};

local HUDInfoFormat	=
{
	[ 2 ]		= "%02i"; 		-- Level
	[ 3 ]		= "%08i";		-- Money
	[ 5 ]		= "%03i%%"; 	-- Health
	[ 6 ]		= "%03i%%"; 	-- Armor
	[ 7 ]		= "%03i%%"; 	-- Power
};

local HUDInfo	= {};

class: CClientHUD
{
-- public:
	CClientHUD = function( self )
		if g_pHUD then
			return;
		end
		
		g_pHUD = self;
		
		function self.__Render()
			if CLIENT.m_pCharacter then
				self:Render();
			end
		end
		
		addEventHandler( "onClientRender", root, self.__Render );
	end;

	_CClientHUD = function( self )
		removeEventHandler( "onClientRender", root, self.__Render );
	end;
	
	Render = function( self )
		if not self.m_bEnabled then
			return;
		end
		
		if self.m_TopBar.m_bEnabled then
			for i, pItem in ipairs( self.m_TopBar ) do
				if pItem.m_bVisible then
					dxDrawImage( pItem.m_fX, pItem.m_fY, pItem.m_fWidth, pItem.m_fHeight, gl_TexturesRoot + pItem.m_sTexture, 0, 0, 0, COLOR_WHITE, true );
					
					if pItem.m_sIcon then
						dxDrawImage( pItem.m_fX - 2, pItem.m_fY, 32, 32, gl_TexturesRoot + pItem.m_sIcon, 0, 0, 0, pItem.m_iColor or COLOR_WHITE, true );
					end
					
					if pItem.m_sValue then
						local sValue = NULL;
						
						if type( pItem.m_sValue ) == 'function' then
							sValue = pItem.m_sValue( pItem, i );
						else
							sValue = pItem.m_sValue;
						end
						
						if sValue then
							local fX = pItem.m_sIcon and pItem.m_fX + (int)(pItem.m_fPaddingLeft) + 16 or pItem.m_fX;
							
							for i = sValue:len(), 1, -1 do
								local sChar = sValue[ i ];
								
								if sChar == '%' then
									sChar = "Percent";
								elseif not tonumber( sChar ) then
									sChar = NULL;
								end
								
								if sChar then
									dxDrawImage( fX + ( 12 * ( i - 1 ) ), pItem.m_fY, 32, 32, gl_TexturesRoot + sChar + ( pItem.m_sFontType and ( '-' + pItem.m_sFontType ) or '' ) + ".png", 0, 0, 0, COLOR_WHITE, true );
								end
							end
						end
					end
				end
			end
		end
	end;
	
-- private:
	m_bEnabled			= true;
	
	m_TopBar			=
	{
		m_bEnabled			= true;
		
		{
			m_fX			= 0;
			m_fY			= 0;
			m_fWidth		= g_iScreenX;
			m_fHeight		= 32;
			m_sTexture		= "Background.png";
			m_bVisible		= true;
		};
		{
			m_fX			= g_iScreenX * .02;
			m_fY			= 0;
			m_fWidth		= 64;
			m_fHeight		= 32;
			m_sTexture		= "LevelBackground.png";
			m_bVisible		= true;
			m_sFontType		= "Italic";
			m_sValue		= function( self, i )
				for i = 1, 10 do
					local sLevelExp	= "LevelExpOff.png";
					
					if i <= ( HUDInfo[ 1 ] or HUDInfoDefaults[ 1 ] ) then
						sLevelExp	= "LevelExpOn.png";
					end
					
					dxDrawImage( self.m_fX + 50 + ( 8 * ( i - 1 ) ), 9, 16, 16, gl_TexturesRoot + sLevelExp, 0, 0, 0, COLOR_WHITE, true );
				end
				
				return HUDInfo[ i ] or HUDInfoDefaults[ i ];
			end;
		};
		{
			m_fX			= g_iScreenX * .2;
			m_fY			= 0;
			m_fWidth		= 128;
			m_fHeight		= 32;
			m_fPaddingLeft	= 2;
			m_sTexture		= "MoneyBackground.png";
			m_bVisible		= true;
			m_sIcon			= "MoneyIcon.png";
			m_sValue		= function( self, i )
				return HUDInfo[ i ] or HUDInfoDefaults[ i ];
			end;
		};
		{
			m_fX			= ( g_iScreenX - 256 ) / 2;
			m_fY			= 0;
			m_fWidth		= 256;
			m_fHeight		= 32;
			m_sTexture		= "WeaponBackground.png";
			m_bVisible		= true;
			m_sValue		= function( self, i )
				local sWeapon	= "none";
				
				if CLIENT.m_pWeapon and CLIENT.m_pWeapon.m_sClassName and fileExists( gl_TexturesRoot + "Weapon-" + CLIENT.m_pWeapon.m_sClassName + ".png" ) then
					sWeapon = CLIENT.m_pWeapon.m_sClassName;
				else
					CLIENT.m_pWeapon = NULL;
				end
				
				dxDrawImage( self.m_fX + 24, self.m_fY, 128, 32, gl_TexturesRoot + "Weapon-" + sWeapon + ".png", 0, 0, 0, COLOR_WHITE, true );
				
				if CLIENT.m_pWeapon then
					local iClipSize = math.min( 10, CLIENT.m_pWeapon.m_iClipSize or 10 );
					
					if CLIENT.m_pWeapon.m_iValue and CLIENT.m_pWeapon.m_iClipSize then
						iClipSize	= math.min( iClipSize, CLIENT.m_pWeapon.m_iClipSize );
						
						local iClip	= math.ceil( CLIENT.m_pWeapon.m_iValue / CLIENT.m_pWeapon.m_iClipSize * iClipSize );
						
						if iClip > 0 then
							dxDrawImage( self.m_fX + 24 + 122, self.m_fY, 16, 32, gl_TexturesRoot + "WeaponClip-" + iClip + ".png", 0, 0, 0, COLOR_BLUE, true );
						end	
					end
					
					local iAlpha = 128;
					
					if not CLIENT.m_pWeapon.m_Data.m_sClip or CLIENT.m_pWeapon.m_iValue == 0 then
						local fProgress = self.m_iLerpEnd and 1.0 - ( self.m_iLerpEnd - getTickCount() ) / 500 or 1.0;
						
						iAlpha = Lerp( self.m_iAlphaStart or 0, self.m_iAlphaTarget or 128, fProgress );
						
						if fProgress >= 1.0 then
							self.m_iAlphaTarget, self.m_iAlphaStart = self.m_iAlphaStart or 0, self.m_iAlphaTarget or 128;
							
							self.m_iLerpEnd = getTickCount() + 500;
						end
					end
					
					dxDrawImage( self.m_fX + 24 + 122, self.m_fY, 16, 32, gl_TexturesRoot + "WeaponClip-" + iClipSize + ".png", 0, 0, 0, tocolor( 64, 255, 255, iAlpha ), true );
				
					for i, pClip in ipairs( CLIENT.m_pCharacter.m_pInventory.m_Items[ ITEM_SLOT_CLIP_AMMO ] ) do
						if pClip.m_sWeaponClass == CLIENT.m_pWeapon.m_sClassName then
							local fX = self.m_fX + 24 + 122 + ( 12 * i );
							
							local iClipSize = math.min( 10, pClip.m_iClipSize );
							local iClip		= math.ceil( pClip.m_iValue / pClip.m_iClipSize * iClipSize );
							
							if iClip > 0 then
								dxDrawImage( fX, self.m_fY, 16, 32, gl_TexturesRoot + "WeaponClip-" + iClip + ".png", 0, 0, 0, COLOR_WHITE, true );
							end
							
							dxDrawImage( fX, self.m_fY, 16, 32, gl_TexturesRoot + "WeaponClip-" + iClipSize + ".png", 0, 0, 0, tocolor( 255, 255, 255, 128 ), true );
						end
					end
				end
				
				return NULL;
			end;
		};
		{
			m_fX			= g_iScreenX * .89;
			m_fY			= 0;
			m_fWidth		= 128;
			m_fHeight		= 32;
			m_sTexture		= "Background2.png";
			m_sIcon			= "HealthIcon.png";
			m_bVisible		= true;
			m_sFontType		= "Italic";
			m_sValue		= function( self, i )
				local iHealth = HUDInfo[ i ] or 0;
				
				if not HUDInfo[ i ] then
					local bAdminDuty = CLIENT:GetData( "adminduty" );
					
					iHealth = bAdminDuty and 999 or math.ceil( CLIENT:GetHealth() );
					
					if iHealth <= 100 then
						if not self.m_iColorLerpEnd then
							self.m_iHealthLerp		= Clamp( 300, iHealth * 30, 1000 );
							self.m_iColorLerpEnd	= getTickCount() + self.m_iHealthLerp;
						end
					else
						self.m_iColorLerpEnd = NULL;
						self.m_iColor = COLOR_RED;
					end
					
					if self.m_iColorLerpEnd then
						local fProgress	= iHealth > 0 and getEasingValue( 1.0 - ( self.m_iColorLerpEnd - getTickCount() ) / self.m_iHealthLerp, 'OutInBack', 0.3, 1.0, 0.701 ) or 0.5;
						
						self.m_iColor 	= tocolor( 255, 255, 255, Lerp( 255, 0, fProgress ) );
						
						if fProgress >= 1.0 then
							self.m_iColorLerpEnd = NULL;
						end
					end
				end
				
				return ( "%3i%%" ):format( iHealth );
			end;
		};
		{
			m_fX			= g_iScreenX * .77;
			m_fY			= 0;
			m_fWidth		= 128;
			m_fHeight		= 32;
			m_sTexture		= "Background2.png";
			m_sIcon			= "ArmourIcon.png";
			m_bVisible		= true;
			m_sFontType		= "Italic";
			m_sValue		= function( self )
				return HUDInfo[ i ] or ( "%3i%%" ):format( math.ceil( getPedArmor( CLIENT ) ) );
			end;
		};
		{
			m_fX			= g_iScreenX * .65;
			m_fY			= 0;
			m_fWidth		= 128;
			m_fHeight		= 32;
			m_sTexture		= "Background2.png";
			m_sIcon			= "EnergyIcon.png";
			m_bVisible		= true;
			m_sFontType		= "Italic";
			m_sValue		= function( self, i )
				local fPower = math.ceil( HUDInfo[ i ] or CLIENT:GetData( "CChar::m_fPower" ) or HUDInfoDefaults[ i ] );
				
				if fPower ~= self.m_fPower then
					self.m_iPowerLerpEnd = getTickCount() + 1000;
					
					self.m_fSPower	= self.m_fPower or 0;
					self.m_fPower 	= fPower;
				end
				
				if self.m_iPowerLerpEnd then
					local fProgress	= 1.0 - ( self.m_iPowerLerpEnd - getTickCount() ) / 1000;
					
					fPower	= Lerp( self.m_fSPower, fPower, fProgress );
				end
				
				return ( "%3i%%" ):format( fPower );
			end;
		};
	};
};

function SetHUDVisible( bVisible, sItemName )
	if g_pHUD then
		if type( sItemName ) == 'string' then
			g_pHUD[ 'm_' + sItemName ].m_bEnabled = bVisible;
		else
			g_pHUD.m_bEnabled = bVisible;
		end
	end
end

function _CClientHUD()
	delete( g_pHUD );
	g_pHUD	= NULL;
end

function SetHUDInfo( eHUDInfo, vValue )
	if HUDInfoDefaults[ eHUDInfo ] then
		HUDInfo[ eHUDInfo ] = vValue and ( HUDInfoFormat[ eHUDInfo ] and HUDInfoFormat[ eHUDInfo ]:format( vValue ) or vValue ) or HUDInfoDefaults[ eHUDInfo ];
	end
end
