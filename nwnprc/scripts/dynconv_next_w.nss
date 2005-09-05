#include "inc_utility"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nOffset = GetLocalInt(oPC, "ChoiceOffset");
    if(nOffset+10 <= array_get_size(oPC, "ChoiceTokens"))
        return TRUE;
    else
        return FALSE;
}

