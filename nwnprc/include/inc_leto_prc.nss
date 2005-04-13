#include "inc_letocommands"
#include "inc_debug"
#include "inc_persist_loca"

void PRCLetoExit(object oPC)
{
    object oSkin = GetPCSkin(oPC);
    itemproperty ipTest = GetFirstItemProperty(oSkin);
    while(GetIsItemPropertyValid(ipTest))
    {
        int ipType = GetItemPropertyType(ipTest);
        if(ipType == ITEM_PROPERTY_ABILITY_BONUS)
        {
            int ipSubType = GetItemPropertySubType(ipTest);
            int ipValue = GetItemPropertyCostTableValue(ipTest);
            int nOldIpValue = GetLocalInt(oPC, "LetoAbility_"+IntToString(ipSubType));
            SetCampaignInt("LetoPRC", "LetoAbility_"+IntToString(ipSubType), ipValue, oPC);
            SetLocalString(oPC, "LetoScript", GetLocalString(oPC, "LetoScript")+AdjustAbility(ipSubType, ipValue-nOldIpValue));
        }
        ipTest = GetNextItemProperty(oSkin);
    }
}

void PRCLetoEnter(object oPC)
{
    int i;
    for(i=0;i<6;i++)
    {
        int nDBValue = GetCampaignInt("LetoPRC", "LetoAbility_"+IntToString(i), oPC);
        if(nDBValue != 0)
        {
            int nPersistValue = GetPersistantLocalInt(oPC, "LetoAbility_"+IntToString(i));
            SetPersistantLocalInt(oPC, "LetoAbility_"+IntToString(i), nPersistValue + nDBValue);
            DeleteCampaignVariable("LetoPRC", "LetoAbility_"+IntToString(i), oPC);
        }
    }
}
