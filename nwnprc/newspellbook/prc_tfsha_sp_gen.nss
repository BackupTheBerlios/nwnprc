#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_SHADOWLORD, METAMAGIC_NONE, GetPowerFromSpellID(PRCGetSpellId()));
}
