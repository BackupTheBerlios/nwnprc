#include "prgt_inc"
void main()
{
    object oPC = GetEnteringObject();
    if(!GetLocalInt(oPC, "InTrap"))
        AssignCommand(oPC, TrapPsuedoHB(OBJECT_SELF));
    SetLocalInt(oPC, "InTrap", GetLocalInt(oPC, "InTrap")+1);
}
