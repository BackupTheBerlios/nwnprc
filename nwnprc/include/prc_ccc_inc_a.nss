#include "inc_utility"
#include "prc_ccc_inc_b"
#include "prc_ccc_inc_e"
#include "prc_ccc_inc_f"

//make the array of tokens for that stage
void SetupStage();

void SetupStage()
{
    int nStage  = GetLocalInt(OBJECT_SELF, "Stage");
    array_create(OBJECT_SELF, "StagesSetup");
    if(array_get_int(OBJECT_SELF, "StagesSetup", nStage))
        return;
    //stage has changed, clear the choice array
    array_delete(OBJECT_SELF, "ChoiceTokens");
    array_create(OBJECT_SELF, "ChoiceTokens");
    array_delete(OBJECT_SELF, "ChoiceValue");
    array_create(OBJECT_SELF, "ChoiceValue");
    DeleteLocalInt(OBJECT_SELF, "ChoiceOffset");
    //setup variables
    int nRace = GetLocalInt(OBJECT_SELF, "Race");
    int nClass = GetLocalInt(OBJECT_SELF, "Class");
    int nGender = GetLocalInt(OBJECT_SELF, "Gender");
    int nStr = GetLocalInt(OBJECT_SELF, "Str");
    int nDex = GetLocalInt(OBJECT_SELF, "Dex");
    int nCon = GetLocalInt(OBJECT_SELF, "Con");
    int nInt = GetLocalInt(OBJECT_SELF, "Int");
    int nWis = GetLocalInt(OBJECT_SELF, "Wis");
    int nCha = GetLocalInt(OBJECT_SELF, "Cha");
    int nPoints = GetLocalInt(OBJECT_SELF, "Points");

    //switch to different stages
    int i;
    string sName;
    string sFile;
    switch(nStage)
    {
        case STAGE_GENDER:
            sName = Get2DACache("gender", "NAME", i);
            while(i < GENDER_2DA_END)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens",
                    array_get_size(OBJECT_SELF, "ChoiceTokens"),
                        GetStringByStrRef(StringToInt(sName)));
                array_set_int(OBJECT_SELF, "ChoiceValue",
                    array_get_size(OBJECT_SELF, "ChoiceValue"),
                        i);
                i++;
                sName = Get2DACache("gender", "NAME", i);
            }
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

        case STAGE_RACE:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, RaceLoop());
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

        case STAGE_CLASS:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, ClassLoop());
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

        case STAGE_ALIGNMENT:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            i=0;
            if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_GOOD,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i, GetStringByStrRef(112));
                array_set_int(OBJECT_SELF, "ChoiceValue", i, 0);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i, GetStringByStrRef(115));
                array_set_int(OBJECT_SELF, "ChoiceValue", i, 1);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i, GetStringByStrRef(118));
                array_set_int(OBJECT_SELF, "ChoiceValue", i, 2);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i, GetStringByStrRef(113));
                array_set_int(OBJECT_SELF, "ChoiceValue", i, 3);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i, GetStringByStrRef(116));
                array_set_int(OBJECT_SELF, "ChoiceValue", i, 4);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i, GetStringByStrRef(119));
                array_set_int(OBJECT_SELF, "ChoiceValue", i, 5);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_EVIL,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i, GetStringByStrRef(114));
                array_set_int(OBJECT_SELF, "ChoiceValue", i, 6);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i, GetStringByStrRef(117));
                array_set_int(OBJECT_SELF, "ChoiceValue", i, 7);
                i++;
            }
            if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL,
                HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                HexToInt(Get2DACache("classes", "InvertRestrict",nClass)))==TRUE)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i, GetStringByStrRef(120));
                array_set_int(OBJECT_SELF, "ChoiceValue", i, 8);
                i++;
            }
            DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

        case STAGE_ABILITY:
            //this one is done manually
            //first setup
            if(GetLocalInt(OBJECT_SELF, "Str") == 0)
            {
                SetLocalInt(OBJECT_SELF, "Points", 30);
                //add race bonuses
                SetLocalInt(OBJECT_SELF, "Str", 8);
                SetLocalInt(OBJECT_SELF, "Dex", 8);
                SetLocalInt(OBJECT_SELF, "Con", 8);
                SetLocalInt(OBJECT_SELF, "Int", 8);
                SetLocalInt(OBJECT_SELF, "Wis", 8);
                SetLocalInt(OBJECT_SELF, "Cha", 8);
                nStr = GetLocalInt(OBJECT_SELF, "Str");
                nDex = GetLocalInt(OBJECT_SELF, "Dex");
                nCon = GetLocalInt(OBJECT_SELF, "Con");
                nInt = GetLocalInt(OBJECT_SELF, "Int");
                nWis = GetLocalInt(OBJECT_SELF, "Wis");
                nCha = GetLocalInt(OBJECT_SELF, "Cha");
                nPoints = GetLocalInt(OBJECT_SELF, "Points");
            }
            if(nStr < 18  && nPoints >= GetCost(nStr+1))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i,
                    IntToString(nStr)+" "+GetStringByStrRef(135)+". "+GetStringByStrRef(137)+" "
                        +IntToString(GetCost(nStr+1))+"."
                        +" (Racial "+Get2DACache("racialtypes", "StrAdjust", nRace)+")");
                array_set_int(OBJECT_SELF, "ChoiceValue", i, ABILITY_STRENGTH);
                i++;
            }
            if(nDex < 18 && nPoints >= GetCost(nDex+1))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i,
                    IntToString(nDex)+" "+GetStringByStrRef(133)+". "+GetStringByStrRef(137)+" "
                        +IntToString(GetCost(nDex+1))+"."
                        +" (Racial "+Get2DACache("racialtypes", "DexAdjust", nRace)+")");
                array_set_int(OBJECT_SELF, "ChoiceValue", i, ABILITY_DEXTERITY);
                i++;
            }
            if(nCon < 18 && nPoints >= GetCost(nCon+1))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i,
                    IntToString(nCon)+" "+GetStringByStrRef(132)+". "+GetStringByStrRef(137)+" "
                        +IntToString(GetCost(nCon+1))+"."
                        +" (Racial "+Get2DACache("racialtypes", "ConAdjust", nRace)+")");
                array_set_int(OBJECT_SELF, "ChoiceValue", i, ABILITY_CONSTITUTION);
                i++;
            }
            if(nInt < 18 && nPoints >= GetCost(nInt+1))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i,
                    IntToString(nInt)+" "+GetStringByStrRef(134)+". "+GetStringByStrRef(137)+" "
                        +IntToString(GetCost(nInt+1))+"."
                        +" (Racial "+Get2DACache("racialtypes", "IntAdjust", nRace)+")");
                array_set_int(OBJECT_SELF, "ChoiceValue", i, ABILITY_INTELLIGENCE);
                i++;
            }
            if(nWis < 18 && nPoints >= GetCost(nWis+1))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i,
                    IntToString(nWis)+" "+GetStringByStrRef(136)+". "+GetStringByStrRef(137)+" "
                        +IntToString(GetCost(nWis+1))+"."
                        +" (Racial "+Get2DACache("racialtypes", "WisAdjust", nRace)+")");
                array_set_int(OBJECT_SELF, "ChoiceValue", i, ABILITY_WISDOM);
                i++;
            }
            if(nCha < 18 && nPoints >= GetCost(nCha+1))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens", i,
                    IntToString(nCha)+" "+GetStringByStrRef(131)+". "+GetStringByStrRef(137)+" "
                        +IntToString(GetCost(nCha+1))+"."
                        +" (Racial "+Get2DACache("racialtypes", "ChaAdjust", nRace)+")");
                array_set_int(OBJECT_SELF, "ChoiceValue", i, ABILITY_CHARISMA);
                i++;
            }
            break;

        case STAGE_SKILL:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, SkillLoop());
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

    // this has a wait while lookup
        case STAGE_FEAT:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, FeatLoop());
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

        case STAGE_FAMILIAR:
            if(nClass != CLASS_TYPE_WIZARD
                && nClass != CLASS_TYPE_SORCERER)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens",
                    array_get_size(OBJECT_SELF, "ChoiceTokens"),
                        "You cannot select a familiar.");
                array_set_int(OBJECT_SELF, "ChoiceValue",
                    array_get_size(OBJECT_SELF, "ChoiceValue"),
                        -1);
                array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
                break;
            }
            sName = Get2DACache("hen_familiar", "STRREF", i);
            while(i < FAMILIAR_2DA_END)
            {
                if(sName != "")
                {
                    array_set_string(OBJECT_SELF, "ChoiceTokens",
                        array_get_size(OBJECT_SELF, "ChoiceTokens"),
                            GetStringByStrRef(StringToInt(sName)));
                    array_set_int(OBJECT_SELF, "ChoiceValue",
                        array_get_size(OBJECT_SELF, "ChoiceValue"),
                            i);
                }
                i++;
                sName = Get2DACache("hen_familiar", "STRREF", i);
            }
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

        case STAGE_ANIMALCOMP:
            if(nClass != CLASS_TYPE_DRUID)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens",
                    array_get_size(OBJECT_SELF, "ChoiceTokens"),
                        "You cannot select an animal companion.");
                array_set_int(OBJECT_SELF, "ChoiceValue",
                    array_get_size(OBJECT_SELF, "ChoiceValue"),
                        -1);
                array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
                break;
            }
            sName = Get2DACache("hen_companion", "STRREF", i);
            while(i < ANIMALCOMP_2DA_END)
            {
                if(sName != "")
                {
                    array_set_string(OBJECT_SELF, "ChoiceTokens",
                        array_get_size(OBJECT_SELF, "ChoiceTokens"),
                            GetStringByStrRef(StringToInt(sName)));
                    array_set_int(OBJECT_SELF, "ChoiceValue",
                        array_get_size(OBJECT_SELF, "ChoiceValue"),
                            i);
                }
                i++;
                sName = Get2DACache("hen_companion", "STRREF", i);
            }
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

        case STAGE_DOMAIN1:
            if(nClass != CLASS_TYPE_CLERIC)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens",
                    array_get_size(OBJECT_SELF, "ChoiceTokens"),
                        "You cannot select domains.");
                array_set_int(OBJECT_SELF, "ChoiceValue",
                    array_get_size(OBJECT_SELF, "ChoiceValue"),
                        -1);
                array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
                break;
            }
            sName = Get2DACache("domains", "Name", i);
            while(i < DOMAINS_2DA_END)
            {
                if(sName != "")
                {
                    if((nRace == RACIAL_TYPE_AIR_GEN
                        && i != 0
                        && GetPRCSwitch(PRC_CONVOCC_GENSAI_ENFORCE_DOMAINS))
                        || (nRace == RACIAL_TYPE_EARTH_GEN
                        && i != 5
                        && GetPRCSwitch(PRC_CONVOCC_GENSAI_ENFORCE_DOMAINS))
                        || (nRace == RACIAL_TYPE_FIRE_GEN
                        && i != 7
                        && GetPRCSwitch(PRC_CONVOCC_GENSAI_ENFORCE_DOMAINS))
                        || (nRace == RACIAL_TYPE_WATER_GEN
                        && i != 21
                        && GetPRCSwitch(PRC_CONVOCC_GENSAI_ENFORCE_DOMAINS))
                        )
                    {
                    }
                    else
                    {
                    array_set_string(OBJECT_SELF, "ChoiceTokens",
                        array_get_size(OBJECT_SELF, "ChoiceTokens"),
                            GetStringByStrRef(StringToInt(sName)));
                    array_set_int(OBJECT_SELF, "ChoiceValue",
                        array_get_size(OBJECT_SELF, "ChoiceValue"),
                            i);
                    }
                }
                i++;
                sName = Get2DACache("domains", "Name", i);
            }
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

        case STAGE_DOMAIN2:
            if(nClass != CLASS_TYPE_CLERIC)
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens",
                    array_get_size(OBJECT_SELF, "ChoiceTokens"),
                        "You cannot select domains.");
                array_set_int(OBJECT_SELF, "ChoiceValue",
                    array_get_size(OBJECT_SELF, "ChoiceValue"),
                        -1);
                array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
                break;
            }
            sName = Get2DACache("domains", "Name", i);
            while(i < DOMAINS_2DA_END)
            {
                if(sName != "" &&
                    GetLocalInt(OBJECT_SELF, "Domain1") != i)
                {
                    array_set_string(OBJECT_SELF, "ChoiceTokens",
                        array_get_size(OBJECT_SELF, "ChoiceTokens"),
                            GetStringByStrRef(StringToInt(sName)));
                    array_set_int(OBJECT_SELF, "ChoiceValue",
                        array_get_size(OBJECT_SELF, "ChoiceValue"),
                            i);
                }
                i++;
                sName = Get2DACache("domains", "Name", i);
            }
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

        case STAGE_SPELLS:
            switch(nClass)
            {
                case CLASS_TYPE_WIZARD:
                    //check for first spell
                    if(GetLocalInt(OBJECT_SELF, "NumberOfSpells") <=0)
                    {
                        //wizards get to pick 6 spells at level 1
                        //and 2 at each level thereafter
                        SetLocalInt(OBJECT_SELF, "NumberOfSpells",6);
                        //wizards also get all cantrips known for free
                            //this is done in the loop however
                        //now start the loop to fill in the choices
                        SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
                        DelayCommand(0.01, SpellLoop());
                        array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
                    }
                    break;
                case CLASS_TYPE_SORCERER:
                    //check for first spell
                    if(GetLocalInt(OBJECT_SELF, "NumberOfSpells") <=0)
                    {
                        //sorcerers get 4 level 0 spells and 2 level 1 spells
                        SetLocalInt(OBJECT_SELF, "NumberOfSpells", StringToInt(
                            Get2DACache("cls_spkn_sorc", "SpellLevel"+IntToString(
                                GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")),0 )));
                        //spells per day for this level
                        SetLocalInt(OBJECT_SELF, "SpellsPerDay"+IntToString(GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")),
                            StringToInt(Get2DACache("cls_spgn_sorc", "SpellLevel"+IntToString(GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")),0)));
                        //now start the loop to fill in the choices
                        SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
                        DelayCommand(0.01, SpellLoop());
                        array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
                    }
                    break;
                case CLASS_TYPE_BARD:
                    if(GetLocalInt(OBJECT_SELF, "NumberOfSpells") <=0)
                    {
                        //sorcerers get 4 level 0 spells and 2 level 1 spells
                        SetLocalInt(OBJECT_SELF, "NumberOfSpells", StringToInt(
                            Get2DACache("cls_spkn_bard", "SpellLevel"+IntToString(
                                GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")),0 )));
                        //spells per day for this level
                        SetLocalInt(OBJECT_SELF, "SpellsPerDay"+IntToString(GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")),
                            StringToInt(Get2DACache("cls_spgn_bard", "SpellLevel"+IntToString(GetLocalInt(OBJECT_SELF, "CurrentSpellLevel")),0)));
                        //now start the loop to fill in the choices
                        SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
                        DelayCommand(0.01, SpellLoop());
                        array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
                    }
                    break;
                default:
                    //if the character is not a wizard/bard/sorcerer
                    //then go to next stage
                    array_set_string(OBJECT_SELF, "ChoiceTokens",
                        array_get_size(OBJECT_SELF, "ChoiceTokens"),
                            "You cannot select spells to learn.");
                    array_set_int(OBJECT_SELF, "ChoiceValue",
                        array_get_size(OBJECT_SELF, "ChoiceValue"),
                            -1);
                    array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
                break;
            }
            break;

        case STAGE_WIZ_SCHOOL:
            if(nClass !=CLASS_TYPE_WIZARD)
            {
                    //if the character is not a wizard
                    //then go to next stage
                    array_set_string(OBJECT_SELF, "ChoiceTokens",
                        array_get_size(OBJECT_SELF, "ChoiceTokens"),
                            "You cannot select a spell school.");
                    array_set_int(OBJECT_SELF, "ChoiceValue",
                        array_get_size(OBJECT_SELF, "ChoiceValue"),
                            -1);
            }
            else
            {
                for(i=0;i<SPELLSCHOOL_2DA_END;i++)
                {
                    if(StringToInt(Get2DACache("spellschools", "StringRef", i)) != 0)
                    {
                    array_set_string(OBJECT_SELF, "ChoiceTokens",
                        array_get_size(OBJECT_SELF, "ChoiceTokens"),
                            GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", i))));
                    array_set_int(OBJECT_SELF, "ChoiceValue",
                        array_get_size(OBJECT_SELF, "ChoiceValue"),
                            i);

                    }
                }
            }
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

        case STAGE_BONUS_FEAT:
            if(StringToInt(Get2DACache(Get2DACache("Classes", "BonusFeatsTable", nClass), "Bonus", 0))<=0)
            {
                    //if the character canot take any bonus feats
                    //then go to next stage
                    array_set_string(OBJECT_SELF, "ChoiceTokens",
                        array_get_size(OBJECT_SELF, "ChoiceTokens"),
                            "You cannot select a bonus feat.");
                    array_set_int(OBJECT_SELF, "ChoiceValue",
                        array_get_size(OBJECT_SELF, "ChoiceValue"),
                            -1);
            }
            else
            {
                SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
                DelayCommand(0.01, BonusFeatLoop());
            }
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

        case STAGE_GENDER_CHECK:
        case STAGE_RACE_CHECK:
        case STAGE_CLASS_CHECK:
        case STAGE_ALIGNMENT_CHECK:
        case STAGE_ABILITY_CHECK:
        case STAGE_SKILL_CHECK:
        case STAGE_FEAT_CHECK:
        case STAGE_FAMILIAR_CHECK:
        case STAGE_ANIMALCOMP_CHECK:
        case STAGE_DOMAIN_CHECK:
        case STAGE_SPELLS_CHECK:
        case STAGE_BONUS_FEAT_CHECK:
        case STAGE_WIZ_SCHOOL_CHECK:
        case STAGE_HAIR_CHECK:
        case STAGE_HEAD_CHECK:
        case STAGE_SKIN_CHECK:
        case STAGE_TAIL_CHECK:
        case STAGE_WINGS_CHECK:
        case STAGE_APPEARANCE_CHECK:
        case STAGE_TATTOOCOLOUR1_CHECK:
        case STAGE_TATTOOCOLOUR2_CHECK:
        case STAGE_TATTOOPART_CHECK:
        case STAGE_RACIAL_ABILITY_CHECK:
        case STAGE_RACIAL_SKILL_CHECK:
        case STAGE_RACIAL_FEAT_CHECK:
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "No");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    -1);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Yes");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    1);
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_APPEARANCE:
            if(GetPRCSwitch(PRC_CONVOCC_USE_RACIAL_APPEARANCES))
                SetupRacialAppearances();
            else
            {
                AppearanceLoop();
                SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            }
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_HAIR:
            SetupHair();
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_HEAD:
            SetupHead();
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_PORTRAIT:
            if(GetPRCSwitch(PRC_CONVOCC_ALLOW_TO_KEEP_PORTRAIT))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens",
                    array_get_size(OBJECT_SELF, "ChoiceTokens"),
                        "Keep exisiting portrait.");
                array_set_int(OBJECT_SELF, "ChoiceValue",
                    array_get_size(OBJECT_SELF, "ChoiceValue"),
                        -1);
            }
            if(GetPRCSwitch(PRC_CONVOCC_USE_RACIAL_PORTRAIT))
            {
                SetupRacialPortrait();
            }
            else
            {
                PortraitLoop();
                SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            }
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_PORTRAIT_CHECK:
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "View this portrait.");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    2);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "No.");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    -1);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Yes.");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    1);
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_SKIN:
             SetupSkin();
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_SOUNDSET:
            if(GetPRCSwitch(PRC_CONVOCC_ALLOW_TO_KEEP_VOICESET))
            {
                array_set_string(OBJECT_SELF, "ChoiceTokens",
                    array_get_size(OBJECT_SELF, "ChoiceTokens"),
                        "Keep exisiting soundset.");
                array_set_int(OBJECT_SELF, "ChoiceValue",
                    array_get_size(OBJECT_SELF, "ChoiceValue"),
                        -1);
            }
            if(GetPRCSwitch(PRC_CONVOCC_USE_RACIAL_VOICESET))
                SetupRacialSoundset();
            else
            {
                SoundsetLoop();
                SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            }
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_SOUNDSET_CHECK:
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Listen to this soundset.");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    2);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "No.");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    -1);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Yes.");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    1);
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_TAIL:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "none");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    0);
            TailLoop();
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_WINGS:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "none");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    0);
            WingLoop();
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_TATTOOCOLOUR1:
        case STAGE_TATTOOCOLOUR2:
            SetupTattooColours();
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_TATTOOPART:
            SetupTattooParts();
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;


        case STAGE_RACIAL_ABILITY:
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Strength");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    ABILITY_STRENGTH);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Dexterity");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    ABILITY_DEXTERITY);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Constitution");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    ABILITY_CONSTITUTION);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Intelligence");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    ABILITY_INTELLIGENCE);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Wisdom");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    ABILITY_WISDOM);
            array_set_string(OBJECT_SELF, "ChoiceTokens",
                array_get_size(OBJECT_SELF, "ChoiceTokens"),
                    "Charisma");
            array_set_int(OBJECT_SELF, "ChoiceValue",
                array_get_size(OBJECT_SELF, "ChoiceValue"),
                    ABILITY_CHARISMA);
            break;
        case STAGE_RACIAL_SKILL:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, SkillLoop());
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;
        case STAGE_RACIAL_FEAT:
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DeleteLocalInt(OBJECT_SELF, "i");
            DelayCommand(0.01, FeatLoop());
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            break;

        case FINAL_STAGE:
            array_set_int(OBJECT_SELF, "StagesSetup", nStage, TRUE);
            SetLocalInt(OBJECT_SELF, "DoMake", TRUE);
            break;
        default:
            break;
    }
}
