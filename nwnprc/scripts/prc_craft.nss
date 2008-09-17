/*
    prc_craft

    Dynamic conversation file for forge, modified from
        old psi_powconv, borrowed from prc_ccc

    By: Flaming_Sword
    Created: Jul 12, 2006
    Modified: Nov 5, 2007

    LIMITATIONS:
        ITEM_PROPERTY_BONUS_FEAT
            not all feats available, anything much higher killed the game
            some of the feats added can be silly (blame the 2das)
        IPRP_SPELLS
            anything involving this 2da file can only use the bioware spells
                since anything much higher produced TMIs
        Not all item properties have returning functions
        Needs updating if item property 2da files increase in size

    CHECK:
        89 properties with constants, 15 without
*/

#include "prc_craft_inc"
#include "inc_dynconv"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

//const int STAGE_                        = ;

const int STAGE_START                   = 0;
const int STAGE_SELECT_SUBTYPE          = 1;
const int STAGE_SELECT_COSTTABLEVALUE   = 2;
const int STAGE_SELECT_PARAM1VALUE      = 3;
const int STAGE_CONFIRM                 = 4;
const int STAGE_BANE                    = 5;

const int STAGE_CONFIRM_MAGIC           = 7;
const int STAGE_APPEARANCE              = 8;
const int STAGE_CLONE                   = 9;
const int STAGE_APPEARANCE_LIST         = 10;
const int STAGE_APPEARANCE_VALUE        = 11;
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
const int CHOICE_SETAPPEARANCE          = 20007;
const int CHOICE_CLONE                  = 20008;

const int CHOICE_APPEARANCE_SHOUT       = 20009;
const int CHOICE_APPEARANCE_SELECT      = 20010;

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
const string PRC_CRAFT_XP               = "PRC_CRAFT_XP";
const string PRC_CRAFT_TIME             = "PRC_CRAFT_TIME";
//const string PRC_CRAFT_BLUEPRINT        = "PRC_CRAFT_BLUEPRINT";
const string PRC_CRAFT_CONVO_           = "PRC_CRAFT_CONVO_";
const string PRC_CRAFT_BASEITEMTYPE     = "PRC_CRAFT_BASEITEMTYPE";
const string PRC_CRAFT_AC               = "PRC_CRAFT_AC";
const string PRC_CRAFT_MIGHTY           = "PRC_CRAFT_MIGHTY";
const string PRC_CRAFT_MATERIAL         = "PRC_CRAFT_MATERIAL";
const string PRC_CRAFT_TAG              = "PRC_CRAFT_TAG";
const string PRC_CRAFT_LINE             = "PRC_CRAFT_LINE";
const string PRC_CRAFT_FILE             = "PRC_CRAFT_FILE";

const string PRC_CRAFT_MAGIC_ENHANCE    = "PRC_CRAFT_MAGIC_ENHANCE";
const string PRC_CRAFT_MAGIC_ADDITIONAL = "PRC_CRAFT_MAGIC_ADDITIONAL";
const string PRC_CRAFT_MAGIC_EPIC       = "PRC_CRAFT_MAGIC_EPIC";

const string PRC_CRAFT_SCRIPT_STATE     = "PRC_CRAFT_SCRIPT_STATE";

const string ARTIFICER_PREREQ_RACE      = "ARTIFICER_PREREQ_RACE";
const string ARTIFICER_PREREQ_ALIGN     = "ARTIFICER_PREREQ_ALIGN";
const string ARTIFICER_PREREQ_CLASS     = "ARTIFICER_PREREQ_CLASS";
const string ARTIFICER_PREREQ_SPELL1    = "ARTIFICER_PREREQ_SPELL1";
const string ARTIFICER_PREREQ_SPELL2    = "ARTIFICER_PREREQ_SPELL2";
const string ARTIFICER_PREREQ_SPELL3    = "ARTIFICER_PREREQ_SPELL3";
const string ARTIFICER_PREREQ_SPELLOR1  = "ARTIFICER_PREREQ_SPELLOR1";
const string ARTIFICER_PREREQ_SPELLOR2  = "ARTIFICER_PREREQ_SPELLOR2";
const string ARTIFICER_PREREQ_COMPLETE  = "ARTIFICER_PREREQ_COMPLETE";

const int PRC_CRAFT_STATE_NORMAL        = 1;
const int PRC_CRAFT_STATE_MAGIC         = 2;

const string PRC_CRAFT_HB               = "PRC_CRAFT_HB";

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

//hardcoded to save time/prevent tmi
int SkipLineSpells(int i)
{
    switch(i)
    {
        case 328: i = 345; break;
        case 359: i++; break;
        case 400: i = 450; break;
        case 487: i = 511; break;
        case 513: i++; break;
        case 521: i = 538; break;
        case 540: i = 899; break;
        case 948: i = 1000; break;
        case 1390: i = 1416; break;
    }
    return i;
}

//hardcoded to save time/prevent tmi
int SkipLineItemprops(int i)
{
    switch(i)
    {
        case 94: i = 100; break;
        case 102: i = 150; break;
        case 151: i = 200; break;
    }
    return i;
}

//Adds names to a list based on sTable (2da), delayed recursion
//  to avoid TMI
void PopulateList(object oPC, int MaxValue, int bSort, string sTable, object oItem = OBJECT_INVALID, int i = 0)
{
    if(GetLocalInt(oPC, "DynConv_Waiting") == FALSE)
        return;
    if(i <= MaxValue)
    {
        int bValid = TRUE;
        string sTemp = "";
        if(sTable == "iprp_spells")
            i = SkipLineSpells(i);
        else if(sTable == "itempropdef")
        {
            i = SkipLineItemprops(i);
            bValid = ValidProperty(oItem, i);
            if(bValid)
                bValid = !GetPRCSwitch("PRC_CRAFT_DISABLE_itempropdef_" + IntToString(i));
        }
        else if(GetStringLeft(sTable, 6) == "craft_")
            bValid = array_get_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i);
        sTemp = Get2DACache(sTable, "Name", i);
        if((sTemp != "") && bValid)//this is going to kill
        {
            if(sTable == "iprp_spells")
            {
                string sIndex = Get2DACache(sTable, "SpellIndex", i);
                if(sIndex != GetLocalString(oPC, "LastSpell"))
                {   //don't add if it's a repeat
                    if(bSort)   AddToTempList(oPC, ActionString(GetStringByStrRef(StringToInt(sTemp))), i);
                    else        AddChoice(ActionString(GetStringByStrRef(StringToInt(sTemp))), i, oPC);
                    SetLocalString(oPC, "LastSpell", sIndex);
                }
            }
            else
            {
                if(bSort)   AddToTempList(oPC, ActionString(GetStringByStrRef(StringToInt(sTemp))), i);
                else        AddChoice(ActionString(GetStringByStrRef(StringToInt(sTemp))), i, oPC);
            }

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
    DelayCommand(0.01, PopulateList(oPC, MaxValue, bSort, sTable, oItem, i + 1));
}

//use heartbeat
void ApplyProperties(object oPC, object oItem, itemproperty ip, int nCost, int nXP, string sFile, int nLine)
{
    if(GetGold(oPC) < nCost)
    {
        FloatingTextStringOnCreature("Crafting: Insufficient gold!", oPC);
        return;
    }
    int nHD = GetHitDice(oPC);
    int nMinXP = nHD * (nHD - 1) * 500;
    int nCurrentXP = GetXP(oPC);
    if((nCurrentXP - nMinXP) < nXP)
    {
        FloatingTextStringOnCreature("Crafting: Insufficient XP!", oPC);
        return;
    }
    if(GetItemPossessor(oItem) != oPC)
    {
        FloatingTextStringOnCreature("Crafting: You do not have the item!", oPC);
        return;
    }
    if(nLine == -1)
        IPSafeAddItemProperty(oItem, ip, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    else if(nLine == -2)
    {   //clone item
        CopyItem(oItem, oPC, TRUE);
    }
    else
    {
        string sPropertyType = Get2DACache(sFile, "PropertyType", nLine);
        if(sPropertyType == "M")
        {   //checking required spells
            if(!CheckCraftingSpells(oPC, sFile, nLine, TRUE))
            {
                FloatingTextStringOnCreature("Crafting: Required spells not available!", oPC);
                return;
            }
        }
        else if(sPropertyType == "P")
        {
            if(!CheckCraftingPowerPoints(oPC, sFile, nLine, TRUE))
            {
                FloatingTextStringOnCreature("Crafting: Insufficient power points!", oPC);
                return;
            }
        }
        ApplyItemProps(oItem, sFile, nLine);
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC);
    TakeGoldFromCreature(nCost, oPC, TRUE);
    SetXP(oPC, GetXP(oPC) - nXP);
}

int ArtificerPrereqCheck(object oPC, string sFile, int nLine, int nCost)
{
    string sTemp, sSub, sSpell;
    int nRace, nAlignGE, nAlignLC, nClass, i, j, bBreak, nLength, nPosition, nTemp;
    int nSpell1, nSpell2, nSpell3, nSpellOR1, nSpellOR2;
    int nDays = nCost / 1000;   //one set of UMD checks per "day" spent crafting
    if(nCost % 1000) nDays++;
    sTemp = Get2DACache(sFile, "PrereqMisc", nLine);
    sSpell = Get2DACache(sFile, "Spells", nLine);
    if(sTemp == "")
    {
        bBreak = TRUE;
        nRace = -1;
        nAlignGE = -1;
        nAlignLC = -1;
        nClass = -1;
    }
    nLength = GetStringLength(sTemp);
    for(i = 0; i < 5; i++)
    {
        if(bBreak)
            break;
        nPosition = FindSubString(sTemp, "_");
        sSub = (nPosition == -1) ? sTemp : GetStringLeft(sTemp, nPosition);
        nLength -= (nPosition + 1);
        if(sSub == "*")
            nTemp = -1;
        else
            nTemp = StringToInt(sSub);
        switch(i)
        {
            case 0:
            {
                nRace = (MyPRCGetRacialType(oPC) == nTemp) ? -1 : nTemp;
                break;
            }
            case 1:
            {
                //can't emulate feat requirement
                break;
            }
            case 2:
            {
                nAlignGE = -1;
                if(sSub == "G") nAlignGE = (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) ? -1 : ALIGNMENT_GOOD;
                else if(sSub == "E") nAlignGE = (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL) ? -1 : ALIGNMENT_EVIL;
                else if(sSub == "N") nAlignGE = (GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL) ? -1 : ALIGNMENT_NEUTRAL;
                break;
            }
            case 3:
            {
                nAlignLC = -1;
                if(sSub == "L") nAlignLC = (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL) ? -1 : ALIGNMENT_LAWFUL;
                if(sSub == "C") nAlignLC = (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC) ? -1 : ALIGNMENT_CHAOTIC;
                if(sSub == "N") nAlignLC = (GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL) ? -1 : ALIGNMENT_NEUTRAL;
                break;
            }
            case 4:
            {
                nClass = (GetLevelByClass(nTemp, oPC)) ? -1 : nTemp;
                break;
            }
        }
        sTemp = GetSubString(sTemp, nPosition + 1, nLength);
    }
    if(sSpell == "")
    {
        nSpell1 = -1;
        nSpell2 = -1;
        nSpell3 = -1;
        nSpellOR1 = -1;
        nSpellOR2 = -1;
    }
    else
    {
        for(i = 0; i < 5; i++)
        {
            nPosition = FindSubString(sTemp, "_");
            sSub = (nPosition == -1) ? sTemp : GetStringLeft(sTemp, nPosition);
            nLength -= (nPosition + 1);
            if(sSub == "*")
                nTemp = -1;
            else
            {
                nTemp = StringToInt(sSub);
                switch(i)
                {
                    case 0:
                    {   //storing the spell level and assuming it's a valid number
                        nSpell1 = (PRCGetHasSpell(nTemp, oPC)) ? -1 : StringToInt(Get2DACache("spells", "Innate", nTemp)) + 20;
                        break;
                    }
                    case 1:
                    {
                        nSpell2 = (PRCGetHasSpell(nTemp, oPC)) ? -1 : StringToInt(Get2DACache("spells", "Innate", nTemp)) + 20;
                        break;
                    }
                    case 2:
                    {
                        nSpell3 = (PRCGetHasSpell(nTemp, oPC)) ? -1 : StringToInt(Get2DACache("spells", "Innate", nTemp)) + 20;
                        break;
                    }
                    case 3:
                    {
                        nSpellOR1 = (PRCGetHasSpell(nTemp, oPC)) ? -1 : StringToInt(Get2DACache("spells", "Innate", nTemp)) + 20;
                        break;
                    }
                    case 4:
                    {
                        nSpellOR2 = (PRCGetHasSpell(nTemp, oPC)) ? -1 : StringToInt(Get2DACache("spells", "Innate", nTemp)) + 20;
                        break;
                    }
                }
            }
            sTemp = GetSubString(sTemp, nPosition + 1, nLength);
        }
    }
    int bTake10 = GetHasFeat(FEAT_SKILL_MASTERY_ARTIFICER, oPC) ? 10 : -1;
    for(i = 0; i <= nDays; i++) //with extra last-ditch roll
    {
        if((nRace == -1) &&
            (nAlignGE == -1) &&
            (nAlignLC == -1) &&
            (nClass == -1) &&
            (nSpell1 == -1) &&
            (nSpell2 == -1) &&
            (nSpell3 == -1) &&
            (nSpellOR1 == -1) &&
            (nSpellOR2 == -1)
            )
            return TRUE;

        if(nRace == -1)     nRace       = (GetPRCIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, 25, bTake10)) ? -1 : nRace;
        if(nAlignGE == -1)  nAlignGE    = (GetPRCIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, 30, bTake10)) ? -1 : nAlignGE;
        if(nAlignLC == -1)  nAlignLC    = (GetPRCIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, 30, bTake10)) ? -1 : nAlignLC;
        if(nClass == -1)    nClass      = (GetPRCIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, 21, bTake10)) ? -1 : nClass;
        if(nSpell1 == -1)   nSpell1     = (GetPRCIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, nSpell1, bTake10)) ? -1 : nSpell1;
        if(nSpell2 == -1)   nSpell2     = (GetPRCIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, nSpell2, bTake10)) ? -1 : nSpell2;
        if(nSpell3 == -1)   nSpell3     = (GetPRCIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, nSpell3, bTake10)) ? -1 : nSpell3;
        if(nSpellOR1 == -1) nSpellOR1   = (GetPRCIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, nSpellOR1, bTake10)) ? -1 : nSpellOR1;
        if(nSpellOR2 == -1) nSpellOR2   = (GetPRCIsSkillSuccessful(oPC, SKILL_USE_MAGIC_DEVICE, nSpellOR2, bTake10)) ? -1 : nSpellOR2;
    }
    if((nRace == -1) &&
        (nAlignGE == -1) &&
        (nAlignLC == -1) &&
        (nClass == -1) &&
        (nSpell1 == -1) &&
        (nSpell2 == -1) &&
        (nSpell3 == -1) &&
        (nSpellOR1 == -1) &&
        (nSpellOR2 == -1)
        )
        return TRUE;
    else
        return FALSE;   //made all the UMD rolls allocated and still failed
}

void CraftingHB(object oPC, object oItem, itemproperty ip, int nCost, int nXP, string sFile, int nLine, int nRounds)
{
    if(GetBreakConcentrationCheck(oPC))
    {
        FloatingTextStringOnCreature("Crafting: Concentration lost!", oPC);
        DeleteLocalInt(oPC, PRC_CRAFT_HB);
        return;
    }
    if(nRounds == 0 || GetPCPublicCDKey(oPC) == "") //default to zero time if single player
    {
        if(GetLevelByClass(CLASS_TYPE_ARTIFICER, oPC))
        {
            if(!ArtificerPrereqCheck(oPC, sFile, nLine, nCost))
            {
                FloatingTextStringOnCreature("Crafting Failed!", oPC);
                DeleteLocalInt(oPC, PRC_CRAFT_HB);
                TakeGoldFromCreature(nCost, oPC, TRUE);
                SetXP(oPC, max(GetXP(oPC) - nXP, GetHitDice(oPC) * (GetHitDice(oPC) - 1) * 500));   //can't delevel
                return;
            }
        }
        FloatingTextStringOnCreature("Crafting Complete!", oPC);
        DeleteLocalInt(oPC, PRC_CRAFT_HB);
        ApplyProperties(oPC, oItem, ip, nCost, nXP, sFile, nLine);
    }
    else
    {
        FloatingTextStringOnCreature("Crafting: " + IntToString(nRounds) + " round(s) remaining", oPC);
        DelayCommand(6.0, CraftingHB(oPC, oItem, ip, nCost, nXP, sFile, nLine, nRounds - 1));
    }
}

void main()
{
    object oTarget = GetSpellTargetObject();
    object oPC = OBJECT_SELF;//GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    if(GetLocalInt(oPC, "PRC_CRAFT_TERMINATED"))
    {
        SendMessageToPC(oPC, "Error Recovery: Please try again");
        SetLocalInt(oPC, DYNCONV_VARIABLE, 0);
        DeleteLocalInt(oPC, "PRC_CRAFT_TERMINATED");
        DeleteLocalInt(oPC, "DynConv_Waiting");
        AllowExit(DYNCONV_EXIT_FORCE_EXIT);
        return;
    }
    if(DEBUG) DoDebug("prc_craft: nValue = " + IntToString(nValue));
    if(nValue == 0)
    {   //as part of a cast spell and not in the convo
        if(GetPRCSwitch(PRC_DISABLE_CRAFT))
        {
            SendMessageToPC(oPC, "Crafting has been disabled.");
            return;
        }
        if(GetLocalInt(GetArea(oPC), PRC_AREA_DISABLE_CRAFTING) != GetPRCSwitch(PRC_AREA_DISABLE_CRAFTING_INVERT))
        {
            SendMessageToPC(oPC, "Crafting has been disabled in this area.");
            return;
        }
        if(GetLocalInt(oPC, PRC_CRAFT_HB))
        {
            SendMessageToPC(oPC, "You are already crafting an item.");
            return;
        }
        if(oTarget == OBJECT_SELF)
        {   //cast on self, crafting non-magical items
            SetLocalInt(OBJECT_SELF, PRC_CRAFT_SCRIPT_STATE, PRC_CRAFT_STATE_NORMAL);
        }
        else if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
        {   //cast on item, crafting targeted item
            int nFeat = GetCraftingFeat(oTarget);
            int bToken = 0;
            if(GetPlotFlag(oTarget) || nFeat == -1)
            {
                SendMessageToPC(oPC, "You cannot craft this item.");
                return;
            }
            location lLoc = GetLocation(oPC);
            object oContainer = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lLoc, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
            string sToken = PRC_CRAFT_TOKEN;
            while(GetIsObjectValid(oContainer))
            {
                if(!GetIsPC(oContainer) && GetHasInventory(oContainer))
                {
                    if(GetIsObjectValid(GetItemPossessedBy(oContainer, sToken)))
                    {
                        SetLocalInt(oPC, PRC_CRAFT_TOKEN, 1);
                        bToken = 1;
                        break;
                    }
                }
                oContainer = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lLoc, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
            }
            if(!GetHasFeat(nFeat, oPC) && !bToken)
            {
                SendMessageToPC(oPC, "You do not have the required feat to craft this item.");
                return;
            }/*
            if(!GetPRCSwitch(PRC_CRAFTING_ARBITRARY))
            {
                int nBase = GetBaseItemType(oTarget);
                if(nFeat == FEAT_CRAFT_ARMS_ARMOR)
                {
                    if((!(GetMaterialString(StringToInt(sMaterial)) == sMaterial && sMaterial != "000") && !GetIsMagicItem(oTarget)))
                    {
                        SendMessageToPC(oPC, "This is not a craftable magic item.");
                        return;
                    }
                }
                else if(StringToInt(Get2DACache("prc_craft_gen_it", "Type", GetBaseItemType(oTarget))) == PRC_CRAFT_ITEM_TYPE_CASTSPELL)
                {
                    SendMessageToPC(oPC, "This item must be crafted by casting spells on it.");
                    return;
                }
                else if(GetIsMagicItem(oTarget))
                {
                    SendMessageToPC(oPC, "This is not a craftable magic item.");
                    return;
                }
            }*/
            SetLocalInt(OBJECT_SELF, PRC_CRAFT_SCRIPT_STATE, PRC_CRAFT_STATE_MAGIC);
            SetLocalObject(OBJECT_SELF, PRC_CRAFT_ITEM, oTarget);
        }
        StartDynamicConversation("prc_craft", OBJECT_SELF, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE);
        return;
    }
    int nStage = GetStage(oPC);
    //in case the script execution is screwed somehow
    SetLocalInt(oPC, "PRC_CRAFT_TERMINATED", 1);

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
    int nXP = GetLocalInt(oPC, PRC_CRAFT_XP);
    int nTime = GetLocalInt(oPC, PRC_CRAFT_TIME);
    int nMaterial = GetLocalInt(oPC, PRC_CRAFT_MATERIAL);
    int nMighty = GetLocalInt(oPC, PRC_CRAFT_MIGHTY);
    int nPropList = GetLocalInt(oPC, PRC_CRAFT_PROPLIST);
    int nState = GetLocalInt(oPC, PRC_CRAFT_SCRIPT_STATE);
    int bToken = GetLocalInt(oPC, PRC_CRAFT_TOKEN);

    string sFile = GetLocalString(oPC, PRC_CRAFT_FILE);

    int nEnhancement = GetLocalInt(oPC, PRC_CRAFT_MAGIC_ENHANCE);
    int nAdditional = GetLocalInt(oPC, PRC_CRAFT_MAGIC_ADDITIONAL);
    int nEpic = GetLocalInt(oPC, PRC_CRAFT_MAGIC_EPIC);

    int nLine = GetLocalInt(oPC, PRC_CRAFT_LINE);


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
                        PopulateList(oPC, PRCGetFileEnd("prc_craft_gen_it"), TRUE, "prc_craft_gen_it");
                    }
                    else if(nState == PRC_CRAFT_STATE_MAGIC)
                    {
                        int nCasterLevel = max(GetLevelByTypeArcane(), GetLevelByTypeDivine());
                        int nBaseItem = GetBaseItemType(oItem);
                        int bAllow = TRUE;
                        sFile = GetCrafting2DA(oItem);
                        string sMaterial = GetStringLeft(GetTag(oItem), 3);
                        SetLocalString(oPC, PRC_CRAFT_FILE, sFile);
                        int nFeat = GetCraftingFeat(oItem);
                        int bEpic = (GetHasFeat(GetEpicCraftingFeat(nFeat), oPC) && (!GetPRCSwitch(PRC_DISABLE_CRAFT_EPIC)));
                        if(bToken)
                            sTemp = "Using crafting facilities\n\n";
                        sTemp += ItemStats(oItem) + "\nPlease make a selection.";
                        SetHeader(ItemStats(oItem) + "\nPlease make a selection.");
                        struct itemvars strTemp = GetItemVars(oPC, oItem, sFile, bEpic, 1);
                        SetLocalInt(oPC, PRC_CRAFT_MAGIC_ENHANCE, strTemp.enhancement);
                        SetLocalInt(oPC, PRC_CRAFT_MAGIC_ADDITIONAL, strTemp.additionalcost);
                        SetLocalInt(oPC, PRC_CRAFT_MAGIC_EPIC, strTemp.epic);
                        AddChoice(ActionString("Change Name"), CHOICE_SETNAME, oPC);
                        AddChoice(ActionString("Change Appearance"), CHOICE_SETAPPEARANCE, oPC);
                        if(!GetPRCSwitch(PRC_CRAFTING_ARBITRARY))
                        {
                            if(nFeat == FEAT_CRAFT_ARMS_ARMOR)
                            {
                                if((!(GetMaterialString(StringToInt(sMaterial)) == sMaterial && sMaterial != "000") && !GetIsMagicItem(oItem)))
                                    bAllow = FALSE;
                            }
                            else if(GetIsMagicItem(oItem))
                                    bAllow = FALSE;
                        }
                        if(bAllow)
                            if(StringToInt(Get2DACache("prc_craft_gen_it", "Type", GetBaseItemType(oTarget))) == PRC_CRAFT_ITEM_TYPE_CASTSPELL)
                                bAllow = FALSE;
                        if(bAllow)
                        {
                            AddChoice(ActionString("Clone Item"), CHOICE_CLONE, oPC);
                            SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                            SetLocalInt(oPC, PRC_CRAFT_TYPE, -1);
                            SetLocalString(oPC, PRC_CRAFT_SUBTYPE, "");
                            SetLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE, -1);
                            SetLocalString(oPC, PRC_CRAFT_COSTTABLE, "");
                            SetLocalInt(oPC, PRC_CRAFT_COSTTABLEVALUE, -1);
                            SetLocalString(oPC, PRC_CRAFT_PARAM1, "");
                            SetLocalInt(oPC, PRC_CRAFT_PARAM1VALUE, -1);
                            if(GetPRCSwitch(PRC_CRAFTING_ARBITRARY))
                            {
                                sFile = "itempropdef";
                                SetLocalString(oPC, PRC_CRAFT_FILE, sFile);
                                PopulateList(oPC, NUM_MAX_PROPERTIES, TRUE, sFile, oItem);
                            }
                            else if(sFile == "")
                            {
                                sFile = "iprp_spells";
                                SetLocalInt(oPC, PRC_CRAFT_TYPE, ITEM_PROPERTY_CAST_SPELL);
                                PopulateList(oPC, PRCGetFileEnd(sFile), TRUE, sFile);
                            }
                            else
                            {
                                PopulateList(oPC, PRCGetFileEnd(sFile), FALSE, sFile);
                                //don't copy the item if we're using bioware crafting (it gets copied later)
                                string sMaterial = GetStringLeft(GetTag(oTarget), 3);
                                object oChest = GetCraftChest();
                                string sTag = sMaterial + GetUniqueID() + PRC_CRAFT_UID_SUFFIX;
                                while(GetIsObjectValid(GetItemPossessedBy(oChest, sTag)))//make sure there aren't any tag conflicts
                                    sTag = sMaterial + GetUniqueID() + PRC_CRAFT_UID_SUFFIX;    //may choke if all uids are taken :P
                                oNewItem = CopyObject(oItem, GetLocation(oChest), oChest, sTag);
                                SetIdentified(oNewItem, TRUE);  //just in case
                                SetLocalString(oPC, PRC_CRAFT_TAG, GetTag(oNewItem));
                            }
                        }
                    }
                    SetDefaultTokens();
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
                    MarkStageSetUp(nStage, oPC);
                    SetCustomToken(DYNCONV_TOKEN_EXIT, ActionString("Leave"));
                    SetCustomToken(DYNCONV_TOKEN_NEXT, ActionString("Next"));
                    SetCustomToken(DYNCONV_TOKEN_PREV, ActionString("Previous"));
                    break;
                }
                case STAGE_SELECT_SUBTYPE:
                {
                    SetHeader("Select a subtype.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, PRCGetFileEnd(sSubtype), TRUE, sSubtype);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_SELECT_COSTTABLEVALUE:
                {
                    SetHeader("Select a costtable value.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, PRCGetFileEnd(sCostTable), FALSE, sCostTable);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_SELECT_PARAM1VALUE:
                {
                    SetHeader("Select a param1 value.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, PRCGetFileEnd(sParam1), FALSE, sParam1);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CONFIRM:
                {
                    itemproperty ip = ConstructIP(nType, nSubTypeValue, nCostTableValue, nParam1Value);
                    IPSafeAddItemProperty(oNewItem, ip, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
                    nTemp = GetGoldPieceValue(oNewItem) - GetGoldPieceValue(oItem);
                    int nTime = GetCraftingTime(nTemp);
                    int nTemp2 = 0;
                    if(!bToken)
                    {
                        nTemp /= 2;
                        nTemp2 = nTemp / 25;
                        if(nTemp2 < 1) nTemp2 = 1;
                    }
                    if(nTemp < 1) nTemp = 1;
                    SetLocalInt(oPC, PRC_CRAFT_COST, nTemp);
                    SetLocalInt(oPC, PRC_CRAFT_XP, nTemp2);
                    sTemp = GetItemPropertyString(ip);
                    sTemp += "\nCost: " + IntToString(nTemp) + "gp " + IntToString(nTemp2) + "XP";
                    if(nTime > 0)
                        sTemp += "\nTime: " + IntToString(nTime) + " rounds";
                    SetHeader("You have selected:\n\n" + sTemp + "\n\nPlease confirm your selection.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    int nHD = GetHitDice(oPC);
                    int nMinXP = nHD * (nHD - 1) * 500;
                    int nCurrentXP = GetXP(oPC);
                    if(GetGold(oPC) >= nTemp && (nCurrentXP - nMinXP) >= nTemp2)
                        AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_BANE:
                {
                    SetHeader("Select a racial type.");
                    AllowExit(DYNCONV_EXIT_NOT_ALLOWED, FALSE, oPC);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, PRCGetFileEnd("racialtypes"), TRUE, "racialtypes");
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
                    nTemp = StringToInt(Get2DACache("prc_craft_gen_it", "Type", nBase));
                    if(!(
                        ((nBase == BASE_ITEM_ARMOR) && (!nAC)) ||
                        (nTemp == PRC_CRAFT_ITEM_TYPE_MISC) ||
                        (nTemp == PRC_CRAFT_ITEM_TYPE_CASTSPELL)
                        )
                        )
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
                        /* NOT IMPLEMENTED YET
                        if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_METAL))
                            AddChoice(ActionString("Mundane Crystal"), PRC_CRAFT_FLAG_MUNDANE_CRYSTAL, oPC);
                        if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_METAL))
                            AddChoice(ActionString("Deep Crystal"), PRC_CRAFT_FLAG_DEEP_CRYSTAL, oPC);
                        */
                    }
                    else if((nBase == BASE_ITEM_ARMOR) && (!nAC))
                        AddChoice(ActionString("Masterwork"), PRC_CRAFT_FLAG_MASTERWORK, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_CONFIRM:
                {   //PHB item prices stored in baseitems.2da
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
                    struct itemvars strTemp;
                    strTemp.item = oNewItem;
                    nTemp = GetPnPItemCost(strTemp);
                    int nScale = GetPRCSwitch(PRC_CRAFTING_MUNDANE_COST_SCALE);
                    if(nScale > 0)
                    {
                        nTemp = FloatToInt(IntToFloat(nTemp) * IntToFloat(nScale) / 100.0);
                    }
                    nTemp /= 3;

                    if(nTemp < 1) nTemp = 1;
                    SetLocalInt(oPC, PRC_CRAFT_COST, nTemp);
                    SetHeader("You have chosen to craft:\n\n" + ItemStats(oNewItem) + "\nPrice: " + IntToString(nTemp) + "gp");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    if(GetGold(oPC) >= nTemp)
                        AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    //DestroyObject(oNewItem);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CONFIRM_MAGIC:
                {
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
                    int nCostDiff;
                    int nXPDiff = 0;
                    struct itemvars strTempOld, strTempNew;
                    int nFeat = GetCraftingFeat(oItem);
                    if(nFeat == FEAT_CRAFT_ARMS_ARMOR)
                    {
                        ApplyItemProps(oNewItem, sFile, nLine);
                        strTempOld.item = oItem;
                        strTempOld.enhancement = nEnhancement;
                        strTempOld.additionalcost = nAdditional;
                        strTempOld.epic = nEpic;
                        strTempNew = GetItemVars(oPC, oNewItem, sFile);
                        if(nEnhancement > 10 || strTempNew.enhancement > 10) strTempNew.epic = TRUE;
                        int nCostOld = GetPnPItemCost(strTempOld, FALSE);
                        int nCostNew = GetPnPItemCost(strTempNew, FALSE);
                        nCostDiff = nCostNew - nCostOld;    //assumes cost increases with addition of itemprops :P
                        if(!bToken)
                        {
                            int nXPOld = GetPnPItemXPCost(nCostOld, nEpic);
                            int nXPNew = GetPnPItemXPCost(nCostNew, strTempNew.epic);
                            nXPDiff = nXPNew - nXPOld;
                        }
                    }
                    else
                    {
                        nCostDiff = StringToInt(Get2DACache(sFile, "AdditionalCost", nLine));
                        nCostDiff = GetModifiedGoldCost(nCostDiff, oPC, nFeat);
                        if(!bToken)
                            nXPDiff = GetPnPItemXPCost(nCostDiff, StringToInt(Get2DACache(sFile, "Epic", nLine)));
                    }
                    int nTime = GetCraftingTime(nCostDiff);

                    if(!bToken)
                    {
                        nCostDiff /= 2;
                        nXPDiff /= 2;
                    }
                    nCostDiff = GetModifiedGoldCost(nCostDiff, oPC, nFeat);
                    nXPDiff = GetModifiedXPCost(nXPDiff, oPC, nFeat);
                    nTime = GetModifiedTimeCost(nTime, oPC, nFeat);
                    if(nCostDiff < 1) nCostDiff = 1;
                    if(nXPDiff < 0) nXPDiff = 0;
                    SetLocalInt(oPC, PRC_CRAFT_COST, nCostDiff);
                    SetLocalInt(oPC, PRC_CRAFT_XP, nXPDiff);
                    SetLocalInt(oPC, PRC_CRAFT_TIME, nTime);
                    sTemp += GetStringByStrRef(StringToInt(Get2DACache(sFile, "Name", nLine)));
                    sTemp += "\n\n";
                    sTemp += GetStringByStrRef(StringToInt(Get2DACache(sFile, "Description", nLine)));
                    //sTemp += "\n\n";
                    //sTemp += ItemStats(oNewItem);
                    sTemp += "\nCost: " + IntToString(nCostDiff) + "gp " + IntToString(nXPDiff) + "XP";
                    if(nTime > 0)
                        sTemp += "\nTime: " + IntToString(nTime) + " rounds";
                    SetHeader("You have selected:\n\n" + sTemp + "\n\nPlease confirm your selection.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);

                    int nHD = GetHitDice(oPC);
                    int nMinXP = nHD * (nHD - 1) * 500;
                    int nCurrentXP = GetXP(oPC);

                    if(GetGold(oPC) >= nCostDiff && (nCurrentXP - nMinXP) >= nXPDiff && CheckPrereq(oPC, nLine, GetHasFeat(GetEpicCraftingFeat(GetCraftingFeat(oItem)), oPC) && (!GetPRCSwitch(PRC_DISABLE_CRAFT_EPIC)), sFile, strTempNew))
                        AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    SetLocalInt(oPC, PRC_CRAFT_COST, nCostDiff);
                    SetLocalInt(oPC, PRC_CRAFT_XP, nXPDiff);
                    DestroyObject(oNewItem);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_APPEARANCE:
                {
                    sTemp = PRCGetItemAppearanceString(oPC, oItem);
                    SetHeader("Please make a selection.\n\nYour item appearance code is: \n\n" + sTemp);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    AddChoice(ActionString("Set new appearance code"), CHOICE_APPEARANCE_SHOUT, oPC);
                    //AddChoice(ActionString("Select new appearance"), CHOICE_APPEARANCE_SELECT, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CLONE:
                {
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
                    string sMaterial = GetStringLeft(GetTag(oTarget), 3);
                    int nFeat = GetCraftingFeat(oItem);
                    if(GetPRCSwitch(PRC_CRAFTING_ARBITRARY) || (GetMaterialString(StringToInt(sMaterial)) != sMaterial))
                    {
                        itemproperty ip = GetFirstItemProperty(oNewItem);
                        while(GetIsItemPropertyValid(ip))
                        {   //removing cost reducing itemprops
                            nType = GetItemPropertyType(ip);
                            if(nType >= 120 && nType <= 127)
                                RemoveItemProperty(oNewItem, ip);
                            ip = GetNextItemProperty(oNewItem);
                        }
                        nCost = GetGoldPieceValue(oNewItem);
                        nXP = nCost / 25;
                        if(nXP < 1) nXP = 1;
                        nTime = GetCraftingTime(nCost);
                    }
                    else
                    {
                        struct itemvars strTemp;
                        strTemp.item = oItem;
                        strTemp.enhancement = nEnhancement;
                        strTemp.additionalcost = nAdditional;
                        strTemp.epic = nEpic;
                        nCost = GetPnPItemCost(strTemp);
                        nXP = GetPnPItemXPCost(GetPnPItemCost(strTemp, FALSE), nEpic);
                        nTime = GetCraftingTime(nCost);
                    }
                    nCost = GetModifiedGoldCost(nCost, oPC, nFeat);
                    nXP = GetModifiedXPCost(nXP, oPC, nFeat);
                    nTime = GetModifiedTimeCost(nTime, oPC, nFeat);
                    if(nCost < 1) nCost = 1;
                    if(nXP < 0) nXP = 0;
                    SetLocalInt(oPC, PRC_CRAFT_COST, nCost);
                    SetLocalInt(oPC, PRC_CRAFT_XP, nXP);
                    SetLocalInt(oPC, PRC_CRAFT_TIME, nTime);
                    sTemp = "Do you want to clone this item?\n\nCost: " + IntToString(nCost) + "gp " + IntToString(nXP) + "XP";
                    if(nTime > 0)
                        sTemp += "\nTime: " + IntToString(nTime) + " rounds";
                    SetHeader(sTemp);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    int nHD = GetHitDice(oPC);
                    int nMinXP = nHD * (nHD - 1) * 500;
                    int nCurrentXP = GetXP(oPC);

                    if(GetGold(oPC) >= nCost && (nCurrentXP - nMinXP) >= nXP)
                        AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    DestroyObject(oNewItem);
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
        DeleteLocalString(oPC, PRC_CRAFT_TAG);
        DeleteLocalInt(oPC, PRC_CRAFT_AC);
        DeleteLocalInt(oPC, PRC_CRAFT_BASEITEMTYPE);
        DeleteLocalInt(oPC, PRC_CRAFT_COST);
        DeleteLocalInt(oPC, PRC_CRAFT_XP);
        DeleteLocalInt(oPC, PRC_CRAFT_TIME);
        DeleteLocalInt(oPC, PRC_CRAFT_MATERIAL);
        DeleteLocalInt(oPC, PRC_CRAFT_MIGHTY);
        DeleteLocalInt(oPC, PRC_CRAFT_SCRIPT_STATE);
        DestroyObject(oNewItem, 0.1);
        DeleteLocalInt(oPC, PRC_CRAFT_TAG);
        DeleteLocalInt(oPC, PRC_CRAFT_MAGIC_ENHANCE);
        DeleteLocalInt(oPC, PRC_CRAFT_MAGIC_ADDITIONAL);
        DeleteLocalInt(oPC, PRC_CRAFT_MAGIC_EPIC);
        DeleteLocalInt(oPC, PRC_CRAFT_LINE);
        DeleteLocalString(oPC, PRC_CRAFT_FILE);
        DeleteLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE);
        DeleteLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE_RACE);
        DeleteLocalInt(oPC, PRC_CRAFT_TOKEN);
        array_delete(oPC, PRC_CRAFT_ITEMPROP_ARRAY);
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
                }
                else if(nState == PRC_CRAFT_STATE_MAGIC)
                {
                    if(nChoice == CHOICE_SETNAME)
                    {
                        //nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                        object oListener = SpawnListener("prc_craft_listen", GetLocation(oPC), "**", oPC, 30.0f, TRUE);
                        SetLocalObject(oListener, PRC_CRAFT_ITEM, oItem);
                        SetLocalInt(oListener, PRC_CRAFT_LISTEN, PRC_CRAFT_LISTEN_SETNAME);
                        SendMessageToPC(oPC, "Please state (use chat) the new name of the item within the next 30 seconds.");
                        //ClearCurrentStage(oPC);
                        AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                        break;
                    }
                    else if(nChoice == CHOICE_SETAPPEARANCE)
                    {
                        nStage = STAGE_APPEARANCE;
                    }
                    else if(nChoice == CHOICE_CLONE)
                    {
                        nStage = STAGE_CLONE;
                    }
                    else
                    {
                        if(GetPRCSwitch(PRC_CRAFTING_ARBITRARY))
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
                        else if(sFile == "")
                        {
                            int nSpell = StringToInt(Get2DACache("iprp_spells", "SpellIndex", nChoice));
                            int bHasSpell = PRCGetHasSpell(nSpell, oPC);
                            int bFailed;
                            if(bHasSpell)
                            {
                                PRCDecrementRemainingSpellUses(oPC, nSpell);
                            }
                            else if(GetLevelByClass(CLASS_TYPE_ARTIFICER, oPC))
                            {
                                SetLocalInt(oPC, "ArtificerCrafting", TRUE);
                            }
                            //imbue item toggled by another feat
                            /*
                            else if(GetHasFeat(FEAT_IMBUE_ITEM, oPC))
                            {
                                SetLocalInt(oPC, "UsingImbueItem", TRUE);
                            }
                            */

                            switch(GetBaseItemType(oItem))
                            {
                                case BASE_ITEM_BLANK_POTION :
                                    // -------------------------------------------------
                                    // Brew Potion
                                    // -------------------------------------------------
                                   bFailed = CICraftCheckBrewPotion(oItem,oPC,nSpell);
                                   break;

                                case BASE_ITEM_BLANK_SCROLL :
                                   // -------------------------------------------------
                                   // Scribe Scroll
                                   // -------------------------------------------------
                                   bFailed = CICraftCheckScribeScroll(oItem,oPC,nSpell);
                                   break;

                                case BASE_ITEM_BLANK_WAND :
                                   // -------------------------------------------------
                                   // Craft Wand
                                   // -------------------------------------------------
                                   bFailed = CICraftCheckCraftWand(oItem,oPC,nSpell);
                                   break;

                                case BASE_ITEM_CRAFTED_ROD :
                                   // -------------------------------------------------
                                   // Craft Rod
                                   // -------------------------------------------------
                                   //bFailed = CICraftCheckCraftWand(oItem,oPC,nSpell);
                                   break;

                                case BASE_ITEM_CRAFTED_STAFF :
                                   // -------------------------------------------------
                                   // Craft Staff
                                   // -------------------------------------------------
                                   bFailed = CICraftCheckCraftStaff(oItem,oPC,nSpell);
                                   break;

                                default:
                                    if(GetLocalInt(oPC, "InscribeRune"))
                                    {
                                        bFailed = InscribeRune(oItem,oPC,nSpell);
                                    }
                                    else if (GetStringLeft(GetResRef(oTarget), 5) == "it_gem")
                                    {
                                        bFailed = AttuneGem(oItem,oPC,nSpell);
                                    }

                                    break;

/*
                                case BASE_ITEM_CRAFTED_STAFF :
                                   // -------------------------------------------------
                                   // Craft Staff
                                   // -------------------------------------------------
                                   CICraftCheckCraftStaff(oItem,oPC,nSpell);
                                   break;

                                case BASE_ITEM_CRAFTED_STAFF :
                                   // -------------------------------------------------
                                   // Craft Staff
                                   // -------------------------------------------------
                                   CICraftCheckCraftStaff(oItem,oPC,nSpell);
                                   break;*/
                            }
                            //do something different if we fail? retry?
                            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                            /*
                            //hardcoding of above for spells
                            sSubtype = "IPRP_SPELLS";
                            sCostTable = "IPRP_CHARGECOST";
                            SetLocalString(oPC, PRC_CRAFT_COSTTABLE, "3");
                            sCostTable = Get2DACache("itempropdef", "CostTableResRef", nType);
                            SetLocalInt(oPC, PRC_CRAFT_PROPLIST, 0);
                            SetLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE, nChoice);
                            nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                            */
                        }
                        else
                        {
                            SetLocalInt(oPC, PRC_CRAFT_LINE, nChoice);
                            nStage = STAGE_CONFIRM_MAGIC;
                            if(sFile == "craft_weapon" && (nChoice == 25 || nChoice == 26))
                            {
                                nStage = STAGE_BANE;
                            }
                        }
                    }
                }
                MarkStageNotSetUp(nStage, oPC);
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
                        else
                        {
                            nPropList &= (~HAS_PARAM1);
                        }
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
                    SetLocalInt(oPC, PRC_CRAFT_HB, 1);
                    int nDelay = GetCraftingTime(nCost);
                    CraftingHB(oPC, oItem, ip, nCost, nXP, sFile, -1, nDelay);
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }
                break;
            }
            case STAGE_BANE:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = STAGE_START;
                else
                {
                    nStage = STAGE_CONFIRM_MAGIC;
                    SetLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE_RACE, nChoice);
                }
                MarkStageNotSetUp(nStage, oPC);
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
                    MarkStageNotSetUp(nStage, oPC);
                }
                else
                {
                    if((nChoice > PRC_CRAFT_FLAG_MASTERWORK) && (nChoice <= PRC_CRAFT_FLAG_DEEP_CRYSTAL))
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
                    MarkStageNotSetUp(nStage, oPC);
                }
                else if(nChoice == CHOICE_CONFIRM)
                {
                    int nSkill = GetCraftingSkill(oNewItem);
                    int bCheck = FALSE;
                    TakeGold(GetLocalInt(oPC, PRC_CRAFT_COST), oPC);
                    if(GetCraftingFeat(oNewItem) != FEAT_CRAFT_ARMS_ARMOR)
                        CopyItem(oNewItem, oPC, TRUE);
                    else if(GetIsSkillSuccessful(oPC, nSkill, GetCraftingDC(oNewItem)))
                    {
                        bCheck = (nMaterial & PRC_CRAFT_FLAG_MASTERWORK) ? GetIsSkillSuccessful(oPC, nSkill, 20) : TRUE;
                        if(bCheck)
                            CopyItem(oNewItem, oPC, TRUE);
                    }
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }
                break;
            }
            case STAGE_CONFIRM_MAGIC:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    if(GetLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE))
                        nStage = STAGE_BANE;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else if(nChoice == CHOICE_CONFIRM)
                {
                    itemproperty ip;
                    SetLocalInt(oPC, PRC_CRAFT_HB, 1);
                    CraftingHB(oPC, oItem, ip, nCost, nXP, sFile, nLine, nTime);
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }
                break;
            }
            case STAGE_APPEARANCE:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else
                {
                    //code here
                    switch(nChoice)
                    {
                        case CHOICE_APPEARANCE_SHOUT:
                        {
                            object oListener = SpawnListener("prc_craft_listen", GetLocation(oPC), "**", oPC, 30.0f, TRUE);
                            SetLocalObject(oListener, PRC_CRAFT_ITEM, oItem);
                            SetLocalInt(oListener, PRC_CRAFT_LISTEN, PRC_CRAFT_LISTEN_SETAPPEARANCE);
                            SendMessageToPC(oPC, "Please state (use chat) the new item appearance code within the next 30 seconds.");
                            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                        }
                        case CHOICE_APPEARANCE_SELECT: nStage = STAGE_APPEARANCE_LIST; break;
                    }
                }
                break;
            }
            case STAGE_CLONE:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else if(nChoice == CHOICE_CONFIRM)
                {
                    itemproperty ip;
                    SetLocalInt(oPC, PRC_CRAFT_HB, 1);
                    CraftingHB(oPC, oItem, ip, nCost, nXP, sFile, -2, nTime);
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }
                break;
            }
            /*
            case <CONSTANT>:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else
                {
                    //code here
                    switch(nChoice)
                    {
                        case a: nStage = a; break;
                        case a: nStage = a; break;
                        case a: nStage = a; break;
                    }
                }
                break;
            }
            */
        }
        if(DEBUG) DoDebug("Next stage: " + IntToString(nStage));
        SetStage(nStage, oPC);
    }
    DeleteLocalInt(oPC, "PRC_CRAFT_TERMINATED");
}
