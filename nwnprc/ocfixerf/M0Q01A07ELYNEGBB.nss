// Added compatibility for PRC base classes
#include "prc_alterations"
#include "inc_utility"

int StartingConditional()
{
    return GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker()) > 0;
}