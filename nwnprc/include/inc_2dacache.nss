#include "prc_inc_switch"
#include "inc_utility"

const int PRC_SQL_ERROR = 0;
const int PRC_SQL_SUCCESS = 1;

string Get2DACache(string s2DA, string sColumn, int nRow);
void PRC_SQLInit();
void PRC_SQLExecDirect(string sSQL);
int PRC_SQLFetch();
string PRC_SQLGetData(int iCol);

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
PrintString(sSQL);
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

void PRCMakeTables()
{
    string SQL;
    SQL = "cached2da_feat ( ";
    SQL+= "rowid int(55),";
    SQL+= "LABEL varchar(255),";
    SQL+= "FEAT varchar(255),";
    SQL+= "DESCRIPTION varchar(255),";
    SQL+= "ICON varchar(255),";
    SQL+= "MINATTACKBONUS varchar(255),";
    SQL+= "MINSTR varchar(255),";
    SQL+= "MINDEX varchar(255),";
    SQL+= "MININT varchar(255),";
    SQL+= "MINWIS varchar(255),";
    SQL+= "MINCON varchar(255),";
    SQL+= "MINCHA varchar(255),";
    SQL+= "MINSPELLLVL varchar(255),";
    SQL+= "PREREQFEAT1 varchar(255),";
    SQL+= "PREREQFEAT2 varchar(255),";
    SQL+= "GAINMULTIPLE varchar(255),";
    SQL+= "EFFECTSSTACK varchar(255),";
    SQL+= "ALLCLASSESCANUSE varchar(255),";
    SQL+= "CATEGORY varchar(255),";
    SQL+= "MAXCR varchar(255),";
    SQL+= "SPELLID varchar(255),";
    SQL+= "SUCCESSOR varchar(255),";
    SQL+= "CRValue varchar(255),";
    SQL+= "USESPERDAY varchar(255),";
    SQL+= "MASTERFEAT varchar(255),";
    SQL+= "TARGETSELF varchar(255),";
    SQL+= "OrReqFeat0 varchar(255),";
    SQL+= "OrReqFeat1 varchar(255),";
    SQL+= "OrReqFeat2 varchar(255),";
    SQL+= "OrReqFeat3 varchar(255),";
    SQL+= "OrReqFeat4 varchar(255),";
    SQL+= "REQSKILL varchar(255),";
    SQL+= "ReqSkillMinRanks varchar(255),";
    SQL+= "REQSKILL2 varchar(255),";
    SQL+= "ReqSkillMinRanks2 varchar(255),";
    SQL+= "Constant varchar(255),";
    SQL+= "TOOLSCATEGORIES varchar(255),";
    SQL+= "HostileFeat varchar(255),";
    SQL+= "MinLevel varchar(255),";
    SQL+= "MinLevelClass varchar(255),";
    SQL+= "MaxLevel varchar(255),";
    SQL+= "MinFortSave varchar(255),";
    SQL+= "PreReqEpic varchar(255)";
    SQL+= ")";
    SQL = "CREATE TABLE "+GetStringLowerCase(SQL);
    PRC_SQLExecDirect(SQL);

    SQL = "cached2da_soundset ( ";
    SQL+= "rowid int(55),";
    SQL+= "LABEL varchar(255), ";
    SQL+= "RESREF varchar(255), ";
    SQL+= "STRREF varchar(255), ";
    SQL+= "GENDER varchar(255), ";
    SQL+= "TYPE varchar(255) )";
    SQL = "CREATE TABLE "+GetStringLowerCase(SQL);
    SQL = "cached2da_portraits ( ";
    SQL+= "rowid int(255),";
    SQL+= "BaseResRef varchar(255), ";
    SQL+= "Sex varchar(255), ";
    SQL+= "Race varchar(255), ";
    SQL+= "InanimateType varchar(255), ";
    SQL+= "Plot varchar(255), ";
    SQL+= "LowGore varchar(255) )";
    SQL = "CREATE TABLE "+GetStringLowerCase(SQL);
    PRC_SQLExecDirect(SQL);

    SQL = "cached2da_appearance ( ";
    SQL+= "rowid int(55),";
    SQL+= "LABEL varchar(255), ";
    SQL+= "STRING_REF varchar(255), ";
    SQL+= "NAME varchar(255), ";
    SQL+= "RACE varchar(255), ";
    SQL+= "ENVMAP  varchar(255), ";
    SQL+= "BLOODCOLOR varchar(255), ";
    SQL+= "MODELTYPE varchar(255), ";
    SQL+= "WEAPONSCALE varchar(255), ";
    SQL+= "WING_TAIL_SCALE varchar(255), ";
    SQL+= "HELMET_SCALE_M varchar(255), ";
    SQL+= "HELMET_SCALE_F varchar(255), ";
    SQL+= "MOVERATE varchar(255), ";
    SQL+= "WALKDIST varchar(255), ";
    SQL+= "RUNDIST varchar(255), ";
    SQL+= "PERSPACE varchar(255), ";
    SQL+= "CREPERSPACE varchar(255), ";
    SQL+= "HEIGHT varchar(255), ";
    SQL+= "HITDIST varchar(255), ";
    SQL+= "PREFATCKDIST varchar(255), ";
    SQL+= "TARGETHEIGHT varchar(255), ";
    SQL+= "ABORTONPARRY varchar(255), ";
    SQL+= "RACIALTYPE varchar(255), ";
    SQL+= "HASLEGS varchar(255), ";
    SQL+= "HASARMS varchar(255), ";
    SQL+= "PORTRAIT varchar(255), ";
    SQL+= "SIZECATEGORY varchar(255), ";
    SQL+= "PERCEPTIONDIST varchar(255), ";
    SQL+= "FOOTSTEPTYPE varchar(255), ";
    SQL+= "SOUNDAPPTYPE varchar(255), ";
    SQL+= "HEADTRACK varchar(255), ";
    SQL+= "HEAD_ARC_H varchar(255), ";
    SQL+= "HEAD_ARC_V varchar(255), ";
    SQL+= "HEAD_NAME varchar(255), ";
    SQL+= "BODY_BAG varchar(255), ";
    SQL+= "TARGETABLE  varchar(255)";
    SQL+= ")";
    SQL = "CREATE TABLE "+GetStringLowerCase(SQL);
    PRC_SQLExecDirect(SQL);

    SQL = "cached2da_spells ( ";
    SQL+= "rowid int(55),";
    SQL+= "Label varchar(255), ";
    SQL+= "Name varchar(255), ";
    SQL+= "IconResRef varchar(255), ";
    SQL+= "School varchar(255), ";
    SQL+= "Range varchar(255), ";
    SQL+= "VS varchar(255), ";
    SQL+= "MetaMagic varchar(255), ";
    SQL+= "TargetType varchar(255), ";
    SQL+= "ImpactScript varchar(255), ";
    SQL+= "Bard varchar(255), ";
    SQL+= "Cleric varchar(255), ";
    SQL+= "Druid varchar(255), ";
    SQL+= "Paladin varchar(255), ";
    SQL+= "Ranger varchar(255), ";
    SQL+= "WizzSorc varchar(255), ";
    SQL+= "Innate varchar(255), ";
    SQL+= "ConjTime varchar(255), ";
    SQL+= "ConjAnim varchar(255), ";
    SQL+= "ConjHeadVisual varchar(255), ";
    SQL+= "ConjHandVisual varchar(255), ";
    SQL+= "ConjGrndVisual varchar(255), ";
    SQL+= "ConjSoundVFX varchar(255), ";
    SQL+= "ConjSoundMale varchar(255), ";
    SQL+= "ConjSoundFemale varchar(255), ";
    SQL+= "CastAnim varchar(255), ";
    SQL+= "CastTime varchar(255), ";
    SQL+= "CastHeadVisual varchar(255), ";
    SQL+= "CastHandVisual varchar(255), ";
    SQL+= "CastGrndVisual varchar(255), ";
    SQL+= "CastSound varchar(255), ";
    SQL+= "Proj varchar(255), ";
    SQL+= "ProjModel varchar(255), ";
    SQL+= "ProjType varchar(255), ";
    SQL+= "ProjSpwnPoint varchar(255), ";
    SQL+= "ProjSound varchar(255), ";
    SQL+= "ProjOrientation varchar(255), ";
    SQL+= "ImmunityType varchar(255), ";
    SQL+= "ItemImmunity varchar(255), ";
    SQL+= "SubRadSpell1 varchar(255), ";
    SQL+= "SubRadSpell2 varchar(255), ";
    SQL+= "SubRadSpell3 varchar(255), ";
    SQL+= "SubRadSpell4 varchar(255), ";
    SQL+= "SubRadSpell5 varchar(255), ";
    SQL+= "Category varchar(255), ";
    SQL+= "Master varchar(255), ";
    SQL+= "UserType varchar(255), ";
    SQL+= "SpellDesc varchar(255), ";
    SQL+= "UseConcentration varchar(255), ";
    SQL+= "SpontaneouslyCast varchar(255), ";
    SQL+= "AltMessage varchar(255), ";
    SQL+= "HostileSetting varchar(255), ";
    SQL+= "FeatID varchar(255), ";
    SQL+= "Counter1 varchar(255), ";
    SQL+= "Counter2 varchar(255), ";
    SQL+= "HasProjectile varchar(255))";
    SQL = "CREATE TABLE "+GetStringLowerCase(SQL);
    PRC_SQLExecDirect(SQL);

    SQL = "CREATE TABLE cached2da_cls_feat ( ";
    SQL+= "rowid int(55),";
    SQL+= "class varchar(255), ";
    SQL+= "FeatLabel varchar(255), ";
    SQL+= "FeatIndex varchar(255), ";
    SQL+= "List varchar(255), ";
    SQL+= "GrantedOnLevel varchar(255), ";
    SQL+= "OnMenu varchar(255))";
    PRC_SQLExecDirect(SQL);

    SQL = "CREATE TABLE cached2da ( file varchar(255), column varchar(255), rowid int(55), data varchar(255) )";
    PRC_SQLExecDirect(SQL);

}

string Get2DACache(string s2DA, string sColumn, int nRow)
{
    //get the waypoint htat marks the cache
    object oCacheWP = GetObjectByTag("CACHEWP");
    location lCache = GetLocation(oCacheWP);
    //if no waypoiint, use module start
    if (!GetIsObjectValid(oCacheWP))
        lCache = GetStartingLocation();
    //get the waypoint for this file
    string sFileWPName = "CACHED_"+GetStringUpperCase(s2DA)+"_"+sColumn+"_"+IntToString(nRow/1000);
    object oFileWP = GetWaypointByTag(sFileWPName);
    if (!GetIsObjectValid(oFileWP))
        oFileWP = CreateObject(OBJECT_TYPE_WAYPOINT,"NW_WAYPOINT001",lCache,FALSE,sFileWPName);
    string s = GetLocalString(oFileWP, "2DA_"+s2DA+"_"+sColumn+"_"+IntToString(nRow));
    //check if we should use the database
    int nDB = GetPRCSwitch(PRC_USE_DATABASE);
    string SQL;
    //lower case the 2da and column
    s2DA = GetStringLowerCase(s2DA);
    sColumn = GetStringLowerCase(sColumn);
    
    //sColumn = ReplaceChars(sColumn, "_" , "z");
    string sDBColumn = sColumn;
     
    //if its not locally cached already
    if (s == "")
    {
        //check the database
        if(nDB)
        {
            //initialize if needed
            if(GetLocalString(GetModule(), "NWNX!ODBC!SPACER") == "")
                PRC_SQLInit();
            if(s2DA == "feat"
                || s2DA == "spells"
                || s2DA == "portraits"
                || s2DA == "soundsets"
                || s2DA == "appearance"
                || s2DA == "rig")
                SQL = "SELECT "+sDBColumn+" FROM cached2da_"+s2DA+" WHERE ( rowid = "+IntToString(nRow)+" )";
            else if(TestStringAgainstPattern("cls_feat_**", s2DA))
                SQL = "SELECT "+sDBColumn+" FROM cached2da_cls_feat WHERE ( rowid = "+IntToString(nRow)+" ) AND ( file = '"+s2DA+"' )";
            else
                SQL = "SELECT data FROM cached2da WHERE ( file = '"+s2DA+"' ) AND ( column = '"+sDBColumn+"' ) AND ( rowid = "+IntToString(nRow)+" )";
            
            PRC_SQLExecDirect(SQL);
            // if there is an error, table is not built or is not initialized
            
            //THIS LINE CRASHES NWSCRIPT. WISH I KNEW WHY!!!!!            
            //if(PRC_SQLFetch() == PRC_SQL_ERROR)
            if(FALSE)
            {
                WriteTimestampedLogEntry("Error getting table from DB");
            }
            else
            {
                //table exists, and no problems accessing it
                s = PRC_SQLGetData(1);
            }
        }
        //entry didnt exist in the database
        if(s == "")
        {
            //fetch from the 2da file
            s = Get2DAString(s2DA, sColumn, nRow);
            if (s == "")
                s = "****";
            if(nDB)
            {
                //store it in the database
                //use specific tables for certain 2das
                if(s2DA == "feat"
                    || s2DA == "spells"
                    || s2DA == "portraits"
                    || s2DA == "soundset"
                    || s2DA == "appearance"
                    || s2DA == "rig")
                {
                    //check that 2da row exisits
                    SQL = "SELECT rowid FROM cached2da_"+s2DA+" WHERE rowid="+IntToString(nRow);
                    PRC_SQLExecDirect(SQL);
                    //if the row exists, then update it
                    //otherwise insert a new row
                    if(PRC_SQLFetch() == PRC_SQL_SUCCESS
                        && PRC_SQLGetData(1) != "")
                    {
                        SQL = "UPDATE cached2da_"+s2DA+" SET  "+sDBColumn+" = '"+s+"'  WHERE  rowid = "+IntToString(nRow)+" ";
                    }
                    else
                    {
                        SQL = "INSERT INTO cached2da_"+s2DA+" (rowid, "+sDBColumn+") VALUES ("+IntToString(nRow)+" , '"+s+"')";
                    }                        
                }
                else if(TestStringAgainstPattern("cls_feat_**", s2DA))
                {
                    //check that 2da row exisits
                    SQL = "SELECT rowid FROM cached2da_"+GetStringLeft(s2DA, 8)+" WHERE rowid="+IntToString(nRow);
                    PRC_SQLExecDirect(SQL);
                    //if the row exists, then update it
                    //otherwise insert a new row
                    if(PRC_SQLFetch() == PRC_SQL_SUCCESS
                        && PRC_SQLGetData(1) != "")
                    {
                        SQL = "UPDATE cached2da_cls_feat SET  "+sDBColumn+" = '"+s+"'  WHERE  rowid = "+IntToString(nRow)+" ";
                    }
                    else
                    {
                        SQL = "INSERT INTO cached2da_cls_feat (rowid, "+sDBColumn+") VALUES ("+IntToString(nRow)+" , '"+s+"')";
                    }                        
                }
                else
                {
                    SQL = "INSERT INTO cached2da VALUES ('"+s2DA+"' , '"+sDBColumn+"' , '"+IntToString(nRow)+"' , '"+s+"')";
                }    
                PRC_SQLExecDirect(SQL);
            }
        }
        //store it on the waypoint
        SetLocalString(oFileWP, "2DA_"+s2DA+"_"+sColumn+"_"+IntToString(nRow), s);
    }
    if (s=="****")
        return "";
    else
        return s;
}