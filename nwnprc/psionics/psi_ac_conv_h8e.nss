// Returns true if the AC being edited has Resistance - Electricity
// Result is normalized to TRUE / FALSE

#include "psi_inc_ac_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return (GetLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS + EDIT) &
                             ELEMENT_ELECTRICITY)
           != 0;
}
