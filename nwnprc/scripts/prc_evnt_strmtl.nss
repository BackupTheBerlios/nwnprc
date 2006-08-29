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
	object oWeaponR     = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSpellTarget);
	object oWeaponL     = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSpellTarget);
	object oTarget;
	
	// Scripted combat system
	if(!GetIsObjectValid(oItem))
	{
		oItem = GetLocalObject(oSpellOrigin, "PRC_CombatSystem_OnHitCastSpell_Item");
	}
		
	//If non-magical weapon in right hand
	if(GetIsObjectValid(oWeaponR) && !GetIsMagical(oWeaponR))
	{
		DestroyObject(oWeaponR);
		return;
	}
	
	//if non-magical weapon in left hand
	else if(GetIsObjectValid(oWeaponL) && !GetIsMagical(oWeaponL))
	{
		DestroyObject(oWeaponL);
		return;
	}
		
	//else we have a magical weapon
		
}

	
	
	
	
	
	
	
		