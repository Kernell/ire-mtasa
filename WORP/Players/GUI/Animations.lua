-- Author:      	Kernell
-- Version:     	1.0.0

local scrX, scrY	= guiGetScreenSize();
local pDialog		= NULL;

class "CGUIAnimations" ( CGUI )

local Animations	=
{
	[ "Aim" ]				= { "SHOP", "ROB_Loop", 0, true, false };
	[ "Aim Rifle" ]			= { "SHOP", "SHP_Gun_Aim", 0, true, false };
	[ "Gun Duck" ]			= { "SHOP", "SHP_Gun_Duck", 0, false, false };
	[ "Shifty" ]			= { "SHOP", "ROB_Shifty", 0, false, false };
	[ "Handsup" ]			= { "SHOP", "SHP_HandsUp_Scr", 0, false, false };
	[ "Handsup Loop" ]		= { "SHOP", "SHP_Rob_HandsUp", 0, true, false };
	[ "Handsup React" ]		= { "SHOP", "SHP_Rob_React", 0, false, false };
	[ "Handsup Give Cash" ]	= { "SHOP", "SHP_Rob_GiveCash", 0, false, false };
	[ "Serve Loop" ]		= { "SHOP", "SHP_Serve_Loop", 0, true, false };
	[ "Smoking" ]			= { "SHOP", "Smoke_RYD", 0, true, false };
	[ "Bitch slap" ]		= { "MISC", "bitchslap", 0, true, false };
	[ "Hiker Right" ]		= { "MISC", "Hiker_Pose", 0, false, false };
	[ "Hiker Left" ]		= { "MISC", "Hiker_Pose_L", 0, false, false };
	[ "Throw 1" ]			= { "MISC", "KAT_Throw_K", 0, false, false };
	[ "Throw 2" ]			= { "MISC", "KAT_Throw_P", 0, false, false };
	[ "Lean" ]				= { "MISC", "Plyrlean_Loop", 0, true, false };
	[ "Facepalm" ]			= { "MISC", "plyr_shkhead", 0, false, false };
	[ "Fap" ]				= { "PAULNMAC", "wank_loop", 0, true, false };
	[ "Scratch Balls" ]		= { "MISC", "Scratchballs_01", 0, true, false };
	[ "Dance 1" ]			= { "DANCING", "dance_loop", 0, true, false };
	[ "Dance 2" ]			= { "DANCING", "DAN_Down_A", 0, true, false };
	[ "Dance 3" ]			= { "DANCING", "DAN_Left_A", 0, true, false };
	[ "Dance 4" ]			= { "DANCING", "DAN_Loop_A", 0, true, false };
	[ "Dance 5" ]			= { "DANCING", "DAN_Right_A", 0, true, false };
	[ "Dance 6" ]			= { "DANCING", "DAN_Up_A", 0, true, false };
	[ "Dance 7" ]			= { "DANCING", "dnce_M_a", 0, true, false };
	[ "Dance 8" ]			= { "DANCING", "dnce_M_b", 0, true, false };
	[ "Dance 9" ]			= { "DANCING", "dnce_M_c", 0, true, false };
	[ "Dance 10" ]			= { "DANCING", "dnce_M_d", 0, true, false };
	[ "Dance 11" ]			= { "DANCING", "dnce_M_e", 0, true, false };
	[ "Car Repair Loop" ]	= { "CAR", "Fixn_Car_Loop", 0, true, false };
	[ "Car Repair Out" ]	= { "CAR", "Fixn_Car_Out", 0, false, false, true, true };
}

function CGUIAnimations:CGUIAnimations( Anims )
	self.Window		= self:CreateWindow( "Анимации" )
	{
		X			= scrX / 2;
		Y			= 'center';
		Width		= 250;
		Height		= 390;
		Sizable		= false;
	}
	
	self.list		= self.Window:CreateGridList{ 0, 25, 230, 325 } 
	{ 
		{ "Animation", .85 }; 
	}

	self.btnApply		= self.Window:CreateButton( "Применить" )
	{
		X		= 5;
		Y		= 355;
		Width	= 75;
		Height	= 25;
	}

	self.btnStop		= self.Window:CreateButton( "Остановить" )
	{
		X		= 87;
		Y		= 355;
		Width	= 75;
		Height	= 25;
	}
	
	self.btnClose		= self.Window:CreateButton( "Закрыть" )
	{
		X		= 165;
		Y		= 355;
		Width	= 75;
		Height	= 25;
	}
	
	function self.btnApply.Click( button, state )
		if button == "left" and state == "up" then
			local item 			= self.list:GetSelectedItem();
			
			if not item or item == -1 then
				return;
			end
			
			local anim			= self.list:GetItemText( item, self.list[ 'Animation' ] );
			
			if not anim then
				return;
			end
			
			SERVER.SetAnimation( unpack( Animations[ anim ] ) );
		end
	end

	self.list.DoubleClick = self.btnApply.Click;
	
	function self.btnStop.Click( button, state )
		if button == "left" and state == "up" then
			SERVER.SetAnimation( 'PED', 'facanger', 0, false, false, false, false );
		end
	end
	
	function self.btnClose.Click( button, state )
		if button == "left" and state == "up" then
			delete( self );
		end
	end
	
	self:Fill( Anims );
	
	self.Window:SetVisible( true );
	self.Window:BringToFront();
	
	self:ShowCursor();
end

function CGUIAnimations:_CGUIAnimations()
	self.Window:SetVisible( false );
	
	self:HideCursor();
	
	pDialog = NULL;
end 

function CGUIAnimations:Fill( Anims )
	self.list:Clear();
	
	local AnimationsSorted = {};
	
	for key in pairs( Anims ) do
		table.insert( AnimationsSorted, key );
	end
	
	table.sort( AnimationsSorted );
	
	for _, anim_name in ipairs( AnimationsSorted ) do
		self:AddItem( anim_name );
	end
end

function CGUIAnimations:AddItem( key )
	if not key then
		return;
	end
	
	local gridRow 	= self.list:AddRow();
	
	if not gridRow then
		return;
	end
	
	self.list:SetItemText( gridRow, self.list[ "Animation" ], key, false, false );
end

local function Anims( sCmd, sAnim )
	if sAnim == 'off' or sAnim == 'null' or sAnim == 'stop' then
		SERVER.SetAnimation( 'PED', 'facanger', 0, false, false, false, false );
	elseif Animations[ sAnim ] then
		SERVER.SetAnimation( unpack( Animations[ sAnim ] ) );
	else
		if pDialog then
			delete ( pDialog );
		else
			pDialog = CGUIAnimations( Animations );
		end
	end
end

addCommandHandler( 'anim', Anims );