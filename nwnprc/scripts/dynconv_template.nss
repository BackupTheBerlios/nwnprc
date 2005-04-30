#include "inc_utility"


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
// INSERT CODE HERE FOR THE HEADER
// AND PC RESPONSES
// token no 50 = header
// array named ChoiceTokens for strings
// array named ChoiceValues for ints associated with responces
        if(nStage == 0)
        {
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
        return;
    }
    else if(nValue == -3)
    {
      //abort conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
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
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
    }
    SetLocalInt(oPC, "Stage", nStage);
}
