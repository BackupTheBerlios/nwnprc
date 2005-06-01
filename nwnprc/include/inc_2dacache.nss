const int PRC_SQL_ERROR = 0;
const int PRC_SQL_SUCCESS = 1;

string Get2DACache(string s2DA, string sColumn, int nRow);
void PRC_SQLInit();
void PRC_SQLExecDirect(string sSQL);
int PRC_SQLFetch();
string PRC_SQLGetData(int iCol);
void PRC_SQLCommit();

#include "prc_inc_switch"
#include "inc_utility"
#include "inc_fileends"

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
    if(GetPRCSwitch(PRC_DB_SQLLITE))
    {
        SQL += "PRAGMA page_size=4096; ";
    }
    PRC_SQLExecDirect(SQL); SQL = "";
    SQL+= "CREATE TABLE ";
    SQL+= "prc_cached2da_feat ( ";
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
    SQL+= "PreReqEpic varchar(255) DEFAULT '_',";
    SQL+= "ReqAction varchar(255) DEFAULT '_'); "; 
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE ";
    SQL+= "prc_cached2da_soundset ( ";
    SQL+= "rowid int(55),";
    SQL+= "LABEL varchar(255) DEFAULT '_', ";
    SQL+= "RESREF varchar(255) DEFAULT '_', ";
    SQL+= "STRREF varchar(255) DEFAULT '_', ";
    SQL+= "GENDER varchar(255) DEFAULT '_', ";
    SQL+= "TYPE varchar(255) ); ";
    PRC_SQLExecDirect(SQL); SQL = "";
      
    SQL+= "CREATE TABLE ";
    SQL+= "prc_cached2da_portraits ( ";
    SQL+= "rowid int(55),";
    SQL+= "BaseResRef varchar(255) DEFAULT '_', ";     
    SQL+= "Sex varchar(255) DEFAULT '_', ";    
    SQL+= "Race varchar(255) DEFAULT '_', ";   
    SQL+= "InanimateType varchar(255) DEFAULT '_', ";   
    SQL+= "Plot varchar(255) DEFAULT '_', ";   
    SQL+= "LowGore varchar(255) DEFAULT '_'); ";  
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE ";
    SQL+= "prc_cached2da_appearance ( ";
    SQL+= "rowid int(55),";
    SQL+= "LABEL varchar(255) DEFAULT '_', ";
    SQL+= "STRING_REF varchar(255) DEFAULT '_', ";
    SQL+= "NAME varchar(255) DEFAULT '_', ";
    SQL+= "RACE varchar(255) DEFAULT '_', ";
    SQL+= "ENVMAP  varchar(255) DEFAULT '_', ";
    SQL+= "BLOODCOLR varchar(255) DEFAULT '_', ";
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
    SQL+= "); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE ";
    SQL+= "prc_cached2da_spells ( ";
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
    SQL+= "Wiz_Sorc varchar(255) DEFAULT '_', ";
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
    SQL+= "HasProjectile varchar(255) DEFAULT '_'); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE prc_cached2da_cls_feat ( ";
    SQL+= "rowid int(55),";
    SQL+= "file varchar(255),";
    SQL+= "class varchar(255) DEFAULT '_', ";
    SQL+= "FeatLabel varchar(255) DEFAULT '_', ";
    SQL+= "FeatIndex varchar(255) DEFAULT '_', ";
    SQL+= "List varchar(255) DEFAULT '_', ";
    SQL+= "GrantedOnLevel varchar(255) DEFAULT '_', ";
    SQL+= "OnMenu varchar(255) DEFAULT '_'); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE prc_cached2da_classes ( ";
    SQL+= "rowid int(55),";
    SQL+= "Label varchar(255) DEFAULT '_', ";              
    SQL+= "Name varchar(255) DEFAULT '_', ";    
    SQL+= "Plural varchar(255) DEFAULT '_', ";
    SQL+= "Lower varchar(255) DEFAULT '_', ";
    SQL+= "Description varchar(255) DEFAULT '_', ";
    SQL+= "Icon varchar(255) DEFAULT '_', ";
    SQL+= "HitDie varchar(255) DEFAULT '_', ";
    SQL+= "AttackBonusTable varchar(255) DEFAULT '_', ";
    SQL+= "FeatsTable varchar(255) DEFAULT '_', ";
    SQL+= "SavingThrowTable varchar(255) DEFAULT '_', ";
    SQL+= "SkillsTable varchar(255) DEFAULT '_', ";
    SQL+= "BonusFeatsTable varchar(255) DEFAULT '_', ";
    SQL+= "SkillPointBase varchar(255) DEFAULT '_', ";
    SQL+= "SpellGainTable varchar(255) DEFAULT '_', ";
    SQL+= "SpellKnownTable varchar(255) DEFAULT '_', ";   
    SQL+= "PlayerClass varchar(255) DEFAULT '_', ";   
    SQL+= "SpellCaster varchar(255) DEFAULT '_', ";   
    SQL+= "Str varchar(255) DEFAULT '_', ";   
    SQL+= "Dex varchar(255) DEFAULT '_', ";   
    SQL+= "Con varchar(255) DEFAULT '_', ";   
    SQL+= "Wis varchar(255) DEFAULT '_', ";   
    SQL+= "Int varchar(255) DEFAULT '_', ";   
    SQL+= "Cha varchar(255) DEFAULT '_', ";   
    SQL+= "PrimaryAbil varchar(255) DEFAULT '_', ";   
    SQL+= "AlignRestrict varchar(255) DEFAULT '_', ";   
    SQL+= "AlignRstrctType varchar(255) DEFAULT '_', ";   
    SQL+= "InvertRestrict varchar(255) DEFAULT '_', ";   
    SQL+= "Constant varchar(255) DEFAULT '_', ";                      
    SQL+= "EffCRLvl01 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl02 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl03 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl04 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl05 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl06 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl07 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl08 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl09 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl10 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl11 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl12 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl13 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl14 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl15 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl16 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl17 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl18 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl19 varchar(255) DEFAULT '_', ";   
    SQL+= "EffCRLvl20 varchar(255) DEFAULT '_', ";   
    SQL+= "PreReqTable varchar(255) DEFAULT '_', ";       
    SQL+= "MaxLevel varchar(255) DEFAULT '_', ";   
    SQL+= "XPPenalty varchar(255) DEFAULT '_', ";   
    SQL+= "ArcSpellLvlMod varchar(255) DEFAULT '_', ";   
    SQL+= "DivSpellLvlMod varchar(255) DEFAULT '_', ";   
    SQL+= "EpicLevel varchar(255) DEFAULT '_', ";   
    SQL+= "Package varchar(255) DEFAULT '_'); "; 
    PRC_SQLExecDirect(SQL);

    SQL = "CREATE TABLE prc_cached2da ( file varchar(255) DEFAULT '_', column varchar(255) DEFAULT '_', rowid int(55), data varchar(255) DEFAULT '_'); ";
    PRC_SQLExecDirect(SQL);
    
    //non2dacaching table
    SQL = "CREATE TABLE prc_data (name varchar(255) DEFAULT '_', value varchar(255) DEFAULT '_')";
    PRC_SQLExecDirect(SQL);
    
    //indexs
    SQL = "CREATE UNIQUE INDEX rowindex ON prc_cached2da_feat (rowid); ";
    SQL+= "CREATE UNIQUE INDEX rowindex ON prc_cached2da_spells (rowid); ";
    SQL+= "CREATE INDEX rowindex ON prc_cached2da_cls_feat (FeatIndex); ";
    SQL+= "CREATE INDEX rowindex ON prc_cached2da_cls_feat (file); ";
    SQL+= "CREATE UNIQUE INDEX rowindex ON prc_cached2da_appearance (rowid); ";
    SQL+= "CREATE UNIQUE INDEX rowindex ON prc_cached2da_portrait (rowid); ";
    SQL+= "CREATE UNIQUE INDEX rowindex ON prc_cached2da_soundset (rowid); ";
    SQL+= "CREATE UNIQUE INDEX nameindex ON prc_data (name); ";
    PRC_SQLExecDirect(SQL);

}

void PreCache(string s2DA, string sColumn, int nRow, string sValue)
{
    //get the waypoint htat marks the cache
    object oCacheWP = GetObjectByTag("CACHEWP");
    location lCache = GetLocation(oCacheWP);
    //if no waypoiint, use module start
    if (!GetIsObjectValid(oCacheWP))
        lCache = GetStartingLocation();
    //lower case the 2da and column
    s2DA = GetStringLowerCase(s2DA);
    sColumn = GetStringLowerCase(sColumn);
    //get the waypoint for this file
    string sFileWPName = "CACHED_"+GetStringUpperCase(s2DA)+"_"+sColumn+"_"+IntToString(nRow/1000);
    object oFileWP = GetWaypointByTag(sFileWPName);
    if (!GetIsObjectValid(oFileWP))
        oFileWP = CreateObject(OBJECT_TYPE_WAYPOINT,"NW_WAYPOINT001",lCache,FALSE,sFileWPName);
    SetLocalString(oFileWP, "2DA_"+s2DA+"_"+sColumn+"_"+IntToString(nRow), sValue);
}

string Get2DACache(string s2DA, string sColumn, int nRow)
{
    //get the waypoint htat marks the cache
    object oCacheWP = GetObjectByTag("CACHEWP");
    location lCache = GetLocation(oCacheWP);
    //if no waypoiint, use module start
    if (!GetIsObjectValid(oCacheWP))
        lCache = GetStartingLocation();
    //lower case the 2da and column
    s2DA = GetStringLowerCase(s2DA);
    sColumn = GetStringLowerCase(sColumn);
    //get the waypoint for this file
    string sFileWPName = "CACHED_"+GetStringUpperCase(s2DA)+"_"+sColumn+"_"+IntToString(nRow/1000);
    object oFileWP = GetWaypointByTag(sFileWPName);
    if (!GetIsObjectValid(oFileWP))
        oFileWP = CreateObject(OBJECT_TYPE_WAYPOINT,"NW_WAYPOINT001",lCache,FALSE,sFileWPName);
    string s = GetLocalString(oFileWP, "2DA_"+s2DA+"_"+sColumn+"_"+IntToString(nRow));
    //check if we should use the database
    int nDB = GetPRCSwitch(PRC_USE_DATABASE);
    string SQL;
    
    
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
                || s2DA == "portraits"
                || s2DA == "classes")
                SQL = "SELECT "+sDBColumn+" FROM prc_cached2da_"+s2DA+" WHERE ( rowid = "+IntToString(nRow)+" )";
            else if(TestStringAgainstPattern("cls_feat_**", s2DA))
                SQL = "SELECT "+sDBColumn+" FROM prc_cached2da_cls_feat WHERE ( rowid = "+IntToString(nRow)+" ) AND ( file = '"+s2DA+"' )";
            else
                SQL = "SELECT data FROM prc_cached2da WHERE ( file = '"+s2DA+"' ) AND ( column = '"+sDBColumn+"' ) AND ( rowid = "+IntToString(nRow)+" )";
            
            PRC_SQLExecDirect(SQL);
            // if there is an error, table is not built or is not initialized
            
            //THIS LINE CRASHES NWSERVER for any colum other than the first one. 
            //WISH I KNEW WHY!!!!!    
            //update: its because its returning a null data. 
            //the work around is to specify a default for all columns when creating the table
            if(!PRC_SQLFetch())           
            {
                //WriteTimestampedLogEntry("Error getting table from DB");
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
                    || s2DA == "portraits"
                    || s2DA == "classes")
                {
                    //check that 2da row exisits
                    SQL = "SELECT rowid FROM prc_cached2da_"+s2DA+" WHERE rowid="+IntToString(nRow);
                    PRC_SQLExecDirect(SQL);
                    //if the row exists, then update it
                    //otherwise insert a new row
                    if(PRC_SQLFetch() == PRC_SQL_SUCCESS
                        && PRC_SQLGetData(1) != "")
                    {
                        SQL = "UPDATE prc_cached2da_"+s2DA+" SET  "+sDBColumn+" = '"+s+"'  WHERE  rowid = "+IntToString(nRow)+" ";
                    }
                    else
                    {
                        SQL = "INSERT INTO prc_cached2da_"+s2DA+" (rowid, "+sDBColumn+") VALUES ("+IntToString(nRow)+" , '"+s+"')";
                    }                        
                }
                else if(TestStringAgainstPattern("cls_feat_**", s2DA))
                {
                    //check that 2da row exisits
                    SQL = "SELECT rowid FROM prc_cached2da_"+GetStringLeft(s2DA, 8)+" WHERE (rowid="+IntToString(nRow)+") AND (file='"+s2DA+"')";
                    PRC_SQLExecDirect(SQL);
                    //if the row exists, then update it
                    //otherwise insert a new row
                    if(PRC_SQLFetch() == PRC_SQL_SUCCESS
                        && PRC_SQLGetData(1) != "")
                    {
                        SQL = "UPDATE prc_cached2da_cls_feat SET  "+sDBColumn+" = '"+s+"'WHERE (rowid = "+IntToString(nRow)+") AND (file='"+s2DA+"')";
                    }
                    else
                    {
                        SQL = "INSERT INTO prc_cached2da_cls_feat (rowid, "+sDBColumn+", file) VALUES ("+IntToString(nRow)+" , '"+s+"', '"+s2DA+"')";
                    }                        
                }
                else
                {
                    SQL = "INSERT INTO prc_cached2da VALUES ('"+s2DA+"' , '"+sDBColumn+"' , '"+IntToString(nRow)+"' , '"+s+"')";
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

//Caching functions

void Cache_Done()
{
    WriteTimestampedLogEntry("2da caching complete");
}

void Cache_Class_Feat(int nClass, int nRow = 0)
{
    string sFile = Get2DACache("classes", "FeatsTable", nClass);
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_cls_feat WHERE (file = '"+GetStringLowerCase(sFile)+"') ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    } 
    if(sFile != ""
        && sFile != "****"
        && nRow < GetPRCSwitch(FILE_END_CLASS_FEAT))
    {
        Get2DACache(sFile, "FeatLabel", nRow); 
        Get2DACache(sFile, "FeatIndex", nRow); 
        Get2DACache(sFile, "List", nRow); 
        Get2DACache(sFile, "GrantedOnLevel", nRow); 
        Get2DACache(sFile, "OnMenu", nRow); 
        nRow++;
        DelayCommand(0.1, Cache_Class_Feat(nClass, nRow));
        if(nRow >= GetPRCSwitch(FILE_END_CLASS_FEAT))
        {
            string SQL = "COMMIT";
            PRC_SQLExecDirect(SQL);
            SQL = "BEGIN IMMEDIATE";
            PRC_SQLExecDirect(SQL);
        }            
    }
    else
    {
        if(nClass == 254)
            Cache_Done();
        else
        {
            DelayCommand(0.1, Cache_Class_Feat(nClass+1)); //need to delay to prevent TMI
        }            
    }
}

void Cache_Classes(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_classes ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_CLASSES))
    {
        Get2DACache("classes", "Label", nRow);  
        Get2DACache("classes", "Name", nRow);  
        Get2DACache("classes", "Plural", nRow);  
        Get2DACache("classes", "Lower", nRow);  
        Get2DACache("classes", "Description", nRow);  
        Get2DACache("classes", "Icon", nRow);  
        Get2DACache("classes", "HitDie", nRow);  
        Get2DACache("classes", "AttackBonusTable", nRow);  
        Get2DACache("classes", "FeatsTable", nRow);  
        Get2DACache("classes", "SavingThrowTable", nRow);  
        Get2DACache("classes", "SkillsTable", nRow);  
        Get2DACache("classes", "BonusFeatsTable", nRow);  
        Get2DACache("classes", "SkillPointBase", nRow);  
        Get2DACache("classes", "SpellGainTable", nRow);  
        Get2DACache("classes", "SpellKnownTable", nRow);  
        Get2DACache("classes", "PlayerClass", nRow);
        Get2DACache("classes", "SpellCaster", nRow);     
        Get2DACache("classes", "Str", nRow);          
        Get2DACache("classes", "Dex", nRow);     
        Get2DACache("classes", "Con", nRow);     
        Get2DACache("classes", "Wis", nRow);     
        Get2DACache("classes", "Int", nRow);     
        Get2DACache("classes", "Cha", nRow);     
        Get2DACache("classes", "PrimaryAbil", nRow);     
        Get2DACache("classes", "AlignRestrict", nRow);     
        Get2DACache("classes", "AlignRstrctType", nRow);     
        Get2DACache("classes", "InvertRestrict", nRow);     
        Get2DACache("classes", "Constant", nRow);        
        Get2DACache("classes", "EffCRLvl01", nRow);        
        Get2DACache("classes", "EffCRLvl02", nRow);        
        Get2DACache("classes", "EffCRLvl03", nRow);        
        Get2DACache("classes", "EffCRLvl04", nRow);        
        Get2DACache("classes", "EffCRLvl05", nRow);        
        Get2DACache("classes", "EffCRLvl06", nRow);        
        Get2DACache("classes", "EffCRLvl07", nRow);        
        Get2DACache("classes", "EffCRLvl08", nRow);        
        Get2DACache("classes", "EffCRLvl09", nRow);        
        Get2DACache("classes", "EffCRLvl10", nRow);        
        Get2DACache("classes", "EffCRLvl12", nRow);        
        Get2DACache("classes", "EffCRLvl13", nRow);        
        Get2DACache("classes", "EffCRLvl14", nRow);        
        Get2DACache("classes", "EffCRLvl15", nRow);        
        Get2DACache("classes", "EffCRLvl16", nRow);        
        Get2DACache("classes", "EffCRLvl17", nRow);        
        Get2DACache("classes", "EffCRLvl18", nRow);        
        Get2DACache("classes", "EffCRLvl19", nRow);        
        Get2DACache("classes", "EffCRLvl20", nRow);        
        Get2DACache("classes", "PreReqTable", nRow);        
        Get2DACache("classes", "MaxLevel", nRow);        
        Get2DACache("classes", "XPPenalty", nRow);        
        Get2DACache("classes", "ArcSpellLvlMod", nRow);        
        Get2DACache("classes", "DivSpellLvlMod", nRow);        
        Get2DACache("classes", "EpicLevel", nRow);        
        Get2DACache("classes", "Package", nRow);      
        nRow++;
        DelayCommand(0.1, Cache_Classes(nRow));
    }
    else
        DelayCommand(1.0, Cache_Class_Feat(0));
    if(nRow % 100 == 0)
    {
        string SQL = "COMMIT";
        PRC_SQLExecDirect(SQL);
        SQL = "BEGIN IMMEDIATE";
        PRC_SQLExecDirect(SQL);
    }
}

void Cache_Feat(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_feat ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_FEAT))
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
        Get2DACache("feat", "ReqAction", nRow);
        nRow++;
        DelayCommand(0.01, Cache_Feat(nRow));
    }
    else 
        DelayCommand(1.0, Cache_Classes());
    if(nRow % 100 == 0)
    {
        string SQL = "COMMIT";
        PRC_SQLExecDirect(SQL);
        SQL = "BEGIN IMMEDIATE";
        PRC_SQLExecDirect(SQL);
    }
}

void Cache_Spells(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_spells ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_SPELLS))
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
    if(nRow % 100 == 0)
    {
        string SQL = "COMMIT";
        PRC_SQLExecDirect(SQL);
        SQL = "BEGIN IMMEDIATE";
        PRC_SQLExecDirect(SQL);
    }
}

void Cache_Portraits(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_portraits ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_PORTRAITS))
    {
        Get2DACache("portraits", "BaseResRef", nRow);     
        Get2DACache("portraits", "Sex", nRow);    
        Get2DACache("portraits", "Race", nRow);   
        Get2DACache("portraits", "InanimateType", nRow);   
        Get2DACache("portraits", "Plot", nRow);   
        Get2DACache("portraits", "LowGore", nRow);
        nRow++;
        DelayCommand(0.1, Cache_Portraits(nRow));
    }
    else
        DelayCommand(1.0, Cache_Spells());
    if(nRow % 100 == 0)
    {
        string SQL = "COMMIT";
        PRC_SQLExecDirect(SQL);
        SQL = "BEGIN IMMEDIATE";
        PRC_SQLExecDirect(SQL);
    }
}

void Cache_Soundset(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_soundset ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_SOUNDSET))
    {
        Get2DACache("soundset", "LABEL", nRow);                    
        Get2DACache("soundset", "RESREF", nRow);        
        Get2DACache("soundset", "STRREF", nRow);   
        Get2DACache("soundset", "GENDER", nRow);   
        Get2DACache("soundset", "TYPE", nRow);
        nRow++;
        DelayCommand(0.1, Cache_Soundset(nRow));
    }
    else
        DelayCommand(1.0, Cache_Portraits());
    if(nRow % 100 == 0)
    {
        string SQL = "COMMIT";
        PRC_SQLExecDirect(SQL);
        SQL = "BEGIN IMMEDIATE";
        PRC_SQLExecDirect(SQL);
    }
}

void Cache_Appearance(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_appearance ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_APPEARANCE))
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
        DelayCommand(1.0, Cache_Soundset());
    if(nRow % 100 == 0)
    {
        string SQL = "COMMIT";
        PRC_SQLExecDirect(SQL);
        SQL = "BEGIN IMMEDIATE";
        PRC_SQLExecDirect(SQL);
    }
}

void Cache_2da_data()
{
    Cache_Appearance();
}