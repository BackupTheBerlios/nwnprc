/** @file
 * Caching 2da read function and related.
 *
 * @author Primogenitor
 *
 * @todo Document the constants and functions
 */

const int PRC_SQL_ERROR = 0;
const int PRC_SQL_SUCCESS = 1;

const int DEBUG_GET2DACACHE = FALSE;

string Get2DACache(string s2DA, string sColumn, int nRow, string s = "");

string GetBiowareDBName();

void PRC_SQLInit();
void PRC_SQLExecDirect(string sSQL);
int PRC_SQLFetch();
string PRC_SQLGetData(int iCol);
void PRC_SQLCommit();
string PRC_SQLGetTick();

// Problems can arise with SQL commands if variables or values have single quotes
// in their names. These functions are a replace these quote with the tilde character
string ReplaceSingleChars(string sString, string sTarget, string sReplace);


//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

#include "inc_debug"
#include "prc_inc_switch"

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void PRC_SQLCommit()
{
    int nInterval = GetPRCSwitch(PRC_DB_SQLLITE_INTERVAL);
    if(nInterval == 0)
        nInterval = 600;
    float fDelay = IntToFloat(nInterval);
    DelayCommand(fDelay, PRC_SQLCommit());
    string SQL = "COMMIT";
    PRC_SQLExecDirect(SQL);
    SQL = "BEGIN IMMEDIATE";
    PRC_SQLExecDirect(SQL);
}

void PRC_SQLInit()
{
    int i;

    // Placeholder for ODBC persistence
    string sMemory;

    for (i = 0; i < 8; i++)     // reserve 8*128 bytes
        sMemory +=
            "................................................................................................................................";

    SetLocalString(GetModule(), "NWNX!ODBC!SPACER", sMemory);
}

void PRC_SQLExecDirect(string sSQL)
{
//PrintString(sSQL);
    SetLocalString(GetModule(), "NWNX!ODBC!EXEC", sSQL);
}

int PRC_SQLFetch()
{
    string sRow;
    object oModule = GetModule();

    SetLocalString(oModule, "NWNX!ODBC!FETCH", GetLocalString(oModule, "NWNX!ODBC!SPACER"));
    sRow = GetLocalString(oModule, "NWNX!ODBC!FETCH");
    if (GetStringLength(sRow) > 0)
    {
        SetLocalString(oModule, "NWNX_ODBC_CurrentRow", sRow);
        return PRC_SQL_SUCCESS;
    }
    else
    {
        SetLocalString(oModule, "NWNX_ODBC_CurrentRow", "");
        return PRC_SQL_ERROR;
    }
}

string PRC_SQLGetTick()
{
    string sTick;
    if(GetPRCSwitch(PRC_DB_SQLLITE))
        sTick = "";
    else
        sTick = "`";
    return sTick;
}

string PRC_SQLGetData(int iCol)
{
    int iPos;
    string sResultSet = GetLocalString(GetModule(), "NWNX_ODBC_CurrentRow");

    // find column in current row
    int iCount = 0;
    string sColValue = "";

    iPos = FindSubString(sResultSet, "¬");
    if ((iPos == -1) && (iCol == 1))
    {
        // only one column, return value immediately
        sColValue = sResultSet;
    }
    else if (iPos == -1)
    {
        // only one column but requested column > 1
        sColValue = "";
    }
    else
    {
        // loop through columns until found
        while (iCount != iCol)
        {
            iCount++;
            if (iCount == iCol)
                sColValue = GetStringLeft(sResultSet, iPos);
            else
            {
                sResultSet = GetStringRight(sResultSet, GetStringLength(sResultSet) - iPos - 1);
                iPos = FindSubString(sResultSet, "¬");
            }

            // special case: last column in row
            if (iPos == -1)
                iPos = GetStringLength(sResultSet);
        }
    }

    return sColValue;
}


string ReplaceSingleChars(string sString, string sTarget, string sReplace)
{
    if (FindSubString(sString, sTarget) == -1) // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == sTarget)
            sReturn += sReplace;
        else
            sReturn += sChar;
    }
    return sReturn;
}


void PreCache(string s2DA, string sColumn, int nRow, string sValue)
{
    Get2DACache(s2DA, sColumn, nRow, sValue);
}

/*
This is fugly and long. Should maybe be refactored to multiple functions. But everything inline does give
a few less instructions used.

Caching behaviours
1)      Tokens in creature inventory
2)      Direct to BiowareDB
3)      Direct to MySQL DB
*/
string Get2DACache(string s2DA, string sColumn, int nRow, string s = "")
{
    object oFileWP;
    int nNotWPCached = FALSE;
    int nNotBiowareCached = FALSE;
    int nNotNWNXCached = FALSE;
    int bUseCreature   = !GetPRCSwitch(PRC_2DA_CACHE_IN_CREATURE);
    int bUseBiowareDB  = GetPRCSwitch(PRC_2DA_CACHE_IN_BIOWAREDB);
    int bUseNWNDB      = GetPRCSwitch(PRC_2DA_CACHE_IN_NWNXDB);

    //if a value is pushed in, store in all dbs
    if(s != "")
    {
        nNotWPCached = TRUE;
        nNotBiowareCached = TRUE;
        nNotNWNXCached = TRUE;
    }

    //lower case the 2da and column
    s2DA = GetStringLowerCase(s2DA);
    sColumn = GetStringLowerCase(sColumn);

    if (s == "" && bUseCreature)
    {
        //get the chest that contains the cache
        object oCacheWP = GetObjectByTag("Bioware2DACache");
        //if no chest, use HEARTOFCHAOS in limbo as a location to make a new one
        if (!GetIsObjectValid(oCacheWP))
        {
            if(DEBUG_GET2DACACHE) DoDebug("Get2DACache: Cache container creature does not exist, creating new one");
            //oCacheWP = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_chest2",
            //    GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, "Bioware2DACache");
            //has to be a creature, placeables cant go through the DB
            oCacheWP = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache",
                                    GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, "Bioware2DACache");
        }

        //get the token for this file
        string sFileWPName = s2DA + "_" + sColumn + "_" + IntToString(nRow / 1000);
        //string sFileWPName = "Bio2DACacheToken_" + GetSubString(GetStringUpperCase(s2DA), 0, 1);
        //if(DEBUG_GET2DACACHE) DoDebug("Get2DACache: Token tag is " + sFileWPName);
        oFileWP = GetObjectByTag(sFileWPName);
        //token doesnt exist make it
        if(!GetIsObjectValid(oFileWP))
        {
            if(DEBUG_GET2DACACHE) DoDebug("Get2DACache: Token does not exist, creating new one");

            // Use containers to avoid running out of inventory space
            int nContainer = 0;
            string sContainerName = "Bio2DACacheTokenContainer_" + GetSubString(s2DA, 0, 1) + "_";
            object oContainer     = GetObjectByTag(sContainerName + IntToString(nContainer));

            // Find last existing container
            if(GetIsObjectValid(oContainer))
            {
                if(DEBUG_GET2DACACHE) DoDebug("Get2DACache: Seeking last container in series: " + sContainerName);
                for(;;) // Infinite loop until we hit an non-existent container
                {
                    nContainer++;
                    object oTemp = GetObjectByTag(sContainerName + IntToString(nContainer));
                    if(!GetIsObjectValid(oTemp))
                        break;
                    else
                        oContainer = oTemp;
                }

                if(DEBUG_GET2DACACHE) DoDebug("Get2DACache: Found: " + DebugObject2Str(oContainer));

                // Make sure it's not full
                /*
                if(GetIsObjectValid(oContainer))
                {
                    int nNumItems = 0;
                    object oTest = GetFirstItemInInventory(oContainer);
                    while(GetIsObjectValid(oTest))
                    {
                        nNumItems++;
                        oTest = GetNextItemInInventory(oContainer);
                    }
                    if(nNumItems > (35 - 5)) // 35 is max number of items that can fit in one container page. Try to not fill containers completely in order to avoid accidentall overfills
                        oContainer = OBJECT_INVALID;
                }
                */
                if(GetIsObjectValid(oContainer) && (GetLocalInt(oContainer, "NumTokensInside") >= 34)) // Container has 35 slots. Attempt to not use them all, just in case
                {
                    if(DEBUG_GET2DACACHE) DoDebug("Get2DACache: Container full: " + DebugObject2Str(oContainer));
                    oContainer = OBJECT_INVALID;
                }
            }
            // We need to create a container
            if(!GetIsObjectValid(oContainer))
            {
                if(DEBUG_GET2DACACHE) DoDebug("Get2DACache: Creating new container");

                oContainer = CreateObject(OBJECT_TYPE_ITEM, "nw_it_contain001", GetLocation(oCacheWP), FALSE, sContainerName + IntToString(nContainer));
                DestroyObject(oContainer);
                oContainer = CopyObject(oContainer, GetLocation(oCacheWP), oCacheWP, sContainerName + IntToString(nContainer));
            }

            if(DEBUG_GET2DACACHE) DoDebug("Get2DACache: Using container: " + DebugObject2Str(oContainer));

            // Create the new token
            /*oFileWP = CreateObject(OBJECT_TYPE_ITEM, "hidetoken", GetLocation(oCacheWP), FALSE, sFileWPName);
            DestroyObject(oFileWP);
            oFileWP = CopyObject(oFileWP, GetLocation(oCacheWP), oCacheWP, sFileWPName);*/
            oFileWP = CreateItemOnObject("hidetoken", oContainer, 1, sFileWPName);

            //SetName(oFileWP, "2da Cache - " + sFileWPName);

            // Increment token count tracking variable
            SetLocalInt(oContainer, "NumTokensInside", GetLocalInt(oContainer, "NumTokensInside") + 1);
        }

        //store to check if pushed in
        if(s == "")
            s = GetLocalString(oFileWP, s2DA+"|"+sColumn+"|"+IntToString(nRow));
        if(s == "") {
            nNotWPCached = TRUE;
            if(DEBUG_GET2DACACHE) DoDebug("Get2DACache: Missing from cache: " + s2DA + "|" + sColumn + "|" + IntToString(nRow));
        }
    }

    //if(DEBUG_GET2DACACHE) DoDebug("Get2DACache: Live cached value is '" + s + "'");


    //sColumn = ReplaceChars(sColumn, "_" , "z");
    string sDBColumn = sColumn;

    //if its not locally cached already
    //check if we should use the database
    if (s == "" && bUseNWNDB)
    {
        string q = PRC_SQLGetTick();
        string SQL;

        if(s2DA == "feat"
            || s2DA == "spells"
            || s2DA == "portraits"
            || s2DA == "soundsets"
            || s2DA == "appearance"
            || s2DA == "classes"
            || s2DA == "racialtypes"
            || s2DA == "item_to_ireq")
            SQL = "SELECT "+q+""+sDBColumn+""+q+" FROM "+q+"prc_cached2da_"+s2DA+""+q+" WHERE ( "+q+"rowid"+q+" = "+IntToString(nRow)+" )";
        else if(TestStringAgainstPattern("cls_feat_**", s2DA))
            SQL = "SELECT "+q+""+sDBColumn+""+q+" FROM "+q+"prc_cached2da_cls_feat"+q+" WHERE ( "+q+"rowid"+q+" = "+IntToString(nRow)+" ) AND ( "+q+"file"+q+" = '"+s2DA+"' )";
        else if(TestStringAgainstPattern("ireq_**", s2DA))
            SQL = "SELECT "+q+""+sDBColumn+""+q+" FROM "+q+"prc_cached2da_ireq"+q+" WHERE ( "+q+"rowid"+q+" = "+IntToString(nRow)+" ) AND ( "+q+"file"+q+" = '"+s2DA+"' )";
        else
            SQL = "SELECT "+q+"data"+q+" FROM "+q+"prc_cached2da"+q+" WHERE ( "+q+"file"+q+" = '"+s2DA+"' ) AND ( "+q+"columnid"+q+" = '"+sDBColumn+"' ) AND ( "+q+"rowid"+q+" = "+IntToString(nRow)+" )";

        PRC_SQLExecDirect(SQL);
        // if there is an error, table is not built or is not initialized

        //THIS LINE CRASHES NWSERVER for any column other than the first one.
        //WISH I KNEW WHY!!!!!
        //update: its because its returning a null data.
        //the work around is to specify a default for all columns when creating the table
        if(!PRC_SQLFetch())
        {
            //DoDebug("Error getting table from DB");
        }
        else
        {
            //table exists, and no problems accessing it
            s = PRC_SQLGetData(1);
            if(s == "_")
                s="";
        }
        if(s == "")
            nNotNWNXCached = TRUE;
    }

    //if its not locally cached already
    //check if we should use the database
    string sBiowareDBEntry;
    if (s == "" && bUseBiowareDB)
    {
        sBiowareDBEntry = s2DA+"_"+sColumn+"_"+IntToString(nRow)+"_2DA";
        s = GetCampaignString(GetBiowareDBName()+"b", sBiowareDBEntry);
        if(s == "")
            nNotBiowareCached = TRUE;
    }



    //entry didnt exist in the database
    if(s == "")
    {
        //fetch from the 2da file
        s = Get2DAString(s2DA, sColumn, nRow);
        if (s == "")
            s = "****";
    }

    if(nNotNWNXCached && bUseNWNDB)
    {
        string q = PRC_SQLGetTick();
        string SQL;

        //store it in the database
        //use specific tables for certain 2das
        if(s2DA == "feat"
            || s2DA == "spells"
            || s2DA == "portraits"
            || s2DA == "soundset"
            || s2DA == "appearance"
            || s2DA == "portraits"
            || s2DA == "classes"
            || s2DA == "racialtypes"
            || s2DA == "item_to_ireq")
        {
            //check that 2da row exisits
            SQL = "SELECT "+q+"rowid"+q+" FROM "+q+"prc_cached2da_"+s2DA+""+q+" WHERE "+q+"rowid"+q+"="+IntToString(nRow);
            PRC_SQLExecDirect(SQL);
            //if the row exists, then update it
            //otherwise insert a new row
            if(PRC_SQLFetch() == PRC_SQL_SUCCESS
                && PRC_SQLGetData(1) != "")
            {
                SQL = "UPDATE "+q+"prc_cached2da_"+s2DA+""+q+" SET  "+q+""+sDBColumn+""+q+" = '"+s+"'  WHERE  "+q+"rowid"+q+" = "+IntToString(nRow)+" ";
            }
            else
            {
                SQL = "INSERT INTO "+q+"prc_cached2da_"+s2DA+""+q+" ("+q+"rowid"+q+", "+q+""+sDBColumn+""+q+") VALUES ("+IntToString(nRow)+" , '"+s+"')";
            }
        }
        else if(TestStringAgainstPattern("cls_feat_**", s2DA))
        {
            //check that 2da row exisits
            SQL = "SELECT "+q+"rowid"+q+" FROM "+q+"prc_cached2da_cls_feat"+q+" WHERE ("+q+"rowid"+q+"="+IntToString(nRow)+") AND ("+q+"file"+q+"='"+s2DA+"')";
            PRC_SQLExecDirect(SQL);
            //if the row exists, then update it
            //otherwise insert a new row
            if(PRC_SQLFetch() == PRC_SQL_SUCCESS
                && PRC_SQLGetData(1) != "")
            {
                SQL = "UPDATE "+q+"prc_cached2da_cls_feat"+q+" SET  "+q+""+sDBColumn+""+q+" = '"+s+"'WHERE ("+q+"rowid"+q+" = "+IntToString(nRow)+") AND ("+q+"file"+q+"='"+s2DA+"')";
            }
            else
            {
                SQL = "INSERT INTO "+q+"prc_cached2da_cls_feat"+q+" ("+q+"rowid"+q+", "+q+""+sDBColumn+""+q+", "+q+"file"+q+") VALUES ("+IntToString(nRow)+" , '"+s+"', '"+s2DA+"')";
            }
        }
        else if(TestStringAgainstPattern("ireq_**", s2DA))
        {
            //check that 2da row exisits
            SQL = "SELECT "+q+"rowid"+q+" FROM "+q+"prc_cached2da_ireq"+q+" WHERE ("+q+"rowid"+q+"="+IntToString(nRow)+") AND ("+q+"file"+q+"='"+s2DA+"')";
            PRC_SQLExecDirect(SQL);
            //if the row exists, then update it
            //otherwise insert a new row
            if(PRC_SQLFetch() == PRC_SQL_SUCCESS
                && PRC_SQLGetData(1) != "")
            {
                SQL = "UPDATE "+q+"prc_cached2da_ireq"+q+" SET  "+q+""+sDBColumn+""+q+" = '"+s+"'WHERE ("+q+"rowid"+q+" = "+IntToString(nRow)+") AND ("+q+"file"+q+"='"+s2DA+"')";
            }
            else
            {
                SQL = "INSERT INTO "+q+"prc_cached2da_ireq"+q+" ("+q+"rowid"+q+", "+q+""+sDBColumn+""+q+", "+q+"file"+q+") VALUES ("+IntToString(nRow)+" , '"+s+"', '"+s2DA+"')";
            }
        }
        else
        {
            SQL = "INSERT INTO "+q+"prc_cached2da"+q+" VALUES ('"+s2DA+"' , '"+sDBColumn+"' , '"+IntToString(nRow)+"' , '"+s+"')";
        }
        PRC_SQLExecDirect(SQL);
    }
    //store it on the waypoint
    if(nNotWPCached && bUseCreature)
        SetLocalString(oFileWP, s2DA+"|"+sColumn+"|"+IntToString(nRow), s);

    if(nNotBiowareCached && bUseBiowareDB)
    {
        SetCampaignString(GetBiowareDBName()+"b", sBiowareDBEntry, s);
    }

    //if(DEBUG_GET2DACACHE) PrintString("Get2DACache: Returned value is '" + s + "'");

    if (s=="****")
        return "";
    else
        return s;
}

string GetBiowareDBName()
{
    string sReturn;
    sReturn = "prc_data";
    if(GetPRCSwitch(MARKER_PRC_COMPANION))
        sReturn += "cp";
    if(GetPRCSwitch(MARKER_CEP1))
        sReturn += "c1";
    if(GetPRCSwitch(MARKER_CEP2))
        sReturn += "c2";
    return sReturn;

}

//Cache setup functions moved to inc_cache_setup
