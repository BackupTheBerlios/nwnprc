int StartingConditional()
{
int iCondition = GetLocalInt(GetModule(), "PRC_SPELLSLAB_NOSCROLLS");

if (iCondition > 0) return FALSE;

return TRUE;
}

