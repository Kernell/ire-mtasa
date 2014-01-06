-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CNetManager
{
	m_bConnected	= false;
	
	CNetManager 	= function( this )
		
	end;
	
	_CNetManager 	= function( this )
		
	end;
	
	IsConnected		= function( this )
		return this.m_bConnected;
	end;
	
	Connect			= function( this )
		if not this:IsConnected() then
			local pAsyncQuery	= new. AsyncQuery;
			
			function pAsyncQuery:Complete( iStatusCode, Data )
				if iStatusCode == AsyncQuery.OK then
					this.m_bConnected = true;
				end
			end
			
			pAsyncQuery:Init( "Ready", g_iScreenX, g_iScreenY );
			pAsyncQuery:Query();
		end
	end;
	
	Disconnect		= function( this )
		if this:IsConnected() then
			this.m_bConnected = false;
		end
	end;
	
	Authenticate	= function( this, sLogin, sPassword )
		
	end;
};