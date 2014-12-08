-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class. Group
{
	ID		= NULL;
	Name	= NULL;
	Caption	= NULL;
	Color	= NULL;
	Rights	= NULL;

	Group	= function( id, name, caption, color )
		this.ID			= id;
		this.Name		= name;
		this.Caption	= caption;
		this.Color		= color;
		this.Rights		= {};
	
		Server.Game.GroupManager.AddToList( this );
	end;

	_Group	= function()
		Server.Game.GroupManager.RemoveFromList( this );
	end;

	GetID	= function()
		return this.ID;
	end;
	
	GetName		= function()
		return this.Name;
	end;

	GetCaption	= function()
		return this.Caption;
	end;

	GetColor	= function()
		return this.Color;
	end;

	AddRight	= function( rightName )
		this.Rights[ rightName ] = true;
	end;

	GetRight	= function( rightName )
		return this.Rights[ rightName ];
	end;

	RemoveRight	= function( rightName )
		this.Rights[ rightName ] = NULL;
	end;
}
