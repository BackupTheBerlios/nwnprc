#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_SUEL_ARCHANAMACH, METAMAGIC_SILENT, GetPowerFromSpellID(PRCGetSpellId()));
}
