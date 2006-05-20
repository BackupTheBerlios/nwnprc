const int           RIG_ROOT_COUNT      = 70;
const string        RIG_DB              = "rig";
const float         RIG_DB_DELAY        = 600.0;

object CreateRandomizeItemByType(int nBaseItemType, int nLevel, int nAC = 0, int nRandomizeAppearance = TRUE, int nRandomizeAffixs = TRUE, int nRandomizeOther = TRUE);
object RandomizeItem(object oItem, int nLevel, int nRandomizeAppearance = TRUE, int nRandomizeAffixs = TRUE, int nRandomizeOther = TRUE);

object RIG_AddItemProperty(object oItem, int nRIGIP);
object RIG_Core(object oItem, int nLevel, int nType = BASE_ITEM_INVALID, int nAC = 0);
int RIG_GetRandomMatchingRootByType(int nBase, int nAC = 0);
int RIG_GetRandomMatchingRoot(object oItem, int nAC = 0);
int RIG_CheckLimitations(object oItem, object oPC = OBJECT_SELF);

#include "prc_gateway"
#include "rig_inc_app"

//Returns TRUE if oItem is stackable
int GetIsStackableItem(object oItem)
{
    //sanity testing
    if(!GetIsObjectValid(oItem))
        return FALSE;
    int nStackSize = GetItemStackSize(oItem);
    //Set the stacksize to two
    SetItemStackSize(oItem, 2);
    //Check if it really is two - otherwise, not stackable!
    int bStack;
    if(GetItemStackSize(oItem)==2)
        bStack = TRUE;
    //restore original stack size
    SetItemStackSize(oItem, nStackSize);
    //Return bStack which is TRUE if item is stackable
    return bStack;
}


void VoidRandomizeItem(object oItem, int nLevel)
{
    RandomizeItem(oItem, nLevel);
}

//during this function, the item is checked against OBJECT_SELF
//for equiping restrictions
object RandomizeItem(object oItem, int nLevel, int nRandomizeAppearance = TRUE, int nRandomizeAffixs = TRUE, int nRandomizeOther = TRUE)
{
//    DoDebug("RandomizeItem("+ObjectToString(oItem)+", "+IntToString(nLevel)+");");

    object oOriginalItem = oItem;
    int nIsDroppable = GetDroppableFlag(oItem);

    //sanity testing
    if(!GetIsObjectValid(oItem))
    {
//        DoDebug("oItem is not valid going into RandomizeItem");
        return OBJECT_INVALID;
    }

    //already mid-randomization, abort
    if(GetLocalInt(oItem, "RigEditing"))
    {
//        DoDebug(GetName(oItem)+" is already being randomized");
        return oItem;
    }

    //set a local int to avoid multiple runs
    SetLocalInt(oItem, "RigEditing", TRUE);

    //store original items AC for later
    //odd things if you get AC later on
    //we want the base AC, excluding itemproperties
    int nAC =  GetBaseAC(oItem);

    //do the itemproperties
    if(nRandomizeAffixs)
        oItem = RIG_Core(oItem, nLevel, nAC);

    //randomize appearance
    if(nRandomizeAppearance)
        oItem = RandomizeItemAppearance(oItem, nAC);

    //move it back from temporary storage
    DestroyObject(oItem);
    oItem = CopyItem(oItem, OBJECT_SELF, TRUE);

    if(nRandomizeOther)
    {
        //randomize charges if appropriate
        if(GetItemCharges(oItem) > 0)
            SetItemCharges(oItem, Random(49)+1);

        //randomize stack size, if appropriate
        if(GetIsStackableItem(oItem))
            SetItemStackSize(oItem, Random(StringToInt(Get2DACache("baseitems", "ILRStackSize", GetBaseItemType(oItem)))));

        //1% of items are cursed
        SetItemCursedFlag(oItem, FALSE);
        if(Random(100)==0)
            SetItemCursedFlag(oItem, TRUE);

        //1% of items are stolen
        SetStolenFlag(oItem, FALSE);
        if(Random(100)==0)
            SetStolenFlag(oItem, TRUE);
    }

    //set it if it was droppable
    SetDroppableFlag(oItem, nIsDroppable);

    //clear local int to avoid multiple runs
    DeleteLocalInt(oItem, "RigEditing");
//    DoDebug(GetName(oItem)+" has finished being randomized");

    //clean up the original
    if(GetIsObjectValid(oItem))
        DestroyObject(oOriginalItem);
    else
        oItem = oOriginalItem;
    return oItem;
}

object GetRandomizedItemByType(int nBaseItemType, int nLevel, int nAC = 0, int nRandomizeAppearance = TRUE, int nRandomizeAffixs = TRUE, int nRandomizeOther = TRUE)
{
    string sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(nLevel)+"_"+IntToString(nAC);
    object oChest = GetObjectByTag(sTag);
    //chest is valid
    if(GetIsObjectValid(oChest))
    {
        object oTest = GetFirstItemInInventory(oChest);
        while(!RIG_CheckLimitations(oTest) && GetIsObjectValid(oTest))
        {
            oTest = GetNextItemInInventory(oChest);
        }
        if(!GetIsObjectValid(oTest))
            return CreateRandomizeItemByType(nBaseItemType, nLevel, nAC);
        object oReturn = CopyItem(oTest, OBJECT_SELF, TRUE);
        DestroyObject(oTest);
        return oReturn;
    }
    //chest not valid, create one
    else
    {
        location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
        oChest = CreateObject(OBJECT_TYPE_CREATURE, "rig_chest", lLimbo, FALSE, sTag);
        SetLocalInt(oChest, "BaseItem", nBaseItemType);
        SetLocalInt(oChest, "Level", nLevel);
        SetLocalInt(oChest, "AC", nAC);
        //return a randomitem by type
        return CreateRandomizeItemByType(nBaseItemType, nLevel, nAC);
    }
}
void VoidGetRandomizedItemByType(int nBaseItemType, int nLevel, int nAC = 0, int nRandomizeAppearance = TRUE, int nRandomizeAffixs = TRUE, int nRandomizeOther = TRUE)
{
    GetRandomizedItemByType(nBaseItemType, nLevel, nAC, nRandomizeAppearance, nRandomizeAffixs, nRandomizeOther);
}

//during this function, the item is checked against OBJECT_SELF
//for equiping restrictions
object CreateRandomizeItemByType(int nBaseItemType, int nLevel, int nAC = 0, int nRandomizeAppearance = TRUE, int nRandomizeAffixs = TRUE, int nRandomizeOther = TRUE)
{
//StartTimer(OBJECT_SELF, "CreateRandomizeItemByType");
    if(nBaseItemType == BASE_ITEM_INVALID)
    {
//DoDebug("CreateRandomizeItemByType() invalid base item type");
//DoDebug("Timer CreateRandomizeItemByType(): "+StopTimer(OBJECT_SELF, "CreateRandomizeItemByType"));
        return OBJECT_INVALID;
    }

    object oItem;
    //do the itemproperties
    if(nRandomizeAffixs)
        oItem = RIG_Core(oItem, nLevel, nBaseItemType, nAC);

    if(!GetIsObjectValid(oItem))
    {
//DoDebug("CreateRandomizeItemByType() invalid after Rig_Core");
//DoDebug("Timer CreateRandomizeItemByType(): "+StopTimer(OBJECT_SELF, "CreateRandomizeItemByType"));
        return OBJECT_INVALID;
    }
//DoDebug("Timer CreateRandomizeItemByType() Q : "+QueryTimer(OBJECT_SELF, "CreateRandomizeItemByType"));

    //randomize appearance
    if(nRandomizeAppearance)
        oItem = RandomizeItemAppearance(oItem, nAC);
    if(!GetIsObjectValid(oItem))
    {
//DoDebug("CreateRandomizeItemByType() invalid after RandomizeItemAppearance");
//DoDebug("Timer CreateRandomizeItemByType(): "+StopTimer(OBJECT_SELF, "CreateRandomizeItemByType"));
        return OBJECT_INVALID;
    }

    //move it back from temporary storage
    DestroyObject(oItem);
    oItem = CopyItem(oItem, OBJECT_SELF, TRUE);

//DoDebug("Timer CreateRandomizeItemByType() Q : "+QueryTimer(OBJECT_SELF, "CreateRandomizeItemByType"));
    if(nRandomizeOther)
    {
        //randomize charges if appropriate
        if(GetItemCharges(oItem) > 0)
            SetItemCharges(oItem, RandomI(49)+1);

        //randomize stack size, if appropriate
        if(GetIsStackableItem(oItem))
            SetItemStackSize(oItem, RandomI(StringToInt(Get2DACache("baseitems", "ILRStackSize", GetBaseItemType(oItem)))));

        //1% of items are cursed
        SetItemCursedFlag(oItem, FALSE);
        if(RandomI(100)==0)
            SetItemCursedFlag(oItem, TRUE);

        //1% of items are stolen
        SetStolenFlag(oItem, FALSE);
        if(RandomI(100)==0)
            SetStolenFlag(oItem, TRUE);
    }

//    DoDebug(GetName(oItem)+" has finished being randomized");
//DoDebug("Timer CreateRandomizeItemByType(): "+StopTimer(OBJECT_SELF, "CreateRandomizeItemByType"));

    return oItem;
}

void VoidCreateRandomizeItemByType(int nBaseItemType, int nLevel, int nAC = 0, int nRandomizeAppearance = TRUE, int nRandomizeAffixs = TRUE, int nRandomizeOther = TRUE)
{
    CreateRandomizeItemByType(nBaseItemType, nLevel, nAC, nRandomizeAppearance, nRandomizeAffixs, nRandomizeOther);
}

object RIG_Core(object oItem, int nLevel, int nType = BASE_ITEM_INVALID, int nAC = 0)
{
    int nRoot;
    if(GetIsObjectValid(oItem))
        nRoot = RIG_GetRandomMatchingRoot(oItem, nAC);
    else
        nRoot = RIG_GetRandomMatchingRootByType(nType, nAC);
//DoDebug("Timer CreateRandomizeItemByType() Q : "+QueryTimer(OBJECT_SELF, "CreateRandomizeItemByType"));
    string sResRef = Get2DACache("rig_root", "ResRef", nRoot);
//DoDebug("RIG_Core() nRoot = "+IntToString(nRoot)+" sResRef = "+sResRef);
    int nSuffix, nPrefix;
    string sSuffix, sPrefix;
    if(nType == BASE_ITEM_INVALID
        && GetIsObjectValid(oItem))
        nType = GetBaseItemType(oItem);
    if(nType == BASE_ITEM_INVALID)
        return OBJECT_INVALID;
    int nIPType = StringToInt(Get2DACache("baseitems", "PropColumn", nType));
    object oReturn;
    object oTemp = CreateItemOnObject(sResRef, GetObjectByTag("HEARTOFCHAOS"));
    if(!GetIsObjectValid(GetObjectByTag("HEARTOFCHAOS")))
    {
//        DoDebug("RIG_Core() HEARTOFCHAOS is not valid");
        return OBJECT_INVALID;
    }
    if(!GetIsObjectValid(oTemp))
        oTemp = oItem;
    if(!GetIsObjectValid(oTemp))
    {
//DoDebug("RIG_Core() oTemp is not valid");
        return OBJECT_INVALID;
    }
//DoDebug("RIG_Core() name = "+GetName(oTemp));
    while (!GetIsObjectValid(oReturn))
    {
//DoDebug("rig_inc line 215");
        oReturn = CopyItem(oTemp, GetObjectByTag("HEARTOFCHAOS"), TRUE);
        SetLocalInt(GetModule(), "RIG_LEVEL", nLevel);
        sSuffix = GetRandomFrom2DA("rig_affix_r", "random_default", nIPType);
        sPrefix = GetRandomFrom2DA("rig_affix_r", "random_default", nIPType);
//DoDebug("Timer CreateRandomizeItemByType() Q : GetIsObjectValid(oReturn) : "+QueryTimer(OBJECT_SELF, "CreateRandomizeItemByType"));
        //sanity check. No prefix/suffixs at all, then abort.
        if(sSuffix == "" || sPrefix == "")
        {
            DestroyObject(oItem);
            return oReturn;
        }
        nSuffix = StringToInt(sSuffix);
        nPrefix = StringToInt(sPrefix);
//DoDebug("RIG_Core() nRoot = "+IntToString(nRoot)+" "+sPrefix+" "+sSuffix);
        while(nPrefix == nSuffix && nPrefix != 0 && nSuffix != 0)
        {
//DoDebug("rig_inc line 231");
            sPrefix = GetRandomFrom2DA("rig_affix_r", "random_default", nIPType);
            nPrefix = StringToInt(sPrefix);
        }
        DeleteLocalInt(GetModule(), "RIG_LEVEL");
//DoDebug("sResRef = "+sResRef);
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property1", nSuffix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property2", nSuffix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property3", nSuffix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property4", nSuffix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property5", nSuffix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property1", nPrefix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property2", nPrefix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property3", nPrefix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property4", nPrefix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property5", nPrefix)));
    }
    DestroyObject(oItem);
    string sPrefixName = Get2DACache("rig_affix", "Text", nPrefix);
    string sSuffixName = Get2DACache("rig_affix", "Text", nSuffix);
    string sName = Get2DACache("rig_root", "Name", nRoot);
    if(sPrefixName != "") sName = sPrefixName+" "+sName;
    if(sSuffixName != "") sName = sName+" of "+sSuffixName;
    SetName(oReturn, sName);
//DoDebug(GetName(oItem)+" was turned into "+GetName(oReturn));
    return oReturn;

}

int RIG_GetRandomMatchingRootByType(int nBase, int nAC = 0)
{
    int i = 0;
    string sValue = Get2DACache("rig_root", "BaseItem", i);
    while(sValue != "")
    {
//DoDebug("rig_inc line 278");
        if(StringToInt(sValue) == nBase)
        {
            //fuggly hardcoding for different armors
            if(nBase == BASE_ITEM_ARMOR)
            {
                if(nAC == StringToInt(Get2DACache("rig_root", "AC", i)))
                    return i;
            }
            else
                return i;
        }
        i++;
        sValue = Get2DACache("rig_root", "BaseItem", i);
    }
    return -1;
}

int RIG_GetRandomMatchingRoot(object oItem, int nAC = 0)
{
    //sanity testing
    if(!GetIsObjectValid(oItem))
    {
        DoDebug("oItem is not valid going into RIG_GetRandomMatchingRoot");
        return -1;
    }
    int nBase = GetBaseItemType(oItem);
    return RIG_GetRandomMatchingRootByType(nBase, nAC);
}

object RIG_AddItemProperty(object oItem, int nRIGIP)
{
    //sanity testing
    if(!GetIsObjectValid(oItem))
    {
//        DoDebug("oItem is not valid going into RIG_AddItemProperty");
        return OBJECT_INVALID;
    }
    if(nRIGIP <0)
    {
//        DoDebug("nRIGIP is less than 0 going into RIG_AddItemProperty");
        DestroyObject(oItem);
        return OBJECT_INVALID;
    }
    if(nRIGIP == 0)
    {
//        DoDebug("nRIGIP is 0 going into RIG_AddItemProperty");
        //no itemproperty, do nothing
        return oItem;
    }
    int nType = -1;
    nType = StringToInt(Get2DACache("rig_ip", "Type", nRIGIP));
    string sVar2 = Get2DACache("rig_ip", "Var2", nRIGIP);
    string sVar3 = Get2DACache("rig_ip", "Var3", nRIGIP);
    string sVar4 = Get2DACache("rig_ip", "Var4", nRIGIP);
    int nVar2 = -1;
    int nVar3 = -1;
    int nVar4 = -1;
    //if its not blank, convert to an int
    if(sVar2 != "")
        nVar2 = StringToInt(sVar2);
    if(sVar3 != "")
        nVar3 = StringToInt(sVar3);
    if(sVar4 != "")
        nVar4 = StringToInt(sVar4);
    itemproperty ipToApply;
//DoDebug("nType = "+IntToString(nType));
//DoDebug("sVar2 = "+sVar2);
//DoDebug("sVar3 = "+sVar3);
//DoDebug("sVar4 = "+sVar4);
//DoDebug("nVar2 = "+IntToString(nVar2));
//DoDebug("nVar3 = "+IntToString(nVar3));
//DoDebug("nVar4 = "+IntToString(nVar4));
    ipToApply = IPGetItemPropertyByID(nType, nVar2, nVar3, nVar4);
    if(!GetIsItemPropertyValid(ipToApply))
    {
        DoDebug("Itemproperty is not valid to apply");
        DestroyObject(oItem);
        return OBJECT_INVALID;
    }
    IPSafeAddItemProperty(oItem, ipToApply);
    //check it worked
    itemproperty ipTemp = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipTemp))
    {
//DoDebug("rig_inc line 363");
        if(ipTemp == ipToApply)
            return oItem;
        ipTemp = GetNextItemProperty(oItem);
    }
    //didnt work
    DoDebug("Itemproperty is not applicable to this base item. "+GetName(oItem)+" "+IntToString(nType));
    DestroyObject(oItem);
    return OBJECT_INVALID;
}

int RIG_CheckLimitations(object oItem, object oPC = OBJECT_SELF)
{
    itemproperty ipTemp = GetFirstItemProperty(oItem);
    int nClassValid = -1;
    int nRaceValid = -1;
    int nSAlignValid = -1;
    int nAlignValid = -1;
    while(GetIsItemPropertyValid(ipTemp))
    {
//DoDebug("rig_inc line 383");
        int nType = GetItemPropertyType(ipTemp);
        int nSubType = GetItemPropertySubType(ipTemp);
        switch(nType)
        {
            case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:
                switch(nSubType)
                {
                    case IP_CONST_ALIGNMENTGROUP_EVIL:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENTGROUP_GOOD:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENTGROUP_CHAOTIC:
                        if(GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENTGROUP_LAWFUL:
                        if(GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                }
                break;
            case ITEM_PROPERTY_USE_LIMITATION_CLASS:
                if(GetLevelByClass(nSubType, oPC))
                    nClassValid = TRUE;
                else if(nClassValid == -1)
                    nClassValid = FALSE;
                break;
            case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:
                if(GetRacialType(oPC) == nSubType)
                    nRaceValid = TRUE;
                else if(nRaceValid == -1)
                    nRaceValid = FALSE;
                break;
            case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:
                switch(nSubType)
                {
                    case IP_CONST_ALIGNMENT_CE:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_CN:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_CG:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_NE:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_TN:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_NG:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_LE:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_LN:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_LG:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                }
                break;

        }
        ipTemp = GetNextItemProperty(oItem);
    }
    if(nAlignValid == FALSE
        || nClassValid == FALSE
        || nRaceValid == FALSE
        || nSAlignValid == FALSE)
    {
        return FALSE;
    }
    return TRUE;
}

//spawn 1-40 for each base item type
void RIG_DoSetup2(location lLimbo, int nBaseItemType, int nAC = 0)
{
    int nLevel;
    for(nLevel = 1; nLevel <= 40; nLevel++)
    {
        string sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(nLevel)+"_"+IntToString(nAC);
        object oChest = GetObjectByTag(sTag);
        //check DB next
        if(!GetIsObjectValid(oChest))
        {
            oChest = RetrieveCampaignObject(RIG_DB, sTag, lLimbo);
        }
        //create it if it doesnt exist
        /*
        if(!GetIsObjectValid(oChest))
        {
            oChest = CreateObject(OBJECT_TYPE_CREATURE, "rig_chest", lLimbo, FALSE, sTag);
            SetLocalInt(oChest, "BaseItem", nBaseItemType);
            SetLocalInt(oChest, "Level", nLevel);
            SetLocalInt(oChest, "AC", nAC);
        }
        */
    }
}
void RIG_DoDBStore2(location lLimbo, int nBaseItemType, int nAC = 0)
{
    int nLevel;
    for(nLevel = 1; nLevel <= 40; nLevel++)
    {
        string sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(nLevel)+"_"+IntToString(nAC);
        object oChest = GetObjectByTag(sTag);
        if(GetIsObjectValid(oChest))
        {
            StoreCampaignObject(RIG_DB, sTag, oChest);
        }
    }
}

void RIG_DoDBStore()
{
    //destroy database to stop inifinite bloat
    //doesnt work on linux but oh well
    DestroyCampaignDatabase(RIG_DB);

    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
    int i;
    for(i=0;i<70;i++)
    {
        int nBaseType = StringToInt(Get2DACache("rig_root", "BaseItem", i));
        int nAC = StringToInt(Get2DACache("rig_root", "AC", i));
        DelayCommand(0.1, RIG_DoDBStore2(lLimbo, nBaseType, nAC));
    }
    DelayCommand(RIG_DB_DELAY, RIG_DoDBStore());
}

void RIG_DoSetup()
{
    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
    int i;
    for(i=0;i<70;i++)
    {
        int nBaseType = StringToInt(Get2DACache("rig_root", "BaseItem", i));
        int nAC = StringToInt(Get2DACache("rig_root", "AC", i));
        DelayCommand(0.1, RIG_DoSetup2(lLimbo, nBaseType, nAC));
    }
    //start Pseudo-hb to store them in a database
    DelayCommand(RIG_DB_DELAY, RIG_DoDBStore());
}
