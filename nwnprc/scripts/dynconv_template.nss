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

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY = 0;

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
        if(nStage == STAGE_ENTRY)
        {
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
        return;
    }
    else if(nValue == -3)
    {
      //abort conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "Stage");
        return;
    }
    int nChoice = array_get_int(oPC, "ChoiceValues", nValue);
    int nStage = GetLocalInt(oPC, "Stage");
// INSERT CODE HERE FOR PC RESPONSES
// variable named nChoice is the value of the player's choice as stored when building the choice list
// variable named nStage determines the current conversation node
    if(nStage == STAGE_ENTRY)
    {
        //move to another stage based on response
        //nStage = STAGE_FOO;
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
