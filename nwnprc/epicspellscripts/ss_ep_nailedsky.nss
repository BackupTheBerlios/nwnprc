//:://////////////////////////////////////////////
//:: FileName: "ss_ep_nailedsky"
/*   Purpose: Nailed to the Sky - the target, if it fails its Will save, is
        thrust into the sky, where is suffers from
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
//#include "x0_i0_petrify"
#include "x2_inc_spellhook"
#include "inc_epicspells"
//#include "prc_alterations"

void RunNailedToTheSky(object oTarget, int nDC);

void Petrify(object oTarget)
{
    effect ePetrify = EffectPetrify();
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePetrify, oTarget, 0.0, TRUE, -1, GetTotalCastingLevel(OBJECT_SELF), OBJECT_SELF);
}

void RemoveEffectOfType(object oTarget, int nEffectType)
{
    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff)) {
        if ( GetEffectType(eEff) == nEffectType) { 
            RemoveEffect(oTarget, eEff);
        }
        eEff = GetNextEffect(oTarget);
    }
}
// Removes the petrification effect.
void Depetrify(object oTarget)
{
    RemoveEffectOfType(oTarget, EFFECT_TYPE_PETRIFY);
}
    
void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    object oTarget = PRCGetSpellTargetObject();
    // HUMANOID SPELL ONLY!!!!
    if (AmIAHumanoid(oTarget))
    {
        if (GetCanCastSpell(OBJECT_SELF, NAILSKY_DC, NAILSKY_S, NAILSKY_XP))
        {
            //Declare major variables
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
            RunNailedToTheSky(oTarget, GetEpicSpellSaveDC(OBJECT_SELF, oTarget));
        }
    }
    else
    FloatingTextStringOnCreature
        ("*Invalid target for spell*", OBJECT_SELF, FALSE);
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

void RunNailedToTheSky(object oTarget, int nDC)
{
    effect eVis1 = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eDam = EffectDamage(d6(2));
    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC) && !GetIsDead(oTarget))
    {
        AssignCommand(oTarget, ClearAllActions(TRUE));
        AssignCommand(oTarget,
            ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 6.0));
        DelayCommand(0.2, AssignCommand(oTarget,
            ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 6.0)));
        DelayCommand(0.3, AssignCommand(oTarget,
            ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 6.0)));
        DelayCommand(0.4, AssignCommand(oTarget,
            ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 6.0)));
        DelayCommand(0.5, AssignCommand(oTarget,
            ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 6.0)));
        DelayCommand(0.6, AssignCommand(oTarget,
            ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 6.0)));
        DelayCommand(0.8, Petrify(oTarget));
        DelayCommand(6.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget));
        DelayCommand(6.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        DelayCommand(6.0, RunNailedToTheSky(oTarget, nDC));
    }
    else Depetrify(oTarget);
}
