/*
   ----------------
   Psionic Repair Damage

   psi_pow_repdam
   ----------------

   9/4/05 by Stratovarius
*/ /** @file

    Psionic Repair Damage

    Metacreativity
    Level: Shaper 2
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Construct touched
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin

    When laying your hands upon a construct that has at least 1 hit point
    remaining, you reknit its structure to repair damage it has taken. The power
    repairs 3d8 points of damage +1 point per manifester level. Constructs that
    are immune to psionics or magic cannot be repaired in this fashion.

    Augment: For every 2 additional power points you spend, this power repairs
             an additional 1d8 points of damage.
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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nNumberOfDice = 3 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 8;
        int nHeal;
        effect eHeal, eHealVis = EffectVisualEffect(VFX_IMP_HEALING_L);

        // Check that the target is, in fact, a construct
        if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT)
        {
            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                nHeal = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, manif.nManifesterLevel, 0, FALSE, FALSE);
                eHeal = EffectHeal(nHeal);

                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal,    oTarget);
        	    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget);
        	}// end for - Twin Power
        }// end if - Target is a construct
    }// end if - Successfull manifestation
}
