-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2014
-- License		Proprietary Software
-- Version		1.0

class: ICharacter
{
	ShowUI					= function( this, ... ) triggerClientEvent( this.m_pClient, "IClientCharacter", root, "ShowUI", ... ); 				end;
	HideUI					= function( this, ... ) triggerClientEvent( this.m_pClient, "IClientCharacter", root, "HideUI", ... ); 				end;
	ToggleInventory			= function( this, ... ) triggerClientEvent( this.m_pClient, "IClientCharacter", root, "ToggleInventory", ... ); 	end;
	ShowInventory			= function( this, ... ) triggerClientEvent( this.m_pClient, "IClientCharacter", root, "ShowInventory", ... ); 		end;
	HideInventory			= function( this, ... ) triggerClientEvent( this.m_pClient, "IClientCharacter", root, "HideInventory", ... ); 		end;
	SetInventoryItems		= function( this, ... ) triggerClientEvent( this.m_pClient, "IClientCharacter", root, "SetInventoryItems", ... ); 	end;
};