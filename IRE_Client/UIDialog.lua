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
			local value 		= xmlNodeGetValue( node );
			
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
				attributes._value 	= value;
				
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
		
		if this.OnShow then
			this.OnShow();
		end
	end;
	
	Hide		= function()
		if this.OnHide then
			this.OnHide();
		end
		
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
				
				if data.id then
					this.ElementIDs[ data.id ] = element;
					
					if not this[ data.id ] then
						this[ data.id ] = element;
					end
				end
				
				if data.name then
					this.ElementNames[ data.name ] = element;
				end
				
				if data.icon then
					local iconPath = "Resources/Images/holo_light/" + data.icon + ".png";
					
					if fileExists( iconPath ) then
						local texture	= dxCreateTexture( iconPath, "argb", false, "wrap" );
						
						if texture then
							local size		= data.width - ( data.width % 16 );
							
							local x			= ( data.width - size ) / 2;
							local y			= ( data.height - size ) / 2;
							local width		= size;
							local height	= size;
							
							local function GetPosition( element )
								local x, y = element.GetPosition( false );
								
								if element.Parent then
									local _x, _y = GetPosition( element.Parent );
									
									x, y = x + _x, y + _y;
								end
								
								return x, y;
							end
							
							function element.IconDrawing()
								if isElement( element ) and element.GetVisible() then
									local elementX, elementY = GetPosition( element );
									
									dxDrawImage( x + elementX, y + elementY, size, size, texture, 0, 0, 0, -1, true );
								else
									removeEventHandler( "onClientRender", root, element.IconDrawing );
								end
							end
							
							addEventHandler( "onClientRender", root, element.IconDrawing );	
						end
					end
				end
				
				if element then
					element.Parent		= parent;
					element.Name		= data.name;
					element.Title		= data.title;
					element.X			= data.x;
					element.Y			= data.y;
					element.Width		= data.width;
					element.Height		= data.height;
					element.Type		= data.nodeName;
					element.NoValue 	= (bool)(data.novalue);
					element.Pattern		= data.pattern;
					element.MaxLength	= (int)(data.maxlength);
					element.Required	= (bool)(data.required);
					
					if data.autocomplete and data.nodeName == "input" then
						this.InitAutoComplete( element, data.autocomplete );
					end
					
					if data.hidden and (bool)(data.hidden) then
						element.SetVisible( false );
					end
					
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
					
					if data.onchange then
						element.OnChange = data.onchange;
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
		
		local function onChange( sender, e, ... )
			if sender.OnChange then
				this.OnEvent( sender, e, sender.OnChange, ... );
			end
		end
		
		window.OnClientGUIClick.Add( onClick, true );
		window.OnClientGUIDoubleClick.Add( onDoubleClick, true );
		window.OnClientGUIAccepted.Add( onAccept, true );
		window.OnClientGUIComboBoxAccepted.Add( onAccept, true );
		window.OnClientGUIChanged.Add( onChange, true );
		
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
			element.SetPlaceHolder( data.placeholder );
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
		
		element.Items = {};
		
		function element.GetValue()
			local item = element.GetSelected();
			
			if not item then
				return NULL;
			end
			
			local text = element.GetItemText( item );
			
			if not text then
				return NULL;
			end
			
			return element.Items[ text ];
		end
		
		function element.SetValue( value )
			for i = 0, sizeof( element.Items ) do
				local text = element.GetItemText( i );
				
				if text == value then
					element.SetSelected( i );
					
					return;
				end
			end
		end
		
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
			if data._value then
				parent.AddItem( data._value );
				
				parent.Items[ data._value ] = data.value or data._value;
			end
		end
	end;
	
	InitAutoComplete	= function( element, callbackName )
		element.AutoComplete	=
		{
			Delay		= 300;
			Callback	= callbackName;
		};
		
		local function GetPosition( object )
			local x, y = object.GetPosition( false );
			
			if object.Parent then
				local _x, _y = GetPosition( object.Parent );
				
				x, y = x + _x, y + _y;
			end
			
			return x, y;
		end
		
		local x, y = GetPosition( element );
		
		local dropDown	= new. CEGUIGridList( x, y + element.Height, element.Width, 150, false );
		
		dropDown.AddColumn( " ", 0.8 );
		dropDown.SetScrollBars( false, true );
		dropDown.SetSortingEnabled( false );
		dropDown.SetVisible( false );
		dropDown.SetParent( element );
		
		local function SetResult( result )
			dropDown.Clear();
			
			if result then
				for i, item in ipairs( result ) do
					local row = dropDown.AddRow();
					
					if row then
						dropDown.SetItemText( row, dropDown[ " " ], item.value, false, false );
						dropDown.SetItemData( row, dropDown[ " " ], item.id );
					end
				end
				
				dropDown.SetVisible( true );
				dropDown.BringToFront();
			else
				dropDown.SetVisible( false );
			end
		end
		
		local function Click( button, state )
			dropDown.SetVisible( false );
			
			local row = dropDown.GetSelectedItem();
			
			if not row or row == -1 then
				return;
			end
			
			element.AutoComplete.Skip = true;
			
			element.value = dropDown.GetItemData( row, dropDown[ " " ] ) or NULL;
			
			element.SetText( dropDown.GetItemText( row, dropDown[ " " ] ) or "" );
		end
		
		local function Change()
			if element.AutoComplete.Skip then
				element.AutoComplete.Skip = NULL;
				
				return;
			end
			
			if element.AutoComplete.Timer then
				killTimer( element.AutoComplete.Timer );
				element.AutoComplete.Timer = NULL;
			end
			
			local function query()
				element.AutoComplete.Timer = NULL;
				
				local stringQuery = element.GetText();
				
				if not stringQuery or stringQuery:utfLen() == 0 or stringQuery == element.PlaceHolder then
					return;
				end
				
				if element.AutoComplete.Callback then
					local c = coroutine.create(
						function()
							local result = NULL;
							
							if this[ element.AutoComplete.Callback ] then
								result = this[ element.AutoComplete.Callback ]( stringQuery );
							else
								result = SERVER.PlayerManager( element.AutoComplete.Callback, stringQuery );
							end
							
							SetResult( result );
						end
					);
					
					local success, message = coroutine.resume( c );
					
					if not success then
						Debug( tostring( message ), 1 );
					end
				end
			end
			
			element.AutoComplete.Timer = setTimer( query, element.AutoComplete.Delay, 1 );
		end
		
		local function Blur()
			dropDown.SetVisible( false );
		end
		
		local function Focus()
			dropDown.SetVisible( true );
		end
		
		addEventHandler( "onClientGUIChanged",  element, Change, false );
		addEventHandler( "onClientGUIClick", 	dropDown, Click, false );
		addEventHandler( "onClientGUIBlur", 	dropDown, Blur, false );
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
		if this[ eventName ] then
			this[ eventName ]( sender, data );
			
			return;
		end
		
		local count = 0;
		local data = {};
		
		if not sender.NoValue then		
			for name, element in pairs( this.ElementNames ) do
				local value = element.value or element.GetValue();
				
				if value then
					if type( value ) == "string" then
						if element.MaxLength > 0 and value:utfLen() > element.MaxLength then
							return this.Error( "Поле \"" + ( element.Title or element.Name ) + "\" превышает допустимую длину" );
						end
						
						if element.Pattern and not pregFind( value, element.Pattern ) then
							return this.Error( "Поле \"" + ( element.Title or element.Name ) + "\" заполнено не верно" );
						end
					end
					
					count = count + 1;
					
					data[ name ] = value;
				elseif element.Required then
					return this.Error( "Поле \"" + ( element.Title or element.Name ) + "\" обязательно для заполнения" );
				end
			end
			
			if count == 0 then
				return;
			end
		end
		
		this.Window.SetEnabled( false );
		
		local result = SERVER.PlayerManager( eventName, data );
		
		this.Window.SetEnabled( true );
		
		if type( result ) == "string" then	
			this.Error( result );
		elseif result == -1 then
			this.Destroy();
		end
	end;
};
