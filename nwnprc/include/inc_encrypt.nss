string Encrypt(string sName)
{
    int nKey = GetPRCSwitch(PRC_CONVOCC_ENCRYPTION_KEY);
    string sReturn;
    int nLength = GetStringLength(sName);
    if(nLength == 0)
        return "";
    while(nLength < 500)
    {
        sName += sName;
        nLength = GetStringLength(sName);
    }
    sName = GetStringLeft(sName, 500);
    nLength = GetStringLength(sName);
    int nTest;
    while(GetStringLength(sReturn) < 10)
    {
        while(nTest < nLength)
        {
            string sTest = GetStringLeft(GetStringRight(sName, nTest), 1);
            if(sTest != " ")
                sReturn += sTest;
            nTest += nKey;
        }
        nTest = 0;
    }
    return sReturn;
}
