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
    int nAugCost = 2;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDice = 1;
	int nDiceSize = 12;    	
    
    	if (nSurge > 0) nAugment += nSurge;
    	
    	// Augmentation effects to point transfer
	if (nAugment > 0)	nDice += nAugment;
	
	//Apply effects
	
	int nHP = MetaPsionics(nDiceSize, nDice, oCaster);
	
	effect eHeal = EffectHeal(nHP);
	effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_L);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, OBJECT_SELF);
	
    }
}