-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

local Models	=
{
	peds		=
	{
	--	[64]	= { TXD = 'csstew';			DFF = 'csstew' };
--		[95]	= { TXD = 'arctic';			DFF = 'arctic' };
--		[96]	= { TXD = 'guerilla';		DFF = 'guerilla' };
		[211]	= { TXD = 'wfyclot';		DFF = 'wfyclot' };
		
--		[219]	= { TXD = 'ofyri';			DFF = 'ofyri'	};
		
		[191]	= { TXD = 'gungrl3';		DFF = 'gungrl3' };
		[192]	= { TXD = 'mecgrl3';		DFF = 'mecgrl3' };
		[193]	= { TXD = 'nurgrl3';		DFF = 'nurgrl3' };
		[194]	= { TXD = 'crogrl3';		DFF = 'crogrl3' };
		
--		[280]	= { TXD = 'lapd';			DFF = 'lapd'	};
--		[281]	= { TXD = 'sfpd';			DFF = 'sfpd'	};
--		[282]	= { TXD = 'lvpd';			DFF = 'lvpd'	};
--		[283]	= { TXD = 'swat';			DFF = 'swat'	};
--		[284]	= { TXD = 'swat';			DFF = 'swat'	};
		[285]	= { TXD = 'swat';			DFF = 'urban'	};
--		[286]	= { TXD = 'fbi';			DFF = 'fbi'		};
		[287]	= { TXD = 'fbi_swat';		DFF = 'urban'	};
		[288]	= { TXD = 'army';			DFF = 'urban'	};
	};
	weapons		=
	{
		[347]	= { TXD = 'colt45';			DFF = 'colt45'			};
		[348]	= { TXD = 'desert_eagle';	DFF = 'desert_eagle'	};
		[349]	= { TXD = 'chromegun';		DFF = 'chromegun'		};
		[351]	= { TXD = 'shotgspa';		DFF = 'shotgspa'		};
		[353]	= { TXD = 'mp5lng';			DFF = 'mp5lng'			};
		[355]	= { TXD = 'ak47';			DFF = 'ak47'			};
		[356]	= { TXD = 'm4';				DFF = 'm4'				};
		[357]	= { TXD = 'aug';			DFF = 'aug'				};
		[358]	= { TXD = 'sniper';			DFF = 'sniper'			};
		[341]	= { TXD = 'katana';			DFF = 'katana'			};
		[335]	= { TXD = 'knifecur';		DFF = 'knifecur'		};
	};
	world		=
	{
	--	[13722]	= { TXD = 'mulhouslahills';	DFF = 'vinesign1_cunte'	};
	--	[13831]	= { TXD = 'mulhouslahills';	DFF = 'vinesign1_cunte01'	};
	--	[13759]	= { TXD = 'mulhouslahills';	DFF = 'lodvinesign1_cunte'	};
	};
	vehicles	=
	{
		[402]	= { TXD = 'mustang';		DFF = 'mustang'			};
--		[562]	= { TXD = 'elegy';			DFF = 'elegy'			};
--		[599]	= { TXD = 'copcarru';		DFF = 'copcarru'		};
		[490]	= { TXD = 'copcarru';		DFF = 'copcarru'		};
		[426]	= { TXD = 'charger_rt';		DFF = 'charger_rt'		};
		[507]	= { TXD = 'is300';			DFF = 'is300'			};
		[540]	= { TXD = 'wrx_05';			DFF = 'wrx_05'			};
		[560]	= { TXD = 'evo';			DFF = 'evo'				};
--		[579]	= { TXD = 'huntley';		DFF = 'huntley'		 	};
		[585]	= { TXD = 'falcon';			DFF = 'falcon'			};
		[602]	= { TXD = 'gtr';			DFF = 'gtr'				};
	};
};

function Replace( iModel, sTXD, sDFF, bWorld )
	if sTXD then
		local pTXD = engineLoadTXD( sTXD, true );
		
		if pTXD then
			engineImportTXD( pTXD, iModel );
		else
			error( sTXD );
		end
	end
	
	if sDFF then
		local pDFF = engineLoadDFF( sDFF, bWorld and 0 or iModel );
		
		if pDFF then
			engineReplaceModel( pDFF, iModel );
		else
			error( sDFF );
		end
	end
end


local iDelay = 200;

for sFolder, Content in pairs( Models ) do
	for iModel, Model in pairs( Content ) do
		setTimer( Replace, iDelay, 1, iModel, Model.TXD and ( sFolder + '/' + Model.TXD + '.txd' ), Model.DFF and ( sFolder + '/' + Model.DFF + '.dff' ), sFolder == "world" );
		
		iDelay = iDelay + 200;
	end
end