-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
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

CGUI.__type 		= 'class';
CGUI.__bases		= {};
CGUI.__virtual		= {};
CGUI.__inherited	= {};
CGUI.__from			= {};
CGUI.__class 		= CGUI;
CGUI.__name 		= 'CGUI';
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
	CursorVisible[ self ] = nil;
	
	updateCursorVisible( bToggleControls );
end

function CGUI:AddCallBack( sEventName, vFunction, bGetPropagated )
	return addEventHandler( sEventName, self.__instance or root, vFunction, (bool)(bGetPropagated) );
end

-- Buttons
function CGUI:CreateButton( btn_sCaption )
	return function( btn_tData )
		local instance 		= btn_tData;
		
		btn_tData.Width		= btn_tData.Width or 80;
		btn_tData.Height	= btn_tData.Height or 30;
		
		local bRelative = btn_tData.X <= 1 and btn_tData.Y <= 1 and btn_tData.Width <= 1 and btn_tData.Height <= 1;
		
		if self.__instance then
			instance.__instance  	= guiCreateButton( btn_tData.X, btn_tData.Y, btn_tData.Width, btn_tData.Height, btn_sCaption, bRelative, self.__instance );
			
			instance.Parent			= self;
		else
			instance.__instance  	= guiCreateButton( btn_tData.X, btn_tData.Y, btn_tData.Width, btn_tData.Height, btn_sCaption, bRelative );
		end

		addEventHandler( 'onClientGUIClick', instance.__instance, function( ... ) if instance.Click then instance.Click( ... ) end end, false );
		addEventHandler( 'onClientMouseEnter', instance.__instance, function( ... ) if instance.MouseEnter then instance.MouseEnter( ... ) end end, false );
		addEventHandler( 'onClientMouseLeave', instance.__instance, function( ... ) if instance.MouseLeave then instance.MouseLeave( ... ) end end, false );

		setmetatable	( instance, self );
		self.__index 	= self;
		
		if btn_tData.Font then
			instance:SetFont( btn_tData.Font );
		end
		
		instance:SetEnabled( btn_tData.Enabled == NULL or btn_tData.Enabled == true );
		
		return instance;
	end
end

-- Checkboxes
function CGUI:CreateCheckBox( cbx_sCaption )
	return function( cbx_tData )
		local relative 	= cbx_tData.X <= 1 and cbx_tData.Y <= 1 and cbx_tData.Width <= 1 and cbx_tData.Height <= 1;
		
		local instance 	= {};

		if self.__instance then
			instance.__instance  	= guiCreateCheckBox( cbx_tData.X, cbx_tData.Y, cbx_tData.Width, cbx_tData.Height, cbx_sCaption, cbx_tData.Selected, relative, self.__instance ); -- element
		else
			instance.__instance  	= guiCreateCheckBox( cbx_tData.X, cbx_tData.Y, cbx_tData.Width, cbx_tData.Height, cbx_sCaption, cbx_tData.Selected, relative ); -- element
		end
		
		function instance:GetSelected()
			return guiCheckBoxGetSelected( self.__instance );
		end

		function instance:SetSelected( state )
			return guiCheckBoxSetSelected( self.__instance, state ); -- bool
		end

		setmetatable		( instance, self );
		self.__index 		= self;

		return instance;
	end
end

-- Comboboxes
function CGUI:CreateComboBox( cmb_sCaption )
	return function( cmb_tData )
		local relative = cmb_tData.X <= 1 and cmb_tData.Y <= 1 and cmb_tData.Width <= 1 and cmb_tData.Height <= 1;
		
		local instance 		= cmb_tData;

		if self.__instance then
			instance.__instance  	= guiCreateComboBox( cmb_tData.X, cmb_tData.Y, cmb_tData.Width, cmb_tData.Height, cmb_sCaption, relative, self.__instance ); -- element
			
			instance.Parent 		= self;
		else
			instance.__instance  	= guiCreateComboBox( cmb_tData.X, cmb_tData.Y, cmb_tData.Width, cmb_tData.Height, cmb_sCaption, relative ); 
		end
		
		function instance:AddItem( value )
			return guiComboBoxAddItem( self.__instance, value ); -- int
		end

		function instance:Clear()
			return guiComboBoxClear( self.__instance ); -- bool
		end

		function instance:GetItemText( itemId )
			return guiComboBoxGetItemText( self.__instance, itemId ); -- string
		end

		function instance:SetItemText( itemId, text )
			return guiComboBoxSetItemText( self.__instance, itemId, text ); -- bool
		end

		function instance:RemoveItem( itemId )
			return guiComboBoxRemoveItem( self.__instance, itemId ); -- bool
		end

		function instance:GetSelected()
			return guiComboBoxGetSelected( self.__instance ); -- int
		end
		
		function instance:SetSelected( itemIndex )
			return guiComboBoxSetSelected( self.__instance, itemIndex ); -- bool
		end
		
		if cmb_tData.Items then
			for i, value in ipairs( cmb_tData.Items ) do
				instance:AddItem( value );
			end
		end
		
		addEventHandler( 'onClientGUIComboBoxAccepted', instance.__instance, function( ... ) if instance.Accept then instance:Accept( ... ) end end, false );

		setmetatable	( instance, self );
		self.__index 	= self;

		return instance;
	end
end

-- Edit fields
function CGUI:CreateEdit( sCaption )
	return function( this )
		local bRelative = this.X <= 1 and this.Y <= 1 and this.Width <= 1 and this.Height <= 1;

		if self.__instance then
			this.__instance  	= guiCreateEdit( this.X, this.Y, this.Width, this.Height, sCaption, bRelative or false, self.__instance );
			
			this.Parent = self;
		else
			this.__instance  	= guiCreateEdit( this.X, this.Y, this.Width, this.Height, sCaption, bRelative or false ); 
		end
		
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
		
		local instance 		=
		{
			X		= grd_tData[ 1 ];
			Y		= grd_tData[ 2 ];
			Width	= grd_tData[ 3 ];
			Height	= grd_tData[ 4 ];
			Parent	= self;
		};
		
		if self.__instance then
			instance.__instance  	= guiCreateGridList( grd_tData[ 1 ], grd_tData[ 2 ], grd_tData[ 3 ], grd_tData[ 4 ], relative, self.__instance );
		else
			instance.__instance  	= guiCreateGridList( grd_tData[ 1 ], grd_tData[ 2 ], grd_tData[ 3 ], grd_tData[ 4 ], relative );
		end
		
		function instance:AddColumn( title, width )
			self[ title ] = guiGridListAddColumn( self.__instance, title, width );
			
			return self[ title ];
		end

		function instance:AddRow()
			return guiGridListAddRow( self.__instance );
		end

		function instance:AutoSizeColumn( columnIndex )
			return self, guiGridListAutoSizeColumn( self.__instance, columnIndex );
		end

		function instance:Clear()
			return self, guiGridListClear( self.__instance );
		end

		function instance:GetItemData( rowIndex,  columnIndex )
			return guiGridListGetItemData( self.__instance, rowIndex,  columnIndex ); -- string
		end

		function instance:GetItemText( rowIndex, columnIndex )
			return guiGridListGetItemText( self.__instance, rowIndex, columnIndex ); -- string
		end

		function instance:GetRowCount()
			return guiGridListGetRowCount( self.__instance ); -- int
		end

		function instance:GetSelectedItem()
			return guiGridListGetSelectedItem( self.__instance );
		end

		function instance:InsertRowAfter( rowIndex )
			return guiGridListInsertRowAfter( self.__instance, rowIndex ); -- int
		end

		function instance:RemoveColumn( columnIndex )
			return self, guiGridListRemoveColumn( self.__instance, columnIndex ); -- bool
		end

		function instance:RemoveRow( rowIndex )
			return self, guiGridListRemoveRow( self.__instance, rowIndex ); -- bool
		end

		function instance:SetItemData( rowIndex, columnIndex, data )
			return self, guiGridListSetItemData( self.__instance, rowIndex, columnIndex, data ); -- bool
		end

		function instance:SetItemText( rowIndex, columnIndex, text, section, number )
			return self, guiGridListSetItemText( self.__instance, rowIndex, columnIndex, text, section or false, number or false );
		end

		function instance:SetScrollBars( horizontalBar, verticalBar )
			return self, guiGridListSetScrollBars( self.__instance, horizontalBar, verticalBar ); -- bool 
		end

		function instance:SetSelectedItem( rowIndex, columnIndex )
			return self, guiGridListSetSelectedItem( self.__instance, rowIndex, columnIndex );
		end

		function instance:SetSelectionMode( mode )
			return self, guiGridListSetSelectionMode( self.__instance, mode );
		end

		function instance:SetSortingEnabled( mode )
			return self, guiGridListSetSortingEnabled( self.__instance, mode );
		end

		function instance:GetSelectedCount()
			return guiGridListGetSelectedCount( self.__instance ); -- int
		end

		function instance:GetSelectedItems()
			return guiGridListGetSelectedItems( self.__instance ); -- table
		end

		function instance:SetColumnWidth( columnIndex, width, relative)
			return self, guiGridListSetColumnWidth( self.__instance, columnIndex, width, relative or true ); -- bool
		end

		function instance:GetItemColor()
			return guiGridListGetItemColor( self.__instance, rowIndex, columnIndex ); -- int int int int 
		end

		function instance:SetItemColor( rowIndex, columnIndex, red, green, blue, alpha )
			return self, guiGridListSetItemColor ( self.__instance, rowIndex, columnIndex, red, green, blue, alpha or 255 ); -- bool 
		end
		
		if grd_tColumns then
			for _, value in ipairs( grd_tColumns ) do
				instance:AddColumn( value[ 1 ], value[ 2 ] );
			end
		end
		
		addEventHandler( 'onClientGUIClick', instance.__instance, function( ... ) if instance.Click then instance.Click( ... ) end end, false );
		addEventHandler( 'onClientGUIDoubleClick', instance.__instance, function( ... ) if instance.DoubleClick then instance.DoubleClick( ... ) end end, false );
		
		setmetatable		( instance, self );
		self.__index 		= self;

		return instance;
	end
end

-- Memos
function CGUI:CreateMemo( mem_sText )
	return function( mem_tData )
		local relative = mem_tData.X <= 1 and mem_tData.Y <= 1 and mem_tData.Width <= 1 and mem_tData.Height <= 1;
		
		local instance 		= mem_tData;

		if self.__instance then
			instance.__instance  	= guiCreateMemo( mem_tData.X, mem_tData.Y, mem_tData.Width, mem_tData.Height, mem_sText, relative, self.__instance ); -- gui-memo
		else
			instance.__instance  	= guiCreateMemo( mem_tData.X, mem_tData.Y, mem_tData.Width, mem_tData.Height, mem_sText, relative ); -- gui-memo
		end
		
		function instance.SetReadOnly( this, status )
			return guiMemoSetReadOnly( this.__instance, status ); -- bool 
		end
		
		function instance.SetCaretIndex( this, index )
			return guiMemoSetCaretIndex( this.__instance, index ); -- bool 
		end
		
		if mem_tData.ReadOnly then
			instance:SetReadOnly( mem_tData.ReadOnly );
		end
		
		if mem_tData.CaretIndex then
			instance:SetCaretIndex( mem_tData.CaretIndex );
		end
		
		setmetatable		( instance, self );
		self.__index 		= self;

		return instance;
	end
end

-- Progress bars
function CGUI:CreateProgressBar( x, y, width, height, bRelative )
	bRelative	= tobool( bRelative );
	
	local instance 		= {};
	
	local fScreenX, fScreenY = guiGetScreenSize();
		
	if x == 'center' then
		x	= bRelative and ( 1.0 - width ) * .5 or ( fScreenX - width ) * .5;
	end
	
	if y == 'center' then
		y	= bRelative and ( 1.0 - height ) * .5 or ( fScreenY - height ) * .5;
	end

	if self.__instance then
		instance.__instance  	= guiCreateProgressBar( x, y, width, height, bRelative, self.__instance ); -- element
	else
		instance.__instance  	= guiCreateProgressBar( x, y, width, height, bRelative ); -- element
	end
	
	function instance:GetProgress()
		return guiProgressBarGetProgress( self.__instance ); -- float
	end
	
	function instance:SetProgress( fProgress )
		return guiProgressBarSetProgress( self.__instance, fProgress ); -- bool
	end
	
	setmetatable		( instance, self );
	self.__index 		= self;

	return instance;
end

-- Radio buttons
function CGUI:CreateRadioButton( btn_sCaption )
	return function( btn_tData )
		local relative = btn_tData.X <= 1 and btn_tData.Y <= 1 and btn_tData.Width <= 1 and btn_tData.Height <= 1;
		
		local instance 		= btn_tData;

		if self.__instance then
			instance.__instance  	= guiCreateRadioButton( btn_tData.X, btn_tData.Y, btn_tData.Width, btn_tData.Height, btn_sCaption, relative, self.__instance ); -- element 
		else
			instance.__instance  	= guiCreateRadioButton( btn_tData.X, btn_tData.Y, btn_tData.Width, btn_tData.Height, btn_sCaption, relative ); -- element 
		end
		
		function instance:GetSelected()
			return guiRadioButtonGetSelected( self.__instance ); -- bool 
		end
		
		function instance:SetSelected( bSelected )
			return guiRadioButtonSetSelected( self.__instance, bSelected ); -- bool 
		end
		
		addEventHandler( 'onClientGUIClick', instance.__instance, function( ... ) if instance.Click then instance.Click( ... ) end end, false );
		addEventHandler( 'onClientGUIDoubleClick', instance.__instance, function( ... ) if instance.DoubleClick then instance.DoubleClick( ... ) end end, false );
		
		setmetatable		( instance, self );
		self.__index 		= self;

		return instance;
	end
end

-- Scrollbars
function CGUI:CreateScrollBar( x, y, width, height, horizontal, relative )
	local instance 		= {};

	if self.__instance then
		instance.__instance  	= guiCreateScrollBar( x, y, width, height, horizontal, relative, self.__instance ); -- gui-scrollbar 
	else
		instance.__instance  	= guiCreateScrollBar( x, y, width, height, horizontal, relative ); -- gui-scrollbar 
	end
	
	function instance:GetScrollPosition()
		return guiScrollBarGetScrollPosition( self.__instance ); -- float 
	end
	
	function instance:SetScrollPosition( amount )
		return self, guiScrollBarSetScrollPosition( self.__instance, amount ); -- bool 
	end
	
	setmetatable		( instance, self );
	self.__index 		= self;

	return instance;
end

-- Scroll panes
function CGUI:CreateScrollPane( fX, fY, fWidth, fHeight, bRelative )
	local instance 		= {};

	if self.__instance then
		instance.__instance  	= guiCreateScrollPane( fX, fY, fWidth, fHeight, (bool)(bRelative), self.__instance ); -- element
	else
		instance.__instance  	= guiCreateScrollPane( fX, fY, fWidth, fHeight, (bool)(bRelative) ); -- element
	end
	
	function instance:GetHorizontalScrollPosition( ... )
		return guiScrollPaneGetHorizontalScrollPosition( self.__instance, ... ); -- ?
	end
	
	function instance:GetVerticalScrollPosition( ... )
		return  guiScrollPaneGetVerticalScrollPosition( self.__instance, ... ); -- ?
	end
	
	function instance:SetHorizontalScrollPosition( ... )
		return self, guiScrollPaneSetHorizontalScrollPosition( self.__instance, ... ); -- ?
	end

	function instance:SetScrollBars( horizontal, vertical )
		return self, guiScrollPaneSetScrollBars( self.__instance, horizontal, vertical ); -- bool 
	end
	
	function instance:SetVerticalScrollPosition( ... )
		return self, guiScrollPaneSetVerticalScrollPosition( self.__instance, ... ); -- ?
	end
	
	addEventHandler( 'onClientGUIScroll', instance.__instance, function( ... ) if instance.Scroll then instance.Scroll( ... ) end end, false );
	
	setmetatable		( instance, self );
	self.__index 		= self;

	return instance;
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
function CGUI:CreateLabel( lbl_sCaptopn )
	return function( lbl_tData )
		local relative = lbl_tData.X <= 1 and lbl_tData.Y <= 1 and lbl_tData.Width <= 1 and lbl_tData.Height <= 1;
		
		local instance 		= lbl_tData;

		if self.__instance then
			instance.__instance  	= guiCreateLabel( lbl_tData.X, lbl_tData.Y, lbl_tData.Width, lbl_tData.Height, lbl_sCaptopn, relative, self.__instance ); -- element
		else
			instance.__instance  	= guiCreateLabel( lbl_tData.X, lbl_tData.Y, lbl_tData.Width, lbl_tData.Height, lbl_sCaptopn, relative ); -- element
		end
		
		function instance:GetFontHeight()
			return guiLabelGetFontHeight( self.__instance );
		end

		function instance:GetTextExtent()
			return guiLabelGetTextExtent( self.__instance );
		end 

		function instance:SetColor( red, green, blue )
			return guiLabelSetColor( self.__instance, red, green, blue );
		end

		function instance:SetHorizontalAlign( align, wordwrap )
			return guiLabelSetHorizontalAlign( self.__instance, align, wordwrap or false );
		end

		function instance:SetVerticalAlign( align )
			return guiLabelSetVerticalAlign( self.__instance, align );
		end
		
		setmetatable		( instance, self );
		self.__index 		= self;
		
		if lbl_tData.Color then
			instance:SetColor( unpack( lbl_tData.Color ) );
		end
		
		if lbl_tData.Font then
			instance:SetFont( lbl_tData.Font );
		end
		
		if lbl_tData.HorizontalAlign then
			instance:SetHorizontalAlign( unpack( lbl_tData.HorizontalAlign ) );
		end
		
		if lbl_tData.VerticalAlign then
			instance:SetVerticalAlign( lbl_tData.VerticalAlign );
		end
		
		function instance.Click( ... )
			if instance.OnClick then
				instance:OnClick( ... );
			end
		end
		
		function instance.MouseEnter( ... )
			if instance.OnMouseEnter then
				instance:OnMouseEnter( ... );
			end
		end
		
		function instance.MouseLeave( ... )
			if instance.OnMouseLeave then
				instance:OnMouseLeave( ... );
			end
		end
		
		addEventHandler( "onClientGUIClick",	instance.__instance,	instance.Click,			false );
		addEventHandler( "onClientMouseEnter", 	instance.__instance,	instance.MouseEnter,	false );
		addEventHandler( "onClientMouseLeave", 	instance.__instance,	instance.MouseLeave,	false );
		
		return instance;
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
	local bool = destroyElement( self.__instance );
	if bool then
		self = nil;
	end
	return bool;
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