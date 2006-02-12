/*
   ----------------
   Strength of my Enemy

   psi_pow_strnmy
   ----------------

   14/12/05 by Stratovarius
*/ /** @file

    Strength of My Enemy

Psychometabolism
Level: Psychic warrior 2
Manifesting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 round/level
Power Points: 3
Metapsionics: Extend

You gain the ability to siphon away your enemy’s strength for your own use. One of your natural or manufactured weapons becomes the instrument of your desire, and deals 1 point of Strength damage on each successful hit. You gain that point of Strength as an enhancement bonus to your Strength score. Strength you siphon from different foes is tracked separately - the total siphoned from each individual foe is considered a separate enhancement bonus to your Strength (maximum +8), and you gain only the highest total.

Augment: For every 3 additional power points you spend, the maximum enhancement bonus you can add to your Strength increases by 2.
*/


#include "spinc_common"
#include "psi_inc_onhit"
#include "psi_inc_psifunc"
#include "psi_spellhook"

// This is used to apply the Strength Bonus for the proper length of time
void RoundTimer(object oManifester)
{
        int nRound = GetLocalInt(oManifester, "StrengthEnemyRound");
        // If time has run out, delete the int.
        if (0 >= nRound)
        {
                DeleteLocalInt(oManifester, "StrengthEnemyRound");
        }
        else
        {
                // otherwise, keep going, subtracting a round
                SetLocalInt(oManifester, "StrengthEnemyRound", (nRound - 1));
                DelayCommand(6.0f, RoundTimer(oManifester));
        }
}

void main()
{
if (!PsiPrePowerCastCode()){ return; }
// End of Spell Cast Hook



        object oManifester = OBJECT_SELF;
        // Can be either a claw or a weapon, so we check weapon first then see if he has a claw.
        // If there is neither, then tell him so and flunk the power
        object oTarget = IPGetTargetedOrEquippedMeleeWeapon();
        if (!GetIsObjectValid(oTarget))
        {
                oTarget = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oManifester);
                if (!GetIsObjectValid(oTarget))
                {
                        FloatingTextStringOnCreature("You do not have a valid target for Strength of my Enemy", oManifester, FALSE);
                        return;
                }
        }

        struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       3, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND
                              );

        if(manif.bCanManifest)
        {
                int nCaster = GetManifesterLevel(oManifester);
                int nDur = nCaster;
                if(manif.bExtend) nDur *= 2;
                effect eVis = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
                effect eVis2 = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
                int nMax = 8 + 2 * manif.nTimesAugOptUsed_1;

                if(GetIsObjectValid(oTarget))
                {
                        /* Add the onhit spell to the weapon */
                        IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), RoundsToSeconds(nDur), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                        SetLocalInt(oManifester, "StrengthEnemyActive", TRUE);
                        SetLocalInt(oManifester, "StrengthEnemyMax", nMax);
                        // For dispelling the Str boost, make sure the manifester level is correct
                        SetLocalInt(oManifester, "StrengthEnemyCaster", nCaster);
                        // This keeps track of the strength boost. It starts at 0
                        SetLocalInt(oManifester, "StrengthEnemyBonus", 0);
                        DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oManifester, "StrengthEnemyActive"));
                        DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oManifester, "StrengthEnemyMax"));
                        DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oManifester, "StrengthEnemyBonus"));
                        DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oManifester, "StrengthEnemyCaster"));

                        /* Apply the VFX to whatever is wielding the target */
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, GetItemPossessor(oTarget));

                        // Keeps track of how many rounds are left to the power
                        SetLocalInt(oManifester, "StrengthEnemyRound", nDur);
                        DelayCommand(6.0f, RoundTimer(oManifester));
                }
                else
                {
                        FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // Item must be weapon or creature holding a weapon
                        return;
                }

        }
}