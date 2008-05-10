#include "prc_alterations"

#include "inc_newspellbook"

void main()
{
    NewSpellbookSpell(CLASS_TYPE_SUEL_ARCHANAMACH, METAMAGIC_EMPOWER, GetPowerFromSpellID(PRCGetSpellId()));
}
