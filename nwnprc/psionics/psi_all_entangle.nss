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

#include "prc_inc_psifunc"
#include "prc_inc_psionic"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

    object oCaster = OBJECT_SELF;
    int nAugCost = 2;
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	nAugCost = 0;
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	object oTarget = GetSpellTargetObject();
	int nSize = GetCreatureSize(oTarget);
	int nAllowedSize = CREATURE_SIZE_MEDIUM;
	
	effect eSlow = EffectEntangle();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eSlow, eDur);
	effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
	
	
	if (nSurge > 0) nAugment = nSurge;
	
	//Augmentation effects to Size
	if (nAugment > 0) 
	{
		nAllowedSize += nAugment;
		//Max size of creature
		if (nAllowedSize > 5) nAllowedSize = 5;
	}
	
 	if(nSize <= nAllowedSize)
    	{
		
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nCaster))
		{
			
		    //Fire cast spell at event for the specified target
	            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	            
	                //Make a saving throw check
	                if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
	                {
	                        //Apply VFX Impact and daze effect
	                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (60.0 * nCaster),TRUE,-1,nCaster);
                		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	                }
		}
	}
    }
}