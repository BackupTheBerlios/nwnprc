//:://////////////////////////////////////////////
//:: FileName: "ss_ep_spellworm"
/*   Purpose: Spell Worm - the target loses one spell slot of his/her highest
        available level at the rate of 1 per round, for 20 hours, or until the
        target has no remaining spell slots available.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "inc_epicspells"

void RunWorm(object oTarget, int nRoundsRemaining);

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SP_WORM_DC, SP_WORM_S, SP_WORM_XP))
    {
        object oTarget = GetSpellTargetObject();
        int nDuration = FloatToInt(HoursToSeconds(20) / 6);
        int nSpellDC = GetEpicSpellSaveDC(OBJECT_SELF) +
            GetDCSchoolFocusAdjustment(OBJECT_SELF, SP_WORM_S);
        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_MIND);
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
            oTarget != OBJECT_SELF)
        {
            if (GetLocalInt(oTarget, "sSpellWormActive") != TRUE)
            {
                //Make SR check
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                {
                     //Make Will save
                     if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC,
                        SAVING_THROW_TYPE_MIND_SPELLS))
                     {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            eVis, oTarget);
                        SetLocalInt(oTarget, "sSpellWormActive", TRUE);
                        RunWorm(oTarget, nDuration);
                     }
                }
            }
        }
    }
}

void RunWorm(object oTarget, int nRoundsRemaining)
{
    int nSpell = GetBestAvailableSpell(oTarget);
    if (nSpell != 99999)
    {
        DecrementRemainingSpellUses(oTarget, nSpell);
        nRoundsRemaining -= 1;
    }
    if (nRoundsRemaining > 0)
        DelayCommand(6.0, RunWorm(oTarget, nRoundsRemaining));
    if (nSpell == 99999 || nRoundsRemaining < 1)
        SetLocalInt(oTarget, "sSpellWormActive", FALSE);
}
