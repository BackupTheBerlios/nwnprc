/*
   ----------------
   Mind Blank
   
   prc_pow_psimndbk
   ----------------

   25/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 8
   Range: Close
   Target: One Creature
   Duration: 24 Hours
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 15
   
   The creature touched gains immunity to mind affecting spells and powers.
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
    object oTarget = GetSpellTargetObject();
    int nAugCost = 0;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);      
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
	int nDur = 24;
	if (nMetaPsi == 2)	nDur *= 2;
	
	//Massive effect linkage, go me
    	effect eMind = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    	effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eDur2 = EffectVisualEffect(249);
    	effect eLink = EffectLinkEffects(eMind, eDur);
    	eLink = EffectLinkEffects(eLink, eDur2);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDur),TRUE,-1,nCaster);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}