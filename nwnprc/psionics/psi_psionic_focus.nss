#include "prc_inc_function"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    if (GetLocalInt(oSkin, "PsionicFocus") == 1)
    {
        SendMessageToPC(oPC, "You are already Psionically Focused.");
        return;
    }

    if ((GetHasFeat(FEAT_NARROW_MIND, oPC)) && (!(GetHasFeat(FEAT_COMBAT_MANIFESTATION, oPC))))
    {
        if (GetIsSkillSuccessful(oPC, SKILL_CONCENTRATION, 16))
        {
            SetLocalInt(oSkin, "PsionicFocus", 1);
            SendMessageToPC(oPC, "You are now Psionically Focused.");
            return;
        }
    }
    else if ((!(GetHasFeat(FEAT_NARROW_MIND, oPC))) && (GetHasFeat(FEAT_COMBAT_MANIFESTATION, oPC)))
    {
        if (GetIsSkillSuccessful(oPC, SKILL_CONCENTRATION, 24))
        {
            SetLocalInt(oSkin, "PsionicFocus", 1);
            SendMessageToPC(oPC, "You are now Psionically Focused.");
            return;
        }
    }
    else
    {
        if (GetIsSkillSuccessful(oPC, SKILL_CONCENTRATION, 20))
        {
            SetLocalInt(oSkin, "PsionicFocus", 1);
            SendMessageToPC(oPC, "You are now Psionically Focused.");
            return;
        }
    }

    SendMessageToPC(oPC, "Concentration check failed.  You are not Psionically Focused.");

}
 