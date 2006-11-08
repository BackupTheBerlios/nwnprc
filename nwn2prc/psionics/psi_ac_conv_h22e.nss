// Returns true if the AC being edited has Energy Bolt - Electricity
// Result is normalized to TRUE / FALSE

#include "psi_inc_ac_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return (GetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS + EDIT) &
                             ELEMENT_ELECTRICITY)
           != 0;
}