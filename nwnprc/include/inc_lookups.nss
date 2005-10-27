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
    string sDestColumn, string sVarNameBase, int nLoopSize = 100);

//this returns the real SpellID of "wrapper" spells cast by psionic or the new spellbooks
int GetPowerFromSpellID(int nSpellID);

//this retuns the featID of the class-specific feat for a spellID
//useful for psionics GetHasPower function
int GetClassFeatFromPower(int nPowerID, int nClass);


#include "inc_utility"
#include "psi_inc_psifunc"
#include "prc_class_const"

void MakeLookupLoopMaster()
{
    //now the loops
    DelayCommand(1.0, MakeLookupLoop(CLASS_TYPE_PSION,            0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(1.2, MakeLookupLoop(CLASS_TYPE_PSION,            0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_PSION)));
    DelayCommand(1.4, MakeLookupLoop(CLASS_TYPE_PSYWAR,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(1.6, MakeLookupLoop(CLASS_TYPE_PSYWAR,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_PSYWAR)));
    DelayCommand(1.8, MakeLookupLoop(CLASS_TYPE_WILDER,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.0, MakeLookupLoop(CLASS_TYPE_WILDER,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_WILDER)));
    DelayCommand(2.2, MakeLookupLoop(CLASS_TYPE_FIST_OF_ZUOKEN,   0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.4, MakeLookupLoop(CLASS_TYPE_FIST_OF_ZUOKEN,   0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_FIST_OF_ZUOKEN)));
    //add new psionic classes here
    //also add them later too

    //new spellbook lookups
    DelayCommand(2.6, MakeLookupLoop(CLASS_TYPE_BLACKGUARD,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.7, MakeLookupLoop(CLASS_TYPE_ANTI_PALADIN,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.8, MakeLookupLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.9, MakeLookupLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE, 0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.0, MakeLookupLoop(CLASS_TYPE_KNIGHT_CHALICE,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.1, MakeLookupLoop(CLASS_TYPE_VIGILANT,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.2, MakeLookupLoop(CLASS_TYPE_VASSAL,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.3, MakeLookupLoop(CLASS_TYPE_OCULAR,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
}

void MakeLookupLoop(int nClass, int nMin, int nMax, string sSourceColumn,
    string sDestColumn, string sVarNameBase, int nLoopSize = 100)
{
    //get the token to store it on
    //this is piggybacked into 2da caching
    string sTag = "PRC_"+sVarNameBase;
    object oWP = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oWP))
    {
        object oChest = GetObjectByTag("Bioware2DACache");
        if(!GetIsObjectValid(oChest))
        {
            oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_chest2",
                GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, "Bioware2DACache");
        }
        if(!GetIsObjectValid(oChest))
        {
            oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_chest2",
                GetStartingLocation(), FALSE, "Bioware2DACache");
        }
        oWP = CreateObject(OBJECT_TYPE_ITEM, "hidetoken", GetLocation(oChest), FALSE, sTag);
        DestroyObject(oWP);
        oWP = CopyObject(oWP, GetLocation(oChest), oChest, sTag);
    }
    if(!GetIsObjectValid(oWP))
    {
        PrintString("Problem creating token for "+sTag);
        return;
    }

    string sFile;
    if(nClass == CLASS_TYPE_PSION
        || nClass == CLASS_TYPE_PSYWAR
        || nClass == CLASS_TYPE_WILDER
        || nClass == CLASS_TYPE_FIST_OF_ZUOKEN
    //add new psionic classes here
        )
        sFile = GetPsiBookFileName(nClass);
    else
    {
        sFile = Get2DACache("classes", "FeatsTable", nClass);
        sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
    }

    int i = nMin;
    for(i=nMin;i<nMin+nLoopSize;i++)
    {
        int nSpellID = StringToInt(Get2DACache(sFile, sSourceColumn, i));
        int nPower   = StringToInt(Get2DACache(sFile, sDestColumn,   i));
        if(nSpellID != 0 && nPower != 0)
            SetLocalInt(oWP, sTag+"_"+IntToString(nSpellID), nPower);

    }
    if(i<nMax)
        DelayCommand(1.0, MakeLookupLoop(nClass, i, nMax, sSourceColumn, sDestColumn, sVarNameBase, nLoopSize));
}

int GetPowerFromSpellID(int nSpellID)
{
    object oWP = GetObjectByTag("PRC_GetPowerFromSpellID");
    int nPower = GetLocalInt(oWP, "PRC_GetPowerFromSpellID_"+IntToString(nSpellID));
    if(nPower == 0)
        nPower = -1;
    return nPower;
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