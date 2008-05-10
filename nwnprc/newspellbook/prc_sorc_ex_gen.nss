#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_SORCERER, METAMAGIC_EXTEND, GetPowerFromSpellID(PRCGetSpellId()));
}
