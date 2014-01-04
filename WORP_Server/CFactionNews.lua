-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class: CFactionNews ( CFaction )
{
	m_aAdverts	= NULL;
	
	CFactionNews = function( self, ... )
		self:CFaction( ... );
		
		self.m_aAdverts = {};
	end;
};

function CFactionNews:ShowMenu( pPlayer, bForce )
	local pChar = pPlayer:GetChar();
	
	if pChar then
		if pChar:GetFaction() == self then
			pPlayer:Client().FMenuSN( self.m_aAdverts, bForce );
			
			return true;
		end
	end
	
	return false;
end

function CFactionNews:AcceptAdvert( iAdverID, sText, pChar )
	local pAdvert = self.m_aAdverts[ iAdverID ];
	
	if pAdvert and pChar:GetID() == pAdvert.m_iCharID then
		if sText:len() > 86 then
			self:MessageBox( false, "Текст рекламы слишком длинный", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error );
			
			return;
		end
		
		self:GiveMoney( pAdvert.m_iPrice );
		
		local sAdvert		= "Реклама: " + sText;
		local sInfo			= "#00ff00   (( #34c924Отправитель: " + pAdvert.m_sName + ", Редактор: " + self:GetName() + " #00ff00))";
		local sInfoAdmin	= "#00ff00   (( #34c924Отправитель: " + table.concat( { pAdvert.m_sName, pAdvert.m_sUserName }, ' - ' ) + ", Редактор: " + self:GetName() + " #00ff00))";
		
		for i, pPlr in pairs( g_pGame:GetPlayerManager():GetAll() ) do
			if pPlr:IsInGame() then
				pPlr:GetChat():Send( sAdvert, 0, 255, 0 );
			
				if pPlr:HaveAccess( "command.adminchat" ) then
					pPlr:GetChat():Send( sInfoAdmin, 0, 255, 0, true );
				else
					pPlr:GetChat():Send( sInfo, 0, 255, 0, true );
				end
			end
		end
		
		g_pADLog:Write( "%s (%s) accepted advert " + sText + " (from: %s (%s)) for $%d" , self:GetName(), self:GetUserName(), pAdvert.m_sName, pAdvert.m_sUserName, pAdvert.m_iPrice );
		
		table.remove( self.m_aAdverts, iAdverID );
		
		for i, pPlr in pairs( self.m_pElement:GetChilds() ) do
			if classof( pPlr ) == CPlayer then
				pPlr:Client().FMenuSN( self.m_aAdverts, false, true );
			end
		end
	else
		self:Hint( "Ошибка", "Это объявление уже было отправлено", "error" );
	end
end

function CFactionNews:AddAdvert( pChar, sText, iPrice )
	self:ClearAdvert( pChar:GetID() );					
	
	table.insert( self.m_aAdverts,
		{
			m_sUserName	= pChar.m_pClient:GetUserName();
			m_iCharID	= pChar:GetID();
			m_sName		= pChar:GetName();
			m_sText		= sText;
			m_iPrice	= iPrice;
		}
	);
	
	if table.getn( self.m_aAdverts ) > 100 then
		table.remove( self.m_aAdverts );
	end
	
	local sMessage = "Автор: " + pChar.m_pClient:GetName() + " (" + pChar.m_pClient:GetID() + ")\n\nНажмите F5 для управления";
	
	for i, pPlr in pairs( self.m_pElement:GetChilds() ) do
		if classof( pPlr ) == CPlayer then
			pPlr:Popup( "info", "Новое объявление", sMessage );
			pPlr:Client().FMenuSN( self.m_aAdverts, false, true );
		end
	end
end

function CFactionNews:ClearAdvert( pChar )
	for i = table.getn( self.m_aAdverts ), 1, -1 do
		if pAdv.m_iCharID == pChar:GetID() then
			table.remove( self.m_aAdverts, i );
		end
	end
	
	return true;
end

function CClientRPC:AcceptAdvert( iAdverID, sText, iCharID )
	if type( sText ) == "string" and sText:len() > 2 then
		local pChar = self:GetChar();
	
		if pChar and pChar:GetFaction() == self then
			self:AcceptAdvert( iAdverID, sText:gsub( "#%x%x%x%x%x%x", '' ), pChar );
		end
	end
end