//:://////////////////////////////////////////////
//:: FileName: "ss_ep_orderresto"
/*   Purpose: Order Restored - all unlawful targets are stunned, and all
        lawful targets get 5 attacks per round and +10 saves vs. chaos.
     Unlawful casters have alignment shift to law by d10, and spell fails.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "inc_epicspells"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, ORDER_R_DC, ORDER_R_S, ORDER_R_XP))
    {
        int nCasterLevel = GetTotalCastingLevel(OBJECT_SELF);
        int nSaveDC = GetEpicSpellSaveDC(OBJECT_SELF) +
            GetDCSchoolFocusAdjustment(OBJECT_SELF, ORDER_R_S);
        float fDuration = RoundsToSeconds(20);
        effect eVis = EffectVisualEffect(VFX_FNF_HOWL_ODD);
        effect eStun = EffectStunned();
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eAtt = EffectModifyAttacks(5);
        effect eST = EffectSavingThrowIncrease(SAVING_THROW_ALL, 10,
            SAVING_THROW_TYPE_CHAOS);
        effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eVis, eStun);
        eLink = EffectLinkEffects(eLink, eDur);
        effect eLink2 = EffectLinkEffects(eAtt, eVis);
        eLink2 = EffectLinkEffects(eLink2, eDur2);
        eLink2 = EffectLinkEffects(eLink2, eST);
        float fDelay;
        // Lawful casters cast normally. All others go to ELSE.
        if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL)
        {
            object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
                RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
            while(GetIsObjectValid(oTarget))
            {
                fDelay = GetRandomDelay();
                if (GetAlignmentLawChaos(oTarget) != ALIGNMENT_LAWFUL)
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                        SPELL_CONFUSION));
                    if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                    {
                        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC,
                            SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                        {
                            DelayCommand(fDelay, ApplyEffectToObject
                                (DURATION_TYPE_TEMPORARY, eLink, oTarget,
                                fDuration));
                        }
                    }
                }
                else
                    DelayCommand(fDelay, ApplyEffectToObject
                        (DURATION_TYPE_TEMPORARY, eLink2, oTarget, fDuration));

                oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                    RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
            }
        }
        else // An unlawful caster will sway towards law on a casting.
        {
            FloatingTextStringOnCreature("*Spell fails. You are not lawful*",
                OBJECT_SELF, FALSE);
            AdjustAlignment(OBJECT_SELF, ALIGNMENT_LAWFUL, d10());
        }
    }
}

