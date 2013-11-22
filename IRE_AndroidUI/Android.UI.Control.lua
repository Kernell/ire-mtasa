-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "Android.UI.Control"
{
	AllowDrop			= false;
	BackgroundImage		= NULL;
	ClientSize			= NULL;
	ContextMenu			= NULL;
	ContextMenuStrip	= NULL;
	Controls			= NULL;
	Created				= false;
	DefaultCursor		= NULL;
	BackColor			= Android.UI.SystemColors.BackColor;
	DefaultBackColor	= Android.UI.SystemColors.BackColor;
	ForeColor			= Android.UI.SystemColors.ControlText;
	DefaultForeColor	= Android.UI.SystemColors.ControlText;
	DefaultMargin		= NULL;
	DefaultMaximumSize	= NULL;
	DefaultMinimumSize	= NULL;
	DefaultPadding		= NULL;
	DefaultSize			= NULL;
	Enabled				= true;
	Location			= NULL;
	Margin				= NULL;
	MaximumSize			= NULL;
	MinimumSize			= NULL;
	Name				= "";
	Padding				= NULL;
	Parent				= NULL;
	PostGUI				= false;
	Size				= NULL;
	TabIndex			= 1;
	TabStop				= true;
	Text				= "";
	UseWaitCursor		= false;
	Visible				= true;
	Click				= NULL;
	Theme				= Android.UI.THEME_HOLO_DARK;
	Width				= 0;
	Height				= 0;
	X					= 0;
	Y					= 0;
	
	Control = function( this, pParent )
		this.Theme		= Settings.Android.Theme;
		
		this.Controls	= this:ControlCollection( pParent );
		
		this.Click		= Android.EventHandler( this );
		
		pParent.Controls:Add( this );
	end;
	
	_Control = function( this )
		
	end;
	
	Init	= function( this )
		function this.__Draw()
			local iCurX, iCurY = getCursorPosition();
			
			iCurX, iCurY = ( iCurX or 0 ) * g_iScreenX, ( iCurY or 0 ) * g_iScreenY;
			
			this:Render( iCurX, iCurY );
		end
		
		function this.__Click( sMouseButton, sState, iCurX, iCurY )
			if sState == "down" then
				if this.MouseOverControl then
					this.MouseDownControl = this.MouseOverControl;
					
					if sMouseButton == "left" then
						this.DragDropOffset	= Android.UI.Point( iCurX - this.Location.X, iCurY - this.Location.Y );
					end
				end
			elseif sState == "up" then
				if this.MouseDownControl and this.MouseOverControl and this.MouseOverControl == this.MouseDownControl then
					this.MouseDownControl.Click:Call();
				end
				
				this.MouseDownControl = NULL;
			end
		end
		
		addEventHandler( "onClientRender", root, this.__Draw );
		addEventHandler( "onClientClick", root, this.__Click );
	end;
	
	Release	= function( this )
		removeEventHandler( "onClientRender", root, this.__Draw );
		removeEventHandler( "onClientClick", root, this.__Click );
		
		this.__Draw		= NULL;
		this.__Click	= NULL;
	end;
	
	Draw	= function( this )
		
	end;
	
	Render	= function( this, iCurX, iCurY )
		if this.Visible then
			if this.Location then				
				this.X		= this.Location.X + ( this.Parent and this.Parent.X or 0 );
				this.Y		= this.Location.Y + ( this.Parent and this.Parent.Y or 0 );
			end
			
			if this.Size then
				this.Width	= this.Size.X;
				this.Height	= this.Size.Y;
			end
			
			if this.Parent then
				if iCurX > this.X and iCurX < this.X + this.Width and iCurY > this.Y and iCurY < this.Y + this.Height then
					this.Parent.MouseOverControl = ( this.Parent.MouseDownControl == NULL or this.Parent.MouseDownControl == this ) and this or NULL;
				end
				
				this.MouseOver = this.Parent.MouseOverControl == this;
				this.MouseDown = this.Parent.MouseDownControl == this;
			end
			
			this:Draw();
			
			for i, pControl in this.Controls.Begin() do
				pControl:Draw( iCurX, iCurY );
			end
		end
	end;
	
	Hide = function( this )
		this.Visible = false;
	end;
	
	Show = function( this )
		this.Visible = true;
	end;
	
	GetIconsPath	= function( this )
		return Android.UI.IMAGES_PATH + ( this.Theme == Android.UI.THEME_HOLO_LIGHT and "holo_light/" or "holo_dark/" );
	end;
};

class "Android.UI.Control.ControlCollection"
{
	ControlCollection = function( this, pParent )
		this.Parent		= pParent;
		
		this.m_List		= {};
		
		this.Add		= function( pControl )
			pControl.Parent	= this.Parent;
			
			table.insert( this.m_List, pControl );
		end
		
		this.Begin		= function()
			local i	= 0;
			local l	= table.getn( this.m_List );
			
			local function iter()
				i = i + 1;
				
				if i <= l then
					return i, this.m_List[ i ];
				end
				
				return NULL;
			end
			
			return iter;
		end
	end;
};
