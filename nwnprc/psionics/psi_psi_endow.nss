#include "prc_inc_function"
#include "inc_item_props"
#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    if (GetLocalInt(oPC, "PsionicFocus") == 0)
    {
        SendMessageToPC(oPC, "You must be psionically focused to use this feat.");
        return;
    }

    SetLocalInt(oPC, "PsionicFocus", 0);
    SetLocalInt(oPC, "PsionicEndowment", 1);
}