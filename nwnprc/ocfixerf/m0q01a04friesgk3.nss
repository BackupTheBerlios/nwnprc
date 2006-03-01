// Added compatibility for PRC base classes
#include "prc_class_const"
#include "inc_utility"

int StartingConditional()
{
DoDebug("m0q01a04friesgk3 running");
    int bCondition = GetLevelByClass(CLASS_TYPE_FIGHTER, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_MONK, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_ANTI_PALADIN, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_SAMURAI, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_CORRUPTER, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_ARCHER, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_BRAWLER, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_SOULKNIFE, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_PSYWAR, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_CW_SAMURAI, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_MARSHAL, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_BARBARIAN, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker()) > 0;
    return bCondition;
}

