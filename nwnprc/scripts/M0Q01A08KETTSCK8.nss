// Added compatibility for PRC base classes
#include "prc_class_const"


int StartingConditional()
{
    int bCondition = (GetLevelByClass(CLASS_TYPE_ROGUE, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_NINJA, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) > 0) &&
                     GetLocalInt(GetModule(),"NW_G_M0Q01_ROGUE_TEST") < 2;
    return bCondition;
}

