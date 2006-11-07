#include "inc_utility"
#include "inc_letocommands"
#include "prc_ccc_inc"

//this tests of OBJECT_SELF meets the requirements for a speicific feat
int CheckFeatRequirements(int nFeatID);
//this tests of OBJECT_SELF meets the requirements for a speicific class
int CheckClassRequirements(int nClassID);

//specifit a skill token for nSkill at nPosition in the list
int SetupSkillToken(int nSkill, int nPosition);

int CheckFeatRequirements(int nFeatID)
{
    string sFeatTest;
    int i = nFeatID;
    int j;
    object oPC = OBJECT_SELF;
    //get some stored data
    int nStr = GetLocalInt(oPC, "Str");
    int nDex = GetLocalInt(oPC, "Dex");
    int nCon = GetLocalInt(oPC, "Con");
    int nInt = GetLocalInt(oPC, "Int");
    int nWis = GetLocalInt(oPC, "Wis");
    int nCha = GetLocalInt(oPC, "Cha");
    int nRace = GetLocalInt(oPC, "Race");
    int nLevel = GetLocalInt(oPC, "Level");
    int         nOrder =            GetLocalInt(oPC, "LawfulChaotic");
    int         nMoral =            GetLocalInt(oPC, "GoodEvil");
    //add racial ability alterations
    nStr += StringToInt(Get2DACache("racialypes", "StrAdjust", nRace));
    nDex += StringToInt(Get2DACache("racialypes", "DexAdjust", nRace));
    nCon += StringToInt(Get2DACache("racialypes", "ConAdjust", nRace));
    nInt += StringToInt(Get2DACache("racialypes", "IntAdjust", nRace));
    nWis += StringToInt(Get2DACache("racialypes", "WisAdjust", nRace));
    nCha += StringToInt(Get2DACache("racialypes", "ChaAdjust", nRace));
    for(j=1;j<=nLevel;j++)
    {
        //ability
        if(j == 3 || j == 7 || j == 11 || j == 15
                || j == 19 || j == 23 || j == 27 || j == 31
                || j == 13 || j == 39)
        {
            int nAbil = GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(j)+"Ability");
            switch(nAbil)
            {
                case ABILITY_STRENGTH:
                    nStr++;
                    break;
                case ABILITY_DEXTERITY:
                    nDex++;
                    break;
                case ABILITY_CONSTITUTION:
                    nCon++;
                    break;
                case ABILITY_INTELLIGENCE:
                    nInt++;
                    break;
                case ABILITY_WISDOM:
                    nWis++;
                    break;
                case ABILITY_CHARISMA:
                    nCha++;
                    break;
            }
        }
    }

    int nClass = GetLocalInt(oPC, "Class");
    int nSex = GetLocalInt(oPC, "Gender");

    //enforcement testing
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_BLOOD_OF_THE_WARLORD)
        && nFeatID == FEAT_BLOOD_OF_THE_WARLORD
        && nRace != RACIAL_TYPE_ORC
        && nRace != RACIAL_TYPE_GRAYORC
        && nRace != RACIAL_TYPE_HALFORC
//        && nRace != RACIAL_TYPE_QD_HALFORC
        && nRace != RACIAL_TYPE_TANARUKK
        && nRace != RACIAL_TYPE_OROG)
        return FALSE;
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_NIMBUSLIGHT)
        && nFeatID == FEAT_NIMBUSLIGHT
        && nMoral < 70)
        return FALSE;
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_HOLYRADIANCE)
        && nFeatID == FEAT_HOLYRADIANCE
        && nMoral < 70)
        return FALSE;
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_SERVHEAVEN)
        && nFeatID == FEAT_SERVHEAVEN
        && nMoral < 70)
        return FALSE;
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_SAC_VOW)
        && nFeatID == FEAT_SAC_VOW
        && nMoral < 70)
        return FALSE;
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VOW_OBED)
        && nFeatID == FEAT_VOW_OBED
        && (nMoral < 70 || nOrder < 70))
        return FALSE;
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_THRALL_TO_DEMON)
        && nFeatID == FEAT_THRALL_TO_DEMON
        && nMoral > 20)
        return FALSE;
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_DISCIPLE_OF_DARKNESS)
        && nFeatID == FEAT_DISCIPLE_OF_DARKNESS
        && nMoral > 20)
        return FALSE;
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_LICHLOVED)
        && nFeatID == FEAT_LICHLOVED
        && nMoral > 20)
        return FALSE;
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_EVIL_BRANDS)
        && (nFeatID == FEAT_EB_ARM
            || nFeatID == FEAT_EB_CHEST
            || nFeatID == FEAT_EB_HAND
            || nFeatID == FEAT_EB_HEAD)
        && nMoral > 20)
        return FALSE;
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VILE_WILL_DEFORM)
        && nFeatID == FEAT_VILE_WILL_DEFORM
        && nMoral > 20)
        return FALSE;
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_OBESE)
        && nFeatID == FEAT_VILE_DEFORM_OBESE
        && nMoral > 20)
        return FALSE;
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_GAUNT)
        && nFeatID == FEAT_VILE_DEFORM_GAUNT
        && nMoral > 20)
        return FALSE;

    //epic feat
    sFeatTest = Get2DACache("feat", "PreReqEpic",i);
    if(StringToInt(sFeatTest) == 1)
        return FALSE;

    //check BAB
    sFeatTest = Get2DACache("feat", "MINATTACKBONUS",i);
    int nBAB;
    for(j=0;j<=nLevel;j++)
    {
        nBAB += StringToInt(Get2DACache(Get2DACache("classes", "AttackBonusTable",nClass),"BAB",j));
    }
    if(StringToInt(sFeatTest) > nBAB)
        return FALSE;

    //caster level
    sFeatTest = Get2DACache("feat", "MINSPELLLVL",i);
    if(sFeatTest != "")
    {
        if(StringToInt(sFeatTest) > 1)
            return FALSE;
        else if(StringToInt(sFeatTest) == 1 &&
            (nClass != CLASS_TYPE_WIZARD
                && nClass != CLASS_TYPE_SORCERER
                && nClass != CLASS_TYPE_BARD
                && nClass != CLASS_TYPE_CLERIC
                && nClass != CLASS_TYPE_DRUID))
            return FALSE;
    }

    //prerequisite feats
    //two (1-2) AND (i.e need these)
    //5 (0-4) OR (i.e. need one of thse)
    int bReturn = FALSE;
    sFeatTest = Get2DACache("feat", "PREREQFEAT1",i);
    if(sFeatTest != "")
    {
        for(j=0;j<array_get_size(oPC, "Feats"); j++)
        {
            int nFeatID = array_get_int(oPC, "Feats", j);
            if(nFeatID == StringToInt(sFeatTest))
                bReturn = TRUE;
        }
        for(j=1;j<nLevel; j++)
        {
            int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
            if(nFeatID == StringToInt(sFeatTest))
                bReturn = TRUE;
        }
        if(bReturn == FALSE)
            return FALSE;
    }

    bReturn = FALSE;
    sFeatTest = Get2DACache("feat", "PREREQFEAT2",i);
    if(sFeatTest != "")
    {
        for(j=0;j<array_get_size(oPC, "Feats"); j++)
        {
            int nFeatID = array_get_int(oPC, "Feats", j);
            if(nFeatID == StringToInt(sFeatTest))
                bReturn = TRUE;
        }
        for(j=1;j<nLevel; j++)
        {
            int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
            if(nFeatID == StringToInt(sFeatTest))
                bReturn = TRUE;
        }
        if(bReturn == FALSE)
            return FALSE;
    }

    bReturn = FALSE;
    sFeatTest = Get2DACache("feat", "OrReqFeat0",i);
    if(sFeatTest != "")
    {
        for(j=0;j<array_get_size(oPC, "Feats"); j++)
        {
            int nFeatID = array_get_int(oPC, "Feats", j);
            if(nFeatID == StringToInt(sFeatTest))
                bReturn = TRUE;
        }
        for(j=1;j<nLevel; j++)
        {
            int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
            if(nFeatID == StringToInt(sFeatTest))
                bReturn = TRUE;
        }
        sFeatTest = Get2DACache("feat", "OrReqFeat1",i);
        if(sFeatTest != "")
        {
            for(j=0;j<array_get_size(oPC, "Feats"); j++)
            {
                int nFeatID = array_get_int(oPC, "Feats", j);
                if(nFeatID == StringToInt(sFeatTest))
                    bReturn = TRUE;
            }
            for(j=1;j<nLevel; j++)
            {
                int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                if(nFeatID == StringToInt(sFeatTest))
                    bReturn = TRUE;
            }
        }
        sFeatTest = Get2DACache("feat", "OrReqFeat2",i);
        if(sFeatTest != "")
        {
            for(j=0;j<array_get_size(oPC, "Feats"); j++)
            {
                int nFeatID = array_get_int(oPC, "Feats", j);
                if(nFeatID == StringToInt(sFeatTest))
                    bReturn = TRUE;
            }
            for(j=1;j<nLevel; j++)
            {
                int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                if(nFeatID == StringToInt(sFeatTest))
                    bReturn = TRUE;
            }
        }
        sFeatTest = Get2DACache("feat", "OrReqFeat3",i);
        if(sFeatTest != "")
        {
            for(j=0;j<array_get_size(oPC, "Feats"); j++)
            {
                int nFeatID = array_get_int(oPC, "Feats", j);
                if(nFeatID == StringToInt(sFeatTest))
                    bReturn = TRUE;
            }
            for(j=1;j<nLevel; j++)
            {
                int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                if(nFeatID == StringToInt(sFeatTest))
                    bReturn = TRUE;
            }
        }
        sFeatTest = Get2DACache("feat", "OrReqFeat4",i);
        if(sFeatTest != "")
        {
            for(j=0;j<array_get_size(oPC, "Feats"); j++)
            {
                int nFeatID = array_get_int(oPC, "Feats", j);
                if(nFeatID == StringToInt(sFeatTest))
                    bReturn = TRUE;
            }
            for(j=1;j<nLevel; j++)
            {
                int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                if(nFeatID == StringToInt(sFeatTest))
                    bReturn = TRUE;
            }
        }
        if(bReturn == FALSE)
            return FALSE;
    }
    //skills
    //skill and rank
    //two possibilities
    sFeatTest = Get2DACache("feat", "REQSKILL",i);
    if(sFeatTest != "")
    {
        int nSkillValue = GetLocalInt(oPC, "Skill"+sFeatTest);
        if(nSkillValue < StringToInt(Get2DACache("feat", "ReqSkillMinRanks",i)))
            return FALSE;
    }
    sFeatTest = Get2DACache("feat", "REQSKILL2",i);
    if(sFeatTest != "")
    {
        int nSkillValue = GetLocalInt(oPC, "Skill"+sFeatTest);
        if(nSkillValue < StringToInt(Get2DACache("feat", "ReqSkillMinRanks2",i)))
            return FALSE;
    }

    //check ability scores
    sFeatTest = Get2DACache("feat", "MINSTR",i);
    if(StringToInt(sFeatTest) > nStr)
        return FALSE;
    sFeatTest = Get2DACache("feat", "MINDEX",i);
    if(StringToInt(sFeatTest) > nDex)
        return FALSE;
    sFeatTest = Get2DACache("feat", "MINCON",i);
    if(StringToInt(sFeatTest) > nCon)
        return FALSE;
    sFeatTest = Get2DACache("feat", "MININT",i);
    if(StringToInt(sFeatTest) > nInt)
        return FALSE;
    sFeatTest = Get2DACache("feat", "MINWIS",i);
    if(StringToInt(sFeatTest) > nWis)
        return FALSE;
    sFeatTest = Get2DACache("feat", "MINCHA",i);
    if(StringToInt(sFeatTest) > nCha)
        return FALSE;

    //min level and class
    sFeatTest = Get2DACache("feat", "MinLevel",i);
    if(sFeatTest != "" && StringToInt(sFeatTest) > 1)
        return FALSE;
    sFeatTest = Get2DACache("feat", "MinLevelClass",i);
    if(sFeatTest != "" && StringToInt(sFeatTest) != nClass)
        return FALSE;

    //max level
    //not needed at the moment
    sFeatTest = Get2DACache("feat", "MaxLevel",i);

    //minimum fort save
    //only for energy feats
    sFeatTest = Get2DACache("feat", "MinFortSave",i);
    if(StringToInt(sFeatTest) > StringToInt(Get2DACache(Get2DACache("classes","SavingThrowTable" , nClass), "FortSave", 0)))
        return FALSE;

    return TRUE;
}

int CheckClassRequirements(int nClassID)
{
    int nPlayerClass = StringToInt(Get2DACache("classes", "PlayerClass", nClassID));
    if(nPlayerClass != 1)
        return FALSE;

    //this checks for base classes
    if(Get2DACache("classes", "EpicLevel", nClassID) != "-1")
        return FALSE;
    //alignment changes are checked for in alignment    
    //MaxLevel
    //not implemented
    //EpicLevel
    //not implemented
    string sPreReq = Get2DACache("classes", "PreReqTable", nClassID);
//now check the prereq table
//only variables implemented
    int i;
    for(i=0;i<GetPRCSwitch(FILE_END_CLASS_PREREQ);i++)
    {
        string sReqType = Get2DACache(sPreReq, "ReqType", i);
        string sParam1 = Get2DACache(sPreReq, "ReqParam1", i);
        string sParam2 = Get2DACache(sPreReq, "ReqParam2", i);
        //jump out if no more prereqs
        if(sReqType == "")
            return TRUE;
        if(sReqType ==  "SKILL")
        {}
        else if(sReqType ==  "FEAT")
        {}
        else if(sReqType ==  "FEATOR")
        {}
        else if(sReqType ==  "RACE")
        {}
        else if(sReqType ==  "CLASS")
        {}
        else if(sReqType ==  "CALSSOR")
        {}
        else if(sReqType ==  "BAB")
        {}
        else if(sReqType ==  "ARCSPELL")
        {}
        else if(sReqType ==  "DIVSPELL")
        {}
        else if(sReqType ==  "VAR")
        {
            if(GetLocalInt(OBJECT_SELF, sParam1) != StringToInt(sParam2))
                return FALSE;
        }
    }
    return TRUE;
}

void AddRaceFeats(int nRace)
{
    string sFile = GetStringLowerCase(Get2DACache("racialtypes", "FeatsTable", nRace));
    int i =0;
    string sFeat = Get2DACache(sFile, "FeatIndex", i);
    while(sFeat != "")
    {
        //aletness fix
        if(sFeat == "0")
            sFeat = "-1";
        array_create(OBJECT_SELF, "Feats");
        array_set_int(OBJECT_SELF, "Feats", array_get_size(OBJECT_SELF, "Feats"),
            StringToInt(sFeat));
        i++;
        sFeat = Get2DACache(sFile, "FeatIndex", i);
    }
}

void AddRaceSpecials(int nRace)
{
    string sFile = Get2DACache("racialtypes", "FeatsTable", nRace);
    int nPos = FindSubString(sFile, "_FEAT_");
    sFile = GetStringLeft(sFile, nPos)+"_SPEC_"+GetStringRight(sFile, GetStringLength(sFile)-(nPos+6));
    sFile = GetStringLowerCase(sFile);
    int i =0;
    string sSpec = Get2DACache(sFile, "SpellNumber", i) ;
    while(sSpec != "")
    {
        array_create(OBJECT_SELF, "SpecAbilID");
        array_create(OBJECT_SELF, "SpecAbilFlag");
        array_create(OBJECT_SELF, "SpecAbilLvl");
        array_set_int(OBJECT_SELF, "SpecAbilID", array_get_size(OBJECT_SELF, "SpecAbilID"),
            StringToInt(sSpec));
        array_set_int(OBJECT_SELF, "SpecAbilFlag", array_get_size(OBJECT_SELF, "SpecAbilFlag"),
            StringToInt(Get2DACache(sFile, "SpellFlags", i)));
        array_set_int(OBJECT_SELF, "SpecAbilLvl", array_get_size(OBJECT_SELF, "SpecAbilLvl"),
            StringToInt(Get2DACache(sFile, "SpellLevel", i)));
        i++;
        sSpec = Get2DACache(sFile, "SpellNumber", i);
    }
}

void DoCloneLetoscript()
{
    object oClone = GetLocalObject(OBJECT_SELF, "Clone");
    if(!GetIsObjectValid(oClone))
        return;
    int         nSoundset =         GetLocalInt(OBJECT_SELF, "Soundset");
    int         nSkin =             GetLocalInt(OBJECT_SELF, "Skin");
    int         nHair =             GetLocalInt(OBJECT_SELF, "Hair");
    int         nSex =              GetLocalInt(OBJECT_SELF, "Gender");
    int         nTattooColour1 =    GetLocalInt(OBJECT_SELF, "TattooColour1");
    int         nTattooColour2 =    GetLocalInt(OBJECT_SELF, "TattooColour2");
    StackedLetoScript(LetoSet("Gender", IntToString(nSex), "byte"));
    StackedLetoScript(LetoSet("SoundSetFile", IntToString(nSoundset), "word"));
    StackedLetoScript(SetSkinColor(nSkin));
    StackedLetoScript(SetHairColor(nHair));
    StackedLetoScript(SetTatooColor(nTattooColour1, 1));
    StackedLetoScript(SetTatooColor(nTattooColour2, 2));
    string sResult;
    RunStackedLetoScriptOnObject(oClone, "OBJECT", "SPAWN", "prc_ccc_app_lspw", TRUE);
    sResult = GetLocalString(GetModule(), "LetoResult");
    SetLocalObject(GetModule(), "PCForThread"+sResult, OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
}

//used to cleanup clones when a player leaves
void CloneMasterCheck();
void CloneMasterCheck()
{
    object oMaster = GetLocalObject(OBJECT_SELF, "Master");
    if(!GetIsObjectValid(oMaster))
    {
        SetIsDestroyable(TRUE);
        DestroyObject(OBJECT_SELF);
    }
    else
        DelayCommand(10.0, CloneMasterCheck());
}

void MakeClone()
{
        //make the real PC invisible
        effect eGhost = EffectCutsceneGhost();
        effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGhost, OBJECT_SELF, 99999999.9);
        //apply the invis effect after the copy is made. otherwise the copy is invisible too
        //create a copy of the PC we can manipulate with letoscript
        effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(OBJECT_SELF));
        object oClone = CopyObject(OBJECT_SELF, GetLocation(OBJECT_SELF), OBJECT_INVALID, "PlayerClone");
        //move it to a standard faction so it can be henchmaned/dominated
        ChangeToStandardFaction(oClone, STANDARD_FACTION_MERCHANT);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, OBJECT_SELF, 9999.9);
        //set locals back and forth between PC and clone
        SetLocalObject(OBJECT_SELF, "Clone", oClone);
        SetLocalObject(oClone, "Master", OBJECT_SELF);
        // start the clone checking that its master is still ingame
        AssignCommand(oClone, CloneMasterCheck());
        //add the clone so the PC can see its portrait
//        effect eDom = EffectCutsceneDominated();
//        AssignCommand(OBJECT_SELF, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDom, oClone));
//        AddHenchman(OBJECT_SELF, oClone);
        //strip the clone so the player can see tatoos
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oClone);
        AssignCommand(oClone, ActionUnequipItem(oArmor));
        DestroyObject(oArmor, 5.0);
        //make sure the clone stays put
        effect eParal = EffectCutsceneImmobilize();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oClone, 9999.9);
}

void DoRotatingCamera()
{
    object oPC = OBJECT_SELF;
    if(!GetIsObjectValid(oPC))
        return;
    if(GetLocalInt(oPC, "StopRotatingCamera"))
    {
        DeleteLocalInt(oPC, "StopRotatingCamera");
        DeleteLocalFloat(oPC, "DoRotatingCamera");
        return;
    }
    float fDirection = GetLocalFloat(oPC, "DoRotatingCamera");
    fDirection += 30.0;
    if(fDirection > 360.0)
        fDirection -= 360.0;
    if(fDirection <= 0.0)
        fDirection += 360.0;
    SetLocalFloat(oPC, "DoRotatingCamera", fDirection);
    SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
    SetCameraFacing(fDirection, 4.0, 45.0, CAMERA_TRANSITION_TYPE_VERY_SLOW);
    DelayCommand(6.0, DoRotatingCamera());
    //its the clone not the PC that does things
    object oClone = GetLocalObject(oPC, "Clone");
    if(GetIsObjectValid(oClone))
        oPC = oClone;
    if(d2()==1)
        AssignCommand(oPC, ActionPlayAnimation(100+Random(17)));
    else
        AssignCommand(oPC, ActionPlayAnimation(100+Random(21), 1.0, 6.0));
}
