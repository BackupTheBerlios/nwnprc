/*
   ----------------
   Thicken Skin
   
   prc_all_thickskn
   ----------------

   28/10/04 by Stratovarius

   Class: Psion (Egoist), Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   Your skin thickens and spreads across your body, providing a +1 bonus to your armour class.
   
   Augment: For every 3 additional power points you spend, the AC bonus improves by 1.
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
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
    	int CasterLvl = GetManifesterLevel(oCaster);
    	int nAC = 1;

    	// Augmentation effects to armour class
	if (nAugment > 0)	nAC += nAugment;
	
	effect eArmor = EffectACIncrease(nAC, AC_NATURAL_BONUS);
	effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
	effect eLink = EffectLinkEffects(eArmor, eDur);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, (600.0 * CasterLvl),TRUE,-1,CasterLvl);
    }
}