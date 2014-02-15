-- Innovation Roleplay Engine
--
-- Author		Kenix
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CUISettings ( CGUI, CUIAsyncQuery )
{
	X		= "center";
	Y		= "center";
	Width	= 650;
	Height	= 450;
	
	static
	{
		L18n	=
		{
			Graphics	=
			{
				Shaders	=
				{
					DepthOfField	= "Глубина резкости";
					HDR				= "High Dynamic Range";
					Bloom			= "Bloom эффект";
				--	Glow			= "Cвечиние ярких областей объекта";
					RadialBlur		= "Размытие в движении";
					RoadShine3		= "Отражение солнца на дорогах";
					BumpMapping		= "Рельефное текстурирование";
					CarReflect		= "Отражения на автомобилях";
					Water			= "Улучшеная прорисовка воды";
				};
			};
		};
	};
	
	CUISettings		= function( this, pSettings )
		this.Window = this:CreateWindow( "Настройки" )
		{
			X		= this.X;
			Y		= this.Y;
			Width	= this.Width;
			Height	= this.Height;
			Sizable	= false;
		};
		
		this.Window.Tab		= this.Window:CreateTabPanel
		{
			X			= 0;
			Y			= 20;
			Width		= this.Width;
			Height		= this.Height - 65;
		};
		
	--	this.Window.Tab.Controls		= this.Window.Tab:CreateTab( "Управление" );
		this.Window.Tab.Graphics		= this.Window.Tab:CreateTab( "Графика" );
		
		do
			local pTab		= this.Window.Tab.Graphics;
			
			function pTab.Apply()
				for key, value in pairs( Settings.Graphics.Shaders ) do
					if pTab.Shaders[ key ] then
						Settings.Graphics.Shaders[ key ] = pTab.Shaders[ key ]:GetSelected();
					end
				end
			end
			
			local fY		= 10;
			local iWidth	= this.Window.Tab.Width * 0.5 - 20;
			
			pTab.Shaders	= pTab:CreateLabel( "Шейдеры" )
			{
				X				= 20;
				Y				= fY;
				Width			= iWidth;
				Height			= 25;
				Font			= CEGUIFont( "Segoe UI", 10, true );
				VerticalAlign	= "center";
			};
			
			fY = fY + pTab.Shaders.Height + 5;
			
			for key, sL18n in pairs( this.L18n.Graphics.Shaders ) do
				local Value = Settings.Graphics.Shaders[ key ];
				
				pTab.Shaders[ key ]	= pTab:CreateCheckBox( sL18n )
				{
					X				= pTab.Shaders.X + 10;
					Y				= fY;
					Width			= pTab.Shaders.Width;
					Height			= 23;
					Font			= CEGUIFont( "Segoe UI", 9, false );
					Selected		= Value == true;
					Enabled			= Value ~= NULL;
				};
				
				fY = fY + pTab.Shaders[ key ].Height;
			end
		end
		
		this.ButtonApply = this.Window:CreateButton( "Применить" )
		{
			X		= this.Width - 90;
			Y		= this.Height - 40;
			Width	= 80;
			Height	= 30;
			
			Click	= function()
				this.Window.Tab.Graphics.Apply();
				
				Settings.Apply();
			end;
		};
		
		this.ButtonClose = this.Window:CreateButton( "Отмена" )
		{
			X		= this.ButtonApply.X - 90;
			Y		= this.ButtonApply.Y;
			Width	= this.ButtonApply.Width;
			Height	= this.ButtonApply.Height;
			
			Click	= function()
				SERVER.SaveSettings( Settings );
				
				delete ( this );
			end;
		};
		
		this.ButtonOK	= this.Window:CreateButton( "ОК" )
		{
			X		= this.ButtonClose.X - 90;
			Y		= this.ButtonClose.Y;
			Width	= this.ButtonClose.Width;
			Height	= this.ButtonClose.Height;
			
			Click	= function()
				this.ButtonApply.Click();
				this.ButtonClose.Click();
			end;
		};
		
		this.Window:SetVisible( true );
		this.Window:BringToFront();
		
		this:ShowCursor();
		
		Ajax:HideLoader();
	end;
	
	_CUISettings	= function( this )
		this.Window:Delete();
		this.Window = NULL;
		
		this:HideCursor();
		
		Ajax:HideLoader();
	end;
};