#include "prc_alterations"
#include "prgt_inc"

void main()
{
    object oTrap = GetLocalObject(OBJECT_SELF, "Trap");
    DisarmTrap(oTrap);
    DoTrapXP(oTrap, GetLastDisarmed(), TRAP_EVENT_DISARMED);
}
