/*
   ----------------
   Ectoplasmic Sheen
   
   prc_all_grease
   ----------------

   30/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Area: 10' square
   Duration: 1 Round/level
   Saving Throw: Reflex negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You create a pool of ectoplasm across the floor that inhibits motion and can cause people to slow down.
   This functions as the spell grease.
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
    int nAugCost = 2;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	object oTarget = GetSpellTargetObject();
	
    	//Declare major variables including Area of Effect Object
    	effect eAOE = EffectAreaOfEffect(AOE_PER_PSIGREASE);
    	location lTarget = GetSpellTargetLocation();
    	effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    	//Create an instance of the AOE Object using the Apply Effect function
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nCaster));
    }
    	
}