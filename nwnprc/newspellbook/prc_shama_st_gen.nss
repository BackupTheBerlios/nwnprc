#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_SHAMAN, METAMAGIC_STILL, GetPowerFromSpellID(PRCGetSpellId()));
}
