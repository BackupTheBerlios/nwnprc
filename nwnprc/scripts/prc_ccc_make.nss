#include "inc_utility"
#include "inc_letocommands"
#include "inc_fileends"
#include "prc_inc_racial"
#include "prc_ccc_inc"
#include "inc_encrypt"

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
    sScript += "<gff:delete 'FeatList' >";
    sScript += "<gff:delete 'ClassList' >";
    sScript += "<gff:delete 'LvlStatList' >";
    sScript += "<gff:delete 'SkillList' >";
//    sScript += "<gff:delete 'SkillPoints' >";
    sScript += "<gff:add 'FeatList' {type='list'}>";
    sScript += "<gff:add 'ClassList' {type='list'}>";
    sScript += "<gff:add 'LvlStatList' {type='list'}>";
    sScript += "<gff:add 'SkillList' {type='list'}>";

    //Sex
    sScript += "<gff:set 'Gender' "+IntToString(nSex)+">";

    //Race
    sScript += "<gff:set 'Race' "+IntToString(nRace)+">";

    //Class
    sScript += "<gff:add 'ClassList/Class' {type='int' value="+IntToString(nClass)+"}>";
    sScript += "<gff:add 'ClassList/[0]/ClassLevel' {type='short' value="+IntToString(nLevel+1)+"}>";
    sScript += "<gff:add 'LvlStatList/LvlStatClass' {type='byte' value="+IntToString(nClass)+"}>";
    sScript += "<gff:add 'LvlStatList/[0]/EpicLevel' {type='byte' value=0}>";
    sScript += "<gff:add 'LvlStatList/[0]/LvlStatHitDie' {type='byte' value="+IntToString(nHitPoints)+"}>";

    //Alignment
    sScript += "<gff:set 'LawfulChaotic' "+IntToString(nOrder)+">";
    sScript += "<gff:set 'GoodEvil' "+IntToString(nMoral)+">";

    //Familiar
    //has a random name
    if(nClass == CLASS_TYPE_WIZARD
        || nClass == CLASS_TYPE_SORCERER)
    {
        sScript += "<gff:add 'FamiliarType' {type='int' value="+IntToString(nFamiliar)+" setifexists=True}>";
        sScript += "<gff:add 'FamiliarName' "+RandomName()+">";
    }

    //Animal Companion
    //has a random name
    if(nClass == CLASS_TYPE_DRUID)
    {
        sScript += "<gff:add 'CompanionType' {type='int' value="+IntToString(nAnimalCompanion)+" setifexists=True}>";
        sScript += "<gff:add 'CompanionName' "+RandomName()+">";
    }

    //Domains
    if(nClass == CLASS_TYPE_CLERIC)
    {
        sScript += "<gff:add 'ClassList/[0]/Domain1' {type='byte' value="+IntToString(nDomain1)+"}>";
        sScript += "<gff:add 'ClassList/[0]/Domain2' {type='byte' value="+IntToString(nDomain2)+"}>";
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
    sScript += "<gff:add 'LvlStatList/[0]/FeatList' {type='list'}>";
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
            sScript += "<gff:add 'FeatList/Feat' {type='word' value="+IntToString(nFeatID)+"}>";
            sScript += "<gff:add 'LvlStatList/[0]/FeatList/Feat' {type='word' value="+IntToString(nFeatID)+"}>";
        }
    }

    //Skills
    sScript += "<gff:add 'LvlStatList/[0]/SkillList' {type='list'}>";
    for (i=0;i<SKILLS_2DA_END;i++)
    {
        sScript += "<gff:add 'SkillList/Rank' {type='byte' value="+IntToString(array_get_int(oPC, "Skills", i))+ "}>";
        sScript += "<gff:add 'LvlStatList/[0]/SkillList/Rank' {type='char' value="+IntToString(array_get_int(oPC, "Skills", i))+"}>";
    }
    sScript += "<gff:set 'SkillPoints' {value="+IntToString(array_get_int(oPC, "Skills", -1))+ "}>";
    sScript += "<gff:add 'LvlStatList/[0]/SkillPoints' {type='word' value="+IntToString(array_get_int(oPC, "Skills", -1))+"}>";

    //Spells
    if(nClass == CLASS_TYPE_WIZARD)
    {
        sScript += "<gff:add 'ClassList/[0]/KnownList0' {type='list'}>";
        sScript += "<gff:add 'ClassList/[0]/KnownList1' {type='list'}>";
        sScript += "<gff:add 'LvlStatList/[0]/KnownList0' {type='list'}>";
        sScript += "<gff:add 'LvlStatList/[0]/KnownList1' {type='list'}>";
        for (i=0;i<array_get_size(oPC, "SpellLvl0");i++)
        {
            sScript += "<gff:add 'ClassList/[0]/KnownList0/Spell' {type='word' value="+IntToString(array_get_int(oPC, "SpellLvl0", i))+"}>";
            sScript += "<gff:add 'LvlStatList/[0]/KnownList0/Spell' {type='word' value="+IntToString(array_get_int(oPC, "SpellLvl0", i))+"}>";
        }
        for (i=0;i<array_get_size(oPC, "SpellLvl1");i++)
        {
            sScript += "<gff:add 'ClassList/[0]/KnownList1/Spell' {type='word' value="+IntToString(array_get_int(oPC, "SpellLvl1", i))+"}>";
            sScript += "<gff:add 'LvlStatList/[0]/KnownList1/Spell' {type='word' value="+IntToString(array_get_int(oPC, "SpellLvl1", i))+"}>";
        }
        //throw spellschoool in here too
        sScript += "<gff:add 'ClassList/[0]/School' {type='byte' value="+IntToString(nSchool)+" setifexists=True}>";
    }
    else if (nClass == CLASS_TYPE_BARD)
    {
        sScript += "<gff:add 'ClassList/[0]/KnownList0' {type='list'}>";
        sScript += "<gff:add 'ClassList/[0]/SpellsPerDayList' {type='list'}>";
        sScript += "<gff:add 'LvlStatList/[0]/KnownList0' {type='list'}>";
        for (i=0;i<array_get_size(oPC, "SpellLvl0");i++)
        {
            sScript += "<gff:add 'ClassList/[0]/KnownList0/Spell' {type='word' value="+IntToString(array_get_int(oPC, "SpellLvl0", i))+"}>";
            sScript += "<gff:add 'LvlStatList/[0]/KnownList0/Spell' {type='word' value="+IntToString(array_get_int(oPC, "SpellLvl0", i))+"}>";
        }
        //spells per day
        sScript += "<gff:add 'ClassList/[0]/SpellsPerDayList/NumSpellsLeft' {type='word' value="+IntToString(nSpellsPerDay0)+"}>";
    }
    else if (nClass == CLASS_TYPE_SORCERER)
    {
        sScript += "<gff:add 'ClassList/[0]/KnownList0' {type='list'}>";
        sScript += "<gff:add 'ClassList/[0]/KnownList1' {type='list'}>";
        sScript += "<gff:add 'LvlStatList/[0]/KnownList0' {type='list'}>";
        sScript += "<gff:add 'LvlStatList/[0]/KnownList1' {type='list'}>";
        sScript += "<gff:add 'ClassList/[0]/SpellsPerDayList' {type='list'}>";
        for (i=0;i<array_get_size(oPC, "SpellLvl0");i++)
        {
            sScript += "<gff:add 'ClassList/[0]/KnownList0/Spell' {type='word' value="+IntToString(array_get_int(oPC, "SpellLvl0", i))+"}>";
            sScript += "<gff:add 'LvlStatList/[0]/KnownList0/Spell' {type='word' value="+IntToString(array_get_int(oPC, "SpellLvl0", i))+"}>";
        }
        for (i=0;i<array_get_size(oPC, "SpellLvl1");i++)
        {
            sScript += "<gff:add 'ClassList/[0]/KnownList1/Spell' {type='word' value="+IntToString(array_get_int(oPC, "SpellLvl1", i))+"}>";
            sScript += "<gff:add 'LvlStatList/[0]/KnownList1/Spell' {type='word' value="+IntToString(array_get_int(oPC, "SpellLvl1", i))+"}>";
        }
        //spells per day
        sScript += "<gff:add 'ClassList/[0]/SpellsPerDayList/NumSpellsLeft' {type='word' value="+IntToString(nSpellsPerDay0)+"}>";
        sScript += "<gff:add 'ClassList/[0]/SpellsPerDayList/NumSpellsLeft' {type='word' value="+IntToString(nSpellsPerDay1)+"}>";
    }

    //Appearance stuff
    sScript += "<gff:set 'Appearance_Type' "+IntToString(nAppearance)+">";
    if(nVoiceset != -1) //keep existing portrait
        sScript += "<gff:set 'SoundSetFile'   "+IntToString(nVoiceset)+">";
    sScript += "<gff:set 'Color_Skin' "+IntToString(nSkin)+">";
    sScript += "<gff:set 'Color_Hair' "+IntToString(nHair)+">";
    sScript += "<gff:set 'Appearance_Head' "+IntToString(nHead)+">";
//NPCS have and ID, PCs have a resref. resref overrides portrait.
//    sScript += "<gff:set 'PortraitId'   "+IntToString(nPortrait)+">";
    if(nPortrait != -1) //keep existing portrait
        sScript += "<gff:set 'Portrait' 'po_"+Get2DACache("portraits","BaseResRef",nPortrait)+"'>";

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
        sScript += "<gff:add 'LvlStatList/LvlStatClass' {type='byte' value="+Get2DACache("ECL", "RaceClass", nRace)+"}>";
        //ability
        if(i == 3 || i == 7 || i == 11 || i == 15
                || i == 19 || i == 23 || i == 27 || i == 31
                || i == 13 || i == 39)
        {
            sScript += AdjustAbility(GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(i)+"Ability"),i);
        }
        //skills
        sScript += "<gff:add 'LvlStatList/["+IntToString(i-1)+"]/SkillList' {type='list'}>";
        int j;
        for (j=0;j<SKILLS_2DA_END;j++)
        {
            sScript += AdjustSkill(j, array_get_int(oPC, "RaceLevel"+IntToString(nLevel)+"Skills", j), i);
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
            sScript += "<gff:add 'LvlStatList/["+IntToString(i-1)+"]/FeatList' {type='list'}>";
            sScript += "<gff:add 'FeatList/Feat' {type='word' value="+IntToString(nFeatID)+"}>";
            sScript += "<gff:add 'LvlStatList/["+IntToString(i-1)+"]/FeatList/Feat' {type='word' value="+IntToString(nFeatID)+"}>";
        }
        //epic level
        if(nLevel <21)
            sScript += "<gff:add 'LvlStatList/["+IntToString(i-1)+"]/EpicLevel' {type='byte' value=0}>";
        else            
            sScript += "<gff:add 'LvlStatList/["+IntToString(i-1)+"]/EpicLevel' {type='byte' value=1}>";
        //hitdice
        int nRacialHitPoints = StringToInt(Get2DACache("classes", "HitDie", StringToInt(Get2DACache("ECL", "RacialClass", nRace))));
        //first 3 racial levels get max HP
        if(i > 3)
            nRacialHitPoints = 1+Random(nRacialHitPoints);
        sScript += "<gff:add 'LvlStatList/["+IntToString(i-1)+"]/LvlStatHitDie' {type='byte' value="+IntToString(nHitPoints)+"}>";
    }
    //racial xp
    if(nLevel > 0)
    {
        int nXP = nLevel*(nLevel-1)*500;
        SetXP(oPC, nXP);
    }

    //change the tag to mark the player as done
    sScript += "<gff:set 'Tag' <qq:"+Encrypt(GetName(oPC))+">>";

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
    DelayCommand(5.0, BootPC(oPC));
    object oClone = GetLocalObject(oPC, "Clone");
    AssignCommand(oClone, SetIsDestroyable(TRUE));
    DestroyObject(oClone);
}
