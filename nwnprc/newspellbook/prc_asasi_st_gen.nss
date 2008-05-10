#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_ASSASSIN, METAMAGIC_STILL, GetPowerFromSpellID(PRCGetSpellId()));
}
