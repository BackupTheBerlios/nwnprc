//:://////////////////////////////////////////////
//:: PRC 2DA caching system
//:: OnLoad script
//:: prccache_onload
//::
//:: This file is licensed under the terms of the
//:: GNU GENERAL PUBLIC LICENSE (GPL) Version 2
//::
//:: Created By: Guido Imperiale (CRVSADER//KY)
//:: Created On: April 18, 2005
//::
//:: 1) Initialize the MySQL database
//:: 2) Test the MySQL database
//:: 3) Test if the 2da cache is up to date and eventually rebuild it
//:: 4) Eventually run a custom OnLoad script that has to be run AFTER the MySQL initialization
//::
//:://////////////////////////////////////////////

#include "prccache"  


//test SQL server functionality
int SQLTest()
{
	SQLExecDirect("CREATE TABLE IF NOT EXISTS prctest (test varchar(255) default NULL) TYPE=MyISAM");
	SQLExecDirect("INSERT INTO prctest (test) VALUES ('prctest')");
	SQLExecDirect("SELECT test FROM prctest");

	int result = (SQLFetch() == SQL_SUCCESS && SQLGetData(1) == "prctest");
	
	SQLExecDirect("DROP TABLE prctest");

	return result;
}
	

//test the cached 2DAs version and return FALSE if versions differ
int Test2DAVersion(string sColumn) 
{
	string sVersion = Get2DAString("prc_version", sColumn, 0);
	string sCachedVersion;
	
	SQLExecDirect("SELECT `data` FROM `prccache` WHERE `file`='prc_version' AND `column`='" + sColumn + "' AND `row`='0'");
	if (SQLFetch() == SQL_ERROR)
		sCachedVersion = "";
	else
		sCachedVersion = SQLDecodeSpecialChars(SQLGetData(1));
	
	//PrintString("Test2DAVersion(" + sColumn + "): " + IntToString(sCachedVersion == sVersion));
	return (sCachedVersion == sVersion);
}


//test if the Character Creator cache is in place
int TestCCCache()
{
	SQLExecDirect("SELECT * FROM prccache_soundset LIMIT 1");
	return (SQLFetch() == SQL_SUCCESS);
}
	

//Initialize game server
void InitServer()
{
	object oModule = OBJECT_SELF;
	
	if (SQLTest() == TRUE) 
	{
		//we have a working SQL server
	
		SetLocalInt(oModule, "HaveSQLServer", TRUE);

		//PrintString("PRCCACHE_CC = " + IntToString(PRCCACHE_CC));

		//test PRC version
		if (Test2DAVersion("nwnversion") == FALSE ||
			Test2DAVersion("prcversion") == FALSE ||
			Test2DAVersion("modversion") == FALSE ||
			(PRCCACHE_CC && TestCCCache() == FALSE))
		{
			//rebuild the 2DA cache
			ExecuteScript("prccache_rebuild", OBJECT_SELF);
		}
			
		if (PRCCACHE_CC) {
			//launch the script at the end of the DelayCommand queue
			DelayCommand(0.0, ExecuteScript("prccache_rbfeat" , OBJECT_SELF));
		}
	}
	else 
	{
		//we don't have a working SQL server
		SetLocalInt(oModule, "HaveSQLServer", FALSE);
		SetLocalInt(oModule, "PRCCACHE_CC"  , FALSE);
	}
		
	//run an eventual custom script
	string sCustom = GetLocalString(oModule, "PRC_OnLoad_AfterSQL");
	if (sCustom != "") {
		//launch the script at the end of the DelayCommand queue
		DelayCommand(0.0, ExecuteScript(sCustom, OBJECT_SELF));
	}
}


void main ()
{
	object oModule = OBJECT_SELF;

	if (GetLocalInt(oModule, "PRC_USE_SQL"))
	{
	    // Linux initialization
	    SetLocalString(oModule,"NWNX!INIT","1"); 
		
		//SQL initialization
		SQLInit();

		//SQLInit takes some time, please wait...
		DelayCommand(3.0, InitServer());
	}
	else 
	{
		DeleteLocalInt(oModule, "PRCCACHE_CC");
		DeleteLocalInt(oModule, "HaveSQLServer");
	}
}
