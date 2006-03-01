// Added compatibility for PRC base classes
#include "prc_class_const"
#include "inc_utility"

int StartingConditional()
{
if(DEBUG) DoDebug("m0q01a04guarsgk2 running");
    int bCondition = GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_PSION, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_PSYWAR, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_WILDER, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker()) > 0;
    return bCondition;
}

