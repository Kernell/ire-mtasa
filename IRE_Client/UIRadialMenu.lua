-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. UIRadialMenu
{
	PostGUI			= true;
	Tick			= 0;
	Items			= NULL;
	IconPath		= "Resources/Images/holo_light/";
	IconExt			= "png";
	Background		= "Resources/Images/RadialMenu.png";
	Size			= 256;
	IconSize		= 32;
	Visible			= false;
	
	UIRadialMenu	= function()
		this.ScreenX, this.ScreenY = guiGetScreenSize();
		
		this.Color			= new. Color( 255, 255, 255, 153 );
		this.ColorHover		= new. Color( 61,  181, 234, 153 );
		this.IconColor		= new. Color( 51,  51,  51,  153 );
		this.IconColorHover	= new. Color( 255, 255, 255, 153 );
		
		this.Items				= {};
		this.BackgroundTexture	= dxCreateTexture( this.Background );
		
		this.X	= ( this.ScreenX - this.Size ) / 2;
		this.Y	= ( this.ScreenY - this.Size ) / 2;
		
		this.X2	= this.X + ( this.Size / 2 );
		this.Y2	= this.Y + ( this.Size / 2 );
		
		this.AddItem( "1-navigation-cancel", NULL );
		
		function this.__Draw()
			if this.Visible then
				this.Draw();
			end
		end
		
		addEventHandler( "onClientRender", root, this.__Draw );
	end;
	
	_UIRadialMenu	= function()
		removeEventHandler( "onClientRender", root, this.__Draw );
		
		for i, texture in pairs( this.Items ) do
			destroyElement( texture );
			
			this.Items[ i ] = NULL;
		end
		
		this.__Draw	= NULL;
		this.Items	= NULL;
	end;
	
	AddItem			= function( icon, func, ... )
		if not icon then
			return NULL;
		end
		
		local size = sizeof( this.Items );
		
		if size > 7 then
			return NULL;
		end
		
		local texture	= dxCreateTexture( this.IconPath + icon + "." + this.IconExt );
		
		if not texture then
			return NULL;
		end
		
		local item		=
		{
			icon		= icon;
			texture		= texture;
			func		= func;
			args		= { ... };
		};
		
		if size == 0 then
			this.Items[ 0 ] = item;
		else
			table.insert( this.Items, item );
		end
		
		return item;
	end;
	
	Clear			= function()
		for i = 7, 1, -1 do
			if this.Items[ i ] then				
				destroyElement( this.Items[ i ].texture );
				
				this.Items[ i ].texture		= NULL;
				this.Items[ i ].func		= NULL;
				this.Items[ i ].args		= NULL;
				
				table.remove( this.Items, i );
			end
		end
	end;
	
	Draw			= function()
		local tick	= getTickCount();
		local curX, curY = getCursorPosition();
		
		curX = ( curX or 0.5 ) * this.ScreenX;
		curY = ( curY or 1.0 ) * this.ScreenY;
		
		if this.HoverItem == NULL then
			curX	= this.X2;
			curY	= this.Y + this.Size;
		end
		
		curX = Clamp( this.X, curX, this.X + this.Size );
		curY = Clamp( this.Y, curY, this.Y + this.Size );
		
		setCursorPosition( curX, curY );
		
		local curRotation = ( 360.0 - math.deg( math.atan2( curX - this.X2, curY - this.Y2 ) ) ) % 360.0;
		
		local progress	= Clamp( 0.0, ( tick - this.Tick ) / 250.0, 1.0 );
		
		progress	= getEasingValue( progress, "OutBack" );
		
		local size	= this.Size * progress;
		local color	= tocolor( this.Color.R, this.Color.G, this.Color.B, this.Color.A * progress );
		
		local x	= this.X + ( this.Size * 0.5 ) * ( 1.0 - progress );
		local y	= this.Y + ( this.Size * 0.5 ) * ( 1.0 - progress );
		
		dxDrawImage( x, y, size, size, this.BackgroundTexture, curRotation, 0, 0, color, this.PostGUI );
		
		for i = 0, 7 do
			local item = this.Items[ i ];
			
			if item then
				local angle = ( i * 45.0 ) % 360.0;
				
				local x = this.X2 + ( ( math.cos( math.rad( angle + 90.0 ) ) ) * ( ( this.Size * 0.5 - 30 ) * progress ) );
				local y = this.Y2 + ( ( math.sin( math.rad( angle + 90.0 ) ) ) * ( ( this.Size * 0.5 - 30 ) * progress ) );
				
				local color = this.IconColor;
				
				if progress == 1.0 then
					if ( angle - ( curRotation - 22.5 ) ) % 360.0 < 45.0 then
						color = this.IconColorHover;
						
						this.HoverItem = item;
					end
				end
				
				local color	= tocolor( color.R, color.G, color.B, color.A * progress );
				local size	= this.IconSize * progress;
				
				dxDrawImage( x - ( size / 2 ), y - ( size / 2 ), size, this.IconSize, item.texture, 0, 0, 0, color, true );
			end
		end
	end;
	
	Show			= function()
		setControlState( "look_behind", 		false );
		setControlState( "vehicle_look_behind", false );
		
		this.HoverItem	= NULL;
		
		this.AddItem( "2-action-settings", "Settings" );
		
		local interiorColShape = CLIENT.GetData( "Interior::ColShape" );
		
		if not CLIENT.IsInVehicle() and CLIENT.GetHealth() > 10.0 then
			local ped = this.FindNearestPed( 1.0 );
			
			if ped then
				if getElementType( ped ) == "player" then
					local health 		= ped.GetHealth();
					local factionID		= CLIENT.GetData( "Player::FactionID" );
					
					if health > 10.0 then
						this.AddItem( "13-handshake", 	"PlayerHello", 	ped );
						this.AddItem( "13-kiss", 		"PlayerKiss", 	ped );
						
						if false then 
							this.AddItem( "13-marry", "PlayerPropose",	ped );
						end
						
						if factionID == 2 then
							this.AddItem( "13-handcuffs", "PlayerToggleCuffed", ped );
						end
					elseif health < 100.0 then					
						if factionID == 4 then
							this.AddItem( "13-heal", "PlayerHeal", ped );
						end
					end
				elseif getElementType( ped ) == "ped" then
					local health = ped.GetHealth();
					
					if health > 10.0 then
						if ped.GetData( "Interactive" ) then
							this.AddItem( "6-social-chat", "NPCInteractive", ped );
						end
					end
				end
			end
		end
		
		if interiorColShape and CLIENT.IsWithinColShape( interiorColShape ) then
			this.AddItem( "13-home", "InteriorMenu" );
		end
		
		showCursor( true, false );
		setCursorPosition( this.X2, this.Y + this.Size );
		
		this.Visible	= true;
		this.Tick		= getTickCount();
	end;
	
	Hide			= function()
		UI.Cursor.Hide( root, false );
		
		if this.Visible then
			this.Visible = false;
			
			if this.HoverItem and this.HoverItem.func then
				triggerServerEvent( "onPlayerRadialMenu", CLIENT, this.HoverItem.func, this.HoverItem.args and unpack( this.HoverItem.args ) or NULL );
			end
		end
		
		this.Clear();
	end;
	
	FindNearestPed	= function( minDistance )
		local position		= CLIENT.GetPosition().Offset( 1.0, CLIENT.GetRotation() );
		local dimension		= CLIENT.GetDimension();
		local minDistance	= minDistance or NULL;
		local ped			= NULL;
		
		for i, npc in ipairs( getElementsByType( "ped", root, true ) ) do
			if npc.GetDimension() == dimension and npc.GetHealth() > 0 then
				local distance = npc.GetPosition().Distance( position );
				
				if distance < ( minDistance or 4.0 ) then
					ped = npc;
					
					minDistance = distance;
				end
			end
		end
		
		for i, player in ipairs( getElementsByType( "player", root, true ) ) do
			if player ~= CLIENT and not player.GetData( "Player::IsAdmin" ) and player.GetDimension() == dimension and player.GetHealth() > 0 then
				local distance = player.GetPosition().Distance( position );
				
				if distance < ( minDistance or 2.0 ) then
					ped = player;
					
					minDistance = distance;
				end
			end
		end
		
		return ped;
	end;
};