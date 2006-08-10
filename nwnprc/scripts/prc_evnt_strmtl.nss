//::///////////////////////////////////////////////
//:: Name      Starmantle Onhit: Destroy Non-magical weapons
//:: FileName  prc_evnt_strmtl.nss
//:://////////////////////////////////////////////
/*
The starmantle renders the wearer impervious to 
non-magical weapon attacks and transforms any 
non-magical weapon or missile that strikes it 
into harmless light, destroying it forever. 
Contact with the starmantle does not destroy 
magic weapons or missiles, but the starmantle's 
wearer is entitled to a Reflex saving throw 
(DC 15) each time he is struck by such a weapon;
success indicates that the wearer takes only 
half damage from the weapon (rounded down).

Author:    Tenjac
Created:   7/17/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	//Get attacker that hit
	object oSpellOrigin = OBJECT_SELF;
	object oSpellTarget = PRCGetSpellTargetObject();
	object oItem        = GetSpellCastItem();
		
	// Scripted combat system
	if(!GetIsObjectValid(oItem))
	{
		oItem = GetLocalObject(oSpellOrigin, "PRC_CombatSystem_OnHitCastSpell_Item");
	}
	
	object oToBeDestroyed = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSpellTarget);
	
	//if not present or magical, look for offhand weapon
	if(!GetIsObjectValid(oToBeDestroyed) || GetIsMagical(oToBeDestroyed))
	{
		oToBeDestroyed = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSpellTarget);
		
		if(!GetIsObjectValid(oToBeDestroyed) || GetIsMagical(oToBeDestroyed))
		{
			return;
		}
	}	
	//Kill it
	DestroyObject(oToBeDestroyed);
}

	
	
	
	
	
	
	
		