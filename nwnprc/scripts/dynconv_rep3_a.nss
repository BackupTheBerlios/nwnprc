void main()
{
    object oPC = GetPCSpeaker();
    string sScript = GetLocalString(oPC, "DynConv_Script");
    SetLocalInt(oPC, "DynConv_Var", 4);
    ExecuteScript(sScript, OBJECT_SELF);
}

