#include "prgt_inc"
void main()
{
    object oPC = GetExitingObject();
    SetLocalInt(oPC, "InDetect", GetLocalInt(oPC, "InDetect")-1);
}
