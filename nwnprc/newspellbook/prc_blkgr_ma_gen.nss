#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_BLACKGUARD, METAMAGIC_MAXIMIZE, GetPowerFromSpellID(PRCGetSpellId()));
}
