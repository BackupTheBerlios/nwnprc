// Added compatibility for PRC base classes
#include "prc_class_const"
#include "inc_utility"

int StartingConditional()
{
DoDebug("m0q01a05herbsck6 running");
    return GetLevelByClass(CLASS_TYPE_MONK, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_BRAWLER, GetPCSpeaker()) > 0;
}

