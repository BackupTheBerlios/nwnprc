/*
   ----------------
   Ectoplasmic Shambler
   
   prc_pow_esham
   ----------------

   23/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 5
   Range: Long
   Area: Colossal
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 9
   
   You fashion an ephemeral mass of psedu-living ectoplasm called an ectoplasmic shambler. Anything caught within the shambler
   is blinded, and takes 1 point of damage for every 2 manifester levels of the caster.
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
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	float fDur = (nCaster * 60.0);
	if (nMetaPsi == 2)	fDur *= 2;	
		
    	//Declare major variables including Area of Effect Object
    	effect eAOE = EffectAreaOfEffect(AOE_PER_SHAMBLER);
    	location lTarget = GetSpellTargetLocation();
    	effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_MIND);
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    	//Create an instance of the AOE Object using the Apply Effect function
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDur);
    }
    	
}