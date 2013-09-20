-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

-- TODO: CPlayerChat

local Smiles	=
{
	smile		= "(\>\:\]|\:-\)|\:\)|\:o\)|\:\]|\:3|\:c\)|\:\>|\=\]|8\)|\=\)|\:\}|\:\^\))";
	laugh		= "(\>\:D|\:-D|\:D|8-D|x-D|X-D|\=-D|\=D|\=-3|8-\)|xD|XD|8D|\=3)";
	sad 		= "(\>\:\[|\:-\(|\:\(|\:-c|\:c|\:-\<|\:-\[|\:\[|\:\{|\>\.\>|\<\.\<|\>\.\<)";
	wink		= "(\>;\]|;-\)|;\)|\*-\)|\*\)|;-\]|;\]|;D|;\^\))";
	tongue		= "(\>\:P|\:-P|\:P|X-P|x-p|\:-p|\:p|\=p|\:-Þ|\:Þ|\:-b|\:b|\=p|\=P|xp|XP|xP|Xp)";
	surprise	= "(\>\:o|\>\:O|\:-O|\:O|°o°|°O°|\:O|o_O|o\.O|8-0)";
	annoyed		= "(\>\:\\|\>\:/|\:-/|\:-\.|\:\\|\=/|\=\\|\:S|\:\/)";
	cry			= "(\:'\(|;'\()";
};

local SmileActions	=
{
	smile		= 'улыбается';
	laugh		= 'смеётся';
	sad			= 'грустит';
	wink		= 'подмигивает';
	tongue		= 'показывает язык';
	surprise	= 'удивляется';
	cry			= 'плачет';
};

local Prefixes =
{
	{ male = 'сказал';			female = 'сказала';			unknown = 'сказал(а)';		};
	{ male = 'крикнул';			female = 'крикнула';		unknown = 'крикнул(а)';		};
	{ male = 'шепнул';			female = 'шепнула';			unknown = 'шепнул(а)'; 		};
	{ male = 'тихо сказал';		female = 'тихо сказала';	unknown = 'тихо сказал(а)';	};
	{ male = 'рация';			female = 'рация';			unknown = 'рация'; 			};
	{ male = 'телефон';			female = 'телефон';			unknown = 'телефон'; 		};
	{ male = 'микрофон';		female = 'микрофон';		unknown = 'микрофон'; 		};
};	

function CPlayer:LocalizedMessage( sMessage, fRange, iType )
	local pChar = self:GetChar();
	
	if pChar then
		if self:IsAdmin() then
			return CCommands:LocalOOC( self, 'LocalOOC', sMessage );
		else
			if false then
				for smile, repexp in pairs( Smiles ) do
					local Result = sMessage:match( repexp );
					
					if Result then
						if type( Result ) == 'string' then
							sMessage:gsub( repexp, '' );
							
							self:Me( SmileActions[ smile ], '' );
							
							break;
						elseif table.getn( Result ) > 1 then
							return CPlayerCMD.LocalOOC( self, 'LocalOOC', sMessage );
						end
					end
				end
			end
			
			local sText = ( "%s (%d) %s: %s" ):format( self:GetVisibleName(), self:GetID(), Prefixes[ iType or 1 ][ pChar:GetSkin().GetGender() or 'unknown' ], sMessage );
			
			self:LocalMessage( sText, 240, 240, 240, tonumber( fRange ) or 20.0, 64, 64, 64 );
			
			if iType == 1 then
				triggerClientEvent( root, 'OnPlayerChatMessage', self, sMessage, 0 );
			end
			
			g_pServer:Print( sText:gsub( "%%", "%%%%" ) );
		end
	end
end

function CPlayer:LocalMessage( message, r, g, b, fRange, r2, g2, b2 )
	r = r or 255;
	g = g or 255;
	b = b or 255;
	
	fRange = fRange or 20.0;
	
	r2 = r2 or r;
	g2 = g2 or g;
	b2 = b2 or b;
	
	local pos	= self:GetPosition();
	local dim	= self:GetDimension();
	
	for _, p in pairs( g_pGame:GetPlayerManager():GetAll() ) do
		local distance = p:GetPosition():Distance( pos );
		
		if distance < fRange and dim == p:GetDimension() then
			local iRed, iGreen, iBlue = CalculateColors( r, g, b, r2, g2, b2, distance, fRange );
			
			p:GetChat():Send( message, iRed, iGreen, iBlue, false );
		end
	end
end

function CPlayer:Me( sMessage, sPrefix, bSendChat, bShowBubble )
	if type( sMessage ) == 'string' then
		sPrefix 	= type( sPrefix ) == 'string' and sPrefix or '* ';
		bSendChat	= bSendChat == NULL and true or (bool)(bSendChat);
		bShowBubble	= bShowBubble == NULL and true or (bool)(bShowBubble);
		
		local sText = sPrefix + self:GetVisibleName() + ' ' + sMessage;
		
		if bSendChat then
			self:LocalMessage( sText, 255, 0, 255, 10, 255, 0, 255 );
			
			outputServerLog( sText );
		else
			self:GetChat():Send( sText, 255, 0, 255 );
		end
		
		if bShowBubble then
			triggerClientEvent( root, 'OnPlayerChatMessage', self, sMessage, 1 );
		end
	end
end

function CalculateColors( r, g, b, r2, g2, b2, distance, range )
	return r - math.floor( ( r - r2 ) * ( distance / range ) ), g - math.floor( ( g - g2 ) * ( distance / range ) ), b - math.floor( ( b - b2 ) * ( distance / range ) );
end

function SendAdminsMessage( message, prefix, r, g, b )
	if type( message ) == 'string' then
		prefix = type( prefix ) == 'string' and prefix or '*Admins: ';
		
		r = r or 255;
		g = g or 64;
		b = b or 0;
		
		for _, player in pairs( g_pGame:GetPlayerManager():GetAll() ) do
			if player:HaveAccess( "command.adminchat" ) then
				player:GetChat():Send( prefix .. message, r, g, b );
			end
		end
		
		g_pServer:Print( prefix + ( message:gsub( '%%', '%%%%' ) ) );
		
		return true;
	end
	
	return false;
end