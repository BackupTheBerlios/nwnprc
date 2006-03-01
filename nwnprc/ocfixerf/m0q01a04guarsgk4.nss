// Added compatibility for PRC base classes
#include "prc_class_const"
#include "inc_utility"

int StartingConditional()
{
if(DEBUG) DoDebug("m0q01a04guarsgk4 running");
    return GetLevelByClass(CLASS_TYPE_ROGUE, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_NINJA, GetPCSpeaker()) > 0;
}
