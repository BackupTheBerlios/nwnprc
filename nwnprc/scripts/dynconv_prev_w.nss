int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nOffset = GetLocalInt(oPC, "ChoiceOffset");
    if(nOffset >= 10)
        return TRUE;
    else
        return FALSE;
}
