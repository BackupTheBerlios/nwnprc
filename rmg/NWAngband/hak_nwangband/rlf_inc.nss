/*
Primogenitors Random Leveling Functions

Levels a creature based upon local variables.
nLevelMax       int     Level to stop leveling at
nClass1         int     Class for position 1
nClass2         int     Class for position 2
nClass3         int     Class for position 3
nClass1Min      int     Minimum class level for position 1
nClass2Min      int     Minimum class level for position 2
nClass3Min      int     Minimum class level for position 3
nClass1Max      int     Maximum class level for position 1
nClass2Max      int     Maximum class level for position 2
nClass3Max      int     Maximum class level for position 3
nClass1Prob     int     Probablility of 1-100 of leveling in position 1
nClass2Prob     int     Probablility of 1-100 of leveling in position 2 assuming
                        did not level in position 1
sReplaceResRefX  string  ResRef of creature to replace with
nReplaceLevelX   int     Level to replace at
nReplaceProbX    int     Probability of replacement per level
    where X is a integer starting at 1

Also, you can set a localstring on the module
sNPCLevelupScript string Script run whenever a NPC levelsup

Notes:
When replacing, only nLevelMax is copied to the new creature.
The second replacement will only be tested for if the first fails, so a
probability of 10 in the first and 10 in the second means a total of 10% to
change to replace1, and 90%*10%=9% to change to replace2.
Minimums are top priority, so if nLevelMax = 5 and nClass1Min = 10, you will
get a Lvl 10 creature.
If a creature is unable to levelup in Position 2, it will level in position 1
instead, even if position 1 is at max.
If a creature is unable to levelup in Position 3, it will level in position 2
instead, even if position 2 is at max.
*/

//Master Leveling Function
//oObject must meet the requirements for leveling
//i.e. Must have started at level one and have a valid character history
//Variables set on oObject determine behavior of LevelUp
//nLevelMax is the number of hit dice to level up to
//nClass1, nClass2, and nClass3 all specify classes for positions
//nClass1Min, nClass2Min, and nClass3Min specify minimum levels for positions
//nClass1Max, nClass2Max, and nClass3Max specify maximum levels for positions
//a value of 0 is random so for CLASS_TYPE_BARBARIAN the value should be -1
//see nwscript for other values
//nPackage1/2/3 are the packages for positions
//a value of 0 is random, so for PACKAGE_BARBARIAN the value should be -1
//nClass1Prob is the chance of leveling in position 1
//nClass2Prob is the chance of leveling in position 2, provided 1 has not been
//seleced
//These probabilities should be integers in the range 1-100
//If they are 0, then they default to nClass1Prob = 0, and nClass2prob = 100
//If you want a zero probablility, use -1 as the value
void LevelUp(object oObject = OBJECT_SELF);

//Returns a random class the oObject can take
//Makes alowances for alignment
//Does not include prestige classes
int GetRandomClass(object oObject, int nPosition);

//Selects a package at random for the class supplied
//Prestige classes and monster classes have only 1 package
//Normal classes have several
int GetRandomPackage(int nClass);

//Returns a prestige class that oObject should be eligible for
//Returns CLASS_TYPE_INVALID if none avaliable
int GetPrestigeClass(object oObject, int nPosition);

//Test if the object matches the prerequisites for the class
//Alignment for normal classes
//Prerequisites for presitge
//Also checks for epicness and prestige classes
int GetIsLevelable(int nClass, object oObject);

//Test if the supplied class is a prestige class or not
//Returns TRUE or FALSE
int GetIsPrestige(int nClass);

//Level up in position 1
//Returns the return of the LevelUpHenchmen call
int LevelUpInPos1(object oObject);

//Level up in position 2
//If Pos2 is invalid, checks localint
//if no local int, picks a random class
//Returns the return of the LevelUpHenchmen call
int LevelUpInPos2(object oObject);

//Level up in position 3
//If Pos3 is invalid, checks localint
//If no local int, picks a random prestige class
//If no valid prestige classes, and over lvl 15, picks a random normal class
//If no valid prestige classes, and under lvl 15, levels up in position 2
//Returns the return of the LevelUpHenchmen call
int LevelUpInPos3(object oObject);

//returns a string name for each normal or prestige class
//monster classes return the ID no as a string
string ClassToString(int nClass);

void AddLevel();

const int SPAWNDEBUG       = TRUE; //FALSE;
const int CLASSES_2DA_END  = 38;  //change if using custom content
const int PACKAGES_2DA_END = 130; //change if using custom content

void DebugString(string sDebug)
{
    if(SPAWNDEBUG == FALSE)
        return;
//    SendMessageToPC(GetFirstPC(), sDebug);
//    WriteTimestampedLogEntry(sDebug);
//    SendMessageToAllDMs(sDebug);
}

int GetIsValidAlignment ( int iLawChaos, int iGoodEvil,int iAlignRestrict, int iAlignRstrctType, int iInvertRestriction )
{
    //deal with no restrictions first
    if(iAlignRstrctType == 0)
        return TRUE;
    //convert the ALIGNMENT_* into powers of 2
    iLawChaos = FloatToInt(pow(2.0, IntToFloat(iLawChaos-1)));
    iGoodEvil = FloatToInt(pow(2.0, IntToFloat(iGoodEvil-1)));
    //initialise result varaibles
    int iAlignTest, iRetVal = TRUE;
    //do different test depending on what type of restriction
    if(iAlignRstrctType == 1 || iAlignRstrctType == 3)   //I.e its 1 or 3
        iAlignTest = iLawChaos;
    if(iAlignRstrctType == 2 || iAlignRstrctType == 3) //I.e its 2 or 3
        iAlignTest = iAlignTest | iGoodEvil;
    //now the real test.
    if(iAlignRestrict & iAlignTest)//bitwise AND comparison
        iRetVal = FALSE;
    //invert it if applicable
    if(iInvertRestriction)
        iRetVal = !iRetVal;
    //and return the result
    return iRetVal;
}

//fudge around GetClassByPosition bug
int MyGetClassByPosition(int nClassPosition, object oCreature=OBJECT_SELF)
{
    int nReturn;
    if(nClassPosition <= 38)//end of bioware classes
    {
        nReturn = GetClassByPosition(nClassPosition, oCreature);
    }
    else
    {
        nReturn = GetLocalInt(oCreature, "ClassPos"+IntToString(nClassPosition));
        if(GetLevelByClass(nReturn) == 0)
            return CLASS_TYPE_INVALID;
    }
    return nReturn;
}

void LevelUp(object oObject = OBJECT_SELF)
{
    if(GetIsObjectValid(oObject) == FALSE
        ||GetObjectType(oObject) != OBJECT_TYPE_CREATURE
        ||GetHitDice(oObject) != 1)
        return;


    //make the arrays needed
    //on module: "Classes_core"
    //on module: "Classes_prestige"
    object oMod = GetModule();
    int i;

    if(!array_exists(oMod, "Classes_core"))
    {
        array_create(oMod, "Classes_core");
        array_create(oMod, "Classes_prestige");
        for(i=0; i<=CLASSES_2DA_END; i++)
        {
            if(Get2DACache("classes", "PlayerClass", i) == "1"
                && GetIsPrestige(i)==TRUE)
            {
                int nSize = array_get_size(oMod, "Classes_prestige");
                array_set_int(oMod, "Classes_prestige", nSize, i);
            }
            else if(Get2DACache("classes", "PlayerClass", i) == "1"
                && GetIsPrestige(i)==FALSE)
            {
                int nSize = array_get_size(oMod, "Classes_core");
                array_set_int(oMod, "Classes_core", nSize, i);
            }
        }

        for(i=0; i<= PACKAGES_2DA_END;i++)
        {
            if(Get2DACache("packages", "Label", i)!=""
                && Get2DACache("packages", "PlayerClass", i) == "1")
            {
                int nClass = StringToInt(Get2DACache("classes", "ClassID", i));
                if(!array_exists(oMod, "ClassPack"+IntToString(nClass)))
                    array_create(oMod, "ClassPack"+IntToString(nClass));
                int nSize = array_get_size(oMod, "ClassPack"+IntToString(nClass));
                array_set_int(oMod, "ClassPack"+IntToString(nClass), nSize, i);
            }
        }
    }
    //fudge around GetClassByPosition bug
    for(i=0; i<=CLASSES_2DA_END; i++)
    {
        if(GetLevelByClass(i, oObject)>0)
        {
            SetLocalInt(oObject, "ClassPos1",i);
            break;
        }
    }

    //minimum levelup
    int nClass1Min = GetLocalInt(oObject, "nClass1Min");
    int nClass2Min = GetLocalInt(oObject, "nClass2Min");
    int nClass3Min = GetLocalInt(oObject, "nClass3Min");
    while (GetLevelByPosition(1, oObject) < nClass1Min)
    {
        LevelUpInPos1(oObject);
    }
    while (GetLevelByPosition(2, oObject) < nClass2Min)
    {
        LevelUpInPos2(oObject);
    }
    while (GetLevelByPosition(3, oObject) < nClass3Min)
    {
        LevelUpInPos3(oObject);
    }


    DebugString("Done Minimum Lvlup of " +GetName(oObject));
    DebugString("Pos 1: " + ClassToString(MyGetClassByPosition(1, oObject)) + " " + IntToString(GetLevelByPosition(1, oObject)));
    DebugString("Pos 2: " + ClassToString(MyGetClassByPosition(2, oObject)) + " " + IntToString(GetLevelByPosition(2, oObject)));
    DebugString("Pos 3: " + ClassToString(MyGetClassByPosition(3, oObject)) + " " + IntToString(GetLevelByPosition(3, oObject)));


    DelayCommand(0.1, AssignCommand(oObject, AddLevel()));
}

void AddLevel()
{
    object oObject = OBJECT_SELF;
    int nClass1Max = GetLocalInt(oObject, "nClass1Max");
    if(nClass1Max == 0)
        nClass1Max = 60;
    int nClass2Max = GetLocalInt(oObject, "nClass2Max");
    if(nClass2Max == 0)
        nClass2Max = 60;
    int nClass3Max = GetLocalInt(oObject, "nClass3Max");
    if(nClass3Max == 0)
        nClass3Max = 60;
    int nCR = GetLocalInt(oObject, "nLevelMax");

    int nClass1Prob = GetLocalInt(oObject, "nClass1Prob");
    if(nClass1Prob == 0)
        nClass1Prob = 0;
    else if (nClass1Prob == -1)
        nClass1Prob = 0;

    int nClass2Prob = GetLocalInt(oObject, "nClass2Prob");
    if(nClass2Prob == 0)
        nClass2Prob = 50;
    else if (nClass2Prob == -1)
        nClass2Prob = 0;

    int i=1;
    string sReplaceResRef = GetLocalString(oObject, "sReplaceResRef"+IntToString(i));
    int nReplaceLevel = GetLocalInt(oObject, "nReplaceLevel"+IntToString(i));
    int nReplaceProb = GetLocalInt(oObject, "nReplaceProb"+IntToString(i));
    if(nReplaceProb == 0)
        nReplaceProb = 100;
    while (GetLocalString(oObject, "sReplaceResRef"+IntToString(i)) != "")
        i++;
    int nReplaceCount = i-1;

    int nLeveled;
    int nRandom;
    int nErrors;

    if(GetHitDice(oObject) < nCR
        && GetHitDice(oObject) < 40
        && nErrors < 10)
    {
        //replacement level
        for (i=1;i<=nReplaceCount;i++)
        {
            sReplaceResRef = GetLocalString(oObject, "sReplaceResRef"+IntToString(i));
            nReplaceLevel = GetLocalInt(oObject, "nReplaceLevel"+IntToString(i));
            nReplaceProb = GetLocalInt(oObject, "nReplaceProb"+IntToString(i));
            if(nReplaceProb == 0)
                nReplaceProb = 100;
            if(sReplaceResRef != ""
                && nReplaceLevel != 0
                && nReplaceLevel <= GetHitDice(oObject)
                && d100() <= nReplaceProb)
            {
                object oReplacement = CreateObject(OBJECT_TYPE_CREATURE, sReplaceResRef, GetLocation(oObject), FALSE, GetTag(oObject));
                SetLocalInt(oReplacement, "nLevelMax", nCR);
                DelayCommand(1.0, LevelUp(oReplacement));
                DestroyObject(oObject);
                return;
            }
        }

        //leveling
        nRandom = d100();
        if(nRandom <= nClass1Prob
            && GetLevelByPosition(1, oObject) < nClass1Max)
        {
            nLeveled = LevelUpInPos1(oObject);
        }
        else
        {
            nRandom = d100();
            if((nRandom <= nClass2Prob
                //for cases where only has 1 level, level up pos 2 before pos 3
                || GetClassByPosition(2, oObject) == CLASS_TYPE_INVALID)
                && GetLevelByPosition(2, oObject) < nClass2Max)
            {
                nLeveled = LevelUpInPos2(oObject);
            }
            else if (GetLevelByPosition(3, oObject) < nClass3Max)
            {
                nLeveled = LevelUpInPos3(oObject);
            }
        }
        if(nLeveled == 0)
            nErrors++;
        else
            ExecuteScript(GetLocalString(GetModule(), "sNPCLevelupScript"), oObject);

        DebugString("Done Lvlup to " +IntToString(GetHitDice(oObject)) + " of "+ GetName(oObject));
        DebugString("Pos 1: " + ClassToString(MyGetClassByPosition(1, oObject)) + " " + IntToString(GetLevelByPosition(1, oObject)));
        DebugString("Pos 2: " + ClassToString(MyGetClassByPosition(2, oObject)) + " " + IntToString(GetLevelByPosition(2, oObject)));
        DebugString("Pos 3: " + ClassToString(MyGetClassByPosition(3, oObject)) + " " + IntToString(GetLevelByPosition(3, oObject)));

        DelayCommand(0.1, AddLevel());
    }
    DebugString("Finished Lvlup of " +GetName(oObject));
    DebugString("Pos 1: " + ClassToString(MyGetClassByPosition(1, oObject)) + " " + IntToString(GetLevelByPosition(1, oObject)));
    DebugString("Pos 2: " + ClassToString(MyGetClassByPosition(2, oObject)) + " " + IntToString(GetLevelByPosition(2, oObject)));
    DebugString("Pos 3: " + ClassToString(MyGetClassByPosition(3, oObject)) + " " + IntToString(GetLevelByPosition(3, oObject)));
}

int GetIsLevelable(int nClass, object oObject)
{
    DebugString("Starting GetIsLevelabe test in "+ ClassToString(nClass));
    object oHench = oObject;

//alignment
    int iAlignRestrict     = HexToInt(Get2DACache("classes", "AlignRestrict",   nClass));
    int iAlignRstrctType   = HexToInt(Get2DACache("classes", "AlignRstrctType", nClass));
    int iInvertRestriction = HexToInt(Get2DACache("classes", "InvertRestrict",  nClass));
    if(!GetIsValidAlignment(GetAlignmentLawChaos(oObject), GetAlignmentGoodEvil(oObject), iAlignRestrict, iAlignRstrctType, iInvertRestriction))
        return FALSE;

//prereq file
    string sPrereqFile = Get2DACache("classes", "PreReqTable", nClass);

    if(sPrereqFile != "")
    {
        int bFeatOr;
        int bClassOr;
        int i;
        string sLabel = Get2DACache(sPrereqFile, "ReqType", i);
        while(sLabel != "")
        {
            string sReqParam1 = Get2DACache(sPrereqFile,  "ReqParam1", i);
            string sReqParam2 =  Get2DACache(sPrereqFile, "ReqParam2", i);
            if(sLabel == "VAR")
            {
                if(GetLocalInt(oObject, sReqParam1) != StringToInt(sReqParam2))
                    return FALSE;
            }
            else if(sLabel == "FEAT")
            {
                if(!GetHasFeat(StringToInt(sReqParam1), oObject))
                    return FALSE;
            }
            else if(sLabel == "FEATOR")
            {
                if(GetHasFeat(StringToInt(sReqParam1), oObject))
                    bFeatOr = TRUE;
                else if(bFeatOr == FALSE)
                    bFeatOr = -1;
            }
            else if(sLabel == "BAB")
            {
                if(GetBaseAttackBonus(oObject) < StringToInt(sReqParam1))
                    return FALSE;
            }
            else if(sLabel == "SKILL")
            {
                //bugged because this includes feat and ability mods
                if(GetSkillRank(StringToInt(sReqParam1), oObject) < StringToInt(sReqParam2))
                    return FALSE;
            }
            else if(sLabel == "RACE")
            {
                if(GetRacialType(oObject) != StringToInt(sReqParam1))
                    return FALSE;
            }
            else if(sLabel == "ARCSPELL")
            {
                //hardcoded to just the original classes
                switch(StringToInt(sReqParam1))
                {
                    case 1:
                        if(1 > GetLevelByClass(CLASS_TYPE_WIZARD, oObject)
                            && 1 > GetLevelByClass(CLASS_TYPE_SORCERER, oObject)
                            && 1 > GetLevelByClass(CLASS_TYPE_BARD, oObject))
                            return FALSE;
                        break;
                    case 2:
                        if(3> GetLevelByClass(CLASS_TYPE_WIZARD, oObject)
                            && 4 > GetLevelByClass(CLASS_TYPE_SORCERER, oObject)
                            && 3 > GetLevelByClass(CLASS_TYPE_BARD, oObject))
                            return FALSE;
                        break;
                    case 3:
                        if(5 > GetLevelByClass(CLASS_TYPE_WIZARD, oObject)
                            && 6 > GetLevelByClass(CLASS_TYPE_SORCERER, oObject)
                            && 5 > GetLevelByClass(CLASS_TYPE_BARD, oObject))
                            return FALSE;
                        break;
                    case 4:
                        if(7 > GetLevelByClass(CLASS_TYPE_WIZARD, oObject)
                            && 8 > GetLevelByClass(CLASS_TYPE_SORCERER, oObject)
                            && 8 > GetLevelByClass(CLASS_TYPE_BARD, oObject))
                            return FALSE;
                        break;
                    case 5:
                        if(9 > GetLevelByClass(CLASS_TYPE_WIZARD, oObject)
                            && 10 > GetLevelByClass(CLASS_TYPE_SORCERER, oObject)
                            && 11 > GetLevelByClass(CLASS_TYPE_BARD, oObject))
                            return FALSE;
                        break;
                    case 6:
                        if(11 > GetLevelByClass(CLASS_TYPE_WIZARD, oObject)
                            && 12 > GetLevelByClass(CLASS_TYPE_SORCERER, oObject)
                            && 14 > GetLevelByClass(CLASS_TYPE_BARD, oObject))
                            return FALSE;
                        break;
                    case 7:
                        if(13 > GetLevelByClass(CLASS_TYPE_WIZARD, oObject)
                            && 1 > GetLevelByClass(CLASS_TYPE_SORCERER, oObject)
                            && 17 > GetLevelByClass(CLASS_TYPE_BARD, oObject))
                            return FALSE;
                        break;
                    case 8:
                        if(15 > GetLevelByClass(CLASS_TYPE_WIZARD, oObject)
                            && 14 > GetLevelByClass(CLASS_TYPE_SORCERER, oObject))
                            return FALSE;
                        break;
                    case 9:
                        if(17 > GetLevelByClass(CLASS_TYPE_WIZARD, oObject)
                            && 16 > GetLevelByClass(CLASS_TYPE_SORCERER, oObject))
                            return FALSE;
                        break;
                }
            }
            else if(sLabel == "CLASS")
            {
                if(GetLevelByClass(StringToInt(sReqParam1), oObject) < 1)
                    return FALSE;
            }
            else if(sLabel == "CLASSOR")
            {
                if(GetLevelByClass(StringToInt(sReqParam1), oObject) >= 1)
                    bClassOr = TRUE;
                else if(bFeatOr == FALSE)
                    bClassOr = -1;
            }
            i++;
            sLabel = Get2DACache(sPrereqFile, "ReqType", i);
        }
        if(bFeatOr == -1)
            return FALSE;
        if(bClassOr == -1)
            return FALSE;
    }

    DebugString("Passed levelupable test");
    return TRUE;
}

int GetRandomClass(object oObject, int nPosition)
{
    DebugString("Getting random class.");
    int bIsLevelable = FALSE;
    int nClass;
    object oMod = GetModule();
    int nSize = array_get_size(oMod, "Classes_core");
    int i = Random(nSize)+1;
    int nLooped;
    while(nLooped < 2
        && bIsLevelable == FALSE)
    {
        nClass = array_get_int(oMod, "Classes_core", i);
        bIsLevelable = GetIsLevelable(nClass, oObject);
        if(GetLevelByClass(nClass, oObject) > 0)
            bIsLevelable = FALSE;
        i++;
        if(i>=nSize)
        {
            i=0;
            nLooped++;
        }
    }
    DebugString("Returning Class of "+ClassToString(nClass));
    return nClass;
}

int GetRandomPackage(int nClass)
{
    int nSize = array_get_size(GetModule(), "ClassPack"+IntToString(nClass));
    int nRandom = RandomI(nSize)+1;
    int nPackage = array_get_int(GetModule(), "ClassPack"+IntToString(nClass), nRandom);
    return nPackage;
}

int GetPrestigeClass(object oObject, int nPosition)
{
    DebugString("Getting random class.");
    int bIsLevelable = FALSE;
    int nClass;
    object oMod = GetModule();
    int nSize = array_get_size(oMod, "Classes_prestige");
    int nRandom = RandomI(nSize)+1;
    int i = nRandom;
    int nLooped;
    while(nLooped < 1
        && bIsLevelable == FALSE)
    {
        nClass = array_get_int(oMod, "Classes_prestige", i);
        bIsLevelable = GetIsLevelable(nClass, oObject);
        if(GetLevelByClass(nClass, oObject) > 0)
            bIsLevelable = FALSE;
        i++;
        if(i==nRandom)
            nLooped++;
        if(i>=nSize)
            i=0;
    }
    DebugString("Returning Class of "+ClassToString(nClass));
    return nClass;
}

int GetIsPrestige(int nClass)
{
    if(Get2DACache("classes", "EpicLevel", nClass) != "-1")
        return TRUE;
    else
        return FALSE;
}

int LevelUpInPos1(object oObject)
{
    DebugString("Leveling Position 1 of "+GetName(oObject));
    int nClass = MyGetClassByPosition(1, oObject);
    //nClass will always be valid
    int nPackage = GetLocalInt(oObject, "nPackage1");
    //if no package picked already, choose one
    if(nPackage == 0)
    {
        nPackage = GetRandomPackage(nClass);
        SetLocalInt(oObject, "nPackage1", nPackage);
    }
    else if(nPackage == -1)
    {
        nPackage = PACKAGE_BARBARIAN;
        SetLocalInt(oObject, "nPackage1", nPackage);
    }
    return LevelUpHenchman(oObject, nClass, TRUE, nPackage);
}

int LevelUpInPos2(object oObject)
{
    DebugString("Leveling Position 2 of "+GetName(oObject));
    int nClass = MyGetClassByPosition(2, oObject);
    //if no levels in class2, then go by localint nClass2
    if(nClass == CLASS_TYPE_INVALID)
    {
        nClass = GetLocalInt(oObject, "nClass2");
        if(nClass == -1)
            nClass = CLASS_TYPE_BARBARIAN;
        //if no nClass2, get one at random
        else if(nClass == 0)
        {
            nClass = GetPrestigeClass(oObject, 2);
            //if there are no eligible presitge classes
            if(nClass == CLASS_TYPE_INVALID)
            {
                //if over Level15, choose a random non-prestige class
                if(GetHitDice(oObject) >= 0)
                    nClass = GetRandomClass(oObject, 2);
                else
                {
                //if under level30, levelup in position 2
                    return LevelUpInPos1(oObject);
                }
            }
        }
    }
    if(GetIsLevelable(nClass, oObject)==FALSE)
    {
        return LevelUpInPos1(oObject);
    }
    int nPackage = GetLocalInt(oObject, "nPackage2");
    //if no package picked already, choose one
    if(nPackage == 0)
    {
        nPackage = GetRandomPackage(nClass);
        SetLocalInt(oObject, "nPackage2", nPackage);
    }
    else if(nPackage == -1)
    {
        nPackage = PACKAGE_BARBARIAN;
        SetLocalInt(oObject, "nPackage2", nPackage);
    }

    //fudge around GetClassByPosition bug
    SetLocalInt(oObject, "ClassPos2", nClass);

    return LevelUpHenchman(oObject, nClass, TRUE, nPackage);
}

int LevelUpInPos3(object oObject)
{
    DebugString("Leveling Position 3 of "+GetName(oObject));
    int nClass = MyGetClassByPosition(3, oObject);
    //if no levels in class3, then go by localint nClass3
    if(nClass == CLASS_TYPE_INVALID)
    {
        nClass = GetLocalInt(oObject, "nClass3");
        if(nClass == -1)
            nClass =CLASS_TYPE_BARBARIAN;
        //if no nClass3, get one at random
        else if(nClass == 0)
        {
            nClass = GetPrestigeClass(oObject, 3);
            //if there are no eligible presitge classes
            if(nClass == CLASS_TYPE_INVALID)
            {
                //if over Level30, choose a random non-prestige class
                if(GetHitDice(oObject) >= 30)
                    nClass = GetRandomClass(oObject, 3);
                else
                {
                //if under level30, levelup in position 2
                    return LevelUpInPos2(oObject);
                }
            }
        }
    }
    //just in case not levelable
    if(GetIsLevelable(nClass, oObject)==FALSE)
    {
        return LevelUpInPos2(oObject);
    }

    int nPackage = GetLocalInt(oObject, "nPackage3");
    //if no package picked already, choose one
    if(nPackage == 0)
    {
        nPackage = GetRandomPackage(nClass);
        SetLocalInt(oObject, "nPackage3", nPackage);
    }
    else if(nPackage == -1)
    {
        nPackage = PACKAGE_BARBARIAN;
        SetLocalInt(oObject, "nPackage3", nPackage);
    }

    //fudge around GetClassByPosition bug
    SetLocalInt(oObject, "ClassPos3", nClass);

    return LevelUpHenchman(oObject, nClass, TRUE, nPackage);
}

string ClassToString(int nClass)
{
    int nStrRef = StringToInt(Get2DACache("classes", "Name", nClass));
    string sReturn = GetStringByStrRef(nStrRef);
    return sReturn;
}

