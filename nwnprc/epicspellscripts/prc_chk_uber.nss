int StartingConditional()
{
int iCondition = GetLocalInt(GetModule(), "PRC_SPELLSLAB");

if (iCondition == 0) return TRUE;

return FALSE;
}

