//:://////////////////////////////////////////////
//:: Teleport options dialog
//:: prc_telp_optdlg
//:://////////////////////////////////////////////
/** @file
    This file builds the entries for the teleport
    locations management dialog when used with the
    dynamic conversation system.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 18.06.2005
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_teleport"
#include "inc_utility"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_MAIN                       = 0;
const int STAGE_LOCATION_LIST              = 1;
const int STAGE_LOCATION_ACTION_SELECTION  = 2;
const int STAGE_QUICKSLOT_SELECTION        = 3;
const int STAGE_QUICKSLOT_LIST             = 4;
//const int STAGE_QUICKSLOT_ACTION_SELECTION = 5;
const int STAGE_OPTIONS_LIST               = 6;
const int STAGE_LISTENER_TIME              = 7;
const int STAGE_MAPPIN                     = 8;
const int STAGE_ONREST_MARKLOCATION        = 9;

const int CHOICE_BACK_TO_MAIN      = -1;

const int CHOICE_STORE_QUICKSELECT = 1;
const int CHOICE_DELETE_LOCATION   = 2;

const int CHOICE_0S                = 0;
const int CHOICE_5S                = 5;
const int CHOICE_10S               = 10;
const int CHOICE_15S               = 15;
const int CHOICE_20S               = 20;

const int CHOICE_YES               = 1;
const int CHOICE_NO                = 0;

const int STRREF_BACK_TO_MAIN = 16824794;  // "Back to main menu"

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void AddChoice(string sText, int nValue)
{
    array_set_string(OBJECT_SELF, "ChoiceTokens", array_get_size(OBJECT_SELF, "ChoiceTokens"), sText);
    array_set_int   (OBJECT_SELF, "ChoiceValues", array_get_size(OBJECT_SELF, "ChoiceValues"), nValue);
}

void main()
{
    object oPC = OBJECT_SELF;
    /* Get the value of the local variable set by the conversation script calling
     * this script. Values:
     * -3   Conversation aborted
     * -2   Conversation exited via the exit node
     * -1   System's reply turn
     * 0    Error
     * 1+   Index of user's choice from the ChoiceValues array +1
     */
    int nValue = GetLocalInt(oPC, "DynConv_Var");

    // Reset the choice arrays
    array_create(oPC, "ChoiceTokens");
    array_create(oPC, "ChoiceValues");

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;
    if(nValue > 0)
        nValue --; // Correct for zero-based array indices in the ChoiceValues array


    if(nValue == -1)
    {
        // The stage is used to determine the active conversation node.
        // 0 is the entry node.
        int nStage = GetLocalInt(oPC, "Stage");
// INSERT CODE HERE FOR THE HEADER
// token    99     = header
// token 100 - 109 = player choices
// array named ChoiceTokens for strings                        \_ The function AddChoice can be used for easy manipulation of these
// array named ChoiceValues for ints associated with responces /
// variable named nStage determines the current conversation node
        if(nStage == STAGE_MAIN)
        {
            SetCustomToken(99, GetStringByStrRef(16825272)); // "Select a list to view"

            AddChoice(GetStringByStrRef(16825273), STAGE_LOCATION_LIST);  // "List stored locations."
            AddChoice(GetStringByStrRef(16825274), STAGE_QUICKSLOT_LIST); // "List quickselections."
            AddChoice(GetStringByStrRef(16825275), STAGE_OPTIONS_LIST);   // "Show options."
        }
        else if(nStage == STAGE_LOCATION_LIST)
        {
            SetCustomToken(99, GetStringByStrRef(16825276)); // "Select a location to manipulate."
            AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN);

            // List all stored locations
            int i, nMax = GetNumberOfStoredTeleportTargetLocations(oPC);
            string sToken;
            struct metalocation mlocL;
            for(i = 0; i < nMax; i++)
            {
                mlocL = GetNthStoredTeleportTargetLocation(oPC, i);
                AddChoice(MetalocationToString(mlocL), i);
            }
        }
        else if(nStage == STAGE_LOCATION_ACTION_SELECTION)
        {
            SetCustomToken(99, GetStringByStrRef(16825277) + // "Select action to perform on the location."
                               "\n" + MetalocationToString(GetNthStoredTeleportTargetLocation(oPC, GetLocalInt(oPC, "ManipulatedTeleportTargetLocationIndex"))));
            AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN);

            AddChoice(GetStringByStrRef(16825278), CHOICE_STORE_QUICKSELECT); // "Store location in a quickslot."
            AddChoice(GetStringByStrRef(16825279), CHOICE_DELETE_LOCATION);   // "Delete location."
        }
        else if(nStage == STAGE_QUICKSLOT_SELECTION)
        {
            SetCustomToken(99, GetStringByStrRef(16825280)); // "Select quickslot to store the location in."
            AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN);

            int i;
            struct metalocation mlocL;
            string sToken;
            for(i = 1; i <= PRC_NUM_TELEPORT_QUICKSELECTS; i++)
            {//          Quickselection
                sToken = GetStringByStrRef(16825271) + " " + IntToString(i) + ": ";
                //if(GetLocalInt(oPC, "PRC_Teleport_QuickSelection_" + IntToString(i)))
                if(GetHasTeleportQuickSelection(oPC, i))
                {
                    //mlocL = GetLocalMetalocation(oPC, "PRC_Teleport_QuickSelection_" + IntToString(i));
                    mlocL = GetTeleportQuickSelection(oPC, i);
                    sToken += MetalocationToString(mlocL);
                }
                else
                    sToken += GetStringByStrRef(16825282); // "Blank"

                AddChoice(sToken, i);
            }
        }
        else if(nStage == STAGE_QUICKSLOT_LIST)
        {
            SetCustomToken(99, GetStringByStrRef(16825281)); // "A list of the contents of your quickslots. Selecting a quickslot empties it."
            AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN);

            int i;
            struct metalocation mlocL;
            string sToken;
            for(i = 1; i <= PRC_NUM_TELEPORT_QUICKSELECTS; i++)
            {//          Quickselection
                sToken = GetStringByStrRef(16825271) + " " + IntToString(i) + ": ";
                //if(GetLocalInt(oPC, "PRC_Teleport_QuickSelection_" + IntToString(i)))
                if(GetHasTeleportQuickSelection(oPC, i))
                {
                    //mlocL = GetLocalMetalocation(oPC, "PRC_Teleport_QuickSelection_" + IntToString(i));
                    mlocL = GetTeleportQuickSelection(oPC, i);
                    sToken += MetalocationToString(mlocL);
                    AddChoice(sToken, i);
                }
            }
        }
        else if(nStage == STAGE_OPTIONS_LIST)
        {
            SetCustomToken(99, GetStringByStrRef(16825283)); // "Select option to modify"
            AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN);

            //        Listener duration
            AddChoice(GetStringByStrRef(16825284) + ": " + IntToString(FloatToInt(GetLocalFloat(oPC, "PRC_Teleport_NamingListenerDuration"))) + "s", STAGE_LISTENER_TIME);
            //        Create map pins for marked locations                                                                     Yes                       No
            AddChoice(GetStringByStrRef(16825299) + ": " + (GetLocalInt(oPC, PRC_TELEPORT_CREATE_MAP_PINS) ? GetStringByStrRef(4752) : GetStringByStrRef(4753)), STAGE_MAPPIN);
            //        Mark resting locations
            AddChoice(GetStringByStrRef(16825308) + ": " + (GetLocalInt(oPC, PRC_TELEPORT_ONREST_MARKLOCATION) ? GetStringByStrRef(4752) : GetStringByStrRef(4753)), STAGE_ONREST_MARKLOCATION);
        }
        else if(nStage == STAGE_LISTENER_TIME)
        {
            SetCustomToken(99, GetStringByStrRef(16825290)); // "Select how long the game will wait for you to speak a name when marking a location."
            AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN);

            AddChoice(GetStringByStrRef(16825285), CHOICE_0S); // "0 seconds - Do not name at all"
            AddChoice(GetStringByStrRef(16825286), CHOICE_5S); // "5 seconds"
            AddChoice(GetStringByStrRef(16825287), CHOICE_10S); // "10 seconds"
            AddChoice(GetStringByStrRef(16825288), CHOICE_15S); // "15 seconds"
            AddChoice(GetStringByStrRef(16825289), CHOICE_20S); // "20 seconds"
        }
        else if(nStage == STAGE_MAPPIN)
        {
            SetCustomToken(99, GetStringByStrRef(16825301)); // "Select whether you want map pins to be automatically to be created at locations you mark. Note that they may not appear immediately, but only after you re-enter the area."
            AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN);

            AddChoice(GetStringByStrRef(4752), CHOICE_YES); // "Yes"
            AddChoice(GetStringByStrRef(4753), CHOICE_NO); // "No"
        }
        else if(nStage == STAGE_ONREST_MARKLOCATION)
        {
            SetCustomToken(99, GetStringByStrRef(16825309)); // "Select whether you want that whenever you rest, the location will be automatically marked.\nWARNING: The location is always stored in the first slot, so if you delete it, next time you rest whatever is now in the first slot will be overwritten."
            AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN);

            AddChoice(GetStringByStrRef(4752), CHOICE_YES); // "Yes"
            AddChoice(GetStringByStrRef(4753), CHOICE_NO); // "No"
        }
// END OF INSERT FOR THE HEADER
        //do token setup
        int nOffset = GetLocalInt(oPC, "ChoiceOffset");
        int i;
        for(i=nOffset; i<nOffset+10; i++)
        {
            string sValue = array_get_string(oPC, "ChoiceTokens" ,i);
            SetLocalString(oPC, "TOKEN10"+IntToString(i-nOffset), sValue);
            SetCustomToken(100+i-nOffset, sValue);
        }
        SetCustomToken(110, GetStringByStrRef(16824212));//finish
        SetCustomToken(111, GetStringByStrRef(16824202));//please wait
        SetCustomToken(112, GetStringByStrRef(16824204));//next
        SetCustomToken(113, GetStringByStrRef(16824203));//previous

        return;
    }
    else if(nValue == -2)
    {
      //end of conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "Stage");
        int i;
        for(i = 99; i <= 110; i++)
            DeleteLocalString(oPC, "TOKEN" + IntToString(i));

        DeleteLocalInt(oPC, "ManipulatedTeleportTargetLocationIndex");

        return;
    }
    else if(nValue == -3)
    {
      //abort conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "Stage");
        int i;
        for(i = 99; i <= 110; i++)
            DeleteLocalString(oPC, "TOKEN" + IntToString(i));

        DeleteLocalInt(oPC, "ManipulatedTeleportTargetLocationIndex");

        return;
    }
    int nChoice = array_get_int(oPC, "ChoiceValues", nValue);
    int nStage = GetLocalInt(oPC, "Stage");
// INSERT CODE HERE FOR PC RESPONSES
// variable named nChoice is the value of the player's choice as stored when building the choice list
// variable named nStage determines the current conversation node
    if(nStage == STAGE_MAIN)
    {
        // Stage to move to is the value of the choice
        nStage = nChoice;
    }
    else if(nStage == STAGE_LOCATION_LIST)
    {
        if(nChoice == CHOICE_BACK_TO_MAIN)
            nStage = STAGE_MAIN;
        else
        {
            // Move to take action on the selected location
            nStage = STAGE_LOCATION_ACTION_SELECTION;
            // Store the index of the selected location
            SetLocalInt(oPC, "ManipulatedTeleportTargetLocationIndex", nChoice);
        }
    }
    else if(nStage == STAGE_LOCATION_ACTION_SELECTION)
    {
        if(nChoice == CHOICE_BACK_TO_MAIN)
        {
            DeleteLocalInt(oPC, "ManipulatedTeleportTargetLocationIndex");
            nStage = STAGE_MAIN;
        }
        else if(nChoice == CHOICE_STORE_QUICKSELECT)
        {
            nStage = STAGE_QUICKSLOT_SELECTION;
        }
        else if(nChoice == CHOICE_DELETE_LOCATION)
        {
            RemoveNthTeleportTargetLocation(oPC, GetLocalInt(oPC, "ManipulatedTeleportTargetLocationIndex"));
            DeleteLocalInt(oPC, "ManipulatedTeleportTargetLocationIndex");
            nStage = STAGE_MAIN;
        }
    }
    else if(nStage == STAGE_QUICKSLOT_SELECTION)
    {
        if(nChoice != CHOICE_BACK_TO_MAIN)
        {
            /*SetLocalInt(oPC, "PRC_Teleport_QuickSelection_" + IntToString(nChoice), TRUE);
            SetLocalMetalocation(oPC, "PRC_Teleport_QuickSelection_" + IntToString(nChoice),
                                 GetNthStoredTeleportTargetLocation(oPC, GetLocalInt(oPC, "ManipulatedTeleportTargetLocationIndex")));*/
            SetTeleportQuickSelection(oPC, GetNthStoredTeleportTargetLocation(oPC, GetLocalInt(oPC, "ManipulatedTeleportTargetLocationIndex")), nChoice);
        }

        DeleteLocalInt(oPC, "ManipulatedTeleportTargetLocationIndex");
        nStage = STAGE_MAIN;
    }
    else if(nStage == STAGE_QUICKSLOT_LIST)
    {
        if(nChoice != CHOICE_BACK_TO_MAIN)
        {
            /*DeleteLocalInt(oPC, "PRC_Teleport_QuickSelection_" + IntToString(nChoice));
            DeleteLocalMetalocation(oPC, "PRC_Teleport_QuickSelection_" + IntToString(nChoice));*/
            RemoveTeleportQuickSelection(oPC, nChoice);
        }

        nStage = STAGE_MAIN;
    }
    else if(nStage == STAGE_OPTIONS_LIST)
    {
        if(nChoice == CHOICE_BACK_TO_MAIN)
            nStage = STAGE_MAIN;
        else
            nStage = nChoice;
    }
    else if(nStage == STAGE_LISTENER_TIME)
    {
        if(nChoice != CHOICE_BACK_TO_MAIN)
        {
            SetLocalFloat(oPC, "PRC_Teleport_NamingListenerDuration", IntToFloat(nChoice));
        }

        nStage = STAGE_MAIN;
    }
    else if(nStage == STAGE_MAPPIN)
    {
        SetLocalInt(oPC, PRC_TELEPORT_CREATE_MAP_PINS, nChoice);

        // Create map pins from existing teleport locations.
        if(nChoice)
            TeleportLocationsToMapPins(oPC);

        nStage = STAGE_MAIN;
    }
    else if(nStage == STAGE_ONREST_MARKLOCATION)
    {
        if(nChoice != CHOICE_BACK_TO_MAIN)
        {
            // Do not move locations if the option is already active
            if(nChoice == CHOICE_YES && GetLocalInt(oPC, PRC_TELEPORT_ONREST_MARKLOCATION) != CHOICE_YES)
            {
                // Array size check. If no limit is defined via switch, default to 50.
                int nNum = GetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME); // Array elements begin at index 0
                int nMax = GetPRCSwitch(PRC_TELEPORT_MAX_TARGET_LOCATIONS) ?
                            GetPRCSwitch(PRC_TELEPORT_MAX_TARGET_LOCATIONS) :
                            50;
                if(nNum >= nMax)
                    // You have reached the maximum allowed teleport locations (              ).\nYou must remove at least one stored location before you can add new locations.
                    SendMessageToPC(oPC, GetStringByStrRef(16825294) + IntToString(nMax) + GetStringByStrRef(16825295));

                // Move all the existing locations up by one
                int i;
                for(i = nNum; i > 0; i--)
                {
                    SetPersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_" + IntToString(i),
                                                   GetPersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_" + IntToString(i - 1))
                                                   );
                    // Move the map pin existence marker if it's present
                    if(GetLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME + "_HasMapPin_" + IntToString(i - 1)))
                        SetLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME + "_HasMapPin_" + IntToString(i), TRUE);
                }

                // Store a null metalocation in the first slot
                SetPersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_0", GetNullMetalocation());

                // Store the increased array size
                SetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME, nNum + 1);

                // Hook into OnRest-Finished event
                AddEventScript(oPC, EVENT_ONPLAYERREST_FINISHED, "prc_telep_mrkrst", TRUE, FALSE);
            }
            else if(nChoice == CHOICE_NO)
            {
                // Delete the location and unhook from OnRest
                RemoveNthTeleportTargetLocation(oPC, 0);
                RemoveEventScript(oPC, EVENT_ONPLAYERREST_FINISHED, "prc_telep_mrkrst", TRUE, FALSE);
            }

            SetLocalInt(oPC, PRC_TELEPORT_ONREST_MARKLOCATION, nChoice);
        }

        nStage = STAGE_MAIN;
    }
// END OF INSERT FOR THE HEADER
    // Clean up the old choice data
    array_delete(oPC, "ChoiceTokens");
    array_delete(oPC, "ChoiceValues");
    array_create(oPC, "ChoiceTokens");
    array_create(oPC, "ChoiceValues");
    DeleteLocalInt(oPC, "ChoiceOffset");

    // Store the new stage value
    SetLocalInt(oPC, "Stage", nStage);
}