-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. CEGUI
{
	event. OnClientGUIClick;
	event. OnClientGUIDoubleClick;
	event. OnClientGUIChanged;
	event. OnClientGUIAccepted;
	event. OnClientGUIScroll;
	event. OnClientClick;
	event. OnClientDoubleClick;
	event. OnClientKey;
	event. OnClientCharacter;
	event. OnClientMouseEnter;
	event. OnClientMouseLeave;
	event. OnClientMouseMove;
	event. OnClientMouseWheel;
	event. OnClientCursorMove;
	event. OnClientGUIMouseDown;
	event. OnClientGUIMouseUp;
	event. OnClientGUIMove;
	event. OnClientGUISize;
	event. OnClientGUITabSwitched;
	event. OnClientGUIComboBoxAccepted;
	event. OnClientGUIFocus;
	event. OnClientGUIBlur;
	
	CEGUI		= function( guiElement )
		guiElement( this );
		
		return guiElement;
	end;
	
	SetParent	= function( guiParent )
		return setElementParent( this, guiParent );
	end;

	SetText		= function( text )
		return guiSetText( this, text );
	end;

	GetText		= function()
		return guiGetText( this );
	end;
	
	GetValue	= function()
		return guiGetText( this );
	end;

	SetFont		= function( font )
		return guiSetFont( this, font );
	end;

	SetSize		= function( width, height, relative )
		return guiSetSize ( this, width, height, relative );
	end;

	GetSize		= function( relative )
		return guiGetSize( this, relative );
	end;

	GetPosition	= function( relative )
		return guiGetPosition( this, relative );
	end;

	SetPosition	= function( x, y, relative )
		return guiSetPosition( this, x, y, relative );
	end;

	GetVisible	= function()
		return guiGetVisible( this );
	end;

	SetVisible	= function( visible )
		return guiSetVisible( this, visible );
	end;

	SetAlpha	= function( alpha )
		return guiSetAlpha( this, alpha );
	end;

	GetEnabled	= function()
		return guiGetEnabled( this );
	end;

	SetEnabled	= function( enabled )
		return guiSetEnabled( this, enabled );
	end;

	BringToFront	= function()
		return guiBringToFront( this );
	end;
	
	SetProperty	= function( prop, value )
		return guiSetProperty( this, prop, value );
	end;

	GetProperty	= function( prop )
		return guiGetProperty( this, prop );
	end;

	Delete	= function()
		destroyElement( this );
		
		return true;
	end;
	
	ShowCursor	= function( toggleControls )
		UI.Cursor.Show( this, toggleControls );
	end;
	
	HideCursor	= function( toggleControls )
		UI.Cursor.Hide( this, toggleControls );
	end;
	
	ShowDialog	= function( pDialog )
		pDialog.Parent	= this;
		
		if not this.m_Dialogs then
			this.m_Dialogs = {};
		end
		
		table.insert( this.m_Dialogs, pDialog );
		
		this.Window.SetEnabled( false );
		
		local sDestructor	= "_" + classname( pDialog );
		local vDestructor 	= pDialog[ sDestructor ];
		
		pDialog[ sDestructor ] = function()
			pDialog.Parent = NULL;
			
			this.Window.SetEnabled( true );
			this.Window.BringToFront();
			this.ShowCursor();
			
			if vDestructor then
				vDestructor( pDialog );
			end
			
			for i = table.getn( this.m_Dialogs ), 0, -1 do
				if this.m_Dialogs[ i ] then
					table.remove( this.m_Dialogs, i );
				end
			end
		end
		
		return pDialog;
	end;
};

class. CEGUIWindow : CEGUI
{
	CEGUIWindow		= function( x, y, width, height, title, relative )
		local guiElement = guiCreateWindow( x, y, width, height, title, relative );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	SetSizable	= function( sizable )
		return guiWindowSetSizable( this, sizable );
	end;
	
	SetMovable	= function( movable )
		return guiWindowSetMovable( this, movable );
	end;
};

class. CEGUILabel : CEGUI
{
	CEGUILabel			= function( x, y, width, height, caption, relative, parent )
		local guiElement = guiCreateLabel( x, y, width, height, caption, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	GetFontHeight		= function()
		return guiLabelGetFontHeight( this );
	end;
	
	GetTextExtent		= function()
		return guiLabelGetTextExtent( this );
	end;
	
	SetColor			= function( red, green, blue )
		return guiLabelSetColor( this, red, green, blue );
	end;
	
	SetHorizontalAlign	= function( align, wordwrap )
		return guiLabelSetHorizontalAlign( this, align, wordwrap or false );
	end;
	
	SetVerticalAlign	= function( align )
		return guiLabelSetVerticalAlign( this, align );
	end;
};

class. CEGUITab : CEGUI
{
	CEGUITab	= function( text, parent )
		local guiElement = guiCreateTab( text, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	Delete	= function( parent )
		return guiDeleteTab( this, parent );
	end;
};

class. CEGUITabPanel : CEGUI
{
	CEGUITabPanel	= function( x, y, width, height, relative, parent )
		local guiElement = guiCreateTabPanel( x, y, width, height, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	GetSelected	= function()
		return guiGetSelectedTab( this );
	end;

	SetSelected	= function( parent )
		return guiSetSelectedTab( this, parent );
	end;
};

class. CEGUIImage : CEGUI
{
	CEGUIImage	= function( x, y, width, height, path, relative, parent )
		local guiElement = guiCreateStaticImage( x, y, width, height, path, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	LoadImage	= function( filename )
		return guiStaticImageLoadImage( this, filename );
	end;
};

class. CEGUIScrollPane : CEGUI
{
	CEGUIScrollPane	= function( x, y, width, height, relative, parent )
		local guiElement = guiCreateScrollPane( x, y, width, height, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	GetHorizontalScrollPosition	= function()
		return guiScrollPaneGetHorizontalScrollPosition( this );
	end;
	
	GetVerticalScrollPosition	= function()
		return  guiScrollPaneGetVerticalScrollPosition( this );
	end;
	
	SetHorizontalScrollPosition	= function( position )
		return guiScrollPaneSetHorizontalScrollPosition( this, position );
	end;

	SetScrollBars	= function( horizontal, vertical )
		return guiScrollPaneSetScrollBars( this, horizontal, vertical ); 
	end;
	
	SetVerticalScrollPosition	= function( position )
		return guiScrollPaneSetVerticalScrollPosition( this, position );
	end;
};

class. CEGUIScrollBar : CEGUI
{
	CEGUIScrollBar = function( x, y, width, height, horizontal, relative, parent )
		local guiElement = guiCreateScrollBar( x, y, width, height, horizontal, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	GetScrollPosition	= function()
		return guiScrollBarGetScrollPosition( this );
	end;
	
	SetScrollPosition	= function( amount )
		return guiScrollBarSetScrollPosition( this, amount );
	end
};

class. CEGUIRadioButton : CEGUI
{
	CEGUIRadioButton	= function( x, y, width, height, caption, relative, parent )
		local guiElement = guiCreateRadioButton( x, y, width, height, caption, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	GetSelected	= function()
		return guiRadioButtonGetSelected( this );
	end;
	
	SetSelected	= function( selected )
		return guiRadioButtonSetSelected( this, selected );
	end;
	
	GetValue	= function()
		return guiRadioButtonGetSelected( this );
	end;
};

class. CEGUIProgressBar : CEGUI
{
	CEGUIProgressBar	= function( x, y, width, height, relative, parent )
		local guiElement = guiCreateProgressBar( x, y, width, height, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	GetProgress	= function()
		return guiProgressBarGetProgress( this );
	end;
	
	SetProgress	= function( progress )
		return guiProgressBarSetProgress( this, progress );
	end;
};

class. CEGUIMemo : CEGUI
{
	CEGUIMemo	= function( x, y, width, height, text, relative, parent )
		local guiElement = guiCreateMemo( x, y, width, height, text, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	SetReadOnly		= function( status )
		return guiMemoSetReadOnly( this, status );
	end;
	
	SetCaretIndex	= function( index )
		return guiMemoSetCaretIndex( this, index );
	end;
};

class. CEGUIGridList : CEGUI
{
	CEGUIGridList	= function( x, y, width, height, relative, parent )
		local guiElement = guiCreateGridList( x, y, width, height, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	AddColumn	= function( title, width )
		this[ title ] = guiGridListAddColumn( this, title, width );
		
		return this[ title ];
	end;

	AddRow	= function()
		return guiGridListAddRow( this );
	end;

	AutoSizeColumn	= function( columnIndex )
		return guiGridListAutoSizeColumn( this, columnIndex );
	end;

	Clear		= function()
		return guiGridListClear( this );
	end;

	GetItemData	= function( rowIndex,  columnIndex )
		return guiGridListGetItemData( this, rowIndex,  columnIndex );
	end;
	
	GetItemText	= function( rowIndex, columnIndex )
		return guiGridListGetItemText( this, rowIndex, columnIndex );
	end;

	GetRowCount	= function()
		return guiGridListGetRowCount( this );
	end;

	GetSelectedItem	= function()
		return guiGridListGetSelectedItem( this );
	end;

	InsertRowAfter	= function( rowIndex )
		return guiGridListInsertRowAfter( this, rowIndex );
	end;

	RemoveColumn	= function( columnIndex )
		return guiGridListRemoveColumn( this, columnIndex );
	end;
	
	RemoveRow	= function( rowIndex )
		return guiGridListRemoveRow( this, rowIndex );
	end;
	
	SetItemData	= function( rowIndex, columnIndex, data )
		return guiGridListSetItemData( this, rowIndex, columnIndex, data );
	end;
	
	SetItemText	= function( rowIndex, columnIndex, text, section, number )
		return guiGridListSetItemText( this, rowIndex, columnIndex, text, section or false, number or false );
	end;
	
	SetScrollBars	= function( horizontalBar, verticalBar )
		return guiGridListSetScrollBars( this, horizontalBar, verticalBar );
	end;
	
	SetSelectedItem	= function( rowIndex, columnIndex )
		return guiGridListSetSelectedItem( this, rowIndex, columnIndex );
	end;
	
	SetSelectionMode	= function( mode )
		return guiGridListSetSelectionMode( this, mode );
	end;
	
	SetSortingEnabled	= function( mode )
		return guiGridListSetSortingEnabled( this, mode );
	end;
	
	GetSelectedCount	= function()
		return guiGridListGetSelectedCount( this );
	end;

	GetSelectedItems	= function()
		return guiGridListGetSelectedItems( this );
	end;

	SetColumnWidth	= function( columnIndex, width, relative)
		return guiGridListSetColumnWidth( this, columnIndex, width, relative or true );
	end;

	GetItemColor	= function()
		return guiGridListGetItemColor( this, rowIndex, columnIndex );
	end;
	
	SetItemColor	= function( rowIndex, columnIndex, red, green, blue, alpha )
		return guiGridListSetItemColor( this, rowIndex, columnIndex, red, green, blue, alpha or 255 );
	end;
};

class. CEGUIEdit : CEGUI
{
	Cursor		= "Text";
	
	CEGUIEdit	= function( x, y, width, height, caption, relative, parent )
		local guiElement = guiCreateEdit( x, y, width, height, caption, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	SetPlaceHolder	= function( text )
		if this.PlaceHolderFocus then
			removeEventHandler( "event. OnClientGUIFocus",	this, this.PlaceHolderFocus );
		end
		
		if this.PlaceHolderBlur then
			removeEventHandler( "event. OnClientGUIBlur", 	this, this.PlaceHolderBlur );
		end
		
		this.PlaceHolderFocus	= NULL;
		this.PlaceHolderBlur	= NULL;
		
		if text then
			function this.PlaceHolderFocus()
				if this.GetText() == text and this.GetProperty( "NormalTextColour" ) == "FF333333" then
					this.SetText( "" );
					this.SetProperty( "NormalTextColour", "FF000000" );
				end
			end
			
			function this.PlaceHolderBlur()
				if this.GetText():len() == 0 then
					this.SetText( text );
					this.SetProperty( "NormalTextColour", "FF333333" );
				end
			end
			
			this.SetProperty( "NormalTextColour", "FF333333" );
			this.SetText( text );
			
			addEventHandler( "event. OnClientGUIFocus",	this, this.PlaceHolderFocus,	false, "high" );
			addEventHandler( "event. OnClientGUIBlur", 	this, this.PlaceHolderBlur, 	true, "high" );
		end
	end;
	
	SetMasked	= function( status )
		return guiEditSetMasked( this, status );
	end;
	
	SetMaxLength	= function( length )
		return guiEditSetMaxLength( this, length );
	end;
	
	SetReadOnly	= function( status )
		return guiEditSetReadOnly( this, status );
	end;
	
	SetCaretIndex	= function( index )
		return guiEditSetCaretIndex( this, index );
	end;
};

class. CEGUIComboBox : CEGUI
{
	CEGUIComboBox	= function( x, y, width, height, caption, relative, parent )
		local guiElement = guiCreateComboBox( x, y, width, height, caption, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	AddItem	= function( value )
		return guiComboBoxAddItem( this, value );
	end;

	Clear	= function()
		return guiComboBoxClear( this );
	end;

	GetItemText	= function( itemId )
		return guiComboBoxGetItemText( this, itemId );
	end;

	SetItemText	= function( itemId, text )
		return guiComboBoxSetItemText( this, itemId, text );
	end;

	RemoveItem	= function( itemId )
		return guiComboBoxRemoveItem( this, itemId );
	end;

	GetSelected	= function()
		return guiComboBoxGetSelected( this );
	end;
	
	SetSelected	= function( itemIndex )
		return guiComboBoxSetSelected( this, itemIndex );
	end;
	
	SetItems	= function( Items )
		for i, value in ipairs( Items ) do
			this.AddItem( value );
		end
	end;
};

class. CEGUICheckBox : CEGUI
{
	CEGUICheckBox	= function( x, y, width, height, caption, selected, relative, parent )
		local guiElement = guiCreateCheckBox( x, y, width, height, caption, selected, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
	
	GetSelected	= function()
		return guiCheckBoxGetSelected( this );
	end;
	
	SetSelected	= function( state )
		return guiCheckBoxSetSelected( this, state );
	end;
	
	GetValue	= function()
		return guiCheckBoxGetSelected( this );
	end;
};

class. CEGUIButton : CEGUI
{
	CEGUIButton	= function( x, y, width, height, caption, relative, parent )
		local guiElement = guiCreateButton( x, y, width, height, caption, relative, parent );
		
		guiElement( this );
		
		return guiElement;
	end;
};
