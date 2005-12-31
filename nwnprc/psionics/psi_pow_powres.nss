/*
   ----------------
   Power Resistance

   psi_pow_powres
   ----------------

   23/2/04 by Stratovarius
*/ /** @file

    Power Resistance

    Clairsentience
    Level: Psion/wilder 5
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min./level
    Saving Throw: None
    Power Resistance: No
    Power Points: 9
    Metapsionics: Extend

    The creature gains power resistance equal to 12 + your manifester level.
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
        int nSR         = 12 + manif.nManifesterLevel;
        effect eLink    =                          EffectSpellResistanceIncrease(nSR);
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE));
        effect eVis     = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, manif.nManifesterLevel);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}
