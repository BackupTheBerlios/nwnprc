//:://////////////////////////////////////////////
//:: FileName: "ss_ep_thewitheri"
/*   Purpose: The Withering - over the course of 20 rounds (or unless saved vs),
        the target will lose 40 total ability points from any of STR, DEX or CON
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "inc_epicspells"
#include "x2_inc_spellhook"
#include "nw_i0_spells"
//#include "prc_alterations"

void DoWithering(object oTarget, int nDC, int nDuration);

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, THEWITH_DC, THEWITH_S, THEWITH_XP))
    {
        object oTarget = GetSpellTargetObject();
        int nDC = /*GetEpicSpellSaveDC(OBJECT_SELF) + */ GetChangesToSaveDC() +
            GetDCSchoolFocusAdjustment(OBJECT_SELF, THEWITH_S) + 10;
        int nDuration = 60; // Lasts 20 rounds, but fires thrice per round.
        effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget,
            EventSpellCastAt(OBJECT_SELF, SPELL_BESTOW_CURSE, FALSE));
        //Make SR Check
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget, 0))
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            DoWithering(oTarget, nDC, nDuration);
        }
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

void DoWithering(object oTarget, int nDC, int nDuration)
{
    int nX;
    int nAbil;
    effect eDown;
    //Make a Fort Save each time
    if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
    {
        // Lower one of either STR, DEX, or CON by 1 every 2 seconds
        nX = d3();
        if (nX == 1) nAbil = ABILITY_STRENGTH;
        if (nX == 2) nAbil = ABILITY_DEXTERITY;
        if (nX == 3) nAbil = ABILITY_CONSTITUTION;
        eDown = EffectAbilityDecrease(nAbil, 1);
        eDown = SupernaturalEffect(eDown);
        if (GetAbilityScore(oTarget, nAbil) > 3)
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDown, oTarget);
    }
    nDuration--;
    if (nDuration >= 1)
        DelayCommand(2.0, DoWithering(oTarget, nDC, nDuration));
}
