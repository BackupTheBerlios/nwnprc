// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

int StartingConditional()
{
if(DEBUG) DoDebug("m0q01a06jarosck5 running");
    return GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker()) >= 1 ||
           GetLevelByClass(CLASS_TYPE_PSION, GetPCSpeaker()) >= 1;
}




