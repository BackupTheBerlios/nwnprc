#include "prgt_inc"
void main()
{
    object oPC = GetEnteringObject();
    object oTrap = GetLocalObject(OBJECT_SELF, "Trap");
    if(!GetLocalInt(oPC, "InTrap"))
        AssignCommand(oPC, DetectPsuedoHB(oTrap));
    SetLocalInt(oPC, "InDetect", GetLocalInt(oPC, "InDetect")+1);
}
