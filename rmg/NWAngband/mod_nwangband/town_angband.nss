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

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                                       = 0;
const int STAGE_SHOPPING                                    = 1000;
const int STAGE_SHOPPING_ATTITUDE                           = 1001;
const int STAGE_SHOPPING_ITEMS                              = 1002;
const int STAGE_TEMPLE                                      = 2000;
const int STAGE_INN                                         = 3000;
const int STAGE_LIBRARY                                     = 4000;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
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
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(nStage == STAGE_ENTRY)
            {
                SetHeader("It is <CUSTOM82001> on the <CUSTOM82002> of <CUSTOM82003> <CUSTOM82004> in the city of Angband. 
What do you want to do today?");
                //AddChoice("Go to the portal",               1, oPC);
                AddChoice("Go shopping",                    2, oPC);
                AddChoice("Go to the temples",              3, oPC);
                AddChoice("Go to the inns",                 4, oPC);
                AddChoice("Go to the library",              5, oPC);
                //AddChoice("Go to the council chambers",     6, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_SHOPPING)
            {
                SetHeader("What type of shopping?");
                AddChoice("Casual",                         1, oPC);
                AddChoice("Hurried",                        2, oPC);
                AddChoice("Specific",                       3, oPC);   
                AddChoice("back",                           999, oPC);         
            }
            else if(nStage == STAGE_SHOPPING_ITEMS)
            {
                SetHeader("What type of items do you wish to buy?");
                AddChoice("Weapons",                        1, oPC);
                AddChoice("Armor",                          2, oPC);
                AddChoice("Jewlery",                        3, oPC);
                AddChoice("Consumables",                    4, oPC);
                AddChoice("back",                           999, oPC);
            }
            else if(nStage == STAGE_SHOPPING_ATTITUDE)
            {
                SetHeader("How do you wish to interact with the merchants?");
                AddChoice("Normal",                             1, oPC);
                AddChoice("<StartCheck>[Intimidate]</Start>",   2, oPC);
                AddChoice("<StartCheck>[Persuade]</Start>",     3, oPC);
                AddChoice("<StartCheck>[Bluff]</Start>",        4, oPC);
                AddChoice("<StartCheck>[Appraise]</Start>",     5, oPC);
                AddChoice("<StartCheck>[Pickpocket]</Start>",   6, oPC);
                AddChoice("back",                               999, oPC);
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
        if(nStage == STAGE_ENTRY)
        {
            if(nChoice == 2)
                nStage = STAGE_SHOPPING;
            else if(nChoice == 3)
                nStage = STAGE_TEMPLE;
            else if(nChoice == 4)
                nStage = STAGE_INN;
            else if(nChoice == 5)
                nStage = STAGE_LIBRARY;
        }
        if(nStage == STAGE_SHOPPING)
        {
            if(nChoice == 999)
                nStage = STAGE_ENTRY;
            else if(nChoice == 1)
            {
                //casual shopping
                nStage = STAGE_SHOPPING_ATTITUDE;
            }
            else if(nChoice == 2)
            {
                //hurried shopping
                //DoShopping()
            }
            else if(nChoice == 3)
            {
                //specific
                nStage = STAGE_SHOPPING_ITEMS;
            }    
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
