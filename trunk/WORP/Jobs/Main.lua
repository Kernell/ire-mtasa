-- Author:      	Kernell
-- Version:     	1.0.0

function JobDialog( iJobID, sJobName )
	local Button = MessageBox:Show( 'Вы действительно хотите устроится на работу "' + sJobName + '"?\n\nВаш скилл работы будет обнулён!', sJobName, MessageBoxButtons.YesNo, MessageBoxIcon.Question );
	
	Button[ 'Да' ].OnClick = function()
		SERVER.JobDialodResponse( iJobID );
	end
end

local gl_Function	= NULL;
local gl_pColShape	= NULL;
local gl_iWait		= 0;

local screenX, screenY = guiGetScreenSize();

local Release;

local function countdown()
	local sText = "Подождите ..";
	
	local pVehicle = CLIENT:GetVehicle();
	
	if pVehicle and gl_Function and gl_pColShape and CLIENT:IsWithinColShape( gl_pColShape ) then
		
		if pVehicle:GetHealth() <= 350 then
			sText = "Ваш автомобиль повреждён";
		else
			local diff = gl_iWait - getTickCount();
			
			if diff >= 0 then
				sText = ( "Подождите %.2f секунд" ):format( diff / 1000 );
			else
				if SERVER[ gl_Function ]() then
					Release();	
				end
				
				return;
			end
		end
		
		dxDrawText( sText, 0, 0, screenX + 1, screenY + 1, COLOR_BLACK, 1.0, DXFont( "consola", 12, true ), "center", "center" );
		dxDrawText( sText, 0, 0, screenX - 1, screenY - 1, COLOR_BLACK, 1.0, DXFont( "consola", 12, true ), "center", "center" );
		dxDrawText( sText, 0, 0, screenX + 1, screenY - 1, COLOR_BLACK, 1.0, DXFont( "consola", 12, true ), "center", "center" );
		dxDrawText( sText, 0, 0, screenX - 1, screenY + 1, COLOR_BLACK, 1.0, DXFont( "consola", 12, true ), "center", "center" );
		dxDrawText( sText, 0, 0, screenX, screenY, COLOR_WHITE, 1.0, DXFont( "consola", 12, true ), "center", "center" );
		
		return;
	end

	Release();
end

function Release()
	gl_Function = NULL;
	
	removeEventHandler( 'onClientRender', root, countdown );
end

function JobWaitTimer( pColShape, iWait, Function )
	if gl_Function then
		Release();
	end
	
	gl_pColShape	= pColShape;
	
	if gl_pColShape then
		gl_iWait 		= getTickCount() + iWait;
		gl_Function		= Function;
		
		addEventHandler( 'onClientRender', root, countdown );
	end
end