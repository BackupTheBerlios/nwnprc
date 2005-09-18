//:://////////////////////////////////////////////
//:: Debug: Duplicate hide feat monitor
//:: prc_debug_hfeatm
//:://////////////////////////////////////////////
/** @file
    Checks if the PC has multiple instances of the
    same itempropertybonusfeat on their hide.

    @author Ornedan
    @date   Created - 2005.9.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_utility"


void Recurse(object oPC, object oSkin)
{
    itemproperty ip = GetNextItemProperty(oSkin);
    if(!GetIsItemPropertyValid(ip))
        return;

    int bFeat = GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT;
    string sLocal;
    if(bFeat)
        if(!GetLocalInt(oPC, (sLocal = "prc_debug_hfeatm_" + IntToString(GetItemPropertySubType(ip)))))
            SetLocalInt(oPC, sLocal, TRUE);
        else
            DoDebug("prc_debug_hfeatm: Duplicate bonus feat on the hide: " + IntToString(GetItemPropertySubType(ip)));
    // Test next ip
    Recurse(oPC, oSkin);
    // All ips checked, clean up
    if(bFeat)
        DeleteLocalInt(oPC, sLocal);
}

void main()
{if(DEBUG){ // To ensure the whole script gets considered dead code by compiler when DEBUG is turned off
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    itemproperty ip = GetFirstItemProperty(oSkin);
    if(!GetIsItemPropertyValid(ip))
        return;
    int bFeat = GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT;
    string sLocal;
    if(bFeat)
        SetLocalInt(oPC, (sLocal = "prc_debug_hfeatm_" + IntToString(GetItemPropertySubType(ip))), TRUE);
    // Test next ip
    Recurse(oPC, oSkin);
    // All ips checked, clean up
    if(bFeat)
        DeleteLocalInt(oPC, sLocal);
}}