// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

int StartingConditional()
{
if(DEBUG) DoDebug("m0q01a05herbsck5 running");
    return GetLevelByClass(CLASS_TYPE_BOWMAN, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, GetPCSpeaker()) > 0 ||
	   GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) > 0 ||
	   GetLevelByClass(CLASS_TYPE_SCOUT, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) > 0;
}



