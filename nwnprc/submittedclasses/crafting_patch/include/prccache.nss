//::////////////////////////////////////////////////////
//:: PRC 2DA caching system
//:: prccache
//::
//:: Original By: He Who Watches
//:: (taken from the Homebrew Functions sticky on
//::  the bioware scripting forum)
//:
//:: Modified By: Primogenitor
//:: Modified By: Guido Imperiale (CRVSADER//KY)
//:: Modified On: April 18, 2004
//::
//:: To enable 2da caching using NWNX2/ODBC, set a local
//:: integer on the module named PRC_USE_SQL to 1
//::
//::////////////////////////////////////////////////////


#include "aps_include"


/*************
 * CONSTANTS *
 *************/

//2da endpoints
//they have to be higher than the actual endpoints
//CEP compatible

const int CLASS_2DA_END         = 255;
const int RACE_2DA_END          = 255;
const int GENDER_2DA_END        = 5;
const int PORTRAITS_2DA_END     = 3600;
const int SKILLS_2DA_END        = 50;
const int CLASS_BFEAT_2DA_END   = 60;
const int CLASS_FEAT_2DA_END    = 600;
const int CLASS_SKILLS_2DA_END  = 50;
const int RACE_FEAT_2DA_END     = 50;
const int FEAT_2DA_END          = 11000;    //please rebalance this when PRC2.3 goes beta
const int PREREQ_2DA_END        = 50;       //cls_pres_* and ireq_*
const int ITEM_TO_IREQ_2DA_END  = 5000;
const int FAMILIAR_2DA_END      = 20;
const int ANIMALCOMP_2DA_END    = 20;
const int DOMAINS_2DA_END       = 70;
const int SOUNDSET_2DA_END      = 900;
const int SPELLS_2DA_END        = 5000;     //please rebalance this when PRC2.3 goes beta
const int SPELLSCHOOL_2DA_END   = 10;
const int APPEARANCE_2DA_END    = 2100;
const int WINGS_2DA_END         = 55;
const int TAILS_2DA_END         = 40;


/*************
 * FUNCTIONS *
 *************/


//Wrapper for Bioware's Get2daString; it will use a database if enabled
//Note that you CAN'T USE IT while any other SQL query is in progress,
//or it will overwrite the results!
string Get2DACache(string datafile, string column, int row);

//Force cache refresh of a 2DA entry
//Note that it won't autonomously check for USE_2DA_DB_CACHE.
//In general, you'll never need this one.
void Set2DACache(string datafile, string column, int row);

//Something horribly wrong happened; shout msg to everyone and write it to the log file
void prccache_error(string msg);


/******************
 * IMPLEMENTATION *
 ******************/

int PRC_USE_SQL = GetLocalInt(GetModule(), "PRC_USE_SQL");
int PRCCACHE_CC = GetLocalInt(GetModule(), "PRCCACHE_CC");


string Get2DACache(string datafile, string column, int row)
{
    string sQuery;

    if (!PRC_USE_SQL)
    {
        //do not use the SQL database
        return Get2DAString(datafile, column, row);
    }

    //Use the SQL database

    //generate encoded parameters
    string e_datafile = SQLEncodeSpecialChars(GetStringLowerCase(datafile));
    string e_column   = SQLEncodeSpecialChars(GetStringLowerCase(column  ));
    string e_row      = IntToString(row);

    sQuery = "SELECT data FROM prccache WHERE `row`=" + e_row + " AND `column`='" + e_column + "' AND `file`='" + e_datafile + "'";
    SQLExecDirect(sQuery);

    if (SQLFetch() == SQL_SUCCESS)
        return SQLDecodeSpecialChars(SQLGetData(1));
    else
    {
        //cache the 2da line, if exists
        string value = Get2DAString(datafile, column, row);
        if (value != "") {
            sQuery = "INSERT INTO prccache (`file`, `row`, `column`, `data`) VALUES ('"
                   + e_datafile + "','" + e_row + "','" + e_column + "','"
                   + SQLEncodeSpecialChars(value) + "')";
            SQLExecDirect(sQuery);
        }
        return value;
    }
}


void Set2DACache(string datafile, string column, int row)
{
	//Doesn't check for PRC_USE_SQL - this behaviour is needed by prccache_rebuild
	string value = Get2DAString(datafile, column, row);
	
    if (value != "") {
	    string e_datafile = SQLEncodeSpecialChars(GetStringLowerCase(datafile));
    	string e_column   = SQLEncodeSpecialChars(GetStringLowerCase(column  ));
    	string e_row      = IntToString(row);

    	string sQuery = "INSERT INTO `prccache` (`file`, `row`, `column`, `data`) VALUES ('"
        		+ e_datafile + "','" + e_row + "','" + e_column + "','"
                + SQLEncodeSpecialChars(value) + "')";
        SQLExecDirect(sQuery);
	}
}
	

void prccache_error(string msg)
{
    msg = "**prccache error** " + msg;
    object oPC = GetFirstPC();
    while (oPC != OBJECT_INVALID) {
        SendMessageToPC(oPC, msg);
        oPC = GetNextPC();
    }

    PrintString(msg);
}
