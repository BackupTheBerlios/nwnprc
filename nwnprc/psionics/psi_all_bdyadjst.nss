/*
   ----------------
   Body Adjustment
   
   prc_all_bdyadjst
   ----------------

   22/10/04 by Stratovarius

   Class: Psion / Wilder, Psychic Warrior
   Power Level: Psion/Wilder 3, Psychic Warrior 2
   Range: Personal
   Target: Caster
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: Psion/Wilder 5, PW 3
   
   When you manifest this power, you heal 1d12 hitpoints.
   
   Augment: For every 2 additional power points spent,you heal 1d12 hitpoints.
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
    	int nHP = d12(1);
    
    	if (nSurge > 0) nAugment = nSurge;
    	
    	// Augmentation effects to point transfer
	if (nAugment > 0)	nHP = nHP + d12(nAugment);
	
	//Apply effects
	effect eHeal = EffectHeal(nHP);
	effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_L);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, OBJECT_SELF);
	
    }
}