void main()
{
    object oPC = GetPCSpeaker();
    string sScript = GetLocalString(oPC, "DynConv_Script");
    SetLocalInt(oPC, "DynConv_Var", 7);
    ExecuteScript(sScript, OBJECT_SELF);
}

