// Added compatibility for PRC base classes
#include "prc_class_const"


int StartingConditional()
{
    return GetLevelByClass(CLASS_TYPE_ARCHER, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) > 0;
}

