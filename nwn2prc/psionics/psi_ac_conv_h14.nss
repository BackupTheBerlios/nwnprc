// Returns true if the AC being edited has Improved Buff
// Result is normalized to TRUE / FALSE

#include "psi_inc_ac_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return (GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT) &
                             ASTRAL_CONSTRUCT_OPTION_IMP_BUFF)
           != 0;
}
