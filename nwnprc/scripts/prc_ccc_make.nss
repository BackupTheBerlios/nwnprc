#include "inc_utility"
#include "inc_letocommands"
#include "inc_fileends"
#include "prc_inc_racial"
#include "prc_ccc_inc"
#include "inc_encrypt"

void CheckAndBoot(object oPC)
{
    if(GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))))
        BootPC(oPC);
}

void main()
{
    //define some varaibles
//    object oPC = GetPCSpeaker();//OBJECT_SELF;
//    if(!GetIsObjectValid(oPC))
//        oPC = OBJECT_SELF;
//    if(!GetIsObjectValid(oPC))
//        return;
    object oPC = OBJECT_SELF;
    int i;
    //get some stored data
    int         nStr =              GetLocalInt(oPC, "Str");
    int         nDex =              GetLocalInt(oPC, "Dex");
    int         nCon =              GetLocalInt(oPC, "Con");
    int         nInt =              GetLocalInt(oPC, "Int");
    int         nWis =              GetLocalInt(oPC, "Wis");
    int         nCha =              GetLocalInt(oPC, "Cha");

    int         nRace =             GetLocalInt(oPC, "Race");

    int         nClass =            GetLocalInt(oPC, "Class");
    int         nHitPoints =        GetLocalInt(oPC, "HitPoints");

    int         nSex =              GetLocalInt(oPC, "Gender");

    int         nOrder =            GetLocalInt(oPC, "LawfulChaotic");
    int         nMoral =            GetLocalInt(oPC, "GoodEvil");


    int         nFamiliar =         GetLocalInt(oPC, "Familiar");

    int         nAnimalCompanion =  GetLocalInt(oPC, "AnimalCompanion");

    int         nDomain1 =          GetLocalInt(oPC, "Domain1");
    int         nDomain2 =          GetLocalInt(oPC, "Domain2");

    int         nSchool =           GetLocalInt(oPC, "School");

    int         nSpellsPerDay0 =    GetLocalInt(oPC, "SpellsPerDay0");
    int         nSpellsPerDay1 =    GetLocalInt(oPC, "SpellsPerDay1");

    int         nWings  =           GetLocalInt(oPC, "Wings");
    int         nTail =             GetLocalInt(oPC, "Tail");
    int         nPortrait =         GetLocalInt(oPC, "Portrait");
    int         nAppearance =       GetLocalInt(oPC, "Appearance");
    int         nVoiceset =         GetLocalInt(oPC, "Soundset");
    int         nSkin =             GetLocalInt(oPC, "Skin");
    int         nHair =             GetLocalInt(oPC, "Hair");
    int         nHead =             GetLocalInt(oPC, "Head");

    int         nLevel =            GetLocalInt(oPC, "Level");

//game does this for you
//    nStr+= StringToInt(Get2DACache("racialtypes", "StrAdjust", nRace));
//    nDex+= StringToInt(Get2DACache("racialtypes", "DexAdjust", nRace));
//    nCon+= StringToInt(Get2DACache("racialtypes", "ConAdjust", nRace));
//    nInt+= StringToInt(Get2DACache("racialtypes", "IntAdjust", nRace));
//    nWis+= StringToInt(Get2DACache("racialtypes", "WisAdjust", nRace));
//    nCha+= StringToInt(Get2DACache("racialtypes", "ChaAdjust", nRace));
//    nHitPoints += (nCon-10)/2;

    //clear existing stuff
    string sScript;
    sScript += LetoDelete("FeatList");
    sScript += LetoDelete("ClassList");
    sScript += LetoDelete("LvlStatList");
    sScript += LetoDelete("SkillList");
    sScript += LetoAdd("FeatList", "", "list");
    sScript += LetoAdd("ClassList", "", "list");
    sScript += LetoAdd("LvlStatList", "", "list");
    sScript += LetoAdd("SkillList", "", "list");

    //Sex
    sScript += SetGender(nSex);

    //Race
    sScript += SetRace(nRace);

    //Class
    sScript += LetoAdd("ClassList/Class", IntToString(nClass), "int");
    sScript += LetoSet("ClassList/[0]/ClassLevel", IntToString(nLevel+1), "short");
    sScript += LetoAdd("LvlStatList/LvlStatClass", IntToString(nClass), "byte");
    sScript += LetoSet("LvlStatList/[0]/EpicLevel", "0", "byte");
    sScript += LetoSet("LvlStatList/[0]/LvlStatHitDie", IntToString(nHitPoints), "byte");
    sScript += LetoSet("LvlStatList/[0]/FeatList", "", "list");
    sScript += LetoSet("LvlStatList/[0]/SkillList", "", "list");

    //Alignment
    sScript += LetoSet("LawfulChaotic", IntToString(nOrder), "byte");
    sScript += LetoSet("GoodEvil", IntToString(nMoral), "byte");

    //Familiar
    //has a random name
    if(nClass == CLASS_TYPE_WIZARD
        || nClass == CLASS_TYPE_SORCERER)
    {
        sScript += LetoSet("FamiliarType", IntToString(nFamiliar), "int");
        sScript += LetoSet("FamiliarName", RandomName(), "string");
    }

    //Animal Companion
    //has a random name
    if(nClass == CLASS_TYPE_DRUID)
    {
        sScript += LetoSet("CompanionType", IntToString(nAnimalCompanion), "int");
        sScript += LetoSet("CompanionName", RandomName(), "string");
    }

    //Domains
    if(nClass == CLASS_TYPE_CLERIC)
    {
        sScript += LetoSet("ClassList/[0]/Domain1", IntToString(nDomain1), "byte");
        sScript += LetoSet("ClassList/[0]/Domain2", IntToString(nDomain2), "byte");
    }

    //Ability Scores
    sScript += SetAbility(ABILITY_STRENGTH, nStr);
    sScript += SetAbility(ABILITY_DEXTERITY, nDex);
    sScript += SetAbility(ABILITY_CONSTITUTION, nCon);
    sScript += SetAbility(ABILITY_INTELLIGENCE, nInt);
    sScript += SetAbility(ABILITY_WISDOM, nWis);
    sScript += SetAbility(ABILITY_CHARISMA, nCha);

    //Feats
    //Make sure the list exists
    //Populate the list from array
    for(i=0;i<array_get_size(oPC, "Feats"); i++)
    {
        string si = IntToString(i);
        int nFeatID =array_get_int(oPC, "Feats", i);
        if(nFeatID != 0)
        {
            if(nFeatID == -1)//alertness fix
                nFeatID = 0;
//            DoDebug("Feat array positon "+IntToString(i)+" is "+IntToString(nFeatID));
            sScript += LetoAdd("FeatList/Feat", IntToString(nFeatID), "word");
            sScript += LetoAdd("LvlStatList/[0]/FeatList/Feat", IntToString(nFeatID), "word");
        }
    }

    //Skills
    for (i=0;i<SKILLS_2DA_END;i++)
    {
        sScript += LetoAdd("SkillList/Rank", IntToString(array_get_int(oPC, "Skills", i)), "byte");
        sScript += LetoAdd("LvlStatList/[_]/SkillList/Rank", IntToString(array_get_int(oPC, "Skills", i)), "char");
    }
    sScript += LetoSet("SkillPoints", IntToString(array_get_int(oPC, "Skills", -1)), "word");
    sScript += LetoAdd("LvlStatList/[_]/SkillPoints", IntToString(array_get_int(oPC, "Skills", -1)), "word");

    //Spells
    if(nClass == CLASS_TYPE_WIZARD)
    {
        sScript += LetoSet("ClassList/[_]/KnownList0", "", "list");
        sScript += LetoSet("ClassList/[_]/KnownList1", "", "list");
        sScript += LetoSet("LvlStatList/[_]/KnownList0", "", "list");
        sScript += LetoSet("LvlStatList/[_]/KnownList1", "", "list");
        for (i=0;i<array_get_size(oPC, "SpellLvl0");i++)
        {
            sScript += LetoAdd("ClassList/[_]/KnownList0/Spell", IntToString(array_get_int(oPC, "SpellLvl0", i)), "word");
            sScript += LetoAdd("LvlStatList/[_]/KnownList0/Spell", IntToString(array_get_int(oPC, "SpellLvl0", i)), "word");
        }
        for (i=0;i<array_get_size(oPC, "SpellLvl1");i++)
        {
            sScript += LetoAdd("ClassList/[_]/KnownList1/Spell", IntToString(array_get_int(oPC, "SpellLvl1", i)), "word");
            sScript += LetoAdd("LvlStatList/[_]/KnownList1/Spell", IntToString(array_get_int(oPC, "SpellLvl1", i)), "word");
        }
        //throw spellschoool in here too
        sScript += LetoSet("ClassList/[_]/School", IntToString(nSchool), "byte");
    }
    else if (nClass == CLASS_TYPE_BARD)
    {
        sScript += LetoSet("ClassList/[_]/KnownList0", "", "list");
        sScript += LetoSet("ClassList/[_]/SpellsPerDayList", "", "list");
        sScript += LetoSet("LvlStatList/[_]/KnownList0", "", "list");
        for (i=0;i<array_get_size(oPC, "SpellLvl0");i++)
        {
            sScript += LetoAdd("ClassList/[_]/KnownList0/Spell", IntToString(array_get_int(oPC, "SpellLvl0", i)), "word");
            sScript += LetoAdd("LvlStatList/[_]/KnownList0/Spell", IntToString(array_get_int(oPC, "SpellLvl0", i)), "word");
        }
        //spells per day
        sScript += LetoAdd("ClassList/[_]/SpellsPerDayList/NumSpellsLeft", IntToString(nSpellsPerDay0), "word");
    }
    else if (nClass == CLASS_TYPE_SORCERER)
    {
        sScript += LetoSet("ClassList/[_]/KnownList0", "", "list");
        sScript += LetoSet("ClassList/[_]/KnownList1", "", "list");
        sScript += LetoSet("ClassList/[_]/SpellsPerDayList", "", "list");
        sScript += LetoSet("LvlStatList/[_]/KnownList0", "", "list");
        sScript += LetoSet("LvlStatList/[_]/KnownList1", "", "list");
        for (i=0;i<array_get_size(oPC, "SpellLvl0");i++)
        {
            sScript += LetoAdd("ClassList/[_]/KnownList0/Spell", IntToString(array_get_int(oPC, "SpellLvl0", i)), "word");
            sScript += LetoAdd("LvlStatList/[_]/KnownList0/Spell", IntToString(array_get_int(oPC, "SpellLvl0", i)), "word");
        }
        for (i=0;i<array_get_size(oPC, "SpellLvl1");i++)
        {
            sScript += LetoAdd("ClassList/[_]/KnownList1/Spell", IntToString(array_get_int(oPC, "SpellLvl1", i)), "word");
            sScript += LetoAdd("LvlStatList/[_]/KnownList1/Spell", IntToString(array_get_int(oPC, "SpellLvl1", i)), "word");
        }
        //spells per day
        sScript += LetoAdd("ClassList/[_]/SpellsPerDayList/NumSpellsLeft", IntToString(nSpellsPerDay0), "word");
        sScript += LetoAdd("ClassList/[_]/SpellsPerDayList/NumSpellsLeft", IntToString(nSpellsPerDay1), "word");
    }

    //Appearance stuff
    sScript += LetoSet("Appearance_Type", IntToString(nAppearance), "word");
    if(nVoiceset != -1) //keep existing portrait
        sScript += LetoSet("SoundSetFile", IntToString(nVoiceset), "word");
    sScript += SetSkinColor(nSkin);
    sScript += SetHairColor(nHair);
    sScript += LetoSet("Appearance_Head", IntToString(nHead), "byte");
//NPCS have and ID, PCs have a resref. resref overrides portrait.
//    sScript += "<gff:set 'PortraitId'   "+IntToString(nPortrait)+">";
    if(nPortrait != -1) //keep existing portrait
        sScript += SetPCPortrait(Get2DACache("portraits","BaseResRef",nPortrait));

    //Special abilities
    //since bioware screws this up in 1.64 its not needed
    //the PRC does this via feats instead
/*    sScript += "<gff:add 'SpecAbilityList' {type='list'}>";
    for(i=0;i<array_get_size(oPC, "SpecAbilID"); i++)
    {
//        sScript += AddSpecialAbility(array_get_int(oPC, "SpecAbilID",i), 1, array_get_int(oPC, "SpecAbilLvl",i));
        sScript +="<gff:add 'SpecAbilityList/Spell' {type='word' value="+IntToString(array_get_int(oPC, "SpecAbilID",i))+"}>";
        sScript +="<gff:add 'SpecAbilityList/[_]/SpellCasterLevel' {type='byte' value="+IntToString(array_get_int(oPC, "SpecAbilLvl",i))+"}>";
        sScript +="<gff:add 'SpecAbilityList/[_]/SpellFlags' {type='char' value="+IntToString(array_get_int(oPC, "SpecAbilFlag",i))+"}>";
    } */

    //Racial hit dice
    for(i=1;i<=nLevel;i++)
    {
        //class
        sScript += LetoSet("LvlStatList/LvlStatClass", Get2DACache("ECL", "RaceClass", nRace), "byte");
        //ability
        if(i == 3 || i == 7 || i == 11 || i == 15
                || i == 19 || i == 23 || i == 27 || i == 31
                || i == 13 || i == 39)
        {
            sScript += AdjustAbility(GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(i)+"Ability"),i);
        }
        //skills
        sScript += LetoSet("LvlStatList/["+IntToString(i-1)+"]/SkillList", "", "list");
        int j;
        for (j=0;j<SKILLS_2DA_END;j++)
        {
            int nMod = array_get_int(oPC, "RaceLevel"+IntToString(nLevel)+"Skills", j); 
            if(nMod)
                sScript += AdjustSkill(j, nMod, i);
        }
        sScript += AdjustSpareSkill(array_get_int(oPC, "RaceLevel"+IntToString(i)+"Skills", -1), i);
        //feat
        if(i == 3 || i == 5 || i == 8 || i == 11
                || i == 14 || i == 17 || i == 20 || i == 23
                || i == 26 || i == 29 || i == 32 || i == 35
                || i == 38 )
        {
            int nFeatID = GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(i)+"Feat");
            //alertness correction
            if(nFeatID == -1)
                nFeatID = 0;
            sScript += LetoSet("LvlStatList/["+IntToString(i-1)+"]/FeatList", "", "list");
            sScript += LetoAdd("FeatList/Feat", IntToString(nFeatID), "word");
            sScript += LetoAdd("LvlStatList/["+IntToString(i-1)+"]/FeatList/Feat", IntToString(nFeatID), "word");
        }
        //epic level
        if(nLevel <21)
            sScript += LetoSet("LvlStatList/["+IntToString(i-1)+"]/EpicLevel", "0", "byte");
        else            
            sScript += LetoSet("LvlStatList/["+IntToString(i-1)+"]/EpicLevel", "1", "byte");
        //hitdice
        int nRacialHitPoints = StringToInt(Get2DACache("classes", "HitDie", StringToInt(Get2DACache("ECL", "RacialClass", nRace))));
        //first 3 racial levels get max HP
        if(i > 3)
            nRacialHitPoints = 1+Random(nRacialHitPoints);
        sScript += LetoSet("LvlStatList/["+IntToString(i-1)+"]/LvlStatHitDie", IntToString(nHitPoints), "byte");
    }
    //racial xp
    if(nLevel > 0)
    {
        int nXP = nLevel*(nLevel-1)*500;
        SetXP(oPC, nXP);
        SetLocalInt(oPC, "sXP_AT_LAST_HEARTBEAT", nXP);//simple XPmod bypassing
    }

    //change the tag to mark the player as done
    sScript += LetoSet("Tag", Encrypt(oPC), "string");

    WriteTimestampedLogEntry(sScript);
    SetLocalString(oPC, "LetoScript", sScript);
    SetCutsceneMode(oPC, FALSE);
    DoCleanup();
    //do anti-hacker stuff
    SetPlotFlag(oPC, FALSE);
    SetImmortal(oPC, FALSE);
    AssignCommand(oPC, SetIsDestroyable(TRUE));
    AssignCommand(oPC, ActionRest());
    DelayCommand(0.0, FloatingTextStringOnCreature("5 seconds", oPC, FALSE));
    DelayCommand(1.0, FloatingTextStringOnCreature("4 seconds", oPC, FALSE));
    DelayCommand(2.0, FloatingTextStringOnCreature("3 seconds", oPC, FALSE));
    DelayCommand(3.0, FloatingTextStringOnCreature("2 seconds", oPC, FALSE));
    DelayCommand(4.0, FloatingTextStringOnCreature("1 seconds", oPC, FALSE));
    DelayCommand(5.0, FloatingTextStringOnCreature("Bootage!", oPC, FALSE));
    DelayCommand(5.0, CheckAndBoot(oPC));
    object oClone = GetLocalObject(oPC, "Clone");
    AssignCommand(oClone, SetIsDestroyable(TRUE));
    DestroyObject(oClone);
}
