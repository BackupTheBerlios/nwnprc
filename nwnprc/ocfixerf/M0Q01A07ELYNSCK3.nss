// Added compatibility for PRC base classes
#include "prc_class_const"
#include "inc_utility"

int StartingConditional()
{
    int bCondition = GetLocalInt(OBJECT_SELF, "NW_L_TALKLEVEL") == 1 &&
                     (GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker()) > 0 ||
		      GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, GetPCSpeaker()) > 0 ||
		      GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker())> 0);
    return bCondition;
}

