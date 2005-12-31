/*
   ----------------
   Fuse Flesh

   psi_pow_fuseflsh
   ----------------

   24/2/05 by Stratovarius
*/ /** @file

    Fuse Flesh

    Psychometabolism
    Level: Psion/wilder 6
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 round/level
    Saving Throw: Fortitude negates and Fortitude partial; see text
    Power Resistance: Yes
    Power Points: 11
    Metapsionics: Extend, Twin

    You cause the touched subject’s flesh to ripple, grow together, and fuse
    into a nearly seamless whole. The subject is forced into a fetal position
    (if humanoid), with only the vaguest outline of its folded arms and legs
    visible below the all-encompassing wave of flesh.

    If the target fails its Fortitude save to avoid the power’s effect, the
    subject must immediately attempt a second Fortitude save. If this second
    save is failed, the creature’s eyes and ears fuse over, effectively blinding
    and deafening it.

    Augment: For every 2 additional power points you spend, this power’s save DC
             increases by 1.
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
    object oTarget = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        effect ePrimary   =                             EffectParalyze();
               ePrimary   = EffectLinkEffects(ePrimary, EffectVisualEffect(VFX_DUR_PARALYZED));
               ePrimary   = EffectLinkEffects(ePrimary, EffectVisualEffect(VFX_DUR_PARALYZE_HOLD));
               ePrimary   = EffectLinkEffects(ePrimary, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
        effect eSecondary =                               EffectBlindness();
               eSecondary = EffectLinkEffects(eSecondary, EffectDeaf());
               eSecondary = EffectLinkEffects(eSecondary, EffectVisualEffect(VFX_IMP_BLIND_DEAF_M));
        float fDuration   = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Let the AI know
        SPRaiseSpellCastAt(oTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            if(PRCDoMeleeTouchAttack(oTarget))
            {
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePrimary, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                        {
                            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSecondary, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                        }// end if - Save vs secondary effect
                    }// end if - Save vs primary effect
                }// end if - SR check
            }// end if - Touch attack hit
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
