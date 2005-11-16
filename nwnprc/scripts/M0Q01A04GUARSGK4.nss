// Added compatibility for PRC base classes
#include "prc_class_const"


int StartingConditional()
{
    return GetLevelByClass(CLASS_TYPE_ROGUE, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_NINJA, GetPCSpeaker()) > 0;
}
