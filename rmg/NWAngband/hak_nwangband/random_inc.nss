const string RANDOM_2DA_SEED = "Random2DASeed";

int GetIsResultRun()
{
    return GetLocalInt(GetModule(), "RandomResultRun");
}

int CheckedStringToInt(string sString)
{
    string sIn = sString;
    string sResult;
    while(GetStringLength(sString))
    {
        string sTest = GetStringLeft(sString, 1);
        if(sTest == "0" || sTest == "1"
            || sTest == "2" || sTest == "3"
            || sTest == "4" || sTest == "5"
            || sTest == "6" || sTest == "7"
            || sTest == "8" || sTest == "9")
            sResult += sTest;
        sString = GetStringRight(sString, GetStringLength(sString)-1);
    }
    int nResult = StringToInt(sResult);
//DoDebug("CheckedStringToInt("+sIn+") = "+sResult);
    return nResult;
}

//s2DA    = 2da file to read from
//sScript = script name to test with
//nSeed   = row to start at
//returns the value from the random row selected
string GetRandomFrom2DA(string s2DA, string sScript = "random_default", int nSeed = 0);

//private function
//sScript = script name to test with
//s2DA    = 2da file to read from
//nRow    = row in 2da file to use
//nColumn = column in 2da file to use
int GetRandomWeight(string sScript, string s2DA, int nRow, int nColumn)
{
    string sWeight = Get2DACache(s2DA, "Random"+IntToString(nColumn)+"Weight", nRow);
    int nWeight = CheckedStringToInt(sWeight);
    if(GetStringLeft(sWeight, 1) == "s")
    {
        SetLocalInt(OBJECT_SELF, RANDOM_2DA_SEED, nWeight);
        ExecuteScript(sScript, OBJECT_SELF);
        nWeight = GetLocalInt(OBJECT_SELF, RANDOM_2DA_SEED);
    }
    return nWeight;
}

string GetRandomFrom2DA(string s2DA, string sScript = "random_default", int nSeed = 0)
{
    int nRow;
    string sReturn;
    string sRandom0, sRandom1, sRandom2, sRandom3,
           sRandom4, sRandom5, sRandom6, sRandom7,
           sRandom8, sRandom9;
    int nRandom0, nRandom1, nRandom2, nRandom3,
        nRandom4, nRandom5, nRandom6, nRandom7,
        nRandom8, nRandom9;
    int nRandom0Weight, nRandom1Weight, nRandom2Weight, nRandom3Weight,
        nRandom4Weight, nRandom5Weight, nRandom6Weight, nRandom7Weight,
        nRandom8Weight, nRandom9Weight;
    string sWeight;
    nRow = nSeed;

//DoDebug("GetRandomFrom2DA("+s2DA+", "+IntToString(nSeed)+")");
    while(sReturn == "")
    {
//DoDebug("random_inc line 66");
        sRandom0 = Get2DACache(s2DA, "Random0", nRow);
        sRandom1 = Get2DACache(s2DA, "Random1", nRow);
        sRandom2 = Get2DACache(s2DA, "Random2", nRow);
        sRandom3 = Get2DACache(s2DA, "Random3", nRow);
        sRandom4 = Get2DACache(s2DA, "Random4", nRow);
        sRandom5 = Get2DACache(s2DA, "Random5", nRow);
        sRandom6 = Get2DACache(s2DA, "Random6", nRow);
        sRandom7 = Get2DACache(s2DA, "Random7", nRow);
        sRandom8 = Get2DACache(s2DA, "Random8", nRow);
        sRandom9 = Get2DACache(s2DA, "Random9", nRow);
        nRandom0 = CheckedStringToInt(sRandom0);
        nRandom1 = CheckedStringToInt(sRandom1);
        nRandom2 = CheckedStringToInt(sRandom2);
        nRandom3 = CheckedStringToInt(sRandom3);
        nRandom4 = CheckedStringToInt(sRandom4);
        nRandom5 = CheckedStringToInt(sRandom5);
        nRandom6 = CheckedStringToInt(sRandom6);
        nRandom7 = CheckedStringToInt(sRandom7);
        nRandom8 = CheckedStringToInt(sRandom8);
        nRandom9 = CheckedStringToInt(sRandom9);
        nRandom0Weight = GetRandomWeight(sScript, s2DA, nRow, 0);
        nRandom1Weight = GetRandomWeight(sScript, s2DA, nRow, 1);
        nRandom2Weight = GetRandomWeight(sScript, s2DA, nRow, 2);
        nRandom3Weight = GetRandomWeight(sScript, s2DA, nRow, 3);
        nRandom4Weight = GetRandomWeight(sScript, s2DA, nRow, 4);
        nRandom5Weight = GetRandomWeight(sScript, s2DA, nRow, 5);
        nRandom6Weight = GetRandomWeight(sScript, s2DA, nRow, 6);
        nRandom7Weight = GetRandomWeight(sScript, s2DA, nRow, 7);
        nRandom8Weight = GetRandomWeight(sScript, s2DA, nRow, 8);
        nRandom9Weight = GetRandomWeight(sScript, s2DA, nRow, 9);
        //sanity check
        if(nRandom0 == 0
            && nRandom0Weight == 0
            && sReturn == "")
            return "";
        //get total weight
        int nRandomWeightTotal;
        nRandomWeightTotal += nRandom0Weight;
        nRandomWeightTotal += nRandom1Weight;
        nRandomWeightTotal += nRandom2Weight;
        nRandomWeightTotal += nRandom3Weight;
        nRandomWeightTotal += nRandom4Weight;
        nRandomWeightTotal += nRandom5Weight;
        nRandomWeightTotal += nRandom6Weight;
        nRandomWeightTotal += nRandom7Weight;
        nRandomWeightTotal += nRandom8Weight;
        nRandomWeightTotal += nRandom9Weight;
        //get a random point in that weight
        int nRandomWeight = RandomI(nRandomWeightTotal);
        //keep adding up untill you reach the point picked
        if(nRandomWeight < nRandom0Weight)
        {
            SetLocalInt(GetModule(), "RandomResultRun", TRUE);
            GetRandomWeight(sScript, s2DA, nRow, 0);
            DeleteLocalInt(GetModule(), "RandomResultRun");
            if(GetStringLeft(sRandom0, 1) == "r")
                sReturn = sRandom0;
            nRow = nRandom0;
        }
        else if(nRandomWeight < nRandom0Weight+nRandom1Weight)
        {
            SetLocalInt(GetModule(), "RandomResultRun", TRUE);
            GetRandomWeight(sScript, s2DA, nRow, 1);
            DeleteLocalInt(GetModule(), "RandomResultRun");
            if(GetStringLeft(sRandom1, 1) == "r")
                sReturn = sRandom1;
            nRow = nRandom1;
        }
        else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight)
        {
            SetLocalInt(GetModule(), "RandomResultRun", TRUE);
            GetRandomWeight(sScript, s2DA, nRow, 2);
            DeleteLocalInt(GetModule(), "RandomResultRun");
            if(GetStringLeft(sRandom2, 1) == "r")
                sReturn = sRandom2;
            nRow = nRandom2;
        }
        else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight+nRandom3Weight)
        {
            SetLocalInt(GetModule(), "RandomResultRun", TRUE);
            GetRandomWeight(sScript, s2DA, nRow, 3);
            DeleteLocalInt(GetModule(), "RandomResultRun");
            if(GetStringLeft(sRandom3, 1) == "r")
                sReturn = sRandom3;
            nRow = nRandom3;
        }
        else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight+nRandom3Weight+nRandom4Weight)
        {
            SetLocalInt(GetModule(), "RandomResultRun", TRUE);
            GetRandomWeight(sScript, s2DA, nRow, 4);
            DeleteLocalInt(GetModule(), "RandomResultRun");
            if(GetStringLeft(sRandom4, 1) == "r")
                sReturn = sRandom4;
            nRow = nRandom4;
        }
        else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight+nRandom3Weight+nRandom4Weight+nRandom5Weight)
        {
            SetLocalInt(GetModule(), "RandomResultRun", TRUE);
            GetRandomWeight(sScript, s2DA, nRow, 5);
            DeleteLocalInt(GetModule(), "RandomResultRun");
            if(GetStringLeft(sRandom5, 1) == "r")
                sReturn = sRandom5;
            nRow = nRandom5;
        }
        else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight+nRandom3Weight+nRandom4Weight+nRandom5Weight+nRandom6Weight)
        {
            SetLocalInt(GetModule(), "RandomResultRun", TRUE);
            GetRandomWeight(sScript, s2DA, nRow, 6);
            DeleteLocalInt(GetModule(), "RandomResultRun");
            if(GetStringLeft(sRandom6, 1) == "r")
                sReturn = sRandom6;
            nRow = nRandom6;
        }
        else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight+nRandom3Weight+nRandom4Weight+nRandom5Weight+nRandom6Weight+nRandom7Weight)
        {
            SetLocalInt(GetModule(), "RandomResultRun", TRUE);
            GetRandomWeight(sScript, s2DA, nRow, 7);
            DeleteLocalInt(GetModule(), "RandomResultRun");
            if(GetStringLeft(sRandom7, 1) == "r")
                sReturn = sRandom7;
            nRow = nRandom7;
        }
        else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight+nRandom3Weight+nRandom4Weight+nRandom5Weight+nRandom6Weight+nRandom7Weight+nRandom8Weight)
        {
            SetLocalInt(GetModule(), "RandomResultRun", TRUE);
            GetRandomWeight(sScript, s2DA, nRow, 8);
            DeleteLocalInt(GetModule(), "RandomResultRun");
            if(GetStringLeft(sRandom8, 1) == "r")
                sReturn = sRandom8;
            nRow = nRandom8;
        }
        else
        {
            SetLocalInt(GetModule(), "RandomResultRun", TRUE);
            GetRandomWeight(sScript, s2DA, nRow, 9);
            DeleteLocalInt(GetModule(), "RandomResultRun");
            if(GetStringLeft(sRandom9, 1) == "r")
                sReturn = sRandom9;
            nRow = nRandom9;
        }
/*
if(nRandom0Weight > 0) DoDebug("weight: "+IntToString(nRandom0Weight)+" : "+IntToString(nRandom0));
if(nRandom1Weight > 0) DoDebug("weight: "+IntToString(nRandom1Weight)+" : "+IntToString(nRandom1));
if(nRandom2Weight > 0) DoDebug("weight: "+IntToString(nRandom2Weight)+" : "+IntToString(nRandom2));
if(nRandom3Weight > 0) DoDebug("weight: "+IntToString(nRandom3Weight)+" : "+IntToString(nRandom3));
if(nRandom4Weight > 0) DoDebug("weight: "+IntToString(nRandom4Weight)+" : "+IntToString(nRandom4));
if(nRandom5Weight > 0) DoDebug("weight: "+IntToString(nRandom5Weight)+" : "+IntToString(nRandom5));
if(nRandom6Weight > 0) DoDebug("weight: "+IntToString(nRandom6Weight)+" : "+IntToString(nRandom6));
if(nRandom7Weight > 0) DoDebug("weight: "+IntToString(nRandom7Weight)+" : "+IntToString(nRandom7));
if(nRandom8Weight > 0) DoDebug("weight: "+IntToString(nRandom8Weight)+" : "+IntToString(nRandom8));
if(nRandom9Weight > 0) DoDebug("weight: "+IntToString(nRandom9Weight)+" : "+IntToString(nRandom9));
DoDebug("nRow is "+IntToString(nRow));
*/
    }
    if(GetStringLeft(sReturn, 1) == "r")
        sReturn = GetStringRight(sReturn, GetStringLength(sReturn)-1);
//DoDebug("returning "+sReturn);
    return sReturn;
}
