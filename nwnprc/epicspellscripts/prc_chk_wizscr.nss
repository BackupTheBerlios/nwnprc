#include "inc_utility"

int StartingConditional()
{
int iCondition = GetPRCSwitch(PRC_SPELLSLAB_NOSCROLLS);

if (iCondition > 0) return FALSE;

return TRUE;
}

