// Added compatibility for PRC base classes
#include "prc_class_const"
#include "inc_utility"

int StartingConditional()
{
if(DEBUG) DoDebug("m0q01a05herbsck5 running");
    return GetLevelByClass(CLASS_TYPE_ARCHER, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) > 0;
}

