
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if(GetLocalInt(oPC, "DynConv_Waiting"))
        return TRUE;
    return FALSE;
}
