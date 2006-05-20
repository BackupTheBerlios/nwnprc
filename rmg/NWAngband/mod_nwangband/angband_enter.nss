void main()
{
    object oPC = GetEnteringObject();
    if(!GetIsPC(oPC))
        return;

    int nXP = 5*(5-1)*500;
    if(GetXP(oPC) < nXP)
        SetXP(oPC, nXP);
    int nGP = 9000;
    TakeGoldFromCreature(GetGold(oPC), oPC, TRUE);
    GiveGoldToCreature(oPC, nGP);

    if(GetLocalInt(OBJECT_SELF, "RunOnce"))
        return;
    SetLocalInt(OBJECT_SELF, "RunOnce", TRUE);
}
