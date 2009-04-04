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

#include "tob_inc_moveknwn"
#include "inc_dynconv"
#include "prc_inc_function"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_LEVEL           = 0;
const int STAGE_SELECT_MANEUVER        = 1;
const int STAGE_SELECT_SLOT            = 2;
const int STAGE_ALL_MANEUVERS_SELECTED = 3;

const int CHOICE_BACK_TO_LSELECT    = -1;

const int STRREF_BACK_TO_LSELECT    = 16829723; // "Return to maneuver level selection."
const int STRREF_LEVELLIST_HEADER   = 16829724; // "Select level of maneuver to gain.\n\nNOTE:\nThis may take a while when first browsing a particular level's maneuvers."
const int STRREF_MOVELIST_HEADER1   = 16829725; // "Select a maneuver to gain.\nYou can select"
const int STRREF_MOVELIST_HEADER2   = 16829726; // "more maneuvers"
const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_HEADER         = 16829727; // "You will be able to select more maneuvers after you gain another level in a blade magic initiator class."
const int STRREF_END_CONVO_SELECT   = 16824212; // "Finish"
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"
const int STRREF_MOVESTANCE_HEADER  = 16829729; // "Choose Maneuver or Stances."
const int STRREF_STANCE             = 16829730; // "Stances"
const int STRREF_MANEUVER           = 16829731; // "Maneuvers"


const int SORT       = TRUE; // If the sorting takes too much CPU, set to FALSE
const int DEBUG_LIST = FALSE;

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void PrintList(object oInitiator)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oInitiator, "PRC_MoveConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

void AddMasterOfNineDiscipline(object oInitiator, int nMove)
{
	int nClass = GetLocalInt(oInitiator, "nClass");
	// Using feats
	int nDiscipline = GetDisciplineByManeuver(nMove, nClass, 1);
	SetPersistantLocalInt(oInitiator, "MasterOfNine" + IntToString(nDiscipline), TRUE);
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: Maneuver names are unique.
 *
 * @param oInitiator     The storage object aka whomever is gaining maneuvers in this conversation
 * @param sChoice The choice string
 * @param nChoice The choice value
 */
void AddToTempList(object oInitiator, string sChoice, int nChoice)
{
    if(DEBUG_LIST) DoDebug("\nAdding to temp list: '" + sChoice + "' - " + IntToString(nChoice));
    if(DEBUG_LIST) PrintList(oInitiator);
    // If there is nothing yet
    if(!GetLocalInt(oInitiator, "PRC_MoveConvo_ListInited"))
    {
        SetLocalString(oInitiator, "PRC_MoveConvo_List_Head", sChoice);
        SetLocalInt(oInitiator, "PRC_MoveConvo_List_" + sChoice, nChoice);

        SetLocalInt(oInitiator, "PRC_MoveConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oInitiator, "PRC_MoveConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + sNext);
        }

        /* Insert the new entry */
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oInitiator, "PRC_MoveConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oInitiator, "PRC_MoveConvo_List_" + sChoice, nChoice);
    }
}

/**
 * Reads the linked list built with AddToTempList() to AddChoice() and
 * deletes it.
 *
 * @param oInitiator A PC gaining maneuvers at the moment
 */
void TransferTempList(object oInitiator)
{
    string sChoice = GetLocalString(oInitiator, "PRC_MoveConvo_List_Head");
    int    nChoice = GetLocalInt   (oInitiator, "PRC_MoveConvo_List_" + sChoice);

    DeleteLocalString(oInitiator, "PRC_MoveConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oInitiator);

        // Get next
        sChoice = GetLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oInitiator, "PRC_MoveConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oInitiator, "PRC_MoveConvo_List_" + sPrev);
    }

    DeleteLocalInt(oInitiator, "PRC_MoveConvo_ListInited");
}

void EternalTrainingTempManeuver(object oInitiator, int nList, int n2daRow, int nChoice)
{
	string sManeuverFile = GetAMSDefinitionFileName(nList);

	// Get the spells.2da row corresponding to the cls_move_*.2da row
	// Will be cast from UseManeuver
	int nManeuver2daRow = StringToInt(Get2DACache(sManeuverFile, "SpellID", n2daRow));

	// Set spells.2da row
	if(DEBUG) DoDebug("tob_etbl_conv: nManeuver2daRow value = " + IntToString(nManeuver2daRow));
	SetLocalInt(oInitiator, "ETBL_MANEUVER_QUICK" + IntToString(nChoice), nManeuver2daRow);

	// Get strref for maneuver
	int nName = StringToInt(Get2DACache("spells", "Name", nManeuver2daRow));
	if(DEBUG) DoDebug("tob_etbl_conv: Maneuver name: " + GetStringByStrRef(nName));
	//int nFeatID = StringToInt(Get2DACache(sManeuverFile, "FeatID", nManeuver));
	SetLocalInt(oInitiator, "ETBL_MANEUVER_NAME_QUICK" + IntToString(nChoice), nName);
}

void main()
{
    object oInitiator = GetPCSpeaker();
    int nValue = GetLocalInt(oInitiator, DYNCONV_VARIABLE);
    int nStage = GetStage(oInitiator);

    int nClass = GetFirstBladeMagicClass(oInitiator);//GetLocalInt(oInitiator, "nClass");
    string sManeuverFile = GetAMSDefinitionFileName(nClass);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("tob_moveconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oInitiator))
        {
            if(DEBUG) DoDebug("tob_moveconv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_LEVEL)
            {
                if(DEBUG) DoDebug("tob_moveconv: Building level selection");
                SetHeader(GetStringByStrRef(STRREF_LEVELLIST_HEADER));

                // Determine maximum maneuver level
                // Initiators get new maneuvers at the same levels as wizards
                // See ToB p39, table 3-1
                int nMaxLevel = min(9, (GetInitiatorLevel(oInitiator, nClass) + 1)/2);

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
		string sMoveStance;
                int nMoveStance = GetLocalInt(oInitiator, "nStanceOrManeuver");
                if      (nMoveStance == MANEUVER_TYPE_MANEUVER) sMoveStance = "ManeuverKnown";
                else if (nMoveStance == MANEUVER_TYPE_STANCE)   sMoveStance = "StancesKnown";

                int nCurrentManeuvers = GetManeuverCount(oInitiator, nClass, nMoveStance);
                int nMaxManeuvers = GetMaxManeuverCount(oInitiator, nClass, nMoveStance);
                string sToken = GetStringByStrRef(STRREF_MOVELIST_HEADER1) + " " + //"Select a maneuver to gain.\n You can select "
                                IntToString(nMaxManeuvers-nCurrentManeuvers) + " " +
                                GetStringByStrRef(STRREF_MOVELIST_HEADER2);        //" more maneuvers"
                SetHeader(sToken);

                // Set the first choice to be return to level selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oInitiator);

                // Determine maximum maneuver level
                int nInitiatorLevel = GetInitiatorLevel(oInitiator, nClass);

                int nManeuverLevelToBrowse = GetLocalInt(oInitiator, "nManeuverLevelToBrowse");
                int i, nManeuverLevel;
                string sFeatID;
                for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
                {
                    nManeuverLevel = StringToInt(Get2DACache(sManeuverFile, "Level", i));
                    // Skip any maneuvers of too low level
                    if(nManeuverLevel < nManeuverLevelToBrowse){
                        continue;
                    }
                    // If looking for stances, skip maneuvers, else reverse
                    if(nMoveStance == MANEUVER_TYPE_STANCE && StringToInt(Get2DACache(sManeuverFile, "Stance", i)) == 0){
                        continue;
                    }  // Skip stances when looking for maneuvers
                    else if(nMoveStance == MANEUVER_TYPE_MANEUVER && StringToInt(Get2DACache(sManeuverFile, "Stance", i)) == 1){
                        continue;
                    }
                    /* Due to the way the maneuver list 2das are structured, we know that once
                     * the level of a read maneuver is greater than the maximum manifestable
                     * it'll never be lower again. Therefore, we can skip reading the
                     * maneuvers that wouldn't be shown anyway.
                     */
                    if(nManeuverLevel > nManeuverLevelToBrowse){
                        continue;
                    }
                    sFeatID = Get2DACache(sManeuverFile, "FeatID", i);
                    if(sFeatID != ""                                           // Non-blank row
                     && !GetHasFeat(StringToInt(sFeatID), oInitiator)                 // PC does not already possess the maneuver
                     && (!StringToInt(Get2DACache(sManeuverFile, "HasPrereqs", i))// Maneuver has no prerequisites
                      || CheckManeuverPrereqs(nClass, StringToInt(sFeatID), oInitiator)          // Or the PC possess the prerequisites
                         )
                       )
                    {
                        if(SORT) AddToTempList(oInitiator, GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", StringToInt(sFeatID)))), i);
                        else     AddChoice(GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", StringToInt(sFeatID)))), i, oInitiator);
                    }
                }

                if(SORT) TransferTempList(oInitiator);

                /* Hack - In the maneuver selection stage, on returning from
                 * confirmation dialog where the answer was "No", restore the
                 * offset to be the same as on entering the confirmation dialog.
                 */
                if(GetLocalInt(oInitiator, "ManeuverListChoiceOffset"))
                {
                    if(DEBUG) DoDebug("tob_moveconv: Running offset restoration hack");
                    SetLocalInt(oInitiator, DYNCONV_CHOICEOFFSET, GetLocalInt(oInitiator, "ManeuverListChoiceOffset") - 1);
                    DeleteLocalInt(oInitiator, "ManeuverListChoiceOffset");
                }

                MarkStageSetUp(STAGE_SELECT_MANEUVER, oInitiator);
            }
            // Selection confirmation stage
            else if(nStage == STAGE_SELECT_SLOT)
            {
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n \n"; // "You have selected:"
                int nManeuver = GetLocalInt(oInitiator, "nManeuver");
                int nFeatID = StringToInt(Get2DACache(sManeuverFile, "FeatID", nManeuver));
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeatID)))+"\n \n";
                //sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                sToken += "Select Quickslot:";
                SetHeader(sToken);

		    //SetHeader("Select QuickSlot:");
		    AddChoice("Slot 1", 1, oInitiator);
		    AddChoice("Slot 2", 2, oInitiator);
		    AddChoice("Slot 3", 3, oInitiator);
		    AddChoice("Slot 4", 4, oInitiator);
		    MarkStageSetUp(nStage, oInitiator); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
		    SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            // Conversation finished stage
            else if(nStage == STAGE_ALL_MANEUVERS_SELECTED)
            {
                if(DEBUG) DoDebug("tob_moveconv: Building finish note");
                SetHeader(GetStringByStrRef(STRREF_END_HEADER));
                // Set the convo quit text to "Finish"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(STRREF_END_CONVO_SELECT));
                AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oInitiator);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("tob_moveconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oInitiator, "nClass");
        DeleteLocalInt(oInitiator, "nManeuver");
        DeleteLocalInt(oInitiator, "nStanceOrManeuver");
        DeleteLocalInt(oInitiator, "nManeuverLevelToBrowse");
        DeleteLocalInt(oInitiator, "ManeuverListChoiceOffset");

        // Restart the convo to pick next maneuver if needed
        // done via EvalPRCFFeats to avoid convlicts with new spellbooks
        //ExecuteScript("psi_maneuvergain", oInitiator);
        DelayCommand(1.0, EvalPRCFeats(oInitiator));
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
        int nChoice = GetChoice(oInitiator);
        if(DEBUG) DoDebug("tob_moveconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oInitiator) +  "'");
	if(nStage == STAGE_SELECT_LEVEL)
        {
            if(DEBUG) DoDebug("tob_moveconv: Level selected");
            SetLocalInt(oInitiator, "nManeuverLevelToBrowse", nChoice);
            nStage = STAGE_SELECT_MANEUVER;
        }
        else if(nStage == STAGE_SELECT_MANEUVER)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("tob_moveconv: Returning to level selection");
                nStage = STAGE_SELECT_LEVEL;
                DeleteLocalInt(oInitiator, "nManeuverLevelToBrowse");
            }
            else
            {
                if(DEBUG) DoDebug("tob_moveconv: Entering maneuver confirmation");
                SetLocalInt(oInitiator, "nManeuver", nChoice);
                // Store offset so that if the user decides not to take the maneuver,
                // we can return to the same page in the maneuver list instead of resetting to the beginning
                // Store the value +1 in order to be able to differentiate between offset 0 and undefined
                SetLocalInt(oInitiator, "ManeuverListChoiceOffset", GetLocalInt(oInitiator, DYNCONV_CHOICEOFFSET) + 1);
                nStage = STAGE_SELECT_SLOT;
            }
            MarkStageNotSetUp(STAGE_SELECT_MANEUVER, oInitiator);
        }
        else if(nStage == STAGE_SELECT_SLOT)
        {
            if(DEBUG) DoDebug("tob_moveconv: Handling maneuver confirmation");
            int nMoveStance = GetLocalInt(oInitiator, "nStanceOrManeuver");
                if(DEBUG) DoDebug("tob_moveconv: Adding maneuver");
                int nManeuver = GetLocalInt(oInitiator, "nManeuver");

                // This triggers regardless of PC being Master of Nine
                //AddMasterOfNineDiscipline(oInitiator, nManeuver);
                //AddManeuverKnown(oInitiator, nClass, nManeuver, nMoveStance, TRUE, GetHitDice(oInitiator));
		EternalTrainingTempManeuver(oInitiator, nClass, nManeuver, nChoice);

                // Delete the stored offset
                DeleteLocalInt(oInitiator, "ManeuverListChoiceOffset");

                nStage = STAGE_ALL_MANEUVERS_SELECTED;
                // Clean up all of these
		string sString = "RestrictedDiscipline";
		int i;
     		for(i = 1; i < 6; i++)
     		{
     			// Cycle through the local ints
     			sString += IntToString(i);
     			DeletePersistantLocalInt(oInitiator, sString);
		}

        }

        if(DEBUG) DoDebug("tob_moveconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oInitiator);
    }
}
