void main()
{
    object oPC = GetPCSpeaker();
    int nOffset = GetLocalInt(oPC, "ChoiceOffset")+10;
    SetLocalInt(oPC, "ChoiceOffset", nOffset);
}

