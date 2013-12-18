-- Innovation Roleplay Engine
--
-- Author		Kenix
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: UIRadio ( CGUI )
{
	UIRadio		= function( this )
		this.Window = this:CreateWindow( "Радио" )
		{
			X		= "center";
			Y		= "center";
			Width	= 300;
			Height	= 400;
			Sizable	= false;
		};
		
		this.Window.List	= this.Window:CreateGridList{ 25, 35, 250, 150 }
		{
			{ "Название", 1.0 };
		};
		
		this.Window.List.DoubleClick 	= function() 
			this:Play( true ); 
		end;
		
		
		for i, v in ipairs( VEHICLE_RADIO ) do
			local iRow = this.Window.List:AddRow();
			this.Window.List:SetItemText( iRow, this.Window.List[ "Название" ], v[ 1 ] );
		end
		
		this.Window.List:SetScrollBars( false, true );
		this.Window.List:SetSortingEnabled( false );
		
		this.Window.LabelTrackName = this.Window:CreateLabel( "Трек: " )
		{
			X		= 25;
			Y		= 225;
			Width	= 200;
			Height	= 80;
			Color	= { 255, 255, 0 };
			Font	= "default-bold-small";
			HorizontalAlign = { 'left', true };
		};
		
		this.Window.LabelVolume = this.Window:CreateLabel( "Громкость: " )
		{
			X		= 25;
			Y		= 250;
			Width	= 200;
			Height	= 80;
			Color	= { 255, 255, 0 };
			Font	= "default-bold-small";
			HorizontalAlign = { 'left', true };
		};
		
		this.Window.ScrollBar = this.Window:CreateScrollBar( 100, 250, 170, 25, true, false );
		this.Window.ScrollBar:SetScrollPosition( 50 );
		
		this.Window.ButtonPlay = this.Window:CreateButton( "Играть" )
		{
			X		= 100;
			Y		= 310;
			Width	= 100;
			Height	= 30;
			Click	= function()
				this:Play();
			end;
		};
		
		
		this.Window.ButtonExit = this.Window:CreateButton( "Выход" )
		{
			X		= 100;
			Y		= 350;
			Width	= 100;
			Height	= 30;
			Click	= function()
				delete( this );
			end;
		};
		
		local iCurRadioID 	= CLIENT:GetVehicle():GetData( "CVehicle::m_iRadioID" );
		local fCurVolume	= CLIENT:GetVehicle():GetData( "CVehicle::m_fRadioVolume" );
				
		this.Window.ButtonPlay:SetText( iCurRadioID == 0 and "Играть" or "Стоп" );
		this.Window.ScrollBar:SetScrollPosition( fCurVolume * 100 );
		
		
		this.Window.ScrollBar:AddCallBack( 'onClientGUIMouseUp', 
			function()
				if this.m_iCurrent ~= 0 then
					local fVolume 			= this:GetVolume();
					if this.pAsyncQuery == NULL then
						this.pAsyncQuery = AsyncQuery( "Radio__SetVolume", fVolume );
							
						function this.pAsyncQuery:Complete( iStatusCode, Data )
							this.pAsyncQuery = NULL;
							
							if iStatusCode == AsyncQuery.OK then
								if type( Data ) == "string" then
									MessageBox:Show( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
								end
							elseif type( Data ) == "string" then
								MessageBox:Show( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error );
							end
						end
					end
				end
			end 
		);
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
	end;
	
	_UIRadio	= function( this )
		this.Window:Delete();
		this.Window = NULL;
		
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		this:HideCursor();
	end;
	
	Play = function( this, bDoubleClick )
		local fVolume 			= this:GetVolume();
		local iRadioID 			= this.Window.List:GetSelectedItem();
		local bPlay				= true;
		
		if this.Window.ButtonPlay:GetText() == "Стоп" then
			bPlay = false;
		end
		
		if ( bPlay ) and ( not iRadioID or iRadioID == - 1 ) then
			return;
		end
				
		iRadioID = iRadioID + 1;
			
		if iRadioID > #VEHICLE_RADIO then
			return;
		end
			
		if not bDoubleClick then
			if this.pAsyncQuery == NULL then
				Ajax:ShowLoader( 2 );
				
				this.Window:SetEnabled( false );
				
				if bPlay then
					this.pAsyncQuery = AsyncQuery( "Radio__Play", iRadioID, fVolume );
				else
					this.pAsyncQuery = AsyncQuery( "Radio__Stop" );
				end
						
				function this.pAsyncQuery:Complete( iStatusCode, Data )
					this.m_iCurrent = iRadioID;
					this.Window.ButtonPlay:SetText( bPlay and "Стоп" or "Играть" );
					this.pAsyncQuery = NULL;
					this.Window:SetEnabled( true );
						
					Ajax:HideLoader();
					if iStatusCode == AsyncQuery.OK then
						if type( Data ) == "string" then
							MessageBox:Show( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
						end
					elseif type( Data ) == "string" then
						MessageBox:Show( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error );
					end
				end
			end
		else
			if this.pAsyncQuery == NULL then
				Ajax:ShowLoader( 2 );
				
				this.Window:SetEnabled( false );
				
				this.pAsyncQuery = AsyncQuery( "Radio__Play", iRadioID, fVolume );
				
				function this.pAsyncQuery:Complete( iStatusCode, Data )
					this.m_iCurrent = iRadioID;
					this.Window.ButtonPlay:SetText( "Стоп" );
					this.pAsyncQuery = NULL;
					this.Window:SetEnabled( true );
						
					Ajax:HideLoader();
					if iStatusCode == AsyncQuery.OK then
						if type( Data ) == "string" then
							MessageBox:Show( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
						end
					elseif type( Data ) == "string" then
						MessageBox:Show( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error );
					end
				end
			end
		end
	end;
	
	GetVolume = function( this )
		return ( this.Window.ScrollBar:GetScrollPosition() * 0.01 );
	end;
};



local function Radios( sCmd, sRadio )
	UIRadio();
end



addCommandHandler( 'radio', Radios );