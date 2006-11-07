/**
 * Hexblade: Dark Companion
 * 14/09/2005
 * Stratovarius
 * Type of Feat: Class Specific
 * Prerequisite: Hexblade level 4.
 * Specifics: The Hexblade gains a dark companion. It is an illusionary creature that does not engage in combat, but all monsters near it take a -2 penalty to AC and Saves.
 * Use: Selected.
 */

#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eAC = EffectACDecrease(2);
    // Link
    effect eLink = EffectLinkEffects(eAC, eSave);

    // Apply the Dark Companion penalties.
    // Doesn't affect allies
    if (!GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
    }
}
