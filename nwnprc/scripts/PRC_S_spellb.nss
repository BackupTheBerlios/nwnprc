#include "prc_alterations"
#include "inc_newspellbook"
#include "inc_dynconv"
void main()
{
    object oPC = OBJECT_SELF;
    int nValue = GetLocalInt(oPC, "DynConv_Var");
    array_create(oPC, "ChoiceTokens");
    array_create(oPC, "ChoiceValues");

    if(nValue == 0)
        return;
    if(nValue > 0)
        nValue --;//correct for 1 based to zero based


    if(nValue == -1)
    {
        int nStage = GetLocalInt(oPC, "Stage");
        array_create(oPC, "StagesSetup");
        if(array_get_int(oPC, "StagesSetup", nStage))
            return; //this stops list duplication when scrolling
// INSERT CODE HERE FOR THE HEADER
// token no 50
        if(nStage == 0)
        {
            //select spell class
            SetCustomToken(99, "Select a spell book:");
            int i;
            for(i=12;i<=255;i++)
            {
                if(GetLevelByClass(i, oPC)
                    && GetSlotCount(GetLevelByClass(i, oPC), 1, GetAbilityForClass(i, oPC), i))
                {
                    array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                        GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", i))));
                    array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), i);
                }
            }
            array_set_int(oPC, "StagesSetup", nStage, TRUE);
        }
        if(nStage == 1)
        {
            //select spell level
            int nSpellClass = GetLocalInt(oPC, "SpellClass");
            string sFile = GetFileForClass(nSpellClass);
            int nClassLevel = GetSpellslotLevel(nSpellClass, oPC);
            int nAbilityScore = GetAbilityForClass(nSpellClass, oPC);
            string sMessage;
            int i;
            sMessage += "You have remaining:\n";
            int nArraySize = persistant_array_get_size(oPC, "NewSpellbookMem_"+IntToString(nSpellClass));     
            for(i=0;i<nArraySize;i++)
            {
                int nUses = persistant_array_get_int(oPC, "NewSpellbookMem_"+IntToString(nSpellClass), i);
                if(nUses > 0)
                {
                    int nSpellID = StringToInt(Get2DACache(sFile, "SpellID", i));
                    string sSpellName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
                    sMessage += "  "+IntToString(nUses)+" "+sSpellName+"\n";
                }
            }
            sMessage += "\nSelect a spell level:";
            SetCustomToken(99, sMessage);
            for(i=0;i<=9;i++)
            {
                if(GetSlotCount(nClassLevel, i, nAbilityScore, nSpellClass))
                {
                    array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"), "Spell level "+IntToString(i));
                    array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), i);
                }
            }
            array_set_int(oPC, "StagesSetup", nStage, TRUE);
        }
        else if(nStage == 2)
        {
            //select spell slot
            SetCustomToken(99, "Select a spell slot:");
            int nSpellClass = GetLocalInt(oPC, "SpellClass");
            int nSpellLevel = GetLocalInt(oPC, "SpellLevel");
            int nClassLevel = GetSpellslotLevel(nSpellClass, oPC);
            int nAbilityScore = GetAbilityForClass(nSpellClass, oPC);
            int nSlots = GetSlotCount(nClassLevel, nSpellLevel, nAbilityScore, nSpellClass);
            int nSlot;
            for(nSlot = 0; nSlot < nSlots; nSlot++)
            {
                int nSpellbookID = persistant_array_get_int(oPC, "Spellbook"+IntToString(nSpellLevel)+"_"+IntToString(nSpellClass), nSlot);
                array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), nSlot);
                if(nSpellbookID == 0)
                    array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"), "empty");
                else
                {
                    string sFile = GetFileForClass(nSpellClass);
                    int nFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID));
                    array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                        GetStringByStrRef(StringToInt(Get2DACache("iprp_feats", "Name", nFeatID))));
                }
            }
            array_set_int(oPC, "StagesSetup", nStage, TRUE);
        }
        else if(nStage == 3 )
        {
            //select spell
            SetCustomToken(99, "Select a spell:");
            int nSpellLevel = GetLocalInt(oPC, "SpellLevel");
            int nSpellClass = GetLocalInt(oPC, "SpellClass");
            string sFile = GetFileForClass(nSpellClass);
            int i;
            //this may cause a TMI, dont have time to fix it now
            for(i=1;i<410;i++)
            {
                if(StringToInt(Get2DACache(sFile, "Level", i)) == nSpellLevel
                    && Get2DACache(sFile, "Level", i) != ""
                    && (Get2DACache(sFile, "ReqFeat", i)=="" 
                        || GetHasFeat(StringToInt(Get2DACache(sFile, "ReqFeat", i)), oPC)))
                {
                    int nFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", i));
                    array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                        GetStringByStrRef(StringToInt(Get2DACache("iprp_feats", "Name", nFeatID))));
                    array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), i);
                }
            }
            array_set_int(oPC, "StagesSetup", nStage, TRUE);
        }
        //do token setup
        SetupTokens();
        SetCustomToken(110, GetStringByStrRef(16824212));//finish
        SetCustomToken(111, GetStringByStrRef(16824202));//please wait
        SetCustomToken(112, GetStringByStrRef(16824204));//next
        SetCustomToken(113, GetStringByStrRef(16824203));//previous

// END OF INSERT FOR THE HEADER
        return;
    }
    else if(nValue == -2)
    {
      //end of conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "Stage");
        DeleteLocalInt(oPC, "SpellClass");
        DeleteLocalInt(oPC, "SpellLevel");
        DeleteLocalInt(oPC, "ChoiceOffset");
        DeleteLocalInt(oPC, "SpellSlot");
        array_delete(oPC, "StagesSetup");
        return;
    }
    else if(nValue == -3)
    {
      //abort conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "Stage");
        DeleteLocalInt(oPC, "SpellClass");
        DeleteLocalInt(oPC, "SpellLevel");
        DeleteLocalInt(oPC, "ChoiceOffset");
        DeleteLocalInt(oPC, "SpellSlot");
        array_delete(oPC, "StagesSetup");
        return;
    }
    nValue = array_get_int(oPC, "ChoiceValues", nValue+GetLocalInt(oPC, "ChoiceOffset"));
    int nStage = GetLocalInt(oPC, "Stage");
    if(nStage == 0)
    {
        //select class
        SetLocalInt(oPC, "SpellClass", nValue);
        array_set_int(oPC, "StagesSetup", nStage, FALSE);
        nStage++;
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
    }
    else if(nStage == 1)
    {
        //select level
        SetLocalInt(oPC, "SpellLevel", nValue);
        array_set_int(oPC, "StagesSetup", nStage, FALSE);
        nStage++;
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
    }
    else if(nStage == 2)
    {
        //select slot
        SetLocalInt(oPC, "SpellSlot", nValue);
        array_set_int(oPC, "StagesSetup", nStage, FALSE);
        nStage++;
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
    }
    else if(nStage == 3)
    {
        //select spell
        int nSpellSlot = GetLocalInt(oPC, "SpellSlot");
        int nSpellLevel = GetLocalInt(oPC, "SpellLevel");
        int nSpellClass = GetLocalInt(oPC, "SpellClass");
        persistant_array_create(oPC, "Spellbook"+IntToString(nSpellLevel)+"_"+IntToString(nSpellClass));
        persistant_array_set_int(oPC, "Spellbook"+IntToString(nSpellLevel)+"_"+IntToString(nSpellClass), nSpellSlot, nValue);
        array_set_int(oPC, "StagesSetup", nStage, FALSE);
        nStage = 1;
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
    }
    SetLocalInt(oPC, "Stage", nStage);
}
