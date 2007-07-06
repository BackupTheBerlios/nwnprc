//:://////////////////////////////////////////////
//:: New Spellbooks spell learning conversation
//:: prc_s_spellgain
//:://////////////////////////////////////////////
/** @file
    New spellbooks spell learning conversation.
    Displays spell levels available and spells
    from those levels available for learning.

    Each conversation instance is tied to some
    class's spellbook.

    @date Modified - 2007.01.01
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "inc_newspellbook"


//////////////////////////////////////////////////
/* Constant definitions                         */
//////////////////////////////////////////////////

const int STAGE_SELECT_LEVEL = 0;
const int STAGE_SELECT_SPELL = 1;
const int STAGE_CONFIRM      = 2;

const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_CONVO_SELECT   = 16824212; // "Finish"
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
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
            if(nStage == STAGE_SELECT_LEVEL)
            {
                int nClass             = GetLocalInt(oPC, "SpellGainClass");
                int nSpellbookMinLevel = GetLocalInt(oPC, "SpellbookMinSpelllevel");
                int nSpellbookMaxLevel = GetLocalInt(oPC, "SpellbookMaxSpelllevel");
                int nLevel             = GetSpellslotLevel(nClass, oPC);
                string sFile           = GetFileForClass(nClass);
                int nSpellsKnownCurrent;
                int nSpellsKnownMax;
                int i;

                int nAddedASpellLevel = FALSE;
                for(i = nSpellbookMinLevel; i <= nSpellbookMaxLevel; i++)
                {
                    nSpellsKnownCurrent  = GetSpellKnownCurrentCount(oPC, i, nClass);
                    nSpellsKnownMax      = GetSpellKnownMaxCount(nLevel, i, nClass, oPC);
                    int nSpellsAvailable = GetSpellUnknownCurrentCount(oPC, i, nClass);
                    if(nSpellsKnownCurrent < nSpellsKnownMax)
                    {
                        if(nSpellsAvailable > 0)
                        {
                            nAddedASpellLevel = TRUE;
                            AddChoice(GetStringByStrRef(7544)/*"Spell Level"*/ + " " + IntToString(i), i);
                        }
                        else
                            DoDebug("ERROR: prc_s_spellgain: Insufficient spells to fill level " + IntToString(i) + "; Class: " + IntToString(nClass));
                    }
                }
                if(!nAddedASpellLevel)
                {
                    SetHeaderStrRef(16828406); // "You can select more spells when you next gain a level."
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, oPC);
                    SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(STRREF_END_CONVO_SELECT));
                }
                else
                {
                    SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
                    // "<classname> spellbook.\nSelect a spell level to gain spells from."
                    SetHeader(ReplaceChars(GetStringByStrRef(16828405), "<classname>", GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)))));
                }
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
            }
            else if(nStage == STAGE_SELECT_SPELL)
            {
                int nClass      = GetLocalInt(oPC, "SpellGainClass");
                int nLevel      = GetSpellslotLevel(nClass, oPC);
                int nSpellLevel = GetLocalInt(oPC, "SelectedLevel");
                string sFile    = GetFileForClass(nClass);

                // Determine how many spells the character can select
                int nSpellsKnownCurrent  = GetSpellKnownCurrentCount(oPC, nSpellLevel, nClass);
                int nSpellsKnownMax      = GetSpellKnownMaxCount(nLevel, nSpellLevel, nClass, oPC);
                int nSpellsKnownToSelect = min(nSpellsKnownMax - nSpellsKnownCurrent, GetSpellUnknownCurrentCount(oPC, nSpellLevel, nClass));

                // Set up header
                // "You have <selectcount> level <spelllevel> spells remaining to select."
                SetHeader(ReplaceChars(ReplaceChars(GetStringByStrRef(16828404),
                          "<selectcount>", IntToString(nSpellsKnownToSelect)),
                          "<spelllevel>", IntToString(nSpellLevel))
                          );

                // List all spells not yet selected of this level
                int i;
                int nRow;
                string sTag = "SpellLvl_" + IntToString(nClass) + "_Level_" + IntToString(nSpellLevel);
                object oWP = GetObjectByTag(sTag);
                for(i = 0; i < array_get_size(oWP, "Lkup"); i++)
                {
                    int nRow    = array_get_int(oWP, "Lkup", i);
                    int nFeatID = StringToInt(Get2DACache(sFile, "FeatID", nRow));
                    if(Get2DACache(sFile, "ReqFeat", nRow) == "" && // Has no prerequisites
                       !GetHasFeat(nFeatID, oPC))                   // And doesnt have it already
                    {
                        int nFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nRow));
                        AddChoice(GetStringByStrRef(StringToInt(Get2DACache("iprp_feats", "Name", nFeatID))), nRow, oPC);

                        if(DEBUG) DoDebug("prc_s_spellgain: Adding spell selection choice:\n"
                                        + "i = " + IntToString(nRow)          + "\n"
                                        + "sFile = " + sFile                  + "\n"
                                        + "nFeatID = " + IntToString(nFeatID) + "\n"
                                        + "resref = " + IntToString(StringToInt(Get2DACache("iprp_feats", "Name", nFeatID)))
                                          );
                    }
                }

                SetDefaultTokens();
                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_CONFIRM)
            {
                int nRow     = GetLocalInt(oPC, "SelectedSpell");
                int nClass   = GetLocalInt(oPC, "SpellGainClass");
                string sFile = GetFileForClass(nClass);
                int nFeat    = StringToInt(Get2DACache(sFile, "FeatID", nRow));

                string sToken  = GetStringByStrRef(16824209) + "\n\n"; // "You have selected:"
                       sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT",        nFeat))) + "\n";
                       sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeat))) + "\n\n";
                       sToken += GetStringByStrRef(16824210); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE);
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE);

                MarkStageSetUp(nStage, oPC);
                SetDefaultTokens();
            }
            //add more stages for more nodes with Else If clauses
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, "SelectedLevel");
        DeleteLocalInt(oPC, "SpellGainClass");
        DeleteLocalInt(oPC, "SelectedSpell");
        DeleteLocalInt(oPC, "SpellbookMinSpelllevel");
        DeleteLocalInt(oPC, "SpellbookMaxSpelllevel");
        DelayCommand(1.0, EvalPRCFeats(oPC));
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, "SelectedLevel");
        DeleteLocalInt(oPC, "SelectedSpell");
        DeleteLocalInt(oPC, "SpellGainClass");
        DeleteLocalInt(oPC, "SpellbookMinSpelllevel");
        DeleteLocalInt(oPC, "SpellbookMaxSpelllevel");
        DelayCommand(1.0, EvalPRCFeats(oPC));
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_SELECT_LEVEL)
        {
            SetLocalInt(oPC, "SelectedLevel", nChoice);
            nStage = STAGE_SELECT_SPELL;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SELECT_SPELL)
        {
            SetLocalInt(oPC, "SelectedSpell", nChoice);
            nStage = STAGE_CONFIRM;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_CONFIRM)
        {
            // Move to another stage based on response, for example
            if(nChoice == TRUE)
            {
                int nClass   = GetLocalInt(oPC, "SpellGainClass");
                int nRow     = GetLocalInt(oPC, "SelectedSpell");
                string sFile = GetFileForClass(nClass);
                object oSkin = GetPCSkin(oPC);

                int nIPFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nRow));
                int nFeatID   = StringToInt(Get2DACache(sFile, "FeatID", nRow));
                int nLevel    = StringToInt(Get2DACache(sFile, "Level", nRow));

                // Create spells known array if it is missing
                if(!persistant_array_exists(oPC, "Spellbook" + IntToString(nClass)))
                    persistant_array_create(oPC, "Spellbook" + IntToString(nClass));

                // Mark the spell as known
                //if(DEBUG) DoDebug("prc_s_spellgain: persistant_array_get_size(" + DebugObject2Str(oPC) + ", Spellbook" + IntToString(nClass)") = " + IntToString(persistant_array_get_size(oPC, "Spellbook" + IntToString(nClass))));
                persistant_array_set_int(oPC, "Spellbook" + IntToString(nClass),
                                         persistant_array_get_size(oPC, "Spellbook" + IntToString(nClass)),
                                         nRow);
                //if(DEBUG) DoDebug("prc_s_spellgain: persistant_array_get_size(" + DebugObject2Str(oPC) + ", Spellbook" + IntToString(nClass)") = " + IntToString(persistant_array_get_size(oPC, "Spellbook" + IntToString(nClass))));

                // Adds spell use feat
                AddSpellUse(oPC, nRow, nClass, sFile, "NewSpellbookMem_" + IntToString(nClass), GetSpellbookTypeForClass(nClass), oSkin, nFeatID, nIPFeatID);
            }
            else
            {
                DeleteLocalInt(oPC, "SelectedSpell");
            }

            nStage = STAGE_SELECT_LEVEL;
            MarkStageNotSetUp(nStage, oPC);
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
