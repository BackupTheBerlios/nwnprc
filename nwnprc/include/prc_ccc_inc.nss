#include "inc_utility"
#include "inc_fileends"



//define constants
//stage of development
const int STAGE_GENDER              =  0;
const int STAGE_GENDER_CHECK        =  1;
const int STAGE_RACE                =  2;
const int STAGE_RACE_CHECK          =  3;
const int STAGE_CLASS               =  4;
const int STAGE_CLASS_CHECK         =  5;
const int STAGE_ALIGNMENT           =  6;
const int STAGE_ALIGNMENT_CHECK     =  7;
const int STAGE_ABILITY             =  8;
const int STAGE_ABILITY_CHECK       =  9;
const int STAGE_SKILL               = 10;
const int STAGE_SKILL_CHECK         = 11;
const int STAGE_FEAT                = 12;
const int STAGE_FEAT_CHECK          = 13;
const int STAGE_BONUS_FEAT          = 14;
const int STAGE_BONUS_FEAT_CHECK    = 15;
const int STAGE_WIZ_SCHOOL          = 16;
const int STAGE_WIZ_SCHOOL_CHECK    = 17;
const int STAGE_SPELLS              = 18;
const int STAGE_SPELLS_CHECK        = 19;
const int STAGE_FAMILIAR            = 20;
const int STAGE_FAMILIAR_CHECK      = 21;
const int STAGE_ANIMALCOMP          = 22;
const int STAGE_ANIMALCOMP_CHECK    = 23;
const int STAGE_DOMAIN1             = 24;
const int STAGE_DOMAIN2             = 25;
const int STAGE_DOMAIN_CHECK        = 26;
const int STAGE_APPEARANCE          = 27;
const int STAGE_APPEARANCE_CHECK    = 28;
const int STAGE_SKIN                = 29;
const int STAGE_SKIN_CHECK          = 30;
const int STAGE_HAIR                = 31;
const int STAGE_HAIR_CHECK          = 32;
const int STAGE_WINGS               = 33;
const int STAGE_WINGS_CHECK         = 34;
const int STAGE_TAIL                = 35;
const int STAGE_TAIL_CHECK          = 36;
const int STAGE_SOUNDSET            = 37;
const int STAGE_SOUNDSET_CHECK      = 38;
const int STAGE_PORTRAIT            = 39;
const int STAGE_PORTRAIT_CHECK      = 40;
const int STAGE_HEAD                = 41;
const int STAGE_HEAD_CHECK          = 42;
const int STAGE_TATTOOCOLOUR1       = 43;
const int STAGE_TATTOOCOLOUR1_CHECK = 44;
const int STAGE_TATTOOCOLOUR2       = 45;
const int STAGE_TATTOOCOLOUR2_CHECK = 46;
const int STAGE_TATTOOPART          = 47;
const int STAGE_TATTOOPART_CHECK    = 48;
const int STAGE_RACIAL_ABILITY      = 49;
const int STAGE_RACIAL_ABILITY_CHECK= 50;
const int STAGE_RACIAL_SKILL        = 51;
const int STAGE_RACIAL_SKILL_CHECK  = 52;
const int STAGE_RACIAL_FEAT         = 53;
const int STAGE_RACIAL_FEAT_CHECK   = 54;
const int FINAL_STAGE               = 55;

void SetToken(int nTokenID, string sString);
int GetCost(int nAbilityScore);

#include "prc_ccc_inc_a"
#include "prc_ccc_inc_b"
#include "prc_ccc_inc_c"
#include "prc_ccc_inc_d"
#include "prc_ccc_inc_e"
#include "prc_ccc_inc_f"

//this returns the cost to get to a score
//or the cost saved by dropping from that score
int GetCost(int nAbilityScore)
{
    if(nAbilityScore >18)
        return -1;
    int nCost = (nAbilityScore-11)/2;
    if(nCost < 1)
        nCost = 1;
    return nCost;
}



//sets tokens for conversation
// 99 is main line
//100-109 is choices
//also sets locals equal to each token
//locals follow "TOKEN_#" pattern
void SetupTokens();


void SetupTokens()
{
    int nStage  = GetLocalInt(OBJECT_SELF, "Stage");
    int nOffset = GetLocalInt(OBJECT_SELF, "ChoiceOffset");
    int nClass  = GetLocalInt(OBJECT_SELF, "Class");
    int nRace  = GetLocalInt(OBJECT_SELF, "Race");
    int nLevel  = GetLocalInt(OBJECT_SELF, "Level");
    string sText;
    int i;

    //choices
    for (i=0;i<10;i++)
    {
        SetToken(100+i, array_get_string(OBJECT_SELF, "ChoiceTokens", nOffset+i));
    }

    //header
    switch(nStage)
    {
        case STAGE_GENDER:
            SetToken(99, "Select Gender");
            break;
        case STAGE_GENDER_CHECK:
            sText = "You have selected:\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("gender", "NAME", GetLocalInt(OBJECT_SELF, "Gender"))));
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_RACE:
            SetToken(99, "Select Race ");
            break;
        case STAGE_RACE_CHECK:
            sText = "You have selected:\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", GetLocalInt(OBJECT_SELF, "Race"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Description", GetLocalInt(OBJECT_SELF, "Race"))));
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_CLASS:
            SetToken(99, "Select Class");
            break;
        case STAGE_CLASS_CHECK:
            sText = "You have selected:\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", GetLocalInt(OBJECT_SELF, "Class"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("classes", "Description", GetLocalInt(OBJECT_SELF, "Class"))));
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_ALIGNMENT:
            SetToken(99, "Select Alignment");
            break;
        case STAGE_ALIGNMENT_CHECK:
            sText = "You have selected:\n";
            if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==85
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==85)
                    sText+= "Lawful Good";
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==50
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==85)
                    sText+= "Neutral Good";
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==15
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==85)
                    sText+= "Chaotic Good";
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==85
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==50)
                    sText+= "Lawful Neutral";
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==50
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==50)
                    sText+= "True Neutral";
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==15
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==50)
                    sText+= "Chaotic Neutral";
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==85
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==15)
                    sText+= "Lawful Evil";
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==50
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==15)
                    sText+= "Neutral Evil";
            else if(GetLocalInt(OBJECT_SELF, "LawfulChaotic")==15
                && GetLocalInt(OBJECT_SELF, "GoodEvil")==15)
                    sText+= "Chaotic Evil";
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_ABILITY:
            SetToken(99, "Select Ability " + IntToString(GetLocalInt(OBJECT_SELF, "Points"))+" points remaining");
            break;
        case STAGE_ABILITY_CHECK:
            sText = "You have selected:\n";
            sText+= IntToString(GetLocalInt(OBJECT_SELF, "Str"))+" ("+Get2DACache("racialtypes", "StrAdjust", nRace)+") Strength\n";
            sText+= IntToString(GetLocalInt(OBJECT_SELF, "Dex"))+" ("+Get2DACache("racialtypes", "DexAdjust", nRace)+") Dexterity\n";
            sText+= IntToString(GetLocalInt(OBJECT_SELF, "Con"))+" ("+Get2DACache("racialtypes", "ConAdjust", nRace)+") Constitution\n";
            sText+= IntToString(GetLocalInt(OBJECT_SELF, "Int"))+" ("+Get2DACache("racialtypes", "IntAdjust", nRace)+") Intelligence\n";
            sText+= IntToString(GetLocalInt(OBJECT_SELF, "Wis"))+" ("+Get2DACache("racialtypes", "WisAdjust", nRace)+") Wisdom\n";
            sText+= IntToString(GetLocalInt(OBJECT_SELF, "Cha"))+" ("+Get2DACache("racialtypes", "ChaAdjust", nRace)+") Charisma\n";
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_SKILL:
            SetToken(99, "Select Skills " + IntToString(GetLocalInt(OBJECT_SELF, "Points"))+" points remaining");
            break;
        case STAGE_SKILL_CHECK:
            sText = "You have selected:\n";
            if(GetLocalInt(GetModule(), "ALLOW_SKILL_POINT_ROLLOVER"))
            {
                    sText+= "Stored skill points:";
                    sText+= " "+IntToString(array_get_int(OBJECT_SELF, "Skills",-1))+"\n";
            }
            for(i=0;i<SKILLS_2DA_END;i++)
            {
                if(Get2DACache("skills", "Name", i) != "" && array_get_int(OBJECT_SELF, "Skills",i) != 0)
                {
                    sText+= GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", i)));
                    sText+= " "+IntToString(array_get_int(OBJECT_SELF, "Skills",i))+"\n";
                }
            }
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_FEAT:
            SetToken(99, "Select Feat");
            break;
        case STAGE_FEAT_CHECK:
            sText = "You have selected:\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", GetLocalInt(OBJECT_SELF, "StartingFeat"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("feat", "Description", GetLocalInt(OBJECT_SELF, "StartingFeat"))));
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_BONUS_FEAT:
            SetToken(99, "Select Bonus Feat");
            break;
        case STAGE_BONUS_FEAT_CHECK:
            sText = "You have selected:\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", GetLocalInt(OBJECT_SELF, "BonusFeat"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("feat", "Description", GetLocalInt(OBJECT_SELF, "BonusFeat"))));
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_WIZ_SCHOOL:
            SetToken(99, "Select Spell School");
            break;
        case STAGE_WIZ_SCHOOL_CHECK:
            sText = "You have selected:\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", GetLocalInt(OBJECT_SELF, "School"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("spellschools", "Description", GetLocalInt(OBJECT_SELF, "School"))));
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_FAMILIAR:
            SetToken(99, "Select Familiar");
            break;
        case STAGE_FAMILIAR_CHECK:
            sText = "You have selected:\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("hen_familiar", "STRREF", GetLocalInt(OBJECT_SELF, "Familiar"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("hen_familiar", "DESCRIPTION", GetLocalInt(OBJECT_SELF, "Familiar"))));
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_ANIMALCOMP:
            SetToken(99, "Select Animal Companion");
            break;
        case STAGE_ANIMALCOMP_CHECK:
            sText = "You have selected:\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("hen_companion", "STRREF", GetLocalInt(OBJECT_SELF, "AnimalCompanion"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("hen_companion", "DESCRIPTION", GetLocalInt(OBJECT_SELF, "AnimalCompanion"))));
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_DOMAIN1:
            SetToken(99, "Select first Domain");
            break;
        case STAGE_DOMAIN2:
            SetToken(99, "Select second Domain");
            break;
        case STAGE_DOMAIN_CHECK:
            sText = "You have selected:\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("domains", "Name", GetLocalInt(OBJECT_SELF, "Domain1"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("domains", "Description", GetLocalInt(OBJECT_SELF, "Domain1"))));
            sText+= "\nAnd: ";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("domains", "Name", GetLocalInt(OBJECT_SELF, "Domain2"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("domains", "Description", GetLocalInt(OBJECT_SELF, "Domain2"))));
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_SPELLS:
            switch(nClass)
            {
                case CLASS_TYPE_WIZARD:
                case CLASS_TYPE_SORCERER:
                case CLASS_TYPE_BARD:
                    SetToken(99, "Select spells ("+IntToString(GetLocalInt(OBJECT_SELF, "NumberOfSpells"))+" remaining)");
                    break;
                default:
                    SetToken(99, "You are unable to select spells");
                    break;
            }
            break;
        case STAGE_SPELLS_CHECK:
            sText = "You have selected: ";
            for(i=0;i<array_get_size(OBJECT_SELF, "SpellLvl0");i++)
                sText+= "\n"+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", array_get_int(OBJECT_SELF, "SpellLvl0", i))));
            for(i=0;i<array_get_size(OBJECT_SELF, "SpellLvl1");i++)
                sText+= "\n"+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", array_get_int(OBJECT_SELF, "SpellLvl1", i))));
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_APPEARANCE:
            SetToken(99, "Select an appearance.");
            break;
        case STAGE_APPEARANCE_CHECK:
            SetToken(99, "Is this appearance correct?");
            break;
        case STAGE_HAIR:
            SetToken(99, "Select hair colour.");
            break;
        case STAGE_HAIR_CHECK:
            SetToken(99, "Is this hair colour correct?");
            break;
        case STAGE_HEAD:
            SetToken(99, "Select head number.");
            break;
        case STAGE_HEAD_CHECK:
            SetToken(99, "Is this head correct?");
            break;
        case STAGE_PORTRAIT:
            SetToken(99, "Select a portrait.");
            break;
        case STAGE_PORTRAIT_CHECK:
            SetToken(99, "Is this portrait correct?");
            break;
        case STAGE_SKIN:
            SetToken(99, "Select skintone.");
            break;
        case STAGE_SKIN_CHECK:
            SetToken(99, "Is this skintone correct?");
            break;
        case STAGE_SOUNDSET:
            SetToken(99, "Select a soundset.");
            break;
        case STAGE_SOUNDSET_CHECK:
            SetToken(99, "Is this soundset correct?");
            break;
        case STAGE_TAIL:
            SetToken(99, "Select tail.");
            break;
        case STAGE_TAIL_CHECK:
            SetToken(99, "Is this tail correct?");
            break;
        case STAGE_WINGS:
            SetToken(99, "Select wings.");
            break;
        case STAGE_WINGS_CHECK:
            SetToken(99, "Is this set of wings correct?");
            break;
        case STAGE_TATTOOPART:
            SetToken(99, "Select a bondypart to alter the tattoo of.");
            break;
        case STAGE_TATTOOPART_CHECK:
            SetToken(99, "Is this tattoo placement correct?");
            break;
        case STAGE_TATTOOCOLOUR1:
            SetToken(99, "Select a colour for the first part of your tattoos");
            break;
        case STAGE_TATTOOCOLOUR1_CHECK:
            SetToken(99, "Is this tattoo colour correct?");
            break;
        case STAGE_TATTOOCOLOUR2:
            SetToken(99, "Select a colour for the second part of your tattoos");
            break;
        case STAGE_TATTOOCOLOUR2_CHECK:
            SetToken(99, "Is this tattoo colour correct?");
            break;
        case FINAL_STAGE:
//            SetToken(99, "Your character is ready to be generated. You will now be passed to the appearance selection system.");
            SetToken(99, "Your character will now be generated. As part of this process, you will be booted. Please exit NWN completely before rejoining.");
            break;
        case STAGE_RACIAL_ABILITY:
            SetToken(99, "Select an ability to increase.");
            break;
        case STAGE_RACIAL_ABILITY_CHECK:
            sText = "You have selected:\n";
            switch(GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(nLevel)+"Feat"))
            {
                case ABILITY_STRENGTH:
                    sText += "Strength";
                    break;
                case ABILITY_DEXTERITY:
                    sText += "Dexterity";
                    break;
                case ABILITY_CONSTITUTION:
                    sText += "Constitution";
                    break;
                case ABILITY_INTELLIGENCE:
                    sText += "Intelligence";
                    break;
                case ABILITY_WISDOM:
                    sText += "Wisdom";
                    break;
                case ABILITY_CHARISMA:
                    sText += "Charisma";
                    break;
            }
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_RACIAL_SKILL:
            SetToken(99, "Select Skills " + IntToString(GetLocalInt(OBJECT_SELF, "Points"))+" points remaining");
            break;
        case STAGE_RACIAL_SKILL_CHECK:
            sText = "You have selected:\n";
            for(i=0;i<SKILLS_2DA_END;i++)
            {
                if(Get2DACache("skills", "Name", i) != "" && array_get_int(OBJECT_SELF, "RaceLevel"+IntToString(nLevel)+"Skills",i) != 0)
                {
                    sText+= GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", i)));
                    sText+= " "+IntToString(array_get_int(OBJECT_SELF, "RaceLevel"+IntToString(nLevel)+"Skills",i))+"\n";
                }
            }
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        case STAGE_RACIAL_FEAT:
            SetToken(99, "Select Feat");
            break;
        case STAGE_RACIAL_FEAT_CHECK:
            sText = "You have selected:\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(nLevel)+"Feat"))));
            sText+= "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("feat", "Description", GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(nLevel)+"Feat"))));
            sText+= "\nIs this correct?";
            SetToken(99, sText);
            break;
        default:
            SetToken(99, "Error");
            break;
    }
}

void DoCleanup()
{
    object oPC = OBJECT_SELF;
    //clean up in all aisles :-)
    DeleteLocalInt(oPC, "Str");
    DeleteLocalInt(oPC, "Dex");
    DeleteLocalInt(oPC, "Con");
    DeleteLocalInt(oPC, "Int");
    DeleteLocalInt(oPC, "Wis");
    DeleteLocalInt(oPC, "Cha");
    DeleteLocalInt(oPC, "Race");
    DeleteLocalInt(oPC, "Class");
    DeleteLocalInt(oPC, "QTMFeat");
    DeleteLocalInt(oPC, "StartingFeat");
    DeleteLocalInt(oPC, "BonusFeat");
    DeleteLocalInt(oPC, "HitPoints");
    DeleteLocalInt(oPC, "Gender");
    DeleteLocalInt(oPC, "LawfulChaotic");
    DeleteLocalInt(oPC, "GoodEvil");
    DeleteLocalInt(oPC, "Portrait");
    DeleteLocalString(oPC, "PortraitResRef");
    DeleteLocalInt(oPC, "Appearance");
    DeleteLocalInt(oPC, "Voiceset");
    DeleteLocalInt(oPC, "Skin");
    DeleteLocalInt(oPC, "Hair");
    DeleteLocalInt(oPC, "Wings");
    DeleteLocalInt(oPC, "Tail");
    DeleteLocalInt(oPC, "Head");
    DeleteLocalInt(oPC, "SoundSet");
    DeleteLocalInt(oPC, "Familiar");
    DeleteLocalInt(oPC, "AnimalCompanion");
    DeleteLocalInt(oPC, "Domain1");
    DeleteLocalInt(oPC, "Domain2");
    DeleteLocalInt(oPC, "Points");
    DeleteLocalInt(oPC, "Stage");
    DeleteLocalInt(oPC, "School");
    DeleteLocalInt(oPC, "CurrentSpellLevel");
    DeleteLocalInt(oPC, "i");
    DeleteLocalInt(oPC, "Level");
    DeleteLocalString(oPC, "TOKEN100");
    DeleteLocalString(oPC, "TOKEN101");
    DeleteLocalString(oPC, "TOKEN102");
    DeleteLocalString(oPC, "TOKEN103");
    DeleteLocalString(oPC, "TOKEN104");
    DeleteLocalString(oPC, "TOKEN105");
    DeleteLocalString(oPC, "TOKEN106");
    DeleteLocalString(oPC, "TOKEN107");
    DeleteLocalString(oPC, "TOKEN108");
    DeleteLocalString(oPC, "TOKEN109");
    DeleteLocalString(oPC, "TOKEN110");
    DeleteLocalString(oPC, "TOKEN50");
    array_delete(oPC, "Feats");
    array_delete(oPC, "SpecAbilID");
    array_delete(oPC, "SpecAbilFlag");
    array_delete(oPC, "SpecAbilLvl");
    array_delete(oPC, "Skills");
    array_delete(oPC, "StagesSetup");
    array_delete(oPC, "ChoiceTokens");
    array_delete(oPC, "ChoiceValue");
    array_delete(oPC, "SpellLvl1");
    array_delete(oPC, "SpellLvl0");
}

/*
Gender
Race
Class
Alignment
Ability
Skills
Feats
Domains
Familiars
Specialist School
Bonus Feat

[done at random]
Portrait
Name
Head
Voiceset
Skincolor(s)


Spells
    Cleric
    Druid
    Ranger
    Paladin
            ClassList/[_]/MemorizedListX/Spell
            ClassList/[_]/MemorizedListX/Ready
            ClassList/[_]/MemorizedListX/SpellMetaMagic
    Sorcerer
    Bard
            ClassList/[_]/MemorizedListX/Spell
            ClassList/[_]/SpellsPerDayList/[_]/NumSpellsLeft
            LvlStatList/[_]/KnownListX/[_]/Spell
            LvlStatList/[_]/KnownRemoveListX/[_]/Spell
    Wizard
            ClassList/[_]/MemorizedListX/Spell
            ClassList/[_]/MemorizedListX/Ready
            ClassList/[_]/MemorizedListX/SpellMetaMagic
            ClassList/[_]/KnownListX/Spell
            LvlStatList/[_]/KnownListX/[_]/Spell

*/
