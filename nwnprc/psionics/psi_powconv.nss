//:://////////////////////////////////////////////
//:: Psionic Power gain conversation script
//:: psi_powconv
//:://////////////////////////////////////////////
/** @file
    This script controls the psionic power selection
    conversation.


    @author Primogenitor - Orinigal
    @author Ornedan - Modifications
    @date   Modified - 2005.03.13
    @date   Modified - 2005.09.23
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_psifunc"
#include "inc_dynconv"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_LEVEL        = 0;
const int STAGE_SELECT_POWER        = 1;
const int STAGE_CONFIRM_SELECTION   = 2;
const int STAGE_ALL_POWERS_SELECTED = 3;

const int CHOICE_BACK_TO_LSELECT    = -1;

const int STRREF_BACK_TO_LSELECT    = 16824205;
const int STRREF_LEVELLIST_HEADER   = 16824206;
const int STRREF_POWERLIST_HEADER1  = 16824207; // "Select a power to gain.\n You can select"
const int STRREF_POWERLIST_HEADER2  = 16824208; // "more powers"
const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_HEADER         = 16824211; // "You will be able to select more powers after you gain another level in a psionic caster class."
const int STRREF_END_CONVO_SELECT   = 16824213; // "Finish"
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"


//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    int nClass = GetLocalInt(oPC, "nClass");
    string sPsiFile = GetPsionicFileName(nClass);
    string sPowerFile = GetPsiBookFileName(nClass);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // Level selection stage
            if(nStage == STAGE_SELECT_LEVEL)
            {
                SetHeader(GetStringByStrRef(STRREF_LEVELLIST_HEADER));

                // Determine maximum power level
                int nManifestLevel = GetLevelByClass(nClass, oPC);
                    nManifestLevel += nClass == GetFirstPsionicClass(oPC) ? GetPsionicPRCLevels(oPC) : 0;
                int nMaxLevel = StringToInt(Get2DACache(sPsiFile, "MaxPowerLevel", nManifestLevel - 1));

                // Set the tokens
                int i;
                for(i = 0; i < nMaxLevel; i++){
                    AddChoice(GetStringByStrRef(LEVEL_STRREF_START - i)), // The minus is correct, these are stored in inverse order in the TLK. Whoops
                              i + 1
                              );
                }

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // Power selection stage
            if(nStage == STAGE_SELECT_POWER)
            {
                int nCurrentPowers = GetPowerCount(oPC, nClass);
                int nMaxPowers = GetMaxPowerCount(oPC, nClass);
                string sToken = GetStringByStrRef(STRREF_POWERLIST_HEADER1) + " " + //"Select a power to gain.\n You can select "
                                IntToString(nMaxPowers-nCurrentPowers) + " " +
                                GetStringByStrRef(STRREF_POWERLIST_HEADER2);        //" more powers"
                SetHeader(sToken);

                // Set the first choice to be return to level selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oPC);

                // Determine maximum power level
                int nManifestLevel = GetLevelByClass(nClass, oPC);
                    nManifestLevel += nClass == GetFirstPsionicClass(oPC) ? GetPsionicPRCLevels(oPC) : 0;
                int nMaxLevel = StringToInt(Get2DACache(sPsiFile, "MaxPowerLevel", nManifestLevel-1));


                int nPowerLevelToBrowse = GetLocalInt(oPC, "nPowerLevelToBrowse");
                int i, nPowerLevel;
                string sFeatID;
                for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
                {
                    nPowerLevel = StringToInt(Get2DACache(sPowerFile, "Level", i));
                    // Skip any powers of too low level
                    if(nPowerLevel < nPowerLevelToBrowse){
                        continue;
                    }
                    /* Due to the way the power list 2das are structured, we know that once
                     * the level of a read power is greater than the maximum manifestable
                     * it'll never be lower again. Therefore, we can skip reading the
                     * powers that wouldn't be shown anyway.
                     */
                    if(nPowerLevel > nPowerLevelToBrowse){
                        break;
                    }
                    sFeatID = Get2DACache(sPowerFile, "FeatID", i);
                    if(sFeatID != ""                                           // Non-blank row
                     && !GetHasFeat(StringToInt(sFeatID), oPC)                 // PC does not already posses the power
                     && (!StringToInt(Get2DACache(sPowerFile, "HasPrereqs", i))// Power has no prerequisites
                      || CheckPowerPrereqs(StringToInt(sFeatID), oPC)          // Or the PC possess the prerequisites
                         )
                       )
                    {
                        AddChoice(GetStringByStrRef(StringToInt(Get2DACache(sPowerFile, "Name", i))), i, oPC);
                    }
                }

                MarkStageSetUp(STAGE_SELECT_POWER, oPC);
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nPower = GetLocalInt(oPC, "nPower");
                int nFeatID = StringToInt(Get2DACache(sPowerFile, "FeatID", nPower));
                sToken += GetStringByStrRef(StringToInt(Get2DACache(sPowerFile, "Name", nPower)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeatID)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
            // Conversation finished stage
            else if(nStage == STAGE_ALL_POWERS_SELECTED)
            {
                SetHeader(GetStringByStrRef(STRREF_END_HEADER));
                // Set the convo quit text to "Finish"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(STRREF_END_CONVO_SELECT));
                AllowExit(FALSE, oPC);
            }
        }
        /* Hack - In the power selection stage, do not rebuild the list on
         * returning from confirmation dialog where the answer was "No"
         * and restore the offset to be the same as on entering the confirmation
         * dialog.
         */
        else
        {
            if(nStage == STAGE_SELECT_POWER)
                SetLocalInt(oPC, DYNCONV_CHOICEOFFSET, GetLocalInt(oPC, "PowerListChoiceOffset"));
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        DeleteLocalInt(oPC, "nPower");
        DeleteLocalInt(oPC, "nPowerLevelToBrowse");
        DeleteLocalInt(oPC, "PowerListChoiceOffset");

        // Restart the convo to pick next power if needed
        ExecuteScript("psi_powergain", oPC);
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since the dynconvo system is supposed to transparently
        // handle restarting the conversation on an abort
        if(DEBUG) DoDebug("psi_powconv: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(nStage == DYNCONV_SETUP_STAGE)
        {
            SetLocalInt(oPC, "nPowerLevelToBrowse", nChoice);
            nStage = STAGE_SELECT_POWER;
        }
        else if(nStage == STAGE_SELECT_POWER)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                nStage = DYNCONV_SETUP_STAGE;
                DeleteLocalInt(oPC, "nPowerLevelToBrowse");
            }
            else
            {
                SetLocalInt(oPC, "nPower", nChoice);
                // Store offset so that if the user decides not to take the power,
                // we can return to the same page in the power list instead of resetting to the beginning
                SetLocalInt(oPC, "PowerListChoiceOffset", GetLocalInt(oPC, DYNCONV_CHOICEOFFSET));
                nStage = STAGE_CONFIRM_SELECTION;
            }
            MarkStageNotSetUp(STAGE_SELECT_POWER, oPC);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(nChoice == TRUE)
            {
                int nPower = GetLocalInt(oPC, "nPower");
                object oSkin = GetPCSkin(oPC);

                // Add the power feat(s) to the PC's hide
                // First power feat
                int nPowerFeatIP = StringToInt(Get2DACache(sPowerFile, "IPFeatID", nPower));
                itemproperty ipFeat = ItemPropertyBonusFeat(nPowerFeatIP);
                IPSafeAddItemProperty(oSkin, ipFeat);
                // Second power feat
                string sPowerFeat2IP = Get2DACache(sPowerFile, "IPFeatID2", nPower);
                if(sPowerFeat2IP != "")
                {
                    ipFeat = ItemPropertyBonusFeat(StringToInt(sPowerFeat2IP));
                    IPSafeAddItemProperty(oSkin, ipFeat);
                }
                // Raise the power count
                if(!persistant_array_exists(oPC, "PsiPowerCount"))
                    persistant_array_create(oPC, "PsiPowerCount");
                persistant_array_set_int(oPC, "PsiPowerCount", nClass, persistant_array_get_int(oPC, "PsiPowerCount", nClass) + 1);

                // Delete the stored offset
                DeleteLocalInt(oPC, "PowerListChoiceOffset");
            }

            int nCurrentPowers = GetPowerCount(oPC, nClass);
            int nMaxPowers = GetMaxPowerCount(oPC, nClass);
            if(nCurrentPowers >= nMaxPowers)
                nStage = STAGE_ALL_POWERS_SELECTED;
            else
                nStage = STAGE_SELECT_POWER;
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
