//:://////////////////////////////////////////////
//:: Shifter shifting options management conversation
//:: prc_shift_convo
//:://////////////////////////////////////////////
/** @file
    PnP Shifter shifting & shifting options management
    conversation script.

    @todo Externalise spoken strings


    @author Ornedan
    @date   Created  - 2006.03.01
    @date   Modified - 2006.10.07 - Finished
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_inc_shifting"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                   = 0;
const int STAGE_CHANGESHAPE             = 1;
const int STAGE_LISTQUICKSHIFTS         = 2;
const int STAGE_DELETESHAPE             = 3;
const int STAGE_SETTINGS                = 4;
const int STAGE_SELECTQUICKSHIFTTYPE    = 5;
const int STAGE_SELECTQUICKSHIFTSHAPE   = 6;


const int CHOICE_CHANGESHAPE            = 1;
const int CHOICE_CHANGESHAPE_EPIC       = 2;
const int CHOICE_LISTQUICKSHIFTS        = 3;
const int CHOICE_DELETESHAPE            = 6;
const int CHOICE_SETTINGS               = 7;

const int CHOICE_DRUIDWS                = 1;

const int CHOICE_NORMAL                 = 1;
const int CHOICE_EPIC                   = 2;

const int CHOICE_BACK_TO_MAIN = -1;
const int STRREF_BACK_TO_MAIN = 16824794;  // "Back to main menu"

const string EPICVAR        = "PRC_ShiftConvo_Epic";
const string QSMODIFYVAR    = "PRC_ShiftConvo_QSToModify";

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void GenerateShapeList(object oPC)
{
    int i, nArraySize = GetNumberOfStoredTemplates(oPC, SHIFTER_TYPE_SHIFTER);

    for(i = 0; i < nArraySize; i++)
        AddChoice(GetStoredTemplateName(oPC, SHIFTER_TYPE_SHIFTER, i), i, oPC);
}




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
                SetHeader("Shifter options:");
                // Add responses for the PC
                AddChoice("Change shape",                                     CHOICE_CHANGESHAPE,      oPC);
                if(GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC) >= 10)
                    AddChoice("Change shape (epic)",                          CHOICE_CHANGESHAPE_EPIC, oPC);
                AddChoice("View / Assign shapes to your 'Quick Shift Slots'", CHOICE_LISTQUICKSHIFTS,  oPC);
                AddChoice("Delete shapes you do not want anymore",            CHOICE_DELETESHAPE,      oPC);
                AddChoice("Special settings",                                 CHOICE_SETTINGS,         oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens();          // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CHANGESHAPE)
            {
                SetHeader(GetLocalInt(oPC, EPICVAR) ?
                          "Select epic shape to become" :
                          "Select shape to become"
                          );

                // The list may be long, so list the back choice first
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN, oPC);

                GenerateShapeList(oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LISTQUICKSHIFTS)
            {
                SetHeader("Select a 'Quick Shift Slot' to change the shape stored in it");

                int i;
                for(i = 1; i <= 10; i++)
                    AddChoice("Quick Shift Slot" + " " + IntToString(i) + " - "
                            + (GetLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(i) + "_ResRef") != "" ?
                               GetLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(i) + "_Name") :
                               GetStringByStrRef(16825282) // "Blank"
                               ),
                              i, oPC);

                AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN, oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SELECTQUICKSHIFTTYPE)
            {
                SetHeader("Select whether you want this 'Quick Shift Slot' to use a normal shift or an epic shift.");

                AddChoice("Normal", CHOICE_NORMAL, oPC);
                AddChoice("Epic",   CHOICE_EPIC,   oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SELECTQUICKSHIFTSHAPE)
            {
                SetHeader(GetLocalInt(oPC, EPICVAR) ?
                          "Select epic shape to store" :
                          "Select shape to store"
                          );

                // The list may be long, so list the back choice first
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN, oPC);

                GenerateShapeList(oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_DELETESHAPE)
            {
                SetHeader("Select shape to delete.\nNote that if the shape is stored in any quickslots, the shape will still remain in those until you change their contents.");

                // The list may be long, so list the back choice first
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN, oPC);

                GenerateShapeList(oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SETTINGS)
            {
                SetHeader("Select special setting to alter.");

                AddChoice("Toggle using Druid Wildshape uses for Shifter Greater Wildshape when out of GWS uses. Current state: "
                        + (GetLocalInt(oPC, "PRC_Shifter_UseDruidWS") ?
                           "On" :
                           "Off"
                           ),
                          CHOICE_DRUIDWS, oPC);


                AddChoice(GetStringByStrRef(STRREF_BACK_TO_MAIN), CHOICE_BACK_TO_MAIN, oPC);

                MarkStageSetUp(nStage, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, EPICVAR);
        DeleteLocalInt(oPC, QSMODIFYVAR);
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, EPICVAR);
        DeleteLocalInt(oPC, QSMODIFYVAR);
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            switch(nChoice)
            {
                case CHOICE_CHANGESHAPE_EPIC:
                    SetLocalInt(oPC, EPICVAR, TRUE);
                case CHOICE_CHANGESHAPE:
                    nStage = STAGE_CHANGESHAPE;
                    break;

                case CHOICE_LISTQUICKSHIFTS:
                    nStage = STAGE_LISTQUICKSHIFTS;
                    break;
                case CHOICE_DELETESHAPE:
                    nStage = STAGE_DELETESHAPE;
                    break;
                case CHOICE_SETTINGS:
                    nStage = STAGE_SETTINGS;
                    break;

                default:
                    DoDebug("prc_shift_convo: ERROR: Unknown choice value at STAGE_ENTRY: " + IntToString(nChoice));
            }
        }
        else if(nStage == STAGE_CHANGESHAPE)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Something chosen to be shifted into
            else
            {
                // Choice is index into the template list
                ShiftIntoResRef(oPC, SHIFTER_TYPE_SHIFTER, GetStoredTemplate(oPC, SHIFTER_TYPE_SHIFTER, nChoice), GetLocalInt(oPC, EPICVAR));

                // The convo should end now
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
        }
        else if(nStage == STAGE_LISTQUICKSHIFTS)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Something slot chosen to be modified
            else
            {
                // Store the number of the slot to be modified
                SetLocalInt(oPC, QSMODIFYVAR, nChoice);
                // If the character is an epic shifter, they can select whether the quickselection is normal or epic shift
                if(GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oPC) >= 10)
                    nStage = STAGE_SELECTQUICKSHIFTTYPE;
                else
                    nStage = STAGE_SELECTQUICKSHIFTSHAPE;
            }
        }
        else if(nStage == STAGE_SELECTQUICKSHIFTTYPE)
        {
            // Set the marker variable if they chose epic
            if(nChoice == CHOICE_EPIC)
                SetLocalInt(oPC, EPICVAR, TRUE);

            nStage = STAGE_SELECTQUICKSHIFTSHAPE;
        }
        else if(nStage == STAGE_SELECTQUICKSHIFTSHAPE)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Something chosen to be stored
            else
            {
                // Store the chosen template into the quickslot, choice is the template's index in the main list
                int nSlot = GetLocalInt(oPC, QSMODIFYVAR);
                SetLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(nSlot) + "_ResRef",
                               GetStoredTemplate(oPC, SHIFTER_TYPE_SHIFTER, nChoice)
                               );
                SetLocalString(oPC, "PRC_Shifter_Quick_" + IntToString(nSlot) + "_Name",
                               GetStoredTemplateName(oPC, SHIFTER_TYPE_SHIFTER, nChoice)
                             + (GetLocalInt(oPC, EPICVAR) ? " (epic)" : "")
                               );

                // Clean up
                DeleteLocalInt(oPC, EPICVAR);
                DeleteLocalInt(oPC, QSMODIFYVAR);

                // Return to main menu
                nStage = STAGE_ENTRY;
            }
        }
        else if(nStage == STAGE_DELETESHAPE)
        {
            // Something was chosen for deletion?
            if(nChoice != CHOICE_BACK_TO_MAIN)
            {
                // Choice is index into the template list
                DeleteStoredTemplate(oPC, SHIFTER_TYPE_SHIFTER, nChoice);
            }

            // Return to main menu in any case
            nStage = STAGE_ENTRY;
        }
        else if(nStage == STAGE_SETTINGS)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Toggle using Druid Wildshape for Greater Wildshape
            else if(nChoice == CHOICE_DRUIDWS)
            {
                SetLocalInt(oPC, "PRC_Shifter_UseDruidWS", !GetLocalInt(oPC, "PRC_Shifter_UseDruidWS"));
                nStage = STAGE_ENTRY;
            }
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
