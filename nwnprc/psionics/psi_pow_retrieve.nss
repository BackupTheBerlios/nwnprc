/*
   ----------------
   Retrieve
   
   prc_pow_retrieve
   ----------------

   27/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 6
   Range: Medium
   Target: One Item of 10 pounds/level
   Duration: Instantaneous
   Saving Throw: Will negates
   Power Resistance: No
   Power Point Cost: 11
   
   You teleport an item you can see to you. If the object is possessed by an opponent, they get a will save to prevent it.
   This power will take the opponents weapon, if it is disarmable.
   
   Augment: For every additional power point spent, the weight of the item you can pick up increases by 10 pounds.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oCaster = OBJECT_SELF;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    int nAugCost = 0;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, METAPSIONIC_TWIN, 0);
        
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	int nDC = GetManifesterDC(oCaster);
	// Weight is tenths of a pound
	int nWeight = (100 * nCaster);
	
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 
	{
		nWeight += (nAugment * 100);
	}
	
	
	if (GetWeight(oTarget) <= nWeight && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
	{
		CopyItem(oTarget, oCaster, FALSE);
		DestroyObject(oTarget);
	}
	else if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
	{
		if (GetIsCreatureDisarmable(oTarget))
		{
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
			{
				object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget);
				CopyItem(oItem, oCaster, FALSE);
				DestroyObject(oItem);
				
				if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oCaster) == OBJECT_INVALID)
				{
					ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND);
				}
			}
		}
	}
	else
	{
		FloatingTextStringOnCreature("This item is too heavy for you to pick up", oCaster, FALSE);
	}	
    }
}