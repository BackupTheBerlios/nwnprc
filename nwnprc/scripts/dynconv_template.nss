//:://////////////////////////////////////////////
//:: Short description
//:: filename
//:://////////////////////////////////////////////
/** @file
    Long description
*/
//:://////////////////////////////////////////////
//:: Created By: Joe Random
//:: Created On: dd.mm.yyyy
//:: Modified By: Jane Random
//:: Modified On: dd.mm.yyyy
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_utility"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY = 0;

void main()
{
    object oPC = GetPCSpeaker(); 
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
        array_create(oPC, "StagesSetup");
        if(array_get_int(oPC, "StagesSetup", nStage))
            return; //this stops list duplication when scrolling
            
        // token        99 = header             This must be set directly
        // token 100 - 109 = player choices     This is set automatically from the arrays
        // array named ChoiceTokens for strings                        \_ The function AddChoice can be used for easy manipulation of these
        // array named ChoiceValues for ints associated with responces /
        // variable named nStage determines the current conversation node
        if(nStage == STAGE_ENTRY)
        {
            array_set_int(oPC, "StagesSetup", nStage, TRUE); //this lets it know that its setup so dont set it up again
        }
        //add more stages for more nodes with Else If clauses
        
        //do token setup
        SetupTokens();
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
        DeleteLocalString(oPC, "DynConv_Script");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_delete(oPC, "StagesSetup");
        DeleteLocalInt(oPC, "Stage");
        //add any other locals set through this conversation
        return;
    }
    else if(nValue == -3)
    {
        //abort conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
        DeleteLocalString(oPC, "DynConv_Script");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_delete(oPC, "StagesSetup");
        DeleteLocalInt(oPC, "Stage");
        //add any other locals set through this conversation
        return;
    }
    SetupTokens();
    int nChoice = array_get_int(oPC, "ChoiceValues", nValue+GetLocalInt(oPC, "ChoiceOffset"));
    int nStage = GetLocalInt(oPC, "Stage");
    int nOldStage = nStage;
    // INSERT CODE HERE FOR PC RESPONSES
    // variable named nChoice is the value of the player's choice as stored when building the choice list
    // variable named nStage determines the current conversation node
    if(nStage == STAGE_ENTRY)
    {
        //move to another stage based on response
        //nStage = STAGE_FOO;
    }
    // Clean up the old choice data if stage changed
    if(nStage != nOldStage)
    {
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
    }

    // Store the new stage value
    SetLocalInt(oPC, "Stage", nStage);
}
