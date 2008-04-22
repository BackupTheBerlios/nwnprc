// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

int StartingConditional()
{
if(DEBUG) DoDebug("m0q01a04guarsgk2 running");
    int bCondition = GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_PSION, GetPCSpeaker()) > 0 ||
		     GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) > 0 ||
		     GetLevelByClass(CLASS_TYPE_SHUGENJA, GetPCSpeaker()) > 0 ||
		     GetLevelByClass(CLASS_TYPE_SWORDSAGE, GetPCSpeaker()) > 0 ||
		     GetLevelByClass(CLASS_TYPE_WARLOCK, GetPCSpeaker()) > 0 ||
		     GetLevelByClass(CLASS_TYPE_WARMAGE, GetPCSpeaker()) > 0 ||
		     GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, GetPCSpeaker()) > 0 ||
		     GetLevelByClass(CLASS_TYPE_DUSKBLADE, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_PSYWAR, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_WILDER, GetPCSpeaker()) > 0 ||
                     GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker()) > 0;
    return bCondition;
}

