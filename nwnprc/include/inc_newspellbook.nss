

/* Steps for adding a new spellbook

Prepared:
Make cls_spbk_*.2da
Make cls_spcr_*.2da
Add the spellbook feat to cls_feat_*.2da at the appropriate level
Add class to GetSpellbookTypeForClass() below
Add class to GetAbilityForClass() below
Add class to GetIsArcaneClass() or GetIsDivineClass() in prc_inc_spells as appropriate
Add class to GetCasterLvl() in prc_inc_spells
Add class to MakeLookupLoopMaster() in inc_lookups
Run the assemble_spellbooks.bat file
Make the prc_* scripts in newspellbook

Spont:
Make cls_spbk_*.2da
Make cls_spkn_*.2da
Make cls_spcr_*.2da
Add class to GetSpellbookTypeForClass() below
Add class to GetAbilityForClass() below
Add class to GetIsArcaneClass() or GetIsDivineClass() in prc_inc_spells as appropriate
Add class to GetCasterLvl() in prc_inc_spells
Add class to MakeLookupLoopMaster() in inc_lookups
Add class to prc_amagsys_gain if(CheckMissingSpells(oPC, CLASS_TYPE_SORCERER, MinimumSpellLevel, MaximumSpellLevel))
Add class to ExecuteScript("prc_spellgain", oPC) list in EvalPRCFeats in prc_inc_function
Run the assemble_spellbooks.bat file
Make the prc_* scripts in newspellbook

*/

//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

const int SPELLBOOK_IPRP_FEATS_START = 5000;
const int SPELLBOOK_IPRP_FEATS_END   = 11999;

const int SPELLBOOK_TYPE_PREPARED    = 1;
const int SPELLBOOK_TYPE_SPONTANEOUS = 2;
const int SPELLBOOK_TYPE_INVALID     = 0;


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

int GetSpellbookTypeForClass(int nClass);
int GetAbilityForClass(int nClass, object oPC);

/**
 * Determines the given character's DC-modifying ability modifier for
 * the given class' spells. Handles split-score casters.
 *
 * @param nClass The spellcasting class for whose spells to determine ability mod to DC for
 * @param oPC    The character whose abilities to examine
 * @return       The DC-modifying ability score's ability modifier value
 */
int GetDCAbilityModForClass(int nClass, object oPC);

string GetFileForClass(int nClass);
int GetSpellslotLevel(int nClass, object oPC);
int GetItemBonusSlotCount(object oPC, int nClass, int nSpellLevel);
int GetSlotCount(int nLevel, int nSpellLevel, int nAbilityScore, int nClass, object oItemPosessor = OBJECT_INVALID);
int GetSpellKnownMaxCount(int nLevel, int nSpellLevel, int nClass, object oPC);
int GetSpellKnownCurrentCount(object oPC, int nSpellLevel, int nClass);
int GetSpellUnknownCurrentCount(object oPC, int nSpellLevel, int nClass);
void AddSpellUse(object oPC, int nSpellbookID, int nClass, string sFile, string sArrayName, int nSpellbookType, object oSkin, int nFeatID, int nIPFeatID);
void RemoveSpellUse(object oPC, int nSpellID, int nClass);
int GetSpellUses(object oPC, int nSpellID, int nClass);
int GetSpellLevel(object oPC, int nSpellID, int nClass);
void SetupSpells(object oPC, int nClass);
void CheckAndRemoveFeat(object oHide, itemproperty ipFeat);
void WipeSpellbookHideFeats(object oPC);
void CheckNewSpellbooks(object oPC);
void NewSpellbookSpell(int nClass, int nMetamagic, int nSpellID);


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "nw_i0_generic"
#include "inc_utility"
#include "prc_inc_spells"
#include "inc_lookups"


//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int GetSpellbookTypeForClass(int nClass)
{
    switch(nClass)
    {
        case CLASS_TYPE_BLACKGUARD:
        case CLASS_TYPE_VASSAL:
        case CLASS_TYPE_SOLDIER_OF_LIGHT:
        case CLASS_TYPE_KNIGHT_MIDDLECIRCLE:
        case CLASS_TYPE_KNIGHT_CHALICE:
        case CLASS_TYPE_VIGILANT:
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_ANTI_PALADIN:
        case CLASS_TYPE_OCULAR:
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_SHADOWLORD:
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_SOHEI:
        case CLASS_TYPE_SLAYER_OF_DOMIEL:
        case CLASS_TYPE_HEALER:
            return SPELLBOOK_TYPE_PREPARED;
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SUEL_ARCHANAMACH:
        case CLASS_TYPE_FAVOURED_SOUL:
        case CLASS_TYPE_HEXBLADE:
        case CLASS_TYPE_DUSKBLADE:
    case CLASS_TYPE_WARMAGE:
            return SPELLBOOK_TYPE_SPONTANEOUS;
        //outsider HD count as sorc for raks
        case CLASS_TYPE_OUTSIDER: {
            /// @todo Will eventually need to add a check here to differentiate between races. Not all are sorcerers, just most
            return SPELLBOOK_TYPE_SPONTANEOUS;
        }
    }
    return SPELLBOOK_TYPE_INVALID;
}

int GetAbilityForClass(int nClass, object oPC)
{
    switch(nClass)
    {
        case CLASS_TYPE_BLACKGUARD:
        case CLASS_TYPE_VASSAL:
        case CLASS_TYPE_SOLDIER_OF_LIGHT:
        case CLASS_TYPE_KNIGHT_MIDDLECIRCLE:
        case CLASS_TYPE_KNIGHT_CHALICE:
        case CLASS_TYPE_VIGILANT:
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_PSYWAR:
        case CLASS_TYPE_ANTI_PALADIN:
        case CLASS_TYPE_OCULAR:
        case CLASS_TYPE_FIST_OF_ZUOKEN:
        case CLASS_TYPE_WARMIND:
        case CLASS_TYPE_SOHEI:
        case CLASS_TYPE_SLAYER_OF_DOMIEL:
        case CLASS_TYPE_HEALER:
        case CLASS_TYPE_SLAYER_OF_DOMIEL:
            return GetAbilityScore(oPC, ABILITY_WISDOM);
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_PSION:
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_SHADOWLORD:
        case CLASS_TYPE_DUSKBLADE:

            return GetAbilityScore(oPC, ABILITY_INTELLIGENCE);
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_WILDER:
        case CLASS_TYPE_SUEL_ARCHANAMACH:
        case CLASS_TYPE_FAVOURED_SOUL:
        case CLASS_TYPE_HEXBLADE:
        case CLASS_TYPE_WARMAGE:
            return GetAbilityScore(oPC, ABILITY_CHARISMA);
        //outsider HD count as sorc for raks
        case CLASS_TYPE_OUTSIDER: {
            /// @todo Will eventually need to add a check here to differentiate between races. Not all are sorcerers, just most
            return GetAbilityScore(oPC, ABILITY_CHARISMA);
        }
    }
    return 0;
}

int GetDCAbilityModForClass(int nClass, object oPC)
{
    switch(nClass)
    {
        // Split ability casters
        case CLASS_TYPE_FAVOURED_SOUL:
            return GetAbilityModifier(ABILITY_WISDOM, oPC);

        // Everyone else
        default:
            return (GetAbilityForClass(nClass, oPC) - 10) / 2;
    }

    return 0;
}

string GetFileForClass(int nClass)
{
    string sFile = Get2DACache("classes", "FeatsTable", nClass);
    sFile = "cls_spell" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061231
    //if(DEBUG) DoDebug("GetFileForClass(" + IntToString(nClass) + ") = " + sFile);
    return sFile;
}

int GetSpellslotLevel(int nClass, object oPC)
{
    //int nLevel = GetCasterLvl(nClass, oPC);
    //if(DEBUG) DoDebug("GetSpellslotLevel(" + IntToString(nClass) + ", " + GetName(oPC) + ") = " + IntToString(nLevel));
    int nLevel = GetLevelByClass(nClass, oPC);
    int nArcSpellslotLevel;
    int nDivSpellslotLevel;
    int i;
    for(i = 1; i <= 3; i++)
    {
        int nTempClass = PRCGetClassByPosition(i, oPC);
        //spellcasting prc
        int nArcSpellMod = StringToInt(Get2DACache("classes", "ArcSpellLvlMod", nTempClass));
        int nDivSpellMod = StringToInt(Get2DACache("classes", "DivSpellLvlMod", nTempClass));
        if(nArcSpellMod == 1)
            nArcSpellslotLevel += GetLevelByClass(nTempClass, oPC);
        else if(nArcSpellMod > 1)
            nArcSpellslotLevel += (GetLevelByClass(nTempClass, oPC) + 1) / nArcSpellMod;
        if(nDivSpellMod == 1)
            nDivSpellslotLevel += GetLevelByClass(nTempClass, oPC);
        else if(nDivSpellMod > 1)
            nDivSpellslotLevel += (GetLevelByClass(nTempClass, oPC) + 1) / nDivSpellMod;
    }
    if(GetFirstArcaneClass(oPC) == nClass)
        nLevel += nArcSpellslotLevel;
    if(GetFirstDivineClass(oPC) == nClass)
        nLevel += nDivSpellslotLevel;
    if(DEBUG) DoDebug("GetSpellslotLevel(" + IntToString(nClass) + ", " + GetName(oPC) + ") = " + IntToString(nLevel));
    return nLevel;
}


int GetItemBonusSlotCount(object oPC, int nClass, int nSpellLevel)
{
    // Value maintained by CheckPRCLimitations()
    return GetLocalInt(oPC, "PRC_IPRPBonSpellSlots_" + IntToString(nClass) + "_" + IntToString(nSpellLevel));
}

int GetSlotCount(int nLevel, int nSpellLevel, int nAbilityScore, int nClass, object oItemPosessor = OBJECT_INVALID)
{
    // Ability score limit rule: Must have casting ability score of at least 10 + spel level to be able to cast spells of that level at all
    if(nAbilityScore < nSpellLevel + 10)
        return 0;
    int nSlots;
    string sFile;
    // Bioware casters use their classes.2da-specified tables
    if(    nClass == CLASS_TYPE_WIZARD
        || nClass == CLASS_TYPE_SORCERER
        || nClass == CLASS_TYPE_BARD
        || nClass == CLASS_TYPE_CLERIC
        || nClass == CLASS_TYPE_DRUID
        || nClass == CLASS_TYPE_PALADIN
        || nClass == CLASS_TYPE_RANGER)
    {
        sFile = Get2DACache("classes", "SpellGainTable", nClass);
    }
    // New spellbook casters use the cls_spbk_* tables
    else
    {
        sFile = Get2DACache("classes", "FeatsTable", nClass);
        sFile = "cls_spbk" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061231
    }

    string sSlots = Get2DACache(sFile, "SpellLevel" + IntToString(nSpellLevel), nLevel - 1);
    if(sSlots == "")
    {
        nSlots = -1;
        //if(DEBUG) DoDebug("GetSlotCount: Problem getting slot numbers for " + IntToString(nSpellLevel) + " " + IntToString(nLevel) + " " + sFile);
    }
    else
        nSlots = StringToInt(sSlots);
    if(nSlots == -1)
        return 0;

    // Add spell slots from items
    if(GetIsObjectValid(oItemPosessor))
        nSlots += GetItemBonusSlotCount(oItemPosessor, nClass, nSpellLevel);

    // Add spell slots from high ability score. Level 0 spells are exempt
    if(nSpellLevel == 0)
        return nSlots;
    else
    {
        int nAbilityMod = (nAbilityScore - 10) / 2;
        if(nAbilityMod >= nSpellLevel) // Need an ability modifier at least equal to the spell level to gain bonus slots
            nSlots += ((nAbilityMod - nSpellLevel) / 4) + 1;
        return nSlots;
    }
}

int GetSpellKnownMaxCount(int nLevel, int nSpellLevel, int nClass, object oPC)
{
    // If the character doesn't have any spell slots available on for this level, it can't know any spells of that level either
    /// @todo Check rules. There might be cases where this doesn't hold
    if(!GetSlotCount(nLevel, nSpellLevel, GetAbilityForClass(nClass, oPC), nClass))
        return 0;
    int nKnown;
    string sFile;
    // Bioware casters use their classes.2da-specified tables
    if(    nClass == CLASS_TYPE_WIZARD
        || nClass == CLASS_TYPE_SORCERER
        || nClass == CLASS_TYPE_BARD
        || nClass == CLASS_TYPE_CLERIC
        || nClass == CLASS_TYPE_DRUID
        || nClass == CLASS_TYPE_PALADIN
        || nClass == CLASS_TYPE_RANGER)
    {
        sFile = Get2DACache("classes", "SpellKnownTable", nClass);
    }
    else
    {
        sFile = Get2DACache("classes", "FeatsTable", nClass);
        sFile = "cls_spkn" + GetStringRight(sFile, GetStringLength(sFile) - 8); // Hardcoded the cls_ part. It's not as if any class uses some other prefix - Ornedan, 20061231
    }

    string sKnown = Get2DACache(sFile, "SpellLevel" + IntToString(nSpellLevel), nLevel - 1);
    if(DEBUG) DoDebug("GetSpellKnownMaxCount(" + IntToString(nLevel) + ", " + IntToString(nSpellLevel) + ", " + IntToString(nClass) + ", " + GetName(oPC) + ") = " + sKnown);
    if(sKnown == "")
    {
        nKnown = -1;
        //if(DEBUG) DoDebug("GetSpellKnownMaxCount: Problem getting known numbers for " + IntToString(nSpellLevel) + " " + IntToString(nLevel) + " " + sFile);
    }
    else
        nKnown = StringToInt(sKnown);
    if(nKnown == -1)
        return 0;

    // Bard and Sorcerer only have new spellbook spells known if they have taken prestige classes that increase spellcasting
    if(nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_BARD)
    {
        if(GetLevelByClass(nClass) == nLevel)
            return 0;
    }
    return nKnown;
}

int GetSpellKnownCurrentCount(object oPC, int nSpellLevel, int nClass)
{
    // Check short-term cache
    string sClassNum = IntToString(nClass);
    if(GetLocalInt(oPC, "GetSKCCCache_" + IntToString(nSpellLevel) + "_" + sClassNum))
        return GetLocalInt(oPC, "GetSKCCCache_" + IntToString(nSpellLevel) + "_" + sClassNum) - 1;

    // Loop over all spells known and count the number of spells of each level known
    int i;
    int nKnown;
    int nKnown0, nKnown1, nKnown2, nKnown3, nKnown4;
    int nKnown5, nKnown6, nKnown7, nKnown8, nKnown9;
    string sFile = GetFileForClass(nClass);
    for(i = 0; i < persistant_array_get_size(oPC, "Spellbook" + sClassNum); i++)
    {
        int nNewSpellbookID = persistant_array_get_int(oPC, "Spellbook" + sClassNum, i);
        int nLevel = StringToInt(Get2DACache(sFile, "Level", nNewSpellbookID));
        switch(nLevel)
        {
            case 0: nKnown0++; break; case 1: nKnown1++; break;
            case 2: nKnown2++; break; case 3: nKnown3++; break;
            case 4: nKnown4++; break; case 5: nKnown5++; break;
            case 6: nKnown6++; break; case 7: nKnown7++; break;
            case 8: nKnown8++; break; case 9: nKnown9++; break;
        }
    }

    // Pick the level requested for returning
    switch(nSpellLevel)
    {
        case 0: nKnown = nKnown0; break; case 1: nKnown = nKnown1; break;
        case 2: nKnown = nKnown2; break; case 3: nKnown = nKnown3; break;
        case 4: nKnown = nKnown4; break; case 5: nKnown = nKnown5; break;
        case 6: nKnown = nKnown6; break; case 7: nKnown = nKnown7; break;
        case 8: nKnown = nKnown8; break; case 9: nKnown = nKnown9; break;
    }
    if(DEBUG) DoDebug("GetSpellKnownCurrentCount(" + GetName(oPC) + ", " + IntToString(nSpellLevel) + ", " + sClassNum + ") = " + IntToString(nKnown));

    // Cache the values for 1 second
    SetLocalInt(oPC, "GetSKCCCache_0_" + sClassNum, nKnown0 + 1);
    SetLocalInt(oPC, "GetSKCCCache_1_" + sClassNum, nKnown1 + 1);
    SetLocalInt(oPC, "GetSKCCCache_2_" + sClassNum, nKnown2 + 1);
    SetLocalInt(oPC, "GetSKCCCache_3_" + sClassNum, nKnown3 + 1);
    SetLocalInt(oPC, "GetSKCCCache_4_" + sClassNum, nKnown4 + 1);
    SetLocalInt(oPC, "GetSKCCCache_5_" + sClassNum, nKnown5 + 1);
    SetLocalInt(oPC, "GetSKCCCache_6_" + sClassNum, nKnown6 + 1);
    SetLocalInt(oPC, "GetSKCCCache_7_" + sClassNum, nKnown7 + 1);
    SetLocalInt(oPC, "GetSKCCCache_8_" + sClassNum, nKnown8 + 1);
    SetLocalInt(oPC, "GetSKCCCache_9_" + sClassNum, nKnown9 + 1);
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_0_" + sClassNum));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_1_" + sClassNum));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_2_" + sClassNum));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_3_" + sClassNum));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_4_" + sClassNum));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_5_" + sClassNum));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_6_" + sClassNum));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_7_" + sClassNum));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_8_" + sClassNum));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_9_" + sClassNum));

    return nKnown;
}

int GetSpellUnknownCurrentCount(object oPC, int nSpellLevel, int nClass)
{
    // Get the lookup token created by MakeSpellbookLevelLoop()
    string sTag = "SpellLvl_" + IntToString(nClass) + "_Level_" + IntToString(nSpellLevel);
    object oCache = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oCache))
    {
        if(DEBUG) DoDebug("GetSpellUnknownCurrentCount: " + sTag + " is not valid");
        return 0;
    }
    // Read the total number of spells on the given level and determine how many are already known
    int nTotal = array_get_size(oCache, "Lkup");
    int nKnown = GetSpellKnownCurrentCount(oPC, nSpellLevel, nClass);
    int nUnknown = nTotal - nKnown;

    if(DEBUG) DoDebug("GetSpellUnknownCurrentCount(" + GetName(oPC) + ", " + IntToString(nSpellLevel) + ", " + IntToString(nClass) + ") = " + IntToString(nUnknown));
    return nUnknown;
}

void AddSpellUse(object oPC, int nSpellbookID, int nClass, string sFile, string sArrayName, int nSpellbookType, object oSkin, int nFeatID, int nIPFeatID)
{
    /*
    string sFile = GetFileForClass(nClass);
    string sArrayName = "NewSpellbookMem_"+IntToString(nClass);
    int nSpellbookType = GetSpellbookTypeForClass(nClass);
    object oSkin = GetPCSkin(oPC);
    int nFeatID = StringToInt(Get2DACache(sFile, "FeatID", nSpellbookID));
    //add the feat only if they dont already have it
    int nIPFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID));
    */

    // Add the spell use feats and set a marker local that tells for CheckAndRemoveFeat() to skip removing this feat
    string sIPFeatID = IntToString(nIPFeatID);
    if(!GetHasFeat(nFeatID, oPC))
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nIPFeatID), oSkin);
        SetLocalInt(oSkin, "NewSpellbookTemp_" + sIPFeatID, TRUE);
        //if(DEBUG) DoDebug("AddSpellUse: SetLocalInt(oSkin, NewSpellbookTemp_" + sIPFeatID + ", TRUE);");
    }
    else
    {
        //they already have it but we need to tell the hide cleaner to keep it
        //if(DEBUG) DoDebug("AddSpellUse: SetLocalInt(oSkin, NewSpellbookTemp_" + sIPFeatID + ", TRUE);");
        SetLocalInt(oSkin, "NewSpellbookTemp_" + sIPFeatID, TRUE);
    }
    // Increase the current number of uses
    if(nSpellbookType == SPELLBOOK_TYPE_PREPARED)
    {
        //sanity test
        if(!persistant_array_exists(oPC, sArrayName))
        {
            DoDebug("ERROR: AddSpellUse: " + sArrayName + " array does not exist, creating");
            persistant_array_create(oPC, sArrayName);
        }
        int nUses = persistant_array_get_int(oPC, sArrayName, nSpellbookID);
        nUses++;
        persistant_array_set_int(oPC, sArrayName, nSpellbookID, nUses);
        if(DEBUG) DoDebug("AddSpellUse: " + sArrayName + "[" + IntToString(nSpellbookID) + "] = " + IntToString(persistant_array_get_int(oPC, sArrayName, nSpellbookID)));
    }
    else if(nSpellbookType == SPELLBOOK_TYPE_SPONTANEOUS)
    {
        if(DEBUG) DoDebug("AddSpellUse() called on spontaneous spellbook. nIPFeatID = " + sIPFeatID);
    }
}

void RemoveSpellUse(object oPC, int nSpellID, int nClass)
{
    string sFile = GetFileForClass(nClass);
    int nSpellbookID = SpellToSpellbookID(nSpellID);
    if(nSpellbookID == -1)
    {
        DoDebug("ERROR: RemoveSpellUse: Unable to resolve spell to spellbookID: " + IntToString(nSpellID) + " in file " + sFile);
        return;
    }
    if(!persistant_array_exists(oPC, "NewSpellbookMem_"+IntToString(nClass)))
    {
        if(DEBUG) DoDebug("RemoveSpellUse: NewSpellbookMem_" + IntToString(nClass) + " does not exist, creating.");
        persistant_array_create(oPC, "NewSpellbookMem_"+IntToString(nClass));
    }

    // Reduce the remaining uses of the given spell by 1 (except never reduce uses below 0).
    // Spontaneous spellbooks reduce the number of spells of the spell's level remaining
    int nSpellbookType = GetSpellbookTypeForClass(nClass);
    if(nSpellbookType == SPELLBOOK_TYPE_PREPARED)
    {
        int nCount = persistant_array_get_int(oPC, "NewSpellbookMem_" + IntToString(nClass), nSpellbookID);
        if(nCount > 0)
            persistant_array_set_int(oPC, "NewSpellbookMem_" + IntToString(nClass), nSpellbookID, nCount - 1);
    }
    else if(nSpellbookType == SPELLBOOK_TYPE_SPONTANEOUS)
    {
        int nSpellLevel = StringToInt(Get2DACache(sFile, "Level", nSpellbookID));
        int nCount = persistant_array_get_int(oPC, "NewSpellbookMem_" + IntToString(nClass), nSpellLevel);
        if(nCount > 0)
            persistant_array_set_int(oPC, "NewSpellbookMem_" + IntToString(nClass), nSpellLevel, nCount - 1);
    }
}

int GetSpellLevel(object oPC, int nSpellID, int nClass)
{
    string sFile = GetFileForClass(nClass);
    int nSpellbookID = SpellToSpellbookID(nSpellID);
    if(nSpellbookID == -1)
    {
        DoDebug("ERROR: GetSpellLevel: Unable to resolve spell to spellbookID: "+IntToString(nSpellID)+" "+sFile);
        return -1;
    }

    // check if this spell actually belong to this class
    if (nSpellID != StringToInt(Get2DACache(sFile, "SpellID", nSpellbookID)))
        return -1;

    // get spell level
    int nSpellLevel = -1;
    string sSpellLevel = Get2DACache(sFile, "Level", nSpellbookID);

    if (sSpellLevel != "")
        nSpellLevel = StringToInt(sSpellLevel);

    return nSpellLevel;
}

void SetupSpells(object oPC, int nClass)
{
    string sFile = GetFileForClass(nClass);
    string sClass = IntToString(nClass);
    string sArrayName = "NewSpellbookMem_" + sClass;
    object oSkin = GetPCSkin(oPC);
    int nLevel = GetCasterLvl(nClass, oPC);
    int nAbility = GetAbilityForClass(nClass, oPC);
    int nSpellbookType = GetSpellbookTypeForClass(nClass);

    // For spontaneous spellbooks, set up an array that tells how many spells of each level they can cast
    // And add casting feats for each spell known to the caster's hide
    if(nSpellbookType == SPELLBOOK_TYPE_SPONTANEOUS)
    {
        // Spell slots
        int nSpellLevel, nSlots;
        for(nSpellLevel = 0; nSpellLevel <= 9; nSpellLevel++)
        {
            nSlots = GetSlotCount(nLevel, nSpellLevel, nAbility, nClass, oPC);
            persistant_array_set_int(oPC, sArrayName, nSpellLevel, nSlots);
        }

        // Use feats
        int i, j;
        int nSpellbookID, nRealSpellID, nTestRealSpellID, nMetaFeat;
        for(i = 0; i < persistant_array_get_size(oPC, "Spellbook" + sClass); i++)
        {
            nSpellbookID = persistant_array_get_int(oPC, "Spellbook" + sClass, i);
            AddSpellUse(oPC, nSpellbookID, nClass, sFile, sArrayName, nSpellbookType, oSkin,
                        StringToInt(Get2DACache(sFile, "FeatID", nSpellbookID)),
                        StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID))
                        );
            //metamagic
            nRealSpellID = StringToInt(Get2DACache(sFile, "RealSpellID", nSpellbookID));

            // Loop over all the possible metamagic versions of this spell
            j = nSpellbookID + 1; // Metamagic variations start at the base spell's index + 1
            // Metamagic variations are all in a continuous block after the base spell. We can therefore terminate the loop
            // upon encountering the first entry related to another spell
            while(StringToInt(Get2DACache(sFile, "RealSpellID", j)) == nRealSpellID)
            {
                // See if the PC has the metafeat required by this variant of the spell
                nMetaFeat = StringToInt(Get2DACache(sFile, "ReqFeat", j));
                if(nMetaFeat != 0 && GetHasFeat(nMetaFeat, oPC))
                    DelayCommand(0.0f,
                            AddSpellUse(oPC, j, nClass, sFile, sArrayName, nSpellbookType, oSkin,
                                StringToInt(Get2DACache(sFile, "FeatID", j)),
                                StringToInt(Get2DACache(sFile, "IPFeatID", j))
                                )
                            );

                // Increment loop counter
                j += 1;
            }
        }
    }// end if - Spontaneous spellbook

    // For prepared spellbooks, add spell uses and use feats according to spells memorised list
    else if(nSpellbookType == SPELLBOOK_TYPE_PREPARED)
    {
        int nSpellLevel, nSlot, nSlots, nSpellbookID;
        string sArrayName2;
        for(nSpellLevel = 0; nSpellLevel <= 9; nSpellLevel++)
        {
            nSlots = GetSlotCount(nLevel, nSpellLevel, nAbility, nClass, oPC);
            nSlot;
            for(nSlot = 0; nSlot < nSlots; nSlot++)
            {
                //done when spells are added to it
                sArrayName2 = "Spellbook" + IntToString(nSpellLevel) + "_" + sClass; // Minor optimisation: cache the array name string for multiple uses
                if(!persistant_array_exists(oPC, sArrayName2))
                    persistant_array_create(oPC, sArrayName2);
                nSpellbookID = persistant_array_get_int(oPC, sArrayName2, nSlot);
                if(nSpellbookID != 0)
                {
                    AddSpellUse(oPC, nSpellbookID, nClass, sFile, sArrayName, nSpellbookType, oSkin,
                        StringToInt(Get2DACache(sFile, "FeatID", nSpellbookID)),
                        StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID))
                        );
                }
            }
        }
    }
}

void CheckAndRemoveFeat(object oHide, itemproperty ipFeat)
{
    int nSubType = GetItemPropertySubType(ipFeat);
    if(!GetLocalInt(oHide, "NewSpellbookTemp_" + IntToString(nSubType)))
    {
        RemoveItemProperty(oHide, ipFeat);
        DeleteLocalInt(oHide, "NewSpellbookTemp_" + IntToString(nSubType));
        if(DEBUG) DoDebug("CheckAndRemoveFeat: DeleteLocalInt(oHide, NewSpellbookTemp_" + IntToString(nSubType) + ");");
        if(DEBUG) DoDebug("CheckAndRemoveFeat: Removing item property");
    }
    else
    {
        DeleteLocalInt(oHide, "NewSpellbookTemp_" + IntToString(nSubType));
        if(DEBUG) DoDebug("CheckAndRemoveFeat: DeleteLocalInt(oHide, NewSpellbookTemp_" + IntToString(nSubType) + ");");
    }
}

void WipeSpellbookHideFeats(object oPC)
{
    object oHide = GetPCSkin(oPC);
    itemproperty ipTest = GetFirstItemProperty(oHide);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT     &&
           GetItemPropertySubType(ipTest) > SPELLBOOK_IPRP_FEATS_START &&
           GetItemPropertySubType(ipTest) < SPELLBOOK_IPRP_FEATS_END
           )
        {
            DelayCommand(0.5, CheckAndRemoveFeat(oHide, ipTest));
        }
        ipTest = GetNextItemProperty(oHide);
    }
}

void CheckNewSpellbooks(object oPC)
{
    WipeSpellbookHideFeats(oPC);
    int i;
    for(i = 1; i <= 3; i++)
    {
        int nClass = PRCGetClassByPosition(i, oPC);
        int nLevel = GetLevelByClass(nClass, oPC);

        if(DEBUG) DoDebug("CheckNewSpellbooks\n"
                        + "nClass = " + IntToString(nClass) + "\n"
                        + "nLevel = " + IntToString(nLevel) + "\n"
                          );
        //if bard/sorc newspellbook is disabled after selecting
        //remove those from radial
        if(   (GetPRCSwitch(PRC_BARD_DISALLOW_NEWSPELLBOOK) && nClass == CLASS_TYPE_BARD)
            ||(GetPRCSwitch(PRC_SORC_DISALLOW_NEWSPELLBOOK) && nClass == CLASS_TYPE_SORCERER))
        {
            //do nothing
        }
        else if(nLevel)
        {
            //raks cast as sorcs
            if(nClass == CLASS_TYPE_OUTSIDER
                && !GetLevelByClass(CLASS_TYPE_SORCERER, oPC)
                && GetRacialType(oPC) == RACIAL_TYPE_RAKSHASA)
                nClass = CLASS_TYPE_SORCERER;
            //remove persistant locals used to track when all spells cast
            if(persistant_array_exists(oPC, "NewSpellbookMem_"+IntToString(nClass)))
            {
                persistant_array_delete(oPC, "NewSpellbookMem_"+IntToString(nClass));
                persistant_array_create(oPC, "NewSpellbookMem_"+IntToString(nClass));
            }
            //delay it so wipespellbookhidefeats has time to start to run
            //but before the deletes actually happen
            DelayCommand(0.1, SetupSpells(oPC, nClass));
        }
    }
}

void NewSpellbookSpell(int nClass, int nMetamagic, int nSpellID)
{
    object oPC = OBJECT_SELF;
    //get the spellbook ID
    string sFile = GetFileForClass(nClass);
    int nFakeSpellID = PRCGetSpellId();
    //if its a subradial spell, get the master
    int nMasterFakeSpellID;
    nMasterFakeSpellID = StringToInt(Get2DACache("spells", "Master", nFakeSpellID));
    if(!nMasterFakeSpellID)
        nMasterFakeSpellID = nFakeSpellID;

    int nSpellbookID = SpellToSpellbookID(nMasterFakeSpellID);

    // Paranoia - It should not be possible to get here without having the spells available array existing
    if(!persistant_array_exists(oPC, "NewSpellbookMem_" + IntToString(nClass)))
    {
        if(DEBUG) DoDebug("ERROR: NewSpellbookSpell: NewSpellbookMem_" + IntToString(nClass) + " array does not exist");
        persistant_array_create(oPC, "NewSpellbookMem_" + IntToString(nClass));
    }

    // Make sure the caster has uses of this spell remaining
    int nSpellbookType = GetSpellbookTypeForClass(nClass);
    int nSpellLevel = StringToInt(Get2DACache(sFile, "Level", nSpellbookID));
    if(nSpellbookType == SPELLBOOK_TYPE_PREPARED)
    {
        int nCount = persistant_array_get_int(oPC, "NewSpellbookMem_" + IntToString(nClass), nSpellbookID);
        if(DEBUG) DoDebug("NewSpellbookSpell: NewSpellbookMem_" + IntToString(nClass) + "[" + IntToString(nSpellbookID) + "] = " + IntToString(nCount));
        if(nCount < 1)
        {
            string sSpellName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
            // "You have no castings of " + sSpellName + " remaining"
            string sMessage   = ReplaceChars(GetStringByStrRef(16828411), "<spellname>", sSpellName);

            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            return;
        }
        else
        {
            string sSpellName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
            // "You have " + IntToString(nCount - 1) + " castings of " + sSpellName + " remaining"
            string sMessage   = ReplaceChars(GetStringByStrRef(16828410), "<count>",     IntToString(nCount - 1));
                   sMessage   = ReplaceChars(sMessage,                    "<spellname>", sSpellName);

            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
        }
    }
    else  if(nSpellbookType == SPELLBOOK_TYPE_SPONTANEOUS)
    {
        int nCount = persistant_array_get_int(oPC, "NewSpellbookMem_" + IntToString(nClass), nSpellLevel);
        if(DEBUG) DoDebug("NewSpellbookSpell: NewSpellbookMem_" + IntToString(nClass) + "[" + IntToString(nSpellbookID) + "] = " + IntToString(nCount));
        if(nCount < 1)
        {
            // "You have no castings of spells of level " + IntToString(nSpellLevel) + " remaining"
            string sMessage   = ReplaceChars(GetStringByStrRef(16828409), "<spelllevel>", IntToString(nSpellLevel));

            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
            return;
        }
        else
        {
            // "You have " + IntToString(nCount - 1) + " castings of spells of level " + IntToString(nSpellLevel) + " remaining"
            string sMessage   = ReplaceChars(GetStringByStrRef(16828408), "<count>",      IntToString(nCount - 1));
                   sMessage   = ReplaceChars(sMessage,                    "<spelllevel>", IntToString(nSpellLevel));

            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
        }
    }

    // Decrement spell uses
    RemoveSpellUse(oPC, nMasterFakeSpellID, nClass);

    // Arcane classes roll ASF if the spell has a somatic component
    if(    GetIsArcaneClass(nClass)
        && Random(100) < GetArcaneSpellFailure(oPC)
        && FindSubString(GetStringLowerCase(Get2DACache("spells", "VS", nSpellID)), "s") != -1)
    {
        int nFail = TRUE;
        // Still spell helps
        if(    nMetamagic == METAMAGIC_STILL
            || (GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_1, oPC) && nSpellLevel <= 3)
            || (GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_2, oPC) && nSpellLevel <= 6)
            || (GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_3, oPC) && nSpellLevel <= 9))
        {
            nFail = FALSE;
        }
        if(nFail)
        {
            //52946 = Spell failed due to arcane spell failure!
            FloatingTextStrRefOnCreature(52946, oPC, FALSE);
            return;
        }
    }

    // If the spell has a vocal component, silence and deafness can cause failure
    if(    FindSubString(GetStringLowerCase(Get2DACache("spells", "VS", nSpellID)),"v") != -1
        && (GetHasEffect(EFFECT_TYPE_SILENCE, oPC) || (GetHasEffect(EFFECT_TYPE_DEAF, oPC) && Random(100) < 20)))

    {
        int nFail = TRUE;
        //auto-still exceptions
        if(    nMetamagic == METAMAGIC_SILENT
            || (GetHasFeat(FEAT_EPIC_AUTOMATIC_SILENT_SPELL_1, oPC) && nSpellLevel <= 3)
            || (GetHasFeat(FEAT_EPIC_AUTOMATIC_SILENT_SPELL_2, oPC) && nSpellLevel <= 6)
            || (GetHasFeat(FEAT_EPIC_AUTOMATIC_SILENT_SPELL_3, oPC) && nSpellLevel <= 9))
        {
            nFail = FALSE;
        }
        if(nFail)
        {
            //3734 = Spell failed!
            FloatingTextStrRefOnCreature(3734, oPC, FALSE);
            return;
        }
    }

    // Calculate DC. 10 + spell level on the casting class's list + DC increasing ability mod
    int nDC = 10 + nSpellLevel + GetDCAbilityModForClass(nClass, oPC);

    //remove any old effects
    //seems cheat-casting breaks hardcoded removal
    //and cant remove effects because I dont know all the targets!

    // This does the Duskblade's Quick Cast
    // Yes, I know it overrides other metamagic
    if (nClass == CLASS_TYPE_DUSKBLADE && GetLocalInt(oPC, "DBQuickCast"))
        nMetamagic = METAMAGIC_QUICKEN;


    //cast the spell
    //dont need to override level, the spellscript will calculate it
    ActionCastSpell(nSpellID, 0, nDC, 0, nMetamagic, nClass);
}