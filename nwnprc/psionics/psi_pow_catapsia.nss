/*
   ----------------
   Catapsi, OnEnter
   
   prc_pow_catapsia
   ----------------

   27/3/05 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 5
   Range: Personal
   Area: 30' radius
   Duration: 1 Round/level
   Saving Throw: Will Negates
   Power Resistance: Yes
   Power Point Cost: 9
   
   By manifesting this power, you generate an aura of mental static, interfering with the ability of other psionic characters 
   to manifest their powers. All psionic powers cost 4 more points to manifest while in the area of the catapsi field. These 4 points
   count towards the manifester limit, reducing the powers other psions can cast. You are not affected by your own catapsi field.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
        object oTarget = GetEnteringObject();
	int nDC = GetManifesterDC(GetAreaOfEffectCreator());
	int nCaster = GetManifesterLevel(GetAreaOfEffectCreator());
	int nPen = GetPsiPenetration(GetAreaOfEffectCreator());
	
        //Check for Power Resistance
	if (PRCMyResistPower(GetAreaOfEffectCreator(), oTarget, nPen))
	{
		if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
		{
			if (oTarget != GetAreaOfEffectCreator())
			{
				SetLocalInt(oTarget, "Catapsi", TRUE);
				DelayCommand(6.0, DeleteLocalInt(oTarget, "Catapsi"));
			}
		}
	}   	
}