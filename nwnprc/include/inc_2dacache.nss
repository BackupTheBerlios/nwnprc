#include "prc_inc_switch"
#include "inc_utility"
#include "inc_fileends"

const int PRC_SQL_ERROR = 0;
const int PRC_SQL_SUCCESS = 1;

string Get2DACache(string s2DA, string sColumn, int nRow);
void PRC_SQLInit();
void PRC_SQLExecDirect(string sSQL);
int PRC_SQLFetch();
string PRC_SQLGetData(int iCol);
void PRC_SQLCommit();

void PRC_SQLCommit()
{
    DelayCommand(600.0, PRC_SQLCommit());
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
    SQL+= "LABEL varchar(255) DEFAULT '_',";
    SQL+= "FEAT varchar(255) DEFAULT '_',";
    SQL+= "DESCRIPTION varchar(255) DEFAULT '_',";
    SQL+= "ICON varchar(255) DEFAULT '_',";
    SQL+= "MINATTACKBONUS varchar(255) DEFAULT '_',";
    SQL+= "MINSTR varchar(255) DEFAULT '_',";
    SQL+= "MINDEX varchar(255) DEFAULT '_',";
    SQL+= "MININT varchar(255) DEFAULT '_',";
    SQL+= "MINWIS varchar(255) DEFAULT '_',";
    SQL+= "MINCON varchar(255) DEFAULT '_',";
    SQL+= "MINCHA varchar(255) DEFAULT '_',";
    SQL+= "MINSPELLLVL varchar(255) DEFAULT '_',";
    SQL+= "PREREQFEAT1 varchar(255) DEFAULT '_',";
    SQL+= "PREREQFEAT2 varchar(255) DEFAULT '_',";
    SQL+= "GAINMULTIPLE varchar(255) DEFAULT '_',";
    SQL+= "EFFECTSSTACK varchar(255) DEFAULT '_',";
    SQL+= "ALLCLASSESCANUSE varchar(255) DEFAULT '_',";
    SQL+= "CATEGORY varchar(255) DEFAULT '_',";
    SQL+= "MAXCR varchar(255) DEFAULT '_',";
    SQL+= "SPELLID varchar(255) DEFAULT '_',";
    SQL+= "SUCCESSOR varchar(255) DEFAULT '_',";
    SQL+= "CRValue varchar(255) DEFAULT '_',";
    SQL+= "USESPERDAY varchar(255) DEFAULT '_',";
    SQL+= "MASTERFEAT varchar(255) DEFAULT '_',";
    SQL+= "TARGETSELF varchar(255) DEFAULT '_',";
    SQL+= "OrReqFeat0 varchar(255) DEFAULT '_',";
    SQL+= "OrReqFeat1 varchar(255) DEFAULT '_',";
    SQL+= "OrReqFeat2 varchar(255) DEFAULT '_',";
    SQL+= "OrReqFeat3 varchar(255) DEFAULT '_',";
    SQL+= "OrReqFeat4 varchar(255) DEFAULT '_',";
    SQL+= "REQSKILL varchar(255) DEFAULT '_',";
    SQL+= "ReqSkillMinRanks varchar(255) DEFAULT '_',";
    SQL+= "REQSKILL2 varchar(255) DEFAULT '_',";
    SQL+= "ReqSkillMinRanks2 varchar(255) DEFAULT '_',";
    SQL+= "Constant varchar(255) DEFAULT '_',";
    SQL+= "TOOLSCATEGORIES varchar(255) DEFAULT '_',";
    SQL+= "HostileFeat varchar(255) DEFAULT '_',";
    SQL+= "MinLevel varchar(255) DEFAULT '_',";
    SQL+= "MinLevelClass varchar(255) DEFAULT '_',";
    SQL+= "MaxLevel varchar(255) DEFAULT '_',";
    SQL+= "MinFortSave varchar(255) DEFAULT '_',";
    SQL+= "PreReqEpic varchar(255) DEFAULT '_'";
    SQL+= ")";
    SQL = "CREATE TABLE "+GetStringLowerCase(SQL);
    PRC_SQLExecDirect(SQL);

    SQL = "cached2da_soundset ( ";
    SQL+= "rowid int(55),";
    SQL+= "LABEL varchar(255) DEFAULT '_', ";
    SQL+= "RESREF varchar(255) DEFAULT '_', ";
    SQL+= "STRREF varchar(255) DEFAULT '_', ";
    SQL+= "GENDER varchar(255) DEFAULT '_', ";
    SQL+= "TYPE varchar(255) )";
    SQL = "CREATE TABLE "+GetStringLowerCase(SQL);
    SQL = "cached2da_portraits ( ";
    SQL+= "rowid int(255),";
    SQL+= "BaseResRef varchar(255) DEFAULT '_', ";
    SQL+= "Sex varchar(255) DEFAULT '_', ";
    SQL+= "Race varchar(255) DEFAULT '_', ";
    SQL+= "InanimateType varchar(255) DEFAULT '_', ";
    SQL+= "Plot varchar(255) DEFAULT '_', ";
    SQL+= "LowGore varchar(255) DEFAULT '_')";
    SQL = "CREATE TABLE "+GetStringLowerCase(SQL);
    PRC_SQLExecDirect(SQL);

    SQL = "cached2da_appearance ( ";
    SQL+= "rowid int(55),";
    SQL+= "LABEL varchar(255) DEFAULT '_', ";
    SQL+= "STRING_REF varchar(255) DEFAULT '_', ";
    SQL+= "NAME varchar(255) DEFAULT '_', ";
    SQL+= "RACE varchar(255) DEFAULT '_', ";
    SQL+= "ENVMAP  varchar(255) DEFAULT '_', ";
    SQL+= "BLOODCOLOR varchar(255) DEFAULT '_', ";
    SQL+= "MODELTYPE varchar(255) DEFAULT '_', ";
    SQL+= "WEAPONSCALE varchar(255) DEFAULT '_', ";
    SQL+= "WING_TAIL_SCALE varchar(255) DEFAULT '_', ";
    SQL+= "HELMET_SCALE_M varchar(255) DEFAULT '_', ";
    SQL+= "HELMET_SCALE_F varchar(255) DEFAULT '_', ";
    SQL+= "MOVERATE varchar(255) DEFAULT '_', ";
    SQL+= "WALKDIST varchar(255) DEFAULT '_', ";
    SQL+= "RUNDIST varchar(255) DEFAULT '_', ";
    SQL+= "PERSPACE varchar(255) DEFAULT '_', ";
    SQL+= "CREPERSPACE varchar(255) DEFAULT '_', ";
    SQL+= "HEIGHT varchar(255) DEFAULT '_', ";
    SQL+= "HITDIST varchar(255) DEFAULT '_', ";
    SQL+= "PREFATCKDIST varchar(255) DEFAULT '_', ";
    SQL+= "TARGETHEIGHT varchar(255) DEFAULT '_', ";
    SQL+= "ABORTONPARRY varchar(255) DEFAULT '_', ";
    SQL+= "RACIALTYPE varchar(255) DEFAULT '_', ";
    SQL+= "HASLEGS varchar(255) DEFAULT '_', ";
    SQL+= "HASARMS varchar(255) DEFAULT '_', ";
    SQL+= "PORTRAIT varchar(255) DEFAULT '_', ";
    SQL+= "SIZECATEGORY varchar(255) DEFAULT '_', ";
    SQL+= "PERCEPTIONDIST varchar(255) DEFAULT '_', ";
    SQL+= "FOOTSTEPTYPE varchar(255) DEFAULT '_', ";
    SQL+= "SOUNDAPPTYPE varchar(255) DEFAULT '_', ";
    SQL+= "HEADTRACK varchar(255) DEFAULT '_', ";
    SQL+= "HEAD_ARC_H varchar(255) DEFAULT '_', ";
    SQL+= "HEAD_ARC_V varchar(255) DEFAULT '_', ";
    SQL+= "HEAD_NAME varchar(255) DEFAULT '_', ";
    SQL+= "BODY_BAG varchar(255) DEFAULT '_', ";
    SQL+= "TARGETABLE  varchar(255) DEFAULT '_'";
    SQL+= ")";
    SQL = "CREATE TABLE "+GetStringLowerCase(SQL);
    PRC_SQLExecDirect(SQL);

    SQL = "cached2da_spells ( ";
    SQL+= "rowid int(55),";
    SQL+= "Label varchar(255) DEFAULT '_', ";
    SQL+= "Name varchar(255) DEFAULT '_', ";
    SQL+= "IconResRef varchar(255) DEFAULT '_', ";
    SQL+= "School varchar(255) DEFAULT '_', ";
    SQL+= "Range varchar(255) DEFAULT '_', ";
    SQL+= "VS varchar(255) DEFAULT '_', ";
    SQL+= "MetaMagic varchar(255) DEFAULT '_', ";
    SQL+= "TargetType varchar(255) DEFAULT '_', ";
    SQL+= "ImpactScript varchar(255) DEFAULT '_', ";
    SQL+= "Bard varchar(255) DEFAULT '_', ";
    SQL+= "Cleric varchar(255) DEFAULT '_', ";
    SQL+= "Druid varchar(255) DEFAULT '_', ";
    SQL+= "Paladin varchar(255) DEFAULT '_', ";
    SQL+= "Ranger varchar(255) DEFAULT '_', ";
    SQL+= "WizzSorc varchar(255) DEFAULT '_', ";
    SQL+= "Innate varchar(255) DEFAULT '_', ";
    SQL+= "ConjTime varchar(255) DEFAULT '_', ";
    SQL+= "ConjAnim varchar(255) DEFAULT '_', ";
    SQL+= "ConjHeadVisual varchar(255) DEFAULT '_', ";
    SQL+= "ConjHandVisual varchar(255) DEFAULT '_', ";
    SQL+= "ConjGrndVisual varchar(255) DEFAULT '_', ";
    SQL+= "ConjSoundVFX varchar(255) DEFAULT '_', ";
    SQL+= "ConjSoundMale varchar(255) DEFAULT '_', ";
    SQL+= "ConjSoundFemale varchar(255) DEFAULT '_', ";
    SQL+= "CastAnim varchar(255) DEFAULT '_', ";
    SQL+= "CastTime varchar(255) DEFAULT '_', ";
    SQL+= "CastHeadVisual varchar(255) DEFAULT '_', ";
    SQL+= "CastHandVisual varchar(255) DEFAULT '_', ";
    SQL+= "CastGrndVisual varchar(255) DEFAULT '_', ";
    SQL+= "CastSound varchar(255) DEFAULT '_', ";
    SQL+= "Proj varchar(255) DEFAULT '_', ";
    SQL+= "ProjModel varchar(255) DEFAULT '_', ";
    SQL+= "ProjType varchar(255) DEFAULT '_', ";
    SQL+= "ProjSpwnPoint varchar(255) DEFAULT '_', ";
    SQL+= "ProjSound varchar(255) DEFAULT '_', ";
    SQL+= "ProjOrientation varchar(255) DEFAULT '_', ";
    SQL+= "ImmunityType varchar(255) DEFAULT '_', ";
    SQL+= "ItemImmunity varchar(255) DEFAULT '_', ";
    SQL+= "SubRadSpell1 varchar(255) DEFAULT '_', ";
    SQL+= "SubRadSpell2 varchar(255) DEFAULT '_', ";
    SQL+= "SubRadSpell3 varchar(255) DEFAULT '_', ";
    SQL+= "SubRadSpell4 varchar(255) DEFAULT '_', ";
    SQL+= "SubRadSpell5 varchar(255) DEFAULT '_', ";
    SQL+= "Category varchar(255) DEFAULT '_', ";
    SQL+= "Master varchar(255) DEFAULT '_', ";
    SQL+= "UserType varchar(255) DEFAULT '_', ";
    SQL+= "SpellDesc varchar(255) DEFAULT '_', ";
    SQL+= "UseConcentration varchar(255) DEFAULT '_', ";
    SQL+= "SpontaneouslyCast varchar(255) DEFAULT '_', ";
    SQL+= "AltMessage varchar(255) DEFAULT '_', ";
    SQL+= "HostileSetting varchar(255) DEFAULT '_', ";
    SQL+= "FeatID varchar(255) DEFAULT '_', ";
    SQL+= "Counter1 varchar(255) DEFAULT '_', ";
    SQL+= "Counter2 varchar(255) DEFAULT '_', ";
    SQL+= "HasProjectile varchar(255) DEFAULT '_')";
    SQL = "CREATE TABLE "+GetStringLowerCase(SQL);
    PRC_SQLExecDirect(SQL);

    SQL = "CREATE TABLE cached2da_cls_feat ( ";
    SQL+= "rowid int(55),";
    SQL+= "class varchar(255) DEFAULT '_', ";
    SQL+= "FeatLabel varchar(255) DEFAULT '_', ";
    SQL+= "FeatIndex varchar(255) DEFAULT '_', ";
    SQL+= "List varchar(255) DEFAULT '_', ";
    SQL+= "GrantedOnLevel varchar(255) DEFAULT '_', ";
    SQL+= "OnMenu varchar(255) DEFAULT '_')";
    PRC_SQLExecDirect(SQL);

    SQL = "CREATE TABLE cached2da ( file varchar(255) DEFAULT '_', column varchar(255) DEFAULT '_', rowid int(55), data varchar(255) DEFAULT '_')";
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
            
            //THIS LINE CRASHES NWSERVER for any colum other than the first one. 
            //WISH I KNEW WHY!!!!!    
            //update: its because its returning a null data. must specify a default for all columns when creating the table
            if(!PRC_SQLFetch())           
            {
                WriteTimestampedLogEntry("Error getting table from DB");
            }
            else
            {
                //table exists, and no problems accessing it
                s = PRC_SQLGetData(1);
                if(s == "_")
                    s="";
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

void Cache_Feat(int nRow = 0)
{
    if(nRow < FEAT_2DA_END)
    {
        Get2DACache("feat", "LABEL", nRow);
        Get2DACache("feat", "FEAT", nRow);
        Get2DACache("feat", "DESCRIPTION", nRow);
        Get2DACache("feat", "MINATTACKBONUS", nRow);
        Get2DACache("feat", "MINSTR", nRow);
        Get2DACache("feat", "MINDEX", nRow);
        Get2DACache("feat", "MININT", nRow);
        Get2DACache("feat", "MINWIS", nRow);
        Get2DACache("feat", "MINCON", nRow);
        Get2DACache("feat", "MINCHA", nRow);
        Get2DACache("feat", "MINSPELLLVL", nRow);
        Get2DACache("feat", "PREREQFEAT1", nRow);
        Get2DACache("feat", "PREREQFEAT2", nRow);
        Get2DACache("feat", "GAINMULTIPLE", nRow);
        Get2DACache("feat", "EFFECTSSTACK", nRow);
        Get2DACache("feat", "ALLCLASSESCANUSE", nRow);
        Get2DACache("feat", "CATEGORY", nRow);
        Get2DACache("feat", "MAXCR", nRow);
        Get2DACache("feat", "SPELLID", nRow);
        Get2DACache("feat", "SUCCESSOR", nRow);
        Get2DACache("feat", "CRValue", nRow);
        Get2DACache("feat", "USESPERDAY", nRow);
        Get2DACache("feat", "MASTERFEAT", nRow);
        Get2DACache("feat", "TARGETSELF", nRow);
        Get2DACache("feat", "OrReqFeat0", nRow);
        Get2DACache("feat", "OrReqFeat1", nRow);
        Get2DACache("feat", "OrReqFeat2", nRow);
        Get2DACache("feat", "OrReqFeat3", nRow);
        Get2DACache("feat", "OrReqFeat4", nRow);
        Get2DACache("feat", "REQSKILL", nRow);
        Get2DACache("feat", "ReqSkillMinRanks", nRow);
        Get2DACache("feat", "REQSKILL2", nRow);
        Get2DACache("feat", "ReqSkillMinRanks2", nRow);
        Get2DACache("feat", "Constant", nRow);
        Get2DACache("feat", "TOOLSCATEGORIES", nRow);
        Get2DACache("feat", "HostileFeat", nRow);
        Get2DACache("feat", "MinLevel", nRow);
        Get2DACache("feat", "MinLevelClass", nRow);
        Get2DACache("feat", "MaxLevel", nRow);
        Get2DACache("feat", "MinFortSave", nRow);
        Get2DACache("feat", "PreReqEpic", nRow);
        nRow++;
        DelayCommand(0.01, Cache_Feat(nRow));
    }
}

void Cache_Spells(int nRow = 0)
{
    if(nRow < SPELLS_2DA_END)
    {
        Get2DACache("spells", "Label", nRow);
        Get2DACache("spells", "Name", nRow);
        Get2DACache("spells", "IconResRef", nRow);
        Get2DACache("spells", "School", nRow);
        Get2DACache("spells", "Range", nRow);
        Get2DACache("spells", "VS", nRow);
        Get2DACache("spells", "MetaMagic", nRow);
        Get2DACache("spells", "TargetType", nRow);
        Get2DACache("spells", "ImpactScript", nRow);
        Get2DACache("spells", "Bard", nRow);
        Get2DACache("spells", "Cleric", nRow);
        Get2DACache("spells", "Druid", nRow);
        Get2DACache("spells", "Paladin", nRow);
        Get2DACache("spells", "Ranger", nRow);
        Get2DACache("spells", "Wiz_Sorc", nRow);
        Get2DACache("spells", "Innate", nRow);
        Get2DACache("spells", "ConjTime", nRow);
        Get2DACache("spells", "ConjAnim", nRow);
        Get2DACache("spells", "ConjHeadVisual", nRow);
        Get2DACache("spells", "ConjHandVisual", nRow);
        Get2DACache("spells", "ConjGrndVisual", nRow);
        Get2DACache("spells", "ConjSoundVFX", nRow);
        Get2DACache("spells", "ConjSoundMale", nRow);
        Get2DACache("spells", "ConjSoundFemale", nRow);
        Get2DACache("spells", "CastAnim", nRow);
        Get2DACache("spells", "CastTime", nRow);
        Get2DACache("spells", "CastHeadVisual", nRow);
        Get2DACache("spells", "CastHandVisual", nRow);
        Get2DACache("spells", "CastGrndVisual", nRow);
        Get2DACache("spells", "CastSound", nRow);
        Get2DACache("spells", "Proj", nRow);
        Get2DACache("spells", "ProjModel", nRow);
        Get2DACache("spells", "ProjType", nRow);
        Get2DACache("spells", "ProjSpwnPoint", nRow);
        Get2DACache("spells", "ProjSound", nRow);
        Get2DACache("spells", "ProjOrientation", nRow);
        Get2DACache("spells", "ImmunityType", nRow);
        Get2DACache("spells", "ItemImmunity", nRow);
        Get2DACache("spells", "SubRadSpell1", nRow);
        Get2DACache("spells", "SubRadSpell2", nRow);
        Get2DACache("spells", "SubRadSpell3", nRow);
        Get2DACache("spells", "SubRadSpell4", nRow);
        Get2DACache("spells", "SubRadSpell5", nRow);
        Get2DACache("spells", "Category", nRow);
        Get2DACache("spells", "Master", nRow);
        Get2DACache("spells", "UserType", nRow);
        Get2DACache("spells", "SpellDesc", nRow);
        Get2DACache("spells", "UseConcentration", nRow);
        Get2DACache("spells", "SpontaneouslyCast", nRow);
        Get2DACache("spells", "AltMessage", nRow);
        Get2DACache("spells", "HostileSetting", nRow);
        Get2DACache("spells", "FeatID", nRow);
        Get2DACache("spells", "Counter1", nRow);
        Get2DACache("spells", "Counter2", nRow);
        Get2DACache("spells", "HasProjectile", nRow);
        nRow++;
        DelayCommand(0.01, Cache_Spells(nRow));
    }
    else
        DelayCommand(0.1, Cache_Feat());
}

void Cache_Appearance(int nRow = 0)
{
    if(nRow < APPEARANCE_2DA_END)
    {
        Get2DACache("appearance", "LABEL", nRow);
        Get2DACache("appearance", "STRING_REF", nRow);
        Get2DACache("appearance", "NAME", nRow);
        Get2DACache("appearance", "RACE", nRow);
        Get2DACache("appearance", "ENVMAP", nRow);
        Get2DACache("appearance", "BLOODCOLR", nRow);
        Get2DACache("appearance", "MODELTYPE", nRow);
        Get2DACache("appearance", "WEAPONSCALE", nRow);
        Get2DACache("appearance", "WING_TAIL_SCALE", nRow);
        Get2DACache("appearance", "HELMET_SCALE_M", nRow);
        Get2DACache("appearance", "HELMET_SCALE_F", nRow);
        Get2DACache("appearance", "MOVERATE", nRow);
        Get2DACache("appearance", "WALKDIST", nRow);
        Get2DACache("appearance", "RUNDIST", nRow);
        Get2DACache("appearance", "PERSPACE", nRow);
        Get2DACache("appearance", "CREPERSPACE", nRow);
        Get2DACache("appearance", "HEIGHT", nRow);
        Get2DACache("appearance", "HITDIST", nRow);
        Get2DACache("appearance", "PREFATCKDIST", nRow);
        Get2DACache("appearance", "TARGETHEIGHT", nRow);
        Get2DACache("appearance", "ABORTONPARRY", nRow);
        Get2DACache("appearance", "RACIALTYPE", nRow);
        Get2DACache("appearance", "HASLEGS", nRow);
        Get2DACache("appearance", "HASARMS", nRow);
        Get2DACache("appearance", "PORTRAIT", nRow);
        Get2DACache("appearance", "SIZECATEGORY", nRow);
        Get2DACache("appearance", "PERCEPTIONDIST", nRow);
        Get2DACache("appearance", "FOOTSTEPTYPE", nRow);
        Get2DACache("appearance", "SOUNDAPPTYPE", nRow);
        Get2DACache("appearance", "HEADTRACK", nRow);
        Get2DACache("appearance", "HEAD_ARC_H", nRow);
        Get2DACache("appearance", "HEAD_ARC_V", nRow);
        Get2DACache("appearance", "HEAD_NAME", nRow);
        Get2DACache("appearance", "BODY_BAG", nRow);
        Get2DACache("appearance", "TARGETABLE", nRow);
        nRow++;
        DelayCommand(0.1, Cache_Appearance(nRow));
    }
    else
        DelayCommand(1.0, Cache_Spells());
}

void Cache_2da_data()
{
    Cache_Appearance();
}