-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CCommand
{
	m_Commands = {};
};

function CCommand:Main( pPlayer, sCmd, sOption, ... )
	assert( pPlayer );
	assert( sCmd );
	
	if sOption then
		local Option = self.m_Options[ sOption ];
		
		if Option then
			if not Option.m_bRestricted or pPlayer:HaveAccess( 'command.' + sCmd + ':' + sOption ) then
				local vResult, iR, iG, iB	= Option.m_Function( self, pPlayer, sCmd, sOption, ... );
				
				if not vResult or vResult == 0 then
					if Option.m_sHelp then
						if type( Option.m_sHelp ) == 'table' then
							for i, txt in ipairs( Option.m_sHelp ) do
								if i == 1 then
									pPlayer:GetChat():Send( "Syntax: /" + sCmd + " " + sOption + " " + txt, 200, 200, 200 );
								else
									pPlayer:GetChat():Send( txt, 200, 200, 200 );
								end
							end
						else
							self:Echo( pPlayer, sOption + " " + Option.m_sHelp, 200, 200, 200 );
						end
					end
				end
				
				return vResult, iR, iG, iB;
			else
				pPlayer:GetChat():Send( ( "UAC: Access denied for '%s %s'" ):format( sCmd, sOption ), 255, 164, 0 );
				g_pServer:Print( "DENIED: Denied '%s' access to command '%s %s'", pPlayer:GetName(), sCmd, sOption );
			end
		else
			self:Echo( pPlayer, "Invalid option '" + sOption + "'" );
		end
	else
		pPlayer:GetChat():Send( "Syntax: /" + sCmd + " <option>", 255, 255, 255 );
		
		self:List( pPlayer );
	end
end

function CCommand:List( pPlayer )
	pPlayer:GetChat():Send( "List of options:", 200, 200, 200 );
	
	for i, sOption in ipairs( self.m_OptionsSorting ) do
		local Option = self.m_Options[ sOption ];
		
		if Option then
			if not Option.m_bRestricted or pPlayer:HaveAccess( 'command.' + self.m_sName + ':' + sOption ) then
				pPlayer:GetChat():Send( sOption:insert_spaces( 20 ) + ( type( Option.m_sHelp ) == 'table' and Option.m_sHelp[ 1 ] or Option.m_sHelp or '' ), 200, 200, 200 );
			end
		end
	end
end

function CCommand:RegisterCommand( Commands, Function, bRestricted, TFaction )
	if type( Commands ) == 'string' then
		Commands = { Commands };
	end
	
	assert( eFactionFlags, "eFactionFlags" );
	
	local sCmd				= Commands[ 1 ];
	
	self[ sCmd ]			=
	{
		Echo				= self.Echo;
		List				= self.List;
		m_sName				= sCmd;
		m_bRestricted		= bRestricted;
		m_pFaction			= type( TFaction ) == "table" and TFaction.m_bIsFaction and TFaction or NULL;
		m_Options			= {};
		m_OptionsSorting	= {};
		m_HandlerFunction	= function ( pPlayer, _, ... )
			if not bRestricted or ( pPlayer:IsLoggedIn() and pPlayer:HaveAccess( "command." + sCmd ) ) then
				if self[ sCmd ].m_pFaction then	
					if not pPlayer:IsInGame() then return; end
					
					local pFaction = pPlayer:GetChar():GetFaction();
					
					if not pFaction or ( classname( self[ sCmd ].m_pFaction ) ~= classname( pFaction ) ) then
						pPlayer:GetChat():Send( "Нет прав на использование данной команды", 255, 164, 0 );
							
						return;
					end
				end
				
				local sReturn		= "chat";
				
				local Args			= {};
				local bQuoteOpen	= false;
				
				for i, v in ipairs( { ... } ) do
					if v == "--send-to-chat" then
						sReturn	= "chat";
					elseif v == "--send-to-hint" then
						sReturn	= "hint";
					elseif v == "--send-to-msgbox" then
						sReturn	= "msgbox";
					else
						table.insert( Args, v );
					end
				end
				
				if bRestricted then
					g_pAdminLog:Write( "%s (%s) : %s %s", pPlayer:GetName(), pPlayer:GetUserName(), sCmd, table.concat( Args, ' ' ) );
				end
				
				local vResult, iR, iG, iB = ( Function or self.Main )( self[ sCmd ], pPlayer, sCmd, unpack( Args ) );
				
				if type( vResult ) == "string" then
					if sReturn == "chat" then
						pPlayer:GetChat():Send( vResult, iR or 255, iG or 255, iB or 255 );
					elseif sReturn == "hint" then
						local sCaption	= "Information";
						local sIcon		= "info";
						
						if iRed == 255 and iGreen == 0 and iBlue == 0 then
							sCaption	= "Error";
							sIcon		= "error";
						end
						
						pPlayer:Hint( sCaption, vResult, sIcon );
					elseif sReturn == "msgbox" then
						local sCaption	= "Information";
						local Icon		= MessageBoxIcon.Information;
						
						if iRed == 255 and iGreen == 0 and iBlue == 0 then
							sCaption		= "Error";
							Icon		= MessageBoxIcon.Error;
						end
						
						pPlayer:MessageBox( NULL, vResult, sCaption, MessageBoxButtons.OK, Icon );
					end
				end
			else
				pPlayer:GetChat():Send( ( "UAC: Access denied for '%s'" ):format( sCmd ), 255, 164, 0 );
				g_pServer:Print( "DENIED: Denied '%s' access to command '%s'", pPlayer:GetName(), sCmd );
			end
		end;
	};

	table.insert( self.m_Commands, self[ sCmd ] );
	
	for _, cmd in ipairs( Commands ) do
		addCommandHandler( cmd, self[ sCmd ].m_HandlerFunction, false, false );
	end
end

function CCommand:SetFaction( sCmd, pFaction )
	if self[ sCmd ] and table.getn( self[ sCmd ].m_Options ) == 0 then
		self[ sCmd ].m_pFaction = pFaction;
		
		return true;
	end
	
	return false;
end

function CCommand:Exec( pPlayer, sCmd, ... )
	if self[ sCmd ] then
		if self[ sCmd ].m_HandlerFunction then
			self[ sCmd ].m_HandlerFunction( pPlayer, sCmd, ... );
			
			return true;
		end
	end
	
	return false;
end

function CCommand:GetAll()
	return self.m_Commands;
end

function CCommand:AddOption( sCmd, sOption, Function, bRestricted, sHelp )
	if not self[ sCmd ] then
		self[ sCmd ]	=
		{
			Echo				= self.Echo;
			List				= self.List;
			m_sName				= sCmd;
			m_Options			= {};
			m_OptionsSorting	= {};
		};
	end
	
	self[ sCmd ].m_Options[ sOption ] =
	{
		m_Function		= Function;
		m_bRestricted	= bRestricted;
		m_sHelp			= sHelp;
	};
	
	table.insert( self[ sCmd ].m_OptionsSorting, sOption );
end

function CCommand:Echo( pPlayer, sText )
	pPlayer:GetChat():Send( self.m_sName + ": " + sText, 200, 200, 200 );
end

function CCommand:ReadParams( ... )
	local Args	= { ... };
	local i		= 0;
	local t		= table.getn( Args );
	
	function iter()
		i = i + 1;
		
		if i <= t then
			if type( Args[ i ] ) == "string" then
				local Param, Value = Args[ i ]:match( "--(%w+)=(.*)" );
				
				if Param and Value then
					return Param, Value;
				end
			end
			
			return iter();
		end
		
		return NULL;
	end
	
	return iter;
end