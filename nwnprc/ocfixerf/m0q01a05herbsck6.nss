// Added compatibility for PRC base classes
#include "prc_alterations"
#include "inc_utility"

int StartingConditional()
{
if(DEBUG) DoDebug("m0q01a05herbsck6 running");
    return GetLevelByClass(CLASS_TYPE_MONK, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_BRAWLER, GetPCSpeaker()) > 0;
}



