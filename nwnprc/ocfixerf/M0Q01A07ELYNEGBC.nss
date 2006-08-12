// Added compatibility for PRC base classes
#include "prc_class_const"
#include "inc_utility"

int StartingConditional()
{
    return GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, GetPCSpeaker()) > 0 ||
	   GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) > 0 ||
	   GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) > 0;
}
