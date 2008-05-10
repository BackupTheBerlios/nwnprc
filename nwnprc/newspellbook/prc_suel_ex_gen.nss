#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_SUEL_ARCHANAMACH, METAMAGIC_EXTEND, GetPowerFromSpellID(PRCGetSpellId()));
}
