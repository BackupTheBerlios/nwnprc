string Encrypt(object oPC)
{
    string sName = GetName(oPC);
    int nKey = GetPRCSwitch(PRC_CONVOCC_ENCRYPTION_KEY);
    if(nKey == 0)
        nKey = 10;
    string sReturn;
    
    int nLastKey = GetCampaignInt("CCC_keys", "LastKey");
    int nPlayerKey = GetCampaignInt("CCC_keys", "PlayerKey", oPC);
    sReturn = IntToString(nKey*nPlayerKey);
    if(sReturn == "0")
    {
        nLastKey++;
        sReturn = IntToString(nKey*nLastKey);
        SetCampaignInt("CCC_keys", "PlayerKey", nLastKey, oPC);
        SetCampaignInt("CCC_keys", "LastKey", nLastKey);
    }

    return sReturn;
}
