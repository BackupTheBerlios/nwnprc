//:://////////////////////////////////////////////
//:: PRC Switch manipulation conversation
//:: prc_switchesc
//:://////////////////////////////////////////////
/** @file
    This conversation is used for changing values
    of the PRC switches ingame.

    @todo Primo: TLKify this

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY               = 0;
const int STAGE_SWITCHES            = 1;
const int STAGE_SWITCHES_VALUE      = 2;
const int STAGE_EPIC_SPELLS         = 3;
const int STAGE_EPIC_SPELLS_ADD     = 4;
const int STAGE_EPIC_SPELLS_REMOVE  = 5;
const int STAGE_EPIC_SPELLS_CONTING = 6;
const int STAGE_SHOPS               = 7;

const int CHOICE_RETURN_TO_PREVIOUS = 0xFFFFFFFF;


//////////////////////////////////////////////////
/* Aid functions                                */
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
            if(nStage == STAGE_ENTRY)
            {
                SetHeader("What do you want to do?");
                AddChoice("Alter code switches.", 1);
                AddChoice("Manage Epic Spells.", 2);
                AddChoice("Purchase general items, such as scrolls or crafting materials.", 3);
                AddChoice("Identify everything in my inventory.", 4);

                MarkStageSetUp(nStage, oPC);
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_SWITCHES)
            {
                SetHeader("Select a variable to modify.\n"
                        + "See prc_inc_switches for descriptions.\n"
                        + "In most cases zero is off and any other value is on."
                         );

                // Get the switches container waypoint, and call the builder function if it doesn't exist yet (it should)
                object oWP = GetWaypointByTag("PRC_Switch_Name_WP");
                if(!GetIsObjectValid(oWP))
                {
                    if(DEBUG) DoDebug("prc_switchesc: PRC_Switch_Name_WP did not exist, attempting creation");
                    CreateSwitchNameArray();
                    oWP = GetWaypointByTag("PRC_Switch_Name_WP");
                    if(DEBUG) DoDebug("prc_switchesc: PRC_Switch_Name_WP " + (GetIsObjectValid(oWP) ? "created":"not created"));
                }
                int i;
                for(i = 0; i < array_get_size(oWP, "Switch_Name"); i++)
                {
                    AddChoice(array_get_string(oWP, "Switch_Name", i), i, oPC);
                }

                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SWITCHES_VALUE)
            {
                string sVarName = GetLocalString(oPC, "VariableName");
                int nVal = GetPRCSwitch(sVarName);

                SetHeader("CurrentValue is: " + IntToString(nVal) + "\n"
                        + "CurrentVariable is: " + sVarName + "\n"
                        + "Select an ammount to modify the variable by:"
                          );

                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);
                AddChoice("-10", -10);
                AddChoice("-5", -5);
                AddChoice("-4", -4);
                AddChoice("-3", -3);
                AddChoice("-2", -2);
                AddChoice("-1", -1);
                AddChoice("+1", 1);
                AddChoice("+2", 2);
                AddChoice("+3", 3);
                AddChoice("+4", 4);
                AddChoice("+5", 5);
                AddChoice("+10", 10);
            }
            else if(nStage == STAGE_EPIC_SPELLS)
            {
                SetHeader("Make a selection.");
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);
                AddChoice("Remove an Epic Spell from the radial menu.", 1);
                AddChoice("Add an Epic Spell to the radial menu.", 2);
                AddChoice("Manage any active contingencies.", 3);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_EPIC_SPELLS_ADD)
            {
                SetCustomToken(99, "Choose the spell to add.");
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_EPIC_SPELLS_REMOVE)
            {
                SetCustomToken(99, "Choose the spell to remove.");
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_EPIC_SPELLS_CONTING)
            {
                SetCustomToken(99, "Choose an active contingency to dispel. Dispelling will preemptively end the contingency and restore the reserved epic spell slot for your use.");
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        //end of conversation cleanup
        array_delete(oPC, "StagesSetup");
        DeleteLocalString(oPC, "VariableName");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        //abort conversation cleanup
        array_delete(oPC, "StagesSetup");
        DeleteLocalString(oPC, "VariableName");
    }
    else
    {
        // PC response handling
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if(nChoice == 1)
                nStage = STAGE_SWITCHES;
            else if(nChoice == 2)
                nStage = STAGE_EPIC_SPELLS;
            else if(nChoice == 3)
                nStage = STAGE_SHOPS;
            else if(nChoice == 4)
                // This aborts conversation?
                AssignCommand(oPC, TryToIDItems(oPC));

            // Mark the target stage to need building
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SWITCHES)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
            {
                //move to another stage based on response
                SetLocalString(oPC, "VariableName", GetChoiceText(oPC));
                nStage = STAGE_SWITCHES_VALUE;
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SWITCHES_VALUE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {
                nStage = STAGE_SWITCHES;
                MarkStageNotSetUp(STAGE_SWITCHES, oPC);
            }
            else
            {
                string sVarName = GetLocalString(oPC, "VariableName");
                SetPRCSwitch(sVarName, GetPRCSwitch(sVarName) + nChoice);
            }
        }
        else if(nStage == STAGE_EPIC_SPELLS)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if (nChoice == 1)
                nStage = STAGE_EPIC_SPELLS_ADD;
            else if (nChoice == 2)
                nStage = STAGE_EPIC_SPELLS_REMOVE;
            else if (nChoice == 3)
                nStage = STAGE_EPIC_SPELLS_CONTING;

            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS_ADD)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_EPIC_SPELLS;

            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS_REMOVE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_EPIC_SPELLS;

            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS_CONTING)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_EPIC_SPELLS;

            MarkStageNotSetUp(nStage, oPC);
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
