-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Control
{
	AllowDrop			= false;
	BackgroundImage		= NULL;
	ClientSize			= NULL;
	ContextMenu			= NULL;
	ContextMenuStrip	= NULL;
	Controls			= NULL;
	Created				= false;

	Enabled				= true;
	Height				= 0;
	Left				= 0;
	Location			= NULL;
	Margin				= NULL;
	MaximumSize			= NULL;
	MinimumSize			= NULL;
	Name				= "";
	Padding				= NULL;
	Parent				= NULL;
	Size				= NULL;
	TabIndex			= 1;
	TabStop				= true;
	Text				= "";
	Top					= 0;
	UseWaitCursor		= false;
	Visible				= true;
	Width				= 0;

	PostGUI				= true;

	BackColor				= SystemColors.ControlBackColor;
	BorderColor 			= SystemColors.ButtonBorder;
	ForeColor 				= SystemColors.ButtonFace;

	CheckedBackColor		= Color.FromArgb( 25, 200, 200, 200 );

	MouseOverBackColor		= Color.FromArgb( 100, 200, 200, 200 );
	MouseOverBorderColor	= SystemColors.ActiveBorderVS2012;
	MouseOverForeColor		= SystemColors.ButtonFace;

	MouseDownBackColor		= Color.FromArgb( 0, 200, 200, 200 );
	MouseDownForeColor		= SystemColors.ButtonFace;
	
	Control = function()
		this.Controls	= new. ControlCollection();
		
		this.Click		= new. EventHandler( this );
		this.Focus		= new. EventHandler( this );
		this.Blur		= new. EventHandler( this );

		-- this.Click.Add( function() Debug( this.Name + "->Click" ); end );
		-- this.Focus.Add( function() Debug( this.Name + "->Focus" ); end );
		-- this.Blur.Add( function() Debug( this.Name + "->Blur" ); end );
	end;
};