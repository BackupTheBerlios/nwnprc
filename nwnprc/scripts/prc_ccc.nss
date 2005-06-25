#include "prc_ccc_inc"

void CheckAndBoot(object oPC)
{
    if(GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))))
        BootPC(oPC);
}

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
        //to the header
        int nStage  = GetLocalInt(OBJECT_SELF, "Stage");
        array_create(OBJECT_SELF, "StagesSetup");
        if(array_get_int(OBJECT_SELF, "StagesSetup", nStage))
            return;
        //stage has changed, clear the choice array
        array_delete(OBJECT_SELF, "ChoiceTokens");
        array_create(OBJECT_SELF, "ChoiceTokens");
        array_delete(OBJECT_SELF, "ChoiceValue");
        array_create(OBJECT_SELF, "ChoiceValue");
        DeleteLocalInt(OBJECT_SELF, "ChoiceOffset");
        SetupStage();
        SetupHeader();
        SetupTokens();
        ExecuteScript("prc_ccc_debug", OBJECT_SELF);
        return;
    }
    else if(nValue == -2)
    {
        //end of conversation cleanup
        if(GetLocalInt(OBJECT_SELF, "DoMake"))
        {
            ExecuteScript("prc_ccc_make", OBJECT_SELF);
            DeleteLocalInt(OBJECT_SELF, "DoMake");
        }
        else
        {
            SetCutsceneMode(oPC, FALSE);
            AssignCommand(oPC, DelayCommand(1.0, CheckAndBoot(oPC)));
        }
        DoCleanup();
        return;
    }
    else if(nValue == -3)
    {
        //abort conversation cleanup
        DoCleanup();
        SetCutsceneMode(oPC, FALSE);
        AssignCommand(oPC, DelayCommand(1.0, CheckAndBoot(oPC)));
        ForceRest(oPC);
        return;
    }
    else
    {
        //selection made
        ChoiceSelected(nValue);
    }        
}
