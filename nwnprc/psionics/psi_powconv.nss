//:://////////////////////////////////////////////
//:: Psionic Power gain conversation script
//:: psi_powconv
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Last Modified On: 13.03.2005
//:: Last Modified By: Ornedan
//:://////////////////////////////////////////////

#include "inc_utility"
#include "inc_item_props"
#include "x2_inc_itemprop"
#include "psi_inc_psifunc"
#include "inc_fileends"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STRREF_LEVELLIST_HEADER   = 16824206;
const int STRREF_POWERLIST_HEADER1  = 16824207;
const int STRREF_POWERLIST_HEADER2  = 16824208;
const int STRREF_SELECTED_HEADER1   = 16824209;
const int STRREF_SELECTED_HEADER2   = 16824210;
const int STRREF_END_HEADER         = 16824211;
const int STRREF_ABORT_CONVO_SELECT = 16824212;
const int STRREF_END_CONVO_SELECT   = 16824213;
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_BACK_TO_LSELECT    = 16824205;

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    int nValue = GetLocalInt(oPC, "DynConv_Var");
    array_create(oPC, "ChoiceTokens");
    array_create(oPC, "ChoiceValues");

    int nClass = GetLocalInt(oPC, "nClass");
    string sPsiFile = Get2DACache("classes", "FeatsTable", nClass);
    sPsiFile = GetStringLeft(sPsiFile, 4)+"psbk"+GetStringRight(sPsiFile, GetStringLength(sPsiFile)-8);
    string sPowerFile = Get2DACache("classes", "FeatsTable", nClass);
    sPowerFile = GetStringLeft(sPowerFile, 4)+"psipw"+GetStringRight(sPowerFile, GetStringLength(sPowerFile)-8);

    if(nValue == 0)
        return;
    if(nValue > 0)
        nValue --;//correct for 1 based to zero based


    if(nValue == -1)
    {
        int nStage = GetLocalInt(oPC, "Stage");
        //PrintString("Building header, stage = " + IntToString(nStage));
// INSERT CODE HERE FOR THE HEADER
// token no 50
        // Level selection stage
        if(nStage == 0){
            // Set the header text
            string sToken = GetStringByStrRef(STRREF_LEVELLIST_HEADER);
            SetCustomToken(99, sToken);
            
            // Set the tokens
            int nManifestLevel = GetLevelByClass(nClass, oPC);
            int nMaxLevel = StringToInt(Get2DACache(sPsiFile, "MaxPowerLevel", nManifestLevel - 1));
            int i;
            for(i = 0; i < nMaxLevel; i++){
                array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                                 GetStringByStrRef(LEVEL_STRREF_START - i)); // The minus is correct, these are stored in inverse order
                array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), i + 1);
            }
            
            // Set the convo quit text to "Abort"
            SetCustomToken(110, GetStringByStrRef(STRREF_END_CONVO_SELECT));
            
            //PrintString("Showed level selection.\nnMaxLevel = " + IntToString(nMaxLevel));
        }
        // Power selection stage
        if(nStage == 1 && GetLocalInt(oPC, "Stage1Setup") == FALSE)
        {
            //select a power to gain
            int nCurrentPowers = GetPowerCount(oPC, nClass);
            int nMaxPowers = GetMaxPowerCount(oPC, nClass);
            //string sToken = "Select a power to gain.\n You can select "+IntToString(nMaxPowers-nCurrentPowers)+" more powers";
            string sToken = GetStringByStrRef(STRREF_POWERLIST_HEADER1) + " " +
                            IntToString(nMaxPowers-nCurrentPowers) + " " +
                            GetStringByStrRef(STRREF_POWERLIST_HEADER2);
            SetCustomToken(99, sToken);
            
            // Set the first choice to be return to level selection stage
            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                             GetStringByStrRef(STRREF_BACK_TO_LSELECT));
            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), -1);
            
            int nManifestLevel = GetLevelByClass(nClass, oPC);
            int nMaxLevel = StringToInt(Get2DACache(sPsiFile, "MaxPowerLevel", nManifestLevel-1));
            int nPowerLevelToBrowse = GetLocalInt(oPC, "nPowerLevelToBrowse");
            //PrintString("Building power list for level " + IntToString(nPowerLevelToBrowse));
            int i;
            for(i = 0; i < CLASS_POWER_2DA_END ; i++)
            {
                int nPowerLevel = StringToInt(Get2DACache(sPowerFile, "Level", i));
                // Skip any powers of too low level
                if(nPowerLevel < nPowerLevelToBrowse){
                    //PrintString("Skipping " + IntToString(i));
                    continue;
                }
                /* Due to the way the power list 2das are structured, we know that once
                 * the level of a read power is greater than the maximum manifestable
                 * it'll never be lower again. Therefore, we can skip reading the
                 * powers that wouldn't be shown anyway.
                 */ 
                if(nPowerLevel > nPowerLevelToBrowse){
                    //PrintString("Quitting seek at " + IntToString(i));
                    break;
                }
                string sFeatID = Get2DACache(sPowerFile, "FeatID", i);
//                int nPowerFeatIP= StringToInt(Get2DACache(sPowerFile, "IPFeatID", i));
//                int nPowerSpell = StringToInt(Get2DACache(sPowerFile, "SpellID", i));
                if(sFeatID != "" 
                  && !GetHasFeat(StringToInt(sFeatID), oPC)
                  && (!StringToInt(Get2DACache(sPowerFile, "HasPrereqs", i))
                    || CheckPowerPrereqs(StringToInt(sFeatID), oPC)
                     )
                  )
                {
//                    array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
//                        GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID))));
                    array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                        GetStringByStrRef(StringToInt(Get2DACache(sPowerFile, "Name", i))));

                    array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), i);
                }
            }
			SetLocalInt(oPC, "Stage1Setup", TRUE);
        }
        // Selection confirmation stage
        else if(nStage == 2)
        {	
            //PrintString("Building confirmation menu");
            //string sToken = "You have selected:\n\n";
            string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n";
            int nPower = GetLocalInt(oPC, "nPower");
            int nFeatID = StringToInt(Get2DACache(sPowerFile, "FeatID", nPower));
//            sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID)))+"\n";
            sToken += GetStringByStrRef(StringToInt(Get2DACache(sPowerFile, "Name", nPower)))+"\n";
            sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeatID)))+"\n\n";
//            sToken += "Is this correct?";
            sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2);
            SetCustomToken(99, sToken);
            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                "Yes");
            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 1);
            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                "No");
            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 2);
        }
        // Conversation finished stage
        else if(nStage == 3)
        {	
            //PrintString("Building convo finished menu");
            //string sToken = "You will be able to select more powers after you gain another level in a psionic caster class.";
            string sToken = GetStringByStrRef(STRREF_END_HEADER);
            SetCustomToken(99, sToken);
            // Set the convo quit text to "Abort"
            SetCustomToken(110, GetStringByStrRef(STRREF_ABORT_CONVO_SELECT));
        }
        //do token setup
        int nOffset = GetLocalInt(oPC, "ChoiceOffset");
        int i;
        for(i=nOffset; i<nOffset+10; i++)
        {
            string sValue = array_get_string(oPC, "ChoiceTokens" ,i);
            SetLocalString(oPC, "TOKEN10"+IntToString(i-nOffset), sValue);
            SetCustomToken(100+i-nOffset, sValue);
        }
        
        /*for(i = 0; i < array_get_size(oPC, "ChoiceTokens"); i++){
            PrintString("ChoiceToken" + IntToString(i) + ": " + array_get_string(oPC, "ChoiceTokens" ,i) + " = " + IntToString(array_get_int(oPC, "ChoiceValues", i)));
        }*/

// END OF INSERT FOR THE HEADER
        return;
    }
    else if(nValue == -2)
    {
        //PrintString("Exiting convo");
        //end of conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
        DeleteLocalInt(oPC, "Stage");
        DeleteLocalInt(oPC, "Stage1Setup");
        DeleteLocalInt(oPC, "nPowerFeat");
        DeleteLocalInt(oPC, "nPowerLevelToBrowse");
        int i;
        for(i = 99; i <= 110; i++)
        	DeleteLocalString(oPC, "TOKEN" + IntToString(i));
        //restart the convo to pick next power if needed
        ExecuteScript("psi_powergain", oPC);
        return;
    }
    else if(nValue == -3)
    {
        //PrintString("Convo aborted");
        //abort conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
        DeleteLocalInt(oPC, "Stage");
        DeleteLocalInt(oPC, "Stage1Setup");
        DeleteLocalInt(oPC, "nPowerFeat");
        DeleteLocalInt(oPC, "nPowerLevelToBrowse");
        int i;
        for(i = 99; i <= 110; i++)
        	DeleteLocalString(oPC, "TOKEN" + IntToString(i));
        //restart the conversation
        AssignCommand(oPC, ClearAllActions());
        ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE);
        return;
    }
    nValue += GetLocalInt(oPC, "ChoiceOffset");
    nValue = array_get_int(oPC, "ChoiceValues", nValue);
    int nStage = GetLocalInt(oPC, "Stage");
    if(nStage == 0){
        SetLocalInt(oPC, "nPowerLevelToBrowse", nValue);
        nStage++;
        
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        //PrintString("Selected level to browse: " + IntToString(nValue));
    }
    else if(nStage == 1)
    {
        if(nValue == -1)
        {
            nStage--;
            DeleteLocalInt(oPC, "nPowerLevelToBrowse");
            //PrintString("Returning to level browsing");
        }
        else
        {
            SetLocalInt(oPC, "nPower", nValue);
            nStage++;
            //PrintString("Going to power selection confirmation");
        }

        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
        DeleteLocalInt(oPC, "Stage1Setup");
    }
    else if(nStage == 2)
    {
        //PrintString("Power selection choice done");
        if(nValue == 1) // feat selected
        {
            //PrintString("Power taken");
            int nPower = GetLocalInt(oPC, "nPower");
            int nPowerFeatIP = StringToInt(Get2DACache(sPowerFile, "IPFeatID", nPower));
            object oSkin = GetPCSkin(oPC);
            itemproperty ipFeat = ItemPropertyBonusFeat(nPowerFeatIP);
            IPSafeAddItemProperty(oSkin, ipFeat);
            if(!persistant_array_exists(oPC, "PsiPowerCount"))
                persistant_array_create(oPC, "PsiPowerCount");
            persistant_array_set_int(oPC, "PsiPowerCount", nClass, persistant_array_get_int(oPC, "PsiPowerCount", nClass)+1);
        }

        int nCurrentPowers = GetPowerCount(oPC, nClass);
        int nMaxPowers = GetMaxPowerCount(oPC, nClass);
        if(nCurrentPowers >= nMaxPowers)
            nStage++;
        else
            nStage--;

        DeleteLocalInt(oPC, "nPowerFeat");

        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");

    }
    SetLocalInt(oPC, "Stage", nStage);
}