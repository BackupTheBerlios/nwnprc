#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_VIGILANT, METAMAGIC_EXTEND, GetPowerFromSpellID(PRCGetSpellId()));
}
