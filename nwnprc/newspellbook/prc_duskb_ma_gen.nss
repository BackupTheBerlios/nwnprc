#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_DUSKBLADE, METAMAGIC_MAXIMIZE, GetPowerFromSpellID(PRCGetSpellId()));
}
