/*
   ----------------
   Psionic Revivify

   psi_pow_psirev
   ----------------

   17/5/05 by Stratovarius
*/ /** @file

    Psionic Revivify

    Psychometabolism (Healing) [Good]
    Level: Egoist 5
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Dead creature touched
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 9, XP
    Metapsionics: None

    Psionic revivify lets a manifester reconnect a corpse’s psyche with its
    body, restoring life to a recently deceased creature.

    This power functions like the raise dead spell, except that the affected
    creature receives no level loss, no Constitution loss, and no loss of
    powers.

    The creature has -1 hit points (but is stable) after being restored to life.

    XP Cost: 200 XP.


    @todo 2da
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
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        effect eResurrect = EffectResurrection();
        effect eVis       = EffectVisualEffect(VFX_IMP_RAISE_DEAD);

        // Make sure the target is in fact dead
        if(GetIsDead(oTarget))
        {
            // Let the AI know - Special handling
            SPRaiseSpellCastAt(oTarget, FALSE, SPELL_RAISE_DEAD, oManifester);

            // Apply effects
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eResurrect, oTarget);

            // Pay the XP cost
            SetXP(oManifester, GetXP(oManifester) - 200);

            // Do special stuff
            ExecuteScript("prc_pw_raisedead", oManifester);
            if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
                SetPersistantLocalInt(oTarget, "persist_dead", FALSE);

            // [Good] descriptor causes an alignent shift
            SPGoodShift(oManifester);
        }// end if - Deadness check
    }// end if - Successfull manifestation
}
