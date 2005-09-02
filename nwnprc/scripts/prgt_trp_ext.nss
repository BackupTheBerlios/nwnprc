#include "prc_alterations"
#include "prgt_inc"
void main()
{
    object oPC = GetExitingObject();
    SetLocalInt(oPC, "InTrap", GetLocalInt(oPC, "InTrap")-1);
}
