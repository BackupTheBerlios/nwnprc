/*
   ----------------
   Far Hand
   
   prc_all_farhand
   ----------------

   6/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Medium
   Target: One Item of 5 pounds
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You mentally lift a small, unattended object and move it to your inventory.
   
   Augment: For every additional power point spent, the weight of the item you can pick up increases by 2 pounds.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

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
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);
        
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	int nWeight = 50;
	
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 
	{
		nWeight += (nAugment * 20);
	}
	
	
	if (GetWeight(oTarget) <= nWeight && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
	{
		CopyItem(oTarget, oCaster, FALSE);
		DestroyObject(oTarget);
	}
	else
	{
		FloatingTextStringOnCreature("This item is too heavy for you to pick up", oCaster, FALSE);
	}	
    }
}