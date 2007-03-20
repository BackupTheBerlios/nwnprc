//:://////////////////////////////////////////////
//:: Tome of Battle Maneuver gain conversation script
//:: tob_moveconv
//:://////////////////////////////////////////////
/** @file
    This script controls the Tome of Battle maneuver selection
    conversation.


    @author Stratovarius - 2006.07.19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "tob_inc_tobfunc"
#include "inc_dynconv"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_LEVEL        = 0;
const int STAGE_SELECT_MANEUVER        = 1;
const int STAGE_CONFIRM_SELECTION   = 2;
const int STAGE_ALL_POWERS_SELECTED = 3;

const int CHOICE_BACK_TO_LSELECT    = -1;

const int STRREF_BACK_TO_LSELECT    = -1; // "Return to maneuver level selection."
const int STRREF_LEVELLIST_HEADER   = -1; // "Select level of maneuver to gain.\n\nNOTE:\nThis may take a while when first browsing a particular level's maneuvers."
const int STRREF_MOVELIST_HEADER1   = -1; // "Select a maneuver to gain.\nYou can select"
const int STRREF_MOVELIST_HEADER2   = -1; // "more maneuvers"
const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_HEADER         = -1; // "You will be able to select more maneuvers after you gain another level in a psionic caster class."
const int STRREF_END_CONVO_SELECT   = 16824212; // "Finish"
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"


const int SORT       = TRUE; // If the sorting takes too much CPU, set to FALSE
const int DEBUG_LIST = FALSE;

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void PrintList(object oPC)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oPC, "PRC_MoveConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oPC, "PRC_MoveConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oPC, "PRC_MoveConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: Maneuver names are unique.
 *
 * @param oPC     The storage object aka whomever is gaining maneuvers in this conversation
 * @param sChoice The choice string
 * @param nChoice The choice value
 */
void AddToTempList(object oPC, string sChoice, int nChoice)
{
    if(DEBUG_LIST) DoDebug("\nAdding to temp list: '" + sChoice + "' - " + IntToString(nChoice));
    if(DEBUG_LIST) PrintList(oPC);
    // If there is nothing yet
    if(!GetLocalInt(oPC, "PRC_MoveConvo_ListInited"))
    {
        SetLocalString(oPC, "PRC_MoveConvo_List_Head", sChoice);
        SetLocalInt(oPC, "PRC_MoveConvo_List_" + sChoice, nChoice);

        SetLocalInt(oPC, "PRC_MoveConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oPC, "PRC_MoveConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oPC, "PRC_MoveConvo_List_Next_" + sNext);
        }

        /* Insert the new entry */
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oPC, "PRC_MoveConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oPC, "PRC_MoveConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oPC, "PRC_MoveConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oPC, "PRC_MoveConvo_List_" + sChoice, nChoice);
    }
}

/**
 * Reads the linked list built with AddToTempList() to AddChoice() and
 * deletes it.
 *
 * @param oPC A PC gaining maneuvers at the moment
 */
void TransferTempList(object oPC)
{
    string sChoice = GetLocalString(oPC, "PRC_MoveConvo_List_Head");
    int    nChoice = GetLocalInt   (oPC, "PRC_MoveConvo_List_" + sChoice);

    DeleteLocalString(oPC, "PRC_MoveConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oPC);

        // Get next
        sChoice = GetLocalString(oPC, "PRC_MoveConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oPC, "PRC_MoveConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oPC, "PRC_MoveConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oPC, "PRC_MoveConvo_List_" + sPrev);
    }

    DeleteLocalInt(oPC, "PRC_MoveConvo_ListInited");
}


void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    int nClass = GetLocalInt(oPC, "nClass");
    string sPsiFile = GetAMSKnownFileName(nClass);
    string sManeuverFile = GetAMSDefinitionFileName(nClass);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("tob_moveconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("tob_moveconv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_LEVEL)
            {
                if(DEBUG) DoDebug("tob_moveconv: Building level selection");
                SetHeader(GetStringByStrRef(STRREF_LEVELLIST_HEADER));

                // Determine maximum maneuver level
                // Initiators can choose up to their level +1/2 levels in all other classes
                // See ToB p39
                int nInitiatorLevel = GetInitiatorLevel(oPC, nClass);
                int nTotalHD = GetHitDice(oPC);
                // Max level is therefor the level plus 1/2 of remaining levels
                int nMaxLevel = nInitiatorLevel + ((nTotalHD - nInitiatorLevel)/2);

                // Set the tokens
                int i;
                for(i = 0; i < nMaxLevel; i++){
                    AddChoice(GetStringByStrRef(LEVEL_STRREF_START - i), // The minus is correct, these are stored in inverse order in the TLK. Whoops
                              i + 1
                              );
                }

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // Maneuver selection stage
            if(nStage == STAGE_SELECT_MANEUVER)
            {
                if(DEBUG) DoDebug("tob_moveconv: Building maneuver selection");
                int nCurrentManeuvers = GetManeuverCount(oPC, nClass);
                int nMaxManeuvers = GetMaxManeuverCount(oPC, nClass);
                string sToken = GetStringByStrRef(STRREF_MOVELIST_HEADER1) + " " + //"Select a maneuver to gain.\n You can select "
                                IntToString(nMaxManeuvers-nCurrentManeuvers) + " " +
                                GetStringByStrRef(STRREF_MOVELIST_HEADER2);        //" more maneuvers"
                SetHeader(sToken);

                // Set the first choice to be return to level selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oPC);

                // Determine maximum maneuver level
                int nInitiatorLevel = GetInitiatorLevel(oPC, nClass);
                int nMaxLevel = StringToInt(Get2DACache(sPsiFile, "MaxManeuverLevel", nInitiatorLevel-1));


                int nManeuverLevelToBrowse = GetLocalInt(oPC, "nManeuverLevelToBrowse");
                int i, nManeuverLevel;
                string sFeatID;
                for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
                {
                    nManeuverLevel = StringToInt(Get2DACache(sManeuverFile, "Level", i));
                    // Skip any maneuvers of too low level
                    if(nManeuverLevel < nManeuverLevelToBrowse){
                        continue;
                    }
                    /* Due to the way the maneuver list 2das are structured, we know that once
                     * the level of a read maneuver is greater than the maximum manifestable
                     * it'll never be lower again. Therefore, we can skip reading the
                     * maneuvers that wouldn't be shown anyway.
                     */
                    if(nManeuverLevel > nManeuverLevelToBrowse){
                        break;
                    }
                    sFeatID = Get2DACache(sManeuverFile, "FeatID", i);
                    if(sFeatID != ""                                           // Non-blank row
                     && !GetHasFeat(StringToInt(sFeatID), oPC)                 // PC does not already posses the maneuver
                     && (!StringToInt(Get2DACache(sManeuverFile, "HasPrereqs", i))// Maneuver has no prerequisites
                      || CheckManeuverPrereqs(StringToInt(sFeatID), oPC)          // Or the PC possess the prerequisites
                         )
                       )
                    {
                        if(SORT) AddToTempList(oPC, GetStringByStrRef(StringToInt(Get2DACache(sManeuverFile, "Name", i))), i);
                        else     AddChoice(GetStringByStrRef(StringToInt(Get2DACache(sManeuverFile, "Name", i))), i, oPC);
                    }
                }

                if(SORT) TransferTempList(oPC);

                /* Hack - In the maneuver selection stage, on returning from
                 * confirmation dialog where the answer was "No", restore the
                 * offset to be the same as on entering the confirmation dialog.
                 */
                if(GetLocalInt(oPC, "ManeuverListChoiceOffset"))
                {
                    if(DEBUG) DoDebug("tob_moveconv: Running offset restoration hack");
                    SetLocalInt(oPC, DYNCONV_CHOICEOFFSET, GetLocalInt(oPC, "ManeuverListChoiceOffset") - 1);
                    DeleteLocalInt(oPC, "ManeuverListChoiceOffset");
                }

                MarkStageSetUp(STAGE_SELECT_MANEUVER, oPC);
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("tob_moveconv: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nManeuver = GetLocalInt(oPC, "nManeuver");
                int nFeatID = StringToInt(Get2DACache(sManeuverFile, "FeatID", nManeuver));
                sToken += GetStringByStrRef(StringToInt(Get2DACache(sManeuverFile, "Name", nManeuver)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeatID)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
            // Conversation finished stage
            else if(nStage == STAGE_ALL_POWERS_SELECTED)
            {
                if(DEBUG) DoDebug("tob_moveconv: Building finish note");
                SetHeader(GetStringByStrRef(STRREF_END_HEADER));
                // Set the convo quit text to "Finish"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(STRREF_END_CONVO_SELECT));
                AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("tob_moveconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        DeleteLocalInt(oPC, "nManeuver");
        DeleteLocalInt(oPC, "nManeuverLevelToBrowse");
        DeleteLocalInt(oPC, "ManeuverListChoiceOffset");

        // Restart the convo to pick next maneuver if needed
        // done via EvalPRCFFeats to avoid convlicts with new spellbooks
        //ExecuteScript("psi_maneuvergain", oPC);
        DelayCommand(1.0, EvalPRCFeats(oPC));
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("tob_moveconv: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("tob_moveconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_LEVEL)
        {
            if(DEBUG) DoDebug("tob_moveconv: Level selected");
            SetLocalInt(oPC, "nManeuverLevelToBrowse", nChoice);
            nStage = STAGE_SELECT_MANEUVER;
        }
        else if(nStage == STAGE_SELECT_MANEUVER)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("tob_moveconv: Returning to level selection");
                nStage = STAGE_SELECT_LEVEL;
                DeleteLocalInt(oPC, "nManeuverLevelToBrowse");
            }
            else
            {
                if(DEBUG) DoDebug("tob_moveconv: Entering maneuver confirmation");
                SetLocalInt(oPC, "nManeuver", nChoice);
                // Store offset so that if the user decides not to take the maneuver,
                // we can return to the same page in the maneuver list instead of resetting to the beginning
                // Store the value +1 in order to be able to differentiate between offset 0 and undefined
                SetLocalInt(oPC, "ManeuverListChoiceOffset", GetLocalInt(oPC, DYNCONV_CHOICEOFFSET) + 1);
                nStage = STAGE_CONFIRM_SELECTION;
            }
            MarkStageNotSetUp(STAGE_SELECT_MANEUVER, oPC);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(DEBUG) DoDebug("tob_moveconv: Handling maneuver confirmation");
            if(nChoice == TRUE)
            {
                if(DEBUG) DoDebug("tob_moveconv: Adding maneuver");
                int nManeuver = GetLocalInt(oPC, "nManeuver");

                AddManeuverKnown(oPC, nClass, nManeuver, TRUE, GetHitDice(oPC));

                // Delete the stored offset
                DeleteLocalInt(oPC, "ManeuverListChoiceOffset");
            }

            int nCurrentManeuvers = GetManeuverCount(oPC, nClass);
            int nMaxManeuvers = GetMaxManeuverCount(oPC, nClass);
            if(nCurrentManeuvers >= nMaxManeuvers)
                nStage = STAGE_ALL_POWERS_SELECTED;
            else
                nStage = STAGE_SELECT_MANEUVER;
        }

        if(DEBUG) DoDebug("tob_moveconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
