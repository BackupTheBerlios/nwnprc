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

#include "inc_dynconv"
#include "ral_inc"
#include "rad_inc"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY     = 0;
const int STAGE_FIRST_1 = 100;


//////////////////////////////////////////////////
/* Aid functions                                */
////////////////////////////////////////////////// 

//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    DoDebug("running plot_mol_conv");
    object oPC = GetPCSpeaker();
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
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_ENTRY)
            {
                /*
                ***************************************************
                
                For the moment, this just jumps you straight into the main world
                No plot, no backstory, nothing. Just for testing purposes really :)
                
                */
                SpawnAndJumpByAreaType(oPC, 1, "rad_spec_portal_r", "nwa_portal");                   
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);                                
                return;
                
                
                /*
                ***************************************************
                */
            
                //first time through
                if(!GetLocalInt(OBJECT_SELF, "DoOnce"))
                {
                    SetLocalInt(OBJECT_SELF, "DoOnce", TRUE);
                    string sText;
                    sText += "If you do not know what I am, then I have failed and you must correct my mistake.\n";
                    sText += "There was a being who conducted an experiment; I am a "+
                        "fragment of that being, and I am here to guide you through "+
                        "completing that experiment.\n";
                    sText += "I cannot tell you more information at this time. If you understand "+
                        "too much it will be dangerous for you and there will be future effects. It is "+
                        "enough that you understand you must follow my instructions."+"\n";
                    sText += "This location is place beyond reality as you understand "+
                        "it. Nothing can harm you here except that which you bring in yourself."+"\n";
                    sText += "My instructions are precise and accurate, however you may not understand the "+
                        "reasoning or purpose behind them. Do not be alarmed and remember if you "+
                        "follow my instructions fully then the experiment will be completed."+"\n";
                    SetHeader(sText);
                    AddChoice("[continue]", 99, oPC);
                }
                else
                {
                    //returning, ask what they want
                    SetHeader("Are you ready for the next quest? Or do you want something else");
                    AddChoice("(quest)", 1, oPC);
                    AddChoice("(shoping)", 2, oPC);
                }

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            //add more stages for more nodes with Else If clauses
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(OBJECT_SELF, "InDynConvoMarker");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(OBJECT_SELF, "InDynConvoMarker");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            if(nChoice == 99)
            {
                //continue intro
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if(nChoice == 1)
            {
                //start quest
                    
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if(nChoice == 2)
            {
                //shopping
            }
            // Move to another stage based on response, for example
            //nStage = STAGE_QUUX;
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
