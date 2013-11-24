-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CUIFactionStaffCard ( CGUI, CUIAsyncQuery )
{
	X		= "center";
	Y		= "center";
	Width	= 600;
	Height	= 400;
	
	Fields	=
	{
		{
			Name	= "Имя";
			X		= 15;
			Y		= 25;
			Width	= 140;
			Height	= 25;
		};
		{
			Name	= "Фамилия";
			X		= 15 + 140 + 20;
			Y		= 25;
			Width	= 140;
			Height	= 25;
		};
		{
			Name	= "Дата приёма";
			X		= 15;
			Y		= 55;
			Width	= 140;
			Height	= 25;
		};
		{
			Name	= "Отдел";
			X		= 15;
			Y		= 80;
			Width	= 140;
			Height	= 25;
		};
		{
			Name	= "Должность";
			X		= 15;
			Y		= 105;
			Width	= 140;
			Height	= 25;
		};
		{
			Name	= "Оклад";
			X		= 15;
			Y		= 130;
			Width	= 140;
			Height	= 25;
		};
	};
	
	CUIFactionStaffCard		= function( this, iMemberID )
		this.Window		= this:CreateWindow( "Карточка сотрудника" )
		{
			X			= this.X;
			Y			= this.Y;
			Width		= this.Width;
			Height		= this.Height;
			Sizable		= false;
		};
		
		this.Label	= {};
		this.Edit	= {};
		
		for i, Field in ipairs( this.Fields ) do
			this.Label[ Field.Name ]	= this.Window:CreateLabel( Field.Name )
			{
				X		= Field.X;
				Y		= Field.Y + 3;
				Width	= Field.Width;
				Height	= Field.Height;
			};
			
			this.Edit[ Field.Name ]		= this.Window:CreateEdit( "" )
			{
				X		= Field.X + 10 + Field.Width;
				Y		= Field.Y;
				Width	= Field.Width - 50;
				Height	= Field.Height;
			};
		end
		
		this.Window.ButtonClose	= this.Window:CreateButton( "Закрыть" )
		{
			X		= this.Width - 90;
			Y		= this.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				delete ( this );
			end;
		};
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
	end;
	
	_CUIFactionStaffCard	= function( this )
		this.Window:Delete();
		this.Window = NULL;
		
		this:HideCursor();
	end;
};