//::///////////////////////////////////////////////
//:: Epic Mage Armor
//:: X2_S2_EpMageArm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the target +20 AC Bonus to Deflection,
    Armor Enchantment, Natural Armor and Dodge.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////

/*
    Altered by Boneshank, for purposes of the Epic Spellcasting project.
*/

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "inc_epicspells"
//#include "prc_alterations"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, EP_M_AR_DC, EP_M_AR_S, EP_M_AR_XP))
    {
        object oTarget = GetSpellTargetObject();
        int nDuration = GetTotalCastingLevel(OBJECT_SELF);
        effect eVis = EffectVisualEffect(495);
        effect eAC1, eAC2, eAC3, eAC4;
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        //Set the four unique armor bonuses
        eAC1 = EffectACIncrease(5, AC_ARMOUR_ENCHANTMENT_BONUS);
        eAC2 = EffectACIncrease(5, AC_DEFLECTION_BONUS);
        eAC3 = EffectACIncrease(5, AC_DODGE_BONUS);
        eAC4 = EffectACIncrease(5, AC_NATURAL_BONUS);
        effect eDur = EffectVisualEffect(VFX_DUR_SANCTUARY);

        effect eLink = EffectLinkEffects(eAC1, eAC2);
        eLink = EffectLinkEffects(eLink, eAC3);
        eLink = EffectLinkEffects(eLink, eAC4);
        eLink = EffectLinkEffects(eLink, eDur);

        RemoveEffectsFromSpell(oTarget, GetSpellId());

        // * Brent, Nov 24, making extraodinary so cannot be dispelled
        eLink = ExtraordinaryEffect(eLink);

        //Apply the armor bonuses and the VFX impact
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,1.0);
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
