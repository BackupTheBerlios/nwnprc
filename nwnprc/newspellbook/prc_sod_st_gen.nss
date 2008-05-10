#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_SLAYER_OF_DOMIEL, METAMAGIC_STILL, GetPowerFromSpellID(PRCGetSpellId()));
}
