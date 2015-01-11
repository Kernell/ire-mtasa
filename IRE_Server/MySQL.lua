-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. MySQL
{
	Transaction	= false;
	
	User		= "root";
	Pass		= "";
	Database	= "users";
	Hostname	= "localhost";
	
	Prefix		= "";
	Engine		= "MyISAM";
	
	static
	{
		CURRENT_TIMESTAMP = "CURRENT_TIMESTAMP";
	};
	
	MySQL = function( sUser, sPasswd, sDatabase, sHost, Options )
		if sUser and sPasswd and sHost then
			this.User 		= sUser or this.User;
			this.Pass 		= sPasswd or this.Pass;
			this.Database 	= sDatabase or this.Database;
			this.Hostname	= sHost or this.Hostname;
			this.Engine		= Options and Options[ "engine" ] or this.Engine;
			
			this.Connect( sUser, sPasswd, sDatabase, sHost, Options );
		end
	end;
	
	_MySQL = function()
		this.Close();
	end;
	
	Close = function()
		if this.m_pHandler ~= NULL then
			mysql_close( this.m_pHandler );
			
			this.m_pHandler		= NULL;
			
			Debug( "MySQL closed (" + this.Hostname + ")" );
			
			return true;
		end
		
		return false;
	end;
	
	Connect = function( sUser, sPasswd, sDatabase, sHost, Options )
		if not this.m_pHandler or not this.Ping() then
			this.m_pHandler = mysql_connect( this.Hostname, this.User , this.Pass, this.Database );
			
			if not this.m_pHandler then
				Debug( "Unable to connect to MySQL server (" + this.Hostname + ")" );
				
				return false;
			end
			
			Debug( "MySQL connected (" + this.Hostname + ")" );
			
			this.Query( "SET NAMES utf8" );
			this.Query( "SET lc_time_names = 'ru_RU'" );
			
			return true;
		end
		
		return false;
	end;
	
	Query = function( sQuery, ... )
		if not sQuery then
			error( "bad argument #1 to 'MySQL.Query'", 2 );
		end
		
		if not this.m_pHandler or not this.Ping() then
			Debug( "MySQL server has gone away", 2 );
			
			this.Connect( this.User, this.Pass, this.Database, this.Hostname );
			
			if not this.Ping() then
				this.m_sLastError = 'MySQL server is lost';
				
				return false, this.m_sLastError;
			end
		end
		
		if ( ... ) then
			local t = { ... };
			
			for k, v in ipairs( t ) do 
				t[ k ] = this.EscapeString( (string)(v) ) or "";
			end
			
			local bResult;
			
			bResult, sQuery = pcall( string.format, sQuery, unpack( t ) );
			
			if not bResult then error( sQuery, 2 ) end
		end
		
		local pResult = this.m_pHandler:query( sQuery );
		
		if not pResult then
			this.m_sLastError = this.m_pHandler:error();
			
			return false, this.m_sLastError;
		end
		
		if type( pResult ) == "boolean" then
			return pResult;
		end
		
		return new. MySQLResult( pResult );
	end;
	
	Insert	= function( sTable, Fields )
		if sTable then
			local sQuery = "INSERT INTO `" + sTable + "` SET ";
			
			local iCount = 0;
			
			for sField, vValue in pairs( Fields ) do
				if iCount > 0 then
					sQuery = sQuery + ", ";
				end
				
				if type( vValue ) == 'table' then
					sQuery = sQuery + "`" + sField + "` = '" + toJSON( vValue ) + "'";
				else
					sQuery = sQuery + "`" + sField + "` = '" + (string)(vValue) + "'";
				end
				
				iCount = iCount + 1;
			end
			
			if iCount > 0 then
				if this.Query( sQuery ) then
					return this.InsertID();
				end
				
				Debug( this.Error(), 1 );
			end
		end
		
		return false;
	end;
	
	CreateTable	= function( sTableName, Struct )
		local pResult = this.Query( "SHOW TABLES LIKE %q", sTableName );
		
		if not pResult then error( this.Error(), 2 ); end
		
		local iRows = pResult.NumRows();
		
		delete ( pResult );
		
		local RemapKeys =
		{
			PRI = "PRIMARY";
			SEC	= "SECONDARY";
			UNI = "UNIQUE";
		};
		
		if iRows == 0 then
			local Fields	= {};
			local Keys		= { PRI = {}; SEC = {}; UNI = {}; };
			
			for i, Row in ipairs( Struct ) do
				if Row.Key then
					if Keys[ Row.Key ] then
						table.insert( Keys[ Row.Key ], Row.Field );
					end
				end
				
				table.insert( Fields, this.ToStringColumn( Row ) );
			end
			
			local sPrimary 	= NULL;
			
			if table.getn( Keys.PRI ) > 0 then
				sPrimary = "PRIMARY KEY (`" + table.concat( Keys.PRI, '`,`' ) + "`)"
			end
			
			local sSecondary = NULL;
			
			for i, key in ipairs( Keys.SEC ) do
				if i == 1 then
					sSecondary = "UNIQUE ";
				end
				
				if i > 2 then
					sSecondary = sSecondary + ",\n";
				end
				
				sSecondary = sSecondary + "KEY `SECONDARY` (`" + key + "`)";
			end
			
			local sUnique	= NULL;
			
			for i, key in ipairs( Keys.UNI ) do
				if i == 1 then
					sUnique = "UNIQUE ";
				end
				
				if i > 2 then
					sUnique = sUnique + ",\n";
				end
				
				sUnique = sUnique + "KEY `" + key + "` (`" + key + "`)";
			end
			
			table.insert( Fields, sPrimary );
			table.insert( Fields, sSecondary );
			table.insert( Fields, sUnique );
			
			local sQuery = "CREATE TABLE `" + sTableName + "`(\n  " + table.concat( Fields, ",\n  " ) + "\n) ENGINE=" + this.Engine + " DEFAULT CHARSET=utf8;";
			
			if this.Query( sQuery ) then
				Debug( "MySQL - Created table " + sTableName, 3 );
				
				return true;
			end
			
			print( sQuery );
			
			error( "MySQL - Unable to create table " + sTableName + "\n" + this.Error(), 2 );		
		end
		
		local pResult = this.Query( "DESCRIBE " + sTableName );
		
		if not pResult then error( this.Error(), 2 ); end
		
		local pRows = pResult.GetArray();
		
		delete( pResult );
		
		local Fields 			= {};
		local AddKeys 			= { PRI = {}; UNI = {}; };
		local DropKeys			= {};
		local HaveKeys 			= { PRI = {}; UNI = {}; };
		
		for i, pRow in ipairs( pRows ) do
			Fields[ pRow.Field ] = pRow;
		end
		
		for i, pRow in ipairs( Struct ) do
			Struct[ pRow.Field ] = pRow;
			
			if HaveKeys[ pRow.Key ] then
				table.insert( HaveKeys[ pRow.Key ], pRow.Field );
			end
		end
		
		for i, pRow in ipairs( Struct ) do repeat
			if Fields[ pRow.Field ] then
				local sField		= this.ToStringColumn( pRow );
				local sCurrentField	= this.ToStringColumn( Fields[ pRow.Field ] );
				
				if sCurrentField ~= sField then
					if not this.Query( "ALTER TABLE `%s` MODIFY COLUMN " + sField, sTableName ) then
						error( "MySQL - Changing field " + sTableName + "." + pRow.Field + " failed\n" + this.Error(), 2 );
					end
					
					Debug( "Changed field " + sTableName + "." + pRow.Field );
					Debug( sCurrentField + " => " + sField );
				end
				
				if Fields[ pRow.Field ].Key ~= pRow.Key then
					if Fields[ pRow.Field ].Key and Fields[ pRow.Field ].Key:len() > 0 then
						table.insert( DropKeys, pRow.Field );
					end
					
					if AddKeys[ pRow.Key ] then
						table.insert( AddKeys[ pRow.Key ], pRow.Field );
					end
				end
				
				break;
			end
			
			local sQuery = ( "ALTER TABLE `%s` ADD " + this.ToStringColumn( pRow ) + ( pRow.Extra == "auto_increment" and " PRIMARY KEY" or "" ) + " " + ( Struct[ i - 1 ] and ( "AFTER `" + Struct[ i - 1 ].Field + "`" ) or "FIRST" ) ):format( sTableName );
			
			if not this.Query( sQuery ) then
				error( "Add field " + sTableName + "." + pRow.Field + " failed\n\n" + this.Error() + "\n\n" + sQuery, 2 );
			end
			
			if AddKeys[ pRow.Key ] and pRow.Extra ~= "auto_increment" then
				table.insert( AddKeys[ pRow.Key ], pRow.Field );
			end
			
			Debug( "Added field " + sTableName + "." + pRow.Field );
		until true end
		
		for i, pRow in ipairs( pRows ) do
			if not Struct[ pRow.Field ] then
				if not this.Query( "ALTER TABLE `%s` DROP `%s`", sTableName, pRow.Field ) then
					error( this.Error(), 2 );
				end
				
				Debug( "Removed field " + sTableName + "." + pRow.Field );
			end
		end
		
		for i, sKey in ipairs( DropKeys ) do
			if not this.Query( "ALTER TABLE `%s` DROP INDEX " + sKey, sTableName ) then
				error( "MySQL - Unable to drop " + sKey + " key\n" + this.Error(), 2 );
			end
			
			Debug( "Removed index " + sTableName + "." + sKey );
		end
		
		if table.getn( AddKeys.PRI ) > 0 then
			if not this.Query( "ALTER TABLE `" + sTableName + "` DROP PRIMARY KEY, ADD PRIMARY KEY ( `" + table.concat( HaveKeys.PRI, "`, `" ) + "` )" ) then
				print( sQuery );
				
				error( "MySQL - Unable to add primary keys\n\n" + this.Error(), 2 );
			end
		end
		
		if table.getn( AddKeys.UNI ) > 0 then
			local sQuery	= "";
			
			for i, k in ipairs( AddKeys.UNI ) do
				if i > 1 then
					sQuery = sQuery + ", ";
				end
				
				sQuery = sQuery + "ADD UNIQUE KEY `" + k + "` ( `" + k + "` )";
			end
			
			if not this.Query( "ALTER TABLE `%s` " + sQuery, sTableName ) then
				print( sQuery );
				
				error( "MySQL - Unable to add unique key\n\n" + this.Error(), 2 );
			end
		end
		
		return true;
	end;
	
	StartTransaction = function( bForce )
		if this.Engine == 'InnoDB' and not this.Transaction then
			this.Transaction		= true;
			this.TransactionForce	= (bool)(bForce);
			
			this.Query( "START TRANSACTION" );
		end
	end;
	
	Commit = function( bForce )
		if this.Transaction and ( not this.TransactionForce or bForce ) then
			this.Transaction		= false;
			this.TransactionForce	= false;
			
			this.Query( "COMMIT" );
		end
	end;
	
	AffectedRows = function()
		return this.m_pHandler and this.m_pHandler:mysql_affected_rows();
	end;
	
	ChangeUser = function( ... )
		return this.m_pHandler and this.m_pHandler:change_user( ... );
	end;
	
	InsertID = function()
		return this.m_pHandler and this.m_pHandler:insert_id();
	end;
	
	EscapeString = function( value )
		return this.m_pHandler and this.m_pHandler:escape_string( value );
	end;
	
	Ping = function()
		return this.m_pHandler and this.m_pHandler:ping();
	end;
	
	Error = function()
		local sError = this.m_sLastError or this.m_pHandler and this.m_pHandler:error();
		
		this.m_sLastError = NULL;
		
		return sError;
	end;
	
	ToStringColumn = function( Column )
		local Field		= Column.Field;
		local Type		= Column.Type;
		local Null		= Column.Null and ( Column.Null == "NO" and "NOT NULL" or "NULL" );
		local Default	= Column.Default ~= false and ( Column.Default and ( MySQL[ Column.Default ] or ( "'" + (string)(Column.Default) + "'" ) ) or "NULL" );
		local Extra		= NULL;
		
		if Default == "NULL" and Null == "NOT NULL" then
			Default = false;
		end
		
		if type( Column.Extra ) == "string" and Column.Extra:len() > 0 then
			Extra = Column.Extra:upper();
		end
		
		return "`" + Field + "` " + Type + ( Null and " " + Null or "" ) + ( Default and " DEFAULT " + Default or "" ) + ( Extra and " " + Extra or "" );
	end;
};
