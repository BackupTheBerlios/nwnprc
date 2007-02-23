/*
    generic utterance calling function
*/
#include "true_inc_trufunc"

void main()
{
	int nSpellId = PRCGetSpellId();
	DoDebug("Utterance SpellId: " + IntToString(nSpellId));
	UseUtterance(GetPowerFromSpellID(nSpellId), CLASS_TYPE_TRUENAMER);
}