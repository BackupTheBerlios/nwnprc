/*
    prc_craft_listen

    Script to be executed by generic listener

    By: Flaming_Sword
    Created: Aug 8, 2006
    Modified: Aug 8, 2006
*/

#include "prc_craft_inc"

void main()
{
    object oPC = GetLastSpeaker();
    string sString = GetMatchedSubstring(0);
    int nState = GetLocalInt(OBJECT_SELF, "PRC_CRAFT_LISTEN");
    if(DEBUG) DoDebug("prc_craft_listen: nState = " + IntToString(nState));
    switch(nState)
    {
        case 1:
        {
            SetName(GetLocalObject(OBJECT_SELF, "PRC_CRAFT_ITEM"), sString);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC);
            break;
        }
        //add more here
    }
    if(nState)
    {
        SetIsDestroyable(TRUE, FALSE, FALSE);
        DestroyObject(OBJECT_SELF);
    }
}