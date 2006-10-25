// check if UMD and animal empathy can be taken
// find the cls_skill_***2da

// do an sql query to see if that skill is there
string sSkillAnimalEmpathy = "0"; // as int 0 is the same as a non existant row
string sSKillUMD = IntToString(SKILL_TYPE_UMD); // check const name

/*
 * SELECT SkillIndex FROM <cls_feat_***>
 * WHERE SkillIndex = <AE> OR SkillIndex = <UMD>
 */

if (PRC_SQLFetch() == SQL_SUCCESS && PRC_SQLGetData(1) == "0") // check it was the right skill
	SetLocalInt(OBJECT_SELF, "bHasAnimalEmpathy", TRUE);

if (PRC_SQLFetch() == SQL_SUCCESS && PRC_SQLGetData(1) == IntToString(SKILL_TYPE_UMD)) // check it was the right skill
	SetLocalInt(OBJECT_SELF, "bHasUMD", TRUE);


// messing with the feat loop function

	//get some stored data
    object oPC = OBJECT_SELF;
	int nSex = GetLocalInt(oPC, "Gender");
	int nRace = GetLocalInt(oPC, "Race");
	int nClass = GetLocalInt(oPC, "Class");
    int nStr = GetLocalInt(oPC, "Str");
    int nDex = GetLocalInt(oPC, "Dex");
    int nCon = GetLocalInt(oPC, "Con");
    int nInt = GetLocalInt(oPC, "Int");
    int nWis = GetLocalInt(oPC, "Wis");
    int nCha = GetLocalInt(oPC, "Cha"); 
    int nOrder = GetLocalInt(oPC, "LawfulChaotic");
    int nMoral = GetLocalInt(oPC, "GoodEvil");

    //add racial ability alterations
    nStr += StringToInt(Get2DACache("racialypes", "StrAdjust", nRace));
    nDex += StringToInt(Get2DACache("racialypes", "DexAdjust", nRace));
    nCon += StringToInt(Get2DACache("racialypes", "ConAdjust", nRace));
    nInt += StringToInt(Get2DACache("racialypes", "IntAdjust", nRace));
    nWis += StringToInt(Get2DACache("racialypes", "WisAdjust", nRace));
    nCha += StringToInt(Get2DACache("racialypes", "ChaAdjust", nRace));

	// gets the BAB
	/* TODO check for right 2da line */
	int nBAB = StringToInt(Get2DACache(Get2DACache("classes", "AttackBonusTable",nClass),"BAB",1));
	
	// get caster level
	int nCasterLevel = 0;
    if(nClass == CLASS_TYPE_WIZARD
        || nClass == CLASS_TYPE_SORCERER
        || nClass == CLASS_TYPE_BARD
        || nClass == CLASS_TYPE_CLERIC
        || nClass == CLASS_TYPE_DRUID)
        nCasterLevel = 1;

	// fortitude save
	/* TODO check for right 2da line */
    int nFortSave = StringToInt(Get2DACache(Get2DACache("classes","SavingThrowTable" , nClass), "FortSave", 1));

	// and the sql statement
	/* 
	SELECT `rowid`, `feat`, `PREREQFEAT1`, `PREREQFEAT2`, `OrReqFeat0`, `OrReqFeat1`, `OrReqFeat2`, `OrReqFeat3`, `OrReqFeat4`,
		`REQSKILL`, `REQSKILL2`, `ReqSkillMinRanks`, `ReqSkillMinRanks2`
	FROM `prc_cached2da_feat`
	WHERE (`feat` != '****') AND (`PreReqEpic` != 1)
	AND (`MinLevel` = '****' OR `MinLevel` = '1')
	AND `ALLCLASSESCANUSE` = 1
	AND `minattackbonus` <= <nBAB>
	AND `minspelllvl` = 1
	AND `minstr`<= <nStr>
	AND `mindex`<= <nDex>
	AND `mincon`<= <nCon>
	AND `minint`<= <nInt>
	AND `minwis`<= <nWis>
	AND `mincha`<= <nCha>
	AND `MinFortSave` <= <nFortSave>
	*/


        string sSQL = "SELECT "+q+"rowid"+q+", "+q+"FEAT"+q+", "+q+"PREREQFEAT1"+q+", "+q+"PREREQFEAT2"+q+", "
		+q+"OrReqFeat0"+q+", "+q+"OrReqFeat1"+q+", "+q+"OrReqFeat2"+q+", "+q+"OrReqFeat3"+q+", "+q+"OrReqFeat4"+q+", "
		+q+"REQSKILL"+q+", "+q+"REQSKILL2"+q+", "+q+"ReqSkillMinRanks"+q+", "+q+"ReqSkillMinRanks2"+q+
		" FROM "+q+"prc_cached2da_feat"+q+
        " WHERE ("+q+"FEAT"+q+" != '****') AND ("+q+"PreReqEpic"+q+" != 1)"
			+" AND ("+q+"MinLevel"+q+" = '****' OR "+q+"MinLevel"+q+" = '1')"
            +" AND ("+q+"ALLCLASSESCANUSE"+q+" = 1)"
            +" AND ("+q+"MINATTACKBONUS"+q+" <= "+IntToString(nBAB)+")"
            +" AND ("+q+"MINSPELLLVL"+q+" <= "+IntToString(nCasterLevel)+")"
            +" AND ("+q+"MINSTR"+q+" <= "+IntToString(nStr)+")"
            +" AND ("+q+"MINDEX"+q+" <= "+IntToString(nDex)+")"
            +" AND ("+q+"MINCON"+q+" <= "+IntToString(nCon)+")"
            +" AND ("+q+"MININT"+q+" <= "+IntToString(nInt)+")"
            +" AND ("+q+"MINWIS"+q+" <= "+IntToString(nWis)+")"
            +" AND ("+q+"MINCHA"+q+" <= "+IntToString(nCha)+")"
            +" AND ("+q+"MinFortSave"+q+" <= "+IntToString(nFortSave)+")"
            +" LIMIT "+IntToString(iMax)+" OFFSET "+IntToString(i);

	PRC_SQLExecDirect(SQL);
    int bAtLeastOneResult; // need to know if the query worked
while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
{
		bAtLeastOneResult = TRUE;
	    int nRow = StringToInt(PRC_SQLGetData(1));
        int nStrRef = StringToInt(PRC_SQLGetData(2));
        string sName = GetStringByStrRef(nStrRef);
        string sPreReqFeat1 = PRC_SQLGetData(3);
        string sPreReqFeat2 = PRC_SQLGetData(4);
        string sOrReqFeat0 = PRC_SQLGetData(5);
        string sOrReqFeat1 = PRC_SQLGetData(6);
        string sOrReqFeat2 = PRC_SQLGetData(7);
        string sOrReqFeat3 = PRC_SQLGetData(8);
        string sOrReqFeat4 = PRC_SQLGetData(9);
        string sReqSkill = PRC_SQLGetData(10);
        string sReqSkill2 = PRC_SQLGetData(11);
        string sReqSkillRanks = PRC_SQLGetData(12);
        string sReqSkillRanks2 = PRC_SQLGetData(13);

	// prereq testing first	
	// AND prereq
	int GetMeetsANDPreReq(string sPreReqFeat1, string sPreReqFeat2)	
	{
		// are there any prereq?
		if (sPreReqFeat1 == '****' && sPreReqFeat2 == '****')
			return TRUE;
		// test if the PC meets the first prereq
		// if not, exit
		if(!ANDPreReqFeatArrayLoop(StringToInt(sPreReqFeat1)))
			return FALSE;
		// got this far, then the first prereq was met
		// is there a second prereq? If not, done
		if (sPreReqFeat2 == '****')
			return TRUE;
		// test if the PC meets the second one
		if(!ANDPreReqFeatArrayLoop(StringToInt(sPreReqFeat2)))
			return FALSE;
		// got this far, so second one matched too
		return TRUE;
	}

	// AND feat array loop
	int ANDPreReqFeatArrayLoop(int nPreReqFeat)
	{
		// as alertness is stored in the array as -1
		if (nPreReqFeat == 0)
			nPreReqFeat == -1;
		int i = 0;
		do
		{
			nFeat  = get_array_int(OBJECT_SELF, "Feat", i);
			i++;
			// if we get to the end of the array here,
			// then there's been no match
			if (i == array_get_size(OBJECT_SELF, "Feats"))
				return FALSE;
		} while(nFeat != nPreReqFeat);
		// got this far, so must have a match
		return TRUE;
	}


	// OR prereq
	int GetMeetsORPreReq(string sOrReqFeat0, string sOrReqFeat1, string sOrReqFeat2, string sOrReqFeat3, string sOrReqFeat4)
	{
		// are there any prereq
		if (OrReqFeat0 == '****')
			return TRUE;
		// first one
		if(ORPreReqFeatArrayLoop(StringToInt(sOrReqFeat0)))
			return TRUE;
		// second one
		if(ORPreReqFeatArrayLoop(StringToInt(sOrReqFeat1)))
			return TRUE;
		// third one
		if(ORPreReqFeatArrayLoop(StringToInt(sOrReqFeat2)))
			return TRUE;
		// 4th one
		if(ORPreReqFeatArrayLoop(StringToInt(sOrReqFeat3)))
			return TRUE;
		// 5th one
		if(ORPreReqFeatArrayLoop(StringToInt(sOrReqFeat4)))
			return TRUE;
		// no match
		return FALSE;
	}

	// 
	// OR feat array loop
	int ORPreReqFeatArrayLoop(int nOrReqFeat)
	{
		// as alertness is stored in the array as -1
		if (nOrReqFeat == 0)
			nOrReqFeat == -1;
		int i = 0;
		while (i != array_get_size(OBJECT_SELF, "Feats"))
		{
			int nFeat  = get_array_int(OBJECT_SELF, "Feat", i);
			if(nFeat == nOrReqFeat) // if there's a match, the prereq are met
				return TRUE;
			i++;
		}
		// otherwise no match
		return FALSE;
	}


int GetMeetSkillPrereq(string sReqSkill, string sReqSkill2, string sReqSkillRanks,  string sReqSkillRanks2)
{
    if(sReqSkill == "****" && sReqSkill2 == "****")
        return TRUE;
    // test if the PC meets the first prereq
    if(!CheckSkillPrereq(sReqSkill, sReqSkillRanks))
        return FALSE;
    
    // got this far, then the first prereq was met
	// is there a second prereq? If not, done
    if(sReqSkill2 = "****")
        return TRUE;
    if(!CheckSkillPrereq(sReqSkill2, sReqSkillRanks2))
        return FALSE;
    // got this far, so second one matched too
    return TRUE;
}

int CheckSkillPrereq(string sReqSkill, string sReqSkillRanks)
{
    // for skill focus feats
    if (sReqSkillRanks == "0" || sReqSkillRanks == "****") // then it just requires being able to put points in the skill
    {
        // if requires animal empathy, but the PC can't take ranks in it
        if(sReqSkill == "0" && !GetLocalInt(OBJECT_SELF, "bHasAnimalEmpathy"))
            return FALSE;
        // if requires UMD, but the PC can't take ranks in it
        if(sReqSkill == IntToString(SKILL_USE_MAGIC_DEVICE) && !GetLocalInt(OBJECT_SELF, "bHasUMD"))
            return FALSE;
    }
    else // test if the PC has enough ranks in the skill
    {
        int nSkillPoints = array_get_int(OBJECT_SELF, "Skills", StringToInt(sReqSkill));
        if (nSkillPoints < StringToInt(sReqSkillRanks)
            return FALSE;
    }
    // get this far then not failed any fo the prereq
    return TRUE;
}
