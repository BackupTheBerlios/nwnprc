/*
   ----------------
   Skate

   psi_pow_skate
   ----------------

   7/12/04 by Stratovarius
*/ /** @file

    Skate

    Psychoportation
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal or touch; see text
    Target: You or one willing creature
    Duration: 1 min./level
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Extend

    You or another willing creature can slide along solid ground as if on smooth
    ice. If you manifest skate on yourself or another creature, the subject of
    the power retains equilibrium by mental desire alone, allowing her to
    gracefully skate along the ground, turn, or stop suddenly as desired. The
    skater’s speed increases by 50%.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"

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
        effect eLink = EffectLinkEffects(EffectMovementSpeedIncrease(50),
                                         EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)
                                         );
        effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        if(oTarget == oManifester                                       ||
           spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oManifester)
           )
        {
            // Let the AI know
            SPRaiseSpellCastAt(oTarget, FALSE, manif.nSpellID, oManifester);

            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID,manif.nManifesterLevel);
        }// end if - Targeting check
    }// end if - Successfull manifestation
}
