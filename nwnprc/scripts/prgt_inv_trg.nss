#include "prgt_inc"
void main()
{
    object oTrap = GetLocalObject(OBJECT_SELF, "Trap");
    if(GetTrapOneShot(OBJECT_SELF))
        DisarmTrap(oTrap);
    string sTriggerScript = GetLocalString(oTrap, "TriggerScript");
    object oPC = GetLastUsedBy();
    SetLocalObject(oTrap, "Target", oPC);
    ExecuteScript(sTriggerScript, oTrap);
    DoTrapXP(oTrap, oPC, TRAP_EVENT_TRIGGERED);
}
