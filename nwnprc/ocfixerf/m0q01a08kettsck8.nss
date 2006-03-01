// Added compatibility for PRC base classes
#include "prc_class_const"
#include "inc_utility"

int StartingConditional()
{
if(DEBUG) DoDebug("m0q01a08kettsck8 running");
    int bCondition = (GetLevelByClass(CLASS_TYPE_ROGUE, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_NINJA, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) > 0) &&
                     GetLocalInt(GetModule(),"NW_G_M0Q01_ROGUE_TEST") < 2;
    return bCondition;
}

