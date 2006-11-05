#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_SLAYER_OF_DOMIEL, METAMAGIC_EXTEND, GetPowerFromSpellID(PRCGetSpellId()));
}
