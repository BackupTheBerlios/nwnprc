//:://////////////////////////////////////////////
//:: Conversation Charactor Creator
//:: prc_ccc.nss
//:://////////////////////////////////////////////
/** @file
    Long description


    @author Primogenitor, modified by fluffyamoeba
    @date   Created  - 2006.09.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

// includes

#include "ccc_inc_convo"

//////////////////////////////////////////////////
/* Constant defintions + functions              */
//////////////////////////////////////////////////

// see includes

//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    int bBoot; // used by this script to mark if the PC should be booted

    if(!GetIsObjectValid(oPC)) // if no valid speaker, then not part of the convo
    {
        // no valid speaker so need to get the PC properly this time
        oPC = GetEnteringObject();
        // if called for a NPC, DM or the switch isn't enabled
        if(!GetIsPC(oPC) || GetIsDM(oPC) || !GetPRCSwitch(PRC_CONVOCC_ENABLE))
            return;
        
        // check letoscript is setup correctly
        bBoot = DoLetoscriptTest(oPC);
        if(bBoot) // if singleplayer game or letoscript not set up correctly
        {
            effect eParal = EffectCutsceneParalyze();
            eParal = SupernaturalEffect(eParal);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParal, oPC);
            AssignCommand(oPC, DelayCommand(10.0, CheckAndBoot(oPC)));
            return;
        }
        
        // encryption stuff
        /* TODO proper comment */
        string sEncrypt;
        sEncrypt= Encrypt(oPC);
        
        // if a new character...
        if((GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetXP(oPC) == 0)
        || (!GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetTag(oPC) != sEncrypt))
        {
            // remove equipped items and clear out inventory
            DoStripPC(oPC);
            //rest them so that they loose cutscene invisible
            //from previous logons
            ForceRest(oPC);
            //Take their Gold
            AssignCommand(oPC,TakeGoldFromCreature(GetGold(oPC),oPC,TRUE));
            //start the ConvoCC conversation
            DelayCommand(10.0, StartDynamicConversation("prc_ccc", oPC, FALSE, FALSE, TRUE));
            //DISABLE FOR DEBUGGING
            if (!DEBUG)
            {
                SetCutsceneMode(oPC, TRUE);
                SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
            }
            SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
        }
        else // returning character
        {
        
            //if using XP for new characters, set returning characters tags to encrypted
            //then you can turn off using XP after all characters have logged on.
            if(GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR)
                && GetTag(oPC) != sEncrypt
                && GetXP(oPC) > 0)
            {
                string sScript = LetoSet("Tag", sEncrypt, "string");
                SetLocalString(oPC, "LetoScript", GetLocalString(oPC, "LetoScript")+sScript);
            }
            SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
        }
    }
    else // in convo
    {
        /* dynamic convo from here*/
        // double check it's a PC
        if(!GetIsPC(oPC) || GetIsDM(oPC) || !GetPRCSwitch(PRC_CONVOCC_ENABLE))
            return;
        // The stage is used to determine the active conversation node.
        // 0 is the entry node.
        int nStage = GetStage(oPC);
        /* Get the value of the local variable set by the conversation script calling
         * this script. Values:
         * DYNCONV_ABORTED     Conversation aborted
         * DYNCONV_EXITED      Conversation exited via the exit node
         * DYNCONV_SETUP_STAGE System's reply turn
         * 0                   The script was called by prc_onenter
         * Other               The user made a choice
         */
        int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
        
        if(DEBUG) DoDebug("prc_ccc running.\n"
                    + "oPC = " + DebugObject2Str(oPC) + "\n"
                    + "nValue = " + IntToString(nValue)
                      );
    
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
                // this function sets up the text displayed and the response options
                // for the current conversation node
                if(DEBUG) DoDebug("prc_ccc: Stage was not already set up");
                /* TODO - function*/
                DoDebug("Pass to DoHeaderAndChoices(): " + IntToString(nStage));
                   // SpawnScriptDebugger();
                DoHeaderAndChoices(nStage);
                DoDebug("DoHeaderAndChoices() finished");
            }
    
            // Do token setup
            SetupTokens();
            ExecuteScript("prc_ccc_debug", oPC); // doesn't do anything right now
        }
        // End of conversation cleanup
        else if(nValue == DYNCONV_EXITED)
        {
            if(DEBUG) DoDebug("prc_ccc: Conversation exited");
            // Add any locals set through this conversation
            /* TODO via a function */
            SetCutsceneMode(oPC, FALSE);
            AssignCommand(oPC, DelayCommand(1.0, CheckAndBoot(oPC)));
            // DoCleanup(); // cleans up variables
        }
        // Abort conversation cleanup.
        // NOTE: This section is only run when the conversation is aborted
        // while aborting is allowed. When it isn't, the dynconvo infrastructure
        // handles restoring the conversation in a transparent manner
        else if(nValue == DYNCONV_ABORTED)
        {
            
            // Add any locals set through this conversation
            /* TODO via a function */
            SetCutsceneMode(oPC, FALSE);
            ForceRest(oPC);
            /* TODO - stick CheckAndBoot() in an include */
            AssignCommand(oPC, DelayCommand(1.0, CheckAndBoot(oPC)));
            // DoCleanup(); // cleans up variables
        }
        // Handle PC responses
        else
        {
            // variable named nChoice is the value of the player's choice as stored when building the choice list
            // variable named nStage determines the current conversation node
            int nChoice = GetChoice(oPC);
            
            // get nStage back so SetStage() actually changes the stage
            DoDebug("nStage before HandleChoice: " + IntToString(nStage));
            nStage = HandleChoice(nStage, nChoice);
            DoDebug("nStage after HandleChoice: " + IntToString(nStage));
    
            // Store the stage value. If it has been changed, this clears out the choices
            SetStage(nStage, oPC);
        }
    }
}
