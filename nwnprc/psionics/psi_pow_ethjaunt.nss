/*
   ----------------
   Ethereal Jaunt, Psionic

   psi_pow_ethjaunt
   ----------------

   8/4/05 by Stratovarius
*/ /** @file

    Ethereal Jaunt, Psionic

    Psychoportation
    Level: Nomad 7
    Display: Visual
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 13
    Metapsionics: Extend

    You become ethereal, along with your equipment. For the duration of the
    power, you are in a place called the Ethereal Plane, which overlaps the
    normal, physical, Material Plane. When the power expires, you return to
    material existence.

    Taking any hostile actions will force the power to expire immediately.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"
#include "prc_inc_teleport"

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

    object oManifester  = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eLink     =                          EffectEthereal();
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SANCTUARY));
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        float fDuration  = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Check ability to move extra-dimensionally
        if(GetCanTeleport(oManifester, GetLocation(oManifester), FALSE, TRUE))
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
        }// end if - Manifester can move extra-dimensionally
    }// end if - Successfull manifestation
}
