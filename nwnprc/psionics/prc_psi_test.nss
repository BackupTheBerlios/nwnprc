#include "prc_inc_psifunc"
#include "prc_inc_psionic"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 1);

    object oCaster = OBJECT_SELF;
    int nAugCost = 1;
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	object oTarget = GetSpellTargetObject();
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, GetManifesterLevel(oCaster)))
	{
	FloatingTextStringOnCreature("Target has failed its Power Resistance Check", oCaster, FALSE);
		
		//Check saving throw
                if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
                {
			FloatingTextStringOnCreature("Target has made its save vs DC " + IntToString(nDC), oCaster, FALSE);
                }
		else
		{
		        FloatingTextStringOnCreature("Target has failed its save vs DC " + IntToString(nDC), oCaster, FALSE);
		}
	}
    }
}