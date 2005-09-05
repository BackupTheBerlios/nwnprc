#include "inc_utility"
int StartingConditional()
{
int iCondition = GetPRCSwitch(PRC_SPELLSLAB);

if (iCondition == 1) return TRUE;

return FALSE;
}

