//:://////////////////////////////////////////////
//:: FileName: "ss_ep_psionicsal"
/*   Purpose: Psionic Salvo - subject loses WIS and INT until both are at 3, or
        until the subject makes a Will saving throw.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "inc_epicspells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"

void DoSalvo(object oTarget, int nDC);

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, PSION_S_DC, PSION_S_S, PSION_S_XP))
    {
        object oTarget = GetSpellTargetObject();
        int nDC = GetEpicSpellSaveDC(OBJECT_SELF) +
            GetDCSchoolFocusAdjustment(OBJECT_SELF, PSION_S_S);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget,
            EventSpellCastAt(OBJECT_SELF, SPELL_BESTOW_CURSE, FALSE));
        //Make SR Check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
            DoSalvo(oTarget, nDC);
        }
    }
}

void DoSalvo(object oTarget, int nDC)
{
    //Make a Will save each time
    if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
    {
        effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
        effect eWIS = EffectAbilityDecrease(ABILITY_WISDOM, 1);
        effect eINT = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 1);
        eWIS = EffectLinkEffects(eWIS, eVis);
        eINT = EffectLinkEffects(eINT, eVis);
        eWIS = SupernaturalEffect(eWIS);
        eINT = SupernaturalEffect(eINT);
        if (GetAbilityScore(oTarget, ABILITY_WISDOM) > 3)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWIS, oTarget);
        if (GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) > 3)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eINT, oTarget);
        if (GetAbilityScore(oTarget, ABILITY_WISDOM) > 3 ||
            GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) > 3)
            DelayCommand(6.0, DoSalvo(oTarget, nDC));
    }
}
