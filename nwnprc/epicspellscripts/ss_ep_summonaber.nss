//:://////////////////////////////////////////////
//:: FileName: "ss_ep_summonaber"
/*   Purpose: Summon Aberration - summons a semi-random aberration for 20 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "inc_utility"
void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_SUMABER))
    {
        effect eSummon;
        float fDuration = HoursToSeconds(20);
        int nX = d10();
        switch (nX)
        {
            case 1:
            case 2:
            case 3: eSummon = EffectSummonCreature("ep_summonaberat1",496,1.0f);
                    break;
            case 4:
            case 5:
            case 6: eSummon = EffectSummonCreature("ep_summonaberat2",496,1.0f);
                    break;
            case 7:
            case 8: eSummon = EffectSummonCreature("ep_summonaberat3",496,1.0f);
                    break;
            case 9: eSummon = EffectSummonCreature("ep_summonaberat4",496,1.0f);
                    break;
            case 10: eSummon = EffectSummonCreature("ep_summonaberat5",496,1.0f);
        }
        eSummon = ExtraordinaryEffect(eSummon);
        //Apply the summon visual and summon the aberration.
        MultisummonPreSummon();
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon,
            PRCGetSpellTargetLocation(), fDuration);
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}


