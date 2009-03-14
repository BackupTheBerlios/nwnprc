//::///////////////////////////////////////////////
//:: Blinding Beauty Enter
//:: race_blindbeauta.nss
//::///////////////////////////////////////////////
/*
    Handles creatures entering the Aura AoE for
    Blinding Beauty
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 27, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oTarget = GetEnteringObject();
    object oNymph = GetAreaOfEffectCreator();

    int nDC = 13 + GetAbilityModifier(ABILITY_CHARISMA, oNymph);

    if(!GetIsReactionTypeFriendly(oTarget, oNymph))
    {
        //don't blind self :P
        if(oTarget == oNymph)
            return;
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oNymph, SPELL_NYMPH_BLINDING_BEAUTY));
        //Make Fort Save to negate effect
        if (!/*Fort Save*/ PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        {
                 effect eBlind   = SupernaturalEffect(EffectBlindness());
                 effect eVis     = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlind, oTarget);
        }

    }
}
