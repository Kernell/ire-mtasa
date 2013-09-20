-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: Form1 ( System.Drawing.Forms.Form )
{
	Form1	= function( this )
		this:InitializeComponent();
	end;
	
	InitializeComponent = function( this )
		this.pictureBox1		= System.Drawing.Forms.PictureBox();
		this.label1				= System.Drawing.Forms.Label();
		this.label2				= System.Drawing.Forms.Label();
		this.button1			= System.Drawing.Forms.Button();
		this.comboBox1			= System.Drawing.Forms.ComboBox();
		
		this:SuspendLayout();
		-- 
		-- pictureBox1
		-- 
		this.pictureBox1.Image					= System.Drawing.Image.FromFile( "Resources/Images/Popup/Info.png" );
		this.pictureBox1.Location				= System.Drawing.Point( 20, 20 );
		this.pictureBox1.Size					= System.Drawing.Size( 64, 64 );
		this.pictureBox1.Name					= "pictureBox1";
		this.pictureBox1.TabIndex				= 1;
		this.pictureBox1.TabStop				= false;
		-- 
		-- label1
		-- 
		this.label1.AutoSize					= true;
		this.label1.Font						= System.Drawing.Font( "Microsoft Sans Serif", 10, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Pixel );
		this.label1.Location					= System.Drawing.Point( 100, 20 );
		this.label1.Size						= System.Drawing.Size( 131, 13 );
		this.label1.TabIndex					= 2;
		this.label1.Name						= "label1";
		this.label1.Text						= "0000 0000 0000 0000";
		-- 
		-- label2
		-- 
		this.label2.AutoSize					= true;
		this.label2.Location					= System.Drawing.Point( 300, 66 );
		this.label2.Size						= System.Drawing.Size( 59, 13 );
		this.label2.Name						= "label2";
		this.label2.Text						= "Доступно:";
		this.label2.TabIndex					= 3;
		-- 
		-- button1
		-- 
		this.button1.Location					= System.Drawing.Point( 374, 61 );
		this.button1.Size						= System.Drawing.Size( 90, 35 );
--		this.button1.Size						= System.Drawing.Size( 84, 22 );
--		this.button1.Size						= System.Drawing.Size( 75, 23 );
		this.button1.UseVisualStyleBackColor 	= true;
		this.button1.Name 						= "button1";
		this.button1.Text 						= "$ 123 456 789";
		this.button1.TabIndex 					= 4;
		-- 
		-- comboBox1
		-- 
		this.comboBox1.Location 				= System.Drawing.Point( 300, 20 );
		this.comboBox1.Size 					= System.Drawing.Size( 164, 21 );
		this.comboBox1.FormattingEnabled		= true;
		this.comboBox1.Name 					= "comboBox1";
		this.comboBox1.Text						= "Операции";
		this.comboBox1.TabIndex					= 5;
		this.comboBox1.Items.AddRange(
			{
				"Пополнить",
				"Перевести на другой счёт",
				"Заблокировать"
			}
		);
		-- 
		-- Form1
		--
		this.BackColor	= System.Drawing.SystemColors.Control
		this.ClientSize = System.Drawing.Size( 484, 112 );
		this.Location	= System.Drawing.Point( ( g_iScreenX - 500 ) / 2, ( g_iScreenY - 150 ) / 2 );
		this.Name		= "Form1";
		this.Text		= "VS.Net Style Demo";
		
		this.Controls.Add( this.pictureBox1 );
		this.Controls.Add( this.label1 );
		this.Controls.Add( this.label2 );
		this.Controls.Add( this.button1 );
		this.Controls.Add( this.comboBox1 );
		
		this:ResumeLayout( false );
		this:PerformLayout();
	end
};

Form1();