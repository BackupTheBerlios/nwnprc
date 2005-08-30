#include "x2_inc_itemprop"
#include "inc_utility"
#include "inc_item_props"
#include "prc_inc_spells"
#include "prc_inc_clsfunc"

const int SPELLBOOK_ROW_COUNT = 410;
const int SPELLBOOK_IPRP_FEATS_START = 10400;
const int SPELLBOOK_IPRP_FEATS_END = 11196;

void NewSpellbookSpell(int nClass, int nMetamagic, int nSpellID);
int SpellToSpellbookID(int nSpell, string sFile = "", int nClass = -1);
string GetFileForClass(int nClass);


string GetFileForClass(int nClass)
{
    string sFile = Get2DACache("classes", "FeatsTable", nClass);
    sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
    return sFile;
}

int SpellToSpellbookID(int nSpell, string sFile = "", int nClass = -1)
{
    if(sFile == "" && nClass != -1)
        sFile = GetFileForClass(nClass);
        
    int i;
    for(i=1; i<SPELLBOOK_ROW_COUNT; i++)
    {
//SendMessageToPC(GetFirstPC(),
//    sFile+" SpellID "+IntToString(i)+" = "+Get2DACache(sFile, "SpellID", i));
        if(StringToInt(Get2DACache(sFile, "SpellID", i)) == nSpell)
        {
            return i;
        }
    }
    return -1;
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
        //spellcasting prc
        int nArcSpellMod = StringToInt(Get2DACache("classes", "ArcSpellLvlMod", nTempClass));
        int nDivSpellMod = StringToInt(Get2DACache("classes", "DivSpellLvlMod", nTempClass));
        //cos of the biobug, this is +1 before dividing
        //yeah its screwy, go bitch at bioware ;)
        if(nArcSpellMod)
            nArcSpellslotLevel += (GetLevelByClass(nTempClass, oPC)+1)/nArcSpellMod;
        if(nDivSpellMod)
            nDivSpellslotLevel += (GetLevelByClass(nTempClass, oPC)+1)/nDivSpellMod;        
    }
    if(GetFirstArcaneClass(oPC) == nClass)
        nLevel += nArcSpellslotLevel;
    if(GetFirstDivineClass(oPC) == nClass)
        nLevel += nDivSpellslotLevel;
    return nLevel;
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
            return GetAbilityScore(oPC, ABILITY_WISDOM);
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_PSION:
            return GetAbilityScore(oPC, ABILITY_INTELLIGENCE);
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_WILDER:
            return GetAbilityScore(oPC, ABILITY_CHARISMA);
    }
    return 0;
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
            DelayCommand(1.0, RemoveItemProperty(oHide, ipTest));
        ipTest = GetNextItemProperty(oHide);
    }
    //remove persistant locals used to track when all spells cast
    persistant_array_delete(oPC, "NewSpellbookMem_"+IntToString(PRCGetClassByPosition(1, oPC)));    
    persistant_array_delete(oPC, "NewSpellbookMem_"+IntToString(PRCGetClassByPosition(2, oPC)));    
    persistant_array_delete(oPC, "NewSpellbookMem_"+IntToString(PRCGetClassByPosition(3, oPC)));        
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
    string sSlots = Get2DACache(sFile, "SpellLevel"+IntToString(nSpellLevel), nLevel);
    if(sSlots == "")
        nSlots = -1;
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

void AddSpellUse(object oPC, int nSpellbookID, int nClass)
{
    string sFile = GetFileForClass(nClass);
    object oSkin = GetPCSkin(oPC);
    int nFeatID = StringToInt(Get2DACache(sFile, "FeatID", nSpellbookID));
    if(!GetHasFeat(nFeatID, oPC))
    {
        int nIPFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID));
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(nIPFeatID), oSkin);
    }    
    persistant_array_create(oPC,  "NewSpellbookMem_"+IntToString(nClass));
    persistant_array_set_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID,
        persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID)+1); 
//SendMessageToPC(oPC, "NewSpellbookMem_"+IntToString(nClass)+" "+IntToString(nSpellbookID)+" = "+IntToString(persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID)));        
}

void RemoveSpellUse(object oPC, int nSpellID, int nClass)
{
    string sFile = GetFileForClass(nClass);
    int nSpellbookID = SpellToSpellbookID(nSpellID, sFile);
    if(nSpellbookID == -1)
        return;
//SendMessageToPC(oPC, "NewSpellbookMem_"+IntToString(nClass)+" "+IntToString(nSpellbookID)+" = "+IntToString(persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID)));        
    //get uses remaining    
    persistant_array_create(oPC, "NewSpellbookMem_"+IntToString(nClass));
    int nCount = persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID); 
    //reduce by 1
    if(nCount > 0)
        persistant_array_set_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID, nCount-1);
        
    nCount--;    
    string sSpellName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
    string sMessage = "You have "+IntToString(nCount)+" castings of "+sSpellName+" left.";
    SendMessageToPC(oPC, sMessage);    
}

void SetupSpells(object oPC, int nClass)
{
    int nLevel = GetLevelByClass(nClass, oPC);
    int nAbility = GetAbilityForClass(nClass, oPC);
    int nSpellLevel;
    for(nSpellLevel = 1; nSpellLevel <=9; nSpellLevel++)
    {
        int nSlots = GetSlotCount(nLevel, nSpellLevel, nAbility, nClass);
        int nSlot;
        for(nSlot = 0; nSlot < nSlots; nSlot++)
        {
            //done when spells are added to it
            //persistant_array_create(oPC, "Spellbook"+IntToString(nSpellLevel)+"_"+IntToString(nClass));
            int nSpellbookID = persistant_array_get_int(oPC, "Spellbook"+IntToString(nSpellLevel)+"_"+IntToString(nClass), nSlot);
            if(nSpellbookID != 0)
            {
                AddSpellUse(oPC, nSpellbookID, nClass);
            }
        }
    }
}

void CheckNewSpellbooks(object oPC)
{
    WipeSpellbookHideFeats(oPC);
    SetupSpells(oPC, PRCGetClassByPosition(1, oPC));
    SetupSpells(oPC, PRCGetClassByPosition(2, oPC));
    SetupSpells(oPC, PRCGetClassByPosition(3, oPC));
}

void NewSpellbookSpell(int nClass, int nMetamagic, int nSpellID)
{
    object oPC = OBJECT_SELF;
    //get the spellbook ID
    int nSpellbookID = SpellToSpellbookID(PRCGetSpellId(), GetFileForClass(nClass));
    //check if all cast  
//SendMessageToPC(oPC, "NewSpellbookMem_"+IntToString(nClass)+" "+IntToString(nSpellbookID)+" = "+IntToString(persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID)));            
    int nCount = persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nClass), nSpellbookID);     
    if(!nCount)
    {
        string sSpellName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
        string sMessage = "You have no castings of "+sSpellName+" remaining";
        SendMessageToPC(oPC, sMessage);
        return;
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