#include "prc_psi_func"
#include "spinc_common"
#include "NW_I0_SPELLS"

void main()
{
    object oCaster = OBJECT_SELF;
    int nPP = GetLocalInt(oCaster, "PowerPoints");
    int nAugCost = 1;
    int nPPCost = GetPowerCost(oCaster, nAugCost);

    if (nPP >= nPPCost) 
    {
	nPP = nPP - nPPCost;
        FloatingTextStringOnCreature("Power Points Remaining: " + IntToString(nPP), oCaster, FALSE);
        SetLocalInt(oCaster, "PowerPoints", nPP);
	
	int nDC = GetManifesterDC(oCaster);
	object oTarget = GetSpellTargetObject();

                if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
                {
			FloatingTextStringOnCreature("Target has made its save vs " + IntToString(nDC), oCaster, FALSE);
                }
	        FloatingTextStringOnCreature("Target has failed its save " + IntToString(nDC), oCaster, FALSE);
    }
    else
    {
        FloatingTextStringOnCreature("You do not have enough Power Points remaining to cast this spell", oCaster, FALSE);	
    }

}