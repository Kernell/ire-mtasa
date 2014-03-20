-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: CUIAsyncQuery
{
	CUIAsyncQuery	= function( this )
	
	end;
	
	_CUIAsyncQuery	= function( this )
		if this.pAsyncQuery then
			delete ( this.pAsyncQuery );
			this.pAsyncQuery = NULL;
		end
		
		Ajax:HideLoader();
	end;
	
	AsyncQuery	= function( this, Complete, sFunction, ... )
		if this.pAsyncQuery then return false; end
		
		this.Window:SetEnabled( false );
		
		Ajax:ShowLoader( 2 );
		
		this.pAsyncQuery = AsyncQuery( sFunction, ... );
		
		function this.pAsyncQuery.Complete( _self, iStatusCode, Data )
			Ajax:HideLoader();
			
			this.Window:SetEnabled( true );
			
			this.pAsyncQuery = NULL;
			
			if iStatusCode == AsyncQuery.OK then
				if type( Data ) == "string" then
					this:ShowDialog( MessageBox( Data, "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error ) );
				elseif Complete then
					Complete( Data );
				end
			elseif type( Data ) == "string" then
				this:ShowDialog( MessageBox( Data, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error ) );
			end
		end
		
		return true;
	end;
};
