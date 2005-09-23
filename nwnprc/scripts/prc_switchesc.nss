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

const int STAGE_ENTRY               = 0;
const int STAGE_SWITCHES            = 1;
const int STAGE_SWITCHES_VALUE      = 2;
const int STAGE_EPIC_SPELLS         = 3;
const int STAGE_EPIC_SPELLS_ADD     = 4;
const int STAGE_EPIC_SPELLS_REMOVE  = 5;
const int STAGE_EPIC_SPELLS_CONTING = 6;
const int STAGE_SHOPS               = 7;

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

    SetupTokens();

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
            SetCustomToken(99, "What do you want to do?");
            AddChoice("Alter code switches.", 1);
            AddChoice("Manage Epic Spells.", 2);
            AddChoice("Purchase general items, such as scrolls or crafting materials.", 3);
            AddChoice("Identify everything in my inventory.", 4);
            array_set_int(oPC, "StagesSetup", nStage, TRUE); //this lets it know that its setup so dont set it up again
        }
        else if(nStage == STAGE_SWITCHES)
        {       
            SetCustomToken(99, "Select a variable to modify. \nSee prc_inc_switches for descriptions.\nIn most cases zero is off and any other value is on.");
            object oWP = GetWaypointByTag("PRC_Switch_Name_WP");
            if(!GetIsObjectValid(oWP))
                oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "NW_WAYPOINT001", GetStartingLocation(), FALSE, "PRC_Switch_Name_WP");
            int i;
            for(i=0;i<array_get_size(oWP, "Switch_Name"); i++)
            {
                AddChoice(array_get_string(oWP, "Switch_Name", i), i);
            }
            AddChoice("Back", 99999);
            array_set_int(oPC, "StagesSetup", nStage, TRUE); //this lets it know that its setup so dont set it up again
        }
        else if(nStage == STAGE_SWITCHES_VALUE)
        {
            string sVarName = GetLocalString(oPC, "VariableName");
            int nVal = GetPRCSwitch(sVarName);
            AddChoice("Back", 99999);
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
            string sDescription = "CurrentValue is: "+IntToString(nVal)+"\n";
            sDescription += "CurrentVariable is: "+sVarName+"\n";
            sDescription += "Select an ammount to modify the variable by:";
            SetCustomToken(99, sDescription);            
        }
        else if(nStage == STAGE_EPIC_SPELLS)
        {       
            SetCustomToken(99, "Make a selection.");
            AddChoice("Back", 99999);
            AddChoice("Remove an Epic Spell from the radial menu.", 1);
            AddChoice("Add an Epic Spell to the radial menu.", 2);
            AddChoice("Manage any active contingencies.", 3);
            array_set_int(oPC, "StagesSetup", nStage, TRUE); //this lets it know that its setup so dont set it up again
        }
        else if(nStage == STAGE_EPIC_SPELLS_ADD)
        {       
            SetCustomToken(99, "Choose the spell to add.");
            AddChoice("Back", 99999);
            array_set_int(oPC, "StagesSetup", nStage, TRUE); //this lets it know that its setup so dont set it up again
        }
        else if(nStage == STAGE_EPIC_SPELLS_REMOVE)
        {       
            SetCustomToken(99, "Choose the spell to remove.");
            AddChoice("Back", 99999);
            array_set_int(oPC, "StagesSetup", nStage, TRUE); //this lets it know that its setup so dont set it up again
        }
        else if(nStage == STAGE_EPIC_SPELLS_CONTING)
        {       
            SetCustomToken(99, "Choose an active contingency to dispel. Dispelling will preemptively end the contingency and restore the reserved epic spell slot for your use.");
            AddChoice("Back", 99999);
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
        DeleteLocalString(oPC, DYNCONV_SCRIPT);
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_delete(oPC, "StagesSetup");
        DeleteLocalInt(oPC, "Stage");
        //add any other locals set through this conversation
        DeleteLocalString(oPC, "VariableName");
        return;
    }
    else if(nValue == -3)
    {
        //abort conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
        DeleteLocalString(oPC, DYNCONV_SCRIPT);
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_delete(oPC, "StagesSetup");
        DeleteLocalInt(oPC, "Stage");
        //add any other locals set through this conversation
        DeleteLocalString(oPC, "VariableName");
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
        if(nChoice == 99999)
            nStage = STAGE_ENTRY;
        else if(nChoice == 1)
            nStage = STAGE_SWITCHES;
        else if(nChoice == 2)
            nStage = STAGE_EPIC_SPELLS;
        else if(nChoice == 3)
            nStage = STAGE_SHOPS;
        else if(nChoice == 4)
            AssignCommand(oPC, TryToIDItems(oPC));
    }
    else if(nStage == STAGE_SWITCHES)
    {
        if(nChoice == 99999)
            nStage = STAGE_ENTRY;
        else
        {
            //move to another stage based on response
            SetLocalString(oPC, "VariableName", array_get_string(oPC, "ChoiceValues", nValue+GetLocalInt(oPC, "ChoiceOffset"))); 
            nStage = STAGE_SWITCHES_VALUE;
        }
    }
    else if(nStage == STAGE_SWITCHES_VALUE)
    {
        if(nChoice == 99999)
            nStage = STAGE_SWITCHES;
        else
        {
            string sVarName = GetLocalString(oPC, "VariableName");
            SetPRCSwitch(sVarName, GetPRCSwitch(sVarName)+nChoice);
        }       
    }
    else if(nStage == STAGE_EPIC_SPELLS)
    {
        if(nChoice == 99999)
            nStage = STAGE_ENTRY;
        else if (nChoice == 1)
            nStage = STAGE_EPIC_SPELLS_ADD;
        else if (nChoice == 2)
            nStage = STAGE_EPIC_SPELLS_REMOVE;
        else if (nChoice == 3)
            nStage = STAGE_EPIC_SPELLS_CONTING;
    }
    else if(nStage == STAGE_EPIC_SPELLS_ADD)
    {
        if(nChoice == 99999)
            nStage = STAGE_EPIC_SPELLS;
    }
    else if(nStage == STAGE_EPIC_SPELLS_REMOVE)
    {
        if(nChoice == 99999)
            nStage = STAGE_EPIC_SPELLS;
    }
    else if(nStage == STAGE_EPIC_SPELLS_CONTING)
    {
        if(nChoice == 99999)
            nStage = STAGE_EPIC_SPELLS;
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
