void main()
{
    object oPC = GetExitingObject();
    int nVar = GetLocalInt(oPC, "sj_tileaoe_w");
    nVar--;
    SetLocalInt(oPC, "sj_tileaoe_w", nVar);
    if(nVar == 0)
    {
        SetFootstepType(FOOTSTEP_TYPE_DEFAULT, oPC);
    }
}
