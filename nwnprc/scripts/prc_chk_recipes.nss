#include "prc_inc_switch"

int StartingConditional()
{
int iCondition = GetPRCSwitch(PRC_SPELLSLAB_NORECIPES);

if (iCondition > 0) return FALSE;

return TRUE;
}

