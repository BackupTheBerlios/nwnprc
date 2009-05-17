#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_DREAD_NECROMANCER, METAMAGIC_NONE, GetPowerFromSpellID(PRCGetSpellId()));
}
