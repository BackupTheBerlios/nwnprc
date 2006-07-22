/*
    prc_craft

    Dynamic conversation file for forge, modified from
        old psi_powconv, borrowed from prc_ccc

    By: Flaming_Sword
    Created: Jul 12, 2006
    Modified: Jul 16, 2006

    LIMITATIONS:
        ITEM_PROPERTY_BONUS_FEAT
            not all feats available, anything much higher killed the game
            some of the feats added can be silly (blame the 2das)
        IPRP_SPELLS
            anything involving this 2da file can only use the bioware spells
                since anything much higher produced TMIs
        Not all item properties have returning functions
        Needs updating if item property 2da files increase in size

    USE:
        Place this script in the OnUsed event of a placable object
        Placeable must be plot, have inventory, locked

    CHECK:
        89 properties with constants, 15 without
*/

#include "prc_craft_include"
#include "inc_dynconv"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

//const int STAGE_                        = ;

const int STAGE_START                   = 0;
const int STAGE_SELECT_ITEM             = 1;
const int STAGE_SELECT_TYPE             = 2;
const int STAGE_SELECT_SUBTYPE          = 3;
const int STAGE_SELECT_COSTTABLEVALUE   = 4;
const int STAGE_SELECT_PARAM1VALUE      = 5;
const int STAGE_CONFIRM                 = 6;
const int STAGE_CRAFT                   = 101;
const int STAGE_CRAFT_SELECT            = 102;
const int STAGE_CRAFT_MASTERWORK        = 103;
const int STAGE_CRAFT_AC                = 104;
const int STAGE_CRAFT_MIGHTY            = 105;
const int STAGE_CRAFT_CONFIRM           = 106;

//const int STAGE_CRAFT                   = 101;


//const int CHOICE_                       = ;

//these must be past the highest 2da entry to be read
const int CHOICE_FORGE                  = 20001;
const int CHOICE_BOOST                  = 20002;
const int CHOICE_BACK                   = 20003;
const int CHOICE_CLEAR                  = 20004;
const int CHOICE_CONFIRM                = 20005;
const int CHOICE_SETNAME                = 20006;

const int CHOICE_CRAFT                  = 20101;

//const int NUM_MAX_COSTTABLEVALUES       = 70;
//const int NUM_MAX_PARAM1VALUES          = 70;

const int HAS_SUBTYPE                   = 1;
const int HAS_COSTTABLE                 = 2;
const int HAS_PARAM1                    = 4;

const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"

const string PRC_CRAFT_ITEM             = "PRC_CRAFT_ITEM";
const string PRC_CRAFT_TYPE             = "PRC_CRAFT_TYPE";
const string PRC_CRAFT_SUBTYPE          = "PRC_CRAFT_SUBTYPE";
const string PRC_CRAFT_SUBTYPEVALUE     = "PRC_CRAFT_SUBTYPEVALUE";
const string PRC_CRAFT_COSTTABLE        = "PRC_CRAFT_COSTTABLE";
const string PRC_CRAFT_COSTTABLEVALUE   = "PRC_CRAFT_COSTTABLEVALUE";
const string PRC_CRAFT_PARAM1           = "PRC_CRAFT_PARAM1";
const string PRC_CRAFT_PARAM1VALUE      = "PRC_CRAFT_PARAM1VALUE";
const string PRC_CRAFT_PROPLIST         = "PRC_CRAFT_PROPLIST";
const string PRC_CRAFT_COST             = "PRC_CRAFT_COST";
//const string PRC_CRAFT_BLUEPRINT        = "PRC_CRAFT_BLUEPRINT";
const string PRC_CRAFT_CONVO_           = "PRC_CRAFT_CONVO_";
const string PRC_CRAFT_BASEITEMTYPE     = "PRC_CRAFT_BASEITEMTYPE";
const string PRC_CRAFT_AC               = "PRC_CRAFT_AC";
const string PRC_CRAFT_MIGHTY           = "PRC_CRAFT_MIGHTY";
const string PRC_CRAFT_MATERIAL         = "PRC_CRAFT_MATERIAL";
const string PRC_CRAFT_TAG              = "PRC_CRAFT_TAG";

const string PRC_CRAFT_SCRIPT_STATE     = "PRC_CRAFT_SCRIPT_STATE";

const int PRC_CRAFT_STATE_NORMAL        = 1;
const int PRC_CRAFT_STATE_MAGIC         = 2;

const int SORT       = TRUE; // If the sorting takes too much CPU, set to FALSE
const int DEBUG_LIST = FALSE;
//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void PrintList(object oPC)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oPC, "ForgeConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oPC, "ForgeConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oPC, "ForgeConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: Power names are unique.
 *
 * @param oPC     The storage object aka whomever is gaining powers in this conversation
 * @param sChoice The choice string
 * @param nChoice The choice value
 */

void AddToTempList(object oPC, string sChoice, int nChoice)
{
    if(DEBUG_LIST) DoDebug("\nAdding to temp list: '" + sChoice + "' - " + IntToString(nChoice));
    if(DEBUG_LIST) PrintList(oPC);
    // If there is nothing yet
    if(!GetLocalInt(oPC, "PRC_CRAFT_CONVO_ListInited"))
    {
        SetLocalString(oPC, "PRC_CRAFT_CONVO_List_Head", sChoice);
        SetLocalInt(oPC, "PRC_CRAFT_CONVO_List_" + sChoice, nChoice);

        SetLocalInt(oPC, "PRC_CRAFT_CONVO_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oPC, "PRC_CRAFT_CONVO_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oPC, "PRC_CRAFT_CONVO_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oPC, "PRC_CRAFT_CONVO_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oPC, "PRC_CRAFT_CONVO_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oPC, "PRC_CRAFT_CONVO_List_Next_" + sChoice, sNext);
        SetLocalInt(oPC, "PRC_CRAFT_CONVO_List_" + sChoice, nChoice);
    }
}

/**
 * Reads the linked list built with AddToTempList() to AddChoice() and
 * deletes it.
 *
 * @param oPC A PC gaining powers at the moment
 */

void TransferTempList(object oPC)
{
    string sChoice = GetLocalString(oPC, "PRC_CRAFT_CONVO_List_Head");
    int    nChoice = GetLocalInt   (oPC, "PRC_CRAFT_CONVO_List_" + sChoice);

    DeleteLocalString(oPC, "PRC_CRAFT_CONVO_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oPC);

        // Get next
        sChoice = GetLocalString(oPC, "PRC_CRAFT_CONVO_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oPC, "PRC_CRAFT_CONVO_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oPC, "PRC_CRAFT_CONVO_List_Next_" + sPrev);
        DeleteLocalInt   (oPC, "PRC_CRAFT_CONVO_List_" + sPrev);
    }

    DeleteLocalInt(oPC, "PRC_CRAFT_CONVO_ListInited");
}

//Returns the next conversation stage according
//  to item property
int GetNextItemPropStage(int nStage, object oPC, int nPropList)
{
    nStage++;
    if(nStage == STAGE_SELECT_SUBTYPE && !(nPropList & HAS_SUBTYPE))
        nStage++;
    if(nStage == STAGE_SELECT_COSTTABLEVALUE && !(nPropList & HAS_COSTTABLE))
        nStage++;
    if(nStage == STAGE_SELECT_PARAM1VALUE && !(nPropList & HAS_PARAM1))
        nStage++;
    MarkStageNotSetUp(nStage, oPC);
    return nStage;
}

//Returns the previous conversation stage according
//  to item property
int GetPrevItemPropStage(int nStage, object oPC, int nPropList)
{
    nStage--;
    if(nStage == STAGE_SELECT_PARAM1VALUE && !(nPropList & HAS_PARAM1))
        nStage--;
    if(nStage == STAGE_SELECT_COSTTABLEVALUE && !(nPropList & HAS_COSTTABLE))
        nStage--;
    if(nStage == STAGE_SELECT_SUBTYPE && !(nPropList & HAS_SUBTYPE))
        nStage--;
    MarkStageNotSetUp(nStage, oPC);
    return nStage;
}

int SkipLine(int i)
{
    switch(i)
    {
        case 328: i = 345;
        case 359: i++;
        case 400: i = 450;
        case 487: i = 511;
        case 513: i++;
        case 521: i = 538;
        case 540: i = 900;
        case 928: i = 1000;
    }
    return i;
}

//Adds names to a list based on sTable (2da), delayed recursion
//  to avoid TMI
void PopulateList(object oPC, int MaxValue, int bSort, string sTable, int nCasterLevel = 0, object oItem = OBJECT_INVALID, int i = 0)
{
    if(GetLocalInt(oPC, "DynConv_Waiting") == FALSE)
        return;
    if(i < MaxValue)
    {
        int bValid = TRUE;
        string sTemp = "";
        //if(GetIsObjectValid(oItem)) bValid = ValidProperty(oItem, i);
        if(sTable == "iprp_spells")
            i = SkipLine(i);
        //else if(GetStringLeft(sTable, 6) == "craft_")
        sTemp = Get2DACache(sTable, "Name", i);
        if((sTemp != "") && bValid)//this is going to kill
        {
            if(bSort)   AddToTempList(oPC, ActionString(GetStringByStrRef(StringToInt(sTemp))), i);
            else        AddChoice(ActionString(GetStringByStrRef(StringToInt(sTemp))), i, oPC);
        }
        if(!(i % 100) && i) //i != 0, i % 100 == 0
            FloatingTextStringOnCreature("*Tick*", oPC, FALSE);
    }
    else
    {
        if(bSort) TransferTempList(oPC);
        DeleteLocalInt(oPC, "DynConv_Waiting");
        FloatingTextStringOnCreature("*Done*", oPC, FALSE);
        return;
    }
    DelayCommand(0.01, PopulateList(oPC, MaxValue, bSort, sTable, nCasterLevel, oItem, i + 1));
}

void main()
{
    object oTarget = GetSpellTargetObject();
    object oPC = OBJECT_SELF;//GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    if(nValue == 0)
    {   //as part of a cast spell and not in the convo
        if(oTarget == OBJECT_SELF)
        {   //cast on self, crafting non-magical items
            SetLocalInt(OBJECT_SELF, PRC_CRAFT_SCRIPT_STATE, PRC_CRAFT_STATE_NORMAL);
        }
        else if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
        {   //cast on item, crafting targeted item
            if(!GetHasFeat(GetCraftingFeat(GetBaseItemType(oTarget)), oPC))
            {
                SendMessageToPC(oPC, "You do not have the required feat to craft this item.");
                return;
            }
            if(!StringToInt(GetStringLeft(GetTag(oItem), 3)))
            {
                SendMessageToPC(oPC, "This is not a magic item.");
                return;
            }
            SetLocalInt(OBJECT_SELF, PRC_CRAFT_SCRIPT_STATE, PRC_CRAFT_STATE_MAGIC);
            SetLocalObject(OBJECT_SELF, PRC_CRAFT_ITEM, oTarget);
        }
        StartDynamicConversation("prc_craft", OBJECT_SELF, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE);
        return;
    }
    int nStage = GetStage(oPC);

    object oItem = GetLocalObject(oPC, PRC_CRAFT_ITEM);
    int nType = GetLocalInt(oPC, PRC_CRAFT_TYPE);
    string sSubtype = GetLocalString(oPC, PRC_CRAFT_SUBTYPE);
    int nSubTypeValue = GetLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE);
    string sCostTable = GetLocalString(oPC, PRC_CRAFT_COSTTABLE);
    int nCostTableValue = GetLocalInt(oPC, PRC_CRAFT_COSTTABLEVALUE);
    string sParam1 = GetLocalString(oPC, PRC_CRAFT_PARAM1);
    int nParam1Value = GetLocalInt(oPC, PRC_CRAFT_PARAM1VALUE);

    string sTag = GetLocalString(oPC, PRC_CRAFT_TAG);

    int nAC = GetLocalInt(oPC, PRC_CRAFT_AC);
    int nBase = GetLocalInt(oPC, PRC_CRAFT_BASEITEMTYPE);
    int nCost = GetLocalInt(oPC, PRC_CRAFT_COST);
    int nMaterial = GetLocalInt(oPC, PRC_CRAFT_MATERIAL);
    int nMighty = GetLocalInt(oPC, PRC_CRAFT_MIGHTY);
    int nPropList = GetLocalInt(oPC, PRC_CRAFT_PROPLIST);
    int nState = GetLocalInt(oPC, PRC_CRAFT_SCRIPT_STATE);

    object oNewItem = GetItemPossessedBy(GetCraftChest(), sTag);

    string sTemp = "";
    int nTemp = 0;

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;
    if(nValue == DYNCONV_SETUP_STAGE)
    {
        //if(DEBUG) DoDebug("forge_conv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            int i;
            switch(nStage)
            {
                case STAGE_START:
                {
                    if(nState == PRC_CRAFT_STATE_NORMAL)
                    {
                        SetHeader("Select an item to craft.");
                        SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                        SetLocalInt(oPC, PRC_CRAFT_AC, -1);
                        SetLocalInt(oPC, PRC_CRAFT_MIGHTY, -1);
                        PopulateList(oPC, MaxListSize("craft_gen_item"), TRUE, "craft_gen_item");
                    }
                    else if(nState == PRC_CRAFT_STATE_MAGIC)
                    {
                        int nCasterLevel = PRCGetCasterLevel(oPC);
                        int nBaseItem = GetBaseItemType(oItem);
                        string sFile = GetCrafting2DA(nBaseItem);
                        int nFeat = GetCraftingFeat(nBaseItem);
                        int bEpic = GetHasFeat(GetEpicCraftingFeat(nFeat), oPC);
                        AddChoice(ActionString("Change Name"), CHOICE_SETNAME, oPC);
                        SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                        if(sFile != "")
                        {
                            //PopulateList(oPC, MaxListSize(sFile), FALSE, sFile, nCasterLevel);
                        }
                        else
                        {
                            sFile = "iprp_spells";
                            PopulateList(oPC, MaxListSize(sFile), TRUE, sFile, nCasterLevel);

                        }

                        SetHeader(ItemStats(oItem) + "\nSelect an item property.");
                        AddChoice(ActionString("Change Name"), CHOICE_SETNAME, oPC);
                        SetLocalInt(oPC, PRC_CRAFT_TYPE, -1);
                        SetLocalString(oPC, PRC_CRAFT_SUBTYPE, "");
                        SetLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE, -1);
                        SetLocalString(oPC, PRC_CRAFT_COSTTABLE, "");
                        SetLocalInt(oPC, PRC_CRAFT_COSTTABLEVALUE, -1);
                        SetLocalString(oPC, PRC_CRAFT_PARAM1, "");
                        SetLocalInt(oPC, PRC_CRAFT_PARAM1VALUE, -1);
                        //PopulateList(oPC, NUM_MAX_PROPERTIES, TRUE, "itempropdef");
                    }
                    SetDefaultTokens();
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
                    MarkStageSetUp(nStage, oPC);
                    SetCustomToken(DYNCONV_TOKEN_EXIT, ActionString("Leave"));
                    SetCustomToken(DYNCONV_TOKEN_NEXT, ActionString("Next"));
                    SetCustomToken(DYNCONV_TOKEN_PREV, ActionString("Previous"));
                    break;
                }
                case STAGE_SELECT_ITEM:
                {
                    SetHeader("Select an equipped item to forge.");
                    AllowExit(DYNCONV_EXIT_NOT_ALLOWED, FALSE, oPC);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    for(i = 0; i < 14; i++) //no creature items
                    {
                        sTemp = GetName(GetItemInSlot(i, oPC));
                        if(sTemp != "")
                            AddChoice(ActionString(sTemp), i, oPC);
                    }
                    MarkStageSetUp(nStage, oPC);
                    break;
                }
                case STAGE_SELECT_TYPE:
                {
                    SetHeader(ItemStats(oItem) + "\nSelect an item property.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    AddChoice(ActionString("Remove all item properties") +
                            " [<cþ>WARNING</c>]",
                        CHOICE_CLEAR, oPC);
                    AddChoice(ActionString("Change Name"), CHOICE_SETNAME, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    SetLocalInt(oPC, PRC_CRAFT_TYPE, -1);
                    SetLocalString(oPC, PRC_CRAFT_SUBTYPE, "");
                    SetLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE, -1);
                    SetLocalString(oPC, PRC_CRAFT_COSTTABLE, "");
                    SetLocalInt(oPC, PRC_CRAFT_COSTTABLEVALUE, -1);
                    SetLocalString(oPC, PRC_CRAFT_PARAM1, "");
                    SetLocalInt(oPC, PRC_CRAFT_PARAM1VALUE, -1);
                    PopulateList(oPC, NUM_MAX_PROPERTIES, TRUE, "itempropdef");
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_SELECT_SUBTYPE:
                {
                    SetHeader("Select a subtype.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, MaxListSize(sSubtype), TRUE, sSubtype);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_SELECT_COSTTABLEVALUE:
                {
                    SetHeader("Select a costtable value.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, MaxListSize(sCostTable), FALSE, sCostTable);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_SELECT_PARAM1VALUE:
                {
                    SetHeader("Select a param1 value.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, MaxListSize(sParam1), FALSE, sParam1);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CONFIRM:
                {
                    itemproperty ip = ConstructIP(nType, nSubTypeValue, nCostTableValue, nParam1Value);
                    IPSafeAddItemProperty(oNewItem, ip, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
                    nTemp = GetGoldPieceValue(oNewItem) - GetGoldPieceValue(oItem);
                    SetLocalInt(oPC, PRC_CRAFT_COST, nTemp);
                    sTemp = InsertSpaceAfterString(GetStringByStrRef(StringToInt(Get2DACache("itempropdef", "GameStrRef", nType))));
                    if(sSubtype != "")
                        sTemp += InsertSpaceAfterString(GetStringByStrRef(StringToInt(Get2DACache(sSubtype, "Name", nSubTypeValue))));
                    if(sCostTable != "")
                        sTemp += InsertSpaceAfterString(GetStringByStrRef(StringToInt(Get2DACache(sCostTable, "Name", nCostTableValue))));
                    if(sParam1 != "")
                        sTemp += InsertSpaceAfterString(GetStringByStrRef(StringToInt(Get2DACache(sParam1, "Name", nParam1Value))));
                    sTemp += "\n\nCost: " + IntToString(nTemp);
                    SetHeader("You have selected:\n\n" + sTemp + "\n\nPlease confirm your selection.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    if(GetGold(oPC) >= nTemp)
                        AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_AC:
                {
                    SetHeader("Select a base AC value.");
                    AllowExit(DYNCONV_EXIT_NOT_ALLOWED, FALSE, oPC);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    for(i = 0; i < 9; i++)
                        AddChoice(ActionString(IntToString(i)), i, oPC);
                    /*
                    AddChoice(ActionString("0"), 0, oPC);
                    AddChoice(ActionString("1"), 1, oPC);
                    AddChoice(ActionString("2"), 2, oPC);
                    AddChoice(ActionString("3"), 3, oPC);
                    AddChoice(ActionString("4"), 4, oPC);
                    AddChoice(ActionString("5"), 5, oPC);
                    AddChoice(ActionString("6"), 6, oPC);
                    AddChoice(ActionString("7"), 7, oPC);
                    AddChoice(ActionString("8"), 8, oPC);
                    */
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_MIGHTY:
                {
                    SetHeader("Select a mighty value.");
                    AllowExit(DYNCONV_EXIT_NOT_ALLOWED, FALSE, oPC);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    for(i = 0; i < 21; i++)
                        AddChoice("+" + ActionString(IntToString(i)), i, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_MASTERWORK:
                {
                    SetHeader("Select an item type.");
                    AllowExit(DYNCONV_EXIT_NOT_ALLOWED, FALSE, oPC);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    AddChoice(ActionString("Normal"), PRC_CRAFT_FLAG_NONE, oPC);
                    if(!((nBase == BASE_ITEM_ARMOR) && (GetItemBaseAC(oNewItem))))
                    {
                        AddChoice(ActionString("Masterwork"), PRC_CRAFT_FLAG_MASTERWORK, oPC);
                        //if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_METAL))
                        if(nBase == BASE_ITEM_ARMOR)    //because we can only have adamantine armour at this point
                            AddChoice(ActionString("Adamantine"), PRC_CRAFT_FLAG_ADAMANTINE, oPC);
                        if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_WOOD))
                            AddChoice(ActionString("Darkwood"), PRC_CRAFT_FLAG_DARKWOOD, oPC);
                        if((nBase == BASE_ITEM_ARMOR) ||
                            (nBase == BASE_ITEM_SMALLSHIELD) ||
                            (nBase == BASE_ITEM_LARGESHIELD) ||
                            (nBase == BASE_ITEM_TOWERSHIELD))
                            AddChoice(ActionString("Dragonhide"), PRC_CRAFT_FLAG_DRAGONHIDE, oPC);
                        if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_METAL))
                            AddChoice(ActionString("Mithral"), PRC_CRAFT_FLAG_MITHRAL, oPC);/*
                        if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_METAL))
                            AddChoice(ActionString("Cold Iron"), PRC_CRAFT_FLAG_COLD_IRON, oPC);
                        if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_METAL))
                            AddChoice(ActionString("Alchemical Silver"), PRC_CRAFT_FLAG_ALCHEMICAL_SILVER, oPC);*/
                    }
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_CONFIRM:
                {   //approximate PHB item prices stored in baseitems.2da (accurate except for shields)
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
                    SetIdentified(oNewItem, FALSE);
                    nTemp = GetGoldPieceValue(oNewItem) / StringToInt(Get2DACache("baseitems", "ItemMultiplier", nType));
                    SetIdentified(oNewItem, TRUE);
                    int sFlag = StringToInt(Get2DACache("craft_gen_item", "Type", nBase));
                    int nAdd = 0;
                    if(nMaterial & PRC_CRAFT_FLAG_MASTERWORK)
                    {
                        switch(sFlag)
                        {
                            case PRC_CRAFT_ITEM_TYPE_WEAPON: nAdd = 300; break;
                            case PRC_CRAFT_ITEM_TYPE_ARMOUR: nAdd = 150; break;
                            case PRC_CRAFT_ITEM_TYPE_SHIELD: nAdd = 150; break;
                            case PRC_CRAFT_ITEM_TYPE_AMMO: nAdd = 594; break;
                        }
                    }
                    if(nMaterial & PRC_CRAFT_FLAG_ADAMANTINE)
                    {
                        switch(GetItemBaseAC(oNewItem))
                        {
                            case 1:
                            case 2:
                            case 3: nAdd = 5000; break;
                            case 4:
                            case 5: nAdd = 10000; break;
                            case 6:
                            case 7:
                            case 8: nAdd = 15000; break;
                        }
                    }
                    if(nMaterial & PRC_CRAFT_FLAG_DARKWOOD)
                    {
                        nAdd += StringToInt(Get2DACache("baseitems", "TenthLBS", nType));
                    }
                    if(nMaterial & PRC_CRAFT_FLAG_DRAGONHIDE)
                    {
                        nAdd += nAdd + nTemp;
                    }
                    if(nMaterial & PRC_CRAFT_FLAG_MITHRAL)
                    {
                        if(nBase == BASE_ITEM_ARMOR)
                        {
                            switch(GetItemBaseAC(oNewItem))
                            {
                                case 1:
                                case 2:
                                case 3: nAdd = 1000; break;
                                case 4:
                                case 5: nAdd = 4000; break;
                                case 6:
                                case 7:
                                case 8: nAdd = 9000; break;
                            }
                        }
                        else
                        {
                            switch(sFlag)
                            {
                                case PRC_CRAFT_ITEM_TYPE_WEAPON: nAdd = 50 * StringToInt(Get2DACache("baseitems", "TenthLBS", nType)); break;
                                case PRC_CRAFT_ITEM_TYPE_SHIELD: nAdd = 1000; break;
                            }
                        }
                    }
                    if(nMaterial & PRC_CRAFT_FLAG_COLD_IRON)
                    {
                        //not implemented
                    }
                    if(nMaterial & PRC_CRAFT_FLAG_ALCHEMICAL_SILVER)
                    {
                        //not implemented
                    }
                    nTemp += nAdd;
                    nTemp /= 3;
                    if(nTemp < 1) nTemp = 1;
                    SetLocalInt(oPC, PRC_CRAFT_COST, nTemp);
                    SetHeader("You have chosen to craft:\n\n" + ItemStats(oNewItem) + "\nPrice: " + IntToString(nTemp) + "gp");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    if(GetGold(oPC) >= nTemp)
                        AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                /*
                case <CONSTANT>:
                {
                    SetHeader("");
                    AddChoice(ActionString(""), <CONSTANT>, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                */
                default:
                {
                    if(DEBUG) DoDebug("Invalid Stage: " + IntToString(nStage));
                    break;
                }
            }
        }
        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("prc_craft: Running exit handler");
        // End of conversation cleanup
        DeleteLocalObject(oPC, PRC_CRAFT_ITEM);
        DeleteLocalInt(oPC, PRC_CRAFT_TYPE);
        DeleteLocalString(oPC, PRC_CRAFT_SUBTYPE);
        DeleteLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE);
        DeleteLocalString(oPC, PRC_CRAFT_COSTTABLE);
        DeleteLocalInt(oPC, PRC_CRAFT_COSTTABLEVALUE);
        DeleteLocalString(oPC, PRC_CRAFT_PARAM1);
        DeleteLocalInt(oPC, PRC_CRAFT_PARAM1VALUE);
        DeleteLocalInt(oPC, PRC_CRAFT_PROPLIST);
        DeleteLocalInt(oPC, PRC_CRAFT_AC);
        DeleteLocalInt(oPC, PRC_CRAFT_BASEITEMTYPE);
        DeleteLocalInt(oPC, PRC_CRAFT_COST);
        DeleteLocalInt(oPC, PRC_CRAFT_MATERIAL);
        DeleteLocalInt(oPC, PRC_CRAFT_MIGHTY);
        DeleteLocalInt(oPC, PRC_CRAFT_SCRIPT_STATE);
        DestroyObject(oNewItem, 0.1);
        DeleteLocalInt(oPC, PRC_CRAFT_TAG);
        /*
        while(GetIsObjectValid(oNewItem))   //clearing inventory
        {
            DestroyObject(oNewItem);
            oNewItem = GetNextItemInInventory(OBJECT_SELF);
        }
        */
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("prc_craft: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        switch(nStage)
        {
            case STAGE_START:
            {
                if(nState == PRC_CRAFT_STATE_NORMAL)
                {
                    SetLocalInt(oPC, PRC_CRAFT_BASEITEMTYPE, nChoice);
                    if(nChoice == BASE_ITEM_ARMOR) nStage = STAGE_CRAFT_AC;
                    else if((nChoice == BASE_ITEM_LONGBOW) ||
                        (nChoice == BASE_ITEM_SHORTBOW)
                        )
                        nStage = STAGE_CRAFT_MIGHTY;
                    else
                        nStage = STAGE_CRAFT_MASTERWORK;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else if(nState == PRC_CRAFT_STATE_MAGIC)
                {
                    if(nChoice == CHOICE_SETNAME)
                    {
                        SetLocalInt(oPC, "Item_Name_Change", 1);
                        nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                        SendMessageToPC(oPC, "Please state (use chat) the new name of the item.");
                    }
                    else
                    {
                        nType = nChoice;
                        SetLocalInt(oPC, PRC_CRAFT_TYPE, nType);
                        sSubtype = Get2DACache("itempropdef", "SubTypeResRef", nType);
                        SetLocalString(oPC, PRC_CRAFT_SUBTYPE, sSubtype);
                        sCostTable = Get2DACache("itempropdef", "CostTableResRef", nType);
                        if(sCostTable == "0")   //IPRP_BASE1 is blank
                            sCostTable = "";
                        if(sCostTable != "")
                            sCostTable = Get2DACache("iprp_costtable", "Name", StringToInt(sCostTable));
                        SetLocalString(oPC, PRC_CRAFT_COSTTABLE, sCostTable);
                        sParam1 = Get2DACache("itempropdef", "Param1ResRef", nType);
                        if(sParam1 != "")
                            sParam1 = Get2DACache("iprp_paramtable", "TableResRef", StringToInt(sParam1));
                        SetLocalString(oPC, PRC_CRAFT_PARAM1, sParam1);

                        nPropList = 0;
                        if(sSubtype != "")
                            nPropList |= HAS_SUBTYPE;
                        if(sCostTable != "")
                            nPropList |= HAS_COSTTABLE;
                        if(sParam1 != "")
                            nPropList |= HAS_PARAM1;
                        SetLocalInt(oPC, PRC_CRAFT_PROPLIST, nPropList);
                    }
                    nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                }
                break;
            }
            case STAGE_SELECT_ITEM:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = 0;//GetPrevItemPropStage(nStage, oPC, nPropList);
                else
                {
                    oItem = GetItemInSlot(nChoice, oPC);
                    SetLocalObject(oPC, PRC_CRAFT_ITEM, oItem);
                    while(GetIsObjectValid(oNewItem))   //clearing inventory
                    {
                        DestroyObject(oNewItem);
                        oNewItem = GetNextItemInInventory(OBJECT_SELF);
                    }
                    oNewItem = CopyItem(oItem, OBJECT_SELF, FALSE); //temp item for cost
                    nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                }
                break;
            }
            case STAGE_SELECT_TYPE:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                else if(nChoice == CHOICE_CLEAR) //strips item properties
                {
                    itemproperty ip = GetFirstItemProperty(oItem);
                    while(GetIsItemPropertyValid(ip))
                    {
                        RemoveItemProperty(oItem, ip);
                        ip = GetNextItemProperty(oItem);
                    }
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC);
                    SetHeader(ItemStats(oItem) + "\nSelect an item property.");
                }
                else if(nChoice == CHOICE_SETNAME)
                {
                    SetLocalInt(oPC, "Item_Name_Change", 1);
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                    SendMessageToPC(oPC, "Please state (use chat) the new name of the item.");
                }
                else
                {
                    nType = nChoice;
                    SetLocalInt(oPC, PRC_CRAFT_TYPE, nType);
                    sSubtype = Get2DACache("itempropdef", "SubTypeResRef", nType);
                    SetLocalString(oPC, PRC_CRAFT_SUBTYPE, sSubtype);
                    sCostTable = Get2DACache("itempropdef", "CostTableResRef", nType);
                    if(sCostTable == "0")   //IPRP_BASE1 is blank
                        sCostTable = "";
                    if(sCostTable != "")
                        sCostTable = Get2DACache("iprp_costtable", "Name", StringToInt(sCostTable));
                    SetLocalString(oPC, PRC_CRAFT_COSTTABLE, sCostTable);
                    sParam1 = Get2DACache("itempropdef", "Param1ResRef", nType);
                    if(sParam1 != "")
                        sParam1 = Get2DACache("iprp_paramtable", "TableResRef", StringToInt(sParam1));
                    SetLocalString(oPC, PRC_CRAFT_PARAM1, sParam1);

                    nPropList = 0;
                    if(sSubtype != "")
                        nPropList |= HAS_SUBTYPE;
                    if(sCostTable != "")
                        nPropList |= HAS_COSTTABLE;
                    if(sParam1 != "")
                        nPropList |= HAS_PARAM1;
                    SetLocalInt(oPC, PRC_CRAFT_PROPLIST, nPropList);

                    nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                }
                break;
            }
            case STAGE_SELECT_SUBTYPE:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                else
                {
                    nSubTypeValue = nChoice;
                    if(nType == ITEM_PROPERTY_ON_HIT_PROPERTIES)    //Param1 depends on subtype
                    {
                        sParam1 = Get2DACache(sSubtype, "Param1ResRef", nSubTypeValue);
                        if(sParam1 != "")   //if subtype has a Param1
                        {
                            sParam1 = Get2DACache("iprp_paramtable", "TableResRef", StringToInt(sParam1));
                            nPropList |= HAS_PARAM1;
                        }
                        else //if(nPropList & HAS_PARAM1)
                            nPropList &= (~HAS_PARAM1);
                        SetLocalString(oPC, PRC_CRAFT_PARAM1, sParam1);
                        SetLocalInt(oPC, PRC_CRAFT_PROPLIST, nPropList);
                    }
                    SetLocalInt(oPC, PRC_CRAFT_PROPLIST, nPropList);
                    SetLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE, nSubTypeValue);
                    nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                }
                break;
            }
            case STAGE_SELECT_COSTTABLEVALUE:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                else
                {
                    nCostTableValue = nChoice;
                    SetLocalInt(oPC, PRC_CRAFT_COSTTABLEVALUE, nCostTableValue);
                    nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                }
                break;
            }
            case STAGE_SELECT_PARAM1VALUE:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                else
                {
                    nParam1Value = nChoice;
                    SetLocalInt(oPC, PRC_CRAFT_PARAM1VALUE, nParam1Value);
                    nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                }
                break;
            }
            case STAGE_CONFIRM:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                if(nChoice == CHOICE_CONFIRM)
                {
                    itemproperty ip = ConstructIP(nType, nSubTypeValue, nCostTableValue, nParam1Value);
                    IPSafeAddItemProperty(oItem, ip, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC);
                    TakeGoldFromCreature(GetLocalInt(oPC, PRC_CRAFT_COST), oPC, TRUE);
                    nStage = STAGE_SELECT_TYPE;
                    MarkStageNotSetUp(nStage, oPC);
                }
                break;
            }
            case STAGE_CRAFT_AC:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = STAGE_START;
                else
                {
                    SetLocalInt(oPC, PRC_CRAFT_AC, nChoice);
                    nStage = STAGE_CRAFT_MASTERWORK;
                }
                MarkStageNotSetUp(nStage, oPC);
                break;
            }
            case STAGE_CRAFT_MIGHTY:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = STAGE_START;
                else
                {
                    SetLocalInt(oPC, PRC_CRAFT_MIGHTY, nChoice);
                    nStage = STAGE_CRAFT_MASTERWORK;
                }
                MarkStageNotSetUp(nStage, oPC);
                break;
            }
            case STAGE_CRAFT_MASTERWORK:
            {   //automatically masterwork materials
                if(nChoice == CHOICE_BACK)
                {
                    if(nAC != -1)
                        nStage = STAGE_CRAFT_AC;
                    else if(nMighty != -1)
                        nStage = STAGE_CRAFT_MIGHTY;
                    else
                        nStage = STAGE_START;
                }
                else
                {
                    if((nChoice > PRC_CRAFT_FLAG_MASTERWORK) && (nChoice < PRC_CRAFT_FLAG_COLD_IRON))
                        nChoice |= PRC_CRAFT_FLAG_MASTERWORK;
                    SetLocalInt(oPC, PRC_CRAFT_MATERIAL, nChoice);
                    oNewItem = MakeMyItem(oPC, nBase, nAC, nChoice, nMighty);
                    SetIdentified(oNewItem, TRUE);  //just in case
                    SetLocalString(oPC, PRC_CRAFT_TAG, GetTag(oNewItem));
                    nStage = STAGE_CRAFT_CONFIRM;
                }
                MarkStageNotSetUp(nStage, oPC);
                break;
            }
            case STAGE_CRAFT_CONFIRM:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_CRAFT_MASTERWORK;
                    DestroyObject(oNewItem, 0.1);
                }
                else if(nChoice == CHOICE_CONFIRM)
                {
                    int nSkill = GetCraftingSkill(oNewItem);
                    int bCheck = FALSE;
                    TakeGold(GetLocalInt(oPC, PRC_CRAFT_COST), oPC);

                    if(GetIsSkillSuccessful(oPC, nSkill, GetCraftingDC(oNewItem)))
                    {
                        bCheck = (nMaterial & PRC_CRAFT_FLAG_MASTERWORK) ? GetIsSkillSuccessful(oPC, nSkill, 20) : TRUE;
                        if(bCheck)
                            CopyItem(oNewItem, oPC, TRUE);
                    }
                    ClearCurrentStage(oPC);
                }
                MarkStageNotSetUp(nStage, oPC);
                break;
            }
        }
        if(DEBUG) DoDebug("Next stage: " + IntToString(nStage));
        SetStage(nStage, oPC);
    }
}
