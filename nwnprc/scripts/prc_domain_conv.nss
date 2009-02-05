//:://////////////////////////////////////////////
//:: Domain Subradial Casting Conversation
//:: prc_domain_conv
//:://////////////////////////////////////////////
/** @file
    This allows you to choose which subradial spell to use


    @author Stratovarius
    @date   Created  - 29.10.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SPELL_CHOICE  = 0;
const int STAGE_CONFIRMATION  = 1;

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
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_SPELL_CHOICE)
            {
                // Set the header
                SetHeader("Select the subradial option you would like to cast.");

                // Add responses for the PC
                // Get the subradial options, add them
                int nSpellID = GetLocalInt(oPC, "DomainOrigSpell");
		int nSubId1 = StringToInt(Get2DACache("spells", "SubRadSpell1", nSpellID));
		int nSubId2 = StringToInt(Get2DACache("spells", "SubRadSpell2", nSpellID));
		int nSubId3 = StringToInt(Get2DACache("spells", "SubRadSpell3", nSpellID));
		int nSubId4 = StringToInt(Get2DACache("spells", "SubRadSpell4", nSpellID));
		int nSubId5 = StringToInt(Get2DACache("spells", "SubRadSpell5", nSpellID));
		// All subradials are greater than 0
		if (nSubId1 > 0)
                	AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSubId1))), nSubId1, oPC);
		if (nSubId2 > 0)
                	AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSubId2))), nSubId2, oPC);
		if (nSubId3 > 0)
                	AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSubId3))), nSubId3, oPC);
		if (nSubId4 > 0)
                	AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSubId4))), nSubId4, oPC);
		if (nSubId5 > 0)
                	AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSubId5))), nSubId5, oPC);                	

                MarkStageSetUp(STAGE_SPELL_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nChoice = GetLocalInt(oPC, "DomainSubChoice");
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nChoice)));
                string sText = "You have selected " + sName + " as the subradial to cast.\n";

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
        DeleteLocalInt(oPC, "DomainSubChoice");
        DeleteLocalFloat(oPC, "DomainDuration");
        DeleteLocalInt(oPC, "DomainCastLevel");
        DeleteLocalInt(oPC, "DomainOrigSpell");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "DomainSubChoice");
        DeleteLocalFloat(oPC, "DomainDuration");
        DeleteLocalInt(oPC, "DomainCastLevel");
        DeleteLocalInt(oPC, "DomainOrigSpell");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_SPELL_CHOICE)
        {
            nStage = STAGE_CONFIRMATION;
            SetLocalInt(oPC, "DomainSubChoice", nChoice);
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            if(nChoice == TRUE)
            {
            	// Get the choice
                int nSub = GetLocalInt(oPC, "DomainSubChoice");
                ActionCastSpell(nSub);
                
                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);

            }
            else // Reset
            {
                nStage = STAGE_SPELL_CHOICE;
                MarkStageNotSetUp(STAGE_SPELL_CHOICE, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }

            DeleteLocalInt(oPC, "DomainSubChoice");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
