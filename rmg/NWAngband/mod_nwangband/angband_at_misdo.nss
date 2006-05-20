#include "ral_inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oWP = GetObjectByTag("Angband_WP");
    int nDifficulty = GetLocalInt(OBJECT_SELF, "MissionDifficulty");
    RAL_DoTransition(oPC, oWP);
}
