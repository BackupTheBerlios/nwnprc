#include "x2_inc_itemprop"
#include "inc_utility"
#include "inc_item_props"
#include "prc_inc_spells"
#include "prc_inc_clsfunc"

void NewSpellbookSpell(int nClass, int nMetamagic, int nSpellID);

int GetAbilityForClass(int nClass, object oPC)
{
    switch(nClass)
    {
        case CLASS_TYPE_BLACKGUARD:
        case CLASS_TYPE_VASSAL:
        case CLASS_TYPE_SOLDIER_OF_LIGHT:
        case CLASS_TYPE_KNIGHT_MIDDLECIRCLE:
            return GetAbilityScore(oPC, ABILITY_WISDOM);
        case CLASS_TYPE_ASSASSIN:
            return GetAbilityScore(oPC, ABILITY_INTELLIGENCE);
    }
    return 0;
}

int GetNewSpellbookCasterLevel(int nClass, object oCaster = OBJECT_SELF)
{
    int nLevel = GetLevelByClass(nClass, oCaster);
    if(GetIsDivineClass(nClass))
    { 
        if (GetFirstDivineClass(oCaster) == nClass) 
            nLevel += GetDivinePRCLevels(oCaster);
        nLevel += TrueNecromancy(oCaster, GetSpellId(), "DIVINE") 
                  +  ShadowWeave(oCaster, GetSpellId()) 
                  +  FireAdept(oCaster, GetSpellId());
                  
        nLevel += PractisedSpellcasting(oCaster, nClass, nLevel); //gotta be the last one
    }
    if(GetIsArcaneClass(nClass))
    { 
        if (GetFirstArcaneClass(oCaster) == nClass) 
            nLevel += GetArcanePRCLevels(oCaster);
        nLevel += TrueNecromancy(oCaster, GetSpellId(), "ARCANE") 
                  +  ShadowWeave(oCaster, GetSpellId()) 
                  +  FireAdept(oCaster, GetSpellId());
                  
        nLevel += PractisedSpellcasting(oCaster, nClass, nLevel); //gotta be the last one
    }
    return nLevel;
}

void WipeSpellbookHideFeats(object oPC)
{
    object oHide = GetPCSkin(oPC);
    itemproperty ipTest = GetFirstItemProperty(oHide);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT
            && GetItemPropertySubType(ipTest) > 10400
            && GetItemPropertySubType(ipTest) < 10592)
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
    WipeSpellbookHideFeats(oPC);
}

void NewSpellbookSpell(int nClass, int nMetamagic, int nSpellID)
{
    //get the level
    int nLevel = GetNewSpellbookCasterLevel(nClass);
    //set metamagic
    SetLocalInt(OBJECT_SELF, "NewSpellMetamagic", nMetamagic);
    DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "NewSpellMetamagic"));
    //pass in the spell
    ActionCastSpell(nSpellID, nLevel);
    //remove it from the spellbook
    RemoveSpellUse(OBJECT_SELF, GetSpellId(), nClass);
}