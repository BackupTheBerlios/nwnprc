//::///////////////////////////////////////////////
//:: Teleport include
//:: prc_inc_teleport
//::///////////////////////////////////////////////
/** @file
    This include contains operations to maintain
    an array of metalocations used as teleport target
    locations on a PC. In addition, there is a function
    for starting a conversation for the PC to select a
    location from their array.

    All the operations work only on PCs, as there is no
    AI that could have NPCs take any advantage of the
    system.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 29.05.2005
//:://////////////////////////////////////////////

#include "inc_metalocation"
#include "inc_utility"



//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

/**
 * Starts the conversation for selecting the target location for a teleport.
 * Once the PC has made his/her/it's selection, the result is stored on the
 * PC and the callbackscript is run.
 *
 * @param oPC             The PC that will make the selection.
 * @param sCallbackScript The name of the script to run once the PC has made
 *                        their decision.
 * @param sCallbackVar    The name of the local variable where the PC's choice
 *                        will be stored.
 * @param bMeta           If this is TRUE, the result will be stored as a
 *                        metalocation. Otherwise it will be stored as a location.
 * @param bForce          If this is TRUE, an attempt will be made to make sure
 *                        the PC will make the choice. ClearAllActions will be
 *                        called to prevent other activity from interfering with
 *                        the conversation strating and the PC will not be allowed
 *                        to abort the conversation.
 */
void ChooseTeleportTargetLocation(object oPC, string sCallbackScript, string sCallbackVar,
                                  int bMeta = FALSE, int bForce = FALSE);

/**
 * Returns the first teleport target location in the array and initialises
 * the iteration counter for calls to GetNextStoredTeleportTargetLocation().
 *
 * @param oPC The PC on whose array to operate.
 * @return    The first element of the array or null metalocation if the
 *            array is empty.
 */
struct metalocation GetFirstStoredTeleportTargetLocation(object oPC);

/**
 * Returns the element at the current value of the iteration counter and
 * increments the counter.
 *
 * @param oPC The PC on whose array to operate.
 * @return    The next element in the array or null metalocation if the
 *            iteration has reached the end of the array or if the iteration
 *            counter hasn't been initialised.
 *
 * @see GetFirstStoredTeleportTargetLocation
 */
struct metalocation GetNextStoredTeleportTargetLocation(object oPC);

/**
 * Returns the teleport target location stored at the given index in the array.
 * This function does not interfere with the iteration counter used by
 * GetFirstStoredTeleportTargetLocation and GetNextStoredTeleportTargetLocation.
 *
 * @param oPC  The PC on whose array to operate.
 * @param nInd The array index from which to retrieve the location.
 * @return     The teleport target location stored at the given index, or null
 *             metalocation if the index was out of array bounds.
 */
struct metalocation GetNthStoredTeleportTargetLocation(object oPC, int nInd);

/**
 * Returns the number of elements in the teleport target locations array on the
 * PC.
 *
 * @param oPC The PC on whose array to operate.
 * @return    The number of locations stored in the array.
 */
int GetNumberOfStoredTeleportTargetLocations(object oPC);

/**
 * Removes the teleport target location last returned by GetFirstStoredTeleportTargetLocation
 * or GetNextStoredTeleportTargetLocation from the PCs array.
 * Resets the iteration counter to prevent possible errors.
 *
 * @param oPC The PC on whose array to operate.
 */
void RemoveCurrentTeleportTargetLocation(object oPC);

/**
 * Removes the teleport target location at the given index in the PCs array. The
 * elements after the removed index will be moved down so there will not be empty
 * elements in the middle of the array.
 * Resets the iteration counter to prevent possible errors.
 *
 * @param oPC  The PC on whose array to operate.
 * @param nInd The index from which to delete.
 */
void RemoveNthTeleportTargetLocation(object oPC, int nInd);

/**
 * Adds a location to the end of the teleport target array of the given PC.
 * Implemented by constructing a metalocation out of locToAdd and sName and
 * calling AddTeleportTargetLocationAsMeta.
 *
 * @param oPC      The PC to whose teleport target location array the
 *                 location is to be added.
 * @param locToAdd The location to store.
 * @param sName    The name of the teleport target location.
 *
 * @return          TRUE if the addition was successfull, FALSE otherwise.
 */
int AddTeleportTargetLocation(object oPC, location locToAdd, string sName);

/**
 * Adds a metalocation to the end of the teleport target array of the given PC.
 *
 * @param oPC       The PC to whose teleport target location array the
 *                  metalocation is to be added.
 * @param mlocToAdd The metalocation to store.
 *
 * @return          TRUE if the addition was successfull, FALSE otherwise.
 */
int AddTeleportTargetLocationAsMeta(object oPC, struct metalocation mlocToAdd);



//////////////////////////////////////////////////
/* Internal Constants - nothing to see here :D  */
//////////////////////////////////////////////////

const string PRC_TELEPORT_ARRAY_NAME = "PRC_TeleportLocation_Array";
const int NUM_TELEPORT_QUICKSELECTS = 2;

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void ChooseTeleportTargetLocation(object oPC, string sCallbackScript, string sCallbackVar,
                                  int bMeta = FALSE, int bForce = TRUE)
{
    // The system is only useful to PCs. If it is at some point implemented for NPCs, change this.
    if(!GetIsPC(oPC)) return;

    // Make sure the PC has the feats for marking locations
    ExecuteScript("prc_tp_mgmt_eval", oPC);

    // Handle possible quickselection
    if(GetLocalInt(oPC, "PRC_Teleport_Quickselection"))
    {
        // Get the quickselected metalocation
        struct metalocation mlocL = GetLocalMetalocation(oPC, "PRC_Teleport_Quickselection");

        // Store it under the requested name
        // Store the return value
        if(bMeta)
            SetLocalMetalocation(oPC, sCallbackVar, mlocL);
        else
            SetLocalLocation(oPC, sCallbackVar, MetalocationToLocation(mlocL));

        // Break the script execution association between this one and the callback script
        // by delaying it. Probably unnecessary, but it will clear potential interference
        // caused by things done in this execution
        DelayCommand(0.2f, ExecuteScript(sCallbackScript, oPC));

        // Clear the quickselection
        DeleteLocalInt(oPC, "PRC_Teleport_Quickselection");
        DeleteLocalMetalocation(oPC, "PRC_Teleport_Quickselection");
    }
    // No quickselection was active, so run the conversation to find out where the user wants to go
    else
    {
        if(bForce) AssignCommand(oPC, ClearAllActions(TRUE));

        SetLocalString(oPC, "PRC_TeleportTargetSelection_CallbackScript", sCallbackScript);
        SetLocalString(oPC, "PRC_TeleportTargetSelection_ReturnStoreName", sCallbackVar);
        SetLocalInt(oPC, "PRC_TeleportTargetSelection_ReturnAsMetalocation", bMeta);
        SetLocalInt(oPC, "PRC_TeleportTargetSelection_DisallowConversationAbort", bForce);

        SetLocalString(oPC, "DynConv_Script", "prc_teleprt_conv");
        AssignCommand(oPC, ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE));
    }
}

struct metalocation GetFirstStoredTeleportTargetLocation(object oPC)
{
    // The system is only useful to PCs. If it is at some point implemented for NPCs, change this.
    if(!GetIsPC(oPC)) return GetNullMetalocation();

    // Return null if the array is empty
    if(!GetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME))
        return GetNullMetalocation();

    // Set the iterator value for subsequent calls to GetNextStoredTeleportTargetLocation()
    SetLocalInt(oPC, "PRC_Teleport_Array_Iterator", 1);
    // Clean away the iterator on script execution end
    DelayCommand(0.0f, DeleteLocalInt(oPC, "PRC_Teleport_Array_Iterator"));

    return GetPersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_0");
}

struct metalocation GetNextStoredTeleportTargetLocation(object oPC)
{
    // The system is only useful to PCs. If it is at some point implemented for NPCs, change this.
    if(!GetIsPC(oPC)) return GetNullMetalocation();

    // Return null if GetFirstStoredTeleportTargetLocation() hasn't been called previously
    int nInd = GetLocalInt(oPC, "PRC_Teleport_Array_Iterator");
    if(!nInd) return GetNullMetalocation();

    // If the iteration has reached the end of the array, delete the iteration counter and return null
    if(nInd > GetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME) - 1)
    {
        DeleteLocalInt(oPC, "PRC_Teleport_Array_Iterator");
        return GetNullMetalocation();
    }

    // Increment iterator and return the value
    SetLocalInt(oPC, "PRC_Teleport_Array_Iterator", nInd + 1);
    return GetPersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_" + IntToString(nInd));
}

struct metalocation GetNthStoredTeleportTargetLocation(object oPC, int nInd)
{
    // The system is only useful to PCs. If it is at some point implemented for NPCs, change this.
    if(!GetIsPC(oPC)) return GetNullMetalocation();

    // If out of lower or upper bound, return null
    if(nInd < 0 || nInd > GetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME) - 1)
        return GetNullMetalocation();

    // Return the nth stored location
    return GetPersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_" + IntToString(nInd));
}

int GetNumberOfStoredTeleportTargetLocations(object oPC)
{
    // The system is only useful to PCs. If it is at some point implemented for NPCs, change this.
    if(!GetIsPC(oPC)) return 0;

    return GetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME);
}

void RemoveCurrentTeleportTargetLocation(object oPC)
{
    // The system is only useful to PCs. If it is at some point implemented for NPCs, change this.
    if(!GetIsPC(oPC)) return;

    // Return if GetFirstStoredTeleportTargetLocation() or GetNextStoredTeleportTargetLocation() hasn't been called previously.
    int nInd = GetLocalInt(oPC, "PRC_Teleport_Array_Iterator");
    if(!nInd) return;

    // Get the index of the last element in the array and move elements back if needed
    int nMax = GetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME) - 1;
    for(; nInd < nMax; nInd++)
        SetPersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_" + IntToString(nInd),
                                       GetPersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_" + IntToString(nInd + 1))
                                       );

    // Remove the last element and mark the size change
    DeletePersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_" + IntToString(nMax));
    SetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME, nMax);

    // Delete the iteration counter to keep potential errors down.
    DeleteLocalInt(oPC, "PRC_Teleport_Array_Iterator");
}

void RemoveNthTeleportTargetLocation(object oPC, int nInd)
{
    // The system is only useful to PCs. If it is at some point implemented for NPCs, change this.
    if(!GetIsPC(oPC)) return;

    // If out of lower or upper bound, return
    if(nInd < 0 || nInd > GetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME) - 1)
        return;

    // Get the index of the last element in the array and move elements back if needed
    int nMax = GetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME) - 1;
    for(; nInd < nMax; nInd++)
        SetPersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_" + IntToString(nInd),
                                       GetPersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_" + IntToString(nInd + 1))
                                       );

    // Remove the last element and mark the size change
    DeletePersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_" + IntToString(nMax));
    SetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME, nMax);

    // Delete the iteration counter to keep potential errors down.
    DeleteLocalInt(oPC, "PRC_Teleport_Array_Iterator");
}

int AddTeleportTargetLocation(object oPC, location locToAdd, string sName)
{
    return AddTeleportTargetLocationAsMeta(oPC, LocationToMetalocation(locToAdd, sName));
}

int AddTeleportTargetLocationAsMeta(object oPC, struct metalocation mlocToAdd)
{
    // The system is only useful to PCs. If it is at some point implemented for NPCs, change this.
    if(!GetIsPC(oPC)) return FALSE;

    // Array size check. If no limit is defined via switch, default to 50.
    int nInd = GetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME); // Array elements begin at index 0
    int nMax = GetPRCSwitch(PRC_TELEPORT_MAX_TARGET_LOCATIONS) ?
                GetPRCSwitch(PRC_TELEPORT_MAX_TARGET_LOCATIONS) :
                50;
    if(nInd > nMax)
    {// You have reached the maximum allowed teleport locations (              ).\nYou must remove at least one stored location before you can add new locations.
        SendMessageToPC(oPC, GetStringByStrRef(16825294) + IntToString(nMax) + GetStringByStrRef(16825295));
        return FALSE;
    }

    // All checks passed, store the location, increment array size and return
    SetPersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_" + IntToString(nInd), mlocToAdd);
    SetPersistantLocalInt(oPC, PRC_TELEPORT_ARRAY_NAME, nInd + 1);
    return TRUE;
}



//void main(){} // Test main