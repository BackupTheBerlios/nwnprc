#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_KNIGHT_CHALICE, METAMAGIC_EXTEND, GetPowerFromSpellID(PRCGetSpellId()));
}
