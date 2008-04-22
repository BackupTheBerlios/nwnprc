// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

int StartingConditional()
{
if(DEBUG) DoDebug("m0q01a08kettsck6 running");
    int bCondition =  GetLocalInt(OBJECT_SELF, "NW_L_TALKLEVEL") == 2 &&
                      (GetLevelByClass(CLASS_TYPE_ROGUE, GetPCSpeaker()) > 0 ||
                       GetLevelByClass(CLASS_TYPE_NINJA, GetPCSpeaker()) > 0 ||
                       GetLevelByClass(CLASS_TYPE_SCOUT, GetPCSpeaker()) > 0 ||
                       GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker())> 0) &&
                      !GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(),"NW_ROGUE_ITEM"));
    return bCondition;
}



