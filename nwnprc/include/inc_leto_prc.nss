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
            string sPath = GetName(oPC);//GetLocalString(oPC, "Leto_Path");
            int nOldIpValue = GetPersistantLocalInt(oPC, "LetoAbility_"+IntToString(ipSubType));
            SetCampaignInt("LetoPRC", "LetoAbility_"+IntToString(ipSubType)+sPath, ipValue);
            SetLocalString(oPC, "LetoScript", GetLocalString(oPC, "LetoScript")+AdjustAbility(ipSubType, ipValue-nOldIpValue));
            PrintString(sPath);
            PrintString("LetoAbility_"+IntToString(ipSubType)+sPath);
            PrintString(IntToString(ipValue));
            PrintString(IntToString(nOldIpValue));
        }
        ipTest = GetNextItemProperty(oSkin);
    }
}

void PRCLetoEnter(object oPC)
{
    int i;
    string sPath = GetName(oPC);//GetLocalString(oPC, "Leto_Path");
    /*if(sPath == "")
    {
        sPath = GetBicPath(oPC);
        SetLocalString(oPC, "Leto_Path", sPath);
    }*/
    PrintString(sPath);
    for(i=0;i<6;i++)
    {
        PrintString("LetoAbility_"+IntToString(i)+sPath);
        int nDBValue = GetCampaignInt("LetoPRC", "LetoAbility_"+IntToString(i)+sPath);
        PrintString(IntToString(nDBValue));
        if(nDBValue)
        {
            int nPersistValue = GetPersistantLocalInt(oPC, "LetoAbility_"+IntToString(i));
            PrintString(IntToString(nPersistValue));
            SetPersistantLocalInt(oPC, "LetoAbility_"+IntToString(i), nPersistValue + nDBValue);
            DeleteCampaignVariable("LetoPRC", "LetoAbility_"+IntToString(i)+sPath);
        }
    }
}
