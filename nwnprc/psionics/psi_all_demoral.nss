/*
   ----------------
   Demoralize
   
   prc_all_demoral
   ----------------

   29/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: 30 ft
   Area: 30 ft radius centered on caster
   Duration: 1 Min/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You fill your enemies with self doubt. Any enemy in the area that fails its save becomes shaken.
   
   Augment: For every 2 additional power points spent, the DC on this power increases by 1.
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

	if (nSurge > 0) nAugment = nSurge;
	
	//Augmentation effects to Size
	if (nAugment > 0) 	nDC += nAugment;
	
	effect eLink = CreateDoomEffectsLink();
	effect eImpact = EffectVisualEffect(VFX_IMP_DOOM);
    	effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));

    	while(GetIsObjectValid(oTarget))
    	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
		{
			//Check for Power Resistance
			if (PRCMyResistPower(oCaster, oTarget, nCaster))
			{
					
			    //Fire cast spell at event for the specified target
		            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			            
		                //Make a saving throw check
		                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
		                {
		                        //Apply VFX Impact and daze effect
		                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (60.0 * nCaster),TRUE,-1,nCaster);
		               		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
		                }
			}
		}

        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    	}	
	
	

    }
}