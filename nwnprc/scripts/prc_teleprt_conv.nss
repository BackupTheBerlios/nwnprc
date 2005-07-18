//:://////////////////////////////////////////////
//:: Teleport location selection conversation
//:: prc_teleprt_conv
//:://////////////////////////////////////////////
/** @file
    This file builds the entries for a teleport
    target selection dialog when used with the
    dynamic conversation system.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 29.05.2005
//:://////////////////////////////////////////////

#include "prc_inc_teleport"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_MAIN           = 0;
const int STAGE_SELECTION_MADE = 1;


//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void AddChoice(object oPC, string sText, int nValue)
{
    array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"), sText);
    array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), nValue);
}


void main()
{
    object oPC = OBJECT_SELF;
    int nValue = GetLocalInt(oPC, "DynConv_Var");
    array_create(oPC, "ChoiceTokens");
    array_create(oPC, "ChoiceValues");

    if(nValue == 0)
        return;
    if(nValue > 0)
        nValue --;// Change from 1-based to 0-based

    // Build system reply
    if(nValue == -1)
    {
        int nStage = GetLocalInt(oPC, "Stage");

        // Build the list of choices
        if(nStage == STAGE_MAIN && !GetLocalInt(oPC, "PRC_TeleportSelectionConvo_Setup"))
        {
            // Set the header text
            string sToken = GetStringByStrRef(16825270); // "Select location to use"
            SetCustomToken(99, sToken);

            int i;
            struct metalocation mlocL;
            // Print the quickselections up front

            for(i = 1; i < NUM_TELEPORT_QUICKSELECTS; i++)
            {//          Quickselection
                sToken = GetStringByStrRef(16825271) + " " + IntToString(i) + ": ";
                if(GetLocalInt(oPC, "PRC_Teleport_QuickSelection_" + IntToString(i)))
                {
                    mlocL = GetLocalMetalocation(oPC, "PRC_Teleport_QuickSelection_" + IntToString(i));
                    sToken += MetalocationToString(mlocL);
                    AddChoice(oPC, sToken, -i);
                }
            }

            // Print the contents of the array, skipping any locations not in the current module
            int nMax = GetNumberOfStoredTeleportTargetLocations(oPC);
            for(i = 0; i < nMax; i++)
            {
                mlocL = GetNthStoredTeleportTargetLocation(oPC, i);
                if(GetIsMetalocationInModule(mlocL))
                    AddChoice(oPC, MetalocationToString(mlocL), i);
            }

            SetLocalInt(oPC, "PRC_TeleportSelectionConvo_Setup", TRUE);
        }
        // The user made their selection
        else if(nStage == STAGE_SELECTION_MADE)
        {
            // Set the header text
            string sToken = GetStringByStrRef(16825306); // "Selection made. Select finish to continue."
            SetCustomToken(99, sToken);

            // Get the metalocation to store
            int nReturn = GetLocalInt(oPC, "PRC_TeleportSelectionConvo_Selection");
            struct metalocation mlocL = nReturn < 0 ? // Is it a quickselection?
                                        GetLocalMetalocation(oPC, "PRC_Teleport_QuickSelection_" + IntToString(-nReturn)) :
                                        GetNthStoredTeleportTargetLocation(oPC, nReturn);
            // Store the return value
            if(GetLocalInt(oPC, "PRC_TeleportTargetSelection_ReturnAsMetalocation"))
                SetLocalMetalocation(oPC,
                                     GetLocalString(oPC, "PRC_TeleportTargetSelection_ReturnStoreName"),
                                     mlocL);
            else
                SetLocalLocation(oPC,
                                 GetLocalString(oPC, "PRC_TeleportTargetSelection_ReturnStoreName"),
                                 MetalocationToLocation(mlocL));
            // Mark the conversation as finished.
            SetLocalInt(oPC, "PRC_TeleportSelectionMade", TRUE);
        }
        
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

        // END OF INSERT FOR THE HEADER
        return;
    }
    // Conversation ended normally
    else if(nValue == -2)
    {
        // Check if the user is allowed to exit the conversation without making a selection
        if(!GetLocalInt(oPC, "PRC_TeleportSelectionMade") &&
           GetLocalInt(oPC, "PRC_TeleportTargetSelection_DisallowConversationAbort")
           )
        {
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE));
        }
        else
        {
            // Schedule the callback script to be run
            //SendMessageToPC(oPC, "Running script " + GetLocalString(oPC, "PRC_TeleportTargetSelection_CallbackScript"));
            string sScript = GetLocalString(oPC, "PRC_TeleportTargetSelection_CallbackScript");
            DelayCommand(0.3f, ExecuteScript(sScript, oPC));
            
            DeleteLocalInt(oPC, "DynConv_Var");
            array_delete(oPC, "ChoiceTokens");
            array_delete(oPC, "ChoiceValues");
            DeleteLocalInt(oPC, "Stage");
            DeleteLocalString(oPC, "DynConv_Script");
            int i;
            for(i = 99; i <= 110; i++)
                DeleteLocalString(oPC, "TOKEN" + IntToString(i));

            DeleteLocalInt(oPC, "PRC_TeleportSelectionConvo_Setup");
            DeleteLocalInt(oPC, "PRC_TeleportSelectionConvo_Selection");
            DeleteLocalInt(oPC, "PRC_TeleportSelectionMade");
            DeleteLocalInt(oPC, "PRC_TeleportTargetSelection_DisallowConversationAbort");
            DeleteLocalString(oPC, "PRC_TeleportTargetSelection_CallbackScript");
            DeleteLocalString(oPC, "PRC_TeleportTargetSelection_ReturnStoreName");
            DeleteLocalInt(oPC, "PRC_TeleportTargetSelection_ReturnAsMetalocation");
        }

        return;
    }
    // Conversation aborted
    else if(nValue == -3)
    {
        // Restart the conversation if necessary
        if(GetLocalInt(oPC, "PRC_TeleportTargetSelection_DisallowConversationAbort"))
        {
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE));
        }
        // Cleanup
        else
        {
            DeleteLocalInt(oPC, "DynConv_Var");
            array_delete(oPC, "ChoiceTokens");
            array_delete(oPC, "ChoiceValues");
            DeleteLocalInt(oPC, "Stage");
            DeleteLocalString(oPC, "DynConv_Script");
            int i;
            for(i = 99; i <= 110; i++)
                DeleteLocalString(oPC, "TOKEN" + IntToString(i));

            DeleteLocalInt(oPC, "PRC_TeleportSelectionConvo_Setup");
            DeleteLocalInt(oPC, "PRC_TeleportSelectionConvo_Selection");
            DeleteLocalInt(oPC, "PRC_TeleportSelectionMade");
            DeleteLocalInt(oPC, "PRC_TeleportTargetSelection_DisallowConversationAbort");
            DeleteLocalString(oPC, "PRC_TeleportTargetSelection_CallbackScript");
            DeleteLocalString(oPC, "PRC_TeleportTargetSelection_ReturnStoreName");
            DeleteLocalInt(oPC, "PRC_TeleportTargetSelection_ReturnAsMetalocation");
        }

        return;
    }
    nValue = array_get_int(oPC, "ChoiceValues", nValue);
    int nStage = GetLocalInt(oPC, "Stage");
    if(nStage == STAGE_MAIN)
    {
        nStage = 1;
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");

        SetLocalInt(oPC, "PRC_TeleportSelectionConvo_Selection", nValue);
    }
    SetLocalInt(oPC, "Stage", nStage);
}