// Added compatibility for PRC base classes
#include "prc_alterations"
#include "inc_utility"

int StartingConditional()
{
if(DEBUG) DoDebug("m0q01a06jarosck6 running");
    int bCondition = GetLocalInt(OBJECT_SELF,"NW_L_TALKLEVEL") == 2 &&
                     (GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_PSION, GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_DUSKBLADE, GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_SHUGENJA, GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_WARMAGE, GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_PSYWAR, GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_WILDER, GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker()) > 0);

    return bCondition;
}

