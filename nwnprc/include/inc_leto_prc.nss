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
            //PrintString(sPath);
            //PrintString("LetoAbility_"+IntToString(ipSubType)+sPath);
            //PrintString(IntToString(ipValue));
            //PrintString(IntToString(nOldIpValue));
        }
        ipTest = GetNextItemProperty(oSkin);
    }
    
    if(GetPRCSwitch(PRC_PNP_SPELL_SCHOOLS)
        && GetLevelByClass(CLASS_TYPE_WIZARD, oPC))
    {
        if(GetHasFeat(2274)
            || GetHasFeat(2276)
            || GetHasFeat(2277)
            || GetHasFeat(2278)
            || GetHasFeat(2279)
            || GetHasFeat(2280)
            || GetHasFeat(2281))
        {
            //set school to PnP school
            string sScript;
            sScript = "<for:field /ClassList><if:~/Class=10><gff:set ~/School '9'></if></for>";
            SetLocalString(oPC, "LetoScript", GetLocalString(oPC, "LetoScript")+sScript);
        }
        else if(GetHasFeat(2273))
        {
            //set school to generalist
            string sScript;
            sScript = "<for:field /ClassList><if:~/Class=10><gff:set ~/School '0'></if></for>";
            SetLocalString(oPC, "LetoScript", GetLocalString(oPC, "LetoScript")+sScript);
        }
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
    //PrintString(sPath);
    for(i=0;i<6;i++)
    {
        //PrintString("LetoAbility_"+IntToString(i)+sPath);
        int nDBValue = GetCampaignInt("LetoPRC", "LetoAbility_"+IntToString(i)+sPath);
        //PrintString(IntToString(nDBValue));
        if(nDBValue)
        {
            int nPersistValue = GetPersistantLocalInt(oPC, "LetoAbility_"+IntToString(i));
            //PrintString(IntToString(nPersistValue));
            SetPersistantLocalInt(oPC, "LetoAbility_"+IntToString(i), nPersistValue + nDBValue);
            DeleteCampaignVariable("LetoPRC", "LetoAbility_"+IntToString(i)+sPath);
        }
    }
}
