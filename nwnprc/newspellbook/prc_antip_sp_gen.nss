#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_ANTI_PALADIN, METAMAGIC_NONE, GetPowerFromSpellID(PRCGetSpellId()));
}
