//:://////////////////////////////////////////////
//:: FileName: "ss_ep_nailedsky"
/*   Purpose: Nailed to the Sky - the target, if it fails its Will save, is
        thrust into the sky, where is suffers from
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////

#include "x2_I0_SPELLS"
#include "x0_i0_petrify"
#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "prc_alterations"

void RunNailedToTheSky(object oTarget, int nDC);

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    object oTarget = GetSpellTargetObject();
    // HUMANOID SPELL ONLY!!!!
    if (AmIAHumanoid(oTarget))
    {
        if (GetCanCastSpell(OBJECT_SELF, NAILSKY_DC, NAILSKY_S, NAILSKY_XP))
        {
            //Declare major variables
            int nSpellDC = GetEpicSpellSaveDC(OBJECT_SELF) + GetChangesToSaveDC() +
                GetDCSchoolFocusAdjustment(OBJECT_SELF, NAILSKY_S);
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            RunNailedToTheSky(oTarget, nSpellDC);
        }
    }
    else
    FloatingTextStringOnCreature
        ("*Invalid target for spell*", OBJECT_SELF, FALSE);
}

void RunNailedToTheSky(object oTarget, int nDC)
{
    effect eVis1 = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eDam = EffectDamage(d6(2));
    if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC) && !GetIsDead(oTarget))
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
        DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget));
        DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        DelayCommand(6.0, RunNailedToTheSky(oTarget, nDC));
    }
    else Depetrify(oTarget);
}
