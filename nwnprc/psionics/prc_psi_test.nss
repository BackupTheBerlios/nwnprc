void main()
{
    object oCaster = OBJECT_SELF;
    int nPP = GetLocalInt(oCaster, "PowerPoints");
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nPPCost = 1;
    
    if (nAugment == 1) nPPCost = nPPCost + 1;
    if (nAugment == 2) nPPCost = nPPCost + 2;
    if (nAugment == 3) nPPCost = nPPCost + 3;
    if (nAugment == 4) nPPCost = nPPCost + 4;
    if (nAugment == 5) nPPCost = nPPCost + 5;

    if (nPP > nPPCost) 
    {
	nPP = nPP - nPPCost;
        FloatingTextStringOnCreature("Power Points Remaining: " + IntToString(nPP), oCaster, FALSE);
        SetLocalInt(oCaster, "PowerPoints", nPP);
    }
    else
    {
        FloatingTextStringOnCreature("You do not have enough Power Points remaining to cast this spell", oCaster, FALSE);	
    }

}