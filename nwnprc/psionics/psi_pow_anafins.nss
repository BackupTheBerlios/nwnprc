/*
   ----------------
   Animal Affinity, Strength
   
   prc_pow_anafins
   ----------------

   11/5/05 by Stratovarius

   Class: Psion (Egoist), Psychic Warrior
   Power Level: 2
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   You forge an affinity with an idealized animal form, thereby boosting one of your ability scores. You gain a +4 bonus to the
   chosen ability score.    
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
    object oTarget = PRCGetSpellTargetObject();
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	
    	effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,4);
    	effect eLink = EffectLinkEffects(eStr, eDur);
        float fDur = 60.0 * nCaster;
        
        if (nMetaPsi == 2)	fDur *= 2;
    	
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
    	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}