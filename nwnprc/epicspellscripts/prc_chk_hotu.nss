int StartingConditional()
{
int iCondition = GetLocalInt(GetModule(), "PRC_SPELLSLAB");

if (iCondition == 1) return TRUE;

return FALSE;
}

