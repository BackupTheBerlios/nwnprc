//:://////////////////////////////////////////////
//:: FileName: "ss_ep_transvital"
/*   Purpose: Transcendent Vitality - the target permanently gains 5 CON,
        immunity to poisons and disease, and regeneration.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "inc_utility"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_TRANVIT))
    {
        object oTarget = GetSpellTargetObject();

        object oSkin = GetPCSkin(oTarget);
        SetPersistantLocalInt(oTarget, "EpicSpell_TransVital", TRUE);
        ExecuteScript("trans_vital", oTarget);
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

