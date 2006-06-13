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
#include "ral_inc"
#include "time_tokensetup"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                                       = 0;
const int STAGE_SHOPPING                                    = 1000;
const int STAGE_SHOPPING_ATTITUDE                           = 1001;
const int STAGE_SHOPPING_ITEMS                              = 1002;
const int STAGE_SHOPPING_LEVEL                              = 1003;
const int STAGE_SHOPPING_CONFIRM                            = 1004;
const int STAGE_TEMPLE                                      = 2000;
const int STAGE_INN                                         = 3000;
const int STAGE_LIBRARY                                     = 4000;
const int STAGE_PORTAL                                      = 5000;


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
                SetupTimeTokens();
                SetHeader("It is "+GetTokenIDString(82001)+" on the "+GetTokenIDString(82002)+" of "+GetTokenIDString(82003)+" "+GetTokenIDString(82004)+" in the city of Angband.\nWhat do you want to do today?");
                AddChoice("Go to the portal",               1, oPC);
                //can only go shopping 8am-8pm
                if(GetTimeHour() >= 8 
                    && GetTimeHour() < 20)
                    AddChoice("Go shopping",                    2, oPC);
                //AddChoice("Go to the temple",               3, oPC);
                AddChoice("Go to the inn",                  4, oPC);
                //AddChoice("Go to the library",              5, oPC);
                //AddChoice("Go to the council chambers",     6, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_SHOPPING)
            {
                //some inital cleanup
                DeleteLocalInt(oPC, "Shopping_Attitude");
                DeleteLocalInt(oPC, "Shopping_ItemType");
                DeleteLocalInt(oPC, "Shopping_ItemLevel");
                DeleteLocalInt(oPC, "Shopping_Hours");
                
                SetHeader("What type of shopping?");
                AddChoice("Casual",                         1, oPC);
                AddChoice("Hurried",                        2, oPC);
                AddChoice("Specific",                       3, oPC);   
                AddChoice("back",                           999, oPC);   

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values      
            }
            else if(nStage == STAGE_SHOPPING_ITEMS)
            {
                SetHeader("What type of items do you wish to buy?");
                AddChoice("Weapons",                        1, oPC);
                AddChoice("Armor",                          2, oPC);
                AddChoice("Jewlery",                        3, oPC);
                AddChoice("Consumables",                    4, oPC);
                AddChoice("back",                           999, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_SHOPPING_ATTITUDE)
            {
                SetHeader("How do you wish to interact with the merchants?");
                AddChoice("Normal",                             1, oPC);
                AddChoice("<StartCheck>[Intimidate]</Start>",   2, oPC);
                AddChoice("<StartCheck>[Persuade]</Start>",     3, oPC);
                AddChoice("<StartCheck>[Bluff]</Start>",        4, oPC);
                AddChoice("<StartCheck>[Pickpocket]</Start>",   5, oPC);
                AddChoice("back",                               999, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_SHOPPING_LEVEL)
            {
                SetHeader("What quality of items do you wish to shop for?");
                //add levels in decreasing order
                int i;
                for(i=GetECL(oPC);i>0;i--)
                {
                    AddChoice("Level "+IntToString(i), i);
                }
                AddChoice("back",                               999, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_SHOPPING_CONFIRM)
            {
                string sHeader;
                int nHours = GetLocalInt(oPC, "Shopping_Hours");
                int nAttitude = GetLocalInt(oPC, "Shopping_Attitude");
                int nType = GetLocalInt(oPC, "Shopping_ItemType");
                int nLevel = GetLocalInt(oPC, "Shopping_ItemLevel");
                sHeader = "You will be shopping for "+IntToString(nHours)+" hours.";
                if(nAttitude)
                {
                    switch(nAttitude)
                    {
                        case 2:
                            sHeader+="\nYou are shopping using <StartCheck>[Intimidate]</Start> (significantly non-good, very minor non-lawful)";
                            break;
                        case 3:
                            sHeader+="\nYou are shopping using <StartCheck>[Persuade]</Start> (minor non-lawful)";
                            break;
                        case 4:
                            sHeader+="\nYou are shopping using <StartCheck>[Bluff]</Start> (minor non-good, very minor non-lawful)";
                            break;
                        case 5:
                            sHeader+="\nYou are shopping using <StartCheck>[Pickpocket]</Start> (significantly non-good, minor non-lawful)";
                            break;
                    }
                }
                if(nType)
                {
                    switch(nType)
                    {
                        case 1:
                            sHeader+="\nYou are shopping for weapons";
                            break;
                        case 2:
                            sHeader+="\nYou are shopping for armor";
                            break;
                        case 3:
                            sHeader+="\nYou are shopping for jewlery";
                            break;
                        case 4:
                            sHeader+="\nYou are shopping for comsumeables";
                            break;
                    }
                }
                if(nLevel)
                {
                    sHeader+="\nYou are shopping for level "+IntToString(nLevel)+" items.";
                }
                sHeader += "\n";
                sHeader += "\nIs this correct?";
                SetHeader(sHeader);
                AddChoice("Yes",                                  1, oPC);
                AddChoice("No",                                 999, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_PORTAL)
            {
                SetHeader("Are you sure you wish to enter the Portal?");
                AddChoice("Yes",                                1, oPC);
                AddChoice("No",                                 2, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_INN)
            {
                SetHeader("Are you sure you wish to enter the Inn?");
                AddChoice("Yes",                                1, oPC);
                AddChoice("No",                                 2, oPC);

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
        DeleteLocalInt(oPC, "Shopping_Attitude");
        DeleteLocalInt(oPC, "Shopping_ItemType");
        DeleteLocalInt(oPC, "Shopping_ItemLevel");
        DeleteLocalInt(oPC, "Shopping_Hours");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, "Shopping_Attitude");
        DeleteLocalInt(oPC, "Shopping_ItemType");
        DeleteLocalInt(oPC, "Shopping_ItemLevel");
        DeleteLocalInt(oPC, "Shopping_Hours");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            if(nChoice == 1)
            {
                nStage = STAGE_PORTAL;
                MarkStageNotSetUp(nStage);
                object oPortal = GetNearestObjectByTag("Sewer_Portal");
                AssignCommand(oPC, JumpToObject(oPortal));
            }    
            else if(nChoice == 2)
            {
                nStage = STAGE_SHOPPING;
                MarkStageNotSetUp(nStage);
                object oPortal = GetNearestObjectByTag("Angband_Merchant");
                AssignCommand(oPC, JumpToObject(oPortal));
            }    
            else if(nChoice == 3)
            {
                nStage = STAGE_TEMPLE;
                MarkStageNotSetUp(nStage);
                object oPortal = GetNearestObjectByTag("Angband_Temple");
                AssignCommand(oPC, JumpToObject(oPortal));
            }    
            else if(nChoice == 4)
            {
                nStage = STAGE_INN;
                MarkStageNotSetUp(nStage);
                object oPortal = GetNearestObjectByTag("Angband_Inn");
                AssignCommand(oPC, JumpToObject(oPortal));
            }    
            else if(nChoice == 5) 
                nStage = STAGE_LIBRARY;
        }
        else if(nStage == STAGE_SHOPPING)
        {
            if(nChoice == 999)
            {
                nStage = STAGE_ENTRY;
                MarkStageNotSetUp(nStage);
            }    
            else if(nChoice == 1)
            {
                //casual shopping
                SetLocalInt(oPC, "Shopping_Hours", 8);
                nStage = STAGE_SHOPPING_ATTITUDE;
                MarkStageNotSetUp(nStage);
            }
            else if(nChoice == 2)
            {
                //hurried shopping
                SetLocalInt(oPC, "Shopping_Hours", 2);
                SetLocalInt(oPC, "Shopping_ItemLevel", GetECL(oPC));
                nStage = STAGE_SHOPPING_CONFIRM;
                MarkStageNotSetUp(nStage);
            }
            else if(nChoice == 3)
            {
                //specific
                SetLocalInt(oPC, "Shopping_Hours", 8);
                nStage = STAGE_SHOPPING_ITEMS;
                MarkStageNotSetUp(nStage);
            }    
        }
        else if(nStage == STAGE_SHOPPING_ATTITUDE)
        {
            if(nChoice == 999)
            {
                nStage = STAGE_SHOPPING;
                MarkStageNotSetUp(nStage);
            }    
            else
            {
                SetLocalInt(oPC, "Shopping_Attitude", nChoice);
                nStage = STAGE_SHOPPING_LEVEL;
                MarkStageNotSetUp(nStage);            
            }
                /*
                AddChoice("Normal",                             1, oPC);
                AddChoice("<StartCheck>[Intimidate]</Start>",   2, oPC);
                AddChoice("<StartCheck>[Persuade]</Start>",     3, oPC);
                AddChoice("<StartCheck>[Bluff]</Start>",        4, oPC);
                AddChoice("<StartCheck>[Appraise]</Start>",     5, oPC);
                AddChoice("<StartCheck>[Pickpocket]</Start>",   6, oPC);
                */
        }
        else if(nStage == STAGE_SHOPPING_ITEMS)
        {
            if(nChoice == 999)
            {
                nStage = STAGE_SHOPPING;
                MarkStageNotSetUp(nStage);
            }    
            else
            {
                SetLocalInt(oPC, "Shopping_ItemType", nChoice);
                nStage = STAGE_SHOPPING_ATTITUDE;
                MarkStageNotSetUp(nStage);            
            }
                /*
            AddChoice("Weapons",                        1, oPC);
            AddChoice("Armor",                          2, oPC);
            AddChoice("Jewlery",                        3, oPC);
            AddChoice("Consumables",                    4, oPC);
                */
        }
        else if(nStage == STAGE_SHOPPING_LEVEL)
        {
            if(nChoice == 999)
            {
                nStage = STAGE_SHOPPING;
                MarkStageNotSetUp(nStage);
            }    
            else
            {
                SetLocalInt(oPC, "Shopping_ItemLevel", nChoice);
                nStage = STAGE_SHOPPING_CONFIRM;
                MarkStageNotSetUp(nStage);            
            }
        }
        else if(nStage == STAGE_PORTAL)
        {
            if(nChoice == 2)
            {
                nStage = STAGE_ENTRY;
                MarkStageNotSetUp(nStage);
            }
            else if(nChoice == 1)
            {
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);    
                SetCutsceneMode(oPC, FALSE);
                PRCForceRest(oPC);
                object oPortal = GetNearestObjectByTag("Sewer_Portal");
                RAL_DoTransition(oPC, oPortal);
            }
        }
        else if(nStage == STAGE_INN)
        {
            if(nChoice == 2)
            {
                nStage = STAGE_ENTRY;
                MarkStageNotSetUp(nStage);
            }
            else if(nChoice == 1)
            {
                AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
                object oPortal = GetNearestObjectByTag("Angband_Inn_Inside");
                AssignCommand(oPC, JumpToObject(oPortal));
            }
        }
        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
