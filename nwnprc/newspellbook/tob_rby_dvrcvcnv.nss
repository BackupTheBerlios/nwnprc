//:://////////////////////////////////////////////
//:: Swordsage Recovery Conversation
//:: tob_rby_dvrcvcnv
//:://////////////////////////////////////////////
/** @file
    This allows you to choose which maneuver to recover.


    @author Stratovarius
    @date   Created  - 21.9.2008
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "tob_inc_recovery"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_MANEUVER     = 1;

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


//////////////////////////////////////////////////
/* Aid Functions                                */
//////////////////////////////////////////////////

int _GetLoopEnd(int nClass)
{
	if (nClass == CLASS_TYPE_SWORDSAGE) return 141;
	
	return -1;
}

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

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
        if(DEBUG) DoDebug("tob_rby_dvrcvcnv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("tob_rby_dvrcvcnv: Stage was not set up already");
            // Maneuver selection stage
            if(nStage == STAGE_SELECT_MANEUVER)
            {
                if(DEBUG) DoDebug("tob_rby_dvrcvcnv: Building maneuver selection");
                int nBrowseLevel = GetLocalInt(oPC, "nManeuverLevelToBrowse");
	        int nMaxReady   = GetMaxReadiedCount(oPC, nClass);
            	int nCountReady = GetReadiedCount(oPC, nClass);   
            	int nMoveId;
                string sToken = "Select a Maneuver to recover. This will automatically recover and grant that maneuver and exist this conversation.";
                SetHeader(sToken);
                
                // Max number of expended maneuvers.
                int i;
		for(i = 0; i < 12; i++)
		{	
			nMoveId = GetLocalInt(oPC, "ManeuverExpended" + IntToString(nClass) + IntToString(i));
			// If it is not 0, it is a MoveId
			if (nMoveId != 0)
			{
				AddChoice(GetManeuverName(nMoveId), i);
				if(DEBUG) DoDebug("tob_rby_dvrcvcnv: Expended Maneuvers: " + GetManeuverName(nMoveId));
			}
                }

                MarkStageSetUp(STAGE_SELECT_MANEUVER, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("tob_rby_dvrcvcnv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        DeleteLocalInt(oPC, "nManeuver");
        DeleteLocalInt(oPC, "nManeuverLevelToBrowse");
        DeleteLocalInt(oPC, "ManeuverListChoiceOffset");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("tob_rby_dvrcvcnv: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("tob_rby_dvrcvcnv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
	if(nStage == STAGE_SELECT_MANEUVER)
        {
                if(DEBUG) DoDebug("tob_rby_dvrcvcnv: Adding maneuver readied");
                int nManeuver = nChoice;
                int nMoveId = StringToInt(Get2DACache(sManeuverFile, "RealSpellID", nManeuver));
                if(DEBUG) DoDebug("tob_rby_dvrcvcnv: nReadyMoveId: " + IntToString(nMoveId));
                RecoverManeuver(oPC, nClass, nMoveId);
                GrantWithheldManeuver(oPC, nClass, nMoveId);

                // Delete the stored offset
                DeleteLocalInt(oPC, "ManeuverListChoiceOffset");
		// And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);  
                nStage = STAGE_SELECT_MANEUVER;
	        MarkStageNotSetUp(STAGE_SELECT_MANEUVER, oPC);
        }

        if(DEBUG) DoDebug("tob_rby_dvrcvcnv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
