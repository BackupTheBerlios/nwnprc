// Added compatibility for PRC base classes
#include "prc_class_const"

int StartingConditional()
{
    int bCondition = GetLocalInt(OBJECT_SELF, "NW_L_TALKLEVEL") == 2 &&
                     (GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker()) > 0 ||
		      GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) > 0 ||
		      GetLevelByClass(CLASS_TYPE_SHAMAN, GetPCSpeaker()) > 0 ||
		      GetLevelByClass(CLASS_TYPE_CRUSADER, GetPCSpeaker()) > 0 ||
		      GetLevelByClass(CLASS_TYPE_SHUGENJA, GetPCSpeaker()) > 0 ||
		      GetLevelByClass(CLASS_TYPE_HEALER, GetPCSpeaker()) > 0 ||
		      GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, GetPCSpeaker()) > 0 ||
		      		      GetLevelByClass(CLASS_TYPE_MYSTIC, GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker())> 0);
    return bCondition;
}



