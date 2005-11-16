// Added compatibility for PRC base classes
#include "prc_class_const"


int StartingConditional()
{
    return GetLevelByClass(CLASS_TYPE_ANTI_PALADIN, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_CORRUPTER, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_SAMURAI, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_PSYWAR, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_SOULKNIFE, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_CW_SAMURAI, GetPCSpeaker()) > 0 ||
           GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker()) > 0;
}

