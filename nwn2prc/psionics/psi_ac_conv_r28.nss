// Removes Rend from the AC being edited

#include "psi_inc_ac_const"


void main()
{
    object oPC = GetPCSpeaker();

    int nFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT);
        nFlags ^= ASTRAL_CONSTRUCT_OPTION_REND;

    SetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT, nFlags);
}