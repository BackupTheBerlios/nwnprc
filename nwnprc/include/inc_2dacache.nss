#include "prc_inc_switch"

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
    string SQL2;
    //lower case the query
    s2DA = GetStringLowerCase(s2DA);
    //if its not locally cached already
    if (s == "")
    {
        //check the database
        if(nDB)
        {
            if(s2DA == "feat"
                || s2DA == "spells"
                || s2DA == "portraits"
                || s2DA == "soundsets"
                || s2DA == "appearance"
                || s2DA == "rig")
                SQL = "SELECT "+sColumn+" FROM cached2da_"+s2DA+" WHERE ( row = "+IntToString(nRow)+" )";
            else if(TestStringAgainstPattern("cls_feat_**", s2DA))
                SQL = "SELECT "+sColumn+" FROM cached2da_cls_feat WHERE ( row = "+IntToString(nRow)+" ) AND ( file = '"+s2DA+"' )";
            else
                SQL = "SELECT data FROM cached2da WHERE ( file = '"+s2DA+"' ) AND ( column = '"+sColumn+"' ) AND ( row = "+IntToString(nRow)+" )";
            PRC_SQLExecDirect(SQL);
            // if there is an error table is not built or is not initialized
            if(PRC_SQLFetch() == PRC_SQL_ERROR)
            {
                //initialize if needed
                if(GetLocalString(GetModule(), "NWNX!ODBC!SPACER") == "")
                    PRC_SQLInit();
                //create table
                //separate tables for special 2das
                if(s2DA == "feat"
                    || s2DA == "spells"
                    || s2DA == "portraits"
                    || s2DA == "soundset"
                    || s2DA == "appearance"
                    || s2DA == "rig")
                {
                    SQL2 = "SELECT row FROM cached2da_"+s2DA;
                    PRC_SQLExecDirect(SQL2);
                    if(PRC_SQLFetch() == PRC_SQL_SUCCESS)
                    {
                    }
                    else if(s2DA == "feat")
                    {
                        SQL2 = "CREATE TABLE cached2da_"+s2DA+" ( ";
                        SQL2+= "row int(255),";
                        SQL2+= "LABEL varchar(255),";
                        SQL2+= "FEAT int(255),";
                        SQL2+= "DESCRIPTION int(255),";
                        SQL2+= "ICON varchar(255),";
                        SQL2+= "MINATTACKBONUS int(255),";
                        SQL2+= "MINSTR int(255),";
                        SQL2+= "MINDEX int(255),";
                        SQL2+= "MININT int(255),";
                        SQL2+= "MINWIS int(255),";
                        SQL2+= "MINCON int(255),";
                        SQL2+= "MINCHA int(255),";
                        SQL2+= "MINSPELLLVL int(255),";
                        SQL2+= "PREREQFEAT1 int(255),";
                        SQL2+= "PREREQFEAT2 int(255),";
                        SQL2+= "GAINMULTIPLE int(255),";
                        SQL2+= "EFFECTSSTACK int(255),";
                        SQL2+= "ALLCLASSESCANUSE int(255),";
                        SQL2+= "CATEGORY int(255),";
                        SQL2+= "MAXCR int(255),";
                        SQL2+= "SPELLID int(255),";
                        SQL2+= "SUCCESSOR int(255),";
                        SQL2+= "CRValue int(255),";
                        SQL2+= "USESPERDAY int(255),";
                        SQL2+= "MASTERFEAT int(255),";
                        SQL2+= "TARGETSELF int(255),";
                        SQL2+= "OrReqFeat0 int(255),";
                        SQL2+= "OrReqFeat1 int(255),";
                        SQL2+= "OrReqFeat2 int(255),";
                        SQL2+= "OrReqFeat3 int(255),";
                        SQL2+= "OrReqFeat4 int(255),";
                        SQL2+= "REQSKILL int(255),";
                        SQL2+= "ReqSkillMinRanks int(255),";
                        SQL2+= "REQSKILL2 int(255),";
                        SQL2+= "ReqSkillMinRanks2 int(255),";
                        SQL2+= "Constant varchar(255),";
                        SQL2+= "TOOLSCATEGORIES int(255),";
                        SQL2+= "HostileFeat int(255),";
                        SQL2+= "MinLevel int(255),";
                        SQL2+= "MinLevelClass int(255),";
                        SQL2+= "MaxLevel int(255),";
                        SQL2+= "MinFortSave int(255),";
                        SQL2+= "PreReqEpic int(255)";
                        SQL2+= ")";
                    }
                    else if(s2DA == "soundset")
                    {
                        SQL2 = "CREATE TABLE cached2da_"+s2DA+" ( ";
                        SQL2+= "row int(255),";
                        SQL2+= "LABEL varchar(255), ";
                        SQL2+= "RESREF varchar(255), ";
                        SQL2+= "STRREF int(255), ";
                        SQL2+= "GENDER int(255), ";
                        SQL2+= "TYPE int(255) )";
                    }
                    else if(s2DA == "portraits")
                    {
                        SQL2 = "CREATE TABLE cached2da_"+s2DA+" ( ";
                        SQL2+= "row int(255),";
                        SQL2+= "BaseResRef varchar(255), ";
                        SQL2+= "Sex int(255), ";
                        SQL2+= "Race int(255), ";
                        SQL2+= "InanimateType int(255), ";
                        SQL2+= "Plot int(255), ";
                        SQL2+= "LowGore int(255) )";
                    }
                    else if(s2DA == "appearance")
                    {
                        SQL2 = "CREATE TABLE cached2da_"+s2DA+" ( ";
                        SQL2+= "row int(255),";
                        SQL2+= "LABEL varchar(255), ";
                        SQL2+= "STRING_REF int(255), ";
                        SQL2+= "NAME varchar(255), ";
                        SQL2+= "RACE varchar(255), ";
                        SQL2+= "ENVMAP  varchar(255), ";
                        SQL2+= "BLOODCOLR varchar(255), ";
                        SQL2+= "MODELTYPE varchar(255), ";
                        SQL2+= "WEAPONSCALE varchar(255), ";
                        SQL2+= "WING_TAIL_SCALE varchar(255), ";
                        SQL2+= "HELMET_SCALE_M varchar(255), ";
                        SQL2+= "HELMET_SCALE_F varchar(255), ";
                        SQL2+= "MOVERATE varchar(255), ";
                        SQL2+= "WALKDIST varchar(255), ";
                        SQL2+= "RUNDIST varchar(255), ";
                        SQL2+= "PERSPACE varchar(255), ";
                        SQL2+= "CREPERSPACE varchar(255), ";
                        SQL2+= "HEIGHT varchar(255), ";
                        SQL2+= "HITDIST varchar(255), ";
                        SQL2+= "PREFATCKDIST varchar(255), ";
                        SQL2+= "TARGETHEIGHT varchar(255), ";
                        SQL2+= "ABORTONPARRY varchar(255), ";
                        SQL2+= "RACIALTYPE varchar(255), ";
                        SQL2+= "HASLEGS varchar(255), ";
                        SQL2+= "HASARMS varchar(255), ";
                        SQL2+= "PORTRAIT varchar(255), ";
                        SQL2+= "SIZECATEGORY varchar(255), ";
                        SQL2+= "PERCEPTIONDIST varchar(255), ";
                        SQL2+= "FOOTSTEPTYPE varchar(255), ";
                        SQL2+= "SOUNDAPPTYPE varchar(255), ";
                        SQL2+= "HEADTRACK varchar(255), ";
                        SQL2+= "HEAD_ARC_H varchar(255), ";
                        SQL2+= "HEAD_ARC_V varchar(255), ";
                        SQL2+= "HEAD_NAME varchar(255), ";
                        SQL2+= "BODY_BAG varchar(255), ";
                        SQL2+= "TARGETABLE  varchar(255)";
                        SQL2+= ")";
                    }
                    else if(s2DA == "spells")
                    {
                        SQL2 = "CREATE TABLE cached2da_"+s2DA+" ( ";
                        SQL2+= "row int(255),";
                        SQL2+= "Label varchar(255), ";
                        SQL2+= "Name int(255), ";
                        SQL2+= "IconResRef varchar(255), ";
                        SQL2+= "School varchar(255), ";
                        SQL2+= "Range varchar(255), ";
                        SQL2+= "VS varchar(255), ";
                        SQL2+= "MetaMagic varchar(255), ";
                        SQL2+= "TargetType varchar(255), ";
                        SQL2+= "ImpactScript varchar(255), ";
                        SQL2+= "Bard int(255), ";
                        SQL2+= "Cleric int(255), ";
                        SQL2+= "Druid int(255), ";
                        SQL2+= "Paladin int(255), ";
                        SQL2+= "Ranger int(255), ";
                        SQL2+= "Wiz_Sorc int(255), ";
                        SQL2+= "Innate int(255), ";
                        SQL2+= "ConjTime int(255), ";
                        SQL2+= "ConjAnim varchar(255), ";
                        SQL2+= "ConjHeadVisual varchar(255), ";
                        SQL2+= "ConjHandVisual varchar(255), ";
                        SQL2+= "ConjGrndVisual varchar(255), ";
                        SQL2+= "ConjSoundVFX varchar(255), ";
                        SQL2+= "ConjSoundMale varchar(255), ";
                        SQL2+= "ConjSoundFemale varchar(255), ";
                        SQL2+= "CastAnim varchar(255), ";
                        SQL2+= "CastTime int(255), ";
                        SQL2+= "CastHeadVisual varchar(255), ";
                        SQL2+= "CastHandVisual varchar(255), ";
                        SQL2+= "CastGrndVisual varchar(255), ";
                        SQL2+= "CastSound varchar(255), ";
                        SQL2+= "Proj int(255), ";
                        SQL2+= "ProjModel varchar(255), ";
                        SQL2+= "ProjType varchar(255), ";
                        SQL2+= "ProjSpwnPoint varchar(255), ";
                        SQL2+= "ProjSound varchar(255), ";
                        SQL2+= "ProjOrientation varchar(255), ";
                        SQL2+= "ImmunityType varchar(255), ";
                        SQL2+= "ItemImmunity int(255), ";
                        SQL2+= "SubRadSpell1 int(255), ";
                        SQL2+= "SubRadSpell2 int(255), ";
                        SQL2+= "SubRadSpell3 int(255), ";
                        SQL2+= "SubRadSpell4 int(255), ";
                        SQL2+= "SubRadSpell5 int(255), ";
                        SQL2+= "Category int(255), ";
                        SQL2+= "Master int(255), ";
                        SQL2+= "UserType int(255), ";
                        SQL2+= "SpellDesc int(255), ";
                        SQL2+= "UseConcentration int(255), ";
                        SQL2+= "SpontaneouslyCast int(255), ";
                        SQL2+= "AltMessage int(255), ";
                        SQL2+= "HostileSetting int(255), ";
                        SQL2+= "FeatID int(255), ";
                        SQL2+= "Counter1 int(255), ";
                        SQL2+= "Counter2 int(255), ";
                        SQL2+= "HasProjectile int(255))";
                    }
                    else if(TestStringAgainstPattern("cls_feat_**", s2DA))
                    {
                        SQL2 = "CREATE TABLE cached2da_"+GetStringLeft(s2DA, 8)+" ( ";
                        SQL2+= "row int(255),";
                        SQL2+= "class varchar(255), ";
                        SQL2+= "FeatLabel varchar(255), ";
                        SQL2+= "FeatIndex varchar(255), ";
                        SQL2+= "List varchar(255), ";
                        SQL2+= "GrantedOnLevel varchar(255), ";
                        SQL2+= "OnMenu varchar(255))";
                    }
                }
                else
                {
                    SQL2 = "CREATE TABLE cached2da ( file varchar(255), column varchar(255), row int(55), data varchar(255) )";
                }
                //run the create table command
                PRC_SQLExecDirect(SQL2);
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
                    SQL = "SELECT row FROM cached2da_"+s2DA+" WHERE row="+IntToString(nRow);
                    PRC_SQLExecDirect(SQL);
                    //if the row exists, then update it
                    //otherwise insert a new row
                    if(PRC_SQLFetch() == PRC_SQL_SUCCESS
                        && PRC_SQLGetData(1) != "")
                        SQL = "UPDATE cached2da_"+s2DA+" SET  "+sColumn+" = '"+s+"'  WHERE  row = "+IntToString(nRow)+" ";
                    else
                        SQL = "INSERT INTO cached2da_"+s2DA+" (row, "+sColumn+") VALUES ("+IntToString(nRow)+" , '"+s+"')";
                }
                else if(TestStringAgainstPattern("cls_feat_**", s2DA))
                {
                    //check that 2da row exisits
                    SQL = "SELECT row FROM cached2da_"+GetStringLeft(s2DA, 8)+" WHERE row="+IntToString(nRow);
                    PRC_SQLExecDirect(SQL);
                    //if the row exists, then update it
                    //otherwise insert a new row
                    if(PRC_SQLFetch() == PRC_SQL_SUCCESS
                        && PRC_SQLGetData(1) != "")
                        SQL = "UPDATE cached2da_"+GetStringLeft(s2DA, 8)+" SET  "+sColumn+" = '"+s+"'  WHERE  row = "+IntToString(nRow)+" ";
                    else
                        SQL = "INSERT INTO cached2da_"+GetStringLeft(s2DA, 8)+" (row, "+sColumn+") VALUES ("+IntToString(nRow)+" , '"+s+"')";
                }
                else
                    SQL = "INSERT INTO cached2da VALUES ('"+s2DA+"' , '"+sColumn+"' , '"+IntToString(nRow)+"' , '"+s+"')";
                PRC_SQLExecDirect(SQL);
            }
        }
        //store it on the waypoint
        SetLocalString(oFileWP, "2DA_"+s2DA+"_"+sColumn+"_"+IntToString(nRow), s);
    }
//    WriteTimestampedLogEntry(s2DA+" "+sColumn+" "+IntToString(nRow)+" "+s);
    if (s=="****")
        return "";
    else
        return s;
}