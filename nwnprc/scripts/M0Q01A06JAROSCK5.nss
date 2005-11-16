// Added compatibility for PRC base classes
#include "prc_class_const"


int StartingConditional()
{
    return GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker()) >= 1 ||
           GetLevelByClass(CLASS_TYPE_PSION, GetPCSpeaker()) >= 1;
}


