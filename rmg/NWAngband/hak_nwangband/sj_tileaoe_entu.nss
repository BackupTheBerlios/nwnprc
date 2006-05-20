#include "water_inc"
void main()
{
    object oPC = GetEnteringObject();
    int nVar = GetLocalInt(oPC, "sj_tileaoe_w");
    nVar++;
    SetLocalInt(oPC, "sj_tileaoe_w", nVar);
    if(nVar == 1)
    {
        SetFootstepType(FOOTSTEP_TYPE_WATER_LARGE, oPC);
        EnterUnderwaterDrown(oPC);
    }
}
