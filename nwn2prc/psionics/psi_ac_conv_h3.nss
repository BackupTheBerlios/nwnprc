// Returns true if the AC being edited has Cleave
// Result is normalized to TRUE / FALSE

#include "psi_inc_ac_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return (GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT) &
                             ASTRAL_CONSTRUCT_OPTION_CLEAVE)
           != 0;
}