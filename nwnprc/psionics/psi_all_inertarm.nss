/*
   ----------------
   Inertial Armour
   
   prc_all_inertarm
   ----------------

   28/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Hour/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   Your mind generates a tangible field of force that provides a +4 bonus to AC.
   This bonus does not stack with that provided by armour enchantments.
   
   Augment: For every 2 additional power points you spend, the AC bonus improves by 1.
*/

#include "prc_inc_psifunc"
#include "prc_inc_psionic"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

    object oCaster = OBJECT_SELF;
    int nAugCost = 2;
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	nAugCost = 0;
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
    	int CasterLvl = GetManifesterLevel(oCaster);
    	int nAC = 4;    	

    	if (nSurge > 0) nAugment = nSurge;
		
	// Augmentation effects to armour class
	if (nAugment > 0)	nAC += nAugment;
	
	effect eArmor = EffectACIncrease(nAC, AC_ARMOUR_ENCHANTMENT_BONUS);
	effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
	effect eLink = EffectLinkEffects(eArmor, eDur);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, HoursToSeconds(CasterLvl),TRUE,-1,CasterLvl);
    }
}