-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.1.1

_showCursor = showCursor;
function showCursor( ... )
	_showCursor( ... );
	
	UpdateControls();
end

function UpdateControls()
	local Controls		= CLIENT:GetData( "CPlayer::m_Controls" );
	local ControlStates	= CLIENT:GetData( "CPlayer::m_ControlStates" );
	
	if Controls and ControlStates then
		for ctrl, bEnabled in pairs( Controls ) do
			toggleControl( ctrl, bEnabled );
		end
		
		for ctrl, bState in pairs( ControlStates ) do
			setControlState( ctrl, bState );
		end
	end
end

CGUI 			= {};
local CGUI_meta	= {};

setmetatable( CGUI, CGUI_meta );

CGUI.__type 		= "class";
CGUI.__bases		= {};
CGUI.__virtual		= {};
CGUI.__inherited	= {};
CGUI.__from			= {};
CGUI.__class 		= CGUI;
CGUI.__name 		= "CGUI";
CGUI.__index 		= CGUI;

function CGUI_meta:__call()
	local obj = {};
	
	setmetatable( obj, self );
	self.__index = self;
	
	return obj;
end

local CursorVisible = {};

local function updateCursorVisible( bToggleControls )
	showCursor( false );
	
	for key, value in pairs( CursorVisible ) do
		showCursor( true, bToggleControls );
		
		return;
	end
end

function CGUI:ShowCursor( bToggleControls )
	CursorVisible[ self ] = true;
	
	updateCursorVisible( bToggleControls );
end

function CGUI:HideCursor( bToggleControls )
	CursorVisible[ self ] = NULL;
	
	updateCursorVisible( bToggleControls );
end

function CGUI:AddCallBack( sEventName, vFunction, bGetPropagated )
	return addEventHandler( sEventName, self.__instance or root, vFunction, (bool)(bGetPropagated) );
end

-- Buttons
function CGUI:CreateButton( btn_sCaption )
	return function( this )
		this.Width		= this.Width or 80;
		this.Height		= this.Height or 30;
		
		local bRelative = this.X <= 1 and this.Y <= 1 and this.Width <= 1 and this.Height <= 1;
		
		if self.__instance then
			this.__instance  	= guiCreateButton( this.X, this.Y, this.Width, this.Height, btn_sCaption, bRelative, self.__instance );
			
			this.Parent			= self;
		else
			this.__instance  	= guiCreateButton( this.X, this.Y, this.Width, this.Height, btn_sCaption, bRelative );
		end
		
		this.__instance( this );

		addEventHandler( 'onClientGUIClick', 	this.__instance, function( ... ) if this.Click then this.Click( ... ) end end, false );
		addEventHandler( 'onClientMouseEnter', 	this.__instance, function( ... ) if this.MouseEnter then this.MouseEnter( ... ) end end, false );
		addEventHandler( 'onClientMouseLeave', 	this.__instance, function( ... ) if this.MouseLeave then this.MouseLeave( ... ) end end, false );

		setmetatable	( this, self );
		self.__index 	= self;
		
		if this.Font then
			this:SetFont( this.Font );
		end
		
		this:SetEnabled( this.Enabled == NULL or this.Enabled == true );
		
		return this;
	end
end

-- Checkboxes
function CGUI:CreateCheckBox( sCaption )
	return function( this )
		local bRelative 	= this.X <= 1 and this.Y <= 1 and this.Width <= 1 and this.Height <= 1;
		
		if self.__instance then
			this.__instance  	= guiCreateCheckBox( this.X, this.Y, this.Width, this.Height, sCaption, this.Selected, bRelative, self.__instance );
		else
			this.__instance  	= guiCreateCheckBox( this.X, this.Y, this.Width, this.Height, sCaption, this.Selected, bRelative );
		end
		
		this.__instance( this );
		
		function this:GetSelected()
			return guiCheckBoxGetSelected( self.__instance );
		end

		function this:SetSelected( state )
			return guiCheckBoxSetSelected( self.__instance, state );
		end

		setmetatable		( this, self );
		self.__index 		= self;
		
		if this.Selected then
			this:SetSelected( this.Selected );
		end
		
		if this.Font then
			this:SetFont( this.Font );
		end
		
		this:SetEnabled( this.Enabled == NULL or this.Enabled == true );
		
		function this.Click( ... )
			if this.OnClick then
				this:OnClick( ... );
			end
		end
		
		function this.MouseEnter( ... )
			if this.OnMouseEnter then
				this:OnMouseEnter( ... );
			end
		end
		
		function this.MouseLeave( ... )
			if this.OnMouseLeave then
				this:OnMouseLeave( ... );
			end
		end
		
		addEventHandler( "onClientGUIClick",	this.__instance,	this.Click,			false );
		addEventHandler( "onClientMouseEnter", 	this.__instance,	this.MouseEnter,	false );
		addEventHandler( "onClientMouseLeave", 	this.__instance,	this.MouseLeave,	false );

		return this;
	end
end

-- Comboboxes
function CGUI:CreateComboBox( cmb_sCaption )
	return function( cmb_tData )
		local relative = cmb_tData.X <= 1 and cmb_tData.Y <= 1 and cmb_tData.Width <= 1 and cmb_tData.Height <= 1;
		
		local this 		= cmb_tData;

		if self.__instance then
			this.__instance  	= guiCreateComboBox( cmb_tData.X, cmb_tData.Y, cmb_tData.Width, cmb_tData.Height, cmb_sCaption, relative, self.__instance ); -- element
			
			this.Parent 		= self;
		else
			this.__instance  	= guiCreateComboBox( cmb_tData.X, cmb_tData.Y, cmb_tData.Width, cmb_tData.Height, cmb_sCaption, relative ); 
		end
		
		this.__instance( this );
		
		function this:AddItem( value )
			return guiComboBoxAddItem( self.__instance, value ); -- int
		end

		function this:Clear()
			return guiComboBoxClear( self.__instance ); -- bool
		end

		function this:GetItemText( itemId )
			return guiComboBoxGetItemText( self.__instance, itemId ); -- string
		end

		function this:SetItemText( itemId, text )
			return guiComboBoxSetItemText( self.__instance, itemId, text ); -- bool
		end

		function this:RemoveItem( itemId )
			return guiComboBoxRemoveItem( self.__instance, itemId ); -- bool
		end

		function this:GetSelected()
			return guiComboBoxGetSelected( self.__instance ); -- int
		end
		
		function this:SetSelected( itemIndex )
			return guiComboBoxSetSelected( self.__instance, itemIndex ); -- bool
		end
		
		function this:SetItems( Items )
			for i, value in ipairs( Items ) do
				this:AddItem( value );
			end
		end
		
		if cmb_tData.Items then
			this:SetItems( cmb_tData.Items );
		end
		
		addEventHandler( 'onClientGUIComboBoxAccepted', this.__instance, function( ... ) if this.Accept then this:Accept( ... ) end end, false );

		setmetatable	( this, self );
		self.__index 	= self;

		return this;
	end
end

-- Edit fields
function CGUI:CreateEdit( sCaption )
	return function( this )
		this.Cursor	= this.Cursor or "Text";
		
		local bRelative = this.X <= 1 and this.Y <= 1 and this.Width <= 1 and this.Height <= 1;

		if self.__instance then
			this.__instance  	= guiCreateEdit( this.X, this.Y, this.Width, this.Height, sCaption, bRelative or false, self.__instance );
			
			this.Parent = self;
		else
			this.__instance  	= guiCreateEdit( this.X, this.Y, this.Width, this.Height, sCaption, bRelative or false ); 
		end
		
		this.__instance( this );
		
		function this:SetMasked( status )
			return guiEditSetMasked( self.__instance, status );
		end

		function this:SetMaxLength( length )
			return guiEditSetMaxLength( self.__instance, length );
		end

		function this:SetReadOnly( status )
			return guiEditSetReadOnly( self.__instance, status );
		end

		function this:SetCaretIndex( index )
			return guiEditSetCaretIndex( self.__instance, index );
		end
		
		if this.Masked then
			this:SetMasked( this.Masked );
		end
		
		if this.MaxLength then
			this:SetMaxLength( this.MaxLength );
		end
		
		if this.ReadOnly then
			this:SetReadOnly( this.ReadOnly );
		end
		
		if this.CaretIndex then
			this:SetCaretIndex( this.CaretIndex );
		end
		
		addEventHandler( 'onClientGUIFocus', 		this.__instance, function( ... ) if this.Focus 	then this.Focus( ... ) end end, false );
		addEventHandler( 'onClientGUIBlur', 		this.__instance, function( ... ) if this.Blur 	then this.Blur( ... ) end end, false );
		addEventHandler( 'onClientGUIAccepted', 	this.__instance, function( ... ) if this.Accept then this.Accept( ... ) end end, false );
		addEventHandler( 'onClientGUIChanged', 		this.__instance, function( ... ) if this.Change then this.Change( ... ) end end, false );
		addEventHandler( 'onClientGUIClick', 		this.__instance, function( ... ) if this.Click 	then this.Click( ... ) end end, false );
		addEventHandler( 'onClientGUIDoubleClick', 	this.__instance, function( ... ) if this.DoubleClick then this.DoubleClick( ... ) end end, false );
		
		setmetatable	( this, self );
		self.__index 	= self;
		
		if this.PlaceHolder then
			local function Focus()
				if this:GetText() == this.PlaceHolder and this:GetProperty( "NormalTextColour" ) == "FF333333" then
					this:SetText( "" );
					this:SetProperty( "NormalTextColour", "FF000000" );
				end
			end
			
			local function Blur()
				if this:GetText():len() == 0 then
					this:SetText( this.PlaceHolder );
					this:SetProperty( "NormalTextColour", "FF333333" );
				end
			end
			
			this:SetProperty( "NormalTextColour", "FF333333" );
			this:SetText( this.PlaceHolder );
			
			addEventHandler( 'onClientGUIFocus',	this.__instance, Focus, false, "high" );
			addEventHandler( 'onClientGUIBlur', 	this.__instance, Blur, 	true, "high" );
		end
		
		if this.AutoComplete then
			this.AutoComplete.Delay = this.AutoComplete.Delay or 100;
			
			local fX = 0;
			local fY = 0;
			
			local function CalculateOffset( pObject )
				fX = fX + pObject.X;
				fY = fY + pObject.Y;
				
				if pObject.Parent then
					return CalculateOffset( pObject.Parent );
				end
			end
			
			CalculateOffset( this );
			
			this.AutoComplete.DropDown	= CGUI:CreateGridList{ fX, fY + this.Height, this.Width, 150 }
			{
				{ " ", 0.8 };
			};
			
			function this.AutoComplete.DropDown:SetResult( Result )
				self:Clear();
				
				if Result then
					for i, pRow in ipairs( Result ) do
						local iRow 	= self:AddRow();
						
						if iRow then
							self:SetItemText( iRow, self[ " " ], this.AutoComplete.ParseItem( pRow ), false, false );
						end
					end
					
					self.Result = Result;
					
					self:SetVisible( true );
					self:BringToFront();
				end
			end
			
			this.AutoComplete.DropDown:SetScrollBars( false, true );
			this.AutoComplete.DropDown:SetSortingEnabled( false );
			this.AutoComplete.DropDown:SetVisible( false );
			this.AutoComplete.DropDown:SetParent( this );
			
			function this.AutoComplete.DropDown.Click( button, state )
				this.AutoComplete.DropDown:SetVisible( false );
				
				local iRow 			= this.AutoComplete.DropDown:GetSelectedItem();
				
				if not iRow or iRow == -1 then
					return;
				end
				
				this.AutoComplete.Skip = true;
				
				if this.AutoComplete.OnSelect then
					this.AutoComplete.OnSelect( this.AutoComplete.DropDown.Result[ iRow + 1 ] );
				end
			end
			
			if not this.AutoComplete.ParseItem then
				function this.AutoComplete.ParseItem( pRow )
					return pRow;
				end
			end
			
			if not this.AutoComplete.GetQuery then
				function this.AutoComplete.GetQuery( sText )
					return sText;
				end
			end
			
			local function Change()
				if this.AutoComplete.Skip then
					this.AutoComplete.Skip = NULL;
					
					return;
				end
				
				if this.AutoComplete.m_pTimer then
					this.AutoComplete.m_pTimer:Kill();
					this.AutoComplete.m_pTimer = NULL;
				end
				
				this.AutoComplete.m_pTimer = CTimer(
					function()
						this.AutoComplete.m_pTimer = NULL;
						
						local sText = this:GetText();
						
						if not sText or sText:utfLen() == 0 or sText == this.PlaceHolder then
							return;
						end
						
						if this.AutoComplete.m_pAsyncQuery then
							delete ( this.AutoComplete.m_pAsyncQuery );
							this.AutoComplete.m_pAsyncQuery = NULL;
						end
						
						if this.AutoComplete.Callback then
							this.AutoComplete.m_pAsyncQuery = new. AsyncQuery;
							
							this.AutoComplete.m_pAsyncQuery.Delay = 100;
							
							this.AutoComplete.m_pAsyncQuery:Init( this.AutoComplete.Callback, this.AutoComplete.GetQuery( sText ) );
							
							function this.AutoComplete.m_pAsyncQuery.Complete( _self, iStatusCode, Result )
								this.AutoComplete.m_pAsyncQuery = NULL;
								
								if iStatusCode == AsyncQuery.OK then
									this.AutoComplete.DropDown:SetResult( Result );
								end
							end
							
							this.AutoComplete.m_pAsyncQuery:Query();
						elseif this.AutoComplete.Items then
							this.AutoComplete.DropDown:SetResult( this.AutoComplete.Items );
						end
					end,
					300,
					1
				);
			end
			
			local function Blur()
				this.AutoComplete.DropDown:SetVisible( false );
			end
			
			addEventHandler( "onClientGUIChanged",  this.__instance, Change, false );
			addEventHandler( 'onClientGUIBlur', 	this.AutoComplete.DropDown.__instance, Blur, false );
		end

		return this;
	end
end

-- Gridlists
function CGUI:CreateGridList( grd_tData )
	return function( grd_tColumns )
		local relative = grd_tData[ 1 ] <= 1 and grd_tData[ 2 ] <= 1 and grd_tData[ 3 ]<= 1 and grd_tData[ 4 ]<= 1;
		
		local this 		=
		{
			X		= grd_tData[ 1 ];
			Y		= grd_tData[ 2 ];
			Width	= grd_tData[ 3 ];
			Height	= grd_tData[ 4 ];
			Parent	= self;
		};
		
		if self.__instance then
			this.__instance  	= guiCreateGridList( grd_tData[ 1 ], grd_tData[ 2 ], grd_tData[ 3 ], grd_tData[ 4 ], relative, self.__instance );
		else
			this.__instance  	= guiCreateGridList( grd_tData[ 1 ], grd_tData[ 2 ], grd_tData[ 3 ], grd_tData[ 4 ], relative );
		end
		
		this.__instance( this );
		
		function this:AddColumn( title, width )
			self[ title ] = guiGridListAddColumn( self.__instance, title, width );
			
			return self[ title ];
		end

		function this:AddRow()
			return guiGridListAddRow( self.__instance );
		end

		function this:AutoSizeColumn( columnIndex )
			return self, guiGridListAutoSizeColumn( self.__instance, columnIndex );
		end

		function this:Clear()
			return self, guiGridListClear( self.__instance );
		end

		function this:GetItemData( rowIndex,  columnIndex )
			return guiGridListGetItemData( self.__instance, rowIndex,  columnIndex ); -- string
		end

		function this:GetItemText( rowIndex, columnIndex )
			return guiGridListGetItemText( self.__instance, rowIndex, columnIndex ); -- string
		end

		function this:GetRowCount()
			return guiGridListGetRowCount( self.__instance ); -- int
		end

		function this:GetSelectedItem()
			return guiGridListGetSelectedItem( self.__instance );
		end

		function this:InsertRowAfter( rowIndex )
			return guiGridListInsertRowAfter( self.__instance, rowIndex ); -- int
		end

		function this:RemoveColumn( columnIndex )
			return self, guiGridListRemoveColumn( self.__instance, columnIndex ); -- bool
		end

		function this:RemoveRow( rowIndex )
			return self, guiGridListRemoveRow( self.__instance, rowIndex ); -- bool
		end

		function this:SetItemData( rowIndex, columnIndex, data )
			return self, guiGridListSetItemData( self.__instance, rowIndex, columnIndex, data ); -- bool
		end

		function this:SetItemText( rowIndex, columnIndex, text, section, number )
			return self, guiGridListSetItemText( self.__instance, rowIndex, columnIndex, text, section or false, number or false );
		end

		function this:SetScrollBars( horizontalBar, verticalBar )
			return self, guiGridListSetScrollBars( self.__instance, horizontalBar, verticalBar ); -- bool 
		end

		function this:SetSelectedItem( rowIndex, columnIndex )
			return self, guiGridListSetSelectedItem( self.__instance, rowIndex, columnIndex );
		end

		function this:SetSelectionMode( mode )
			return self, guiGridListSetSelectionMode( self.__instance, mode );
		end

		function this:SetSortingEnabled( mode )
			return self, guiGridListSetSortingEnabled( self.__instance, mode );
		end

		function this:GetSelectedCount()
			return guiGridListGetSelectedCount( self.__instance ); -- int
		end

		function this:GetSelectedItems()
			return guiGridListGetSelectedItems( self.__instance ); -- table
		end

		function this:SetColumnWidth( columnIndex, width, relative)
			return self, guiGridListSetColumnWidth( self.__instance, columnIndex, width, relative or true ); -- bool
		end

		function this:GetItemColor()
			return guiGridListGetItemColor( self.__instance, rowIndex, columnIndex ); -- int int int int 
		end

		function this:SetItemColor( rowIndex, columnIndex, red, green, blue, alpha )
			return self, guiGridListSetItemColor ( self.__instance, rowIndex, columnIndex, red, green, blue, alpha or 255 ); -- bool 
		end
		
		if grd_tColumns then
			for _, value in ipairs( grd_tColumns ) do
				this:AddColumn( value[ 1 ], value[ 2 ] );
			end
		end
		
		addEventHandler( 'onClientGUIClick', 		this.__instance, function( ... ) if this.Click 			then this.Click( ... ) 			end end, false );
		addEventHandler( 'onClientGUIDoubleClick', 	this.__instance, function( ... ) if this.DoubleClick 	then this.DoubleClick( ... ) 	end end, false );
		
		setmetatable		( this, self );
		self.__index 		= self;

		return this;
	end
end

-- Memos
function CGUI:CreateMemo( sText )
	return function( this )
		this.Cursor	= this.Cursor or "Text";
		
		local bRelative = this.X <= 1 and this.Y <= 1 and this.Width <= 1 and this.Height <= 1;
		
		if self.__instance then
			this.__instance  	= guiCreateMemo( this.X, this.Y, this.Width, this.Height, sText, bRelative, self.__instance );
		else
			this.__instance  	= guiCreateMemo( this.X, this.Y, this.Width, this.Height, sText, bRelative );
		end
		
		this.__instance( this );
		
		function this.SetReadOnly( this, status )
			return guiMemoSetReadOnly( this.__instance, status );
		end
		
		function this.SetCaretIndex( this, index )
			return guiMemoSetCaretIndex( this.__instance, index );
		end
		
		if this.ReadOnly then
			this:SetReadOnly( this.ReadOnly );
		end
		
		if this.CaretIndex then
			this:SetCaretIndex( this.CaretIndex );
		end
		
		setmetatable		( this, self );
		self.__index 		= self;

		return this;
	end
end

-- Progress bars
function CGUI:CreateProgressBar( x, y, width, height, bRelative )
	bRelative	= tobool( bRelative );
	
	local this 		= {};
	
	local fScreenX, fScreenY = guiGetScreenSize();
		
	if x == 'center' then
		x	= bRelative and ( 1.0 - width ) * .5 or ( fScreenX - width ) * .5;
	end
	
	if y == 'center' then
		y	= bRelative and ( 1.0 - height ) * .5 or ( fScreenY - height ) * .5;
	end

	if self.__instance then
		this.__instance  	= guiCreateProgressBar( x, y, width, height, bRelative, self.__instance ); -- element
	else
		this.__instance  	= guiCreateProgressBar( x, y, width, height, bRelative ); -- element
	end
	
	this.__instance( this );
	
	function this:GetProgress()
		return guiProgressBarGetProgress( self.__instance ); -- float
	end
	
	function this:SetProgress( fProgress )
		return guiProgressBarSetProgress( self.__instance, fProgress ); -- bool
	end
	
	setmetatable		( this, self );
	self.__index 		= self;

	return this;
end

-- Radio buttons
function CGUI:CreateRadioButton( sCaption )
	return function( this )
		local bRelative = this.X <= 1.0 and this.Y <= 1.0 and this.Width <= 1.0 and this.Height <= 1.0;

		if self.__instance then
			this.__instance  	= guiCreateRadioButton( this.X, this.Y, this.Width, this.Height, sCaption, bRelative, self.__instance );
		else
			this.__instance  	= guiCreateRadioButton( this.X, this.Y, this.Width, this.Height, sCaption, bRelative );
		end
		
		this.__instance( this );
		
		function this:GetSelected()
			return guiRadioButtonGetSelected( self.__instance );
		end
		
		function this:SetSelected( bSelected )
			return guiRadioButtonSetSelected( self.__instance, bSelected );
		end
		
		addEventHandler( "onClientGUIClick", 		this.__instance, function( ... ) if this.Click 			then this.Click			( ... ); end end, false );
		addEventHandler( "onClientGUIDoubleClick",	this.__instance, function( ... ) if this.DoubleClick 	then this.DoubleClick	( ... ); end end, false );
		
		setmetatable		( this, self );
		self.__index 		= self;
		
		if this.Font then
			this:SetFont( this.Font );
		end

		return this;
	end
end

-- Scrollbars
function CGUI:CreateScrollBar( x, y, width, height, horizontal, relative )
	local this 		= {};

	if self.__instance then
		this.__instance  	= guiCreateScrollBar( x, y, width, height, horizontal, relative, self.__instance ); -- gui-scrollbar 
	else
		this.__instance  	= guiCreateScrollBar( x, y, width, height, horizontal, relative ); -- gui-scrollbar 
	end
	
	this.__instance( this );
	
	function this:GetScrollPosition()
		return guiScrollBarGetScrollPosition( self.__instance ); -- float 
	end
	
	function this:SetScrollPosition( amount )
		return self, guiScrollBarSetScrollPosition( self.__instance, amount ); -- bool 
	end
	
	setmetatable		( this, self );
	self.__index 		= self;

	return this;
end

-- Scroll panes
function CGUI:CreateScrollPane( fX, fY, fWidth, fHeight, bRelative )
	local this 		= {};

	if self.__instance then
		this.__instance  	= guiCreateScrollPane( fX, fY, fWidth, fHeight, (bool)(bRelative), self.__instance ); -- element
	else
		this.__instance  	= guiCreateScrollPane( fX, fY, fWidth, fHeight, (bool)(bRelative) ); -- element
	end
	
	this.__instance( this );
	
	function this:GetHorizontalScrollPosition( ... )
		return guiScrollPaneGetHorizontalScrollPosition( self.__instance, ... ); -- ?
	end
	
	function this:GetVerticalScrollPosition( ... )
		return  guiScrollPaneGetVerticalScrollPosition( self.__instance, ... ); -- ?
	end
	
	function this:SetHorizontalScrollPosition( ... )
		return self, guiScrollPaneSetHorizontalScrollPosition( self.__instance, ... ); -- ?
	end

	function this:SetScrollBars( horizontal, vertical )
		return self, guiScrollPaneSetScrollBars( self.__instance, horizontal, vertical ); -- bool 
	end
	
	function this:SetVerticalScrollPosition( ... )
		return self, guiScrollPaneSetVerticalScrollPosition( self.__instance, ... ); -- ?
	end
	
	addEventHandler( 'onClientGUIScroll', this.__instance, function( ... ) if this.Scroll then this.Scroll( ... ) end end, false );
	
	setmetatable		( this, self );
	self.__index 		= self;

	return this;
end

-- Static images
function CGUI:CreateStaticImage( img_sPath )
	return function( aData )
		local bRelative	= 	( type( aData.X ) == 'number' and aData.X <= 1 or true ) and
							( type( aData.Y ) == 'number' and aData.Y <= 1 or true ) and 
							aData.Width <= 1 and
							aData.Height <= 1;
		
		local fScreenX, fScreenY = guiGetScreenSize();
		
		if aData.X == 'center' then
			aData.X	= bRelative and ( 1.0 - aData.Width ) * .5 or ( fScreenX - aData.Width ) * .5;
		end
		
		if aData.Y == 'center' then
			aData.Y	= bRelative and ( 1.0 - aData.Width ) * .5 or ( fScreenY - aData.Height ) * .5;
		end
		
		local instance 		= aData;

		if self.__instance then
			instance.__instance  	= guiCreateStaticImage( aData.X, aData.Y, aData.Width, aData.Height, img_sPath, bRelative, self.__instance ); -- element
		else
			instance.__instance  	= guiCreateStaticImage( aData.X, aData.Y, aData.Width, aData.Height, img_sPath, bRelative ); -- element
		end
		
		instance.__instance( instance );
		
		function instance:LoadImage( filename )
			return self, guiStaticImageLoadImage( self.__instance, filename ); -- bool 
		end
		
		addEventHandler( 'onClientGUIClick', instance.__instance, function( ... ) if instance.Click then instance.Click( ... ) end end, false );
		addEventHandler( 'onClientGUIDoubleClick', instance.__instance, function( ... ) if instance.DoubleClick then instance.DoubleClick( ... ) end end, false );
		addEventHandler( 'onClientMouseEnter', instance.__instance, function( ... ) if instance.MouseEnter then instance.MouseEnter( ... ) end end, false );
		addEventHandler( 'onClientMouseLeave', instance.__instance, function( ... ) if instance.MouseLeave then instance.MouseLeave( ... ) end end, false );

		setmetatable	( instance, self );
		self.__index 	= self;

		return instance;
	end
end

function CGUI:CreateImage( sPath )
	local function Function( pObject )
		pObject.m_sPath = sPath;
		
		local bRelative	= ( type( pObject.X ) == 'number' and pObject.X <= 1 or true ) and ( type( pObject.Y ) == 'number' and pObject.Y <= 1 or true ) and 
							pObject.Width <= 1 and pObject.Height <= 1;
		
		if pObject.X == "center" then
			pObject.X	= ( bRelative and ( 1.0 - pObject.Width ) or ( g_iScreenX - pObject.Width ) ) * .5;
		end
		
		if pObject.Y == "center" then
			pObject.Y	= ( bRelative and ( 1.0 - pObject.Width ) or ( g_iScreenY - pObject.Height ) ) * .5;
		end
		
		if self.__instance then
			pObject.m_pParent = self;
		end
		
		function pObject.OnRender()
			local fX, fY, fWidth, fHeight = pObject.X, pObject.Y, pObject.Width, pObject.Height;
			
			if pObject.m_pParent then
				if pObject.m_pParent.__instance == NULL then
					pObject:Destroy();
					
					return;
				end
				
				fX 		= fX + pObject.m_pParent.X;
				fY 		= fY + pObject.m_pParent.Y;
				fWidth	= fWidth + pObject.m_pParent.Width;
				fHeight	= fHeight + pObject.m_pParent.Height;
			end
			
			dxDrawImage( fX, fY, fWidth, fHeight, pObject.m_sPath );
		end
		
		function pObject:Destroy()
			removeEventHandler( "onClientHUDRender", root, pObject.OnRender );
		end
		
		function pObject:LoadImage( sPath )
			self.m_sPath = sPath;
		end
		
		addEventHandler( "onClientHUDRender", root, pObject.OnRender );
		
		setmetatable	( pObject, self );
		self.__index 	= self;
		
		return pObject;
	end
	
	return Function
end

-- Tab panels
function CGUI:CreateTabPanel( tab_tData )
	local relative = tab_tData.X <= 1 and tab_tData.Y <= 1 and tab_tData.Width <= 1 and tab_tData.Height <= 1;
	
	local instance 		= tab_tData;

	if self.__instance then
		instance.__instance  	= guiCreateTabPanel( tab_tData.X, tab_tData.Y, tab_tData.Width, tab_tData.Height, relative, self.__instance ); -- element
		
		instance.Parent	= self;
	else
		instance.__instance  	= guiCreateTabPanel( tab_tData.X, tab_tData.Y, tab_tData.Width, tab_tData.Height, relative ); -- element 
	end
	
	instance.__instance( instance );
	
	function instance:GetSelected()
		return guiGetSelectedTab( self.__instance ); -- element
	end

	function instance:SetSelected( theTab )
		return self, guiSetSelectedTab( self.__instance, theTab.__instance ); -- bool
	end

	setmetatable		( instance, self );
	self.__index 		= self;

	return instance;
end

-- Tabs
function CGUI:CreateTab( text, bEnabled )
	local instance 		= {};

	if self.__instance then
		instance.__instance  	= guiCreateTab( text, self.__instance ); -- element 
		
		instance.Parent = self;
	else
		instance.__instance  	= guiCreateTab( text ); -- element 
	end
	
	instance.__instance( instance );
	
	function instance:Delete( pTab )
		return guiDeleteTab( self.__instance, pTab );
	end
	
	addEventHandler( "onClientGUITabSwitched", instance.__instance, function( pTab ) if instance.Switched and pTab == instance.__instance then instance.Switched() end end, false );
	
	guiSetEnabled( instance.__instance, bEnabled == NULL or (bool)(bEnabled) );

	setmetatable		( instance, self );
	self.__index 		= self;

	return instance;
end

-- Text labels
function CGUI:CreateLabel( sCaptopn )
	return function( this )
		local bRelative		= false;
		
		if this.Width ~= "auto" then
			bRelative = this.X <= 1.0 and this.Y <= 1.0 and this.Width <= 1.0 and this.Height <= 1.0;
		end
		
		if self.__instance then
			this.__instance  	= guiCreateLabel( this.X, this.Y, (int)(this.Width), this.Height, sCaptopn, bRelative, self.__instance );
		else
			this.__instance  	= guiCreateLabel( this.X, this.Y, (int)(this.Width), this.Height, sCaptopn, bRelative );
		end
		
		this.__instance( this );
		
		function this:GetFontHeight()
			return guiLabelGetFontHeight( self.__instance );
		end
		
		function this:GetTextExtent()
			return guiLabelGetTextExtent( self.__instance );
		end 
		
		function this:SetColor( red, green, blue )
			return guiLabelSetColor( self.__instance, red, green, blue );
		end
		
		function this:SetHorizontalAlign( align, wordwrap )
			return guiLabelSetHorizontalAlign( self.__instance, align, wordwrap or false );
		end
		
		function this:SetVerticalAlign( align )
			return guiLabelSetVerticalAlign( self.__instance, align );
		end
		
		setmetatable		( this, self );
		self.__index 		= self;
		
		if this.Color then
			this:SetColor( unpack( this.Color ) );
		end
		
		if this.Font then
			this:SetFont( this.Font );
		end
		
		if this.HorizontalAlign then
			this:SetHorizontalAlign( unpack( this.HorizontalAlign ) );
		end
		
		if this.VerticalAlign then
			this:SetVerticalAlign( this.VerticalAlign );
		end
		
		if this.Width == "auto" then
			this.Width	= this:GetTextExtent();
			
			this:SetSize( this.Width, this.Height, false );
		end
		
		function this.Click( ... )
			if this.OnClick then
				this:OnClick( ... );
			end
		end
		
		function this.MouseEnter( ... )
			if this.OnMouseEnter then
				this:OnMouseEnter( ... );
			end
		end
		
		function this.MouseLeave( ... )
			if this.OnMouseLeave then
				this:OnMouseLeave( ... );
			end
		end
		
		addEventHandler( "onClientGUIClick",	this.__instance,	this.Click,			false );
		addEventHandler( "onClientMouseEnter", 	this.__instance,	this.MouseEnter,	false );
		addEventHandler( "onClientMouseLeave", 	this.__instance,	this.MouseLeave,	false );
		
		return this;
	end
end

-- Windows
function CGUI:CreateWindow( sTitle )
	return function( aData )
		local bRelative	= 	( type( aData.X ) == 'number' and aData.X <= 1 or true ) and
							( type( aData.Y ) == 'number' and aData.Y <= 1 or true ) and 
							aData.Width <= 1 and
							aData.Height <= 1;
		
		local fScreenX, fScreenY = guiGetScreenSize();
		
		if aData.X == 'center' then
			aData.X	= bRelative and ( 1.0 - aData.Width ) * .5 or ( fScreenX - aData.Width ) * .5;
		end
		
		if aData.Y == 'center' then
			aData.Y	= bRelative and ( 1.0 - aData.Width ) * .5 or ( fScreenY - aData.Height ) * .5;
		end
		
		aData.__instance  = guiCreateWindow( aData.X, aData.Y, aData.Width, aData.Height, sTitle, bRelative );
		
		aData.__instance( aData );
		
		function aData.SetSizable( this, bSizable )
			return guiWindowSetSizable( this.__instance, bSizable );
		end
		
		function aData.SetMovable( this, bMovable )
			return guiWindowSetMovable( this.__instance, bMovable );
		end
		
		if aData.Sizable ~= NULL then
			aData:SetSizable( aData.Sizable );
		end
		
		if aData.Movable ~= NULL then
			aData:SetMovable( aData.Movable );
		end

		setmetatable	( aData, self );
		self.__index 	= self;

		aData:SetVisible( (bool)(aData.Visible) );

		return aData;
	end
end

-- Other
function CGUI:SetParent( pGUI )
	return setElementParent( self.__instance, pGUI.__instance );
end

function CGUI:SetText( sText )
	return guiSetText( self.__instance, sText );
end

function CGUI:GetText()
	return guiGetText( self.__instance );
end

function CGUI:SetFont( font )
	return guiSetFont( self.__instance, font ); -- bool
end

function CGUI:SetSize( width, height, relative )
	return guiSetSize ( self.__instance, width, height, relative );
end

function CGUI:GetSize( relative )
	return guiGetSize( self.__instance, relative );
end

function CGUI:GetPosition( relative )
	return guiGetPosition( self.__instance, relative );
end

function CGUI:SetPosition( x, y, relative )
	return guiSetPosition( self.__instance, x, y, relative );
end

function CGUI:GetVisible()
	return guiGetVisible( self.__instance, bool );
end

function CGUI:SetVisible( bool )
	return guiSetVisible( self.__instance, bool );
end

function CGUI:SetAlpha( float )
	return guiSetAlpha( self.__instance, float );
end

function CGUI:GetEnabled( )
	return guiGetEnabled( self.__instance );
end

function CGUI:SetEnabled( bool )
	return guiSetEnabled( self.__instance, bool );
end

function CGUI:BringToFront( )
	return guiBringToFront( self.__instance );
end


function CGUI:SetProperty( property, value )
	return guiSetProperty( self.__instance, property, value );
end

function CGUI:GetProperty( property )
	return guiGetProperty( self.__instance, property );
end

function CGUI:Delete()
	destroyElement( self.__instance );
	
	return true;
end

function CGUI:ShowDialog( pDialog )
	pDialog.Parent	= self;
	
	if not self.m_Dialogs then
		self.m_Dialogs = {};
	end
	
	table.insert( self.m_Dialogs, pDialog );
	
	self.Window:SetEnabled( false );
	
	local sDestructor	= "_" + classname( pDialog );
	local vDestructor 	= pDialog[ sDestructor ];
	
	pDialog[ sDestructor ] = function()
		pDialog.Parent = NULL;
		
		self.Window:SetEnabled( true );
		self.Window:BringToFront();
		self:ShowCursor();
		
		if vDestructor then
			vDestructor( pDialog );
		end
		
		for i = table.getn( self.m_Dialogs ), 0, -1 do
			if self.m_Dialogs[ i ] then
				table.remove( self.m_Dialogs, i );
			end
		end
	end
	
	return pDialog;
end

local styles		=
{
	[ 2 ]		= { png = 'Resources/Images/Ajax/loading', frames = 5, sizeX = 64, sizeY = 16, offsetX = 0, offsetY = -2, rate = 100 },
};

Ajax =
{
	frame 		= 1;
	loader		= false;
	tick		= 0;
	wnd			= false;
	img			= false;
	style		= false;
	
	ShowLoader = function( this, _style )
		if this.loader then
			removeEventHandler( 'onClientRender', root, this.draw );
			destroyElement( this.wnd );
		end
		
		this.style	= _style or 1;
		this.tick 	= getTickCount();
		this.frame 	= 1;
		
		this.wnd	= guiCreateWindow( ( g_iScreenX - ( styles[ this.style ].sizeX + 72 ) ) / 2, ( g_iScreenY - 45 ) / 2, styles[ this.style ].sizeX + 72, 45, ' ', false );
		this.img	= guiCreateStaticImage( 35 + styles[ this.style ].offsetX, 20 + styles[ this.style ].offsetY, styles[ this.style ].sizeX, styles[ this.style ].sizeY, styles[ this.style ].png .. "[" .. this.frame .. "].png", false, this.wnd );
		
		-- guiSetAlpha( this.wnd, .6 );
		guiSetVisible( this.wnd, true );
		guiSetEnabled( this.wnd, false );
		guiBringToFront( this.wnd );
		
		addEventHandler( 'onClientRender', root, this.draw );
		
		this.loader = true;
		
		return this;
	end;
	
	HideLoader = function( this )
		if this.loader then
			this.loader = false;
			
			removeEventHandler( 'onClientRender', root, this.draw );
			destroyElement( this.wnd );
		end
		
		return this;
	end;
	
	draw = function()
		if getTickCount() - Ajax.tick > styles[ Ajax.style ].rate then
			Ajax.tick = getTickCount();

			guiStaticImageLoadImage( Ajax.img, styles[ Ajax.style ].png .. "[" .. Ajax.frame .. "].png" );
			
			Ajax.frame = Ajax.frame < styles[ Ajax.style ].frames and Ajax.frame + 1 or 1;
		end
	end;
};