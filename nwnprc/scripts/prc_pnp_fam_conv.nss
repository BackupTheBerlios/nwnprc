#include "inc_utility"
#include "inc_persist_loca"
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

    SetupTokens();
    if(nValue == -1)
    {
        int nStage = GetLocalInt(oPC, "Stage");
        array_create(oPC, "StagesSetup");
        if(array_get_int(oPC, "StagesSetup", nStage))
            return;
// INSERT CODE HERE FOR THE HEADER
// AND PC RESPONSES
// token no 99 = header
// array named ChoiceTokens for strings
// array named ChoiceValues for ints associated with responces
        if(nStage == 0)
        {
            SetCustomToken(99, "Please select a familiar.\nAll familiars will cost 100GP to summon.");

            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                "Bat");
            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 1);
//            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
//                "Cat");
//            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 2);
            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                "Hawk");
            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 3);
//            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
//                "Lizard");
//            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 4);
//            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
//                "Owl");
//            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 5);
//            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
//                "Rat");
//            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 6);
//            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
//                "Raven");
//            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 7);
//            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
//                "Snake");
//            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 8);
//            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
//                "Toad");
//            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 9);
//            array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
//                "Weasel");
//            array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), 10);
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
        DeleteLocalString(oPC, "DynConv_Script");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "Stage");
        return;
    }
    else if(nValue == -3)
    {
      //abort conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
        DeleteLocalString(oPC, "DynConv_Script");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "Stage");
        return;
    }
    nValue = array_get_int(oPC, "ChoiceValues", nValue);
    int nStage = GetLocalInt(oPC, "Stage");
    if(nStage == 0)
    {
        //nValue is the int associated with the response selected
        //move to another stage based on responce
        nStage++;
        SetPersistantLocalInt(oPC, "PnPFamiliarType", nValue);
        ActionUseFeat(FEAT_SUMMON_FAMILIAR, OBJECT_SELF);
        //take gold
        TakeGoldFromCreature(100, oPC, TRUE);
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
    }
    SetLocalInt(oPC, "Stage", nStage);
}
