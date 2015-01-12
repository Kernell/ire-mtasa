-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. UIDialog
{
	static
	{
		Nodes	=
		{
			window		= "CreateWindow";
			label		= "CreateLabel";
			tab			= "CreateTab";
			tabpanel	= "CreateTabPanel";
			image		= "CreateImage";
			scrollpane	= "CreateScrollPane";
			scrollbar	= "CreateScrollBar";
			radiobutton	= "CreateRadioButton";
			progressbar	= "CreateProgressBar";
			memo		= "CreateMemo";
			gridlist	= "CreateGridList";
			column		= "AddGridListColumn";
			input		= "CreateEdit";
			select		= "CreateComboBox";
			checkbox	= "CreateCheckBox";
			button		= "CreateButton";
			
			item	 	= "AddItem";
		};
	};
	
	Name		= NULL;
	
	UIDialog	= function( name )
		this.BufferX, this.BufferY = guiGetScreenSize();
		
		if type( name ) ~= "string" then
			error( "bad argument #1 for 'name' (expected string, got " + type( name ) + ")", 2 );
		end
		
		local path	= "UI/" + name + ".xml";
		
		if fileExists( path ) then
			this.Name	= name;
			this.Struct	= {};
			this.Vars	= {};
			
			local xml = xmlLoadFile( path );
			
			if xml then
				this.LoadNode( this.Struct, xml );
				
				xmlUnloadFile( xml );
			end
		end
	end;
	
	_UIDialog	= function()
		this.Hide();
		
		resourceRoot.UI.UIList[ this.Name ] = NULL;
		
		this.Name	= NULL;
		this.Struct	= NULL;
		this.Vars	= NULL;
	end;
	
	Destroy		= function()
		delete ( this );
	end;
	
	LoadNode	= function( struct, xmlNode )
		for i, node in ipairs( xmlNodeGetChildren( xmlNode ) ) do
			local nodeName		= xmlNodeGetName( node );
			local attributes	= xmlNodeGetAttributes( node );
			
			if nodeName == "var" then
				this.Vars[ attributes.name ] = attributes.value;
			else			
				if attributes.font then
					attributes.font = UI.Font.CEGUI( unpack( string.split( attributes.font, " " ) ) );
				end
				
				if attributes.color then
					attributes.color = string.split( attributes.color, "," );
				end
				
				if attributes.horizontalalign then
					attributes.horizontalalign = string.split( attributes.horizontalalign, " " );
				end
				
				attributes.node 	= node;
				attributes.nodeName = nodeName;
				
				table.insert( struct, attributes );
			end
			
			this.LoadNode( attributes, node );
		end
	end;
	
	Show		= function( vars, data )
		if vars then
			for key, value in pairs( vars ) do
				this.Vars[ key ] = value;
			end
		end
		
		if this.Window then
			this.Hide();
		end
		
		this.ElementNames = {};
		this.ElementIDs = {};
		
		this.Create( this.Struct );
		
		if data then
			for name, items in pairs( data ) do
				local list = this.ElementNames[ name ];
				
				if list then
					this.FillGridList( list, items );
				end
			end
		end
		
		this.Window.ShowCursor();
	end;
	
	Hide		= function()
		if this.Window then
			this.Window.HideCursor();
		
			destroyElement( this.Window );
		end
		
		this.Window = NULL;
		
		this.ElementNames = NULL;
		this.ElementIDs = NULL;
	end;
	
	IsVisible	= function()
		return this.Window and guiGetVisible( this.Window );
	end;
	
	IsValid		= function()
		return this.Name ~= NULL;
	end;
	
	Create		= function( struct, parent )
		for i, data in ipairs( struct ) do
			local funcName = UIDialog.Nodes[ data.nodeName ];
			
			if funcName then
				for key, value in pairs( data ) do
					if type( value ) == "string" and value[ 1 ] == "{" and value[ -1 ] == "}" then
						local varName = value:sub( 2, -2 );
						
						if this.Vars[ varName ] ~= NULL then
							data[ key ] = this.Vars[ varName ];
						end
					end
				end
				
				if data.nodeName == "window" then
					data.x			= data.x or "center";
					data.y			= data.y or "center";
					data.width		= data.width or ( this.BufferX * 0.5 );
					data.height		= data.height or ( this.BufferY * 0.5 );
				else
					data.x			= data.x or 20;
					data.y			= data.y or 20;
					data.width		= data.width or 64;
					data.height		= data.height or 64;
				end
				
				data.relative	= false;
				
				if typeof( data.x ) == "number" and typeof( data.y ) == "number" then
					data.relative = data.x <= 1.0 and data.y <= 1.0 and data.width <= 1.0 and data.height <= 1.0;
				end
				
				if data.x == "center" then
					data.x	= data.relative and ( 1.0 - data.width ) * 0.5 or ( this.BufferX - data.width ) * 0.5;
				end
				
				if data.y == "center" then
					data.y	= data.relative and ( 1.0 - data.width ) * 0.5 or ( this.BufferY - data.height ) * 0.5;
				end
				
				local element = this[ funcName ]( data, parent );
				
				if data.name then
					this.ElementNames[ data.name ] = element;
				end
				
				if element then
					element.Parent	= parent;
					element.Name	= data.name;
					element.X		= data.x;
					element.Y		= data.y;
					element.Width	= data.width;
					element.Height	= data.height;
					element.Type	= data.node;
					
					if type( data.enabled ) ~= "nil" then
						element.SetEnabled( (bool)(data.enabled) );
					end
					
					if data.cursor then
						element.Cursor = data.cursor;
					end
					
					if data.onclick then
						element.OnClick = data.onclick;
					end
					
					if data.ondoubleclick then
						element.OnDoubleClick = data.ondoubleclick;
					end
					
					if data.onaccept then
						element.OnAccept = data.onaccept;
					end
					
					this.Create( data, element );
				end
			end
		end
	end;
	
	CreateWindow		= function( data )
		local window = new. CEGUIWindow( data.x, data.y, data.width, data.height, data.title or "", data.relative );
		
		if data.sizable ~= NULL then
			window.SetSizable( (bool)(data.sizable) );
		end
		
		if data.movable ~= NULL then
			window.SetMovable( (bool)(data.movable) );
		end
		
		local function onClick( sender, e, ... )
			if sender.OnClick then
				this.OnEvent( sender, e, sender.OnClick, ... );
			end
		end
		
		local function onDoubleClick( sender, e, ... )
			if sender.OnDoubleClick then
				this.OnEvent( sender, e, sender.OnDoubleClick, ... );
			end
		end
		
		local function onAccept( sender, e, ... )
			if sender.OnAccept then
				this.OnEvent( sender, e, sender.OnAccept, ... );
			end
		end
		
		window.OnClientGUIClick.Add( onClick, true );
		window.OnClientGUIDoubleClick.Add( onDoubleClick, true );
		window.OnClientGUIAccepted.Add( onAccept, true );
		
		this.Window = window;
		
		return window;
	end;
	
	CreateLabel			= function( data, parent )
		local element	= new. CEGUILabel( data.x, data.y, data.width, data.height, data.text, data.relative, parent );
		
		if data.font then
			element.SetFont( data.font );
		end
		
		if data.color then
			element.SetColor( unpack( data.color ) );
		end
		
		if data.horizontalalign then
			element.SetHorizontalAlign( data.horizontalalign[ 1 ], (bool)(data.horizontalalign[ 2 ]) );
		end
		
		if data.verticalAlign then
			element.SetVerticalAlign( data.verticalAlign );
		end
		
		return element;
	end;
	
	CreateTab			= function( data, parent )
		local element	= new. CEGUITab( data.text, parent );
		
		if data.selected then
			parent.SetSelected( element );
		end
		
		return element;
	end;
	
	CreateTabPanel		= function( data, parent )
		local element	= new. CEGUITabPanel( data.x, data.y, data.width, data.height, data.relative, parent );
		
		return element;
	end;
	
	CreateImage			= function( data, parent )
		local element	= new. CEGUIImage( data.x, data.y, data.width, data.height, data.src, data.relative, parent );
		
		return element;
	end;
	
	CreateScrollPane	= function( data, parent )
		local element	= new. CEGUIScrollPane( data.x, data.y, data.width, data.height, data.relative, parent );
		
		element.SetScrollBars( data.horizontal ~= NULL, data.vertical ~= NULL );
		
		if data.horizontal then
			element.SetHorizontalScrollPosition( data.horizontal );
		end
		
		if data.vertical then
			element.SetVerticalScrollPosition( data.vertical );
		end
		
		return element;
	end;
	
	CreateScrollBar		= function( data, parent )
		local element	= new. CEGUIScrollBar( data.x, data.y, data.width, data.height, data.align == "horizontal", data.relative, parent );
		
		return element;
	end;
	
	CreateRadioButton	= function( data, parent )
		local element	= new. CEGUIRadioButton( data.x, data.y, data.width, data.height, data.text, data.relative, parent );
		
		if data.selected then
			element.SetSelected( true );
		end
		
		return element;
	end;
	
	CreateProgressBar	= function( data, parent )
		local element	= new. CEGUIProgressBar( data.x, data.y, data.width, data.height, data.relative, parent );
		
		if data.progress then
			element.SetProgress( data.progress );
		end
		
		return element;
	end;
	
	CreateMemo			= function( data, parent )
		local element	= new. CEGUIMemo( data.x, data.y, data.width, data.height, data.text, data.relative, parent );
		
		if data.readonly then
			element.SetReadOnly( true );
		end
		
		if data.caret then
			element.SetCaretIndex( data.caret );
		end
		
		return element;
	end;
	
	CreateGridList		= function( data, parent )
		local element	= new. CEGUIGridList( data.x, data.y, data.width, data.height, data.relative, parent );
		
		return element;
	end;
	
	AddGridListColumn	= function( data, parent )
		local index = parent.AddColumn( data.title, data.width );
		
		if not parent.columns then
			parent.columns = {};
		end
		
		parent.columns[ data.title ] =
		{
			index	= index;
			title	= data.title;
			name	= data.name;
		};
	end;
	
	FillGridList		= function( list, items )
		for i, item in pairs( items ) do
			local row 	= list.AddRow();
			
			if row then
				for title, column in pairs( list.columns ) do				
					local name = column.name;
					
					list.SetItemText( row, column.index, item[ name ], false, false );
					list.SetItemData( row, column.index, item.id );
				end
			end
		end
	end;
	
	CreateEdit			= function( data, parent )
		local element	= new. CEGUIEdit( data.x, data.y, data.width, data.height, data.value, data.relative, parent );
		
		if data.placeholder then
			element.SetPlaceHolder( data.placeholders );
		end
		
		if data.masked then
			element.SetMasked( (bool)(data.masked) );
		end
		
		if data.maxlength then
			element.SetMaxLength( data.maxlength );
		end
		
		if data.readonly then
			element.SetReadOnly( true );
		end
		
		if data.caret then
			element.SetCaretIndex( data.caret );
		end
		
		return element;
	end;
	
	CreateComboBox		= function( data, parent )
		local element	= new. CEGUIComboBox( data.x, data.y, data.width, data.height, data.text, data.relative, parent );
		
		return element;
	end;
	
	CreateCheckBox		= function( data, parent )
		local element	= new. CEGUICheckBox( data.x, data.y, data.width, data.height, data.text, (bool)(data.checked), data.relative, parent );
		
		return element;
	end;
	
	CreateButton		= function( data, parent )
		local element	= new. CEGUIButton( data.x, data.y, data.width, data.height, data.text, data.relative, parent );
		
		return element;
	end;
	
	AddItem				= function( data, parent )
		local parentType = parent and parent.Type;
		
		if parentType == "select" then
			local value = xmlNodeGetValue( data.node );
			
			if value then
				parent.AddItem( value );
			end
		end
	end;
	
	--
	
	Error				= function( text )
		local errorElement = this.ElementIDs.error;
		
		if errorElement then
			errorElement.SetText( text );
		else
			this.Window.ShowDialog( new. MessageBox( text, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error ) );
		end
	end;
	
	-- Event raisers
	
	OnEvent		= function( sender, e, eventName, ... )
		local count = 0;
		local data = {};
		
		for name, element in pairs( this.ElementNames ) do
			data[ name ] = element.GetValue();
			
			if data[ name ] then
				count = count + 1;
			end
		end
		
		if count == 0 then
			return;
		end
		
		this.Window.SetEnabled( false );
		
		local result = SERVER.PlayerManager( eventName, data );
		
		this.Window.SetEnabled( true );
		
		if type( result ) == "string" then	
			this.Error( result );
		elseif result == -1 then
			this.Hide();
		end
	end;
};
