-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. GroupManager : Manager
{
	GroupManager	= function()
		this.Manager();
	end;

	_GroupManager	= function()
		this.DeleteAll();
	end;

	Init	= function()
		local result = Server.DB.Query( "SELECT * FROM `uac_groups` ORDER BY `id` ASC" );

		if result then
			for i, row in result.FetchRow() do
				local id		= (int)(row[ "id" ]);
				local name		= row[ "name" ];
				local caption	= row[ "caption" ];
				local color		= new. Color( unpack( fromJSON( row[ "color" ] ) ) );

				local group		= new. Group( id, name, caption, color );

				for key, value in pairs( row ) do
					if value == "Yes" then
						group.AddRight( key );
					end
				end
			end

			result.Free();
			
			return true;
		else
			Debug( Server.DB.Error(), 1 );
		end

		return false;
	end;
	
	Get	= function( str )
		if this.m_List[ str ] then
			return this.m_List[ str ];
		end
		
		for ID, group in pairs( this.GetAll() ) do
			if group.GetName() == str or group.GetCaption() == str then
				return group;
			end
		end

		return NULL;
	end;
}
