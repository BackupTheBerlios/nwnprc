#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_WARMAGE, METAMAGIC_SILENT, GetPowerFromSpellID(PRCGetSpellId()));
}
