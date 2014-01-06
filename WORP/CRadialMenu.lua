-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CRadialMenu
{
	m_bPostGUI			= true;
	m_bVisible			= false;
	m_iTick				= 0;
	m_Items				= NULL;
	m_sIconPath			= "Resources/Images/holo_light/";
	m_sIconExt			= "png";
	m_sRadial			= "Resources/Images/radial_menu.png";
	m_iSize				= 256;
	m_iIconSize			= 32;
	
	CRadialMenu		= function( this )
		this.m_pColor			= { R = 255, G = 255, B = 255, A = 153 };
		this.m_pColorHover		= { R = 61,  G = 181, B = 234, A = 153 };
		this.m_pIconColor		= { R = 51,  G = 51,  B = 51,  A = 153 };
		this.m_pIconColorHover	= { R = 255, G = 255, B = 255, A = 153 };
		
		this.m_Items			= {};
		this.m_pTexture			= dxCreateTexture( this.m_sRadial );
		
		this.m_iX	= ( g_iScreenX - this.m_iSize ) / 2;
		this.m_iY	= ( g_iScreenY - this.m_iSize ) / 2;
		
		this.m_iX2	= this.m_iX + ( this.m_iSize / 2 );
		this.m_iY2	= this.m_iY + ( this.m_iSize / 2 );
		
		this:AddItem( "1-navigation-cancel", NULL );
		
		function this.__Draw()
			if this.m_bVisible then
				this:Draw();
			end
		end
		
		addEventHandler( "onClientRender", root, this.__Draw );
	end;
	
	_CRadialMenu	= function( this )
		removeEventHandler( "onClientRender", root, this.__Draw );
		
		for i, pTexture in pairs( this.m_Items ) do
			destroyElement( pTexture );
			
			this.m_Items[ i ] = NULL;
		end
		
		this.__Draw		= NULL;
		this.m_Items	= NULL;
		
		CLIENT.m_pRadialMenu = NULL;
	end;
	
	AddItem			= function( this, sIcon, vFunction, ... )
		if not sIcon then
			return NULL;
		end
		
		local iSize = sizeof( this.m_Items );
		
		if iSize > 7 then
			return NULL;
		end
		
		local pTexture	= dxCreateTexture( this.m_sIconPath + sIcon + "." + this.m_sIconExt );
		
		if not pTexture then
			return NULL;
		end
		
		local pItem		=
		{
			sIcon		= sIcon;
			pTexture	= pTexture;
			vFunction	= vFunction;
			Args		= { ... };
		};
		
		if iSize == 0 then
			this.m_Items[ 0 ] = pItem;
		else
			table.insert( this.m_Items, pItem );
		end
		
		return pItem;
	end;
	
	Clear			= function( this )
		for i = 7, 1, -1 do
			if this.m_Items[ i ] then				
				destroyElement( this.m_Items[ i ].pTexture );
				
				this.m_Items[ i ].pTexture	= NULL;
				this.m_Items[ i ].vFunction = NULL;
				this.m_Items[ i ].Args		= NULL;
				
				table.remove( this.m_Items, i );
			end
		end
	end;
	
	Draw			= function( this )
		local iTick	= getTickCount();
		local fCurX, fCurY = getCursorPosition();
		
		fCurX = ( fCurX or 0.5 ) * g_iScreenX;
		fCurY = ( fCurY or 1.0 ) * g_iScreenY;
		
		if this.m_pHoverItem == NULL then
			fCurX	= this.m_iX2;
			fCurY	= this.m_iY + this.m_iSize;
		end
		
		fCurX = Clamp( this.m_iX, fCurX, this.m_iX + this.m_iSize );
		fCurY = Clamp( this.m_iY, fCurY, this.m_iY + this.m_iSize );
		
		setCursorPosition( fCurX, fCurY );
		
		local fCurRotation = ( 360 - math.deg( math.atan2( fCurX - this.m_iX2, fCurY - this.m_iY2 ) ) ) % 360;
		
		local fProgress	= Clamp( 0.0, ( iTick - this.m_iTick ) / 250, 1.0 );
		
		fProgress		= getEasingValue( fProgress, "OutBack" );
		
		local fSize		= this.m_iSize * fProgress;
		local iColor	= tocolor( this.m_pColor.R, this.m_pColor.G, this.m_pColor.B, this.m_pColor.A * fProgress );
		
		local fX	= this.m_iX + ( this.m_iSize * 0.5 ) * ( 1.0 - fProgress );
		local fY	= this.m_iY + ( this.m_iSize * 0.5 ) * ( 1.0 - fProgress );
		
		dxDrawImage( fX, fY, fSize, fSize, this.m_pTexture, fCurRotation, 0, 0, iColor, this.m_bPostGUI );
		
		for i = 0, 7 do
			local pItem = this.m_Items[ i ];
			
			if pItem then
				local fAngle = ( i * 45 ) % 360;
				
				local fX = this.m_iX2 + ( ( math.cos( math.rad( fAngle + 90 ) ) ) * ( ( this.m_iSize * 0.5 - 30 ) * fProgress ) );
				local fY = this.m_iY2 + ( ( math.sin( math.rad( fAngle + 90 ) ) ) * ( ( this.m_iSize * 0.5 - 30 ) * fProgress ) );
				
				local pColor = this.m_pIconColor;
				
				if fProgress == 1.0 then
					if ( fAngle - ( fCurRotation - 22.5 ) ) % 360 < 45 then
						pColor = this.m_pIconColorHover;
						
						this.m_pHoverItem = pItem;
					end
				end
				
				local iColor	= tocolor( pColor.R, pColor.G, pColor.B, pColor.A * fProgress );
				local iSize		= this.m_iIconSize * fProgress;
				
				dxDrawImage( fX - ( iSize / 2 ), fY - ( iSize / 2 ), iSize, this.m_iIconSize, pItem.pTexture, 0, 0, 0, iColor, true );
			end
		end
	end;
	
	static
	{
		Show		= function()
			setControlState( "look_behind", 			false );
			setControlState( "vehicle_look_behind", 	false );
			
			if CLIENT.m_pRadialMenu == NULL then
				CLIENT.m_pRadialMenu = CRadialMenu();
			end
			
			local this = CLIENT.m_pRadialMenu;
			
			this.m_pHoverItem	= NULL;
			
			local pSkin			= CLIENT:GetSkin();
			
			if not CLIENT:IsInVehicle() and CLIENT:GetHealth() > 10.0 then
				local pPlayer		= this.FindNearestPlayer( 1.0 );
				
				if pPlayer then
					local fHealth 		= pPlayer:GetHealth();
					local iFactionID	= CLIENT:GetData( "CFaction::ID" );
					
					if fHealth > 10.0 then
						this:AddItem( "13-handshake", 	CRadialMenu.FunctionPlayerHello, 	pPlayer );
						this:AddItem( "13-kiss", 		CRadialMenu.FunctionPlayerKiss, 	pPlayer );
						
						if false then
							this:AddItem( "13-marry", CRadialMenu.FunctionPlayerPropose, pPlayer );
						end
						
						if iFactionID == 2 then
							this:AddItem( "13-handcuffs", CRadialMenu.FunctionPlayerToggleCuffed, pPlayer );
						end
					elseif fHealth < 100.0 then					
						if iFactionID == 4 then
							this:AddItem( "13-heal", CRadialMenu.FunctionPlayerHeal, pPlayer );
						end
					end
				end
			end
			
			local pIntColShape = CLIENT:GetData( "CInterior::m_pColShape" );
			
			if pIntColShape and CLIENT:IsWithinColShape( pIntColShape ) then
				this:AddItem( "13-home", CRadialMenu.FunctionInteriorMenu );
			end
			
			showCursor( true, false );
			setCursorAlpha( 0 );
			setCursorPosition( this.m_iX2, this.m_iY + this.m_iSize );
			
			this.m_bVisible	= true;
			this.m_iTick	= getTickCount();
		end;
		
		Hide		= function()
			CGUI:HideCursor( false );
			
			setCursorAlpha( 255 );
			
			if CLIENT.m_pRadialMenu then
				if CLIENT.m_pRadialMenu.m_bVisible then
					CLIENT.m_pRadialMenu.m_bVisible = false;
					
					if CLIENT.m_pRadialMenu.m_pHoverItem and CLIENT.m_pRadialMenu.m_pHoverItem.vFunction then
						CLIENT.m_pRadialMenu.m_pHoverItem:vFunction( CLIENT.m_pRadialMenu.m_pHoverItem.Args and unpack( CLIENT.m_pRadialMenu.m_pHoverItem.Args ) or NULL );
					end
				end
				
				CLIENT.m_pRadialMenu:Clear();
			end
		end;
		
		FindNearestPlayer	= function( fMinDistance )
			local vecPosition	= CLIENT:GetPosition():Offset( 1.0, CLIENT:GetRotation() );
			local iDimension	= CLIENT:GetDimension();
			local fMinDistance	= fMinDistance or 2.0;
			local pPlayer		= NULL;
			
			for i, pPlr in ipairs( getElementsByType( "player", root, true ) ) do
				if pPlr ~= CLIENT and not pPlr:GetData( "adminduty" ) and pPlr:GetDimension() == iDimension and pPlr:GetHealth() > 0 then
					local fDistance = pPlr:GetPosition():Distance( vecPosition );
					
					if fDistance < fMinDistance then
						pPlayer = pPlr;
						
						fMinDistance = fDistance;
					end
				end
			end
			
			return pPlayer;
		end;
	};
	
	FunctionDemo			= function( this )
		Hint( "Radial Menu beta", "Вы выбрали пункт меню: " + this.sIcon, "info" );
	end;
	
	FunctionInteriorMenu	= function( this )
		local pIntColShape = CLIENT:GetData( "CInterior::m_pColShape" );
			
		if pIntColShape and CLIENT:IsWithinColShape( pIntColShape ) then
			SERVER.Exec( "interior openmenu " + ( pIntColShape:GetID() - "interior:" ) );
		end
	end;
	
	FunctionPlayerHello		= function( this, pPlayer )
		SERVER.Exec( "offer hello " + pPlayer:GetData( "player_id" ) );
	end;
	
	FunctionPlayerKiss		= function( this, pPlayer )
		SERVER.Exec( "offer kiss " + pPlayer:GetData( "player_id" ) );
	end;
	
	FunctionPlayerPropose	= function( this, pPlayer )
		SERVER.Exec( "offer propose " + pPlayer:GetData( "player_id" ) );
	end;
	
	FunctionPlayerDivorce	= function( this, pPlayer )
		SERVER.Exec( "offer divorce " + pPlayer:GetData( "player_id" ) );
	end;
	
	FunctionPlayerHeal		= function( this, pPlayer )
		SERVER.Exec( "heal " + pPlayer:GetData( "player_id" ) );
	end;
	
	FunctionPlayerToggleCuffed	= function( this, pPlayer )
		SERVER.Exec( "setcuffed " + pPlayer:GetData( "player_id" ) );
	end;
};
