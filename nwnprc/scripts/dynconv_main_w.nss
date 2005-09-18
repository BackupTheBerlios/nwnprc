#include "inc_dynconv"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if(GetLocalInt(oPC, "DynConv_Waiting"))
        return FALSE;
    string sScript = GetLocalString(oPC, DYNCONV_SCRIPT);
    SetLocalInt(oPC, "DynConv_Var", -1);
    ExecuteScript(sScript, OBJECT_SELF);
    if(GetLocalInt(oPC, "DynConv_Waiting"))
        return FALSE;
    return TRUE;
}
