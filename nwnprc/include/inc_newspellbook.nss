#include "x2_inc_itemprop"
#include "inc_utility"
#include "prc_inc_spells"
//#include "prc_inc_clsfunc"

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

Spont:
Make cls_spbk_*.2da
Make cls_spkn_*.2da
Make cls_spcr_*.2da
Add class to GetSpellbookTypeForClass() below
Add class to GetAbilityForClass() below
Add class to GetIsArcaneClass() or GetIsDivineClass() in prc_inc_spells as appropriate
Add class to GetCasterLvl() in prc_inc_spells
Add class to MakeLookupLoopMaster() in inc_lookups
Add class to prc_spellgain
Add class to ExecuteScript("prc_spellgain", oPC) list in EvalPRCFeats in prc_inc_function
Run the assemble_spellbooks.bat file

*/

const int SPELLBOOK_IPRP_FEATS_START = 10400;
const int SPELLBOOK_IPRP_FEATS_END = 11999;
const int SPELLBOOK_TYPE_PREPARED = 1;
const int SPELLBOOK_TYPE_SPONTANEOUS = 2;
const int SPELLBOOK_TYPE_INVALID = 0;

void NewSpellbookSpell(int nClass, int nMetamagic, int nSpellID);
int SpellToSpellbookID(int nSpell, string sFile = "", int nClass = -1);
string GetFileForClass(int nClass);


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
            return SPELLBOOK_TYPE_PREPARED;
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_BARD:
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
            return GetAbilityScore(oPC, ABILITY_WISDOM);
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_PSION:
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_SHADOWLORD:
            return GetAbilityScore(oPC, ABILITY_INTELLIGENCE);
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_WILDER:
            return GetAbilityScore(oPC, ABILITY_CHARISMA);
    }
    return 0;
}

string GetFileForClass(int nClass)
{
    string sFile = Get2DACache("classes", "FeatsTable", nClass);
    sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
//DoDebug("GetFileForClass("+IntToString(nClass)+") = "+sFile);
    return sFile;
}

int SpellToSpellbookID(int nSpell, string sFile = "", int nClass = -1)
{
    object oWP = GetObjectByTag("PRC_GetRowFromSpellID");
    int nOutSpellID = GetLocalInt(oWP, "PRC_GetRowFromSpellID_"+IntToString(nSpell));
    if(nOutSpellID == 0)
        nOutSpellID = -1;
DoDebug("SpellToSpellbookID("+IntToString(nSpell)+", "+sFile+") = "+IntToString(nOutSpellID));    
    return nOutSpellID;
    
    /*
    int i;
    for(i=0; i<GetPRCSwitch(FILE_END_CLASS_SPELLBOOK); i++)
    {
        if(StringToInt(Get2DACache(sFile, "SpellID", i)) == nSpell)
        {
DoDebug("SpellToSpellbookID("+IntToString(nSpell)+", "+sFile+", "+IntToString(nClass)+") = "+IntToString(i));
            return i;
        }
    }
DoDebug("SpellToSpellbookID("+IntToString(nSpell)+", "+sFile+", "+IntToString(nClass)+") = "+IntToString(-1));
    return -1;
    */
}

int GetSpellslotLevel(int nClass, object oPC)
{
    int nLevel = GetLevelByClass(nClass, oPC);
    int nArcSpellslotLevel;
    int nDivSpellslotLevel;
    int i;
    for(i=1;i<=3;i++)
    {
        int nTempClass = PRCGetClassByPosition(i, oPC);
        /*1.67 code
        int nTempClass = GetClassByPosition(i, oPC);
        */
        //spellcasting prc
        int nArcSpellMod = StringToInt(Get2DACache("classes", "ArcSpellLvlMod", nTempClass));
        int nDivSpellMod = StringToInt(Get2DACache("classes", "DivSpellLvlMod", nTempClass));
        //cos of the biobug, this is +1 before dividing
        //yeah its screwy, go bitch at bioware ;)
        if(nArcSpellMod)
            nArcSpellslotLevel += (GetLevelByClass(nTempClass, oPC)+1)/nArcSpellMod;
        if(nDivSpellMod)
            nDivSpellslotLevel += (GetLevelByClass(nTempClass, oPC)+1)/nDivSpellMod;
        /*1.67 code
        if(nArcSpellMod)
            if(nArcSpellMod == 1)
                nArcSpellslotLevel += (GetLevelByClass(nTempClass, oPC))/nArcSpellMod;
            else    
                nArcSpellslotLevel += (GetLevelByClass(nTempClass, oPC)+1)/nArcSpellMod;
        if(nDivSpellMod)
            if(nDivSpellMod == 1)
                nDivSpellslotLevel += (GetLevelByClass(nTempClass, oPC))/nDivSpellMod;
            else    
                nDivSpellslotLevel += (GetLevelByClass(nTempClass, oPC)+1)/nDivSpellMod;
        */
    }
    if(GetFirstArcaneClass(oPC) == nClass)
        nLevel += nArcSpellslotLevel;
    if(GetFirstDivineClass(oPC) == nClass)
        nLevel += nDivSpellslotLevel;
DoDebug("GetSpellslotLevel("+IntToString(nClass)+", "+GetName(oPC)+") = "+IntToString(nLevel));
    return nLevel;
}

int GetSlotCount(int nLevel, int nSpellLevel, int nAbilityScore, int nClass)
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
//DoDebug("Problem getting slot numbers for "+IntToString(nSpellLevel)+" "+IntToString(nLevel)+" "+sFile);
    }
    else
        nSlots = StringToInt(sSlots);
    if(nSlots == -1)
        return 0;
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
DoDebug("GetSpellKnownMaxCount("+IntToString(nLevel)+", "+IntToString(nSpellLevel)+", "+IntToString(nClass)+", "+GetName(oPC)+") = "+sSlots);
    if(sSlots == "")
    {
        nKnown = -1;
//DoDebug("Problem getting known numbers for "+IntToString(nSpellLevel)+" "+IntToString(nLevel)+" "+sFile);
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
DoDebug("GetSpellKnownCurrentCount("+GetName(oPC)+", "+IntToString(nSpellLevel)+", "+IntToString(nClass)+") = "+IntToString(nKnown));
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
DoDebug(sTag+" is not valid");
        return 0;
    }    
    int nTotal = array_get_size(oCache, sTag);    
    int nKnown = GetSpellKnownCurrentCount(oPC, nSpellLevel, nClass);
    int nUnknown = nTotal - nKnown;
    
DoDebug("GetSpellUnknownCurrentCount("+GetName(oPC)+", "+IntToString(nSpellLevel)+", "+IntToString(nClass)+") = "+IntToString(nUnknown));
    return nUnknown;    
}

void AddSpellUse(object oPC, int nSpellbookID, int nClass)
{
    string sFile = GetFileForClass(nClass);
    string sArrayName = "NewSpellbookMem_"+IntToString(nClass);
    int nSpellbookType = GetSpellbookTypeForClass(nClass);
    object oSkin = GetPCSkin(oPC);
    int nFeatID = StringToInt(Get2DACache(sFile, "FeatID", nSpellbookID));
    //add the feat only if they dont already have it
    int nIPFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID));
    if(!GetHasFeat(nFeatID, oPC))
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(nIPFeatID), oSkin);
        SetLocalInt(oSkin, "NewSpellbookTemp_"+IntToString(nIPFeatID), TRUE);
DoDebug("SetLocalInt(oSkin, NewSpellbookTemp_"+IntToString(nIPFeatID)+", TRUE);");
    }
    else
    {
        //they already have it but we need to tell the hide cleaner to keep it
DoDebug("SetLocalInt(oSkin, NewSpellbookTemp_"+IntToString(nIPFeatID)+", TRUE);");
        SetLocalInt(oSkin, "NewSpellbookTemp_"+IntToString(nIPFeatID), TRUE);
    }
    //Increase the corrent number of uses
    if(nSpellbookType == SPELLBOOK_TYPE_PREPARED)
    {
        //sanity test
        if(!persistant_array_exists(oPC, sArrayName))
        {
            DoDebug("Error: "+sArrayName+" array does not exist");
DoDebug(sArrayName+" does not exist, creating.");
            persistant_array_create(oPC, sArrayName);
        }
        int nUses = persistant_array_get_int(oPC, sArrayName, nSpellbookID);
        nUses++;
        persistant_array_set_int(oPC, sArrayName, nSpellbookID,nUses);
DoDebug(sArrayName+"="+IntToString(persistant_array_get_int(oPC, sArrayName, nSpellbookID)));
    }
    else if(nSpellbookType == SPELLBOOK_TYPE_SPONTANEOUS)
    {
DoDebug("Spontaneous class calling AddSpellUse()");
    }
}

void RemoveSpellUse(object oPC, int nSpellID, int nClass)
{
    string sFile = GetFileForClass(nClass);
    int nSpellbookID = SpellToSpellbookID(nSpellID, sFile);
    if(nSpellbookID == -1)
    {
        DoDebug("Unable to resolve spell to spellbookID: "+IntToString(nSpellID)+" "+sFile);
        return;
    }
    if(!persistant_array_exists(oPC, "NewSpellbookMem_"+IntToString(nClass)))
    {
DoDebug("NewSpellbookMem_"+IntToString(nClass)+" does not exist, creating.");
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

void SetupSpells(object oPC, int nClass)
{
    int nLevel = GetLevelByClass(nClass, oPC);
    int nAbility = GetAbilityForClass(nClass, oPC);
    int nSpellbookType = GetSpellbookTypeForClass(nClass);
    if(nSpellbookType == SPELLBOOK_TYPE_SPONTANEOUS)
    {
        int nSpellLevel;
        for(nSpellLevel = 0; nSpellLevel <=9; nSpellLevel++)
        {
            int nSlots = GetSlotCount(nLevel, nSpellLevel, nAbility, nClass);
            persistant_array_set_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellLevel, nSlots);
        }
        int i;
        for(i=0;i<persistant_array_get_size(oPC, "Spellbook"+IntToString(nClass));i++)
        {
            int nSpellbookID = persistant_array_get_int(oPC, "Spellbook"+IntToString(nClass), i);
            AddSpellUse(oPC, nSpellbookID, nClass);
        }    
    }
    else if(nSpellbookType == SPELLBOOK_TYPE_PREPARED)
    {
        int nSpellLevel;
        for(nSpellLevel = 0; nSpellLevel <=9; nSpellLevel++)
        {
            int nSlots = GetSlotCount(nLevel, nSpellLevel, nAbility, nClass);
            int nSlot;
            for(nSlot = 0; nSlot < nSlots; nSlot++)
            {
                //done when spells are added to it
                //doesnt do any harm to make it twice
                persistant_array_create(oPC, "Spellbook"+IntToString(nSpellLevel)+"_"+IntToString(nClass));
                int nSpellbookID = persistant_array_get_int(oPC, "Spellbook"+IntToString(nSpellLevel)+"_"+IntToString(nClass), nSlot);
                if(nSpellbookID != 0)
                {
                    AddSpellUse(oPC, nSpellbookID, nClass);
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
DoDebug("DeleteLocalInt(oHide, NewSpellbookTemp_"+IntToString(nSubType)+");");
DoDebug("Removing item property");
    }    
    else
    {
        DeleteLocalInt(oHide, "NewSpellbookTemp_"+IntToString(nSubType));
DoDebug("DeleteLocalInt(oHide, NewSpellbookTemp_"+IntToString(nSubType)+");");
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
        /*1.67 code
        int nClass = GetClassByPosition(i, oPC);
        */
        int nLevel = GetLevelByClass(nClass, oPC);
DoDebug("CheckNewSpellbooks");
DoDebug("nClass="+IntToString(nClass));
DoDebug("nLevel="+IntToString(nLevel));
        if(nLevel)
        {
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
    int nSpellbookID = SpellToSpellbookID(PRCGetSpellId(), sFile);
    if(!persistant_array_exists(oPC, "NewSpellbookMem_"+IntToString(nClass)))
    {
DoDebug("Error: NewSpellbookMem_"+IntToString(nClass)+" array does not exist");
        persistant_array_create(oPC,  "NewSpellbookMem_"+IntToString(nClass));
    }
    //check if all cast
    int nSpellbookType = GetSpellbookTypeForClass(nClass);
    if(nSpellbookType == SPELLBOOK_TYPE_PREPARED)
    {
        int nCount = persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID);
DoDebug("NewSpellbookMem_"+IntToString(nClass)+"["+IntToString(nSpellbookID)+"] = "+IntToString(nCount));
        if(nCount-1 < 1)
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
        int nSpellLevel = StringToInt(Get2DACache(sFile, "Level", nSpellbookID));
        int nCount = persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellLevel);
DoDebug("NewSpellbookMem_"+IntToString(nClass)+"["+IntToString(nSpellbookID)+"] = "+IntToString(nCount));
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
    //uses GetSpellId to get the fake spellID not the real one
    //this is only the BASE DC, feats etc are added on top of this
    int nDC = 10
        +StringToInt(Get2DACache("Spells", "Innate", PRCGetSpellId()))
        +((GetAbilityForClass(nClass, oPC)-10)/2);
    //cast the spell
    //dont need to override level, the spellscript will calculate it
    ActionCastSpell(nSpellID, 0, nDC, 0, nMetamagic, nClass);
    //remove it from the spellbook
    RemoveSpellUse(oPC, PRCGetSpellId(), nClass);
}