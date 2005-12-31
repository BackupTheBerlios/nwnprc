/*
   ----------------
   Psychic Vampire

   psi_pow_psyvamp
   ----------------

   17/5/05 by Stratovarius
*/ /** @file

    Psychic Vampire

Psychometabolism
Level: Egoist 4, psychic warrior 4
Manifesting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates
Power Resistance: Yes
Power Points: 7
Metapsionics: Twin

This power shrouds your hand with darkness that you can use to drain an opponent’s power.

If you make a successful melee touch attack (if the victim fails its Fortitude save), the darkness drains 2 power points from your foe for every manifester level you have. The drained points simply dissipate.

Against a psionic being that has no power points or a nonpsionic foe, your attack instead deals 2 points of Intelligence, Wisdom, and Charisma damage.


    @todo 2da and TLK
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
                              METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC         = GetManifesterDC(oManifester);
        int nPen        = GetPsiPenetration(oManifester);
        effect eVis     = EffectVisualEffect(VFX_IMP_HARM);

        // Let the AI know
        SPRaiseSpellCastAt(oTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Perform the Touch Attach
            if(PRCDoMeleeTouchAttack(oTarget) > 0)
            {
                // Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Save - Fortitude negates
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        // Check if the target has PP to lose
                        if(GetCurrentPowerPoints(oTarget) != 0)
                        {
                            LosePowerPoints(oTarget, 2 * manif.nManifesterLevel, TRUE);
                        }
                        // No PP, do ability damage
                        else
                        {
                            ApplyAbilityDamage(oTarget, ABILITY_CHARISMA,     2, DURATION_TYPE_PERMANENT);
                            ApplyAbilityDamage(oTarget, ABILITY_WISDOM,       2, DURATION_TYPE_PERMANENT);
                            ApplyAbilityDamage(oTarget, ABILITY_INTELLIGENCE, 2, DURATION_TYPE_PERMANENT);
                        }

                        // Do VFX
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }// end if - Save
                }// end if - SR check
            }// end if - Touch attack
        }// end for - Twin Power
    }// end if - Successfull manifestation
}