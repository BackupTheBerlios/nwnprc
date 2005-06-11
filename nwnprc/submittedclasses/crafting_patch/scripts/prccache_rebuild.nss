//:://///////////////////////////////////////////////////////
//:: PRC 2DA caching system
//:: 2DA cache rebuild script
//:: prccache_rebuild
//::
//:: This file is licensed under the terms of the
//:: GNU GENERAL PUBLIC LICENSE (GPL) Version 2
//::
//:: Created By: Guido Imperiale (CRVSADER//KY)
//:: Created On: January 25, 2004
//::
//:: The SQL cache of the 2DAs is out of date, rebuild it
//:: NOTE: extensively using DelayCommand() to avoid timeouts
//::
//:://///////////////////////////////////////////////////////


#include "prccache"


//block size to process some 2DAs
//decrease it if the script crashes for timeout
const int PRCCACHE_BLOCKSIZE = 20;

//block size for item_to_ireq.2da
const int PRCCACHE_ITEMTOIREQ_BLOCKSIZE = 100;


//Various stages (generally, one per table type)
void Stage2();
void Stage3();
void Stage4();
void Stage5();
void Stage6();
void Stage7();
void Stage8();
void StageEnd();


struct query_entries {
    string fields;
    string data;
    string last_value;
};

//add a query parameter, if existing
struct query_entries add_param(struct query_entries query, string sTable, int nRow, string sColumn, string sLabel="");


//caching functions
void cache_cls_feat  (string sTable);
void cache_cls_skill (string sTable);
void cache_cls_bfeat (string sTable);
void cache_reqs      (string sTable);
void cache_class     (int row);
void cache_race_feat (string sTable);
void cache_race      (int row);
void cache_portrait  (int row);
void cache_soundset  (int row);


void main()
{
    PrintString("Rebuilding the PRC 2DA cache. This will take around 1 to 10 minutes, depending on your server settings. Please wait...");

	//Since we have to return the control to the program several times, disable the 2DA cache until finished
	SetLocalInt(GetModule(), "PRC_USE_SQL", FALSE);
	
    //Destroy tables and recreate them from scratch
    PrintString("Stage 1: Generating basic tables");
    
    SQLExecDirect("DROP TABLE IF EXISTS `prccache`");
    SQLExecDirect("DROP TABLE IF EXISTS `prccache_classes`");
    SQLExecDirect("DROP TABLE IF EXISTS `prccache_cls_feat`");
    SQLExecDirect("DROP TABLE IF EXISTS `prccache_cls_skill`");
    SQLExecDirect("DROP TABLE IF EXISTS `prccache_feat`");
    SQLExecDirect("DROP TABLE IF EXISTS `prccache_portraits`");
    SQLExecDirect("DROP TABLE IF EXISTS `prccache_race_feat`");
    SQLExecDirect("DROP TABLE IF EXISTS `prccache_racialtypes`");
    SQLExecDirect("DROP TABLE IF EXISTS `prccache_reqs`");
    SQLExecDirect("DROP TABLE IF EXISTS `prccache_soundset`");
    SQLExecDirect("DROP TABLE IF EXISTS `prccache_spells`");

    SQLExecDirect("CREATE TABLE `prccache` ("
        + "  `ID` int(11) NOT NULL auto_increment,"
        + "  `file` varchar(16) NOT NULL default '',"
        + "  `row` int(11) default NULL,"
        + "  `column` varchar(255) default NULL,"
        + "  `data` varchar(255) default NULL,"
        + "  PRIMARY KEY  (`ID`),"
        + "  KEY `file` (`file`)"
        + ") TYPE=MyISAM AUTO_INCREMENT=1");

    SQLExecDirect("CREATE TABLE `prccache_reqs` ("
        + "  `ID` int(11) NOT NULL auto_increment,"
        + "  `file` varchar(16) NOT NULL default '',"
        + "  `ReqType` varchar(255) default NULL,"
        + "  `ReqParam1` varchar(255) default NULL,"
        + "  `ReqParam2` varchar(255) default NULL,"
        + "  PRIMARY KEY  (`ID`),"
        + "  KEY `file` (`file`)"
        + ") TYPE=MyISAM AUTO_INCREMENT=1");

    DelayCommand(0.0, Stage2());	
}



//process PRCCACHE_ITEMTOIREQ_BLOCKSIZE lines at a time
void __Stage2_block(int row)
{
	int i;
	for (i = 0; i < PRCCACHE_ITEMTOIREQ_BLOCKSIZE; i++) {
    	string sIreq = Get2DAString("item_to_ireq", "RECIPE_TAG", row + i);
    	if (sIreq != "")
        	DelayCommand(0.0, cache_reqs(sIreq));
	}
}


void Stage2()
{
    //ireq_*.2da
	PrintString("Stage 2: Building cache for ireq_*.2da");

	int row;
    for (row = 0; row <= ITEM_TO_IREQ_2DA_END; row += PRCCACHE_ITEMTOIREQ_BLOCKSIZE)
		DelayCommand(0.0, __Stage2_block(row));

	
	if (PRCCACHE_CC)
    	DelayCommand(0.0, Stage3());
	else
		DelayCommand(0.0, StageEnd());
}


void Stage3()
{
    PrintString("Stage 3: Generating tables for the Character Creator");

    SQLExecDirect("CREATE TABLE `prccache_racialtypes` ("
        + "  `row` int(11) NOT NULL default '0',"
        + "  `name` int(11) default NULL,"
        + "  `description` int(11) default NULL,"
        + "  `appearance` int(11) default NULL,"
        + "  `stradjust` int(4) default NULL,"
        + "  `dexadjust` int(4) default NULL,"
        + "  `intadjust` int(4) default NULL,"
        + "  `chaadjust` int(4) default NULL,"
        + "  `wisadjust` int(4) default NULL,"
        + "  `conadjust` int(4) default NULL,"
        + "  `featstable` varchar(16) default NULL,"
        + "  PRIMARY KEY  (`row`)"
        + ") TYPE=MyISAM");

    SQLExecDirect("CREATE TABLE `prccache_race_feat` ("
        + "  `ID` int(11) NOT NULL auto_increment,"
        + "  `file` varchar(16) NOT NULL default '',"
        + "  `featindex` int(11) default NULL,"
        + "  PRIMARY KEY  (`ID`),"
        + "  KEY `file` (`file`)"
        + ") TYPE=MyISAM AUTO_INCREMENT=1");

    SQLExecDirect("CREATE TABLE `prccache_classes` ("
        + "  `row` int(11) NOT NULL default '0',"
        + "  `name` int(11) default NULL,"
        + "  `description` int(11) default NULL,"
        + "  `icon` varchar(255) default NULL,"
        + "  `hitdie` int(4) default NULL,"
        + "  `bab` int(1) default NULL,"
        + "  `featstable` varchar(16) default NULL,"
        + "  `fortsave` int(2) default NULL,"
        + "  `refsave` int(2) default NULL,"
        + "  `willsave` int(2) default NULL,"
        + "  `skillstable` varchar(16) default NULL,"
        + "  `bonusfeats` int(2) default NULL,"
        + "  `skillpointbase` int(4) default NULL,"
        + "  `spellgaintable` varchar(16) default NULL,"
        + "  `spellknowntable` varchar(16) default NULL,"
        + "  `spellcaster` int(1) default NULL,"
        + "  `alignrestrict` varchar(4) default NULL,"
        + "  `alignrstrcttype` varchar(4) default NULL,"
        + "  `invertrestrict` int(1) default NULL,"
        + "  `prereqtable` varchar(16) default NULL,"
        + "  PRIMARY KEY  (`row`)"
        + ") TYPE=MyISAM");

    SQLExecDirect("CREATE TABLE `prccache_cls_feat` ("
        + "  `ID` int(11) NOT NULL auto_increment,"
        + "  `file` varchar(16) NOT NULL default '',"
        + "  `featindex` int(11) default NULL,"
        + "  `list` int(11) default NULL,"
        + "  `grantedonlevel` int(1) default NULL,"
        + "  `onmenu` int(1) default NULL,"
        + "  PRIMARY KEY  (`ID`),"
        + "  KEY `file` (`file`)"
        + ") TYPE=MyISAM AUTO_INCREMENT=1");

    SQLExecDirect("CREATE TABLE `prccache_cls_skill` ("
        + "  `ID` int(11) NOT NULL auto_increment,"
        + "  `file` varchar(16) NOT NULL default '',"
        + "  `skillindex` int(11) default NULL,"
        + "  `classskill` int(1) default NULL,"
        + "  PRIMARY KEY  (`ID`),"
        + "  KEY `file` (`file`)"
        + ") TYPE=MyISAM AUTO_INCREMENT=1");

    SQLExecDirect("CREATE TABLE `prccache_portraits` ("
        + "  `row` int(11) NOT NULL default '0',"
        + "  `baseresref` varchar(16) default NULL,"
        + "  `sex` int(11) default NULL,"
        + "  `race` int(11) default NULL,"
        + "  PRIMARY KEY  (`row`)"
        + ") TYPE=MyISAM");

    SQLExecDirect("CREATE TABLE `prccache_soundset` ("
        + "  `row` int(11) NOT NULL default '0',"
        + "  `resref` varchar(16) default NULL,"
        + "  `strref` int(11) default NULL,"
        + "  `gender` int(4) default NULL,"
        + "  `type` int(4) default NULL,"
        + "  PRIMARY KEY  (`row`)"
        + ") TYPE=MyISAM");

    SQLExecDirect("CREATE TABLE `prccache_feat` ("
        + "  `row` int(11) NOT NULL default '0',"
        + "  `label` varchar(255) default NULL,"
        + "  `feat` int(11) default NULL,"
        + "  `description` int(11) default NULL,"
        + "  `icon` varchar(255) default NULL,"
        + "  `minattackbonus` int(11) default NULL,"
        + "  `minstr` int(4) default NULL,"
        + "  `mindex` int(4) default NULL,"
        + "  `minint` int(4) default NULL,"
        + "  `mincon` int(4) default NULL,"
        + "  `minwis` int(4) default NULL,"
        + "  `mincha` int(4) default NULL,"
        + "  `minspelllvl` int(4) default NULL,"
        + "  `prereqfeat1` int(11) default NULL,"
        + "  `prereqfeat2` int(11) default NULL,"
        + "  `gainmultiple` int(1) default NULL,"
        + "  `effectsstack` int(1) default NULL,"
        + "  `allclassescanuse` int(1) default NULL,"
        + "  `category` int(11) default NULL,"
        + "  `maxcr` int(4) default NULL,"
        + "  `spellid` int(11) default NULL,"
        + "  `successor` int(11) default NULL,"
        + "  `crvalue` int(11) default NULL,"
        + "  `usesperday` int(11) default NULL,"
        + "  `masterfeat` int(11) default NULL,"
        + "  `targetself` int(1) default NULL,"
        + "  `orreqfeat0` int(11) default NULL,"
        + "  `orreqfeat1` int(11) default NULL,"
        + "  `orreqfeat2` int(11) default NULL,"
        + "  `orreqfeat3` int(11) default NULL,"
        + "  `orreqfeat4` int(11) default NULL,"
        + "  `reqskill` int(11) default NULL,"
        + "  `reqskillminranks` int(11) default NULL,"
        + "  `reqskill2` int(11) default NULL,"
        + "  `reqskillminranks2` int(11) default NULL,"
        + "  `constant` varchar(255) default NULL,"
        + "  `toolscategories` int(11) default NULL,"
        + "  `hostilefeat` int(1) default NULL,"
        + "  `minlevel` int(4) default NULL,"
        + "  `minlevelclass` int(11) default NULL,"
        + "  `maxlevel` int(4) default NULL,"
        + "  `minfortsave` int(11) default NULL,"
        + "  `prereqepic` int(1) default NULL,"
        + "  PRIMARY KEY  (`row`)"
        + ") TYPE=MyISAM");

    SQLExecDirect("CREATE TABLE `prccache_spells` ("
        + "  `row` int(11) NOT NULL default '0',"
        + "  `label` varchar(255) default NULL,"
        + "  `name` int(11) default NULL,"
        + "  `iconresref` varchar(16) default NULL,"
        + "  `school` char(1) default NULL,"
        + "  `range` char(1) default NULL,"
        + "  `vs` char(3) default NULL,"
        + "  `metamagic` varchar(4) default NULL,"
        + "  `targettype` varchar(4) default NULL,"
        + "  `impactscript` varchar(16) default NULL,"
        + "  `bard` int(4) default NULL,"
        + "  `cleric` int(4) default NULL,"
        + "  `druid` int(4) default NULL,"
        + "  `paladin` int(4) default NULL,"
        + "  `ranger` int(4) default NULL,"
        + "  `wiz_sorc` int(4) default NULL,"
        + "  `innate` int(4) default NULL,"
        + "  `conjtime` int(11) default NULL,"
        + "  `conjanim` varchar(4) default NULL,"
        + "  `conjheadvisual` varchar(16) default NULL,"
        + "  `conjhandvisual` varchar(16) default NULL,"
        + "  `conjgrndvisual` varchar(16) default NULL,"
        + "  `conjsoundvfx` varchar(16) default NULL,"
        + "  `conjsoundmale` varchar(16) default NULL,"
        + "  `conjsoundfemale` varchar(16) default NULL,"
        + "  `castanim` varchar(16) default NULL,"
        + "  `casttime` int(11) default NULL,"
        + "  `castheadvisual` varchar(16) default NULL,"
        + "  `casthandvisual` varchar(16) default NULL,"
        + "  `castgrndvisual` varchar(16) default NULL,"
        + "  `castsound` varchar(16) default NULL,"
        + "  `proj` int(4) default NULL,"
        + "  `projmodel` varchar(16) default NULL,"
        + "  `projtype` varchar(16) default NULL,"
        + "  `projspwnpoint` varchar(16) default NULL,"
        + "  `projsound` varchar(16) default NULL,"
        + "  `projorientation` varchar(16) default NULL,"
        + "  `immunitytype` varchar(255) default NULL,"
        + "  `itemimmunity` int(4) default NULL,"
        + "  `subradspell1` int(11) default NULL,"
        + "  `subradspell2` int(11) default NULL,"
        + "  `subradspell3` int(11) default NULL,"
        + "  `subradspell4` int(11) default NULL,"
        + "  `subradspell5` int(11) default NULL,"
        + "  `category` int(11) default NULL,"
        + "  `master` int(11) default NULL,"
        + "  `usertype` int(11) default NULL,"
        + "  `spelldesc` int(11) default NULL,"
        + "  `useconcentration` int(1) default NULL,"
        + "  `spontaneouslycast` int(1) default NULL,"
        + "  `altmessage` int(11) default NULL,"
        + "  `hostilesetting` int(1) default NULL,"
        + "  `featid` int(11) default NULL,"
        + "  `counter1` int(11) default NULL,"
        + "  `counter2` int(11) default NULL,"
        + "  `hasprojectile` int(1) default NULL,"
        + "  PRIMARY KEY  (`row`)"
        + ") TYPE=MyISAM");
    
	DelayCommand(0.0, Stage4());
}


void Stage4()
{
    //classes.2da
    //cls_bfeat_*.2da
    //cls_feat_*.2da
    //cls_skill_*.2da
	
	PrintString("Stage 4: Building cache for classes.2da, cls_bfeat_*.2da, cls_feat_*.2da and cls_skill_*.2da");

	//FIXME: some base classes have PREREQ_TABLEs:
	//   LABEL       ReqType    ReqParam1             ReqParam2    
	//0  ScriptVar   VAR        PRC_AllowArcherCore   0           

	int row;
    for (row = 0; row <= CLASS_2DA_END; row++)
		DelayCommand(0.0, cache_class(row));
	
    DelayCommand(0.0, Stage5());
}


void Stage5()
{
    //racialtypes.2da
    //race_feat_*.2da
	PrintString("Stage 5: Building cache for racialtypes.2da and race_feat_*.2da");

   	int row;
    for (row = 0; row <= RACE_2DA_END; row++)
   	    DelayCommand(0.0, cache_race(row));
	
    DelayCommand(0.0, Stage6());
}


//process PRCCACHE_BLOCKSIZE lines at a time
void __Stage6_block(int row)
{
	if (row % 500 == 0)
		PrintString("done " + IntToString(row) + " out of " + IntToString(PORTRAITS_2DA_END));

	int i;
	for (i = 0; i < PRCCACHE_BLOCKSIZE; i++)
		cache_portrait(row + i);
}


void Stage6()
{
    //portraits.2da
    PrintString("Stage 6: Building cache for portraits.2da");

	int row;
    for (row = 0; row <= PORTRAITS_2DA_END; row += PRCCACHE_BLOCKSIZE)
		DelayCommand(0.0, __Stage6_block(row));
	
    DelayCommand(0.0, Stage7());
}


void Stage7()
{
	//soundset.2da
	PrintString("Stage 7: Building cache for soundset.2da");
    int row;
   	for (row = 0; row <= SOUNDSET_2DA_END; row++)
		DelayCommand(0.0, cache_soundset(row));
	
    DelayCommand(0.0, Stage8());
}


//process PRCCACHE_BLOCKSIZE lines at a time
void __Stage8_block(int row)
{
	if (row % 500 == 0)
		PrintString("done " + IntToString(row) + " out of " + IntToString(APPEARANCE_2DA_END));

	int i;
	for (i = 0; i < PRCCACHE_BLOCKSIZE; i++)
		Set2DACache("appearance", "string_ref", row + i);
}


void Stage8()
{
    //appearance.2da (partial)
    PrintString("Stage 8: Building partial cache for appearance.2da");

	int row;
    for (row = 0; row <= APPEARANCE_2DA_END; row += PRCCACHE_BLOCKSIZE)
    	DelayCommand(0.0, __Stage8_block(row));
	
    DelayCommand(0.0, StageEnd());
}


void StageEnd()
{
	PrintString("Registering 2DA version...");
	
    //Finally, save the PRC Version
	Set2DACache("prc_version", "NWNVersion", 0);
	Set2DACache("prc_version", "PRCVersion", 0);
	Set2DACache("prc_version", "ModVersion", 0);
	
	//re-enable 2DA caching
	SetLocalInt(GetModule(), "PRC_USE_SQL", TRUE);
	
    PrintString("Rebuild complete.");
}


//add a query parameter, if existing
struct query_entries add_param(struct query_entries query, string sTable, int nRow, string sColumn, string sLabel="")
{
    string sValue = Get2DAString(sTable, sColumn, nRow);
    if (sValue != "") {
		if (sLabel=="")
			sLabel = sColumn;

        //not NULL, let's add it
        if (query.fields != "") {
            query.fields += ",`" + GetStringLowerCase(sLabel) + "`";
            query.data   += ",'" + SQLEncodeSpecialChars(sValue) + "'";
        } else {
            query.fields = "`" + GetStringLowerCase(sLabel) + "`";
            query.data   = "'" + SQLEncodeSpecialChars(sValue) + "'";
        }
    }

    query.last_value = sValue;
    return query;
}


//cache cls_pres_*.2da or ireq_*.2da
void cache_reqs(string sTable)
{
	string eTable = SQLEncodeSpecialChars(GetStringLowerCase(sTable));
	
	//Check for duplicates
	SQLExecDirect("SELECT file FROM prccache_reqs WHERE file='" + eTable + "' LIMIT 1");
	if (SQLFetch() == SQL_SUCCESS)
		return;
	
    struct query_entries query;
    int row;

    for (row = 0; row <= PREREQ_2DA_END; row++) {
        query.fields = "";
        query.data = "";

        query = add_param(query, sTable, row, "reqtype");
        if (query.last_value == "")
            continue;       //no data on this line

        query = add_param(query, sTable, row, "reqparam1");
        query = add_param(query, sTable, row, "reqparam2");

        string sQuery = "INSERT INTO prccache_reqs (file," + query.fields + ") VALUES ('" + eTable + "'," + query.data + ")";
        SQLExecDirect(sQuery);
    }
}


//cache cls_feat_*.2da
void cache_cls_feat(string sTable)
{
	string eTable = SQLEncodeSpecialChars(GetStringLowerCase(sTable));
	
	//Check for duplicates
	SQLExecDirect("SELECT file FROM prccache_cls_feat WHERE file='" + eTable + "' LIMIT 1");
	if (SQLFetch() == SQL_SUCCESS)
		return;
	
    struct query_entries query;
    int row;
    
    for (row = 0; row <= CLASS_FEAT_2DA_END; row++) {
	    query.fields = "";
	    query.data = "";

	    query = add_param(query, sTable, row, "featindex"     );
    	if (query.last_value == "")
	        continue;       //no data on this line

	    query = add_param(query, sTable, row, "list"          );
    	query = add_param(query, sTable, row, "grantedonlevel");
	    query = add_param(query, sTable, row, "onmenu"        );

	    string sQuery = "INSERT INTO prccache_cls_feat (file," + query.fields + ") VALUES ('" + eTable + "'," + query.data + ")";
    	SQLExecDirect(sQuery);
    }
}


//cache cls_skill_*.2da
void cache_cls_skill(string sTable)
{
	string eTable = SQLEncodeSpecialChars(GetStringLowerCase(sTable));
	
	//Check for duplicates
	SQLExecDirect("SELECT file FROM prccache_cls_skill WHERE file='" + eTable + "' LIMIT 1");
	if (SQLFetch() == SQL_SUCCESS)
		return;

    struct query_entries query;
    int row;

    for (row = 0; row <= CLASS_SKILLS_2DA_END; row++) {
	    query.fields = "";
	    query.data = "";

	    query = add_param(query, sTable, row, "skillindex"           );
	    if (query.last_value == "")
        	continue;       //no data on this line

    	query = add_param(query, sTable, row, "classskill"           );

	    string sQuery = "INSERT INTO prccache_cls_skill (file," + query.fields + ") VALUES ('" + eTable + "'," + query.data + ")";
	    SQLExecDirect(sQuery);
	}
}


//cache one row from classes.2da
void cache_class(int row)
{
    struct query_entries query;

    query.fields = "";
    query.data = "";

	if (Get2DAString("classes", "playerclass", row) != "1")
		return;
		
	if (Get2DAString("classes", "epiclevel", row) != "-1")
		return;

    query = add_param(query, "classes", row, "name"            );
    if (query.last_value == "")
        return;       //no data on this line

    query = add_param(query, "classes", row, "description"     );
    query = add_param(query, "classes", row, "icon"            );
    query = add_param(query, "classes", row, "hitdie"          );

    query = add_param(query, Get2DAString("classes", "attackbonustable", row), 0, "bab");

    query = add_param(query, "classes", row, "featstable"      );
    if (query.last_value != "")
    	DelayCommand(0.0, cache_cls_feat(query.last_value));

	string sSavingThrowTable = Get2DAString("classes", "savingthrowtable", row);
    query = add_param(query, sSavingThrowTable, 0, "fortsave");
    query = add_param(query, sSavingThrowTable, 0, "refsave" );
    query = add_param(query, sSavingThrowTable, 0, "willsave");

    query = add_param(query, "classes", row, "skillstable"     );
    if (query.last_value != "")
    	DelayCommand(0.0, cache_cls_skill(query.last_value));

    query = add_param(query, Get2DAString("classes", "bonusfeatstable", row), 0, "bonus", "bonusfeats");

    query = add_param(query, "classes", row, "skillpointbase"  );
    query = add_param(query, "classes", row, "spellgaintable"  );
    query = add_param(query, "classes", row, "spellknowntable" );
    query = add_param(query, "classes", row, "spellcaster"     );
    query = add_param(query, "classes", row, "alignrestrict"   );
    query = add_param(query, "classes", row, "alignrstrcttype" );
    query = add_param(query, "classes", row, "invertrestrict"  );
    query = add_param(query, "classes", row, "prereqtable"     );

    if (query.last_value != "")
    	DelayCommand(0.0, cache_reqs(query.last_value));

    string sQuery = "INSERT INTO prccache_classes (row," + query.fields + ") VALUES (" + IntToString(row) + "," + query.data + ")";
    SQLExecDirect(sQuery);
}


//cache a race_feat_*.2da
void cache_race_feat(string sTable)
{
	string eTable = SQLEncodeSpecialChars(GetStringLowerCase(sTable));
	
	//Check for duplicates
	SQLExecDirect("SELECT file FROM prccache_race_feat WHERE file='" + eTable + "' LIMIT 1");
	if (SQLFetch() == SQL_SUCCESS)
		return;

    int row;
    struct query_entries query;

    for (row = 0; row <= RACE_FEAT_2DA_END; row++) {
        query.fields = "";
        query.data = "";
        query = add_param(query, sTable, row, "featindex");

        if (query.last_value == "")
            continue;       //no data on this line

        string sQuery = "INSERT INTO prccache_race_feat (file," + query.fields + ") VALUES ('" + eTable + "'," + query.data + ")";
        SQLExecDirect(sQuery);
    }
}


//cache one row from racialtypes.2da
void cache_race(int row)
{
    struct query_entries query;
    query.fields = "";
    query.data = "";

	if (Get2DAString("racialtypes", "playerrace", row) != "1")
		return;

    query = add_param(query, "racialtypes", row, "name"               );
    if (query.last_value == "")
	    return;       //no data on this line

    query = add_param(query, "racialtypes", row, "description"        );
    query = add_param(query, "racialtypes", row, "appearance"         );
    query = add_param(query, "racialtypes", row, "stradjust"          );
    query = add_param(query, "racialtypes", row, "dexadjust"          );
    query = add_param(query, "racialtypes", row, "conadjust"          );
    query = add_param(query, "racialtypes", row, "intadjust"          );
    query = add_param(query, "racialtypes", row, "wisadjust"          );
    query = add_param(query, "racialtypes", row, "chaadjust"          );

    query = add_param(query, "racialtypes", row, "featstable"         );
    if (query.last_value != "")
    	DelayCommand(0.0, cache_race_feat(query.last_value));

    string sQuery = "INSERT INTO prccache_racialtypes (row," + query.fields + ") VALUES (" + IntToString(row) + "," + query.data + ")";
    SQLExecDirect(sQuery);
}


void cache_portrait(int row)
{
    struct query_entries query;
    query.fields = "";
    query.data = "";
    
	if (Get2DAString("portraits", "inanimatetype", row) != "")
		return;

	query = add_param(query, "portraits", row, "baseresref"    );

    if (query.last_value == "")
        return;       //no data on this line

    query = add_param(query, "portraits", row, "sex"           );
    query = add_param(query, "portraits", row, "race"          );

    string sQuery = "INSERT INTO prccache_portraits (row," + query.fields + ") VALUES (" + IntToString(row) + "," + query.data + ")";
    SQLExecDirect(sQuery);
}


void cache_soundset(int row)
{
    struct query_entries query;
    query.fields = "";
    query.data = "";
    
    query = add_param(query, "soundset", row, "resref"         );

    if (query.last_value == "")
    	return;       //no data on this line

    query = add_param(query, "soundset", row, "strref"         );
    query = add_param(query, "soundset", row, "gender"         );
    query = add_param(query, "soundset", row, "type"           );

    string sQuery = "INSERT INTO prccache_soundset (row," + query.fields + ") VALUES (" + IntToString(row) + "," + query.data + ")";
    SQLExecDirect(sQuery);
}
