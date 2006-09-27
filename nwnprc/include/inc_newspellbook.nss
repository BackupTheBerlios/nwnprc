

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
Add the spellbook feat to cls_feat_*.2da at the appropriate level
Add class to GetSpellbookTypeForClass() below
Add class to GetAbilityForClass() below
Add class to GetIsArcaneClass() or GetIsDivineClass() in prc_inc_spells as appropriate
Add class to GetCasterLvl() in prc_inc_spells
Add class to MakeLookupLoopMaster() in inc_lookups
Add class to prc_spellgain if(CheckMissingSpells(oPC, CLASS_TYPE_SORCERER, MinimumSpellLevel, MaximumSpellLevel))
Add class to ExecuteScript("prc_spellgain", oPC) list in EvalPRCFeats in prc_inc_function
Run the assemble_spellbooks.bat file
Make the prc_* scripts in newspellbook

*/

const int SPELLBOOK_IPRP_FEATS_START = 10400;
const int SPELLBOOK_IPRP_FEATS_END = 11999;
const int SPELLBOOK_TYPE_PREPARED = 1;
const int SPELLBOOK_TYPE_SPONTANEOUS = 2;
const int SPELLBOOK_TYPE_INVALID = 0;

void NewSpellbookSpell(int nClass, int nMetamagic, int nSpellID);
int SpellToSpellbookID(int nSpell, string sFile = "", int nClass = -1);
string GetFileForClass(int nClass);

#include "x2_inc_itemprop"
#include "inc_utility"
#include "prc_inc_spells"
//#include "prc_inc_clsfunc"


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
        case CLASS_TYPE_SLAYEROFDOMIEL:
            return SPELLBOOK_TYPE_PREPARED;
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SUEL_ARCHANAMACH:
        case CLASS_TYPE_FAVOURED_SOUL:
        case CLASS_TYPE_HEXBLADE:
            return SPELLBOOK_TYPE_SPONTANEOUS;
        //outsider HD count as sorc for raks
        case CLASS_TYPE_OUTSIDER:
            return SPELLBOOK_TYPE_SPONTANEOUS;
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
        case CLASS_TYPE_SLAYEROFDOMIEL: 
            return GetAbilityScore(oPC, ABILITY_WISDOM);
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_PSION:
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_SHADOWLORD:
            return GetAbilityScore(oPC, ABILITY_INTELLIGENCE);
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_WILDER:
        case CLASS_TYPE_SUEL_ARCHANAMACH:
        case CLASS_TYPE_FAVOURED_SOUL:
        case CLASS_TYPE_HEXBLADE:
            return GetAbilityScore(oPC, ABILITY_CHARISMA);
        //outsider HD count as sorc for raks
        case CLASS_TYPE_OUTSIDER:
            return GetAbilityScore(oPC, ABILITY_CHARISMA);
    }
    return 0;
}

string GetFileForClass(int nClass)
{
    string sFile = Get2DACache("classes", "FeatsTable", nClass);
    sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
//if(DEBUG) DoDebug("GetFileForClass("+IntToString(nClass)+") = "+sFile);
    return sFile;
}

int SpellToSpellbookID(int nSpell, string sFile = "", int nClass = -1)
{
    object oWP = GetObjectByTag("PRC_GetRowFromSpellID");
    int nOutSpellID = GetLocalInt(oWP, "PRC_GetRowFromSpellID_"+IntToString(nSpell));
    if(nOutSpellID == 0)
        nOutSpellID = -1;
if(DEBUG) DoDebug("SpellToSpellbookID("+IntToString(nSpell)+", "+sFile+") = "+IntToString(nOutSpellID));
    return nOutSpellID;

    /*
    int i;
    for(i=0; i<GetPRCSwitch(FILE_END_CLASS_SPELLBOOK); i++)
    {
        if(StringToInt(Get2DACache(sFile, "SpellID", i)) == nSpell)
        {
if(DEBUG) DoDebug("SpellToSpellbookID("+IntToString(nSpell)+", "+sFile+", "+IntToString(nClass)+") = "+IntToString(i));
            return i;
        }
    }
if(DEBUG) DoDebug("SpellToSpellbookID("+IntToString(nSpell)+", "+sFile+", "+IntToString(nClass)+") = "+IntToString(-1));
    return -1;
    */
}

int GetSpellslotLevel(int nClass, object oPC)
{
    //int nLevel = GetCasterLvl(nClass, oPC);
//if(DEBUG) DoDebug("GetSpellslotLevel("+IntToString(nClass)+", "+GetName(oPC)+") = "+IntToString(nLevel));
    int nLevel = GetLevelByClass(nClass, oPC);
    int nArcSpellslotLevel;
    int nDivSpellslotLevel;
    int i;
    for(i=1;i<=3;i++)
    {
        int nTempClass = PRCGetClassByPosition(i, oPC);
        //spellcasting prc
        int nArcSpellMod = StringToInt(Get2DACache("classes", "ArcSpellLvlMod", nTempClass));
        int nDivSpellMod = StringToInt(Get2DACache("classes", "DivSpellLvlMod", nTempClass));
        if(nArcSpellMod == 1)
            nArcSpellslotLevel += GetLevelByClass(nTempClass, oPC);
        else if(nArcSpellMod > 1)
            nArcSpellslotLevel += (GetLevelByClass(nTempClass, oPC)+1)/nArcSpellMod;
        if(nDivSpellMod == 1)
            nDivSpellslotLevel += GetLevelByClass(nTempClass, oPC);
        else if(nDivSpellslotLevel > 1)
            nDivSpellslotLevel += (GetLevelByClass(nTempClass, oPC)+1)/nDivSpellMod;
    }
    if(GetFirstArcaneClass(oPC) == nClass)
        nLevel += nArcSpellslotLevel;
    if(GetFirstDivineClass(oPC) == nClass)
        nLevel += nDivSpellslotLevel;
if(DEBUG) DoDebug("GetSpellslotLevel("+IntToString(nClass)+", "+GetName(oPC)+") = "+IntToString(nLevel));
    return nLevel;
}

int GetItemBonusSlotCount(object oPC, int nClass, int nSpellLevel)
{
    //check cache
    int nCache = GetLocalInt(oPC, "BonusSpellSlots_"+IntToString(nClass)+"_"+IntToString(nSpellLevel));
    //remove offset
    nCache --;
    if(nCache == -1)
    {
        int nBonusCount = 0;
        int nSlot;
        for(nSlot = 0; nSlot <= NUM_INVENTORY_SLOTS; nSlot++)
        {
            object oTest = GetItemInSlot(nSlot, oPC);
            if(GetIsObjectValid(oTest))
            {
                itemproperty ipTest = GetFirstItemProperty(oTest);
                while(GetIsItemPropertyValid(ipTest))
                {
                    int nIPType = GetItemPropertyType(ipTest);
                    int nIPSubType = GetItemPropertySubType(ipTest);
                    int nIPCost = GetItemPropertyCostTableValue(ipTest);
                    if(nIPType == ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N)
                    {
                        SetLocalInt(oPC,
                            "BonusSpellSlots_"+IntToString(nIPSubType)+"_"+IntToString(nIPCost),
                            GetLocalInt(oPC,
                                "BonusSpellSlots_"+IntToString(nIPSubType)+"_"+IntToString(nIPCost))+1);
                        if(nIPSubType == nClass
                            && nIPCost == nSpellLevel)
                        {
                            nBonusCount++;
                            //assume one item can only give 1 slot of any particular class/level combo
                            break;
                        }
                    }
                    ipTest = GetNextItemProperty(oTest);
                }
            }
        }
        return nBonusCount;
    }
    else
        return nCache;
}

int GetSlotCount(int nLevel, int nSpellLevel, int nAbilityScore, int nClass, object oItemPosessor = OBJECT_INVALID)
{
    //check wisdom modifier
    if(nAbilityScore < nSpellLevel+10)
        return 0;
    int nSlots;
    string sFile;
    if(nClass == CLASS_TYPE_WIZARD
        || nClass == CLASS_TYPE_SORCERER
        || nClass == CLASS_TYPE_BARD
        || nClass == CLASS_TYPE_CLERIC
        || nClass == CLASS_TYPE_DRUID
        || nClass == CLASS_TYPE_PALADIN
        || nClass == CLASS_TYPE_RANGER)
    {
        sFile = Get2DACache("classes", "SpellGainTable", nClass);
    }
    else
    {
        sFile = Get2DACache("classes", "FeatsTable", nClass);
        sFile = GetStringLeft(sFile, 4)+"spbk"+GetStringRight(sFile, GetStringLength(sFile)-8);
    }
    string sSlots = Get2DACache(sFile, "SpellLevel"+IntToString(nSpellLevel), nLevel-1);
    if(sSlots == "")
    {
        nSlots = -1;
//if(DEBUG) DoDebug("Problem getting slot numbers for "+IntToString(nSpellLevel)+" "+IntToString(nLevel)+" "+sFile);
    }
    else
        nSlots = StringToInt(sSlots);
    if(nSlots == -1)
        return 0;
    //add item slots
    if(GetIsObjectValid(oItemPosessor))
        nSlots += GetItemBonusSlotCount(oItemPosessor, nClass, nSpellLevel);
    //cantrips dont get bonus slots
    if(nSpellLevel == 0)
        return nSlots;
    //add extra slots
    int nAbilityMod = (nAbilityScore-10)/2;
    nSlots += ((nAbilityMod-nSpellLevel)/4)+1;
    return nSlots;
}

int GetSpellKnownMaxCount(int nLevel, int nSpellLevel, int nClass, object oPC)
{
    int nKnown = 0;
    //no slots = no knowns
    if(!GetSlotCount(nLevel, nSpellLevel, GetAbilityForClass(nClass, oPC), nClass))
        return 0;
    string sFile;
    if(nClass == CLASS_TYPE_WIZARD
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
        sFile = GetStringLeft(sFile, 4)+"spkn"+GetStringRight(sFile, GetStringLength(sFile)-8);
    }
    string sSlots = Get2DACache(sFile, "SpellLevel"+IntToString(nSpellLevel), nLevel-1);
if(DEBUG) DoDebug("GetSpellKnownMaxCount("+IntToString(nLevel)+", "+IntToString(nSpellLevel)+", "+IntToString(nClass)+", "+GetName(oPC)+") = "+sSlots);
    if(sSlots == "")
    {
        nKnown = -1;
//if(DEBUG) DoDebug("Problem getting known numbers for "+IntToString(nSpellLevel)+" "+IntToString(nLevel)+" "+sFile);
    }
    else
        nKnown = StringToInt(sSlots);
    if(nKnown == -1)
        return 0;
    //if its bard or sorc, only return if has a PrC
    if(nClass == CLASS_TYPE_SORCERER
        || nClass == CLASS_TYPE_BARD)
    {
        if(GetLevelByClass(nClass) == nLevel)
            return 0;
    }
    return nKnown;
}

int GetSpellKnownCurrentCount(object oPC, int nSpellLevel, int nClass)
{
    //check short-term cache
    if(GetLocalInt(oPC, "GetSKCCCache_"+IntToString(nSpellLevel)))
        return GetLocalInt(oPC, "GetSKCCCache_"+IntToString(nSpellLevel))-1;
    int i;
    int nKnown;
    int nKnown0, nKnown1, nKnown2, nKnown3, nKnown4;
    int nKnown5, nKnown6, nKnown7, nKnown8, nKnown9;
    string sFile = GetFileForClass(nClass);
    for(i=0;i<persistant_array_get_size(oPC, "Spellbook"+IntToString(nClass));i++)
    {
        int nNewSpellbookID = persistant_array_get_int(oPC, "Spellbook"+IntToString(nClass), i);
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
    switch(nSpellLevel)
    {
        case 0: nKnown = nKnown0; break; case 1: nKnown = nKnown1; break;
        case 2: nKnown = nKnown2; break; case 3: nKnown = nKnown3; break;
        case 4: nKnown = nKnown4; break; case 5: nKnown = nKnown5; break;
        case 6: nKnown = nKnown6; break; case 7: nKnown = nKnown7; break;
        case 8: nKnown = nKnown8; break; case 9: nKnown = nKnown9; break;
    }
if(DEBUG) DoDebug("GetSpellKnownCurrentCount("+GetName(oPC)+", "+IntToString(nSpellLevel)+", "+IntToString(nClass)+") = "+IntToString(nKnown));
    //cache the value for 1 second
    SetLocalInt(oPC, "GetSKCCCache_0", nKnown0+1);
    SetLocalInt(oPC, "GetSKCCCache_1", nKnown1+1);
    SetLocalInt(oPC, "GetSKCCCache_2", nKnown2+1);
    SetLocalInt(oPC, "GetSKCCCache_3", nKnown3+1);
    SetLocalInt(oPC, "GetSKCCCache_4", nKnown4+1);
    SetLocalInt(oPC, "GetSKCCCache_5", nKnown5+1);
    SetLocalInt(oPC, "GetSKCCCache_6", nKnown6+1);
    SetLocalInt(oPC, "GetSKCCCache_7", nKnown7+1);
    SetLocalInt(oPC, "GetSKCCCache_8", nKnown8+1);
    SetLocalInt(oPC, "GetSKCCCache_9", nKnown9+1);
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_0"));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_1"));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_2"));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_3"));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_4"));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_5"));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_6"));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_7"));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_8"));
    DelayCommand(1.0, DeleteLocalInt(oPC, "GetSKCCCache_9"));
    return nKnown;
}

int GetSpellUnknownCurrentCount(object oPC, int nSpellLevel, int nClass)
{
    string sTag = "SpellLvl_"+IntToString(nClass)+"_Level_"+IntToString(nSpellLevel);

    object oCache = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oCache))
    {
if(DEBUG) DoDebug(sTag+" is not valid");
        return 0;
    }
    int nTotal = array_get_size(oCache, sTag);
    int nKnown = GetSpellKnownCurrentCount(oPC, nSpellLevel, nClass);
    int nUnknown = nTotal - nKnown;

if(DEBUG) DoDebug("GetSpellUnknownCurrentCount("+GetName(oPC)+", "+IntToString(nSpellLevel)+", "+IntToString(nClass)+") = "+IntToString(nUnknown));
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
    string sIPFeatID = IntToString(nIPFeatID);
    if(!GetHasFeat(nFeatID, oPC))
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(nIPFeatID), oSkin);
        SetLocalInt(oSkin, "NewSpellbookTemp_"+sIPFeatID, TRUE);
if(DEBUG) DoDebug("SetLocalInt(oSkin, NewSpellbookTemp_"+sIPFeatID+", TRUE);");
    }
    else
    {
        //they already have it but we need to tell the hide cleaner to keep it
if(DEBUG) DoDebug("SetLocalInt(oSkin, NewSpellbookTemp_"+sIPFeatID+", TRUE);");
        SetLocalInt(oSkin, "NewSpellbookTemp_"+sIPFeatID, TRUE);
    }
    //Increase the corrent number of uses
    if(nSpellbookType == SPELLBOOK_TYPE_PREPARED)
    {
        //sanity test
        if(!persistant_array_exists(oPC, sArrayName))
        {
            if(DEBUG) DoDebug("Error: "+sArrayName+" array does not exist");
if(DEBUG) DoDebug(sArrayName+" does not exist, creating.");
            persistant_array_create(oPC, sArrayName);
        }
        int nUses = persistant_array_get_int(oPC, sArrayName, nSpellbookID);
        nUses++;
        persistant_array_set_int(oPC, sArrayName, nSpellbookID,nUses);
if(DEBUG) DoDebug(sArrayName+"="+IntToString(persistant_array_get_int(oPC, sArrayName, nSpellbookID)));
    }
    else if(nSpellbookType == SPELLBOOK_TYPE_SPONTANEOUS)
    {
if(DEBUG) DoDebug("Spontaneous class calling AddSpellUse()");
    }
}

void RemoveSpellUse(object oPC, int nSpellID, int nClass)
{
    string sFile = GetFileForClass(nClass);
    int nSpellbookID = SpellToSpellbookID(nSpellID, sFile);
    if(nSpellbookID == -1)
    {
        if(DEBUG) DoDebug("Unable to resolve spell to spellbookID: "+IntToString(nSpellID)+" "+sFile);
        return;
    }
    if(!persistant_array_exists(oPC, "NewSpellbookMem_"+IntToString(nClass)))
    {
if(DEBUG) DoDebug("NewSpellbookMem_"+IntToString(nClass)+" does not exist, creating.");
        persistant_array_create(oPC, "NewSpellbookMem_"+IntToString(nClass));
    }
    int nSpellbookType = GetSpellbookTypeForClass(nClass);
    //get uses remaining
    if(nSpellbookType == SPELLBOOK_TYPE_PREPARED)
    {
        int nCount = persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID);
        //reduce by 1
        if(nCount > 0)
            persistant_array_set_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID, nCount-1);
    }
    else if(nSpellbookType == SPELLBOOK_TYPE_SPONTANEOUS)
    {
        int nSpellLevel = StringToInt(Get2DACache(sFile, "Level", nSpellbookID));
        int nCount = persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellLevel);
        //reduce by 1
        if(nCount > 0)
            persistant_array_set_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellLevel, nCount-1);
    }
}

int GetSpellUses(object oPC, int nSpellID, int nClass)
{
    string sFile = GetFileForClass(nClass);
    int nSpellbookID = SpellToSpellbookID(nSpellID, sFile);
    if(nSpellbookID == -1)
    {
        if(DEBUG) DoDebug("Unable to resolve spell to spellbookID: "+IntToString(nSpellID)+" "+sFile);
        return 0;
    }

    // check if this spell actually belong to this class
    if (nSpellID != StringToInt(Get2DACache(sFile, "SpellID", nSpellbookID)))
        return 0;

    // check for the metamagic feat
    string sReqFeat = Get2DACache(sFile, "ReqFeat", nSpellbookID);
    if (sReqFeat != "" && !GetHasFeat(StringToInt(sReqFeat), oPC))
        return 0;
    
    if(!persistant_array_exists(oPC, "NewSpellbookMem_"+IntToString(nClass)))
    {
if(DEBUG) DoDebug("NewSpellbookMem_"+IntToString(nClass)+" does not exist, creating.");
        persistant_array_create(oPC, "NewSpellbookMem_"+IntToString(nClass));
    }
    int nSpellbookType = GetSpellbookTypeForClass(nClass);
    //get uses remaining
    int nCount;

    if(nSpellbookType == SPELLBOOK_TYPE_PREPARED)
    {
        nCount = persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID);
    }
    else if(nSpellbookType == SPELLBOOK_TYPE_SPONTANEOUS)
    {
        int iSize = persistant_array_get_size(oPC, "Spellbook"+IntToString(nClass));
        int i = 0;
        int bHas = FALSE;
        while (i < iSize && !bHas)
        {
            if (nSpellbookID == persistant_array_get_int(oPC, "Spellbook"+IntToString(nClass), i))
                bHas = TRUE;
            i++;
        }
        if (!bHas)
            return 0;
        int nSpellLevel = StringToInt(Get2DACache(sFile, "Level", nSpellbookID));
        nCount = persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellLevel);
    }
    return nCount;
}

int GetSpellLevel(object oPC, int nSpellID, int nClass)
{
    string sFile = GetFileForClass(nClass);
    int nSpellbookID = SpellToSpellbookID(nSpellID, sFile);
    if(nSpellbookID == -1)
    {
        if(DEBUG) DoDebug("Unable to resolve spell to spellbookID: "+IntToString(nSpellID)+" "+sFile);
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
    string sArrayName = "NewSpellbookMem_"+sClass;
    object oSkin = GetPCSkin(oPC);
    int nLevel = GetCasterLvl(nClass, oPC);
    int nAbility = GetAbilityForClass(nClass, oPC);
    int nSpellbookType = GetSpellbookTypeForClass(nClass);
    if(nSpellbookType == SPELLBOOK_TYPE_SPONTANEOUS)
    {
        int nSpellLevel, nSlots;
        for(nSpellLevel = 0; nSpellLevel <=9; nSpellLevel++)
        {
            nSlots = GetSlotCount(nLevel, nSpellLevel, nAbility, nClass, oPC);
            persistant_array_set_int(oPC, "NewSpellbookMem_"+sClass, nSpellLevel, nSlots);
        }
        int i, j;
        int nSpellbookID, nRealSpellID, nTestRealSpellID, nMetaFeat;
        for(i=0;i<persistant_array_get_size(oPC, "Spellbook"+sClass);i++)
        {
            nSpellbookID = persistant_array_get_int(oPC, "Spellbook"+sClass, i);
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
    }
    else if(nSpellbookType == SPELLBOOK_TYPE_PREPARED)
    {
        int nSpellLevel, nSlot, nSlots, nSpellbookID;
        string sArrayName2;
        for(nSpellLevel = 0; nSpellLevel <=9; nSpellLevel++)
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
    if(!GetLocalInt(oHide, "NewSpellbookTemp_"+IntToString(nSubType)))
    {
        RemoveItemProperty(oHide, ipFeat);
        DeleteLocalInt(oHide, "NewSpellbookTemp_"+IntToString(nSubType));
if(DEBUG) DoDebug("DeleteLocalInt(oHide, NewSpellbookTemp_"+IntToString(nSubType)+");");
if(DEBUG) DoDebug("Removing item property");
    }
    else
    {
        DeleteLocalInt(oHide, "NewSpellbookTemp_"+IntToString(nSubType));
if(DEBUG) DoDebug("DeleteLocalInt(oHide, NewSpellbookTemp_"+IntToString(nSubType)+");");
    }
}

void WipeSpellbookHideFeats(object oPC)
{
    object oHide = GetPCSkin(oPC);
    itemproperty ipTest = GetFirstItemProperty(oHide);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT
            && GetItemPropertySubType(ipTest) > SPELLBOOK_IPRP_FEATS_START
            && GetItemPropertySubType(ipTest) < SPELLBOOK_IPRP_FEATS_END)
            DelayCommand(0.5, CheckAndRemoveFeat(oHide, ipTest));
        ipTest = GetNextItemProperty(oHide);
    }
}

void CheckNewSpellbooks(object oPC)
{
    WipeSpellbookHideFeats(oPC);
    int i;
    for(i=1;i<=3;i++)
    {
        int nClass = PRCGetClassByPosition(i, oPC);
        int nLevel = GetLevelByClass(nClass, oPC);

if(DEBUG) DoDebug("CheckNewSpellbooks");
if(DEBUG) DoDebug("nClass="+IntToString(nClass));
if(DEBUG) DoDebug("nLevel="+IntToString(nLevel));
        //if bard/sorc newspellbook is disabled after selecting
        //remove those from radial
        if((GetPRCSwitch(PRC_BARD_DISALLOW_NEWSPELLBOOK)
                && nClass == CLASS_TYPE_BARD)
            ||(GetPRCSwitch(PRC_SORC_DISALLOW_NEWSPELLBOOK)
                && nClass == CLASS_TYPE_SORCERER))
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

    int nSpellbookID = SpellToSpellbookID(nMasterFakeSpellID, sFile);

    if(!persistant_array_exists(oPC, "NewSpellbookMem_"+IntToString(nClass)))
    {
if(DEBUG) DoDebug("Error: NewSpellbookMem_"+IntToString(nClass)+" array does not exist");
        persistant_array_create(oPC,  "NewSpellbookMem_"+IntToString(nClass));
    }
    //check if all cast
    int nSpellbookType = GetSpellbookTypeForClass(nClass);
    int nSpellLevel = StringToInt(Get2DACache(sFile, "Level", nSpellbookID));
    if(nSpellbookType == SPELLBOOK_TYPE_PREPARED)
    {
        int nCount = persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID);
if(DEBUG) DoDebug("NewSpellbookMem_"+IntToString(nClass)+"["+IntToString(nSpellbookID)+"] = "+IntToString(nCount));
        if(nCount < 1)
        {
            string sSpellName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
            string sMessage = "You have no castings of "+sSpellName+" remaining";
            SendMessageToPC(oPC, sMessage);
            return;
        }
        else
        {
            string sSpellName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
            string sMessage = "You have "+IntToString(nCount-1)+" castings of "+sSpellName+" remaining";
            SendMessageToPC(oPC, sMessage);
        }
    }
    else  if(nSpellbookType == SPELLBOOK_TYPE_SPONTANEOUS)
    {
        int nCount = persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellLevel);
if(DEBUG) DoDebug("NewSpellbookMem_"+IntToString(nClass)+"["+IntToString(nSpellbookID)+"] = "+IntToString(nCount));
        if(nCount < 1)
        {
            string sSpellName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
            string sMessage = "You have no castings of spells of level "+IntToString(nSpellLevel)+" remaining";
            SendMessageToPC(oPC, sMessage);
            return;
        }
        else
        {
            string sSpellName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
            string sMessage = "You have "+IntToString(nCount-1)+" castings of spells of level "+IntToString(nSpellLevel)+" remaining";
            SendMessageToPC(oPC, sMessage);
        }
    }
    //remove it from the spellbook
    RemoveSpellUse(oPC, nMasterFakeSpellID, nClass);
    //test for ASF
    if(GetIsArcaneClass(nClass)
        && Random(100) < GetArcaneSpellFailure(oPC)
        && FindSubString(GetStringLowerCase(Get2DACache("spells", "VS", nSpellID)),"s") != -1)
        //52946 = Spell failed due to arcane spell failure!
    {
        int nFail = TRUE;
        //auto-still exceptions
        if(nMetamagic == METAMAGIC_STILL
            ||(GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_1, oPC)
                && nSpellLevel <= 3)
            ||(GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_2, oPC)
                && nSpellLevel <= 6)
            ||(GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_3, oPC)
                && nSpellLevel <= 9))
            nFail = FALSE;
        if(nFail)
        {
            SendMessageToPCByStrRef(oPC, 52946);
            return;
        }
    }
    //test for deaf/silenced
    if(FindSubString(GetStringLowerCase(Get2DACache("spells", "VS", nSpellID)),"v") != -1
        && (GetHasEffect(EFFECT_TYPE_SILENCE, oPC)
            || (GetHasEffect(EFFECT_TYPE_DEAF, oPC) && Random(100) < 20)))
        //3734 = Spell failed!
    {
        int nFail = TRUE;
        //auto-still exceptions
        if(nMetamagic == METAMAGIC_SILENT
            || (GetHasFeat(FEAT_EPIC_AUTOMATIC_SILENT_SPELL_1, oPC)
                && nSpellLevel <= 3)
            ||(GetHasFeat(FEAT_EPIC_AUTOMATIC_SILENT_SPELL_2, oPC)
                && nSpellLevel <= 6)
            ||(GetHasFeat(FEAT_EPIC_AUTOMATIC_SILENT_SPELL_3, oPC)
                && nSpellLevel <= 9))
            nFail = FALSE;
        if(nFail)
        {
            SendMessageToPCByStrRef(oPC, 3734);
            return;
        }
    }
    //uses GetSpellId to get the fake spellID not the real one
    //this is only the BASE DC, feats etc are added on top of this
    int nDC = 10;
    nDC += StringToInt(Get2DACache("Spells", "Innate", nFakeSpellID));
    if(nClass == CLASS_TYPE_FAVOURED_SOUL)
        nDC += (GetAbilityModifier(ABILITY_WISDOM, oPC));
    else
        nDC += ((GetAbilityForClass(nClass, oPC)-10)/2);

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