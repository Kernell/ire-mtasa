-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

local WM;

class. WindowManager
{
	CurrentWindow	= NULL;
	List			= NULL;

	static
	{
		Add		= function( window )
			WM.List.Insert( window );

			WM.CurrentWindow = window;
		end;

		Remove	= function( window )
			for i = WM.List.Length(), 1, -1 do
				if WM.List[ i ] == window then
					WM.List.Remove( i );
				end
			end
		end;

		IsInList	= function( window )
			for i = WM.List.Length(), 1, -1 do
				if WM.List[ i ] == window then
					return true;
				end
			end

			return false;
		end;

		BringToFront	= function( window )
			WindowManager.Remove( window );
			WindowManager.Add( window );

			WM.CurrentWindow = window;
		end;

		GetCurrent		= function()
			return WM.CurrentWindow;
		end;
	};

	WindowManager	= function()
		this.List	= new {};

		function this.__Draw()
			local curX, curY = getCursorPosition();
			
			curX, curY = ( curX or 0 ) * Screen.Width, ( curY or 0 ) * Screen.Height;
			
			this.Draw( curX, curY );
		end

		function this.__Click( mouseButton, state, curX, curY )
			this.Click( mouseButton, state, curX, curY );
		end
	end;

	_WindowManager	= function()
		removeEventHandler( "onClientClick", root, this.__Click );
		removeEventHandler( "onClientRender", root, this.__Draw );
	end;

	Initialize		= function()
		addEventHandler( "onClientRender", root, this.__Draw );
		addEventHandler( "onClientClick", root, this.__Click );
	end;

	Draw			= function( curX, curY )
		for i = 1, WM.List.Length(), 1 do
			local window = WM.List[ i ];

			window.Draw( curX, curY );
		end
	end;

	Click			= function( mouseButton, state, curX, curY )
		local oldWindow = this.CurrentWindow;

		this.CurrentWindow = NULL;

		for i = WM.List.Length(), 1, -1 do
			local window = WM.List[ i ];

			if curX > window.Left and curX < window.Left + window.Width and curY > window.Top and curY < window.Top + window.Height then
				this.CurrentWindow = window;

				window.BringToFront();

				break;
			end
		end

		local window = this.CurrentWindow;

		if oldWindow and oldWindow ~= window and state == "down" then
			if oldWindow.FocusedControl then
				oldWindow.FocusedControl.Blur.Call();
			end

			oldWindow.FocusedControl = NULL;
		end

		if window == NULL then
			return;
		end

		if state == "down" then
			local oldFocus = window.FocusedControl;

			window.FocusedControl = NULL;

			if window.MouseOverControl then
				window.MouseDownControl = window.MouseOverControl;
				
				if mouseButton == "left" then
					window.FocusedControl = window.MouseOverControl;

					if oldFocus ~= window.FocusedControl then
						window.FocusedControl.Focus.Call();
					end

					window.DragDropOffset = new. Point( curX - window.Location.X, curY - window.Location.Y );
				end
			end

			if mouseButton == "left" and oldFocus and ( window.FocusedControl == NULL or window.FocusedControl ~= oldFocus ) then
				oldFocus.Blur.Call();
			end
		elseif state == "up" then
			if window.MouseDownControl and window.MouseOverControl and window.MouseOverControl == window.MouseDownControl then
				window.MouseDownControl.Click.Call( mouseButton, curX, curY );
			end
			
			window.MouseDownControl = NULL;
		end
	end;
}

WM = new. WindowManager();

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		WM.Initialize();
	end
);