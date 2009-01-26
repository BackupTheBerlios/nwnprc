///////////////////////////////////////////////////
//  Craft Poison Convo
//  prc_crft_poison
///////////////////////////////////////////////////

#include "prc_inc_spells"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                           =0;
const int STAGE_POISON                          =1;
const int STAGE_CONFIRM                         =2;

//Choice constants
const int CHOICE_ABORT_CRAFT                    =10;
const int CHOICE_CONFIRM_CRAFT                  =11;
const int CHOICE_BACK                           =12;


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
    
    int nPoison = GetSkillRank(SKILL_CRAFT_POISON, oPC);
    int nAlchem = GetSkillRank(SKILL_CRAFT_ALCHEMY, oPC);    
    
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
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                    SetHeader("Would you like to craft a poison?");
                    AddChoice("Yes.", 1);
                                       
                    MarkStageSetUp(nStage, oPC);
                    SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values            
            }
            
            if(nStage == STAGE_POISON)
            {
                                        
            }            
            
            else if (nStage == STAGE_CONFIRM)
            {
                    SetHeader("Are you sure you want to create this item?");
                    
                    AddChoice("Back", CHOICE_BACK, oPC);
                    
                    if(GetGold(oPC) >= nCost) AddChoice("Confirm", CHOICE_CONFIRM_CRAFT, oPC);
                    MarkStageSetUp(nStage);
            }            
            
            else  
            {
                    if(DEBUG) DoDebug("Invalid Stage: " + IntToString(nStage));
                    return;
            }
    }
    // Do token setup
    SetupTokens();
    
    // End of conversation cleanup
        else if(nValue == DYNCONV_EXITED)
        {
                // Add any locals set through this conversation
                DeleteLocalInt(oPC, "PRC_CRAFT_COST");
                DeleteLocalInt(oPC, "PRC_CRAFT_DC");
                DeleteLocalString(oPC, "PRC_CRAFT_RESREF");
                DeleteLocalInt(oPC, "PRC_CRAFT_SKILLUSED");
        }
        // Abort conversation cleanup.
        // NOTE: This section is only run when the conversation is aborted
        // while aborting is allowed. When it isn't, the dynconvo infrastructure
        // handles restoring the conversation in a transparent manner
        else if(nValue == DYNCONV_ABORTED)
        {
                DeleteLocalInt(oPC, "PRC_CRAFT_COST");
                DeleteLocalInt(oPC, "PRC_CRAFT_DC");
                DeleteLocalString(oPC, "PRC_CRAFT_RESREF");
                DeleteLocalInt(oPC, "PRC_CRAFT_SKILLUSED");
            // Add any locals set through this conversation
            if(DEBUG) DoDebug("prc_craft: ERROR: Conversation abort section run");
        }
        // Handle PC responses
        else
        {
            // variable named nChoice is the value of the player's choice as stored when building the choice list
            // variable named nStage determines the current conversation node
            int nChoice = GetChoice(oPC);
            if(nStage == STAGE_ENTRY)
            {
                    if(nChoice == 1) nStage = STAGE_POISON;                    
                // Move to another stage based on response, for example
                //nStage = STAGE_QUUX;
            }
            
            else if(nStage == STAGE_POISON)
            {
                    int nIP;
                    int nDC = Get2daCache(                                                    
                    nSkill = SKILL_CRAFT_POISON;             
                    
                    //Use alchemy skill if it is 5 or more higher than craft(poisonmaking). DC is increased by 4.
                    if((nAlchem - nPoison) >4)
                    {
                            nSkill = SKILL_CRAFT_ALCHEMY;
                            nDC += 4;
                    }
                                        
            }
            
            else if(nStage == STAGE_CONFIRM)
            {
                    if(nChoice == CHOICE_ABORT_CRAFT)
                    {
                            nStage = STAGE_ENTRY;
                    }
                    
                    else if(nChoice == CHOICE_CONFIRM_CRAFT)
                    {
                            int nRank = GetSkillRank(nSkill, oPC);                        
                            TakeGoldFromCreature(GetLocalInt(oPC, "PRC_CRAFT_COST"), oPC, TRUE);
                            if(GetIsSkillSuccessful(oPC, GetLocalInt(oPC,"PRC_CRAFT_SKILLUSED"), GetLocalInt(oPC, "PRC_CRAFT_DC"))) CreateItemOnObject(GetLocalString(oPC, "PRC_CRAFT_RESREF"), oPC, 1);
                            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                    }                
            }            
            // Store the stage value. If it has been changed, this clears out the choices
            SetStage(nStage, oPC);
    }
}
        