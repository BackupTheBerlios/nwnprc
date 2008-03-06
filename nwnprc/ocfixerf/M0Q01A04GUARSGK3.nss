// Added compatibility for PRC base classes
#include "prc_alterations"
#include "inc_utility"

int StartingConditional()
{
    int bCondition = GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker()) > 0 ||
		     GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, GetPCSpeaker()) > 0 ||
		     GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) > 0 ||
		     GetLevelByClass(CLASS_TYPE_CRUSADER, GetPCSpeaker()) > 0 ||
		     GetLevelByClass(CLASS_TYPE_SHAMAN, GetPCSpeaker()) > 0 ||
		     GetLevelByClass(CLASS_TYPE_HEALER, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) > 0;
    return bCondition;
}
