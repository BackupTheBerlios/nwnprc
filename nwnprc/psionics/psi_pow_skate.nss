/*
   ----------------
   Skate
   
   prc_all_skate
   ----------------

   7/12/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Touch
   Target: One Creature
   Duration: 1 min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You, or another willing creature, can slide along solid ground as if it was smooth ice. The skater's land speed
   increases by 50%.
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
    	effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eSpeed = EffectMovementSpeedIncrease(50);
    	effect eLink = EffectLinkEffects(eDur, eSpeed);

	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (60.0 * nCaster),TRUE,-1,nCaster);
    }
}