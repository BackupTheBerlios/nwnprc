#include "inc_utility"
#include "inc_item_props"
#include "x2_inc_itemprop"
#include "psi_inc_psifunc"
#include "inc_fileends"

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
// INSERT CODE HERE FOR THE HEADER
// token no 50
        if(nStage == 0 && GetLocalInt(oPC, "Stage0Setup") == FALSE)
        {
            //select a power to gain

            int nCurrentPowers = GetPowerCount(oPC, nClass);
            int nLevel = GetLevelByClass(nClass, oPC);
            int nMaxPowers = StringToInt(Get2DACache(sPsiFile, "PowersKnown", nLevel-1));
            string sToken = "Select a power to gain.\n You can select "+IntToString(nMaxPowers-nCurrentPowers)+" more powers";
            SetCustomToken(99, sToken);

            int nManifestLevel = GetLevelByClass(nClass, oPC);
            int nMaxLevel = StringToInt(Get2DACache(sPsiFile, "MaxPowerLevel", nManifestLevel-1));
            int i;
            for (i=0;i<CLASS_POWER_2DA_END;i++)
            {
                int nPowerLevel = StringToInt(Get2DACache(sPowerFile, "Level", i));
                int nFeatID  = StringToInt(Get2DACache(sPowerFile, "FeatID", i));
//                int nPowerFeatIP= StringToInt(Get2DACache(sPowerFile, "IPFeatID", i));
//                int nPowerSpell = StringToInt(Get2DACache(sPowerFile, "SpellID", i));
                if(Get2DACache(sPowerFile, "FeatID", i) != ""
                    && nPowerLevel <= nMaxLevel
                    && CheckPowerPrereqs(nFeatID, oPC))
                {
                    array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                        GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID))));
                    array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), i);
                }
            }
		SetLocalInt(oPC, "Stage0Setup", TRUE);
        }
        else if(nStage == 1)
        {	
            string sToken = "You have selected:\n\n";
            int nPower = GetLocalInt(oPC, "nPower");
            int nFeatID = StringToInt(Get2DACache(sPowerFile, "FeatID", nPower));
            sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID)))+"\n";
            sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeatID)))+"\n\n";
            sToken += "Is this correct?";
            SetCustomToken(99, sToken);
            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                "Yes");
            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 1);
            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                "No");
            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 2);
        }
        else if(nStage == 2)
        {	
            string sToken = "You will be able to select more powers after you gain another level in a psionic caster class.";
            SetCustomToken(99, sToken);
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

// END OF INSERT FOR THE HEADER
        return;
    }
    else if(nValue == -2)
    {
        //end of conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
        DeleteLocalInt(oPC, "Stage");
        DeleteLocalInt(oPC, "Stage0Setup");
        DeleteLocalInt(oPC, "nPowerFeat");
        //restart the convo to pick next power if needed
        ExecuteScript("psi_powergain", oPC);
        return;
    }
    else if(nValue == -3)
    {
        //abort conversation cleanup
        //restart the conversation
        AssignCommand(oPC, ClearAllActions());
        ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE);
        return;
    }
    nValue += GetLocalInt(oPC, "ChoiceOffset");
    nValue = array_get_int(oPC, "ChoiceValues", nValue);
    int nStage = GetLocalInt(oPC, "Stage");
    if(nStage == 0)
    {
        SetLocalInt(oPC, "nPower", nValue);
        nStage++;

        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
        DeleteLocalInt(oPC, "Stage0Setup");
    }
    else if(nStage == 1)
    {
        if(nValue == 1) // feat selected
        {
            int nPower = GetLocalInt(oPC, "nPower");
            int nPowerFeatIP= StringToInt(Get2DACache(sPowerFile, "IPFeatID", nPower));
            object oSkin = GetPCSkin(oPC);
            itemproperty ipFeat = ItemPropertyBonusFeat(nPowerFeatIP);
            IPSafeAddItemProperty(oSkin, ipFeat);
            if(!persistant_array_exists(oPC, "PsiPowerCount"))
                persistant_array_create(oPC, "PsiPowerCount");
            persistant_array_set_int(oPC, "PsiPowerCount", nClass, persistant_array_get_int(oPC, "PsiPowerCount", nClass)+1);
        }

        int nCurrentPowers = GetPowerCount(oPC, nClass);
        int nLevel = GetLevelByClass(nClass, oPC);
        int nMaxPowers = StringToInt(Get2DACache(sPsiFile, "PowersKnown", nLevel-1));
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