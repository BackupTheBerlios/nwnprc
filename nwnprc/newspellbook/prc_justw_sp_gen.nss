#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_JUSTICEWW, METAMAGIC_NONE, GetPowerFromSpellID(PRCGetSpellId()));
}