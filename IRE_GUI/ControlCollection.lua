-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. ControlCollection
{
	ControlCollection = function( owner )
		this.Owner		= owner;
		
		this.List		= new {};
		
		this.Add		= function( control )
			control.Owner	= this.Owner;
			
			this.List.Insert( control );
		end
		
		this.Begin		= function()
			local i	= 0;
			local l	= this.List.Length();
			
			local function iter()
				i = i + 1;
				
				if i <= l then
					return i, this.List[ i ];
				end
				
				return NULL;
			end
			
			return iter;
		end

		this.Length	= this.List.Length;
	end;

	Owner  = NULL;
};