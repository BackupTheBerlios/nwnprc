/*
    prc_craft_listen

    Script to be executed by generic listener

    By: Flaming_Sword
    Created: Aug 8, 2006
    Modified: Sept 25, 2006
*/

#include "prc_craft_inc"

void main()
{
    object oPC = GetLastSpeaker();
    string sString = GetMatchedSubstring(0);
    int nState = GetLocalInt(OBJECT_SELF, PRC_CRAFT_LISTEN);
    if(DEBUG) DoDebug("prc_craft_listen: nState = " + IntToString(nState));
    object oItem = GetLocalObject(OBJECT_SELF, "PRC_CRAFT_ITEM");
    object oNewItem;
    object oTemp;
    int nBase = GetBaseItemType(oItem);
    //int nTemp;
    switch(nState)
    {
        case PRC_CRAFT_LISTEN_SETNAME:
        {
            SetName(oItem, sString);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC);
            break;
        }
        case PRC_CRAFT_LISTEN_SETAPPEARANCE:
        {
            int nModelType = StringToInt(Get2DACache("baseitems", "ModelType", nBase));
            PRCSetItemAppearance(oPC, oItem, sString);
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