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
//#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "inc_epicspells"
//#include "prc_alterations"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, ORDER_R_DC, ORDER_R_S, ORDER_R_XP))
    {
        int nCasterLevel = GetTotalCastingLevel(OBJECT_SELF);
        int nSaveDC = GetEpicSpellSaveDC(OBJECT_SELF) + GetDCSchoolFocusAdjustment(OBJECT_SELF, ORDER_R_S);

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
                    if(!MyPRCResistSpell(OBJECT_SELF, oTarget, 0, fDelay))
                    {
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC + GetChangesToSaveDC(oTarget,OBJECT_SELF),
                            SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                        {
                            DelayCommand(fDelay, SPApplyEffectToObject
                                (DURATION_TYPE_TEMPORARY, eLink, oTarget,
                                fDuration, TRUE, -1, GetTotalCastingLevel(OBJECT_SELF)));
                        }
                    }
                }
                else
                    DelayCommand(fDelay, SPApplyEffectToObject
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
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

