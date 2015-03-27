-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

showCursor( true );

class. Form1 : Window
{
	Form1	= function()
		this.Window();

		this.pictureBox1		= new. PictureBox();
		this.label1				= new. Label();
		this.label2				= new. Label();
		this.button1			= new. Button();
		this.comboBox1			= new. ComboBox();
		this.checkbox1			= new. Checkbox();
		-- 
		-- pictureBox1
		-- 
		this.pictureBox1.Image					= Image.FromFile( "Resources/Images/Info.png" );
		this.pictureBox1.Location				= new. Point( 20, 20 );
		this.pictureBox1.Size					= new. Size( 64, 64 );
		this.pictureBox1.Name					= "pictureBox1";
		this.pictureBox1.TabIndex				= 1;
		this.pictureBox1.TabStop				= false;
		-- 
		-- label1
		-- 
		this.label1.AutoSize					= true;
		this.label1.WordBreak					= true;
		this.label1.Font						= new. Font( "Microsoft Sans Serif", 10, FontStyle.Regular, GraphicsUnit.Pixel );
		this.label1.Location					= new. Point( 100, 20 );
		this.label1.Size						= new. Size( 180, 50 );
		this.label1.TabIndex					= 2;
		this.label1.Name						= "label1";
		this.label1.Text						= "Съешь ещё этих мягких французских булок, да выпей чаю.";
		-- 
		-- button1
		-- 
		this.button1.Location					= new. Point( 374, 61 );
		this.button1.Font						= new. Font( "Segoe UI", 9, FontStyle.Regular, GraphicsUnit.Pixel );
		this.button1.Size						= new. Size( 90, 30 );
		this.button1.UseVisualStyleBackColor 	= true;
		this.button1.Name 						= "button1";
		this.button1.Text 						= "Закрыть";
		this.button1.TabIndex 					= 4;
		-- 
		-- comboBox1
		-- 
		this.comboBox1.Location 				= new. Point( 300, 20 );
		this.comboBox1.Size 					= new. Size( 164, 21 );
		this.comboBox1.FormattingEnabled		= true;
		this.comboBox1.Name 					= "comboBox1";
		this.comboBox1.Text						= "Выпадающее меню";
		this.comboBox1.TabIndex					= 5;
		this.comboBox1.Items.AddRange(
			new
			{
				"Пополнить",
				"Перевести на другой счёт",
				"Заблокировать"
			}
		);
		-- 
		-- checkbox1
		-- 
		this.checkbox1.Location 				= new. Point( 20, 100 );
		this.checkbox1.Size 					= new. Size( 100, 18 );
		this.checkbox1.Name 					= "checkbox1";
		this.checkbox1.TabIndex					= 6;
		this.checkbox1.Text						= "Checkbox";
		-- 
		-- Form1
		--
		this.ClientSize = new. Size( 484, 150 );
		this.Location	= new. Point( ( Screen.Width - 500 ) / 2, ( Screen.Height - 150 ) / 2 );
		this.Name		= "Form1";
		this.Text		= "VS.Net Style Demo";
		
		this.Controls.Add( this.pictureBox1 );
		this.Controls.Add( this.label1 );
		this.Controls.Add( this.button1 );
		this.Controls.Add( this.comboBox1 );
		this.Controls.Add( this.checkbox1 );
		
		this.ResumeLayout( false );
		this.PerformLayout();
	end;
};

new. Form1();

-- setTimer( function() new. Form1(); end, 1000, 1 );