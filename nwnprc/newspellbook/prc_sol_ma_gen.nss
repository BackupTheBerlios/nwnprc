#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_SOLDIER_OF_LIGHT, METAMAGIC_MAXIMIZE, GetPowerFromSpellID(PRCGetSpellId()));
}
