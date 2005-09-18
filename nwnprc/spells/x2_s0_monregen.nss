//::///////////////////////////////////////////////
//:: Monstrous Regeneration
//:: X2_S0_MonRegen
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants the selected target 3 HP of regeneration
    every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 09, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "x2_inc_spellhook"
#include "prc_alterations"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook


    object oTarget = PRCGetSpellTargetObject();

    /* Bug fix 21/07/03: Andrew. Lowered regen to 3 HP per round, instead of 10. */
    effect eRegen = EffectRegenerate(3, 6.0);

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eRegen, eDur);

    int nMeta = PRCGetMetaMagicFeat();
    int nLevel = (PRCGetCasterLevel(OBJECT_SELF) / 2) + 1;

    if (nMeta == METAMAGIC_EXTEND)
    {
        nLevel *= 2;
    }

    // Stacking Spellpass, 2003-07-07, Georg   ... just in case
    RemoveEffectsFromSpell(oTarget, GetSpellId());

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply effects and VFX
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nLevel));
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}
