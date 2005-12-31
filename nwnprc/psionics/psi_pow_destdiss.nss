/*
   ----------------
   Destiny Dissonance

   psi_pow_destdiss
   ----------------

   15/7/05 by Stratovarius
*/ /** @file

    Destiny Dissonance

    Clairsentience
    Level: Seer 1
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 round/level
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Extend, Twin

    Your mere touch grants your foe an imperfect, unfocused glimpse of the many
    possible futures in store. Unaccustomed to and unable to process the information,
    the subject becomes sickened for 1 round per level of the manifester.
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
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC         = GetManifesterDC(oManifester);
        int nPen        = GetPsiPenetration(oManifester);
        effect eShaken  = CreateDoomEffectsLink();
	    effect eImpact  = EffectVisualEffect(VFX_IMP_DOOM);
	    float fDuration = RoundsToSeconds(manif.nManifesterLevel);
	    if(manif.bExtend) fDuration *= 2;

	    // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Let the AI know
            SPRaiseSpellCastAt(oTarget, TRUE, manif.nSpellID, oManifester);

            // Touch attack
            int nTouchAttack = PRCDoMeleeTouchAttack(oTarget);
            if(nTouchAttack > 0)
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    //Apply VFX Impact and shaken effect
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
                }
            }
        }
    }
}
