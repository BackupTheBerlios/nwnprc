/*
   ----------------
   Animal Affinity, Intelligence

   prc_pow_anafini
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

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
            EvaluateManifestation(oManifester, oTarget,
                                  PowerAugmentationProfile(),
                                  METAPSIONIC_EXTEND
                              );
    if(manif.bCanManifest)
    {
        effect eVis  = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
        effect eDur  = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eAbi  = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4);
        effect eLink = EffectLinkEffects(eAbi, eDur);

        float fDur = 60.0 * manif.nManifesterLevel;
        if(manif.bExtend) fDur *= 2;

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, -1, manif.nManifesterLevel);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}