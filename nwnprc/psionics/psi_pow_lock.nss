/*
   ----------------
   Far Hand
   
   prc_all_farhand
   ----------------

   7/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Medium
   Target: One Chest or Door
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   You lock and trap a chest or door. This will prevent anyone from opening the chest without harm. Be careful
   as the trap will target anyone attempting to open the chest.
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
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    int nAugCost = 0;
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
    	object oTarget = GetSpellTargetObject();
	int nCaster = GetManifesterLevel(oCaster);
	
	 if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR || GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
	 {
		if (GetLockLockable(oTarget))
		{
			SetLocked(oTarget, TRUE);
			itemproperty iTrap = ItemPropertyTrap(IP_CONST_TRAPSTRENGTH_STRONG, TRAP_BASE_TYPE_STRONG_SONIC);
			AddItemProperty(DURATION_TYPE_PERMANENT, iTrap, oTarget);
		}
		else
		{
			FloatingTextStringOnCreature("This item is cannot be locked", oCaster, FALSE);
		}	
	 }
    }
}