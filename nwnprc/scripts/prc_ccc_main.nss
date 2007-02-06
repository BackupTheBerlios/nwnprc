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
        // will boot the PC later if they should go through the convoCC but can't
        // otherwise ignore
        bBoot = DoLetoscriptTest(oPC);
        
        // encryption stuff
        /* TODO proper comment */
        string sEncrypt;
        sEncrypt= Encrypt(oPC);
        
        // if a new character...
        if((GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetXP(oPC) == 0)
        || (!GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetTag(oPC) != sEncrypt))
        {
            // if letoscript can't find the bic, the convoCC won't work
            // so kick the PC now
            if(bBoot) // if singleplayer game or letoscript not set up correctly
            {
                effect eParal = EffectCutsceneParalyze();
                eParal = SupernaturalEffect(eParal);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParal, oPC);
                AssignCommand(oPC, DelayCommand(10.0, CheckAndBoot(oPC)));
                return;
            }
            // next see if someone has already started the convo
            if(GetLocalInt(GetModule(), "ccc_active"))
            {
                // no avoiding the convoCC, so stop them running off
                effect eParal = EffectCutsceneParalyze();
                eParal = SupernaturalEffect(eParal);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParal, oPC);
                // floaty text info as we can't use the dynamic convo for this
                DelayCommand(10.0, FloatingTextStringOnCreature(
                    "The conversation Character Creator is in use, please try later.", oPC, FALSE));
                DelayCommand(11.0, FloatingTextStringOnCreature("You will be booted in 5...", oPC, FALSE));
                DelayCommand(12.0, FloatingTextStringOnCreature("4...", oPC, FALSE));
                DelayCommand(13.0, FloatingTextStringOnCreature("3...", oPC, FALSE));
                DelayCommand(14.0, FloatingTextStringOnCreature("2...", oPC, FALSE));
                DelayCommand(15.0, FloatingTextStringOnCreature("1...", oPC, FALSE));
                AssignCommand(oPC, DelayCommand(16.0, CheckAndBoot(oPC)));
            }
            // now reserve the conversation slot - only one at a time
            SetLocalInt(GetModule(), "ccc_active", 1);
            // remove equipped items and clear out inventory
            DoStripPC(oPC);
            //rest them so that they loose cutscene invisible
            //from previous logons
            ForceRest(oPC);
            //Take their Gold
            AssignCommand(oPC,TakeGoldFromCreature(GetGold(oPC),oPC,TRUE));
            //DISABLE FOR DEBUGGING
            if (!DEBUG)
            {
                // start the cutscene
                // off for debugging to see the debug text in the client
                SetCutsceneMode(oPC, TRUE);
            }
            SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
            //make sure the PC stays put
            effect eParal = EffectCutsceneImmobilize();
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oPC, 9999.9);
            //start the ConvoCC conversation
            DelayCommand(10.0, StartDynamicConversation("prc_ccc_main", oPC, FALSE, FALSE, TRUE));
            // sets up the cutscene to the point in the convo at which the player logged out
            DelayCommand(11.0, DoCutscene(oPC, TRUE));
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
                if(DEBUG)
                {
                    DoDebug("prc_ccc: Stage was not already set up");
                    DoDebug("Pass to DoHeaderAndChoices(): " + IntToString(nStage));
                }
                   // SpawnScriptDebugger();
                DoHeaderAndChoices(nStage);
                if(DEBUG) DoDebug("DoHeaderAndChoices() finished");
            }
    
            // Do token setup
            SetupTokens();
            if(DEBUG) ExecuteScript("prc_ccc_debug", oPC);
        }
        // End of conversation cleanup
        else if(nValue == DYNCONV_EXITED)
        {
            if(DEBUG) DoDebug("prc_ccc: Conversation exited");
            // cleanup is done in prc_ccc_make_pc
            // deletes local variables used to create the character
        }
        // Abort conversation cleanup.
        // NOTE: This section is only run when the conversation is aborted
        // while aborting is allowed. When it isn't, the dynconvo infrastructure
        // handles restoring the conversation in a transparent manner
        else if(nValue == DYNCONV_ABORTED)
        {
            // shouldn't reach this stage as aboting isn't allowed
            AssignCommand(oPC, DelayCommand(1.0, CheckAndBoot(oPC)));
        }
        // Handle PC responses
        else
        {
            // variable named nChoice is the value of the player's choice as stored when building the choice list
            // variable named nStage determines the current conversation node
            int nChoice = GetChoice(oPC);
            
            // get nStage back so SetStage() actually changes the stage
            if(DEBUG) DoDebug("nStage before HandleChoice: " + IntToString(nStage));
            nStage = HandleChoice(nStage, nChoice);
            if(DEBUG) DoDebug("nStage after HandleChoice: " + IntToString(nStage));
    
            // Store the stage value. If it has been changed, this clears out the choices
            SetStage(nStage, oPC);
        }
    }
}
