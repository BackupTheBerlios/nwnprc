//:://////////////////////////////////////////////
//:: Weapon Aptitude conversation script
//:: tob_aptitudeconv
//:://////////////////////////////////////////////
/** @file
    This script controls the weapon selection
    conversation for Warblade's Aptitude


    @author Primogenitor - Orinigal
    @author Ornedan - Modifications
    @author Fox - ripped from Psionics convo
    @date   Modified - 2005.03.13
    @date   Modified - 2005.09.23
    @date   Modified - 2008.01.25
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_WEAPON             = 0;
const int STAGE_WEAPON_SELECTED           = 1;
const int STAGE_CONFIRM_SELECTION         = 2;

const int CHOICE_BACK_TO_LSELECT         = -1;

const int STRREF_LEVELLIST_HEADER        = 16827087; // "Select a weapon to focus your feats on:"
const int STRREF_SELECTED_HEADER1        = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2        = 16824210; // "Is this correct?"
const int STRREF_END_HEADER              = 16827088; // "Your Aptitude feats have been set.  You can choose a weapon type again when you next rest."
const int STRREF_END_CONVO_SELECT        = 16824212; // "Finish"
const int STRREF_YES                     = 4752;     // "Yes"
const int STRREF_NO                      = 4753;     // "No"


const int SORT       = TRUE; // If the sorting takes too much CPU, set to FALSE
const int DEBUG_LIST = FALSE;

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void PrintList(object oPC)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oPC, "PRC_WpnConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oPC, "PRC_WpnConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oPC, "PRC_WpnConvo_List_Next_" + s);
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
    if(!GetLocalInt(oPC, "PRC_WpnConvo_ListInited"))
    {
        SetLocalString(oPC, "PRC_WpnConvo_List_Head", sChoice);
        SetLocalInt(oPC, "PRC_WpnConvo_List_" + sChoice, nChoice);

        SetLocalInt(oPC, "PRC_WpnConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oPC, "PRC_WpnConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oPC, "PRC_WpnConvo_List_Next_" + sNext);
        }

        /* Insert the new entry */
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oPC, "PRC_WpnConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oPC, "PRC_WpnConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oPC, "PRC_WpnConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oPC, "PRC_WpnConvo_List_" + sChoice, nChoice);
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
    string sChoice = GetLocalString(oPC, "PRC_WpnConvo_List_Head");
    int    nChoice = GetLocalInt   (oPC, "PRC_WpnConvo_List_" + sChoice);

    DeleteLocalString(oPC, "PRC_WpnConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oPC);

        // Get next
        sChoice = GetLocalString(oPC, "PRC_WpnConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oPC, "PRC_WpnConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oPC, "PRC_WpnConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oPC, "PRC_WpnConvo_List_" + sPrev);
    }

    DeleteLocalInt(oPC, "PRC_WpnConvo_ListInited");
}


void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    string sWpnFile = "baseitems";

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("tob_aptitudeconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("tob_aptitudeconv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_WEAPON)
            {
                if(DEBUG) DoDebug("tob_aptitudeconv: Building weapon selection");
                SetHeader(GetStringByStrRef(STRREF_LEVELLIST_HEADER));

                // Set the tokens
                int i = 0;
                int nChoiceLine = 1;
                while(Get2DACache(sWpnFile, "Name", i) != "") //until we hit a nonexistant line
                {
                    if(StringToInt(Get2DACache(sWpnFile, "WeaponType", i)) > 0) //if a weapon, add it
                    {
                       AddChoice(GetStringByStrRef(StringToInt(Get2DACache(sWpnFile, "WeaponType", i))), // The minus is correct, these are stored in inverse order in the TLK. Whoops
                              nChoiceLine
                              );
                       SetLocalInt(oPC, "AptitudeConv" + IntToString(nChoiceLine), i); //keep track of what choice is what line
                       nChoiceLine++;
                    }
                    
                    i++; //go to next line
                }

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("tob_aptitudeconv: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nWeapon = GetLocalInt(oPC, "nWeapon");
                sToken += GetStringByStrRef(StringToInt(Get2DACache(sWpnFile, "Name", nWeapon)))+"\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
            // Conversation finished stage
            else if(nStage == STAGE_WEAPON_SELECTED)
            {
                if(DEBUG) DoDebug("tob_aptitudeconv: Building finish note");
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
        if(DEBUG) DoDebug("tob_aptitudeconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nWeapon");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("tob_aptitudeconv: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("tob_aptitudeconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_WEAPON)
        {
            if(DEBUG) DoDebug("tob_aptitudeconv: Weapon selected.  Entering Confirmation.");
            SetLocalInt(oPC, "nWeapon", GetLocalInt(oPC, "AptitudeConv" + IntToString(nChoice)));
            nStage = STAGE_CONFIRM_SELECTION;
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(DEBUG) DoDebug("tob_aptitudeconv: Handling invocation confirmation");
            if(nChoice == TRUE)
            {
                if(DEBUG) DoDebug("tob_aptitudeconv: Marking Weapon");
                int nWeapon = GetLocalInt(oPC, "nWeapon");

                SetLocalInt(oPC, "AptitudeWpnType", nWeapon);

                nStage = STAGE_WEAPON_SELECTED;
            }
            else
                nStage = STAGE_SELECT_WEAPON;
        }

        if(DEBUG) DoDebug("tob_aptitudeconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
