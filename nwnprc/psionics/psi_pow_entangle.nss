/*
   ----------------
   Entangling Ectoplasm
   
   prc_all_entangle
   ----------------

   30/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Target: One Medium or smaller Creature
   Duration: 5 Rounds
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You draw forth a glob of ectoplasmic goo from the Astral Plane and throw it at a creature
   as a ranged touch attack. On a succesful hit, the subject is covered in goo and becomes entangled.
   
   Augment: For every 2 additional power points spent, this power can affect a target
   that is one size larger.
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
	int nPen = GetPsiPenetration(oCaster);
	int nSize = GetCreatureSize(oTarget);
	int nAllowedSize = CREATURE_SIZE_MEDIUM;
	int nDur = 5;
	if (nMetaPsi == 2)	nDur *= 2;	
	
	effect eSlow = EffectEntangle();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eSlow, eDur);
	effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
	
	
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Size
	if (nAugment > 0) 
	{
		nAllowedSize += nAugment;
		//Max size of creature
		if (nAllowedSize > 5) nAllowedSize = 5;
	}
	
 	if(nSize <= nAllowedSize)
    	{
	    //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Apply VFX Impact and daze effect
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
	    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
    }
}