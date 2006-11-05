#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_SOLDIER_OF_LIGHT, METAMAGIC_STILL, GetPowerFromSpellID(PRCGetSpellId()));
}
