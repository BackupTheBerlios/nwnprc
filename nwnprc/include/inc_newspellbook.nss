#include "x2_inc_itemprop"
#include "inc_utility"
#include "inc_item_props"

int GetAbilityForClass(int nClass, object oPC)
{
    object oHide = GetPCSkin(oPC);
    switch(nClass)
    {
        case CLASS_TYPE_BLACKGUARD:
            return GetLocalInt(oHide, "PRC_trueWIS");
        case CLASS_TYPE_ASSASSIN:
            return GetLocalInt(oHide, "PRC_trueINT");
    }
    return 0;
}

int GetNewSpellbookCasterLevel(int nClass, object oCaster = OBJECT_SELF)
{
    int nLevel = GetLevelByClass(nClass, oCaster);
    return nLevel;
}

void WipeSpellbookHideFeats(object oPC)
{
    object oHide = GetPCSkin(oPC);
    itemproperty ipTest = GetFirstItemProperty(oHide);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT
            && GetItemPropertySubType(ipTest) > 100
            && GetItemPropertySubType(ipTest) < 200)
            RemoveItemProperty(oHide, ipTest);
        ipTest = GetNextItemProperty(oHide);
    }
}

int GetSlotCount(int nLevel, int nSpellLevel, int nAbilityScore, int nClass)
{
    //check wisdom modifier
    if(nAbilityScore < nSpellLevel+10)
        return 0;
    int nSlots;
    string sFile = Get2DACache("classes", "FeatsTable", nClass);
    sFile = GetStringLeft(sFile, 4)+"spbk"+GetStringRight(sFile, GetStringLength(sFile)-8);
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
    string sFile = Get2DACache("classes", "FeatsTable", nClass);
    sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
    int nIPFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID));
    object oSkin = GetPCSkin(oPC);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(nIPFeatID), oSkin);
}

void RemoveSpellUse(object oPC, int nSpellID, int nClass)
{
    string sFile = Get2DACache("classes", "FeatsTable", nClass);
    sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
    int nSpellbookID;
    int i;
    for(i=1; i<150; i++)
    {
        if(StringToInt(Get2DACache(sFile, "SpellID", i)) == nSpellID)
        {
            nSpellbookID = i;
            break;
        }
    }
    if(nSpellbookID != i)
        return;
    int nIPFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID));
    object oSkin = GetPCSkin(oPC);
    itemproperty ipTest = GetFirstItemProperty(oSkin);
    int nCount;
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT
            && GetItemPropertySubType(ipTest) == nIPFeatID)
        {
            RemoveItemProperty(oSkin, ipTest);
            nCount++;
        }
        ipTest = GetNextItemProperty(oSkin);
    }
    //have to remove all and then replace them
    //otherwise the gui doesnt recognise the feats till the item is reequiped
    //this would wipe bonus spells from int bonuses (and others)
    nCount--;
    for(i=0;i<nCount;i++)
    {
        DelayCommand(0.01, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(nIPFeatID), oSkin));
    }
}

void SetupSpells(object oPC, int nClass)
{
    WipeSpellbookHideFeats(oPC);
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
    int i;
    for(i=12;i<=255;i++)
    {
        if(GetLevelByClass(i, oPC))
        {
            DelayCommand(0.01, SetupSpells(oPC, i));
        }
    }
}

int GetNewSpellMetamagic()
{
    int nSpellID = GetSpellId();
    int nMetamagic = nSpellID % 10;
    switch(nMetamagic)
    {
        case 1://quicken
            nMetamagic = METAMAGIC_QUICKEN;
            break;
        case 2://empower
            nMetamagic = METAMAGIC_EMPOWER;
            break;
        case 3://extend
            nMetamagic = METAMAGIC_EXTEND;
            break;
        case 4://maximise
            nMetamagic = METAMAGIC_MAXIMIZE;
            break;
        case 5://silent
            nMetamagic = METAMAGIC_SILENT;
            break;
        case 6://still
            nMetamagic = METAMAGIC_STILL;
            break;
        case 7://none
            nMetamagic = 0;
            break;
        case 8://none
            nMetamagic = 0;
            break;
        case 9://none
            nMetamagic = 0;
            break;
    }
    return nMetamagic;
}
