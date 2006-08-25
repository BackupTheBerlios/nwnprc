// Added compatibility for PRC base classes
#include "prc_class_const"
#include "prc_alterations"

int StartingConditional()
{
    return GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker()) > 0;
}
