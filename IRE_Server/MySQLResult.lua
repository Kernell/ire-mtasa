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
	
	result		= NULL;
	
	MySQLResult	= function( pResult )
		this.result = pResult;
		
		this.ID	= tostring( this.result );
		
		MySQLResult.Pool[ this.ID ] = this;
	end;
	
	_MySQLResult	= function()
		this.Free();
	end;
	
	Free			= function()
		if this.result then
			this.result:free();
			
			MySQLResult.Pool[ this.ID ] = NULL;
			
			this.result = NULL;
		end
	end;

	Empty			= function()
		return this.result == NULL;
	end;
	
	DataSeek 		= function( offset )
		return this.result:data_seek( offset );
	end;
	
	FieldSeek 		= function( offset )
		return this.result:field_seek( offset );
	end;
	
	FieldTell 		= function()
		return this.result:field_tell();
	end;
	
	NumFields 		= function()
		return this.result:num_fields();
	end;
	
	NumRows			= function()
		return this.result:num_rows();
	end;
	
	FetchRow 		= function()
		return this.result:rows_assoc();
	end;
	
	GetRow			= function()
		local t = false;
		
		if this.NumRows() > 0 then
			t = {};
			
			for key, value in pairs( this.result:fetch_assoc() ) do
				if value ~= mysql_null() then
					t[ key ] = tonumber( value ) or value;
				end
			end
		end
		
		return t;
	end;
	
	GetArray 		= function()
		local array = new {};
		
		if this.NumRows() > 0 then
			for _, _row in this.result:rows_assoc() do
				local row = {};
				
				for key, value in pairs( _row ) do
					if value ~= mysql_null() then
						row[ key ] = tonumber( value ) or value;
					end
				end
				
				array.Insert( row );
			end
		end
		
		return array;
	end;
};