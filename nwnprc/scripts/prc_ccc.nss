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


    if(nValue == -1)
    {
        //to the header
        SetupStage();
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
        return;
    }
    else
    {
        //selection made
        ChoiceSelected(nValue);
    }        
}
