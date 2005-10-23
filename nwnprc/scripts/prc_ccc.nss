#include "prc_ccc_inc"

#include "inc_dynconv"


void CheckAndBoot(object oPC)
{
    if(GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))))
        BootPC(oPC);
}

void main()
{
    object oPC = OBJECT_SELF;
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);

    if(nValue == 0)
        return;


    if(nValue == DYNCONV_SETUP_STAGE)
    {
        int nStage = GetStage(oPC);
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(GetIsStageSetUp(nStage, oPC))
        {
            SetupStage();
            SetupHeader();
        }

        // Do token setup
        SetupTokens();
        ExecuteScript("prc_ccc_debug", oPC);
    }
    else if(nValue == DYNCONV_EXITED)
    {
        //end of conversation cleanup
        SetCutsceneMode(oPC, FALSE);
        AssignCommand(oPC, DelayCommand(1.0, CheckAndBoot(oPC)));
        DoCleanup();
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        //abort conversation cleanup
        DoCleanup();
        SetCutsceneMode(oPC, FALSE);
        AssignCommand(oPC, DelayCommand(1.0, CheckAndBoot(oPC)));
        ForceRest(oPC);
    }
    else
    {
        //selection made
        ChoiceSelected(nValue);
        SetupTokens();
    }
}
