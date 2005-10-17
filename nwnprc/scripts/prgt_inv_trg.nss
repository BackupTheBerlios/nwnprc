#include "prc_alterations"
#include "prgt_inc"
void main()
{
    if(DEBUG) DoDebug("prgt_inv_trg running");
    object oTrap = GetLocalObject(OBJECT_SELF, "Trap");
    if(GetTrapOneShot(OBJECT_SELF)){
        if(DEBUG) DoDebug("One shot - disarming trap");
        DisarmTrap(oTrap);
    }
    string sTriggerScript = GetLocalTrap(oTrap, "TrapSettings").sTriggerScript;
    object oPC = GetEnteringObject();
    if(DEBUG) DoDebug("sTriggerScript = '" + sTriggerScript + "'\noPC = '" + GetName(oPC) + "' - '" + GetTag(oPC) + "'");
    SetLocalObject(oTrap, "Target", oPC);
    ExecuteScript(sTriggerScript, oTrap);
    DoTrapXP(oTrap, oPC, TRAP_EVENT_TRIGGERED);
}
