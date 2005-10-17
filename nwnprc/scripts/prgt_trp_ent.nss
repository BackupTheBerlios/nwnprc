#include "prc_alterations"
#include "prgt_inc"
void main()
{
    object oPC = GetEnteringObject();
    object oTrap = OBJECT_SELF;
    if(!GetLocalInt(oPC, "InTrap"))
        AssignCommand(oPC, TrapPsuedoHB(oTrap));
    SetLocalInt(oPC, "InTrap", GetLocalInt(oPC, "InTrap")+1);
}
