#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_HEALER, METAMAGIC_NONE, GetPowerFromSpellID(PRCGetSpellId()));
}
