/*

    This file is used for lookup functions for psionics and newspellbooks
    It is supposed to reduce the need for large loops that may result in
    TMI errors.
    It does this by creating arrays in advance and the using those as direct
    lookups.
*/

//nClass is the class to do this for
//nMin is the row to start at
//sSourceColumn is the column you want to lookup by
//sDestComumn is the column you want returned
//sVarNameBase is the root of the variables and tag of token
//nLoopSize is the number of rows per call
void MakeLookupLoop(int nClass, int nMin, int nMax, string sSourceColumn,
    string sDestColumn, string sVarNameBase, int nLoopSize = 100, string sTag = "");

void MakeSpellbookLevelLoop(int nClass, int nMin, int nMax, string sVarNameBase,
    string sColumnName, string sColumnValue, int nLoopSize = 100, string sTag = "");

//this returns the real SpellID of "wrapper" spells cast by psionic or the new spellbooks
int GetPowerFromSpellID(int nSpellID);

/**
 * Maps spells.2da rows of the class-specific entries to corresponding cls_psipw_*.2da rows.
 *
 * @param nSpellID Spells.2da row to determine cls_psipw_*.2da row for
 * @return         The mapped value
 */
int GetPowerfileIndexFromSpellID(int nSpellID);

//this retuns the featID of the class-specific feat for a spellID
//useful for psionics GetHasPower function
int GetClassFeatFromPower(int nPowerID, int nClass);

/**
 * Determines the name of the 2da file that defines the number of alternate magic
 * system powers/spells/whathaveyou known, maximum level of such known and
 * number of uses at each level of the given class. And possibly related things
 * that apply to that specific system.
 *
 * @param nClass CLASS_TYPE_* of the class to determine the powers known 2da name of
 * @return       The name of the given class's powers known 2da
 */
string GetAMSKnownFileName(int nClass);

/**
 * Determines the name of the 2da file that lists the powers/spells/whathaveyou
 * on the given class's list of such.
 *
 * @param nClass CLASS_TYPE_* of the class to determine the power list 2da name of
 * @return       The name of the given class's power list 2da
 */
string GetAMSDefinitionFileName(int nClass);

#include "inc_utility"
#include "prc_class_const"

void MakeLookupLoopMaster()
{
    //now the loops
    DelayCommand(1.0, MakeLookupLoop(CLASS_TYPE_PSION,            0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(1.2, MakeLookupLoop(CLASS_TYPE_PSION,            0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_PSION)));
    DelayCommand(1.3, MakeLookupLoop(CLASS_TYPE_PSION,            0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    DelayCommand(1.4, MakeLookupLoop(CLASS_TYPE_PSYWAR,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(1.6, MakeLookupLoop(CLASS_TYPE_PSYWAR,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_PSYWAR)));
    DelayCommand(1.7, MakeLookupLoop(CLASS_TYPE_PSYWAR,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    DelayCommand(1.8, MakeLookupLoop(CLASS_TYPE_WILDER,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.0, MakeLookupLoop(CLASS_TYPE_WILDER,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_WILDER)));
    DelayCommand(2.1, MakeLookupLoop(CLASS_TYPE_WILDER,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    DelayCommand(2.2, MakeLookupLoop(CLASS_TYPE_FIST_OF_ZUOKEN,   0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.4, MakeLookupLoop(CLASS_TYPE_FIST_OF_ZUOKEN,   0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_FIST_OF_ZUOKEN)));
    DelayCommand(2.5, MakeLookupLoop(CLASS_TYPE_FIST_OF_ZUOKEN,   0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    DelayCommand(2.6, MakeLookupLoop(CLASS_TYPE_WARMIND,          0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.8, MakeLookupLoop(CLASS_TYPE_WARMIND,          0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_WARMIND)));
    DelayCommand(2.9, MakeLookupLoop(CLASS_TYPE_WARMIND,          0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    // The Truenamer uses the same lookup loop style as the psionic classes. Time adjusted to put it after the last of the caster lookup loops
    DelayCommand(7.3, MakeLookupLoop(CLASS_TYPE_TRUENAMER,        0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(7.5, MakeLookupLoop(CLASS_TYPE_TRUENAMER,        0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_TRUENAMER)));
    DelayCommand(7.6, MakeLookupLoop(CLASS_TYPE_TRUENAMER,        0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "", "SpellIDToClsPsipw"));
    //add new psionic classes here
    //also add them later too

    //new spellbook lookups
    DelayCommand(2.6, MakeLookupLoop(CLASS_TYPE_BLACKGUARD,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.7, MakeLookupLoop(CLASS_TYPE_ANTI_PALADIN,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.8, MakeLookupLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.9, MakeLookupLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE, 0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.0, MakeLookupLoop(CLASS_TYPE_KNIGHT_CHALICE,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.1, MakeLookupLoop(CLASS_TYPE_VIGILANT,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.2, MakeLookupLoop(CLASS_TYPE_VASSAL,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.3, MakeLookupLoop(CLASS_TYPE_OCULAR,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.4, MakeLookupLoop(CLASS_TYPE_ASSASSIN,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.5, MakeLookupLoop(CLASS_TYPE_SUEL_ARCHANAMACH,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(4.0, MakeLookupLoop(CLASS_TYPE_SHADOWLORD,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(4.0, MakeLookupLoop(CLASS_TYPE_BARD,                0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(4.0, MakeLookupLoop(CLASS_TYPE_SORCERER,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(4.2, MakeLookupLoop(CLASS_TYPE_FAVOURED_SOUL,       0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(7.8, MakeLookupLoop(CLASS_TYPE_HEXBLADE,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(7.8, MakeLookupLoop(CLASS_TYPE_SOHEI,               0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(8.8, MakeLookupLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(9.4, MakeLookupLoop(CLASS_TYPE_DUSKBLADE,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(10.1, MakeLookupLoop(CLASS_TYPE_HEALER,             0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));

    DelayCommand(2.6, MakeLookupLoop(CLASS_TYPE_BLACKGUARD,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(2.7, MakeLookupLoop(CLASS_TYPE_ANTI_PALADIN,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(2.8, MakeLookupLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(2.9, MakeLookupLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE, 0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(3.0, MakeLookupLoop(CLASS_TYPE_KNIGHT_CHALICE,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(3.1, MakeLookupLoop(CLASS_TYPE_VIGILANT,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(3.2, MakeLookupLoop(CLASS_TYPE_VASSAL,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(3.3, MakeLookupLoop(CLASS_TYPE_OCULAR,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(3.4, MakeLookupLoop(CLASS_TYPE_ASSASSIN,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(3.5, MakeLookupLoop(CLASS_TYPE_SUEL_ARCHANAMACH,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(4.0, MakeLookupLoop(CLASS_TYPE_SHADOWLORD,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(4.0, MakeLookupLoop(CLASS_TYPE_BARD,                0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(4.0, MakeLookupLoop(CLASS_TYPE_SORCERER,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(4.2, MakeLookupLoop(CLASS_TYPE_FAVOURED_SOUL,       0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(7.9, MakeLookupLoop(CLASS_TYPE_HEXBLADE,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(7.9, MakeLookupLoop(CLASS_TYPE_SOHEI,               0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(8.9, MakeLookupLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(9.5, MakeLookupLoop(CLASS_TYPE_DUSKBLADE,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));
    DelayCommand(10.2, MakeLookupLoop(CLASS_TYPE_HEALER,             0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "", "GetRowFromSpellID"));

    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_BLACKGUARD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_BLACKGUARD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_BLACKGUARD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_BLACKGUARD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ANTI_PALADIN,0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ANTI_PALADIN,0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ANTI_PALADIN,0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ANTI_PALADIN,0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_CHALICE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK), "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_CHALICE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK), "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_CHALICE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK), "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_CHALICE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK), "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level","1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level","2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE,0,GetPRCSwitch(FILE_END_CLASS_SPELLBOOK),"SpellLvl","Level","3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VIGILANT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VIGILANT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VIGILANT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VIGILANT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VASSAL,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VASSAL,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VASSAL,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_VASSAL,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_OCULAR,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_OCULAR,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_OCULAR,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_OCULAR,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_OCULAR,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_OCULAR,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ASSASSIN,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ASSASSIN,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ASSASSIN,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_ASSASSIN,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SHADOWLORD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SHADOWLORD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_SHADOWLORD,  0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.1, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(4.2, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(4.3, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(4.4, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(4.5, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(4.6, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(4.7, MakeSpellbookLevelLoop(CLASS_TYPE_BARD,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "6"));
    DelayCommand(4.8, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(4.9, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(5.0, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(5.1, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(5.2, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(5.3, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(5.4, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "6"));
    DelayCommand(5.5, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "7"));
    DelayCommand(5.6, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "8"));
    DelayCommand(5.7, MakeSpellbookLevelLoop(CLASS_TYPE_SORCERER,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "9"));
    DelayCommand(5.8, MakeSpellbookLevelLoop(CLASS_TYPE_SUEL_ARCHANAMACH,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(5.9, MakeSpellbookLevelLoop(CLASS_TYPE_SUEL_ARCHANAMACH,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(6.0, MakeSpellbookLevelLoop(CLASS_TYPE_SUEL_ARCHANAMACH,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(6.1, MakeSpellbookLevelLoop(CLASS_TYPE_SUEL_ARCHANAMACH,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(6.2, MakeSpellbookLevelLoop(CLASS_TYPE_SUEL_ARCHANAMACH,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(6.3, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(6.4, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(6.5, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(6.6, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(6.7, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(6.8, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(6.9, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "6"));
    DelayCommand(7.0, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "7"));
    DelayCommand(7.1, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "8"));
    DelayCommand(7.2, MakeSpellbookLevelLoop(CLASS_TYPE_FAVOURED_SOUL,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "9"));
    DelayCommand(8.0, MakeSpellbookLevelLoop(CLASS_TYPE_HEXBLADE,         0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(8.1, MakeSpellbookLevelLoop(CLASS_TYPE_HEXBLADE,         0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(8.2, MakeSpellbookLevelLoop(CLASS_TYPE_HEXBLADE,         0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(8.3, MakeSpellbookLevelLoop(CLASS_TYPE_HEXBLADE,         0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(8.4, MakeSpellbookLevelLoop(CLASS_TYPE_SOHEI,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(8.5, MakeSpellbookLevelLoop(CLASS_TYPE_SOHEI,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(8.6, MakeSpellbookLevelLoop(CLASS_TYPE_SOHEI,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(8.7, MakeSpellbookLevelLoop(CLASS_TYPE_SOHEI,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(9.0, MakeSpellbookLevelLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,   0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(9.1, MakeSpellbookLevelLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,   0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(9.2, MakeSpellbookLevelLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,   0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(9.3, MakeSpellbookLevelLoop(CLASS_TYPE_SLAYER_OF_DOMIEL,   0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(9.6, MakeSpellbookLevelLoop(CLASS_TYPE_DUSKBLADE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(9.7, MakeSpellbookLevelLoop(CLASS_TYPE_DUSKBLADE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(9.8, MakeSpellbookLevelLoop(CLASS_TYPE_DUSKBLADE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(9.9, MakeSpellbookLevelLoop(CLASS_TYPE_DUSKBLADE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(10.0, MakeSpellbookLevelLoop(CLASS_TYPE_DUSKBLADE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(11.3, MakeSpellbookLevelLoop(CLASS_TYPE_DUSKBLADE,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(10.3, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "0"));
    DelayCommand(10.4, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(10.5, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(10.6, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(10.7, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
    DelayCommand(10.8, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "5"));
    DelayCommand(10.9, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "6"));
    DelayCommand(11.0, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "7"));
    DelayCommand(11.1, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "8"));
    DelayCommand(11.2, MakeSpellbookLevelLoop(CLASS_TYPE_HEALER,           0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "9"));
}

void MakeSpellbookLevelLoop(int nClass, int nMin, int nMax, string sVarNameBase,
    string sColumnName, string sColumnValue, int nLoopSize = 100, string sTag = "")
{
    if(DEBUG) DoDebug("MakeSpellbookLevelLoop("
                 +IntToString(nClass)+", "
                 +IntToString(nMin)+", "
                 +IntToString(nMax)+", "
                 +sVarNameBase+", "
                 +sColumnName+", "
                 +sColumnValue+", "
                 +IntToString(nLoopSize)+", "
                 +") : sTag = "+sTag);

    /// Determine the 2da to use
    int bNewSpellbook = FALSE;
    string sFile;
    // Stuff handled in GetAMSDefinitionFileName()
    if(nClass == CLASS_TYPE_PSION          ||
       nClass == CLASS_TYPE_PSYWAR         ||
       nClass == CLASS_TYPE_WILDER         ||
       nClass == CLASS_TYPE_FIST_OF_ZUOKEN ||
       nClass == CLASS_TYPE_WARMIND        ||
       // Add new psionic classes here

       // Other new caster types
       nClass == CLASS_TYPE_TRUENAMER
       )
        sFile = GetAMSDefinitionFileName(nClass);
    else
    {
        sFile = Get2DACache("classes", "FeatsTable", nClass);
        //sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
        sFile = "cls_spell" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210
        bNewSpellbook = TRUE;
    }

    //get the token to store it on
    //this is piggybacked into 2da caching
    if(sTag == "")
        sTag = sVarNameBase + "_" + IntToString(nClass) + "_" + sColumnName + "_" + sColumnValue;
    object oWP = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oWP))
    {
        object oChest = GetObjectByTag("Bioware2DACache");
        if(!GetIsObjectValid(oChest))
        {
            //has to be an object, placeables cant go through the DB
            oChest = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache",
                                  GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, "Bioware2DACache");
        }
        if(!GetIsObjectValid(oChest))
        {
            //has to be an object, placeables cant go through the DB
            oChest = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache",
                                  GetStartingLocation(), FALSE, "Bioware2DACache");
        }
        // Some inventory shuffle, probably? - Ornedan
        oWP = CreateObject(OBJECT_TYPE_ITEM, "hidetoken", GetLocation(oChest), FALSE, sTag);
        DestroyObject(oWP);
        oWP = CopyObject(oWP, GetLocation(oChest), oChest, sTag);

        if(!GetIsObjectValid(oWP))
        {
            DoDebug("Problem creating token for " + sTag);
            return;
        }
    }
    // Starting a new run and the array exists already. Assume the whole thing is present and abort
    if(nMin == 0 && array_exists(oWP, sTag))
    {
        DoDebug("MakeSpellbookLevelLoop("+sTag+") restored from database");
        return;
    }

    // New run, create the array
    if(nMin == 0)
        array_create(oWP, sTag);

    // Cache loopsize rows
    int i;
    for(i = nMin; i < nMin + nLoopSize; i++)
    {
        // None of the relevant 2da files have blank Label entries on rows other than 0. We can assume i is greater than 0 at this point
        if(i > 0 && Get2DAString(sFile, "Label", i) == "") // Using Get2DAString() instead of Get2DACache() to avoid caching extra
            return;

        if(Get2DACache(sFile, sColumnName, i) == sColumnValue &&
           (!bNewSpellbook ||Get2DACache(sFile, "ReqFeat", i)   == "") // Only new spellbooks have the ReqFeat column. No sense in caching it for other stuff
           )
            array_set_int(oWP, sTag, array_get_size(oWP, sTag), i);
    }

    // And delay continuation to avoid TMI
    if(i < nMax)
        DelayCommand(0.0, MakeSpellbookLevelLoop(nClass, i, nMax, sVarNameBase, sColumnName, sColumnValue, nLoopSize, sTag));
}

void MakeLookupLoop(int nClass, int nMin, int nMax, string sSourceColumn,
    string sDestColumn, string sVarNameBase, int nLoopSize = 100, string sTag = "")
{
    if(DEBUG) DoDebug("MakeLookupLoop("
                 +IntToString(nClass)+", "
                 +IntToString(nMin)+", "
                 +IntToString(nMax)+", "
                 +sSourceColumn+", "
                 +sDestColumn+", "
                 +sVarNameBase+", "
                 +IntToString(nLoopSize)+", "
                 +") : sTag = "+sTag);

    string sFile;
    // Stuff handled in GetAMSDefinitionFileName()
    if(nClass == CLASS_TYPE_PSION          ||
       nClass == CLASS_TYPE_PSYWAR         ||
       nClass == CLASS_TYPE_WILDER         ||
       nClass == CLASS_TYPE_FIST_OF_ZUOKEN ||
       nClass == CLASS_TYPE_WARMIND        ||
       // Add new psionic classes here

       // Other new caster types
       nClass == CLASS_TYPE_TRUENAMER
       )
        sFile = GetAMSDefinitionFileName(nClass);
    else
    {
        sFile = Get2DACache("classes", "FeatsTable", nClass);
        //sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
        sFile = "cls_spell" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210
    }
    //get the token to store it on
    //this is piggybacked into 2da caching
    if(sTag == "")
        sTag = "PRC_" + sVarNameBase;
    object oWP = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oWP))
    {
        object oChest = GetObjectByTag("Bioware2DACache");
        if(!GetIsObjectValid(oChest))
        {
            //has to be an object, placeables cant go through the DB
            oChest = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache",
             GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, "Bioware2DACache");
        }
        if(!GetIsObjectValid(oChest))
        {
            //has to be an object, placeables cant go through the DB
            oChest = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache",
                GetStartingLocation(), FALSE, "Bioware2DACache");
        }
        // Some inventory shuffle, probably? - Ornedan
        oWP = CreateObject(OBJECT_TYPE_ITEM, "hidetoken", GetLocation(oChest), FALSE, sTag);
        DestroyObject(oWP);
        oWP = CopyObject(oWP, GetLocation(oChest), oChest, sTag);

        //cant short-ciruit it cos it gets confused between classes
        if(!GetIsObjectValid(oWP))
        {
            DoDebug("Problem creating token for " + sTag);
            return;
        }
    }
    //else if(nMin == 0)//token exists, if starting new run abort assuming restored from database
    if(nMin == 0
        && GetLocalInt(oWP, sTag+"_"+IntToString(StringToInt(Get2DACache(sFile, sSourceColumn, nMin+1)))))//+1 cos 0 is always null
    {
        DoDebug("MakeLookupLoop("+sTag+") restored from database");
        return;
    }

    int i;
    int nSource, nDest;
    for(i = nMin; i < nMin + nLoopSize; i++)
    {
        // None of the relevant 2da files have blank Label entries on rows other than 0. We can assume i is greater than 0 at this point
        if(i > 0 && Get2DAString(sFile, "Label", i) == "") // Using Get2DAString() instead of Get2DACache() to avoid caching extra
            return;

        if(sSourceColumn == "")
            nSource = i;
        else
            nSource = StringToInt(Get2DACache(sFile, sSourceColumn, i));

        if(sDestColumn == "")
            nDest = i;
        else
            nDest = StringToInt(Get2DACache(sFile, sDestColumn, i));

        if(nSource != 0 && nDest != 0)
        {
            SetLocalInt(oWP, sTag + "_" + IntToString(nSource), nDest);
        }
    }

    // And delay continuation to avoid TMI
    if(i < nMax)
        DelayCommand(0.0, MakeLookupLoop(nClass, i, nMax, sSourceColumn, sDestColumn, sVarNameBase, nLoopSize, sTag));
}

int GetPowerFromSpellID(int nSpellID)
{
    object oWP = GetObjectByTag("PRC_GetPowerFromSpellID");
    int nPower = GetLocalInt(oWP, "PRC_GetPowerFromSpellID_"+IntToString(nSpellID));
    if(nPower == 0)
        nPower = -1;
    return nPower;
}

int GetPowerfileIndexFromSpellID(int nSpellID)
{
    object oWP = GetObjectByTag("PRC_SpellIDToClsPsipw");
    int nIndex = GetLocalInt(oWP, "PRC_SpellIDToClsPsipw_" + IntToString(nSpellID));
    return nIndex;
}

int GetClassFeatFromPower(int nPowerID, int nClass)
{
    string sLabel = "PRC_GetClassFeatFromPower_"+IntToString(nClass);
    object oWP = GetObjectByTag(sLabel);
    int nPower = GetLocalInt(oWP, sLabel+"_"+IntToString(nPowerID));
    if(nPower == 0)
        nPower = -1;
    return nPower;
}

string GetAMSKnownFileName(int nClass)
{
    // Get the class-specific base
    string sFile = Get2DACache("classes", "FeatsTable", nClass);

    // Various naming schemes based on system
    if(nClass == CLASS_TYPE_TRUENAMER)
        sFile = "cls_true_known";
    // Assume psionics if no other match
    else
        sFile = "cls_psbk" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210

    return sFile;
}

string GetAMSDefinitionFileName(int nClass)
{
    // Get the class-specific base
    string sFile = Get2DACache("classes", "FeatsTable", nClass);

    // Various naming schemes based on system
    if(nClass == CLASS_TYPE_TRUENAMER)
        sFile = "cls_true_utter";
    // Assume psionics if no other match
    else
        sFile = "cls_psipw" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061210

    return sFile;
}

// Test main
//void main(){}
