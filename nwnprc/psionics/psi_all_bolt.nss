/*
   ----------------
   Bolt
   
   prc_all_bolt
   ----------------

   29/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You create a stack of arrows, bolts, or sling bullets. Ammunition has a +1 enhancement bonus.
   The type of ammunition created depends on what weapon is equipped. Bows produce arrows, slings bullets,
   and all others create bolts.
   
   Augment: For every 3 additional power points spent, the enhancement increases by +1. 
*/

#include "prc_inc_psifunc"
#include "prc_inc_psionic"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

    object oCaster = OBJECT_SELF;
    int nAugCost = 3;
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	nAugCost = 0;
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
    	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
    	int nBonus = DAMAGE_BONUS_1;
    	object oAmmo;
    	
	if (nSurge > 0) nAugment = nSurge;
	
	// Augmentation effects to item property
	if (nAugment == 1)	nBonus = DAMAGE_BONUS_2;
	if (nAugment == 2)	nBonus = DAMAGE_BONUS_3;
	if (nAugment == 3)	nBonus = DAMAGE_BONUS_4;
	if (nAugment >= 4)	nBonus = DAMAGE_BONUS_5;
	
    	
    	if (GetBaseItemType(oWeapon) == BASE_ITEM_LONGBOW || GetBaseItemType(oWeapon) == BASE_ITEM_SHORTBOW)
    	{
    	   	oAmmo = CreateItemOnObject("NW_WAMAR001", OBJECT_SELF, 99);
    	   	SetIdentified(oAmmo, TRUE);    	
    		AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, nBonus), oAmmo, 99999.9);
    	}
    	if (GetBaseItemType(oWeapon) == BASE_ITEM_SLING)
    	{
    	   	oAmmo = CreateItemOnObject("NW_WAMBU001", OBJECT_SELF, 99);
    	   	SetIdentified(oAmmo, TRUE);    	
    		AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, nBonus), oAmmo, 99999.9);
    	}
    	else 
    	{
    	   	oAmmo = CreateItemOnObject("NW_WAMBO001", OBJECT_SELF, 99);
    	   	SetIdentified(oAmmo, TRUE);    	
    		AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, nBonus), oAmmo, 99999.9);
    	}    	

    }
}