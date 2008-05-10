#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_DUSKBLADE, METAMAGIC_QUICKEN, GetPowerFromSpellID(PRCGetSpellId()));
}
