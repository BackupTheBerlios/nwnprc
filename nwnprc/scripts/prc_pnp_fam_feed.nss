#include "prc_alterations"
#include "prc_inc_switch"
int StartingConditional()
{
    return !GetPRCSwitch(PRC_PNP_FAMILIAR_FEEDING);
}
