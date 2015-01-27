-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

local soundParent = createElement( "Sound", "Sound" );

enum "eSoundState"
{
	SOUND_STATE_ERROR		= -1;
    SOUND_STATE_STOPPED		= 0;
    SOUND_STATE_PLAYING		= 1;
    SOUND_STATE_PAUSED		= 2;
};

class. Sound
{
	ID				= NULL;
	Path			= sPath;
	AttachedTo		= NULL;
	Interior		= 0;
	Dimension		= 0;
	Volume			= 1.0;
	MinDistance		= 5.0;
	MaxDistance		= 30.0;
	Loop			= true;
	Element			= NULL;
	EnabledEffects	= NULL;
	MemberID		= NULL;
	
	Sound		= function( path )
		this.Path	= path;
	end;
	
	_Sound		= function()
		this.Stop();
		
		this.AttachedTo		= NULL;
		this.Position		= NULL;
		this.EnabledEffects	= NULL;
	end;
	
	Play		= function()
		if this.AttachedTo and type( this.AttachedTo ) ~= "userdata" then
			Error( 2, 2342, "this.AttachedTo", "userdata", type( this.AttachedTo ) );
		end
		
		this.Stop();
		
		local sound	=
		{
			Path			= this.Path;
			Volume			= this.Volume;
			MinDistance		= this.MinDistance;
			MaxDistance		= this.MaxDistance;
			Loop			= this.Loop;
			EnabledEffects	= this.EnabledEffects;
			AttachedTo		= this.AttachedTo;
			MemberID		= this.MemberID;
		};
		
		this.Element = createColSphere( 0.0, 0.0, 0.0, this.MaxDistance + 40.0 );
		
		this.Element:SetData( "Sound::", sound );
		
		this.Element:SetParent( soundParent );
		
		this.Element.SetInterior( this.Interior );
		this.Element.SetDimension( this.Dimension );
		
		if this.Position then
			this.Element.SetPosition( this.Position );
		end
		
		if this.AttachedTo then
			this.Element.AttachTo( this.AttachedTo );
		end
		
		return true;
	end;
	
	Pause		= function()
	end;
	
	Stop		= function()
		if this.Element then
			this.Element.Destroy();
			this.Element = NULL;
			
			return true;
		end
		
		return false;
	end;
};
