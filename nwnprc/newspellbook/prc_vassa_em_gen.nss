#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_VASSAL, METAMAGIC_EMPOWER, GetPowerFromSpellID(PRCGetSpellId()));
}
