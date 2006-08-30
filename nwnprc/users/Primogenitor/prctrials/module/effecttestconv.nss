//:://////////////////////////////////////////////
//:: Short description
//:: filename
//:://////////////////////////////////////////////
/** @file
    Long description


    @author Joe Random
    @date   Created  - yyyy.mm.dd
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_EFFECT        = 0;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void AddEffectList(int nMin, int nMax, int nInterval);
void AddEffectList(int nMin, int nMax, int nInterval)
{
    int i;
    for(i=nMin; i<nMin+nInterval && i<nMax; i++)
    {
        string sLabel = Get2DACache("visualeffects", "Label", i);
        string sType = Get2DACache("visualeffects", "Type_FD", i);
        if(sType != "")
            AddChoice(sLabel, i);
    }
    if(i<nMax)
        DelayCommand(0.0, AddEffectList(nMin+nInterval, nMax, nInterval));
}    

void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetObjectByTag("EffectCreature");
    /* Get the value of the local variable set by the conversation script calling
     * this script. Values:
     * DYNCONV_ABORTED     Conversation aborted
     * DYNCONV_EXITED      Conversation exited via the exit node
     * DYNCONV_SETUP_STAGE System's reply turn
     * 0                   Error - something else called the script
     * Other               The user made a choice
     */
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    // The stage is used to determine the active conversation node.
    // 0 is the entry node.
    int nStage = GetStage(oPC);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(nStage == STAGE_EFFECT)
            {
                SetHeader("Select an effect");
                AddEffectList(0, 1500, 200);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_EFFECT)
        {
            string sType = Get2DACache("visualeffects", "Type_FD", nChoice);
            //fnf effect
            if(sType == "F")
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nChoice), GetLocation(oTarget));
            else if(sType == "D")
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nChoice), oTarget, 6.0);
            else if(sType == "P")
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nChoice), oTarget);
            else if(sType == "B")
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(nChoice, OBJECT_SELF, BODY_NODE_CHEST), oTarget, 6.0);            
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
