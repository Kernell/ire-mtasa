-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0


class. MySQLResult
{
	static 
	{
		Pool = {};
	};
	
	m_pResult		= NULL;
	
	MySQLResult	= function( pResult )
		this.m_pResult = pResult;
		
		this.m_ID	= tostring( this.m_pResult );
		
		MySQLResult.Pool[ this.m_ID ] = this;
	end;
	
	_MySQLResult	= function()
		if this.m_pResult then
			this.m_pResult:free();
			
			MySQLResult.Pool[ this.m_ID ] = NULL;
			
			this.m_pResult = NULL;
		end
	end;

	Empty			= function()
		return this.m_pResult == NULL;
	end;
	
	DataSeek 		= function( offset )
		return this.m_pResult:data_seek( offset );
	end;
	
	FieldSeek 		= function( offset )
		return this.m_pResult:field_seek( offset );
	end;
	
	FieldTell 		= function()
		return this.m_pResult:field_tell();
	end;
	
	NumFields 		= function()
		return this.m_pResult:num_fields();
	end;
	
	NumRows			= function()
		return this.m_pResult:num_rows();
	end;
	
	FetchRow		= function()
		local t = false;
		
		if this.NumRows() > 0 then
			t = {};
			
			for key, value in pairs( this.m_pResult:fetch_assoc() ) do
				if value ~= mysql_null() then
					t[ key ] = tonumber( value ) or value;
				end
			end
		end
		
		return t;
	end;
	
	FetchAssoc 		= function()
		return this.m_pResult:rows_assoc();
	end;
	
	GetArray 		= function()
		local Array = {};
		
		if this.NumRows() > 0 then
			for _, row in this.FetchAssoc() do
				local Row = {};
				
				for key, value in pairs( row ) do
					if value ~= mysql_null() then
						Row[ key ] = tonumber( value ) or value;
					end
				end
				
				table.insert( Array, Row );
			end
		end
		
		return Array;
	end;
};