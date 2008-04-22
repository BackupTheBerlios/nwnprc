// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

int StartingConditional()
{
if(DEBUG) DoDebug("m0q01a08kettsgk1 running");
    int bCondition = GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(),"NW_ROGUE_ITEM")) &&
                     GetLocalInt(GetModule(),"NW_G_M0Q01_ROGUE_TEST") == 1 &&
                     (GetLevelByClass(CLASS_TYPE_BARD,GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_NINJA,GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_SCOUT,GetPCSpeaker()) > 0 ||
                      GetLevelByClass(CLASS_TYPE_ROGUE,GetPCSpeaker()) > 0);

    return bCondition;
}



