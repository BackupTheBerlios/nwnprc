#include "prc_alterations"
#include "prc_craft_inc"

void main()
{
    struct ipstruct iptemp = GetIpStructFromString("1_*_1_*");
    itemproperty ip = ConstructIP(iptemp.type, iptemp.subtype, iptemp.costtablevalue, iptemp.param1value);
    PrintString(GetItemPropertyString(ip));
    DoDebug("fs_test: starting");
    //DoDebug(GetItemPropertyString(ip));
    //object oPC = GetFirstPC();
    //DoDebug(IntToString(PRCGetHasSpell(368, oPC)));
    DoDebug("fs_test: ending");
}