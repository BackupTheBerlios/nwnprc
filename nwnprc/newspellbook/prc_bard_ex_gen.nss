#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_BARD, METAMAGIC_EXTEND, GetPowerFromSpellID(PRCGetSpellId()));
}
