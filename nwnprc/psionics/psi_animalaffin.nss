//:://////////////////////////////////////////////
//:: Animal Affinity Conversation
//:: psi_animalaffin
//:://////////////////////////////////////////////
/** @file
    This allows you to choose which stats to boost using the AA power


    @author Stratovarius
    @date   Created  - 29.10.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_alterations"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_STAT_CHOICE = 0;
const int STAGE_CONFIRMATION  = 1;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

// Just takes the stat and returns the name
string StatToName(int nStat)
{
	if (nStat == ABILITY_STRENGTH) return "Strength";
	else if (nStat == ABILITY_DEXTERITY) return "Dexterity";
	else if (nStat == ABILITY_CONSTITUTION) return "Constitution";
	else if (nStat == ABILITY_WISDOM) return "Wisdom";
	else if (nStat == ABILITY_INTELLIGENCE) return "Intelligence";
	else if (nStat == ABILITY_CHARISMA) return "Charisma";
	
	// if its not a stat
	return "";
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
            if(nStage == STAGE_STAT_CHOICE)
            {
                // Set the header
                SetHeader("Select the Ability Score you would like to boost.");
                
                // Add responses for the PC
                AddChoice("Strength", ABILITY_STRENGTH, oPC);
                AddChoice("Dexterity", ABILITY_DEXTERITY, oPC);
                AddChoice("Constitution", ABILITY_CONSTITUTION, oPC);
                AddChoice("Wisdom", ABILITY_WISDOM, oPC);
                AddChoice("Intelligence", ABILITY_INTELLIGENCE, oPC);
                AddChoice("Charisma", ABILITY_CHARISMA, oPC);

                MarkStageSetUp(STAGE_STAT_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nChoice = GetLocalInt(oPC, "AnimalAffinityStat");
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sName = StatToName(nChoice);
                string sText = "You have selected " + sName + " as the ability to boost.\n";
                /*string sText = "You have selected these abilities to boost.\n";
                
                // This reads the PC's choices and adds em
                int i;
		for(i = 0; i < 6; i++) //Total possible choices
		{
			// If the selection is a legal weapon
			sName = "AnimalAffinityStat" + IntToString(i);
			nChoice = GetLocalInt(oPC, sName);
			// If it returns an actual stat
			if (StatToName(nChoice) != "")
			{
				sText += IntToString (i) + ": " + StatToName(nChoice) + ".\n";
			}
                }*/
                sText += "Is this correct?";

                SetHeader(sText);
                MarkStageSetUp(STAGE_CONFIRMATION, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "AnimalAffinityStat");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "AnimalAffinityStat");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_STAT_CHOICE)
        {
            // If there are more stats to do
            
/*            // Keeps track of how many times we've been through here
            int nCounter = GetLocalInt(oPC, "AACounter");
            SetLocalInt(oPC, "AACounter", (nCount + 1));
            
            if (GetLocalInt(oPC, "AnimalAffinityAugment") > nCounter)
            {
                nStage = STAGE_STAT_CHOICE;
            }
            else
            {
            	nStage = STAGE_CONFIRMATION;
            }
            sName = "AnimalAffinityStat" + IntToString(nCounter);*/
            nStage = STAGE_CONFIRMATION;
            SetLocalInt(oPC, "AnimalAffinityStat", nChoice);
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            if(nChoice == TRUE)
            {
            	effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
	    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	        effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,4);
    		effect eLink = EffectLinkEffects(eDex, eDur);
    		
    	    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, GetLocalFloat(oPC, "AnimalAffinityDuration"),TRUE,-1,GetLocalInt(oPC, "AnimalAffinityManifesterLevel"));
    		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            
                // And we're all done
               	AllowExit(DYNCONV_EXIT_FORCE_EXIT);

            }
            else
            {
                nStage = STAGE_STAT_CHOICE;
                // Reset the counter
                DeleteLocalInt(oPC, "AACounter");
                MarkStageNotSetUp(STAGE_STAT_CHOICE, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }

            DeleteLocalInt(oPC, "AnimalAffinityStat");
        }        

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
