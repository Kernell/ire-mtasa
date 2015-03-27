-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

Registry = 
{
	peds		=
	{
		wfyclot		=
		{
			ID		= 211;
			DFF		= "Peds/wfyclot.dff";
			TXD		= "Peds/wfyclot.txd";
		};
		gungrl		=
		{
			ID		= 191;
			DFF		= "Peds/gungrl3.dff";
			TXD		= "Peds/gungrl3.txd";
		};
		mecgrl		=
		{
			ID		= 192;
			DFF		= "Peds/mecgrl3.dff";
			TXD		= "Peds/mecgrl3.txd";
		};
		nurgrl		=
		{
			ID		= 193;
			DFF		= "Peds/nurgrl3.dff";
			TXD		= "Peds/nurgrl3.txd";
		};
		crogrl3		=
		{
			ID		= 194;
			DFF		= "Peds/crogrl3.dff";
			TXD		= "Peds/crogrl3.txd";
		};
		lapd		=
		{
			ID		= 280;
			DFF		= "Peds/lapd.dff";
			TXD		= "Peds/lapd.txd";
		};
		sfpd		=
		{
			ID		= 281;
			DFF		= "Peds/sfpd.dff";
			TXD		= "Peds/sfpd.txd";
		};
		lvpd		=
		{
			ID		= 282;
			DFF		= "Peds/lvpd.dff";
			TXD		= "Peds/lvpd.txd";
		};
		swat		=
		{
			ID		= 285;
			DFF		= "Peds/urban.dff";
			TXD		= "Peds/swat.txd";
		};
		fbi			=
		{
			ID		= 286;
			DFF		= "Peds/fbi.dff";
			TXD		= "Peds/fbi.txd";
		};
		fbi_swat	=
		{
			ID		= 287;
			DFF		= "Peds/urban.dff";
			TXD		= "Peds/fbi_swat.txd";
		};
		fbi_swat	=
		{
			ID		= 288;
			DFF		= "Peds/urban.dff";
			TXD		= "Peds/army.txd";
		};
	};
	weapons		=
	{
		acr			= 
		{
			ID		= 1851;
			DFF		= "Weapons/acr/model.dff";
			TXD		= "Weapons/acr/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					ACR_Diffuse		=
					{
						DiffuseTexture	= "Weapons/acr/Diffuse.jpg";
						NormalTexture	= "Weapons/acr/Normal.jpg";
						SpecularTexture	= "Weapons/acr/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		ak74m		= 
		{
			ID		= 1877;
			DFF		= "Weapons/ak74m/model.dff";
			TXD		= "Weapons/ak74m/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					AK74M_Diffuse		=
					{
						DiffuseTexture	= "Weapons/ak74m/Diffuse.jpg";
						NormalTexture	= "Weapons/ak74m/Normal.jpg";
						SpecularTexture	= "Weapons/ak74m/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		ak12		= 
		{
			ID		= 1852;
			DFF		= "Weapons/ak12/model.dff";
			TXD		= "Weapons/ak12/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					AK12_Diffuse		=
					{
						DiffuseTexture	= "Weapons/ak12/Diffuse.jpg";
						NormalTexture	= "Weapons/ak12/Normal.jpg";
						SpecularTexture	= "Weapons/ak12/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		aug			= 
		{
			ID		= 1853;
			DFF		= "Weapons/aug/model.dff";
			TXD		= "Weapons/aug/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					AUG_Diffuse		=
					{
						DiffuseTexture	= "Weapons/aug/Diffuse.jpg";
						NormalTexture	= "Weapons/aug/Normal.jpg";
						SpecularTexture	= "Weapons/aug/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		desert_eagle	= 
		{
			ID		= 1875;
			DFF		= "Weapons/desert_eagle/model.dff";
			TXD		= "Weapons/desert_eagle/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					DESERTEAGLE_Diffuse	=
					{
						DiffuseTexture	= "Weapons/desert_eagle/Diffuse.jpg";
						NormalTexture	= "Weapons/desert_eagle/Normal.jpg";
						SpecularTexture	= "Weapons/desert_eagle/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		famas_f1	= 
		{
			ID		= 1854;
			DFF		= "Weapons/famas_f1/model.dff";
			TXD		= "Weapons/famas_f1/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					FAMASF1_Diffuse		=
					{
						DiffuseTexture	= "Weapons/famas_f1/Diffuse.jpg";
						NormalTexture	= "Weapons/famas_f1/Normal.jpg";
						SpecularTexture	= "Weapons/famas_f1/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		scar_h		= 
		{
			ID		= 1855;
			DFF		= "Weapons/scar_h/model.dff";
			TXD		= "Weapons/scar_h/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					SCARH_Diffuse		=
					{
						DiffuseTexture	= "Weapons/scar_h/Diffuse.jpg";
						NormalTexture	= "Weapons/scar_h/Normal.jpg";
						SpecularTexture	= "Weapons/scar_h/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		scar_l		= 
		{
			ID		= 1856;
			DFF		= "Weapons/scar_l/model.dff";
			TXD		= "Weapons/scar_l/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					SCARL_Diffuse		=
					{
						DiffuseTexture	= "Weapons/scar_l/Diffuse.jpg";
						NormalTexture	= "Weapons/scar_l/Normal.jpg";
						SpecularTexture	= "Weapons/scar_l/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		spas12		= 
		{
			ID		= 1857;
			DFF		= "Weapons/spas12/model.dff";
			TXD		= "Weapons/spas12/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					SPAS12_Diffuse		=
					{
						DiffuseTexture	= "Weapons/spas12/Diffuse.jpg";
						NormalTexture	= "Weapons/spas12/Normal.jpg";
						SpecularTexture	= "Weapons/spas12/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		glock17		= 
		{
			ID		= 1858;
			DFF		= "Weapons/glock17/model.dff";
			TXD		= "Weapons/glock17/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					GLOCK17_Diffuse		=
					{
						DiffuseTexture	= "Weapons/glock17/Diffuse.jpg";
						NormalTexture	= "Weapons/glock17/Normal.jpg";
						SpecularTexture	= "Weapons/glock17/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		glock18		= 
		{
			ID		= 1859;
			DFF		= "Weapons/glock18/model.dff";
			TXD		= "Weapons/glock18/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					GLOCK18_Diffuse		=
					{
						DiffuseTexture	= "Weapons/glock17/Diffuse.jpg";
						NormalTexture	= "Weapons/glock17/Normal.jpg";
						SpecularTexture	= "Weapons/glock17/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		hk416		= 
		{
			ID		= 1860;
			DFF		= "Weapons/hk416/model.dff";
			TXD		= "Weapons/hk416/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					HK416_Diffuse		=
					{
						DiffuseTexture	= "Weapons/hk416/Diffuse.jpg";
						NormalTexture	= "Weapons/hk416/Normal.jpg";
						SpecularTexture	= "Weapons/hk416/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		hk417		= 
		{
			ID		= 1861;
			DFF		= "Weapons/hk417/model.dff";
			TXD		= "Weapons/hk417/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					HK417_Diffuse		=
					{
						DiffuseTexture	= "Weapons/hk417/Diffuse.jpg";
						NormalTexture	= "Weapons/hk417/Normal.jpg";
						SpecularTexture	= "Weapons/hk417/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		g36c		= 
		{
			ID		= 1862;
			DFF		= "Weapons/g36c/model.dff";
			TXD		= "Weapons/g36c/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					G36C_Diffuse		=
					{
						DiffuseTexture	= "Weapons/g36c/Diffuse.jpg";
						NormalTexture	= "Weapons/g36c/Normal.jpg";
						SpecularTexture	= "Weapons/g36c/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		jng90		= 
		{
			ID		= 1864;
			DFF		= "Weapons/jng90/model.dff";
			TXD		= "Weapons/jng90/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					JNG90_Diffuse		=
					{
						DiffuseTexture	= "Weapons/jng90/Diffuse.jpg";
						NormalTexture	= "Weapons/jng90/Normal.jpg";
						SpecularTexture	= "Weapons/jng90/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		m4a1		= 
		{
			ID		= 1865;
			DFF		= "Weapons/m4a1/model.dff";
			TXD		= "Weapons/m4a1/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					M4A1_Diffuse		=
					{
						DiffuseTexture	= "Weapons/m4a1/Diffuse.jpg";
						NormalTexture	= "Weapons/m4a1/Normal.jpg";
						SpecularTexture	= "Weapons/m4a1/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		m9			= 
		{
			ID		= 1866;
			DFF		= "Weapons/m9/model.dff";
			TXD		= "Weapons/m9/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					M9_Diffuse		=
					{
						DiffuseTexture	= "Weapons/m9/Diffuse.jpg";
						NormalTexture	= "Weapons/m9/Normal.jpg";
						SpecularTexture	= "Weapons/m9/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		m1911		= 
		{
			ID		= 1867;
			DFF		= "Weapons/m1911/model.dff";
			TXD		= "Weapons/m1911/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					M1911_Diffuse		=
					{
						DiffuseTexture	= "Weapons/m1911/Diffuse.jpg";
						NormalTexture	= "Weapons/m1911/Normal.jpg";
						SpecularTexture	= "Weapons/m1911/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		mp443		= 
		{
			ID		= 1868;
			DFF		= "Weapons/mp443/model.dff";
			TXD		= "Weapons/mp443/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					MP443_Diffuse		=
					{
						DiffuseTexture	= "Weapons/mp443/Diffuse.jpg";
						NormalTexture	= "Weapons/mp443/Normal.jpg";
						SpecularTexture	= "Weapons/mp443/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		mp5			= 
		{
			ID		= 1863;
			DFF		= "Weapons/mp5/model.dff";
			TXD		= "Weapons/mp5/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					MP5_Diffuse		=
					{
						DiffuseTexture	= "Weapons/mp5/Diffuse.jpg";
						NormalTexture	= "Weapons/mp5/Normal.jpg";
						SpecularTexture	= "Weapons/mp5/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		mp7			= 
		{
			ID		= 1876;
			DFF		= "Weapons/mp7/model.dff";
			TXD		= "Weapons/mp7/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					MP7_Diffuse		=
					{
						DiffuseTexture	= "Weapons/mp7/Diffuse.jpg";
						NormalTexture	= "Weapons/mp7/Normal.jpg";
						SpecularTexture	= "Weapons/mp7/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		p90			= 
		{
			ID		= 1869;
			DFF		= "Weapons/p90/model.dff";
			TXD		= "Weapons/p90/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					P90_Diffuse		=
					{
						DiffuseTexture	= "Weapons/p90/Diffuse.jpg";
						NormalTexture	= "Weapons/p90/Normal.jpg";
						SpecularTexture	= "Weapons/p90/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		qbu88		= 
		{
			ID		= 1870;
			DFF		= "Weapons/qbu88/model.dff";
			TXD		= "Weapons/qbu88/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					QBU88_Diffuse		=
					{
						DiffuseTexture	= "Weapons/qbu88/Diffuse.jpg";
						NormalTexture	= "Weapons/qbu88/Normal.jpg";
						SpecularTexture	= "Weapons/qbu88/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		qjy88		= 
		{
			ID		= 1871;
			DFF		= "Weapons/qjy88/model.dff";
			TXD		= "Weapons/qjy88/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					QJY88_Diffuse		=
					{
						DiffuseTexture	= "Weapons/qjy88/Diffuse.jpg";
						NormalTexture	= "Weapons/qjy88/Normal.jpg";
						SpecularTexture	= "Weapons/qjy88/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		rpg			= 
		{
			ID		= 1872;
			DFF		= "Weapons/rpg/model.dff";
			TXD		= "Weapons/rpg/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					RPG_Diffuse		=
					{
						DiffuseTexture	= "Weapons/rpg/Diffuse.jpg";
						NormalTexture	= "Weapons/rpg/Normal.jpg";
						SpecularTexture	= "Weapons/rpg/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		rpk74m		= 
		{
			ID		= 1873;
			DFF		= "Weapons/rpk74m/model.dff";
			TXD		= "Weapons/rpk74m/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					RPK74M_Diffuse		=
					{
						DiffuseTexture	= "Weapons/rpk74m/Diffuse.jpg";
						NormalTexture	= "Weapons/rpk74m/Normal.jpg";
						SpecularTexture	= "Weapons/rpk74m/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
		ump45		= 
		{
			ID		= 1874;
			DFF		= "Weapons/ump45/model.dff";
			TXD		= "Weapons/ump45/texture.txd";
			Shaders	=
			{
				NormalMapping	=
				{
					UMP45_Diffuse		=
					{
						DiffuseTexture	= "Weapons/ump45/Diffuse.jpg";
						NormalTexture	= "Weapons/ump45/Normal.jpg";
						SpecularTexture	= "Weapons/ump45/Specular.jpg";

						Params			=
						{
							EnableLight1	= true;
						};
					};
				};
			};
		};
	};
};

function GetInfo( path )
	path = path:split( "\\" );

	local dir	= path[ 1 ];
	local file	= path[ 2 ];

	return Registry[ dir ] and Registry[ dir ][ file ];
end