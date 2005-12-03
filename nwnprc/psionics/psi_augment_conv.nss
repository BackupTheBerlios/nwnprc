//::///////////////////////////////////////////////
//:: Augmentation options conversation
//:: psi_augment_conv
//:://////////////////////////////////////////////
/** @file
    A conversation where the user may set up and
    modify their augmentation profiles and a few
    related settings.


    @author Ornedan
    @date   Created  - 2005.11.23
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "psi_inc_augment"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY        = 0;
const int STAGE_PROFILES     = 1;
const int STAGE_QUICKS       = 2;
const int STAGE_MISC         = 3;
const int STAGE_LEV_OR_PP    = 4;
const int STAGE_SET_DEFAULTS = 5;

const int CHOICE_BACK_TO_MAIN = -1;

const int CHOICE_RAISE_1 = 1;
const int CHOICE_LOWER_1 = 2;
const int CHOICE_RAISE_2 = 3;
const int CHOICE_LOWER_2 = 4;
const int CHOICE_RAISE_3 = 5;
const int CHOICE_LOWER_3 = 6;
const int CHOICE_RAISE_4 = 7;
const int CHOICE_LOWER_4 = 8;
const int CHOICE_RAISE_5 = 9;
const int CHOICE_LOWER_5 = 10;
const int CHOICE_SAVE    = 11;
const int CHOICE_CLEAR   = 12;

const int CHOICE_YES = 1;
const int CHOICE_NO  = 0;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void ClearLocals(object oPC)
{
    DeleteLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile");
    DeleteLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_IsQuickSelection");
    DeleteLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_Index");
}

//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void foo()//main()
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
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_ENTRY)
            {
                // Set the header
                SetHeader("This conversation manages your augmentation profiles and augmentation quickselections.");
                // Add responses for the PC
                AddChoice("View / modify augmentation profiles", STAGE_PROFILES, oPC);
                AddChoice("View / modify quickselections", STAGE_QUICKS, oPC);
                AddChoice("Special options", STAGE_MISC, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_PROFILES)
            {
                SetHeader("Select profile to modify.");

                // Back to main choice
                AddChoice("Return to main menu", CHOICE_BACK_TO_MAIN, oPC);

                // Loop over the profiles and add a choice for each
                string sChoice;
                int i;
                for(i = PRC_AUGMENT_PROFILE_INDEX_MIN; i <= PRC_AUGMENT_PROFILE_INDEX_MAX; i++)
                {
                    sChoice = IntToString(i) + " - ";
                    // HACK! Depends on the internal implementation of the profile storage
                    if(GetPersistantLocalInt(oPC, PRC_AUGMENT_PROFILE + IntToString(i)) == PRC_AUGMENT_NULL_PROFILE)
                        sChoice += GetStringByStrRef(16823968); // "Empty profile"
                    else
                        sChoice += UserAugmentationProfileToString(GetUserAugmentationProfile(oPC, i));

                    AddChoice(sChoice, i, oPC);
                }

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_QUICKS)
            {
                SetHeader("Select quickselection to modify.");

                // Back to main choice
                AddChoice("Return to main menu", CHOICE_BACK_TO_MAIN, oPC);

                // Loop over the quickselections and add a choice for each
                string sChoice;
                int i;
                for(i = PRC_AUGMENT_QUICKSELECTION_MIN; i <= PRC_AUGMENT_QUICKSELECTION_MAX; i++)
                {
                    sChoice = IntToString(i) + " - ";
                    // HACK! Depends on the internal implementation of the profile storage
                    if(GetPersistantLocalInt(oPC, PRC_AUGMENT_QUICKSELECTION + IntToString(i)) == PRC_AUGMENT_NULL_PROFILE)
                        sChoice += GetStringByStrRef(16824180); // "Empty Quickselection"
                    else
                        sChoice += UserAugmentationProfileToString(GetUserAugmentationProfile(oPC, i, TRUE));

                    AddChoice(sChoice, i, oPC);
                }

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_MISC)
            {
                SetHeader("Make your selection.");

                // Back to main choice
                AddChoice("Return to main menu", STAGE_ENTRY, oPC);

                // The augment levels / PP personal switch
                AddChoice("Set how the values in an augmentation profile are treated.", STAGE_LEV_OR_PP, oPC);
                // Set the profiles to a default that approximates the old behaviour
                AddChoice("Set augmentation profiles to a simple default", STAGE_SET_DEFAULTS, oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEV_OR_PP)
            {
                SetHeader("You may define how your personal augmentation profiles are treated. The option values may either mean how many times to use that option, or how many power points to use for that option. In the latter case, the number of times the option is used is the number of power points divided by the cost of the option, rounded down.\nCurrent setting: ");

                // Back to main choice
                AddChoice("Return to main menu", CHOICE_BACK_TO_MAIN, oPC);

                AddChoice("Change to levels.", FALSE, oPC);
                AddChoice("Change to power points.", TRUE, oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SET_DEFAULTS)
            {
                SetHeader("This will set your profiles to a simple progression, where each profile's first augmentation option's value is equal to the profile's number and all the other options are zero.\n\nThis change is irreversible, are you sure you want to do this?");

                AddChoice("Yes", CHOICE_YES, oPC);
                AddChoice("No", CHOICE_NO, oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_MODIFY_PROFILE)
            {
                struct user_augment_profile uapTemp = _DecodeProfile(GetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile"));

                SetHeader("Set the profile's values. Current:" + "\n"
                        + "Option " + "1: " + IntToString(uapTemp.nOption1) + "\n"
                        + "Option " + "2: " + IntToString(uapTemp.nOption2) + "\n"
                        + "Option " + "3: " + IntToString(uapTemp.nOption3) + "\n"
                        + "Option " + "4: " + IntToString(uapTemp.nOption4) + "\n"
                        + "Option " + "5: " + IntToString(uapTemp.nOption5)
                          );

                // The modification choices
                AddChoice("Raise option 1 value", CHOICE_RAISE_1, oPC);
                AddChoice("Lower option 1 value", CHOICE_LOWER_1, oPC);
                AddChoice("Raise option 2 value", CHOICE_RAISE_2, oPC);
                AddChoice("Lower option 2 value", CHOICE_LOWER_2, oPC);
                AddChoice("Raise option 3 value", CHOICE_RAISE_3, oPC);
                AddChoice("Lower option 3 value", CHOICE_LOWER_3, oPC);
                AddChoice("Raise option 4 value", CHOICE_RAISE_4, oPC);
                AddChoice("Lower option 4 value", CHOICE_LOWER_4, oPC);
                AddChoice("Raise option 5 value", CHOICE_RAISE_5, oPC);
                AddChoice("Lower option 5 value", CHOICE_LOWER_5, oPC);

                // Add the save choice
                AddChoice("Clear profile", CHOICE_CLEAR, oPC);
                AddChoice("Save profile", CHOICE_SAVE, oPC);
                AddChoice("Return to main menu without saving", CHOICE_BACK_TO_MAIN, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        ClearLocals(oPC);
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        ClearLocals(oPC);
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);

        // Clear the current stage's setup marker
        MarkStageNotSetUp(nStage, oPC);

        if(nStage == STAGE_ENTRY)
        {
            // From the mainmenu, the choice is the index of the stage to move to
            nStage = nChoice;
        }
        else if(nStage == STAGE_PROFILES)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN) nStage = STAGE_ENTRY;
            else
            {
                // The choice is the index of the profile to modify
                SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile", GetPersistantLocalInt(oPC, PRC_AUGMENT_PROFILE + IntToString(nChoice)));
                SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_IsQuickSelection", FALSE);
                SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_Index", nChoice);

                nStage = STAGE_MODIFY_PROFILE;
            }
        }
        else if(nStage == STAGE_QUICKS)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN) nStage = STAGE_ENTRY;
            else
            {
                // The choice is the index of the profile to modify
                SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile", GetPersistantLocalInt(oPC, PRC_AUGMENT_QUICKSELECTION + IntToString(nChoice)));
                SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_IsQuickSelection", TRUE);
                SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_Index", nChoice);

                nStage = STAGE_MODIFY_PROFILE;
            }
        }
        else if(nStage == STAGE_MISC)
        {
            // The choice is the index of the stage to move to
            nStage = nChoice;
        }
        else if(nStage == STAGE_LEV_OR_PP)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN) nStage = STAGE_ENTRY;
            else
            {
                // The value of the choice is the new value of the switch
                SetPersistantLocalInt(oPC, PRC_PLAYER_SWITCH_AUGMENT_IS_PP, nChoice);
            }
        }
        else if(nStage == STAGE_SET_DEFAULTS)
        {
            if(nChoice == CHOICE_YES)
            {
                // Loop over all profiles and set them to a new value
                struct user_augment_profile uapTemp;
                uapTemp.nOption1 = 0;
                uapTemp.nOption2 = 0;
                uapTemp.nOption3 = 0;
                uapTemp.nOption4 = 0;
                uapTemp.nOption5 = 0;

                for(i = PRC_AUGMENT_PROFILE_INDEX_MIN; i <= PRC_AUGMENT_PROFILE_INDEX_MAX; i++)
                {
                    uapTemp.nOption1 = i;
                    StoreUserAugmentationProfile(oPC, i, uapTemp, FALSE);
                }
            }

            nStage = STAGE_ENTRY;
        }
        else if(nStage == STAGE_MODIFY_PROFILE)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN) nStage = STAGE_ENTRY;
            else
            {
                struct user_augment_profile uapTemp = _DecodeProfile(GetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile"));

                // Depends on the values of the choice options being a continuous series
                if(nChoice >= CHOICE_RAISE_1 && nChoice <= CHOICE_LOWER_5)
                {
                    switch(nChoice)
                    {
                        case CHOICE_RAISE_1: uapTemp.nOption1++; break;
                        case CHOICE_LOWER_1: uapTemp.nOption1--; break;
                        case CHOICE_RAISE_2: uapTemp.nOption1++; break;
                        case CHOICE_LOWER_2: uapTemp.nOption1--; break;
                        case CHOICE_RAISE_3: uapTemp.nOption1++; break;
                        case CHOICE_LOWER_3: uapTemp.nOption1--; break;
                        case CHOICE_RAISE_4: uapTemp.nOption1++; break;
                        case CHOICE_LOWER_4: uapTemp.nOption1--; break;
                        case CHOICE_RAISE_5: uapTemp.nOption1++; break;
                        case CHOICE_LOWER_5: uapTemp.nOption1--; break;
                    }
                }
                else if(nChoice == CHOICE_CLEAR)
                {
                    uapTemp.nOption1 = 0;
                    uapTemp.nOption2 = 0;
                    uapTemp.nOption3 = 0;
                    uapTemp.nOption4 = 0;
                    uapTemp.nOption5 = 0;
                }
                else
                {
                    if(nChoice == CHOICE_SAVE)
                    {
                        StoreUserAugmentationProfile(oPC, GetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_Index"),
                                                     uapTemp, GetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_IsQuickSelection")
                                                     );
                        nStage = STAGE_ENTRY;
                    }
                    else
                    {
                        SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile", _EncodeProfile(uapTemp));
                        ClearCurrentStage(oPC);
                    }
                }


            }
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
