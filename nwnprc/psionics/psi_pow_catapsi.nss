/*
   ----------------
   Catapsi
   
   prc_pow_catapsi
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
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oCaster = OBJECT_SELF;
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);    
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nDur = nCaster;
	if (nMetaPsi == 2)	nDur *= 2;	
		
    	//Declare major variables including Area of Effect Object
    	effect eAOE = EffectAreaOfEffect(AOE_MOB_CATAPSI);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, RoundsToSeconds(nDur));
    }
    	
}