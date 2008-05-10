#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_OCULAR, METAMAGIC_MAXIMIZE, GetPowerFromSpellID(PRCGetSpellId()));
}
