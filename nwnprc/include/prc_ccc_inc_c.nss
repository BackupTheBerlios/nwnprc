#include "inc_utility"
#include "prc_inc_racial"
#include "prc_ccc_inc_d"

//the various delayed loops
//used when lots of intructions needed
//causes extreme lag

void PortraitLoop();
void FeatLoop();
void ClassLoop();
void SoundsetLoop();
void SpellLoop();
void SkillLoop();
void BonusFeatLoop();
void AppearanceLoop();
void SoundsetLoop();
void WingLoop();
void TailLoop();

//this doenst feedback into the main convo
void DoClassFeat(string sClassFeatTable, int i=0);

void ClassLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    if(GetLocalInt(OBJECT_SELF, "DynConv_Waiting") == FALSE)
        return;
    if(i < CLASS_2DA_END)
    {
        if(CheckClassRequirements(i))
        {
            string sName = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", i)));
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                   sName);
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                   i);
        }
        i++;
        SetLocalInt(OBJECT_SELF, "i", i);
        if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
        {
            int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(CLASS_2DA_END));
            FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, "Percentage",1);
            DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
        }
    }
    else
    {
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        DeleteLocalInt(OBJECT_SELF, "i");
        return;
    }
    DelayCommand(0.01, ClassLoop());
}

void SkillLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    if(GetLocalInt(OBJECT_SELF, "DynConv_Waiting") == FALSE)
        return;
    int nPoints = GetLocalInt(OBJECT_SELF, "Points");
    int nInt = GetLocalInt(OBJECT_SELF, "Int");
    int nClass = GetLocalInt(OBJECT_SELF, "Class");
    int nRace = GetLocalInt(OBJECT_SELF, "Race");
    int nLevel = GetLocalInt(OBJECT_SELF, "Level");
    if(nPoints== 0)
    {
        nPoints = StringToInt(Get2DACache("classes", "SkillPointBase", GetLocalInt(OBJECT_SELF, "Class")));
        nInt += StringToInt(Get2DACache("racialtypes", "IntAdjust", nRace));
        nPoints += ((nInt-10)/2);
        if(nPoints <1)
            nPoints = 1; //min 1point
        //QTM bonus
        if(nLevel == 0)
        {
            for(i=0;i<array_get_size(OBJECT_SELF, "Feats");i++)
            {
               if(array_get_int(OBJECT_SELF, "Feats", i) == FEAT_QUICK_TO_MASTER)
               {
                   nPoints++;
                   i=999999;
                }
            }
            nPoints *= 4;
        }
        SetLocalInt(OBJECT_SELF, "Points", nPoints);
    }

    i = GetLocalInt(OBJECT_SELF, "i");
    if(i==1
        && GetPRCSwitch(PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER))
        SetupSkillToken(-1, array_get_size(OBJECT_SELF, "ChoiceValue"));
    string sFile = Get2DACache("classes", "SkillsTable", nClass);
    if(i < SKILLS_2DA_END)
    {
        SetupSkillToken(i, array_get_size(OBJECT_SELF, "ChoiceValue"));
        i++;
        SetLocalInt(OBJECT_SELF, "i", i);
        DelayCommand(0.01, SkillLoop());
        return;
   }
   FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
   DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
   DeleteLocalInt(OBJECT_SELF, "Percentage");
   DeleteLocalInt(OBJECT_SELF, "i");
}

void FeatLoop()
{
    object oPC = OBJECT_SELF;
    //get some stored data
//    int nLoop;
    int i;
    int nClass = GetLocalInt(OBJECT_SELF, "Class");
//declare using variables
    i = GetLocalInt(oPC, "i");
    int j;
    int bReturn;
    string sFeatName;
    int nFeatIsAll;
    string sFeatTest;
    int bNoAdd;
    int nFeatStage = GetLocalInt(oPC, "FeatStage");
    int nLevel = GetLocalInt(oPC, "Level");
    //FOR DEBUG PURPOSES ONLY
//    nFeatStage = 1;
    object oACCUwp = GetWaypointByTag("CACHED__ACCU");
///go through each feat in turn
//    if(i < FEAT_2DA_END && nFeatStage == 0)
//FOR DEBUG PURPOSES ONLY
    if(i < 500 && nFeatStage == 0)
    {
            object cachewp = GetObjectByTag("CACHEWP");
            location lCache = GetLocation(cachewp);
            if (!GetIsObjectValid(cachewp))
                lCache = GetStartingLocation();
            bNoAdd=FALSE;
            //check its name (which will be a tlk reference)
            sFeatName = Get2DACache("feat", "FEAT", i);
            //if it has a name, its not an empty row
            if(sFeatName != "")
            {
                if(!StringToInt(Get2DACache("feat", "ALLCLASSESCANUSE",i)))
                {
                    bNoAdd = TRUE;
                }
                if(!bNoAdd)
                {   //Test its not already been given
                    for(j=1;j<=array_get_size(oPC, "Feats"); j++)
                    {
                        int nTestFeatID = array_get_int(oPC, "Feats", j);
                        if(nTestFeatID == i)
                            bNoAdd=TRUE;
                    }
                }
                if(!bNoAdd)
                {   //test its not been taken as a racial bonus feat
                    for(j=1;j<nLevel; j++)
                    {
                        int nTestFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                        if(nTestFeatID == i)
                            bNoAdd=TRUE;
                    }
                }
                if(!bNoAdd)
                {   //test its not already on the list
                    for(j=0;j<array_get_size(OBJECT_SELF, "ChoiceValue");j++)
                    {
                        if(array_get_int(OBJECT_SELF, "ChoiceValue", j) == i)
                            bNoAdd= TRUE;
                    }
                }
                if(!bNoAdd && !CheckFeatRequirements(i))
                    bNoAdd= TRUE;
                if(bNoAdd==FALSE)
                {
                    array_set_string(OBJECT_SELF, "ChoiceTokens",
                        array_get_size(OBJECT_SELF, "ChoiceTokens"),
                           GetStringByStrRef(StringToInt(sFeatName)));
                    array_set_int(OBJECT_SELF, "ChoiceValue",
                        array_get_size(OBJECT_SELF, "ChoiceValue"),
                           i);
                }
            } //if(sFeatName != "")
            i++;
        //prepare for next thing
            SetLocalInt(oPC, "i",i);
            DelayCommand(0.01,FeatLoop());
            if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
            {
                int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(FEAT_2DA_END+CLASS_FEAT_2DA_END));
                FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
                SetLocalInt(OBJECT_SELF, "Percentage",1);
                DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
            }
            return;

    }
//now add class specific feats
    if(nFeatStage == 0)//i.e final general feat done
    {
        nFeatStage = 1;
        SetLocalInt(oPC, "FeatStage", 1);
        DeleteLocalInt(oACCUwp, "Building");
        i=0;
        SetLocalInt(oPC, "i",i);
    }
    string sFeatList = Get2DACache("classes", "FeatsTable", nClass);

    if(i < CLASS_FEAT_2DA_END && nFeatStage == 1)
    {
        bNoAdd=FALSE;
        //check its name (which will be a tlk reference)
        sFeatName = Get2DACache(sFeatList, "FeatIndex", i);
        //if it has a name, its not an empty row
        if(sFeatName != "")
        {
            int nFeatNo = StringToInt(sFeatName);
            if(!bNoAdd &&
                !StringToInt(Get2DACache("feat", "ALLCLASSESCANUSE",nFeatNo)))
                bNoAdd = TRUE;
            if(!bNoAdd)
            {   //test its not been given as a feat
                for(j=1;j<=array_get_size(oPC, "Feats"); j++)
                {
                    int nFeatID = array_get_int(oPC, "Feats", j);
                    if(nFeatID == nFeatNo)
                        bNoAdd=TRUE;
                }
            }
            if(!bNoAdd)
            {   //test its not been taken as a racial bonus feat
                for(j=1;j<nLevel; j++)
                {
                    int nTestFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                    if(nTestFeatID == nFeatNo)
                        bNoAdd=TRUE;
                }
            }
            if(!bNoAdd)
            {
                for(j=0;j<array_get_size(OBJECT_SELF, "ChoiceValue");j++)
                {
                    if(array_get_int(OBJECT_SELF, "ChoiceValue", j) == nFeatNo)
                        bNoAdd= TRUE;
                }
            }
            if(!bNoAdd && !CheckFeatRequirements(nFeatNo))
                bNoAdd= TRUE;
            if(bNoAdd==FALSE)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens",
                    array_get_size(OBJECT_SELF, "ChoiceTokens"),
                       GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", StringToInt(sFeatName)))));
                array_set_int(OBJECT_SELF, "ChoiceValue",
                    array_get_size(OBJECT_SELF, "ChoiceValue"),
                       nFeatNo);
            }
        }
        i++;
        //prepare for next thing
        SetLocalInt(oPC, "i",i);
        DelayCommand(0.01,FeatLoop());
//        ActionDoCommand(FeatLoop());
        if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
        {
            int nPercentage = FloatToInt((IntToFloat(i+FEAT_2DA_END)*100.0)/IntToFloat(FEAT_2DA_END+CLASS_FEAT_2DA_END));
            FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, "Percentage",1);
            DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
        }
        return;
    }
    if((i < FEAT_2DA_END && nFeatStage == 0)
        || i < CLASS_FEAT_2DA_END && nFeatStage == 1)
    {
    }
    else
    {
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "FeatStage");
    }
}

int IsInWizList(int nSpell, int nLevel)
{
    int i;
    string sLevel = IntToString(nLevel);
    for (i=2;i<array_get_size(OBJECT_SELF, "SpellLvl"+sLevel);i++)
    {
        if(nSpell == array_get_int(OBJECT_SELF,"SpellLvl"+sLevel,i))
            return TRUE;
    }
    return FALSE;
}

void SpellLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    if(GetLocalInt(OBJECT_SELF, "DynConv_Waiting") == FALSE)
        return;
    //end if you have reached the end of the file
    if(i >= SPELLS_2DA_END)
    {
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        DeleteLocalInt(OBJECT_SELF, "i");
        return;
    }
    int nSpellLevel = GetLocalInt(OBJECT_SELF, "SpellLevel");
    string sClassAbbrev;
    string sName;
    int nClass = GetLocalInt(OBJECT_SELF, "Class");
    //get spellschool
    int nSchool = GetLocalInt(OBJECT_SELF, "School");
    //get opposition school
    string sOpposition = Get2DACache("spellschools", "Letter", StringToInt(Get2DACache("spellschools", "Opposition", nSchool)));
    switch(nClass)
    {
        case CLASS_TYPE_WIZARD:
            sClassAbbrev = "Wiz_Sorc";

            //check spell is valid and is a level 1 spell
            //and is not already in list
            //and is not in opposition school
            if(Get2DACache("spells", sClassAbbrev, i) != ""
                && StringToInt(Get2DACache("spells", sClassAbbrev, i)) == 1
                && !IsInWizList(i, 1)
                && Get2DACache("spells", "School", i) != sOpposition)
            {
                sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", i)));
                array_set_string(OBJECT_SELF, "ChoiceTokens",
                    array_get_size(OBJECT_SELF, "ChoiceTokens"),
                       "Level "+Get2DACache("spells", sClassAbbrev, i)+": "+sName);
                array_set_int(OBJECT_SELF, "ChoiceValue",
                    array_get_size(OBJECT_SELF, "ChoiceValue"),
                       i);
            }
            array_create(OBJECT_SELF, "SpellLvl0");
            //if its a cantrip, add it stright to the spelllist.
            if(Get2DACache("spells", sClassAbbrev, i) != ""
                && StringToInt(Get2DACache("spells", sClassAbbrev, i)) == 0
                && !IsInWizList(i, 0))
            {
                array_set_int(OBJECT_SELF, "SpellLvl0",
                    array_get_size(OBJECT_SELF, "SpellLvl0"),i);
            }
            break;
        case CLASS_TYPE_SORCERER:
            sClassAbbrev = "Wiz_Sorc";
            //check spell is valid and is a level 1 spell
            if(Get2DACache("spells", sClassAbbrev, i) != ""
                && StringToInt(Get2DACache("spells", sClassAbbrev, i)) == GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")
                && !IsInWizList(i, GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")))
            {
                sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", i)));
                array_set_string(OBJECT_SELF, "ChoiceTokens",
                    array_get_size(OBJECT_SELF, "ChoiceTokens"),
                       "Level "+Get2DACache("spells", sClassAbbrev, i)+": "+sName);
                array_set_int(OBJECT_SELF, "ChoiceValue",
                    array_get_size(OBJECT_SELF, "ChoiceValue"),
                       i);
            }
            break;
        case CLASS_TYPE_BARD:
            sClassAbbrev = "Bard";
            //check spell is valid and is a level 1 spell
            if(Get2DACache("spells", sClassAbbrev, i) != ""
                && StringToInt(Get2DACache("spells", sClassAbbrev, i)) == GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")
                && !IsInWizList(i, GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")))
            {
                sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", i)));
                array_set_string(OBJECT_SELF, "ChoiceTokens",
                    array_get_size(OBJECT_SELF, "ChoiceTokens"),
                       "Level "+Get2DACache("spells", sClassAbbrev, i)+": "+sName);
                array_set_int(OBJECT_SELF, "ChoiceValue",
                    array_get_size(OBJECT_SELF, "ChoiceValue"),
                       i);
            }
            break;
    }
    //now do the counting stuff to go to the next line
    i++;
    SetLocalInt(OBJECT_SELF, "i", i);
    DelayCommand(0.01, SpellLoop());
    if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
    {
        int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(SPELLS_2DA_END));
        FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "Percentage",1);
        DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
    }
}


void BonusFeatLoop()
{
    object oPC = OBJECT_SELF;
    //get some stored data
//    int nRace = GetLocalInt(oPC, "Race");
    int nClass = GetLocalInt(oPC, "Class");
//declare using variables
    int i = GetLocalInt(oPC, "i");
    int j;
    int bReturn;
    string sFeatName = Get2DACache("feat", "FEAT", i);
    int nFeatIsAll;
    string sFeatTest;
    int bNoAdd;
    string sFeatList = Get2DACache("classes", "FeatsTable", nClass);
    int nLevel = GetLocalInt(oPC, "Level");

    if(i < CLASS_FEAT_2DA_END)
    {
        bNoAdd=FALSE;
        //check its name (which will be a tlk reference)
        sFeatName = Get2DACache(sFeatList, "FeatIndex", i);
        //if it has a name, its not an empty row
        if(sFeatName != "")
        {
            //check its not given already
            for(j=1;j<=array_get_size(oPC, "Feats"); j++)
            {
                int nFeatID = array_get_int(oPC, "Feats", j);
                if(nFeatID == StringToInt(sFeatName))
                    bNoAdd=TRUE;
            }
            if(!bNoAdd)
            {   //test its not been taken as a racial bonus feat
                for(j=1;j<nLevel; j++)
                {
                    int nTestFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                    if(nTestFeatID == StringToInt(sFeatName))
                        bNoAdd=TRUE;
                }
            }
            if(Get2DACache(sFeatList, "List", i)=="1" || Get2DACache(sFeatList, "List", i)=="2")//check its pickable
            {
                if(CheckFeatRequirements(StringToInt(sFeatName))==FALSE)
                    bNoAdd= TRUE;
                //actually add it
                if(bNoAdd==FALSE)
                {
                    array_set_string(OBJECT_SELF, "ChoiceTokens",
                        array_get_size(OBJECT_SELF, "ChoiceTokens"),
                           GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", StringToInt(Get2DACache(sFeatList, "FeatIndex", i))))));
                    array_set_int(OBJECT_SELF, "ChoiceValue",
                        array_get_size(OBJECT_SELF, "ChoiceValue"),
                           StringToInt(Get2DACache(sFeatList, "FeatIndex", i)));
                }
            }
        }
        i++;
        //prepare for next thing
        SetLocalInt(oPC, "i",i);
        DelayCommand(0.01,BonusFeatLoop());
        if(GetLocalInt(oPC, "Percentage") == 0)
        {
            int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(CLASS_FEAT_2DA_END));
            FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, "Percentage",1);
            DelayCommand(1.0, DeleteLocalInt(oPC, "Percentage"));
        }
        return;
    }
   FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
   DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
   DeleteLocalInt(OBJECT_SELF, "Percentage");
   DeleteLocalInt(OBJECT_SELF, "i");
}


void RaceLoop()
{
    object oPC = OBJECT_SELF;
    //get some stored data
//    int nRace = GetLocalInt(oPC, "Race");
//    int nClass = GetLocalInt(oPC, "Class");
//declare using variables
    int i = GetLocalInt(oPC, "i");
    int j;
    int bReturn;
    string sFeatName = Get2DACache("racialtypes", "name", i);
    int nFeatIsAll;
    string sFeatTest;
    int bNoAdd;
    if(i < RACE_2DA_END)
    {
        //check its name (which will be a tlk reference)
        sFeatName = Get2DACache("racialtypes", "name", i);
        //if it has a name, its not an empty row
        int bIsTakeable = TRUE;
        if(i == RACIAL_TYPE_DROW_FEMALE
            && GetLocalInt(OBJECT_SELF, "Gender") == GENDER_MALE
            && GetPRCSwitch(PRC_CONVOCC_DROW_ENFORCE_GENDER))
            bIsTakeable = FALSE;
        if(i == RACIAL_TYPE_DROW_MALE
            && GetLocalInt(OBJECT_SELF, "Gender") == GENDER_FEMALE
            && GetPRCSwitch(PRC_CONVOCC_DROW_ENFORCE_GENDER))
            bIsTakeable = FALSE;
        if(sFeatName != ""
            && Get2DACache("racialtypes", "PlayerRace", i) == "1"
            && bIsTakeable)
        {
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    GetStringByStrRef(StringToInt(sFeatName)));
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    i);
        }
        i++;
        //prepare for next thing
        SetLocalInt(oPC, "i",i);
        DelayCommand(0.01,RaceLoop());
        if(GetLocalInt(oPC, "Percentage") == 0)
        {
            int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(RACE_2DA_END));
            FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, "Percentage",1);
            DelayCommand(1.0, DeleteLocalInt(oPC, "Percentage"));
        }
        return;
    }
   FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
   DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
   DeleteLocalInt(OBJECT_SELF, "Percentage");
   DeleteLocalInt(OBJECT_SELF, "i");
}

void DoClassFeat(string sClassFeatTable, int i=0)
{
    if(i<CLASS_FEAT_2DA_END)
    {
        if(Get2DACache(sClassFeatTable, "FeatIndex", i) != ""
            && Get2DACache(sClassFeatTable, "List", i) == "3"
            && Get2DACache(sClassFeatTable, "GrantedOnLevel", i) == "1")
        {
            array_set_int(OBJECT_SELF, "Feats", array_get_size(OBJECT_SELF, "Feats"),
                StringToInt(Get2DACache(sClassFeatTable, "FeatIndex", i)));
        }
        i++;
        DelayCommand(0.1, DoClassFeat(sClassFeatTable, i));
    }
}



void AppearanceLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    string SQL = "SELECT row, STRING_REF FROM cached2da_appearance LIMIT 100, "+IntToString(i);
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        int nStrRef = StringToInt(PRC_SQLGetData(2));
        string sName = GetStringByStrRef(nStrRef);
        int nRow = StringToInt(PRC_SQLGetData(1));
        array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    sName);
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    nRow);
    }

    if(i > APPEARANCE_2DA_END)
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        return;
    }

    i += 100;
    SetLocalInt(OBJECT_SELF, "i", i);
    if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
    {
        int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(APPEARANCE_2DA_END));
        FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "Percentage",1);
        DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
    }

    DelayCommand(0.01, AppearanceLoop());
}


void SoundsetLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    if(i > SOUNDSET_2DA_END)
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        return;
    }
    else
    {
        string sName = Get2DACache("soundset", "STRREF", i);
        if(GetPRCSwitch(PRC_CONVOCC_ONLY_PLAYER_VOICESETS)
            && Get2DACache("soundset", "TYPE", i) != "0")
            sName = "";
        if(GetPRCSwitch(PRC_CONVOCC_RESTRICT_VOICESETS_BY_SEX)
            && StringToInt(Get2DACache("soundset", "GENDER", i)) != GetLocalInt(OBJECT_SELF, "Gender"))
            sName = "";
        if(sName != "")
        {
            sName = GetStringByStrRef(StringToInt(sName));

            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    sName);
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    i);
        }
        i++;
        SetLocalInt(OBJECT_SELF, "i", i);
        if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
        {
            int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(SOUNDSET_2DA_END));
            FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, "Percentage",1);
            DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
        }
        DelayCommand(0.01, SoundsetLoop());
    }
}

void PortraitLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    if(i > PORTRAITS_2DA_END)
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        return;
    }
    else
    {
        string sName = Get2DACache("portraits", "BaseResRef", i);
        if(GetPRCSwitch(PRC_CONVOCC_RESTRICT_PORTRAIT_BY_SEX)
            && StringToInt(Get2DACache("portraits", "SEX", i)) != GetLocalInt(OBJECT_SELF, "Gender"))
            sName = "";
        if(sName != "" && Get2DACache("portraits", "InanimateType", i)=="" )
        {
            sName += " "+GetStringByStrRef(StringToInt(Get2DACache("gender", "NAME", StringToInt(Get2DACache("portraits", "Sex", i)))));
            sName += " "+GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", StringToInt(Get2DACache("portraits", "Race", i)))));

            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    sName);
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    i);
        }
        i++;
        SetLocalInt(OBJECT_SELF, "i", i);
        if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
        {
            int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(PORTRAITS_2DA_END));
            FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, "Percentage",1);
            DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
        }
        DelayCommand(0.01, PortraitLoop());
    }
}

void WingLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    if(i > WINGS_2DA_END)
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        return;
    }
    else
    {
        string sName = Get2DACache("wingmodel", "Label", i);
        if(sName != "")
        {
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    sName);
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    i);
        }
        i++;
        SetLocalInt(OBJECT_SELF, "i", i);
        if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
        {
            int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(WINGS_2DA_END));
            FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, "Percentage",1);
            DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
        }
        DelayCommand(0.01, WingLoop());
    }
}

void TailLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    if(i > TAILS_2DA_END)
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        return;
    }
    else
    {
        string sName = Get2DACache("tailmodel", "Label", i);
        if(sName != "")
        {
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    sName);
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    i);
        }
        i++;
        SetLocalInt(OBJECT_SELF, "i", i);
        if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
        {
            int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(TAILS_2DA_END));
            FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, "Percentage",1);
            DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
        }
        DelayCommand(0.01, TailLoop());
    }
}


