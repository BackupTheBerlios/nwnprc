#include "inc_dynconv"


void main()
{
    object oPC = GetPCSpeaker();
    string sScript = GetLocalString(oPC, DYNCONV_SCRIPT);
    SetLocalInt(oPC, "DynConv_Var", 2);
    ExecuteScript(sScript, OBJECT_SELF);
}

