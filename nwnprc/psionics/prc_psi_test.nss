void main()
{
    object oCaster = OBJECT_SELF;
    int nPP = GetLocalInt(oCaster, "PowerPoints");
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nPPCost = 1;
    int nAugCost = 1;

    if (nAugment == 0) nPPCost = nPPCost;    
    else if (nAugment == 1) nPPCost = nPPCost + (nAugCost * 1);
    else if (nAugment == 2) nPPCost = nPPCost + (nAugCost * 2);
    else if (nAugment == 3) nPPCost = nPPCost + (nAugCost * 3);
    else if (nAugment == 4) nPPCost = nPPCost + (nAugCost * 4);
    else if (nAugment == 5) nPPCost = nPPCost + (nAugCost * 5);

    if (nPP >= nPPCost) 
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