/*
   ----------------
   Restoration, Psionic

   psi_pow_restore
   ----------------

   19/2/04 by Stratovarius
*/ /** @file

    Restoration, Psionic

    Psychometabolism (Healing)
    Level: Egoist 6
    Manifesting Time: 3 rounds
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 11
    Metapsionics: None

    As the restoration spell, except as noted here.

    @todo 2da
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"

// Checks if the effect is specific to a plot and should not be removed normally
int GetShouldNotBeRemoved(effect eEff)
{
    object oCreator = GetEffectCreator(eEff);
    if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
        return TRUE;
    return FALSE;
}

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
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        int nEffectType;
        effect eVis = EffectVisualEffect(VFX_IMP_RESTORATION);
        effect eTest;

        // Let the AI know - Special handling
        SPRaiseSpellCastAt(oTarget, FALSE, SPELL_RESTORATION, oManifester);

        // Loop over remaining effects, remove any negative ones
        eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            nEffectType = GetEffectType(eTest);
            if(nEffectType == EFFECT_TYPE_ABILITY_DECREASE          ||
               nEffectType == EFFECT_TYPE_AC_DECREASE               ||
               nEffectType == EFFECT_TYPE_ATTACK_DECREASE           ||
               nEffectType == EFFECT_TYPE_DAMAGE_DECREASE           ||
               nEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE  ||
               nEffectType == EFFECT_TYPE_SAVING_THROW_DECREASE     ||
               nEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
               nEffectType == EFFECT_TYPE_SKILL_DECREASE            ||
               nEffectType == EFFECT_TYPE_BLINDNESS                 ||
               nEffectType == EFFECT_TYPE_DEAF                      ||
               nEffectType == EFFECT_TYPE_PARALYZE                  ||
               nEffectType == EFFECT_TYPE_NEGATIVELEVEL
               )
            {
                if(!GetShouldNotBeRemoved(eTest))
                    RemoveEffect(oTarget, eTest);
            }

            eTest = GetNextEffect(oTarget);
        }// end while - Effect loop

        // Apply visuals
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }// end if - Successfull manifestation
}
